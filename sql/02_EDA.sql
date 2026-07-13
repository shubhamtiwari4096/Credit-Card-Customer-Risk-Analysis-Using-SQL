/*=====================================================================================================================
                                   EXPLORATORY DATA ANALYSIS (EDA)
=======================================================================================================================
Project : Credit Card Approval Prediction
Dataset : application_record & credit_record

Objective:
To understand the characteristics of applicants and their historical credit behaviour by
analyzing demographic, financial, and repayment-related attributes.

=====================================================================================================================*/


/*=====================================================================================================================
1. DATASET OVERVIEW
=====================================================================================================================*/

/* Total Applicant Records */

SELECT COUNT(*) AS Total_Applicants
FROM application_record;


/* Total Credit Records */

SELECT COUNT(*) AS Total_Credit_Records
FROM credit_record;


/* Unique Applicants */

SELECT COUNT(DISTINCT ID) AS Unique_Applicants
FROM application_record;


/* Unique Customers in Credit Dataset */

SELECT COUNT(DISTINCT ID) AS Unique_Customers
FROM credit_record;


/* Credit History Period */

SELECT
MIN(MONTHS_BALANCE) AS Earliest_Month,
MAX(MONTHS_BALANCE) AS Latest_Month
FROM credit_record;


/* Credit History Summary */

SELECT
MIN(Months_Observed) AS Minimum_Months,
MAX(Months_Observed) AS Maximum_Months,
ROUND(AVG(Months_Observed),2) AS Average_Months
FROM
(
SELECT
ID,
COUNT(*) AS Months_Observed
FROM credit_record
GROUP BY ID
)t;


/* Matching Customers */

SELECT
COUNT(DISTINCT a.ID) AS Matching_Customers
FROM application_record a
INNER JOIN credit_record c
ON a.ID=c.ID;


/*=====================================================================================================================
2. CUSTOMER DEMOGRAPHIC ANALYSIS
=====================================================================================================================*/


/* Gender Distribution */

SELECT
CODE_GENDER AS Gender,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY CODE_GENDER;


/* Average Age */

SELECT
ROUND(AVG(ABS(DAYS_BIRTH)/365),1) AS Average_Age
FROM application_record;


/* Youngest & Oldest Applicant */

SELECT
ROUND(MIN(ABS(DAYS_BIRTH)/365),1) AS Youngest,
ROUND(MAX(ABS(DAYS_BIRTH)/365),1) AS Oldest
FROM application_record;


/* Age Groups */

SELECT
CASE
WHEN ABS(DAYS_BIRTH)/365<30 THEN '<30'
WHEN ABS(DAYS_BIRTH)/365<40 THEN '30-39'
WHEN ABS(DAYS_BIRTH)/365<50 THEN '40-49'
WHEN ABS(DAYS_BIRTH)/365<60 THEN '50-59'
ELSE '60+'
END AS Age_Group,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY Age_Group
ORDER BY Age_Group;


/* Education */

SELECT
NAME_EDUCATION_TYPE AS Education_Level,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY NAME_EDUCATION_TYPE
ORDER BY Applicants DESC;


/* Marital Status */

SELECT
NAME_FAMILY_STATUS AS Marital_Status,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY NAME_FAMILY_STATUS
ORDER BY Applicants DESC;


/* Housing Type */

SELECT
NAME_HOUSING_TYPE AS Housing_Type,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY NAME_HOUSING_TYPE
ORDER BY Applicants DESC;


/* Car Ownership */

SELECT
FLAG_OWN_CAR AS Owns_Car,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY FLAG_OWN_CAR;


/* Property Ownership */

SELECT
FLAG_OWN_REALTY AS Owns_Property,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY FLAG_OWN_REALTY;


/*=====================================================================================================================
3. FINANCIAL PROFILE ANALYSIS
=====================================================================================================================*/


/* Income Statistics */

SELECT
MIN(AMT_INCOME_TOTAL) AS Minimum_Income,
MAX(AMT_INCOME_TOTAL) AS Maximum_Income,
ROUND(AVG(AMT_INCOME_TOTAL),2) AS Average_Income
FROM application_record;


/* Income Distribution */

SELECT
CASE
WHEN AMT_INCOME_TOTAL<100000 THEN '<100K'
WHEN AMT_INCOME_TOTAL<200000 THEN '100K-200K'
WHEN AMT_INCOME_TOTAL<500000 THEN '200K-500K'
ELSE '>500K'
END AS Income_Group,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY Income_Group
ORDER BY Applicants DESC;


