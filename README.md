# SQL-Data-Warehouse-Project

## Overview

This project demonstrates the design and implementation of a modern SQL Data Warehouse using Microsoft SQL Server.

The solution follows the **Medallion Architecture** approach:

* **Bronze Layer** → Raw data ingestion
* **Silver Layer** → Data cleansing and transformation
* **Gold Layer** → Business-ready dimensional model

The project integrates data from multiple CRM and ERP source systems, performs ETL processing, applies data quality checks, and delivers analytical datasets optimized for reporting and business intelligence.

---

## Architecture

<img width="1182" height="667" alt="image" src="docs/Data Architecture.jpeg" />

---

## Data Flow

<img width="986" height="559" alt="image" src="https://github.com/user-attachments/assets/7741241b-9c61-4104-9819-11b59307b76f" />

---

## Project Objectives

The primary goals of this project are:

* Build a scalable SQL Data Warehouse.
* Implement a Medallion Architecture.
* Design ETL pipelines using T-SQL.
* Integrate CRM and ERP source systems.
* Clean and standardize raw data.
* Validate data quality.
* Create analytical dimension and fact models.
* Prepare data for reporting and dashboarding.

---

## Project Structure

```text
SQL-Data-Warehouse-Project/
│
├── datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── scripts/
│   ├── init_database.sql
│   │
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   └── proc_load_silver.sql
│   │
│   └── gold/
│       └── ddl_gold.sql
│
├── tests/
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
└── README.md
```

---

## Source Systems

### CRM Data

Contains customer, product, and sales information.

| File              | Description          |
| ----------------- | -------------------- |
| cust_info.csv     | Customer information |
| prd_info.csv      | Product information  |
| sales_details.csv | Sales transactions   |

---

### ERP Data

Contains supporting business attributes.

| File            | Description           |
| --------------- | --------------------- |
| CUST_AZ12.csv   | Customer demographics |
| LOC_A101.csv    | Customer locations    |
| PX_CAT_G1V2.csv | Product categories    |

---

# Database Design

## Database

```sql
DataWarehouse
```

## Schemas

### Bronze

Stores raw source data without transformation.

### Silver

Stores cleaned and transformed data.

### Gold

Stores business-ready analytical views.

---

# Bronze Layer

## Purpose

The Bronze layer serves as the landing zone for raw source data.

### Characteristics

* Raw ingestion
* No transformations
* Historical source preservation
* Fast loading using BULK INSERT

---

## Bronze Tables

### CRM Tables

* bronze.crm_cust_info
* bronze.crm_prd_info
* bronze.crm_sales_details

### ERP Tables

* bronze.erp_cust_az12
* bronze.erp_loc_a101
* bronze.erp_px_cat_g1v2

---

## Bronze ETL Process

The stored procedure:

```sql
EXEC bronze.load_bronze;
```

Performs:

* Table truncation
* CSV ingestion
* Bulk loading
* Load duration logging
* Error handling

---

# Silver Layer

## Purpose

The Silver layer performs cleansing, standardization, and transformation.

---

## Transformations Implemented

### Customer Data

* Remove duplicates
* Keep latest customer record
* Trim unwanted spaces
* Standardize marital status
* Standardize gender values

Example:

```text
S → Single
M → Married

F → Female
M → Male
```

---

### Product Data

* Extract category IDs
* Normalize product lines
* Handle null costs
* Generate product validity periods

Example:

```text
M → Mountain
R → Road
T → Touring
S → Other Sales
```

---

### Sales Data

* Convert integer dates to DATE
* Validate order dates
* Recalculate incorrect sales values
* Correct invalid prices

Business Rule:

```text
Sales = Quantity × Price
```

---

### ERP Data

#### Customer Data

* Remove NAS prefixes
* Standardize genders
* Handle future birthdates

#### Location Data

Normalize country names:

```text
DE  → Germany
US  → United States
USA → United States
```

---

## Silver ETL Process

```sql
EXEC silver.load_silver;
```

Features:

* Data cleansing
* Data standardization
* Data enrichment
* Data validation
* Error handling

---

# Gold Layer

## Purpose

The Gold layer provides a business-ready analytical model.

The design follows a **Star Schema**.

---

## Star Schema

<img width="1016" height="671" alt="image" src="https://github.com/user-attachments/assets/2699e407-660c-4529-8729-d77c476499ac" />

---

## Dimension Tables

### gold.dim_customers

Contains:

* Customer information
* Demographics
* Country
* Gender
* Marital status

Generated surrogate key:

```sql
customer_key
```

---

### gold.dim_products

Contains:

* Product information
* Categories
* Subcategories
* Product lines
* Maintenance information

Generated surrogate key:

```sql
product_key
```

---

## Fact Table

### gold.fact_sales

Stores:

* Sales transactions
* Revenue
* Quantity sold
* Product relationships
* Customer relationships

Measures:

* Sales Amount
* Quantity
* Price

---

# Data Quality Checks

The project includes dedicated validation scripts.

---

## Silver Layer Validation

Checks include:

### Customer Data

* Duplicate IDs
* Null IDs
* Unwanted spaces
* Standardized values

### Product Data

* Duplicate products
* Invalid costs
* Invalid date ranges

### Sales Data

* Invalid dates
* Incorrect sales calculations
* Quantity/price inconsistencies

### ERP Data

* Invalid birthdates
* Country standardization
* Missing values

---

## Gold Layer Validation

Checks include:

### Dimension Validation

* Unique customer keys
* Unique product keys

### Referential Integrity

Validate relationships between:

```text
fact_sales
    ↔ dim_customers
    ↔ dim_products
```

Expected Result:

```text
No orphan records
```

---

# ETL Workflow

## Step 1

Create database and schemas

```sql
scripts/init_database.sql
```

---

## Step 2

Create Bronze tables

```sql
scripts/bronze/ddl_bronze.sql
```

---

## Step 3

Load Bronze data

```sql
EXEC bronze.load_bronze;
```

---

## Step 4

Create Silver tables

```sql
scripts/silver/ddl_silver.sql
```

---

## Step 5

Load Silver data

```sql
EXEC silver.load_silver;
```

---

## Step 6

Create Gold views

```sql
scripts/gold/ddl_gold.sql
```

---

## Step 7

Run Quality Checks

```sql
tests/quality_checks_silver.sql

tests/quality_checks_gold.sql
```

---

# SQL Concepts Demonstrated

### Database Design

* CREATE DATABASE
* CREATE SCHEMA
* CREATE TABLE
* CREATE VIEW

### ETL Development

* Stored Procedures
* BULK INSERT
* Data Transformation

### Data Cleaning

* TRIM()
* CASE Statements
* NULL Handling
* Standardization

### Window Functions

* ROW_NUMBER()
* LEAD()

### Data Validation

* Data Quality Rules
* Referential Integrity Checks

### Error Handling

* TRY...CATCH
* Logging
* Runtime Monitoring

---

# Technologies Used

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* T-SQL
* CSV Files
* Data Warehouse Modeling

---

# Key Skills Demonstrated

* Data Warehouse Design
* ETL Pipeline Development
* Data Modeling
* Star Schema Design
* Data Quality Management
* Data Cleansing
* SQL Performance Concepts
* Business Data Integration
* Dimensional Modeling
* Data Engineering Fundamentals

---
