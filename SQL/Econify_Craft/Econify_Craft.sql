-- 🔹 1. Create Database and Use It
CREATE DATABASE IF NOT EXISTS Econify_Craft;
USE Econify_Craft;

-- 🔹 2. Create Table
CREATE TABLE IF NOT EXISTS retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(20),
    age INT,
    category VARCHAR(40),
    quantity INT,
    price_per_unit INT,
    cogs INT,
    total_sale INT
);

-- 🔹 3. View Table Structure
SELECT * FROM retail_sales;

SHOW COLUMNS FROM retail_sales;

-- ========================================================
--  DATA CLEANING
-- ========================================================

-- 🔸 Check NULL counts in each column
SELECT 
    SUM(CASE WHEN transactions_id IS NULL THEN 1 ELSE 0 END) AS null_transactions,
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN sale_time IS NULL THEN 1 ELSE 0 END) AS null_time,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customers,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN quantiy IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN total_sale IS NULL THEN 1 ELSE 0 END) AS null_total_sale
FROM retail_sales;

-- 🔸 Find records with negative quantity or 0 total_sale
SELECT * 
FROM retail_sales
WHERE quantiy < 0 OR total_sale = 0;

-- 🔸 Check for NULLs in critical columns
SELECT * 
FROM retail_sales 
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR total_sale IS NULL;

-- 🔸 Check for duplicate transaction IDs
SELECT transactions_id, COUNT(*) AS count
FROM retail_sales
WHERE transactions_id IS NOT NULL
GROUP BY transactions_id
HAVING COUNT(*) > 1;

-- ========================================================
--  DATA EXPLORATION
-- ========================================================

-- 🔸 Total sales value
SELECT SUM(total_sale) AS total_sales FROM retail_sales;

-- 🔸 Total number of transactions
SELECT COUNT(transactions_id) AS total_transactions FROM retail_sales;

-- 🔸 Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- 🔸 Unique product categories
SELECT DISTINCT category AS unique_categories FROM retail_sales;

-- ========================================================
-- DATA ANALYSIS / BUSINESS QUESTIONS
-- ========================================================

-- 1. Sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. 'Clothing' sales with quantity > 10 in November 2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >=4
  AND MONTH(sale_date) = 11
  AND YEAR(sale_date) = 2022;

-- 3. Total sales and number of orders per category
SELECT 
    category, 
    SUM(total_sale) AS total_sales, 
    COUNT(*) AS total_orders 
FROM retail_sales 
GROUP BY category;

-- 4. Average age of customers who bought 'Beauty' products
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Transactions with total sale > 1000
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Number of transactions by gender and category
SELECT 
    category, 
    gender, 
    COUNT(*) AS total_transactions 
FROM retail_sales 
GROUP BY category, gender
ORDER BY category;

-- 7. Average monthly sales + best-selling month in each year
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS "Rank"
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date);

-- 8. Top 5 customers by total sales
SELECT 
    customer_id, 
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Unique customers per category
SELECT 
    category,    
    COUNT(DISTINCT customer_id) AS total_unique_customers
FROM retail_sales
GROUP BY category;

-- 10. Number of orders by shift (Morning <12, Afternoon 12–17, Evening >17)
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of File
