-- Drop database if exists
DROP DATABASE IF EXISTS DataWarehouse;

-- Create database
CREATE DATABASE DataWarehouse;

-- Use database
USE DataWarehouse;

-- Drop schemas/databases if they exist
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create schemas/databases
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;

-- Verify
SHOW DATABASES;
