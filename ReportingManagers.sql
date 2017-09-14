WITH CurrentPeople
AS
(
	SELECT EMP_NO
	FROM dbo.PERSON P
	WHERE LEN(P.EMP_NO) < 7
		AND P.PERSON_STATUS NOT LIKE 'L%'
)
,Hierarchy
AS
(
	SELECT H.emp_no, H.reports_to_emp_no
	FROM temp_hierarchy_final H
		JOIN CurrentPeople E
			ON H.emp_no = E.EMP_NO
		JOIN CurrentPeople R
			ON H.reports_to_emp_no = R.EMP_NO
	WHERE H.IS_MASTER = 'Y'
)
,EmpPosRef
AS
(
	SELECT *
		,ROW_NUMBER() OVER (PARTITION BY EMP_NO ORDER BY iTrentPositionRef) AS rn
	FROM iTLoads.dbo.EMP_NO_X_POS_REF
)
,CoreEmployees
AS
(
	SELECT P.EMP_NO, P.SURNAME, P.FORENAMES
		,ROW_NUMBER() OVER (PARTITION BY P.EMP_NO ORDER BY D.IS_MASTER DESC) AS rn
	FROM dbo.PERSON P
		JOIN dbo.APPOINTMENTS A
			ON P.EMP_NO = A.EMP_NO
		JOIN dbo.CONTRACT_DETAILS D
			ON A.EMP_NO = D.EMP_NO
				AND A.CONTRACT_NO = D.CONTRACT_NO
				AND D.IS_MASTER = 'Y'
	WHERE P.PERSON_STATUS NOT LIKE 'L%'
		AND A.BASIC_PAY > 0
		AND
		(
			A.CURRENT_INDICATOR IN ('C','L')
			OR
			(
				A.CURRENT_INDICATOR = 'J'
				AND
				(
					NOT EXISTS
					(
							SELECT 1
							FROM dbo.APPOINTMENTS A1
							WHERE A1.EMP_NO = A.EMP_NO
								AND A1.CURRENT_INDICATOR = 'C'		
					)
					OR A.CHANGE_DATE <= CURRENT_TIMESTAMP
				)
			)
		)
		AND EXISTS
		(
			SELECT 1
			FROM dbo.REFNO RN
			WHERE RN.PAYROLL_EMP_NO = P.EMP_NO
				AND RN.PAY_GROUP = 'MTH'
		)
)
-- Missing Core Employees
SELECT C.EMP_NO, C.SURNAME, C.FORENAMES
FROM CoreEmployees C
	LEFT JOIN
	(
		 Hierarchy H
			JOIN EmpPosRef E
				ON H.emp_no = E.EMP_NO
					AND E.rn = 1
			JOIN EmpPosRef R
				ON H.reports_to_emp_no = R.EMP_NO
					AND R.rn = 1
	)
		ON C.EMP_NO = H.emp_no
WHERE C.rn = 1
	and H.emp_no is null

