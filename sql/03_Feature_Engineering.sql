/*=====================================================================================================================
                            FEATURE ENGINEERING & CUSTOMER CREDIT SUMMARY

Project : Credit Card Approval Prediction

Objective:
Transform monthly credit records into customer-level features that can be merged with the
application dataset for customer-level credit risk analysis.

=====================================================================================================================*/

/*=====================================================================================================================
1. CUSTOMER CREDIT SUMMARY
=====================================================================================================================*/

DROP TABLE IF EXISTS customer_credit_summary;

CREATE TABLE customer_credit_summary AS
SELECT
    ID,
    /* Observation Period */
    COUNT(*) AS Months_Observed,
    /* Worst Repayment Status */
    MAX(
        CASE
            WHEN STATUS IN ('0','1','2','3','4','5')
            THEN CAST(STATUS AS UNSIGNED)
            ELSE NULL
        END
    ) AS Worst_Status,
    /* Monthly Status Counts */
    SUM(STATUS='0') AS Paid_On_Time,
    SUM(STATUS='1') AS Late_30_Days,
    SUM(STATUS='2') AS Late_60_Days,
    SUM(STATUS='3') AS Late_90_Days,
    SUM(STATUS='4') AS Late_120_Days,
    SUM(STATUS='5') AS Late_150Plus_Days,
    SUM(STATUS='C') AS Closed_Months,
    SUM(STATUS='X') AS No_Loan_Months,
    /* Total Delinquent Months */
    SUM(STATUS IN ('1','2','3','4','5')) AS Total_Late_Months
FROM credit_record
GROUP BY ID;

/*=====================================================================================================================
2. VERIFY CUSTOMER CREDIT SUMMARY
=====================================================================================================================*/


/* Number of Customers */
SELECT COUNT(*)
FROM customer_credit_summary;

/* Preview */
SELECT *
FROM customer_credit_summary
LIMIT 20;


/* Credit History Summary */
SELECT
MIN(Months_Observed),
MAX(Months_Observed),
ROUND(AVG(Months_Observed),2)
FROM customer_credit_summary;

/* Worst Status Distribution */
SELECT
Worst_Status,
COUNT(*) AS Customers
FROM customer_credit_summary
GROUP BY Worst_Status
ORDER BY Worst_Status;

/* Late Payment Summary */
SELECT
SUM(Paid_On_Time)      AS Paid_On_Time,
SUM(Late_30_Days)      AS Late_30,
SUM(Late_60_Days)      AS Late_60,
SUM(Late_90_Days)      AS Late_90,
SUM(Late_120_Days)     AS Late_120,
SUM(Late_150Plus_Days) AS Late_150Plus
FROM customer_credit_summary;

/*=====================================================================================================================
3. CUSTOMER LABEL
=====================================================================================================================*/

/*
Business Rule

Good Customer
-------------
Worst_Status = 0
OR
Worst_Status IS NULL

Bad Customer
------------
Worst_Status >= 1

*/


ALTER TABLE customer_credit_summary

ADD COLUMN Customer_Label VARCHAR(10);

UPDATE customer_credit_summary
SET Customer_Label =
CASE
WHEN Worst_Status >=1 THEN 'Bad'
ELSE 'Good'
END;

/* Label Distribution */
SELECT
Customer_Label,
COUNT(*) AS Customers,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM customer_credit_summary
GROUP BY Customer_Label;

/*=====================================================================================================================
4. CREATE FINAL CUSTOMER DATASET
=====================================================================================================================*/

DROP TABLE IF EXISTS final_customer_dataset;
CREATE TABLE final_customer_dataset AS
SELECT
a.*,
c.Months_Observed,
c.Worst_Status,
c.Paid_On_Time,
c.Late_30_Days,
c.Late_60_Days,
c.Late_90_Days,
c.Late_120_Days,
c.Late_150Plus_Days,
c.Total_Late_Months,
c.Closed_Months,
c.No_Loan_Months,
c.Customer_Label
FROM application_record a
INNER JOIN customer_credit_summary c
ON a.ID=c.ID;

/*=====================================================================================================================
5. VERIFY FINAL DATASET
=====================================================================================================================*/


SELECT COUNT(*)
FROM final_customer_dataset;

SELECT *
FROM final_customer_dataset
LIMIT 20;

/* Label Distribution */
SELECT
Customer_Label,
COUNT(*) AS Customers,
ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS Percentage
FROM final_customer_dataset
GROUP BY Customer_Label;

/*=====================================================================================================================
END OF FEATURE ENGINEERING
=====================================================================================================================*/