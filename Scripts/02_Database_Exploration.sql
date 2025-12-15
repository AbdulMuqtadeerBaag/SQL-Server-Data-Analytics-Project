/*
=========================================================================
					    Database Exporation
=========================================================================
Project: SQL Server Data Analytics Project
Script: 02_Database_Exploration.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- Explore the database structure by listing all tables, schemas, and 
	inspecting column-level metadata.
	- This script helps in understanding the data model before analysis.

Tables Used:
	- INFORMATION_SCHEMA.TABLES
	- INFORMATION_SCHEMA.COLUMNS
=========================================================================
*/

-- Change the database context:
USE AnalyticsDB;
GO

-- Retrieve a list of all tables in the database:
SELECT
	TABLE_CATALOG,
	TABLE_SCHEMA,
	TABLE_NAME,
	TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;
GO

-- Retrieve all columns for a specific table (dim_customers):
SELECT
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE,
	CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
GO

-- Retrieve all columns for a specific table (dim_products):
SELECT
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE,
	CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';
GO

-- Retrieve all columns for a specific table (fact_sales):
SELECT
	COLUMN_NAME,
	DATA_TYPE,
	IS_NULLABLE,
	CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';
GO
