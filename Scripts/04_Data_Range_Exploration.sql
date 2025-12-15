/*
=========================================================================
					   Dimensions_Exploration
=========================================================================
Project: SQL Server Data Analytics Project
Script: 04_Data_Range_Exploration.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Analyze the date ranges to understand historical coverage and time boundaries.

SQL Server Functions used:
	- MAX()
	- MIN()
	- DIFFDATE()
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

-- Determine the first and last order date and the total duration in months:
SELECT 
    MIN(Order_Date) AS First_Order_Date,
    MAX(Order_Date) AS Last_Order_Date,
    DATEDIFF(MONTH, MIN(Order_Date), MAX(Order_Date)) AS Order_Range_Months
FROM final.fact_sales;
GO

-- Find the youngest and oldest customer based on birthdate:
SELECT
    MIN(Birth_Date) AS Oldest_Birth_Date,
    DATEDIFF(YEAR, MIN(Birth_Date), GETDATE()) AS Oldest_Age,
    MAX(Birth_Date) AS Youngest_Birth_Date,
    DATEDIFF(YEAR, MAX(Birth_Date), GETDATE()) AS Youngest_Age
FROM final.dim_customers;
GO
