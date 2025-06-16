/*
Before creating 'ETL_Datawarehouse' we need first to drop this database if it alerady exists
then recreate 
new one with same name,
Purpose: 
	- our objectif is to create 3 schemas: 'bronze', 'silver' & 'gold'
WARNING:
    Running this script will delete the existing 'ETL_Datawarehouse' database.
    All existing data will be lost. Please ensure proper backups are in place
    before executing this script.
*/


-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'ETL_Datawarehouse')
BEGIN
    ALTER DATABASE ETL_Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ETL_Datawarehouse;
END;
GO
-- Create the ETL_Datawarehouse database
CREATE DATABASE ETL_Datawarehouse;
USE ETL_Datawarehouse;

-- Createing schemas bronze, silver & gold
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
