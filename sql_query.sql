-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1;

-- Creating TABLE

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales 
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category	VARCHAR(15),
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale	FLOAT
			);

SELECT * FROM retail_sales;

--First 100 rows IN ASCENDING ORDER

SELECT * FROM public.retail_sales
ORDER BY transactions_id ASC
LIMIT 100;

-- First 10 rows only

SELECT * FROM retail_sales
LIMIT 10;

-- Count the number of rows

SELECT 
	COUNT (*)
FROM retail_sales;

--DATA CLEANING

-- To check NULL value in one particular column

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

-- To check NULL VALUES for multiple columns

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- To delete the records which have NULL VALUES

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales we have?

SELECT COUNT (*) AS total_sale FROM retail_sales;

-- How many customers we have?

SELECT COUNT (customer_id) AS customers FROM retail_sales;

-- How many unique customers we have?

SELECT COUNT (DISTINCT customer_id) AS customers FROM retail_sales;

-- How many category we have?

SELECT COUNT (DISTINCT category) AS cat FROM retail_sales;

-- How many category we have? If we want to see the it in the tabular format with the values

SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- Analysis and Findings

-- Write an SQL Query to retrieve all columns of sales made on 2022-11-05 ?

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Write an SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022 ?

SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	quantiy >= 4
	AND
	TO_CHAR (sale_date, 'YYYY-MM') = '2022-11';


-- Write a SQL Query to calculate the total sales (total_sale) for each category ?

SELECT category,
	SUM (total_sale) AS net_sale
FROM retail_sales
GROUP BY 1;

-- Write a SQL Query to calculate the total sales (total_sale) and total number of orders for each category ?

SELECT category,
	SUM (total_sale) AS net_sale
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?

SELECT
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000?

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?

SELECT
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 
	1;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?

SELECT
	EXTRACT (YEAR FROM sale_date) AS YEAR,
	EXTRACT (MONTH FROM sale_date) AS MONTH,
	ROUND(AVG(total_sale)) AS avg_sale
FROM retail_sales
GROUP BY 1,
ORDER BY 1, 3 DESC;

-- USING WINDOWS FUNCTIONS

SELECT
	YEAR,
	MONTH,
	avg_sale
FROM
(
SELECT
	EXTRACT (YEAR FROM sale_date) AS YEAR,
	EXTRACT (MONTH FROM sale_date) AS MONTH,
	ROUND(AVG(total_sale)) AS avg_sale
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC ) AS RANK
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE RANK = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales ?

SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category?

SELECT
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_cst
FROM retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;