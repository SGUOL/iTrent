#Export to iTrent
#May need to install Windows PowerShell Extensions for SQL Server
#and then run
#Add-PSSnapin SqlServerCmdletSnapin100
#Add-PSSnapin SqlServerProviderSnapin100

    #,("SELECT * FROM dbo.iT90_12_01_01_Agresso_Number ORDER BY PER_REF_NO","iT90_12_01_01_Agresso_Number") `
    #,("SELECT * FROM dbo.iT90_3_1_1_Left_People_For_Agresso_Number ORDER BY PER_REF_NO","iT90_3_1_1_Left_People_For_Agresso_Number") `
    #,("SELECT * FROM dbo.iT99_11_02_Probationary_Periods ORDER BY PER_REF_NO","iT99_11_02_Probationary_Periods")
    #,("SELECT * FROM dbo.iT99_12_01_01_Next_Of_Kin ORDER BY PER_REF_NO","iT99_12_01_01_Next_Of_Kin") `
    #,("SELECT * FROM dbo.iT99_12_01_01_Work_Permits ORDER BY PER_REF_NO","iT99_12_01_01_Work_Permits") `

$QF = (
    ("SELECT * FROM dbo.iT01_00_Organisation_Structure","iT01_00_Organisation_Structure") `
    ,("SELECT * FROM dbo.iT_HESA_Personal_Details","iT_HESA_Personal_Details") `
    ,("SELECT * FROM dbo.iT03_00_People ORDER BY PER_REF_NO","iT03_00_People") `
    ,("SELECT * FROM dbo.iT03_01_Personal_Detail_Changes ORDER BY PER_REF_NO","iT03_01_Personal_Detail_Changes") `
    ,("SELECT * FROM dbo.iT04_00_Emergency_Contact ORDER BY PER_REF_NO","iT04_00_Emergency_Contact") `
    ,("SELECT * FROM dbo.iT05_00_Personal_Contacts ORDER BY PER_REF_NO","iT05_00_Personal_Contacts") `
    ,("SELECT * FROM dbo.iT06_01_AttachEmployees2Structure ORDER BY PER_REF_NO","iT06_01_AttachEmployees2Structure") `
    ,("SELECT * FROM dbo.iT06_02_Create_Leaver_Positions_from_Post ORDER BY PER_REF_NO","iT06_02_Create_Leaver_Positions_from_Post") `
    ,("SELECT * FROM dbo.iT07_00_Payroll ORDER BY PER_REF_NO","iT07_00_Payroll") `
    ,("SELECT * FROM dbo.iT08_00_StudentLoans ORDER BY PER_REF_NO","iT08_00_StudentLoans") `
    ,("SELECT * FROM dbo.iT09_00_Work_Patterns ORDER BY PATTERN_NAME, PATTERN_DAY_NUMBER","iT09_00_Work_Patterns") `
    ,("SELECT * FROM dbo.iT10_03_Annual_Salary_Payscale_with_Grade ORDER BY PER_REF_NO","iT10_03_Annual_Salary_Payscale_with_Grade") `
    ,("SELECT * FROM dbo.iT11_01_FTE_Hours ORDER BY PER_REF_NO","iT11_01_FTE_Hours") `
    ,("SELECT * FROM dbo.iT11_02_Contractual_Hours ORDER BY PER_REF_NO","iT11_02_Contractual_Hours") `
    ,("SELECT * FROM dbo.iT11_03_Annual_Weeks_Worked_DoWeREALLYNeed ORDER BY PER_REF_NO","iT11_03_Annual_Weeks_Worked_DoWeREALLYNeed") `
    ,("SELECT * FROM dbo.iT12_00_Inheritance_Work_Patterns ORDER BY PER_REF_NO, VALUE2","iT12_00_Inheritance_Work_Patterns") `
    ,("SELECT * FROM dbo.iT15_01_Employment_Basis ORDER BY PER_REF_NO","iT15_01_Employment_Basis") `
    ,("SELECT * FROM dbo.iT15_02_Employment_Category ORDER BY PER_REF_NO","iT15_02_Employment_Category") `
    ,("SELECT * FROM dbo.iT15_03_Employment_Type ORDER BY PER_REF_NO","iT15_03_Employment_Type") `
    ,("SELECT * FROM dbo.iT18_00_Inheritance_Irregular_Employment ORDER BY PER_REF_NO","iT18_00_Inheritance_Irregular_Employment") `
    ,("SELECT * FROM dbo.iT19_00_Inheritance_Pension_Schemes ORDER BY PER_REF_NO","iT19_00_Inheritance_Pension_Schemes") `
    ,("SELECT * FROM dbo.iT19_01_Inheritance_AVCs ORDER BY PER_REF_NO","iT19_01_Inheritance_AVCs") `
    ,("SELECT * FROM dbo.iT20_00_Pension_Rates_and_Membership_Details ORDER BY PER_REF_NO","iT20_00_Pension_Rates_and_Membership_Details") `
    ,("SELECT * FROM dbo.iT23_00_Time_and_Attendance ORDER BY PER_REF_NO","iT23_00_Time_and_Attendance") `
    ,("SELECT * FROM dbo.iT24_00_Reporting_Managers ORDER BY PER_REF_NO","iT24_00_Reporting_Managers") `
    ,("SELECT * FROM dbo.iT25_01_Taxable_Pay ORDER BY PER_REF_NO","iT25_01_Taxable_Pay") `
    ,("SELECT * FROM dbo.iT25_02_Tax ORDER BY PER_REF_NO","iT25_02_Tax") `
    ,("SELECT * FROM dbo.iT25_03_Student_Loans ORDER BY PER_REF_NO","iT25_03_Student_Loans") `
    ,("SELECT * FROM dbo.iT25_04_National_Insurance_Employee_Contributions ORDER BY PER_REF_NO","iT25_04_National_Insurance_Employee_Contributions") `
    ,("SELECT * FROM dbo.iT25_05_National_Insurance_Employer_Contributions ORDER BY PER_REF_NO","iT25_05_National_Insurance_Employer_Contributions") `
    ,("SELECT * FROM dbo.iT25_06_Niable_Pay ORDER BY PER_REF_NO","iT25_06_Niable_Pay") `
    ,("SELECT * FROM dbo.iT25_07_National_Insurance_to_LEL ORDER BY PER_REF_NO","iT25_07_National_Insurance_to_LEL") `
    ,("SELECT * FROM dbo.iT25_08_National_Insurance_to_ET ORDER BY PER_REF_NO","iT25_08_National_Insurance_to_ET") `
    ,("SELECT * FROM dbo.iT25_09_National_Insurance_to_UEL ORDER BY PER_REF_NO","iT25_09_National_Insurance_to_UEL") `
    ,("SELECT * FROM dbo.iT25_10_Pension_Employee_Contributions ORDER BY PER_REF_NO","iT25_10_Pension_Employee_Contributions") `
    ,("SELECT * FROM dbo.iT25_11_Pension_Employer_Contributions ORDER BY PER_REF_NO","iT25_11_Pension_Employer_Contributions") `
    ,("SELECT * FROM dbo.iT25_12_Pensionable_Pay ORDER BY PER_REF_NO","iT25_12_Pensionable_Pay") `
    ,("SELECT * FROM dbo.iT25_13_AVC_Employee_Contributions ORDER BY PER_REF_NO","iT25_13_AVC_Employee_Contributions") `
    ,("SELECT * FROM dbo.iT26_00_Leaver_Details ORDER BY PER_REF_NO","iT26_00_Leaver_Details") `
    ,("SELECT * FROM dbo.iT99_12_01_01_Agresso_Number ORDER BY PER_REF_NO","iT99_12_01_01_Agresso_Number") `
    ,("SELECT * FROM dbo.iT99_12_01_01_HESA_Return ORDER BY PER_REF_NO","iT99_12_01_01_HESA_Return") `
    ,("SELECT * FROM dbo.iT99_4_8_1_Fixed_Term_End_Dates ORDER BY PER_REF_NO","iT99_4_8_1_Fixed_Term_End_Dates") `
    )

For ($i=0; $i -lt $QF.Length; $i++)
{
	$Query = $QF[$i][0]
	$File = $QF[$i][1]

    echo $File
	Invoke-Sqlcmd -ServerInstance HRA2 -Database iTLoads -Query "$Query" |
		Export-CSV -Path  "T:\CSVFiles\$File.csv" -NoTypeInformation
	Invoke-Sqlcmd -ServerInstance HRA2 -Database iTLoads -Query "$Query" |
		ConvertTo-Csv -Delimiter '|' -NoTypeInformation | % {$_ -replace '"',''} |
		Out-File -Encoding ASCII "T:\PipeDelimitedFiles\$File.txt"
}

