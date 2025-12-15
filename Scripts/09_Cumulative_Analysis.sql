/*
=========================================================================
						Cumulative Analysis
=========================================================================
Project: SQL Server Data Analytics Project
Script: 09_Cumulative_Analysis.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Perform cumulative analysis to track how key metrics.
	- Build up over time and understand long-term performance.
	- To calculate running totals and moving averages for overall trends>

Functions Used:
	- SUM() OVER()
	- AVG() OVER()
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Calculate the total sales per month,
-- And the running total of sales over time:
SELECT
	Order_Date,
	Total_Sales,
	SUM(Total_Sales) OVER (ORDER BY Order_Date) AS Running_Total_Sales,
	AVG(Avg_Price) OVER (ORDER BY Order_Date) AS Moving_Average_Price
FROM
	(
		SELECT 
			DATETRUNC(MONTH, Order_Date) AS Order_Date,
			SUM(Sales_Amount) AS Total_Sales,
			AVG(Price) AS Avg_Price
		FROM final.fact_sales
		WHERE Order_Date IS NOT NULL
		GROUP BY DATETRUNC(MONTH, Order_Date)
	) t;
GO
