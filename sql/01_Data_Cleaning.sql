/*=========================================================
            DATA QUALITY ASSESSMENT & DATA CLEANING
===========================================================
Project : Credit Card Approval Prediction
===========================================================
Objective:
Before performing Exploratory Data Analysis (EDA), the datasets
were assessed to identify duplicate records, missing values,
invalid values, placeholder values, and abnormal observations
that could affect analysis.

Datasets:
1. application_record
2. credit_record

===========================================================
A. DUPLICATE RECORD CHECK
===========================================================*/

/*---------------------------------------------------------
A.1 Duplicate Check - credit_record

Objective:
To ensure each customer's monthly credit record is unique.

Result:
No duplicate records were found.

Action:
No cleaning required.
---------------------------------------------------------*/

WITH Duplicate_Check AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY ID, MONTHS_BALANCE, STATUS
           ) AS RN
    FROM credit_record
)
SELECT *
FROM Duplicate_Check
WHERE RN > 1;



/*---------------------------------------------------------
A.2 Duplicate Check - application_record

Objective:
To ensure no duplicate applicant records exist.

Result:
No duplicate records were found.

Action:
No cleaning required.
---------------------------------------------------------*/

WITH Duplicate_Check AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY
                   ID,
                   CODE_GENDER,
                   FLAG_OWN_CAR,
                   FLAG_OWN_REALTY,
                   CNT_CHILDREN,
                   AMT_INCOME_TOTAL,
                   NAME_INCOME_TYPE,
                   NAME_EDUCATION_TYPE,
                   NAME_FAMILY_STATUS,
                   NAME_HOUSING_TYPE,
                   DAYS_BIRTH,
                   DAYS_EMPLOYED,
                   FLAG_MOBIL,
                   FLAG_WORK_PHONE,
                   FLAG_PHONE,
                   FLAG_EMAIL,
                   OCCUPATION_TYPE,
                   CNT_FAM_MEMBERS
           ) AS RN
    FROM application_record
)
SELECT *
FROM Duplicate_Check
WHERE RN > 1;



/*=========================================================
B. NULL VALUE CHECK
===========================================================

Objective:
To determine whether missing values exist in either dataset.

=========================================================*/


/*---------------------------------------------------------
B.1 credit_record
---------------------------------------------------------*/

SELECT
    SUM(ID IS NULL) AS ID,
    SUM(MONTHS_BALANCE IS NULL) AS MONTHS_BALANCE,
    SUM(STATUS IS NULL) AS STATUS
FROM credit_record;

/*
Findings:
No NULL values were found.

Action:
No cleaning required.
*/


/*---------------------------------------------------------
B.2 application_record
---------------------------------------------------------*/

SELECT
    SUM(ID IS NULL) AS ID,
    SUM(CODE_GENDER IS NULL) AS CODE_GENDER,
    SUM(FLAG_OWN_CAR IS NULL) AS FLAG_OWN_CAR,
    SUM(FLAG_OWN_REALTY IS NULL) AS FLAG_OWN_REALTY,
    SUM(CNT_CHILDREN IS NULL) AS CNT_CHILDREN,
    SUM(AMT_INCOME_TOTAL IS NULL) AS AMT_INCOME_TOTAL,
    SUM(NAME_INCOME_TYPE IS NULL) AS NAME_INCOME_TYPE,
    SUM(NAME_EDUCATION_TYPE IS NULL) AS NAME_EDUCATION_TYPE,
    SUM(NAME_FAMILY_STATUS IS NULL) AS NAME_FAMILY_STATUS,
    SUM(NAME_HOUSING_TYPE IS NULL) AS NAME_HOUSING_TYPE,
    SUM(DAYS_BIRTH IS NULL) AS DAYS_BIRTH,
    SUM(DAYS_EMPLOYED IS NULL) AS DAYS_EMPLOYED,
    SUM(FLAG_MOBIL IS NULL) AS FLAG_MOBIL,
    SUM(FLAG_WORK_PHONE IS NULL) AS FLAG_WORK_PHONE,
    SUM(FLAG_PHONE IS NULL) AS FLAG_PHONE,
    SUM(FLAG_EMAIL IS NULL) AS FLAG_EMAIL,
    SUM(OCCUPATION_TYPE IS NULL) AS OCCUPATION_TYPE,
    SUM(CNT_FAM_MEMBERS IS NULL) AS CNT_FAM_MEMBERS