/* Highest Income Values */

SELECT
AMT_INCOME_TOTAL,
COUNT(*) AS Applicants
FROM application_record
GROUP BY AMT_INCOME_TOTAL
ORDER BY AMT_INCOME_TOTAL DESC
LIMIT 10;


/* Income Type */

SELECT
NAME_INCOME_TYPE AS Income_Type,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY NAME_INCOME_TYPE
ORDER BY Applicants DESC;


/* Occupation */

SELECT
COALESCE(OCCUPATION_TYPE,'Unknown') AS Occupation,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY Occupation
ORDER BY Applicants DESC;


/* Average Employment */

SELECT
ROUND(AVG(ABS(DAYS_EMPLOYED))/365,2) AS Average_Employment_Years
FROM application_record;


/* Employment Groups */

SELECT
CASE
WHEN ABS(DAYS_EMPLOYED)/365<5 THEN '<5 Years'
WHEN ABS(DAYS_EMPLOYED)/365<10 THEN '5-10 Years'
WHEN ABS(DAYS_EMPLOYED)/365<20 THEN '10-20 Years'
WHEN ABS(DAYS_EMPLOYED)/365<30 THEN '20-30 Years'
ELSE '30+ Years'
END AS Employment_Group,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
WHERE DAYS_EMPLOYED IS NOT NULL
GROUP BY Employment_Group
ORDER BY Applicants DESC;


/* Number of Children */

SELECT
CNT_CHILDREN,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY CNT_CHILDREN
ORDER BY CNT_CHILDREN;


/* Family Members */

SELECT
CNT_FAM_MEMBERS,
COUNT(*) AS Applicants,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM application_record
GROUP BY CNT_FAM_MEMBERS
ORDER BY CNT_FAM_MEMBERS;


/*=====================================================================================================================
4. CREDIT BEHAVIOUR ANALYSIS
=====================================================================================================================*/


/* Credit Status Distribution */

SELECT
STATUS,
COUNT(*) AS Records,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM credit_record
GROUP BY STATUS
ORDER BY STATUS;


/* Customers by Credit Status */

SELECT
STATUS,
COUNT(DISTINCT ID) AS Customers,
ROUND(
COUNT(DISTINCT ID)*100/
(SELECT COUNT(DISTINCT ID) FROM credit_record),2
) AS Percentage
FROM credit_record
GROUP BY STATUS
ORDER BY STATUS;


/* Months Observed per Customer */

SELECT
ID,
COUNT(*) AS Months_Observed
FROM credit_record
GROUP BY ID
ORDER BY ID;


/* Credit History Summary */

SELECT
MIN(Months_Observed) AS Minimum_Months,
MAX(Months_Observed) AS Maximum_Months,
ROUND(AVG(Months_Observed),2) AS Average_Months
FROM
(
SELECT
ID,
COUNT(*) AS Months_Observed
FROM credit_record
GROUP BY ID
)t;


/* Credit History Groups */

SELECT
CASE
WHEN Months_Observed<12 THEN '<12 Months'
WHEN Months_Observed<24 THEN '12-23 Months'
WHEN Months_Observed<36 THEN '24-35 Months'
WHEN Months_Observed<48 THEN '36-47 Months'
ELSE '48+ Months'
END AS History_Group,
COUNT(*) AS Customers,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM
(
SELECT
ID,
COUNT(*) AS Months_Observed
FROM credit_record
GROUP BY ID
)t
GROUP BY History_Group
ORDER BY Customers DESC;


/* Repayment Status */

SELECT
CASE
WHEN STATUS='X' THEN 'No Loan'
WHEN STATUS='C' THEN 'Closed'
WHEN STATUS='0' THEN 'Paid on Time'
WHEN STATUS='1' THEN '30 Days Overdue'
WHEN STATUS='2' THEN '60 Days Overdue'
WHEN STATUS='3' THEN '90 Days Overdue'
WHEN STATUS='4' THEN '120 Days Overdue'
WHEN STATUS='5' THEN '150+ Days Overdue'
END AS Repayment_Status,
COUNT(*) AS Records,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM credit_record
GROUP BY Repayment_Status
ORDER BY Records DESC;


/*=====================================================================================================================
                                       END OF EXPLORATORY DATA ANALYSIS
=====================================================================================================================*/