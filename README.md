<h1 align="center">🏭 Manufacturing Data System</h1>

<p align="center">
  <img src="https://readme-typing-svg.herokuapp.com?size=22&duration=3000&color=36BCF7&center=true&vCenter=true&width=700&lines=From+Messy+Excel+to+Structured+SQL;Designing+Data+Systems%2C+Not+Just+Tables;Built+for+Real-World+Manufacturing+Data" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Focus-Data%20Engineering-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Rows-10K%2B-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Database-SQL%20Server-green?style=for-the-badge" />
</p>

---

## 📌 Overview

Most data projects don’t fail at analysis.  
They fail before that — when the data is still messy, inconsistent, and unreliable.

This project focuses on building a **structured manufacturing database from raw operational data**, transforming scattered inputs into a system ready for analytics and decision-making.

👉 Not just storing data — designing a system that **prevents bad data from entering**

---

## 🧠 Problem

Manufacturing data often comes from:
- spreadsheets  
- flat files  
- legacy systems  

And it looks like this:
- duplicated  
- inconsistent  
- hard to query  

The challenge wasn’t writing SQL.

The challenge was:

👉 **making the data usable in the first place**

---

## ⚙️ What This System Does

- Transforms raw production data into a **normalized relational schema**  
- Enforces **data integrity using constraints & relationships**  
- Cleans inconsistencies during migration  
- Structures data for **analytics, reporting, and BI use cases**  

---

## 🏗️ System Design

### Core Entities

- Customers  
- Components  
- Materials  
- Production Orders  
- Material Usage  
- Machines  
- Employees  
- Quality Checks  

---

### Example Relationship

ProductionOrders
↓
MaterialUsage (many-to-many bridge)
↓
Materials

👉 Designed to reflect **real manufacturing workflows**, not just textbook schemas

---

## 🧩 Normalization Strategy

Instead of dumping everything into one table:

- Customers → separate entity  
- Materials → separate entity  
- Production → separate entity  
- Usage → bridge table  

👉 Reduces redundancy  
👉 Improves consistency  
👉 Makes queries faster and cleaner  

---

## 🔄 Data Migration Pipeline

Raw Data → Profiling → Cleaning → Transformation → SQL Tables

### Key Steps

1. Data profiling (nulls, duplicates, inconsistencies)  
2. Cleaning (units, casing, formats)  
3. Transformation (splitting into entities)  
4. Loading with constraints  

---

## 🧹 Real Cleaning Work (Not Just Theory)

- Standardized units: `meter`, `meters`, `m` → `m`  
- Normalized: `sq ft`, `sqft`, `square feet` → `sq_ft`  
- Trimmed whitespace & fixed casing  
- Removed duplicate production records  
- Validated numeric fields  
- Handled missing values  

👉 This is where most of the real effort went

---

## ⚡ Key Insight

Writing queries is easy.

Designing a system where:

👉 bad data **cannot enter**  
👉 relationships **make sense**  
👉 analysis becomes **simple**

That’s the real work.

---

## 📊 What This Enables

Once structured, the system supports:

- Production tracking  
- Material consumption analysis  
- Customer demand insights  
- Machine performance monitoring  
- Quality and defect analysis  
- BI dashboards (Power BI ready)  

---

## 🛠️ Tech Stack

<p align="center">
  <img src="https://skillicons.dev/icons?i=postgres,mysql" />
</p>

<p align="center">
  SQL Server • T-SQL • Power BI (planned)
</p>

---

## 🧠 What I Learned

- Data engineering > just writing queries  
- Cleaning data is harder than modeling  
- Good schema design simplifies everything downstream  
- Data integrity matters more than speed  

---

## 🚀 Why This Matters

Most ML/analytics projects assume clean data.

Real systems don’t have that luxury.

This project focuses on:

👉 building the **foundation** everything else depends on

---

## 📫 Connect

- LinkedIn: https://www.linkedin.com/in/faheemb  
- Email: adahm7114@gmail.com  

---

<p align="center">
  ⭐ If you found this useful, consider starring the repo!
</p>


