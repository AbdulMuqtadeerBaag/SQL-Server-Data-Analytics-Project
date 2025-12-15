/*
=========================================================================
					   Dimensions_Exploration
=========================================================================
Project: SQL Server Data Analytics Project
Script: 03_Dimensions_Exploration.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Explore dimension tables to understand categorical attributes.
	- This analysis helps in identifying unique values and hierarchies.
	- Used for reporting and slicing data.

SQL Sever Functions USed:
	- DISTINCT
	- ORDER BY
==========================================================================
*/

-- Change the database context:
USE AnalyticsDB;
GO

-- Retrieve a list of unique countries from which customers originate:
SELECT	DISTINCT Country
FROM final.dim_customers;
GO

-- Retrieve a list of unique categories, subcategories, and products
SELECT
    Category,
    Sub_Category,
    Product_Name 
FROM final.dim_products
ORDER BY  Category, Sub_Category, Product_Name;
GO
