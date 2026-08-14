SELECT *
FROM dirty_cafe_sales;

CREATE TABLE cafe_sales1
LIKE dirty_cafe_sales;

INSERT cafe_sales1
SELECT *
FROM dirty_cafe_sales;

SELECT *
FROM cafe_sales1;


-- Standardize missing values in the Item column

SELECT *
FROM cafe_sales1
WHERE Item = 'UNKNOWN'
	OR Item = 'ERROR'
    OR TRIM(Item) = '';
    
UPDATE Cafe_sales1
SET Item = NULL
WHERE Item = 'UNKNOWN'
	OR Item = 'ERROR'
    OR TRIM(Item) = '';

SELECT Item, COUNT(*) As total
FROM cafe_sales1
GROUP BY Item;


-- Standardize missing values in the payment method column

SELECT *
FROM cafe_sales1
WHERE Payment_method = 'UNKNOWN'
	OR payment_method = 'ERROR'
    OR TRIM(payment_method) = '';
    
UPDATE cafe_sales1
SET payment_method = NULL
WHERE payment_method = 'UNKNOWN'
	OR payment_method = 'ERROR'
    OR TRIM(payment_method) = '';

SELECT payment_method, COUNT(*) AS total
FROM cafe_sales1
GROUP BY payment_method;


-- Standardize missing values in the Loction column

SELECT *
FROM cafe_sales1
WHERE Location = 'UNKNOWN'
	OR Location = 'ERROR'
    OR TRIM(Location) = '';

UPDATE cafe_sales1
SET Location = NULL
WHERE Location = 'UNKNOWN'
	OR Location = 'ERROR'
    OR TRIM(Location) = '';

SELECT Location, COUNT(*) AS total
FROM cafe_sales1
GROUP BY Location;


-- Standardize missing values in the Quantity column

SELECT *
FROM cafe_sales1
WHERE Quantity = 'UNKNOWN'
	OR Quantity = 'ERROR'
    OR TRIM(Quantity) = ''
    OR Quantity IS NULL;

# No invalid placeholder values (UNKNOWN, ERROR, or Blank) were found


-- Standardize missing values in the Price Per Unit column

SELECT *
FROM cafe_sales1
WHERE Price_Per_Unit = 'UNKNOWN'
	OR Price_Per_Unit = 'ERROR'
    OR TRIM(Price_Per_Unit) = ''
    OR Price_Per_Unit IS NULL;

# No invalid placeholder values (UNKNOWN, ERROR, or Blank) were found


-- Standardize missing values in the Total Spent column

SELECT *
FROM cafe_sales1
WHERE Total_Spent = 'UNKNOWN'
	OR Total_Spent = 'ERROR'
    OR TRIM(Total_Spent) = ''
    OR Total_Spent IS NULL;

SELECT Total_Spent, COUNT(*) AS total
FROM cafe_sales1
WHERE Total_Spent = 'UNKNOWN'
	OR Total_Spent = 'ERROR'
	OR TRIM(Total_Spent) = ''
    OR Total_Spent IS NULL
GROUP BY Total_Spent;


-- Validate Total Spent

SELECT Quantity, price_per_unit, total_spent, Quantity * price_per_unit AS Calculated_Total
FROM cafe_sales1
WHERE Total_Spent NOT IN ('ERROR', 'UNKNOWN', '', 'NULL');
    

-- Recalculate Invalid Total Spent Values

SELECT Quantity, price_per_unit, total_spent, quantity * price_per_unit AS Calculated_Total
FROM cafe_sales1
WHERE Total_Spent = 'ERROR'
	OR Total_Spent = 'UNKNOWN'
    OR Total_Spent IS NULL
    OR TRIM(Total_Spent) = '';
    
UPDATE cafe_sales1
SET Total_Spent = quantity * price_per_unit
WHERE Total_Spent = 'ERROR'
	OR Total_Spent = 'UNKNOWN'
    OR Total_Spent IS NULL
    OR TRIM(Total_Spent) = '';

SELECT Total_Spent, COUNT(*) AS Total
FROM cafe_sales1
GROUP BY Total_Spent;

SELECT *
FROM cafe_sales1
WHERE Total_Spent != quantity * Price_Per_Unit;

# No rows returned


-- Location Value Validation

SELECT Location, COUNT(*) AS total
FROM cafe_sales1
GROUP BY Location;


-- Handle missing Location values

