# Manufacturing Database Creation and Data Migration

## Overview
This project focuses on designing and building a structured manufacturing database, migrating raw operational data into a relational SQL environment, and preparing the data for downstream analytics and reporting.

The goal is to simulate a realistic manufacturing data workflow where raw, inconsistent production records are transformed into a normalized database schema that supports efficient querying, analysis, and business intelligence.

---

## Project Objectives
- Design a relational database for a manufacturing environment
- Normalize production-related data into well-structured tables
- Migrate raw data into SQL tables
- Clean and standardize inconsistent values during migration
- Build relationships between production, customers, components, and materials
- Enable analytical querying for operational insights
- Prepare the database for dashboarding and reporting

---

## Business Context
Manufacturing organizations often collect operational data from multiple disconnected sources such as spreadsheets, flat files, and legacy systems. These datasets are usually inconsistent, duplicated, and difficult to analyze directly.

This project addresses that problem by:
- centralizing manufacturing data into a single SQL database
- improving data quality through cleaning and transformation
- structuring the data for scalable reporting and analytics

The resulting database can support use cases such as:
- production tracking
- material usage analysis
- customer order monitoring
- quality and efficiency reporting
- future BI dashboard development

---

## Database Scope
The project models core manufacturing entities such as:

- **Customers**
- **Components**
- **Materials**
- **Production Orders**
- **Material Usage**
- **Machines**
- **Employees**
- **Quality Checks**

Depending on the version of the project, some tables may be fully populated using real-world inspired data, while others may be synthetically generated to simulate an enterprise manufacturing environment.

---

## Example Schema Design

### 1. Customers
Stores customer-related information.

**Fields may include:**
- `customer_id`
- `customer_name`
- `region`
- `contact_details`

### 2. Materials
Stores raw material details.

**Fields may include:**
- `material_id`
- `material_name`
- `unit`
- `material_type`

### 3. ProductionOrders
Captures planned or actual production activity.

**Fields may include:**
- `production_order_id`
- `production_date`
- `customer_id`
- `component_id`
- `planned_quantity`

### 4. MaterialUsage
Captures the quantity of each material used in a production order.

**Fields may include:**
- `material_usage_id`
- `production_order_id`
- `material_id`
- `quantity_used`

This table resolves the many-to-many relationship between production orders and materials.

.... 
---

## Normalization Approach
The database design follows normalization principles to reduce redundancy and improve data integrity.

For example:
- customer details are separated into a `Customers` table
- component details are stored in a `Components` table
- material details are stored in a `Materials` table
- production activity is captured in `ProductionOrders`
- material consumption is handled separately in `MaterialUsage`

This prevents duplication and makes the database easier to maintain and query.

---

## Data Migration Workflow
The migration process typically includes the following steps:

1. **Raw Data Collection**
   - Import source files such as CSV or Excel datasets

2. **Data Profiling**
   - Inspect null values, duplicates, inconsistent naming, and invalid formats

3. **Data Cleaning**
   - Standardize text values
   - Fix unit inconsistencies
   - remove duplicates
   - handle missing values

4. **Transformation**
   - split raw fields into normalized entities
   - generate surrogate keys where needed
   - map raw values into relational tables

5. **Loading**
   - insert cleaned data into SQL tables
   - enforce primary and foreign key constraints

---

## Example Data Cleaning Tasks
Some example cleaning tasks performed in this project include:
- standardizing unit names such as `meter`, `meters`, and `m`
- normalizing values like `sq ft`, `sqft`, and `square feet` into `sq_ft`
- trimming whitespace
- converting inconsistent text casing
- validating numeric quantity columns
- handling duplicate production rows

---

## Tech Stack
- **SQL Server / T-SQL**
- **Power BI** (optional future extension for reporting)

---

## Example Analytical Questions
Once the database is created, it can support queries such as:

- Which customers requested the highest production volume?
- Which components were produced most frequently?
- How much raw material was consumed over time?
- Which materials are used most heavily across production orders?
- What is the daily or monthly production trend?
- Which machines contribute most to output or downtime?
- What is the defect rate by component or machine?

