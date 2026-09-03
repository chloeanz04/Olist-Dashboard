## Dashboard Screenshots

### **Executive Overview**
Provides an executive-level view of revenue, order volume, customer behavior, payment preferences, and purchasing patterns.
![Executive Overview](https://github.com/chloeanz04/Olist-Dashboard/blob/main/page_1.png)

### **Delivery & Operations**
Analyzes delivery performance, late-order trends, shipping bottlenecks, and geographic patterns across Brazilian states.
![Delivery & Operations](https://github.com/chloeanz04/Olist-Dashboard/blob/main/page_2.png)

### **Marketing & B2B Sales Funnel**
Evaluates lead acquisition, conversion performance, marketing channels, and sales representative performance.
![Marketing & B2B Sales Funnel](https://github.com/chloeanz04/Olist-Dashboard/blob/main/page_3.png)

> **Note:** The Executive Overview and Marketing & B2B Sales Funnel dashboards shown above focus on **2018** to provide a consistent reporting period for the analysis.

---

## Key Analytical Insights

### Executive Overview

* **Revenue & Volume:** In 2018, the platform generated **R$7.39M in revenue** across **53,775 orders**, with an **Average Order Value (AOV) of R$137.35**.
* **Payment Preferences:** Credit cards accounted for **79.05% of total revenue**, making them the dominant payment method.
* **Customer Retention:** Repeat customers represented only **3% of the customer base**, indicating an opportunity to strengthen customer retention and repeat purchases.
* **Purchasing Behavior:** Sales activity peaked consistently on weekdays between **10 AM and 4 PM**, while **Health & Beauty** was the highest-revenue product category.

### Delivery & Operations

* **Delivery Performance:** The average delivery time was **11.60 days**, with a **9.20% late delivery rate** in 2018.
* **Root Cause Analysis:** Carrier shipping delays accounted for **84.11% of late deliveries**, compared with **15.89% attributed to seller preparation delays**.
* **Geographical Impact:** São Paulo (SP) recorded the highest absolute number of late orders at **1,591**. However, smaller states such as SE (**50.00%**) and PI (**37.50%**) experienced higher proportional late-delivery rates.

### Marketing & B2B Sales Funnel

* **Funnel Conversion:** The B2B marketing funnel converted **10.53% of 8,000 leads**, resulting in **842 closed deals** and **R$676,851 in Marketing GMV**.
* **Top Acquisition Channel:** **Organic Search** generated the highest number of closed deals, with **271 conversions**.
* **Conversion Trends:** The monthly conversion rate increased during early 2018, reaching a peak of **15.31% in April** before gradually declining.
* **Sales Team Performance:** **Rep 08** was the highest-performing sales representative, closing **133 deals**.

---

## Business Recommendations

Based on the analysis, several opportunities were identified:

* **Improve customer retention:** Develop post-purchase engagement and retention initiatives to increase repeat purchases.
* **Optimize logistics performance:** Prioritize carrier-level performance monitoring, given that carrier delays account for the majority of late deliveries.
* **Monitor high-risk regions:** Investigate states with high proportional late-delivery rates rather than focusing only on states with the largest absolute number of delays.
* **Strengthen high-performing acquisition channels:** Evaluate and scale strategies associated with Organic Search while monitoring conversion efficiency across other channels.
* **Support sales team performance:** Investigate the practices of high-performing representatives such as Rep 08 to identify potentially replicable sales strategies.

---

## Data Architecture & Workflow

The project follows a **PostgreSQL-based Data Warehousing architecture** to separate data preparation from reporting and visualization.

### 1. Data Ingestion

Raw Olist datasets were loaded into **PostgreSQL staging tables**, providing a structured layer for downstream data transformation.

### 2. Data Warehousing

SQL transformations were used to prepare analytical Fact and Dimension tables following a **Star Schema design**.

Key transformations include:

* Data standardization and cleaning
* Deduplication using window functions
* Geographic enrichment
* Customer first-purchase and cohort preparation
* Marketing funnel integration
* Fact and Dimension table construction

### 3. Business Intelligence

The processed DWH tables were connected to **Power BI** for analytical reporting. Power BI was primarily used for semantic modeling, DAX measures, time-based analysis, and interactive visualization, while data preparation and core transformations were performed in PostgreSQL.

### 4. Analytical Model

**Fact Tables**
* `fact_sales` — one row per order item
* `fact_payments` — one row per payment record
* `fact_funnel` — one row per marketing qualified lead

**Dimension Tables**
* `dim_customer` — customer attributes and cohort information
* `dim_seller` — seller and acquisition attributes
* `dim_product` — product and category attributes
* `dim_geolocation` — geographic reference data
* `dim_orders` — order-level reference

---

## SQL Techniques

The project applies SQL techniques commonly used in analytical workflows, including:

* CTEs for structured transformations
* Window functions such as `ROW_NUMBER()` for deduplication
* `CASE WHEN` for business logic
* Aggregations and date functions for analytical metrics
* Multi-table joins across transactional, customer, product, geographic, and marketing datasets
* Data standardization using `INITCAP()`, `REPLACE()`, and `COALESCE()`

---

## Tools & Technologies

* **PostgreSQL**
* **SQL**
* **Power BI**
* **DAX**
* **Data Warehousing**
* **Star Schema**