FROM application_record;

/*
Findings:
No NULL values were found.

Action:
No cleaning required.
*/



/*=========================================================
C. DOMAIN VALIDATION
===========================================================

Objective:
To validate all categorical variables and ensure that only
valid categories exist.

=========================================================*/


SELECT CODE_GENDER, COUNT(*) AS Total
FROM application_record
GROUP BY CODE_GENDER;

SELECT FLAG_OWN_CAR, COUNT(*) AS Total
FROM application_record
GROUP BY FLAG_OWN_CAR;

SELECT FLAG_OWN_REALTY, COUNT(*) AS Total
FROM application_record
GROUP BY FLAG_OWN_REALTY;

SELECT NAME_INCOME_TYPE, COUNT(*) AS Total
FROM application_record
GROUP BY NAME_INCOME_TYPE;

SELECT NAME_EDUCATION_TYPE, COUNT(*) AS Total
FROM application_record
GROUP BY NAME_EDUCATION_TYPE;

SELECT NAME_FAMILY_STATUS, COUNT(*) AS Total
FROM application_record
GROUP BY NAME_FAMILY_STATUS;

SELECT NAME_HOUSING_TYPE, COUNT(*) AS Total
FROM application_record
GROUP BY NAME_HOUSING_TYPE;

SELECT OCCUPATION_TYPE, COUNT(*) AS Total
FROM application_record
GROUP BY OCCUPATION_TYPE;

SELECT FLAG_MOBIL, COUNT(*) AS Total
FROM application_record
GROUP BY FLAG_MOBIL;

SELECT FLAG_PHONE, COUNT(*) AS Total
FROM application_record
GROUP BY FLAG_PHONE;

SELECT FLAG_EMAIL, COUNT(*) AS Total
FROM application_record
GROUP BY FLAG_EMAIL;

SELECT FLAG_WORK_PHONE, COUNT(*) AS Total
FROM application_record
GROUP BY FLAG_WORK_PHONE;

SELECT STATUS, COUNT(*) AS Total
FROM credit_record
GROUP BY STATUS;

/*
Findings:

• All categorical variables contained valid values.

• No unexpected categories were identified.

• Blank values were observed only in OCCUPATION_TYPE.

*/



/*=========================================================
D. NUMERICAL VARIABLE VALIDATION
===========================================================

Objective:
To identify impossible values, placeholder values,
and abnormal observations before analysis.

=========================================================*/


/*---------------------------------------------------------
D.1 Annual Income (AMT_INCOME_TOTAL)
---------------------------------------------------------*/

SELECT
    MIN(AMT_INCOME_TOTAL),
    MAX(AMT_INCOME_TOTAL),
    AVG(AMT_INCOME_TOTAL)
FROM application_record;

SELECT
    AMT_INCOME_TOTAL,
    COUNT(*) AS Frequency
FROM application_record
GROUP BY AMT_INCOME_TOTAL
ORDER BY AMT_INCOME_TOTAL DESC;

/*
Findings:

Minimum Income  : 26,100

Maximum Income  : 6,750,000

Average Income  : ~187,525

Although the distribution is right-skewed,
all observed values are plausible for a banking dataset.

No evidence of invalid income values was found.

Action:
No cleaning required.
*/



/*---------------------------------------------------------
D.2 Occupation Type
---------------------------------------------------------*/

SELECT *
FROM application_record
WHERE OCCUPATION_TYPE = '';

SELECT
    NAME_INCOME_TYPE,
    COUNT(*) AS Total,
    SUM(OCCUPATION_TYPE = '') AS Missing_Occupation
FROM application_record
GROUP BY NAME_INCOME_TYPE;

SELECT
    OCCUPATION_TYPE,
    COUNT(*) AS Frequency
FROM application_record
GROUP BY OCCUPATION_TYPE;

