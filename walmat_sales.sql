-- Use created database
CREATE DATABASE IF NOT EXISTS walmatSalesData;

USE walmatSalesData;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id varchar(30) Primary key,
	branch varchar(5),
	city varchar(30),
	customer_type varchar(30),
	gender varchar(10),
	product_line varchar(100),
	unit_price decimal(10,2),
	quantity int,
	VAT float(6,4),
	total decimal(12,4),
	date datetime,
	time time,
	payment_method varchar(15),
	cogs decimal(10,2),
	gross_margin_pct float(11,9),
	gross_income decimal(12,4),
	rating float(2,1)
);

-- View data
SELECT *
FROM sales;

-- --------------------------------------------------------------------------------
-- ----------------------- Feature Engineering -------------------------------------
-- Creating new columns to aid in our sales analysis

-- TIME OF DAY
SELECT *, 
	(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning' 
		WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END) as time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning' 
		WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
END
);

-- DAY NAME
SELECT date, DAYNAME(date) day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR (20);

UPDATE sales
SET day_name = DAYNAME(date);

-- MONTH NAME
SELECT date, MONTHNAME(date) month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- View data after creating addional columns
SELECT *
FROM sales;


-- ----------------------------------------------------------------------------------
-- ----------------------- Generic Questions -----------------------------------------;
-- EXPLORATORY DATA ANALYSIS (EDA)

-- How many unique cities does the data have?
SELECT city
FROM sales
GROUP BY city; 
-- OR
SELECT DISTINCT city
FROM sales; 

# The data has 3 unique cities that is Yangon, Naypyitaw and Mandalay

-- In which city is each branch?
SELECT city, branch
FROM sales
GROUP BY city, branch;
-- OR
SELECT DISTINCT city, branch
from sales;
# Yangon branch A, Naypyitaw in branch C and Mandalay is in branch B
 -- ---------------------------------------------------------------------------------
 -- ------------------------- Product questions -------------------------------------
 -- How many unique product line does the data have?
 SELECT DISTINCT product_line
 FROM sales;
# The data has 6 unique product line

-- What is the most common payment method?
SELECT payment_method, count(payment_method) count
FROM sales
GROUP BY payment_method
ORDER BY count DESC;
# The most common payment method is by cash and least is by credit

-- What is the most selling product line?
SELECT product_line, count(product_line) count
FROM sales
GROUP BY product_line
ORDER BY count DESC;
# The most selling product line is fashion accessories

-- What is the total revenue by month?
SELECT month_name month, SUM(total) revenue
FROM sales
GROUP BY month
ORDER BY revenue DESC;
# January made the most revenue

select min(date), max(date)
from sales;

-- Which month had the largest COGS?
SELECT month_name month, sum(cogs) cost_of_sales
FROM sales
GROUP BY month
ORDER BY cost_of_sales DESC; 
# January had the most cogs which is due to making more sales

-- What product line had the largest revenue?
SELECT product_line, sum(total) revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;
# Food and beverages made the highest revenue due to the fact that more people consume more food

-- What is the city with largest revenue?
SELECT branch, city, sum(total) revenue
FROM sales
GROUP BY branch, city
ORDER BY revenue DESC;
# Naypyitaw made the highest revenue

-- What product_line had the largest VAT
SELECT product_line, AVG(VAT) avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?
SELECT branch, sum(quantity) qty
FROM sales
GROUP BY branch
HAVING sum(quantity) > ( SELECT avg(quantity) 
						from sales);

-- What is the most common product line by gender?
SELECT product_line, gender, count(gender) total_cnt
FROM sales
GROUP BY product_line, gender
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- -------------------------------------------------------------------------------
-- ----------------------------Sales Questions -----------------------------------
-- Number of sales made in each time of the day per weekday?
SELECT  time_of_day, count(quantity) qty 
FROM sales
WHERE day_name = 'Monday'
GROUP BY time_of_day
ORDER BY qty desc;

-- Which of the customer types brings the most revenue?
SELECT customer_type, sum(total) revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percentage/VAT?
SELECT city, round(AVG(VAT), 2) VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer_type pays the most VAT?
SELECT customer_type, round(avg(VAT), 2) avg_VAT
FROM sales
GROUP BY customer_type
ORDER BY avg_VAT DESC;


-- -------------------------------------------------------------------------------
-- --------------------- CUSTOMER QUESTIONS --------------------------------------
-- How many unique customer types does the data have?
SELECT distinct customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales;


-- What is the most common customer type?
SELECT customer_type, count(*) total
FROM sales
GROUP BY customer_type;


-- Which customer buys the most?
SELECT customer_type, count(*) cust_cnt
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender, count(*) gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT branch, gender, count(gender) gender_cnt 
FROM sales
GROUP BY branch, gender
ORDER BY branch;

-- Which time of the day do customers give most ratings? 
SELECT time_of_day, count(rating) total_rating, AVG(rating) avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which time of the day do customers give most ratings per branch? 
SELECT time_of_day, avg(rating) avg_rating
FROM sales
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY avg_rating desc;

-- which day of the week has the best avg ratings
SELECT day_name, avg(rating) avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;


-- Which day of the week has the best average ratings per branch?
SELECT day_name, ROUND(avg(rating),2) avg_rating
FROM SALES
WHERE branch = 'C'
GROUP BY day_name
ORDER BY avg_rating DESC;




SELECT * FROM walmatSalesData.sales;