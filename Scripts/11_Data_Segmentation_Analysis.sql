/*
=========================================================================
					Data Segmentation Analysis
=========================================================================
Project: SQL Server Data Analytics Project
Script: 11_Data_Segmentation_Analysis.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- To group data into meaningful segments.
	- To better understand customers, products, or regions 
	for focused analysis and insights.

Functions Used:
	- CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Segment products into cost ranges and count how many products fall into each segment:
WITH Product_Segment
AS
(
	SELECT
		Product_Key,
		Product_Name,
		Cost,
		CASE
			WHEN Cost < 100 THEN 'Below 100'
			WHEN Cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN Cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS Cost_Range
	FROM final.dim_products
)
SELECT
	Cost_Range,
	COUNT(Product_Key) AS Total_Product
FROM Product_Segment
GROUP BY Cost_Range
ORDER BY Total_Product DESC;
GO

/* Group customers into three segments based on their spending behavior:
		- VIP: Customers with at least 12 months of history and spending more than 5,000.
		- Regular: Customers with at least 12 months of history but spending 5,000 or less.
		- New: Customers with a lifespan less than 12 months.
	And find the total number of customers by each group. */
WITH Customer_Spending
AS
(
	SELECT
		c.Customer_Key,
		SUM(f.Sales_Amount) AS Total_Spending,
		MIN(f.Order_Date) AS First_Order,
		MAX(f.Order_Date) AS Last_Order,
		DATEDIFF(MONTH,MIN(f.Order_Date),MAX(f.Order_Date)) AS Life_Span
	FROM final.fact_sales f
	LEFT JOIN final.dim_customers c
		ON f.Customer_Key = c.Customer_Key
	GROUP BY c.Customer_Key
)
SELECT
	Customer_Segment,
	COUNT(Customer_Key) AS Total_Customer
FROM (
		SELECT
			Customer_Key,
			CASE
				WHEN Life_Span >= 12 AND Total_Spending > 5000 THEN 'VIP'
				WHEN Life_Span >= 12 AND Total_Spending <= 5000 THEN 'Regular'
				ELSE 'New'
			END AS Customer_Segment
		FROM Customer_Spending
	) t
GROUP BY Customer_Segment
ORDER BY Total_Customer DESC;
GO
