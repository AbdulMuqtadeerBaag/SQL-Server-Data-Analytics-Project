/*
=========================================================================
						   Ranking Analysis
=========================================================================
Project: SQL Server Data Analytics Project
Script: 07_Ranking_Analysis.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Rank products and customers based on performance.
	- To identify top and bottom performers>

Functions used:
	- RANK()
	- DENSE_RANK()
	- ROW_NUMBER()
	- TOP
	- GROUP BY
	- ORDER BY
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Which 5 products Generating the Highest Revenue:
-- Simple Ranking:
SELECT TOP 5
    p.Product_Name,
    SUM(f.Sales_Amount) AS Total_Revenue
FROM final.fact_sales f
LEFT JOIN final.dim_products p
    ON p.Product_Key = f.Product_Key
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC;
GO

-- Complex but Flexibly Ranking Using Window Functions:
SELECT *
FROM 
	(
		SELECT
			p.Product_Name,
			SUM(f.Sales_Amount) AS Total_Revenue,
			RANK() OVER (ORDER BY SUM(f.Sales_Amount) DESC) AS Rank_Products
		FROM final.fact_sales f
		LEFT JOIN final.dim_products p
			ON p.Product_Key = f.Product_Key
		GROUP BY p.Product_Name
	) AS Ranked_Products
WHERE Rank_Products <= 5;
GO

-- What are the 5 worst-performing products in terms of sales:
SELECT TOP 5
    p.Product_Name,
    SUM(f.Sales_Amount) AS Total_Revenue
FROM final.fact_sales f
LEFT JOIN final.dim_products p
    ON p.Product_Key = f.Product_Key
GROUP BY p.Product_Name
ORDER BY Total_Revenue ASC;
GO

-- Find the top 10 customers who have generated the highest revenue:
SELECT TOP 10
    c.Customer_Key,
    c.First_Name,
    c.Last_Name,
    SUM(f.Sales_Amount) AS Total_Revenue
FROM final.fact_sales f
LEFT JOIN final.dim_customers c
    ON c.Customer_Key = f.Customer_Key
GROUP BY 
    c.Customer_Key,
    c.First_Name,
    c.Last_Name
ORDER BY Total_Revenue DESC;
GO

-- The 3 customers with the fewest orders placed:
SELECT TOP 3
    c.Customer_Key,
    c.First_Name,
    c.Last_Name,
    COUNT(DISTINCT Order_Number) AS Total_Orders
FROM final.fact_sales f
LEFT JOIN final.dim_customers c
    ON c.Customer_Key = f.Customer_Key
GROUP BY 
    c.Customer_Key,
    c.First_Name,
    c.Last_Name
ORDER BY Total_Orders;
GO
