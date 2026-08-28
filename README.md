## Dashboard Screenshots

### **Overview (Executive)**
![Executive](https://github.com/chloeanz04/Olist-Dashboard/blob/main/page_1.png)

### **Delivery & Operations**
![Delivery & Operations](https://github.com/chloeanz04/Olist-Dashboard/blob/main/page_2.png)

### **Marketing**
![Marketing B2B](https://github.com/chloeanz04/Olist-Dashboard/blob/main/page_3.png)

---

## Key Analytical Insights

### Executive Summary
* **Revenue & Volume:** The platform generated a total revenue of R$7,386,051 across 53,775 total orders, maintaining an Average Order Value (AOV) of R$137.35.
* **Payment Preferences:** Credit cards heavily dominate customer purchasing habits, accounting for 79.05% of all revenue.
* **Customer Retention:** This is a significant area for potential growth, as repeat customers currently make up only 3% of the total customer base.
* **Purchasing Behavior:** Sales activity consistently peaks on weekdays between 10 AM and 4 PM, with the "Health Beauty" category driving the highest overall revenue.

### Delivery & Operations
* **Delivery Performance:** The overall average delivery time stands at 11.60 days, with a late delivery rate of 9.20%.
* **Root Cause Analysis:** Carrier shipping is the primary bottleneck, causing 84.11% of all late deliveries, while seller preparation delays account for only 15.89%.
* **Geographical Impact:** São Paulo (SP) experiences the highest absolute volume of delayed shipments with 1,591 late orders. However, despite SP having the highest volume, states like SE (50.00%) and PI (37.50%) suffer from the highest proportional rates of late orders.

### Marketing & B2B Sales Funnel
* **Funnel Conversion:** The B2B marketing funnel successfully converted 10.53% of its 8,000 total leads, closing 842 deals and generating R$676,851 in Marketing GMV.
* **Top Acquisition Channel:** "Organic Search" is the most effective acquisition channel for volume, bringing in the highest number of closed deals at 271.
* **Conversion Trends:** The marketing conversion rate showed a strong upward trajectory in early 2018, peaking at 15.31% in April 2018 before slightly cooling off.
* **Sales Team Performance:** Sales performance is top-heavy, with "Rep 08" significantly outperforming the rest of the team by closing 133 deals.

---

## Data Architecture & Workflow

To ensure robust reporting performance and maintain a scalable data model, this project implements a structured Data Warehousing approach:

1. **Data Ingestion:** Raw Olist datasets were imported directly into a PostgreSQL database.
2. **Data Warehousing (DWH):** SQL scripts were written and executed to clean the data, resolve inconsistencies, and construct optimized Fact and Dimension tables (Star Schema) within the database layer.
3. **Data Visualization:** Power BI was connected directly to the SQL database to fetch the processed DWH tables. This architecture minimizes the transformation load on Power Query, shifting the heavy computational lifting to the database engine. Complex DAX measures were then formulated to drive the dynamic visualizations and time-intelligence metrics.
