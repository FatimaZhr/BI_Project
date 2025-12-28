# End-to-End Business Intelligence & Data Mining Pipeline

## 📌 Project Overview
This project demonstrates a complete **Business Intelligence (BI) and Data Mining** workflow, transforming raw operational data into actionable strategic insights. 

Designed as part of the **Master's d'Excellence** curriculum, the system integrates data from a production environment, builds a Data Warehouse, visualizes key performance indicators, and applies Machine Learning algorithms to discover hidden business patterns.

## 🏗️ Architecture
The pipeline follows a standard BI architecture:
1.  **Source:** Operational SQL Server Database (`COMPTOIR`).
2.  **ETL Layer:** Data extraction, transformation, and loading into a Star Schema Data Warehouse using **Talend**.
3.  **Reporting Layer:** Interactive dashboards for sales and logistics analysis using **Power BI**.
4.  **Analytics Layer:** Predictive modeling (Clustering & Association Rules) using **Weka**.

## 🛠️ Technologies Used
* **ETL:** Talend Open Studio for Data Integration
* **Database:** Microsoft SQL Server (SSMS)
* **Visualization:** Microsoft Power BI Desktop
* **Machine Learning:** Weka 3.8
* **Languages:** SQL, Java (Talend backend)

---

## 🚀 Key Features

### 1. Data Engineering (ETL)
* **Objective:** Centralize scattered transaction data.
* **Solution:** Built a **Star Schema** Data Warehouse (`DW_COMPTOIR`) containing:
    * **Fact Table:** `FACT_VENTES` (Sales metrics)
    * **Dimensions:** `Dim_Client`, `Dim_Produit`, `Dim_Temps`
* **Tool:** Talend jobs were created to handle data cleaning, denormalization, and surrogate key generation.

### 2. Business Intelligence Dashboard
* **Objective:** Monitor company health.
* **Solution:** A Power BI Dashboard tracking:
    * Sales Trends over time (Line Charts).
    * Top Selling Products (Pareto/Bar Charts).
    * Geographic Performance (Maps/Tables).
    * Delivery KPI Analysis.

### 3. Advanced Analytics (Data Mining)
* **Clustering (K-Means):**
    * *Goal:* Analyze supply chain efficiency.
    * *Result:* Segmented clients into two distinct clusters: **"Fast Delivery" (1 day)** vs. **"Critical Delay" (20 days)**, allowing for targeted logistics improvements.
* **Association Rules (Apriori):**
    * *Goal:* Market Basket Analysis.
    * *Result:* Discovered strong purchasing patterns, including the rule: **"Customers who buy USB Keyboards also buy Cola Soda"** (100% Confidence), providing opportunities for cross-selling strategies.

---

## 📂 Project Structure
```text
/
├── 1_Database/          # SQL scripts for creating the DW Schema and Views
├── 2_ETL_Talend/        # Screenshots and documentation of Talend Jobs
├── 3_Reporting_PowerBI/ # The .pbix dashboard file and PDF exports
├── 4_Analytics_Weka/    # Pre-processed CSV datasets and Mining Results
└── README.md            # Project documentation
