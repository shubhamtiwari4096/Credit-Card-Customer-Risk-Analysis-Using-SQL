# Credit Card Customer Risk Analysis Using SQL

## Project Overview

This project demonstrates an end-to-end SQL workflow for customer credit risk analysis using relational databases. The project covers data cleaning, exploratory data analysis (EDA), feature engineering, customer-level dataset construction, and business analysis using SQL.

The original dataset consists of applicant demographic information and monthly credit repayment records. Since no predefined target variable is provided, customer risk labels were engineered from historical repayment behavior, enabling customer-level risk analysis.

---

## Business Problem

Financial institutions evaluate customer creditworthiness before issuing credit products. Historical repayment behavior, combined with demographic and financial information, provides valuable insights into customer risk.

The objective of this project is to transform raw transactional credit history into an analytical customer dataset and identify customer segments associated with higher repayment risk using SQL.

---

## Project Objectives

- Clean and validate raw customer data.
- Explore applicant demographics and financial characteristics.
- Analyze historical credit repayment behavior.
- Engineer customer-level behavioral features.
- Construct customer risk labels from repayment history.
- Identify business patterns associated with higher customer risk.

---

## Dataset

**Dataset:** Credit Card Approval Prediction

**Source:** Kaggle

The project uses two relational tables linked through the **ID** column.

### application_record

Contains applicant information including:

- Gender
- Age
- Annual Income
- Occupation
- Employment Duration
- Education Level
- Marital Status
- Housing Type
- Number of Children
- Family Members
- Car Ownership
- Property Ownership

### credit_record

Contains monthly customer credit repayment history.

Repayment status values:

| Status | Description |
|---------|-------------|
| X | No loan during the month |
| C | Loan closed |
| 0 | Paid on time |
| 1 | 30 days overdue |
| 2 | 60 days overdue |
| 3 | 90 days overdue |
| 4 | 120 days overdue |
| 5 | More than 150 days overdue |

---

## Technologies Used

- MySQL 8
- SQL
- Git
- GitHub

---

## Repository Structure

```
Credit-Card-Customer-Risk-Analysis-Using-SQL

│
├── data
│   ├── application_record.csv
│   └── credit_record.csv
│
├── sql
│   ├── 01_Data_Cleaning.sql
│   ├── 02_EDA.sql
│   ├── 03_Feature_Engineering.sql
│   └── 04_Business_Analysis.sql
│
├── README.md
└── LICENSE
```

---

## Project Workflow

```
Raw Data
     │
     ▼
Data Cleaning
     │
     ▼
Exploratory Data Analysis
     │
     ▼
Feature Engineering
     │
     ▼
Customer-Level Dataset Construction
     │
     ▼
Business Analysis
```

---

## Phase 1 – Data Cleaning

The data cleaning process ensured consistency and reliability before analysis.

Activities performed:

- Duplicate record validation
- NULL value inspection
- Missing value identification
- Placeholder value detection
- Occupation standardization
- Employment data validation
- Data quality verification

---

## Phase 2 – Exploratory Data Analysis

Exploratory analysis was performed on both applicant information and credit history.

### Applicant Analysis

- Dataset overview
- Gender distribution
- Age distribution
- Education level
- Marital status
- Housing type
- Income distribution
- Income type
- Occupation distribution
- Employment duration
- Number of children
- Family size
- Car ownership
- Property ownership

### Credit History Analysis

- Credit status distribution
- Customer repayment history
- Credit history length
- Monthly repayment behaviour

---

## Phase 3 – Feature Engineering

Monthly repayment records were aggregated into customer-level behavioral features.

Engineered features include:

- Months Observed
- Worst Repayment Status
- Paid On Time Months
- 30-Day Late Months
- 60-Day Late Months
- 90-Day Late Months
- 120-Day Late Months
- 150+ Day Late Months
- Closed Loan Months
- No Loan Months
- Total Late Months
- Customer Risk Label

The engineered dataset contains one analytical record for each customer.

---

## Phase 4 – Business Analysis

Customer characteristics were analyzed against the engineered risk labels to identify high-risk customer segments.

Business analyses performed:

- Gender vs Customer Risk
- Age Group vs Customer Risk
- Education Level vs Customer Risk
- Marital Status vs Customer Risk
- Housing Type vs Customer Risk
- Income Group vs Customer Risk
- Income Type vs Customer Risk
- Occupation vs Customer Risk
- Employment Duration vs Customer Risk
- Number of Children vs Customer Risk
- Family Size vs Customer Risk
- Car Ownership vs Customer Risk
- Property Ownership vs Customer Risk

---

## Key Findings

- Most customers belong to the Working income category.
- Nearly half of the applicants fall within the 100K–200K annual income range.
- House/Apartment is the dominant housing type.
- Younger customers show relatively higher bad rates than older customers.
- Property owners generally exhibit lower bad rates than non-property owners.
- Customer-level aggregation provides more meaningful insights than monthly repayment records.

---

## SQL Concepts Demonstrated

- Data Cleaning
- Exploratory Data Analysis
- Feature Engineering
- Business Analysis
- Common Table Expressions (CTEs)
- Window Functions
- CASE Expressions
- Aggregate Functions
- Conditional Aggregation
- INNER JOIN
- GROUP BY
- Subqueries
- CREATE TABLE AS SELECT (CTAS)
- ALTER TABLE
- UPDATE
- COALESCE()

---

## How to Run

1. Import both CSV files into MySQL.
2. Execute the SQL scripts in the following order:

```
01_Data_Cleaning.sql

↓

02_EDA.sql

↓

03_Feature_Engineering.sql

↓

04_Business_Analysis.sql
```

---

## Future Enhancements

Potential extensions of this project include:

- Predictive credit risk modeling using machine learning.
- Customer credit scoring.
- Interactive business dashboards.
- Automated SQL reporting workflows.

---

## Author

**Shubham Tiwari**

GitHub: **github.com/shubhamtiwari4096**
