/*=====================================================================================================================
                                    BUSINESS ANALYSIS

Project : Credit Card Approval Prediction

Objective:
Analyze how demographic and financial characteristics influence customer credit risk
using the engineered customer labels (Good / Bad).

=====================================================================================================================*/

/*=====================================================================================================================
1. DEMOGRAPHIC RISK ANALYSIS
=====================================================================================================================*/

/*---------------------------------------------------------------------------------------------------------------
1.1 Gender vs Customer Label
---------------------------------------------------------------------------------------------------------------*/

SELECT
    CODE_GENDER AS Gender,
    Customer_Label,
    COUNT(*) AS Customers,
    ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(PARTITION BY CODE_GENDER),2) AS Percentage
FROM final_customer_dataset
GROUP BY CODE_GENDER, Customer_Label
ORDER BY CODE_GENDER, Customer_Label;

/* Bad Rate by Gender */

SELECT
    CODE_GENDER AS Gender,
    COUNT(*) AS Total_Customers,
    SUM(Customer_Label='Bad') AS Bad_Customers,
    ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY CODE_GENDER;

/*---------------------------------------------------------------------------------------------------------------
1.2 Age Group vs Customer Label
---------------------------------------------------------------------------------------------------------------*/

SELECT
CASE
    WHEN ABS(DAYS_BIRTH)/365 <30 THEN '<30'
    WHEN ABS(DAYS_BIRTH)/365 <40 THEN '30-39'
    WHEN ABS(DAYS_BIRTH)/365 <50 THEN '40-49'
    WHEN ABS(DAYS_BIRTH)/365 <60 THEN '50-59'
    ELSE '60+'
END AS Age_Group,
Customer_Label,
COUNT(*) AS Customers,
ROUND(COUNT(*)*100/
SUM(COUNT(*)) OVER
(PARTITION BY
CASE
    WHEN ABS(DAYS_BIRTH)/365 <30 THEN '<30'
    WHEN ABS(DAYS_BIRTH)/365 <40 THEN '30-39'
    WHEN ABS(DAYS_BIRTH)/365 <50 THEN '40-49'
    WHEN ABS(DAYS_BIRTH)/365 <60 THEN '50-59'
    ELSE '60+'
END),2) AS Percentage
FROM final_customer_dataset
GROUP BY Age_Group, Customer_Label
ORDER BY Age_Group;

/* Bad Rate by Age Group */

SELECT
CASE
    WHEN ABS(DAYS_BIRTH)/365 <30 THEN '<30'
    WHEN ABS(DAYS_BIRTH)/365 <40 THEN '30-39'
    WHEN ABS(DAYS_BIRTH)/365 <50 THEN '40-49'
    WHEN ABS(DAYS_BIRTH)/365 <60 THEN '50-59'
    ELSE '60+'
END AS Age_Group,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY Age_Group
ORDER BY Age_Group;

/*---------------------------------------------------------------------------------------------------------------
1.3 Education Level
---------------------------------------------------------------------------------------------------------------*/

SELECT
NAME_EDUCATION_TYPE,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY NAME_EDUCATION_TYPE
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
1.4 Marital Status
---------------------------------------------------------------------------------------------------------------*/

SELECT
NAME_FAMILY_STATUS,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY NAME_FAMILY_STATUS
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
1.5 Housing Type
---------------------------------------------------------------------------------------------------------------*/

SELECT
NAME_HOUSING_TYPE,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY NAME_HOUSING_TYPE
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
1.6 Car Ownership
---------------------------------------------------------------------------------------------------------------*/

SELECT
FLAG_OWN_CAR,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY FLAG_OWN_CAR;

/*---------------------------------------------------------------------------------------------------------------
1.7 Property Ownership
---------------------------------------------------------------------------------------------------------------*/

SELECT
FLAG_OWN_REALTY,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY FLAG_OWN_REALTY;

/*=====================================================================================================================
2. FINANCIAL RISK ANALYSIS
=====================================================================================================================*/

/*---------------------------------------------------------------------------------------------------------------
2.1 Income Group
---------------------------------------------------------------------------------------------------------------*/

SELECT
CASE
    WHEN AMT_INCOME_TOTAL <100000 THEN '<100K'
    WHEN AMT_INCOME_TOTAL <200000 THEN '100K-200K'
    WHEN AMT_INCOME_TOTAL <500000 THEN '200K-500K'
    ELSE '>500K'
END AS Income_Group,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY Income_Group
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
2.2 Income Type
---------------------------------------------------------------------------------------------------------------*/

SELECT
NAME_INCOME_TYPE,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY NAME_INCOME_TYPE
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
2.3 Occupation
---------------------------------------------------------------------------------------------------------------*/

SELECT
COALESCE(OCCUPATION_TYPE,'Unknown') AS Occupation,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY Occupation
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
2.4 Employment Group
---------------------------------------------------------------------------------------------------------------*/

SELECT
CASE
    WHEN ABS(DAYS_EMPLOYED)/365 <5 THEN '<5 Years'
    WHEN ABS(DAYS_EMPLOYED)/365 <10 THEN '5-10 Years'
    WHEN ABS(DAYS_EMPLOYED)/365 <20 THEN '10-20 Years'
    WHEN ABS(DAYS_EMPLOYED)/365 <30 THEN '20-30 Years'
    ELSE '30+ Years'
END AS Employment_Group,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
WHERE DAYS_EMPLOYED IS NOT NULL
GROUP BY Employment_Group
ORDER BY Bad_Rate DESC;

/*---------------------------------------------------------------------------------------------------------------
2.5 Number of Children
---------------------------------------------------------------------------------------------------------------*/

SELECT
CNT_CHILDREN,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY CNT_CHILDREN
ORDER BY CNT_CHILDREN;

/*---------------------------------------------------------------------------------------------------------------
2.6 Family Members
---------------------------------------------------------------------------------------------------------------*/

SELECT
CNT_FAM_MEMBERS,
COUNT(*) AS Total_Customers,
SUM(Customer_Label='Bad') AS Bad_Customers,
ROUND(SUM(Customer_Label='Bad')*100/COUNT(*),2) AS Bad_Rate
FROM final_customer_dataset
GROUP BY CNT_FAM_MEMBERS
ORDER BY CNT_FAM_MEMBERS;

/*=====================================================================================================================
3. CREDIT SUMMARY
=====================================================================================================================*/

/* Average Credit History */

SELECT
Customer_Label,
ROUND(AVG(Months_Observed),2) AS Avg_Months_Observed,
ROUND(AVG(Total_Late_Months),2) AS Avg_Late_Months,
ROUND(AVG(Paid_On_Time),2) AS Avg_Paid_On_Time
FROM final_customer_dataset
GROUP BY Customer_Label;

/* Worst Status Distribution */

SELECT
Worst_Status,
COUNT(*) AS Customers
FROM final_customer_dataset
GROUP BY Worst_Status
ORDER BY Worst_Status;

/*=====================================================================================================================
END OF BUSINESS ANALYSIS
=====================================================================================================================*/