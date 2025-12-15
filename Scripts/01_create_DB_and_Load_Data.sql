/*
=========================================================================
         DDL & DML Scripts: Create Database Setup and Data Load
=========================================================================
Project: SQL Server Data Analytics Project
Script: 01_create_DB_and_Load_Data.sql
Author: Abdul Muqtadeer Baag

Purpose:
	- This script initializes the analytics environment by:
		- Creating the database 'AnalyticsDB' and required schema 'final'.
		- Creating tables used for analysis.
		- This procedure Truncates and Reloads data into tables.
		- Uses the 'BULK INSERT' Loads data from CSV files into tables.
		
Warning:
   - Running this script will DROP and recreate the database. 
   - All existing data will be permanently deleted. Use with caution .
==========================================================================
*/

-- Use the master DB:
  USE Master;
  GO

-- Drop AnalyticsDB if it already exists:
  IF DB_ID('AnalyticsDB') IS NOT NULL
    BEGIN
        ALTER DATABASE [AnalyticsDB]
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        
        DROP DATABASE [AnalyticsDB];
        PRINT 'AnalyticsDB Dropped Successfully!';
    END;
  ELSE
    BEGIN
        PRINT 'AnalyticsDB doesn`t exist. Creating a new Database...';
    END;
  GO

-- Create the Database:
  CREATE DATABASE [AnalyticsDB];
  GO

-- Use the Database:
  USE [AnalyticsDB];
  Go

-- Check Current Database:
  SELECT DB_NAME() AS Database_Name;
  GO
    
-- Create Schema:
  CREATE SCHEMA [final]
    AUTHORIZATION dbo;
  Go

---------------------------------------------------------------------------
-- Create Table_1 'final.dim_customers':
CREATE TABLE final.dim_customers
(
	Customer_Key	INT,
	Customer_Id		INT,
	Customer_Number	VARCHAR(30),
	First_Name		VARCHAR(50),
	Last_Name		VARCHAR(50),
	Country			VARCHAR(20),
	Marital_Status	VARCHAR(20),
	Gender			VARCHAR(15),
	Birth_Date		DATE,
	Create_Date		DATE
);
GO

-- Create Table_2 'final.dim_products':
CREATE TABLE final.dim_products
(
	Product_Key		INT,
	Product_Id		INT,
	Product_Number	VARCHAR(30),
	Product_Name	VARCHAR(50),
	Category_Id		VARCHAR(20),
	Category		VARCHAR(30),
	Sub_Category	VARCHAR(30),
	Maintaince		VARCHAR(10),
	Cost			INT,
	Product_Line	VARCHAR(20),
	Start_Date		DATE
);
GO

-- Create Table_3 'final.fact_sales':
CREATE TABLE final.fact_sales
(
	Order_Number		VARCHAR(20),
	Product_Key			INT,
	Customer_Key		INT,
	Order_Date			DATE,
	Shipping_Date		DATE,
	Due_Date			DATE,
	Sales_Amount		INT,
	Quantity			INT,
	Price				INT
);
GO

----------------------------------------------------------------------------
-- Run from the project database:
   USE AnalyticsDB;
   GO
   -- Call Stored Procedure:
   EXEC final.load_data;
   GO

-- Create the Stored Procedure:
CREATE OR ALTER PROC final.load_data
AS
BEGIN
	DECLARE @start_time		  DATETIME,
			@end_time  		  DATETIME,
			@batch_start_time DATETIME,
			@batch_end_time	  DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=====================================';
		PRINT '          LOADING DATA';
		PRINT '=====================================';

--1. Loading final.dim_customers:
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: final.dim_customers';
		TRUNCATE TABLE final.dim_customers;
		PRINT '>> Inserting Data Into: final.dim_customers';
		BULK INSERT final.dim_customers
		FROM 'C:\SQL Server\Projects\SQL-Server-Data-Analytics-Project\Datasets\CSV_Files\final.dim_customers.csv'
		WITH (
				FIRSTROW = 2,			-- Skip header start from row 2.
				FIELDTERMINATOR = ',',  -- Columns separated by comma.
				ROWTERMINATOR = '\n',   -- Each row ends on new line.
				TABLOCK					-- Locks the table so other users can`t write during load.
			 );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' Second';
		PRINT '---------------------------';

--2. Loading final.dim_products:
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: final.dim_products';
		TRUNCATE TABLE final.dim_products;
		PRINT '>> Inserting Data Into: final.dim_products';
		BULK INSERT final.dim_products
		FROM 'C:\SQL Server\Projects\SQL-Server-Data-Analytics-Project\Datasets\CSV_Files\final.dim_products.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				TABLOCK
			 );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' Second';
		PRINT '---------------------------';

--3. Loading final.fact_sales:
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: final.fact_sales';
		TRUNCATE TABLE final.fact_sales;
		PRINT '>> Inserting Data Into: final.fact_sales';
		BULK INSERT final.fact_sales
		FROM 'C:\SQL Server\Projects\SQL-Server-Data-Analytics-Project\Datasets\CSV_Files\final.fact_sales.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',
				TABLOCK
			 );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR) + ' Second';
		PRINT '---------------------------';
		
		SET @batch_end_time = GETDATE();
		PRINT '=====================================';
		PRINT '     LOADING DATA IS COMPLELED!';
		PRINT '>> Total Load Duration: '+CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS VARCHAR)+' Second';
		PRINT '=====================================';
	END TRY

	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING!:'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message Number: ' + CAST (ERROR_NUMBER() AS VARCHAR);
		PRINT 'Error Message State: ' + CAST (ERROR_STATE() AS VARCHAR);
		PRINT '=========================================='
	END CATCH
END;
GO
