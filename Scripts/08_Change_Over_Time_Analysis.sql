/*
=========================================================================
						 Change Over Time Analysis
=========================================================================
Project: SQL Server Data Analytics Project
Script: 08_Change_Over_Time_Analysis.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Analyze trends and changes in key metrics.
	- Over time to understand growth or decline.

Functions Used:
	- DATEPART()
	- DATETRUNC()
	- FORMAT()
	- SUM()
	- COUNT()
	- AVG()
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Analyse sales performance over time:
-- Quick Date Functions:
SELECT
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    SUM(Sales_Amount) AS Total_Sales,
    COUNT(DISTINCT Customer_Key) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity
FROM final.fact_sales
WHERE Order_Date IS NOT NULL
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date);
GO

-- DATETRUNC():
SELECT
    DATETRUNC(MONTH, Order_Date) AS Order_Date,
    SUM(Sales_Amount) AS Total_Sales,
    COUNT(DISTINCT Customer_Key) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity
FROM final.fact_sales
WHERE Order_Date IS NOT NULL
GROUP BY DATETRUNC(MONTH, Order_Date)
ORDER BY DATETRUNC(MONTH, Order_Date);
GO

-- FORMAT():
SELECT
    FORMAT(Order_Date, 'yyyy-MMM') AS Order_Date,
    SUM(Sales_Amount) AS Total_Sales,
    COUNT(DISTINCT Customer_Key) AS Total_Customers,
    SUM(Quantity) AS Total_Quantity
FROM final.fact_sales
WHERE Order_Date IS NOT NULL
GROUP BY FORMAT(Order_Date, 'yyyy-MMM')
ORDER BY FORMAT(Order_Date, 'yyyy-MMM');
GO
