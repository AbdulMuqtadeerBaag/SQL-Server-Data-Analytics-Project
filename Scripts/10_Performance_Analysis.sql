/*
=========================================================================
						Performance Analysis
=========================================================================
Project: SQL Server Data Analytics Project
Script: 10_Performance_Analysis.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Measure and compare performance over time.
	- To understand growth, decline, and trends across product, customers, or regions.

Functions Used:
	- LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
==========================================================================
*/

-- Change the DB context:
USE AnalyticsDB;
GO

/* Analyze the yearly performance of products by comparing their sales to both 
the average sales performance of the product and the previous year's sales. */
WITH Yearly_Product_Sales
AS (
    SELECT
        YEAR(f.Order_Date) AS Order_Year,
        p.Product_Name,
        SUM(f.Sales_Amount) AS Current_Sales
    FROM final.fact_sales f
    LEFT JOIN final.dim_products p
        ON f.Product_Key = p.Product_Key
    WHERE f.Order_Date IS NOT NULL
    GROUP BY 
        YEAR(f.Order_Date),
        p.Product_Name
  )
SELECT
    Order_Year,
    Product_Name,
    Current_Sales,
    AVG(Current_Sales) OVER (PARTITION BY Product_Name) AS Avg_Sales,
    Current_Sales - AVG(Current_Sales) OVER (PARTITION BY Product_Name) AS Diff_Avg,
    CASE 
        WHEN Current_Sales - AVG(Current_Sales) OVER (PARTITION BY Product_Name) > 0 THEN 'Above Avg'
        WHEN Current_Sales - AVG(Current_Sales) OVER (PARTITION BY Product_Name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS Avg_Change,
    -- Year-over-Year Analysis:
    LAG(Current_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) AS Prev_Yr_Sales,
    Current_Sales - LAG(Current_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) AS Diff_Prev_Yr,
    CASE 
        WHEN Current_Sales - LAG(Current_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) > 0 THEN 'Increase'
        WHEN Current_Sales - LAG(Current_Sales) OVER (PARTITION BY Product_Name ORDER BY Order_Year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS Prev_Yr_Change
FROM Yearly_Product_Sales
ORDER BY Product_Name, Order_Year;
GO