SELECT Item, COUNT(*) AS total_null_location
FROM cafe_sales1
WHERE location IS NULL
GROUP BY Item
ORDER BY total_null_location DESC;

# Keep Missing Location Values as NULL (3564 values) – no reliable relationship was found between Item and Location


-- Data Validation

SELECT *
FROM cafe_sales1
WHERE Quantity > 5
	OR QUantity < 1;

# no rows returned

SELECT *
FROM cafe_sales1
WHERE Price_Per_Unit <= 0;

# no rows returned

SELECT *
FROM cafe_sales1
WHERE Total_Spent <= 0;

# no rows returned

SELECT Quantity, Price_Per_Unit, Total_Spent
FROM cafe_sales1
WHERE Quantity IS NULL
	OR Price_Per_Unit IS NULL
    OR Total_Spent IS NULL;

# no rows returned


-- Duplicate records detection

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER( PARTITION BY Transaction_ID, Item, Quantity, Price_Per_Unit, Total_Spent, Payment_Method, Location, Transaction_Date) AS row_num
FROM cafe_sales1
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

# no rows returned


-- Transaction ID validation

SELECT Transaction_ID, COUNT(*) AS total
FROM cafe_sales1
GROUP BY Transaction_ID
HAVING total > 1;

# no rows returned ( Transaction IDs are unique )


-- Transaction ID missing values

SELECT *
FROM cafe_sales1
WHERE Transaction_ID IS NULL
	OR Transaction_ID = 'ERROR'
    OR Transaction_ID = 'UNKNOWN'
    OR TRIM(Transaction_ID) = '';

# no rows returned


-- Transaction Date Validation

SELECT *
FROM cafe_sales1
WHERE Transaction_Date IS NULL
	OR Transaction_Date = 'UNKNOWN'
    OR Transaction_Date = 'ERROR'
    OR TRIM(Transaction_Date) = '';


-- Transaction Date Profiling

SELECT Transaction_Date, COUNT(*) AS total
FROM cafe_sales1
WHERE Transaction_Date = 'UNKNOWN'
	OR Transaction_Date = 'ERROR'
    OR Transaction_Date IS NULL
    OR TRIM(Transaction_Date) = ''
GROUP BY Transaction_Date;


-- Transaction Date Format Validation

SELECT Transaction_Date, COUNT(*) AS total
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
	AND Transaction_Date != 'ERROR'
    AND Transaction_Date != 'UNKNOWN'
    AND TRIM(Transaction_Date) != ''
GROUP BY Transaction_Date
ORDER BY Transaction_Date;

# All valid transaction dates follow the same YYYY-MM-DD format


-- Transaction Date Missing Value Assessment

SELECT Item, Transaction_Date, COUNT(*) AS total
FROM cafe_sales1
WHERE Transaction_Date = 'UNKNOWN'
	OR Transaction_Date = 'ERROR'
    OR Transaction_Date IS NULL
    OR TRIM(Transaction_Date) = ''
GROUP BY Item, Transaction_Date;

# no pattern between item and transaction date


-- Standardize Invalid Transaction Dates

UPDATE cafe_sales1
SET Transaction_Date = 'NULL'
WHERE Transaction_Date = 'ERROR'
	OR Transaction_Date = 'UNKNOWN'
    OR TRIM(Transaction_Date) = '';
    
				UPDATE cafe_sales1
                SET Transaction_Date = NULL
                WHERE Transaction_Date = 'NULL';

SELECT *
FROM cafe_sales1
WHERE Transaction_Date = 'ERROR'
	OR Transaction_Date = 'UNKNOWN'
    OR TRIM(Transaction_Date) = '';
    
SELECT COUNT(*) AS total_nulls
FROM cafe_sales1
WHERE Transaction_Date IS NULL;

#Error, unknown, and blank date values were converted to NULL


-- Transaction Date Range Validation

SELECT MAX(Transaction_Date), MIN(Transaction_Date)
FROM cafe_sales1;

# valid transaction dates range from 2023-01-01 to 2023-12-31


-- Transaction Date Completeness

SELECT COUNT(DISTINCT Transaction_Date) AS Distinct_dates
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL;

# all 365 days of 2023 are represented in the dataset


-- Daily Transaction Volume

SELECT Transaction_date, COUNT(*) AS total_transactions
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
GROUP BY Transaction_Date
ORDER BY Transaction_Date ASC;

# calculated the number of transactions recorded for each valid date


-- Highest Transaction Volume Day

