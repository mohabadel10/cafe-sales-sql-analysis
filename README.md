# Cafe Sales Data Cleaning & Exploratory Data Analysis

## Project Overview

This project focuses on cleaning, validating, and analyzing a cafe sales dataset using SQL and MySQL. The goal was to identify data quality issues, clean invalid values, validate the dataset, and extract meaningful business insights through exploratory data analysis.

## Tools

- MySQL
- MySQL Workbench
- SQL

## Dataset

The dataset contains cafe transaction records with information including:

- Transaction ID
- Item
- Quantity
- Price per Unit
- Total Spent
- Payment Method
- Location
- Transaction Date

The dataset covers transactions throughout 2023.

## Data Profiling

The first stage of the project focused on understanding the dataset and identifying data quality issues.

The analysis investigated:

- Missing values
- NULL values
- ERROR values
- UNKNOWN values
- Blank values
- Invalid quantities
- Invalid prices
- Invalid total spending values
- Duplicate records
- Invalid transaction dates

## Data Cleaning

Invalid values such as ERROR, UNKNOWN, and blank values were standardized to SQL NULL where appropriate.
The original data was preserved, while a separate cleaned table was created for the analysis.

## Data Validation

Several validation checks were performed after cleaning, including:

- Duplicate transaction ID checks
- Duplicate record checks
- Quantity range validation
- Price validation
- Total spent consistency checks
- Transaction date validation
- Date coverage validation

Valid transaction dates ranged from January 1, 2023 to December 31, 2023.

All 365 days of 2023 were represented in the dataset.

## Exploratory Data Analysis

The cleaned dataset was analyzed across:

- Product performance
- Quantity sold
- Payment methods
- Location performance
- Monthly sales
- Monthly transaction volume
- Average transaction value

## Key Findings

### Product Performance

- Juice was the most frequently purchased product with 1,063 transactions.
- Tea was the least frequently purchased product with 972 transactions.
- Salad generated the highest total sales at 15,600.
- Coffee had the highest number of units sold with 3,212 units.
- Salad had the highest average transaction value at approximately 15.15.

### Payment Methods

Digital Wallet was the most frequently used payment method with 2,068 transactions.

It also generated the highest total sales at 18,530.

The differences between Digital Wallet, Cash, and Credit Card were relatively small.

### Location Performance

In-store generated higher total sales than Takeaway:

- In-store: 24,598
- Takeaway: 23,868

The number of transactions was very similar:

- In-store: 2,731
- Takeaway: 2,711

In-store also had a slightly higher average transaction value:

- In-store: 9.01
- Takeaway: 8.80

### Monthly Performance

June had the highest monthly sales at 6,678.

February had the lowest monthly sales at 6,055.

March had the highest transaction volume with 749 transactions.

Monthly average transaction value remained relatively stable throughout the year.

## Business Insights

1. Salad was the strongest revenue-generating product and also had the highest average transaction value.

2. Juice was the most frequently purchased product, showing that transaction frequency does not necessarily indicate the highest revenue.

3. Coffee had the highest number of units sold but did not generate the highest revenue, highlighting the difference between sales volume and revenue.

4. In-store generated more revenue than Takeaway despite having almost the same number of transactions. The higher average transaction value helped explain this difference.

5. Monthly sales remained relatively stable throughout 2023, with no major extreme spikes or declines.

## SQL Analysis

All SQL queries used for data profiling, cleaning, validation, and exploratory analysis are included in:

cafe_sales_analysis.sql

## Conclusion

This project demonstrates a complete SQL-based data analysis workflow, starting from data quality assessment and cleaning through validation and exploratory analysis.


The analysis transformed a dataset containing inconsistent and invalid values into a cleaner dataset that could be used to generate meaningful business insights.
