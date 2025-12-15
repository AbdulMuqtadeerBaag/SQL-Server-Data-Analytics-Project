/*
=========================================================================
					  Part To Whole Analysis
=========================================================================
Project: SQL Server Data Analytics Project
Script: 12_Part_To_Whole_Analysis.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Compare individual parts against the total.
	- To understand contribution and distribution.
	- To across categories or time periods.

Functions Used:
	- SUM()
	- AVG()
	- SUM() OVER()
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Which categories contribute the most to overall sales:
WITH Category_Sales
AS
(
	SELECT
		p.Category,
		SUM(f.Sales_Amount) AS Total_Sales
	FROM final.fact_sales f
	LEFT JOIN final.dim_products p
		ON p.Product_Key = f.Product_Key
	GROUP BY p.Category
)
SELECT
	Category,
	Total_Sales,
	SUM(Total_Sales) OVER() Overall_Sales,
	CONCAT((Total_Sales * 1.0/SUM(Total_Sales) OVER()) * 100,'%') AS Percentage_of_Total
FROM Category_Sales;
GO
