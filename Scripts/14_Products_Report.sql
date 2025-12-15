/*
=========================================================================
						    Products Report
=========================================================================
Project: SQL Server Data Analytics Project
Script: 14_Products_Report.sql
Author: Abdul Muqtadeer Baag

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- ==========================================================================
--					Create Report: final.Products_Report
-- ==========================================================================
IF OBJECT_ID('final.Products_Report', 'V') IS NOT NULL
    DROP VIEW final.Products_Report;
GO

CREATE VIEW final.Products_Report
AS

WITH Base_Query 
AS
(
----------------------------------------------------------------------------------
--	 1) Base Query: Retrieves core columns from fact_sales and dim_products:
----------------------------------------------------------------------------------
    SELECT
	    f.Order_Number,
        f.Order_Date,
		f.Customer_Key,
        f.Sales_Amount,
        f.Quantity,
        p.Product_Key,
        p.Product_Name,
        p.Category,
        p.Sub_Category,
        p.Cost
    FROM final.fact_sales f
    LEFT JOIN final.dim_products p
        ON f.Product_Key = p.Product_Key
    WHERE Order_Date IS NOT NULL  -- Only consider valid sales dates.
),
Product_Aggregations 
AS 
(
----------------------------------------------------------------------------------
--		2) Product Aggregations: Summarizes key metrics at the product level:
----------------------------------------------------------------------------------
	SELECT
		Product_Key,
		Product_Name,
		Category,
		Sub_Category,
		Cost,
		DATEDIFF(MONTH, MIN(Order_Date), MAX(Order_Date)) AS Life_Span,
		MAX(Order_Date) AS Last_Sale_Date,
		COUNT(DISTINCT Order_Number) AS Total_Orders,
		COUNT(DISTINCT Customer_Key) AS Total_Customers,
		SUM(Sales_Amount) AS Total_Sales,
		SUM(Quantity) AS Total_Quantity,
		ROUND(AVG(CAST(Sales_Amount AS FLOAT) / NULLIF(Quantity, 0)),1) AS Avg_Selling_Price
	FROM Base_Query
	GROUP BY
		Product_Key,
		Product_Name,
		Category,
		Sub_Category,
		Cost
)
----------------------------------------------------------------------------------
--	   3) Final Query: Combines all product results into one output:
----------------------------------------------------------------------------------
	SELECT 
		Product_Key,
		Product_Name,
		Category,
		Sub_Category,
		Cost,
		Last_Sale_Date,
		DATEDIFF(MONTH, Last_Sale_Date, GETDATE()) AS Recency_in_Months,
		CASE
			WHEN Total_Sales > 50000 THEN 'High-Performer'
			WHEN Total_Sales >= 10000 THEN 'Mid-Range'
			ELSE 'Low-Performer'
		END AS Product_Segment,
		Life_Span,
		Total_Orders,
		Total_Sales,
		Total_Quantity,
		Total_Customers,
		Avg_Selling_Price,
		-- Average Order Revenue (AOR):
		CASE 
			WHEN Total_Orders = 0 THEN 0
			ELSE Total_Sales / Total_Orders
		END AS Avg_Order_Revenue,
		-- Average Monthly Revenue:
		CASE
			WHEN Life_Span = 0 THEN Total_Sales
			ELSE Total_Sales / Life_Span
		END AS Avg_Monthly_Revenue
	FROM Product_Aggregations;
GO
