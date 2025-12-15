/*
=========================================================================
						    Customers Report
=========================================================================
Project: SQL Server Data Analytics Project
Script: 13_Customers_Report.sql
Author: Abdul Muqtadeer Baag

Purpose:
    - This report consolidates key customer metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- =============================================================================
--				Create Report: final.customers_report
-- =============================================================================
IF OBJECT_ID('final.customers_report', 'V') IS NOT NULL
    DROP VIEW final.customers_report;
GO

CREATE VIEW final.customers_report
AS

WITH Base_Query 
AS
(
----------------------------------------------------------------------------------
--		1) Base Query: Retrieves core columns from tables:
----------------------------------------------------------------------------------
	SELECT
		f.Order_Number,
		f.Product_Key,
		f.Order_Date,
		f.Sales_Amount,
		f.Quantity,
		c.Customer_Key,
		c.Customer_Number,
		CONCAT(c.First_Name, ' ', c.Last_Name) AS Customer_Name,
		DATEDIFF(YEAR, c.Birth_Date, GETDATE()) Age
	FROM final.fact_sales f
	LEFT JOIN final.dim_customers c
		ON c.Customer_Key = f.Customer_Key
	WHERE Order_Date IS NOT NULL
),
Customer_Aggregate
AS
(
----------------------------------------------------------------------------------
--	  2) Customer Aggregations: Summarizes key metrics at the customer level:
----------------------------------------------------------------------------------
	SELECT 
		Customer_Key,
		Customer_Number,
		Customer_Name,
		Age,
		COUNT(DISTINCT Order_Number) AS Total_Orders,
		SUM(Sales_Amount) AS Total_Sales,
		SUM(Quantity) AS Total_Quantity,
		COUNT(DISTINCT Product_Key) AS Total_Products,
		MAX(Order_Date) AS Last_Order_Date,
		DATEDIFF(MONTH, MIN(Order_Date), MAX(Order_Date)) AS Life_Span
	FROM Base_Query
	GROUP BY 
		Customer_Key,
		Customer_Number,
		Customer_Name,
		Age
)
SELECT
	Customer_Key,
	Customer_Number,
	Customer_Name,
	Age,
	CASE 
		 WHEN Age < 20 THEN 'Under 20'
		 WHEN Age Between 20 AND 29 THEN '20-29'
		 WHEN Age Between 30 AND 39 THEN '30-39'
		 WHEN Age Between 40 AND 49 THEN '40-49'
		 ELSE '50 and above'
	END AS Age_Group,
	CASE 
		WHEN Life_Span >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN Life_Span >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS Customer_Segment,
	Last_Order_Date,
	DATEDIFF(MONTH, Last_Order_Date, GETDATE()) AS Recency,
	Total_Orders,
	Total_Sales,
	Total_Quantity,
	Total_Products,
	Life_Span,
	-- Compuate average order value (AVO):
	CASE 
		WHEN Total_Sales = 0 THEN 0
		ELSE Total_Sales / Total_Orders
	END AS Avg_Order_Value,
	-- Compuate average monthly spend:
	CASE 
		WHEN Life_Span = 0 THEN Total_Sales
		ELSE Total_Sales / Life_Span
	END AS Avg_Monthly_Spend
FROM Customer_Aggregate;
GO