SELECT Transaction_date, COUNT(*) AS total_transactions
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
GROUP BY Transaction_Date
ORDER BY total_transactions DESC
LIMIT 1;

# identified 2023-06-16 as the date with hte highest transaction volume, with 38 transactions


-- Lowest Transaction Volume Day

SELECT Transaction_Date, COUNT(*) AS total_transactions
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
GROUP BY Transaction_Date
ORDER BY total_transactions ASC
LIMIT 1;

# identified 2023-04-27 as the date with hte lowest transaction volume, with 12 transactions


-- Most Popular Product

SELECT Item, COUNT(*) AS total
FROM cafe_sales1
WHERE Item IS NOT NULL
GROUP BY Item
ORDER BY total DESC
LIMIT 1;

# Juice was the most frequently purchased product, appearing in 1063 transactions


-- Least Popular Product

SELECT Item, COUNT(*) AS total
FROM cafe_sales1
WHERE Item IS NOT NULL
GROUP BY Item
ORDER BY total ASC
LIMIT 1;

# Tea was the least frequently purchased product, appearing 972 transactions


-- Total Sales by Product

SELECT Item, SUM(Total_Spent) AS Total_Sales
FROM cafe_sales1
WHERE Item IS NOT NULL
GROUP BY Item
ORDER BY Total_Sales DESC;

# Salad generated the highest total sales, with 15600


-- Average Transaction Value by Product

SELECT Item, AVG(total_spent) AS avg_total_sales
FROM cafe_sales1
WHERE Item IS NOT NULL
GROUP BY Item
ORDER BY avg_total_sales DESC;

# calculated the average transaction value for each product 


--  Total Quantity Sold by Product

SELECT Item, SUM(Quantity) AS total_quantity_sold
FROM cafe_sales1
WHERE Item IS NOT NULL
GROUP BY Item
ORDER BY total_quantity_sold DESC;

# calculated the total quantity sold for each product


-- Payment Method Analysis

SELECT Payment_Method, COUNT(*) AS total
FROM cafe_sales1
WHERE Payment_Method IS NOT NULL
GROUP BY Payment_Method
ORDER BY total DESC;

# Digital Wallet was the most frequently used payment method, with 2068 transactions


-- Total Sales by Payment Method

SELECT payment_method, SUM(total_spent) AS total_sales_payment_method
FROM cafe_sales1
WHERE Payment_Method IS NOT NULL
GROUP BY Payment_Method
ORDER BY 2 DESC;

# digital wallet generated the highest total sales, with total sales of 18530


-- Total Sales by Location

SELECT Location, SUM(Total_Spent) AS total_sales_location
FROM cafe_sales1
WHERE Location IS NOT NULL
GROUP BY Location
ORDER BY 2 DESC;

# in-store generated the highest total sales, with total sales of 24598


-- Transactions by Location

SELECT Location, COUNT(*) AS total
FROM cafe_sales1
WHERE Location IS NOT NULL
GROUP BY Location
ORDER BY total DESC;

# in-store had the highest transaction volume, with 2731 transactions


-- Average Transaction Value by Location

SELECT Location, AVG(Total_Spent) AS average_total_sales
FROM cafe_sales1
WHERE Location IS NOT NULL
GROUP BY Location
ORDER BY 2 DESC;

# in-store had the highest average transaction value of 9.01 compared with 8.80 for takeaway


-- Monthly Sales Trend

SELECT MONTH(Transaction_Date) AS `MONTH`, SUM(Total_Spent) AS total_sales
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
GROUP BY MONTH(Transaction_Date)
ORDER BY 1 ASC;

# calculated monthly total sales for 2023. sales remained relatively stable throughout the year, with June recording highest sales at 6678 and February recording the lowest at 6678


-- Monthly Transaction Volume

SELECT MONTH(Transaction_Date) AS `MONTH`, COUNT(*) AS monthly_total_transactions
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
GROUP BY MONTH(Transaction_Date)
ORDER BY 1 ASC;

# calculated the total number of transactions for each month of 2023. March had the highest transaction volume with 749 transactions, while February had the lowest with 660


-- Average Monthly Transaction Value

SELECT MONTH(Transaction_Date) AS `MONTH`, AVG(Total_Spent) AS average_transaction_value
FROM cafe_sales1
WHERE Transaction_Date IS NOT NULL
GROUP BY MONTH(Transaction_Date)
ORDER BY 1 ASC;

# calculated the average transaction value for each month of 2023. April had the highest average transaction value at 9.28, while March had the lowest at 8.65

