/*
Findings:

134,193 records contained blank occupation values.

Further investigation revealed:

• Nearly all Pensioners had blank occupations.
• Approximately 16–17% of Working,
  Commercial Associate and State Servant applicants
  also had blank occupations.

Since an empty string does not represent
a valid occupation, it was treated as missing data.

Cleaning Performed:
*/

UPDATE application_record
SET OCCUPATION_TYPE = NULL
WHERE OCCUPATION_TYPE = '';



/*---------------------------------------------------------
D.3 Employment Duration (DAYS_EMPLOYED)
---------------------------------------------------------*/

SELECT
    MIN(DAYS_EMPLOYED),
    MAX(DAYS_EMPLOYED),
    AVG(DAYS_EMPLOYED)
FROM application_record;

SELECT
    COUNT(*) AS Placeholder_Count
FROM application_record
WHERE DAYS_EMPLOYED = 365243;

SELECT
    DAYS_EMPLOYED,
    COUNT(*) AS Frequency
FROM application_record
GROUP BY DAYS_EMPLOYED
ORDER BY DAYS_EMPLOYED DESC;

/*
Findings:

Minimum Employment Days : -17,531

Maximum Employment Days : 365,243

Average Employment Days : 60,566

365243 appeared in 75,324 records.

Since 365243 represents approximately
1000 years of employment,
it was identified as a placeholder value,
not a valid employment duration.

Cleaning Performed:
*/

UPDATE application_record
SET DAYS_EMPLOYED = NULL
WHERE DAYS_EMPLOYED = 365243;



/*---------------------------------------------------------
D.4 Number of Children
---------------------------------------------------------*/

SELECT
    MIN(CNT_CHILDREN),
    MAX(CNT_CHILDREN),
    AVG(CNT_CHILDREN)
FROM application_record;

SELECT
    CNT_CHILDREN,
    COUNT(*) AS Frequency
FROM application_record
GROUP BY CNT_CHILDREN
ORDER BY CNT_CHILDREN DESC;

/*
Findings:

Minimum Children : 0

Maximum Children : 19

Average Children : 0.43

Although very high values exist,
they are rare but still logically possible.

Action:
No cleaning required.
*/



/*---------------------------------------------------------
D.5 Family Members
---------------------------------------------------------*/

SELECT
    MIN(CNT_FAM_MEMBERS),
    MAX(CNT_FAM_MEMBERS),
    AVG(CNT_FAM_MEMBERS)
FROM application_record;

SELECT
    CNT_FAM_MEMBERS,
    COUNT(*) AS Frequency
FROM application_record
GROUP BY CNT_FAM_MEMBERS
ORDER BY CNT_FAM_MEMBERS DESC;

/*
Findings:

Minimum Family Members : 1

Maximum Family Members : 20

Average Family Members : 2.19

Although very high family sizes exist,
they are rare but still possible.

Action:
No cleaning required.
*/



/*---------------------------------------------------------
(Optional Consistency Check)

Objective:
A family cannot have fewer members than
the applicant plus the number of children.

---------------------------------------------------------*/

SELECT *
FROM application_record
WHERE CNT_FAM_MEMBERS < CNT_CHILDREN + 1;

/*
Expected Result:
Zero rows.

If rows are returned,
those records require further investigation.
*/



/*=========================================================
FINAL DATA CLEANING SUMMARY
===========================================================

Duplicate Records
-----------------
No duplicate records found.

NULL Values
-----------
No NULL values found in either dataset.

Occupation Type
---------------
134,193 blank values identified.
Blank strings were standardized to NULL.

Days Employed
-------------
75,324 records contained the placeholder value 365243.
The placeholder was converted to NULL.

Annual Income
-------------
Income ranged from 26,100 to 6,750,000.
No invalid values were identified.
No cleaning performed.

Children
---------
Range: 0–19.
Extreme values were rare but logically possible.
No cleaning performed.

Family Members
--------------
Range: 1–20.
Extreme values were rare but logically possible.
No cleaning performed.

Overall Cleaning Performed
--------------------------
1. Converted blank OCCUPATION_TYPE values to NULL.
2. Converted placeholder value (365243) in DAYS_EMPLOYED to NULL.
3. Retained all other values because no evidence of invalid data was found.

The dataset is now suitable for Exploratory Data Analysis (EDA).

=========================================================*/