/*
=========================================================================
					 Measures Exploration (Key Metrics)
=========================================================================
Project: SQL Server Data Analytics Project
Script: 05_Measures_Exploration.sql
Author: Abdul Muqtadeer Baag

Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT()
	- SUM()
	- AVG()
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Find the Total Sales:
SELECT
	SUM(Sales_Amount) AS Total_Sales
FROM final.fact_sales;
GO

-- Find how many items are sold:
SELECT
	SUM(Quantity) AS Total_Quantity
FROM final.fact_sales;
GO

-- Find the average selling price:
SELECT
	AVG(Price) AS Avg_Price
FROM final.fact_sales;
GO

-- Find the Total number of Orders:
SELECT
	COUNT(Order_Number) AS Total_Orders
FROM final.fact_sales;
GO
SELECT 
	COUNT(DISTINCT Order_Number) AS Total_Orders
FROM final.fact_sales;
GO

-- Find the total number of products:
SELECT 
	COUNT(Product_Name) AS Total_Products
FROM final.dim_products;
GO

-- Find the total number of customers:
SELECT 
	COUNT(Customer_Key) AS Total_Customers
FROM final.dim_customers;
GO

-- Find the total number of customers that has placed an order:
SELECT 
	COUNT(DISTINCT customer_key) AS Total_Customers
FROM final.fact_sales;
GO

-- Generate a Report that shows all key metrics of the business:
SELECT 
	'Total Sales' AS Measure_Name,
	SUM(Sales_Amount) AS Measure_Value
FROM final.fact_sales
UNION ALL
SELECT 
	'Total Quantity',
	SUM(Quantity) AS Total_Quantity
FROM final.fact_sales
UNION ALL
SELECT 
	'Average Price', 
	AVG(Price)
FROM final.fact_sales
UNION ALL
SELECT 
	'Total Orders',
	COUNT(DISTINCT Order_Number)
FROM final.fact_sales
UNION ALL
SELECT 
	'Total Products', 
	COUNT(DISTINCT Product_Name)
FROM final.dim_products
UNION ALL
SELECT 
	'Total Customers',
	COUNT(Customer_Key) 
FROM final.dim_customers;
GO
