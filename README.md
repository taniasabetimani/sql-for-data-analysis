# 🗄️ SQL for Data Analysis

[![SQLite](https://img.shields.io/badge/SQLite-3.0-blue)](https://www.sqlite.org/)
[![Python](https://img.shields.io/badge/Python-3.9%2B-blue)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📌 Project Overview

A comprehensive SQL practice repository using the **Online Retail** e-commerce dataset (1M+ transactions). Contains **60+ SQL queries** organized by complexity – from basic `SELECT` statements to advanced **window functions** and **15 real-world business cases**.

**Key insights uncovered:**
- 🇬🇧 **UK dominates** with **£14.7M revenue** from 725K orders
- 🏆 **Top customer** spent **£608K** across 145 orders
- 📈 **November** consistently drives highest revenue (**£1.17M** peak)
- 💰 **High-frequency customers** (>10 orders) spend **55% more per order** than low-frequency ones
- 🔄 **844 customers** were retained from 2009 to 2010
---

## 🛠️ Technologies

- **SQLite** – lightweight file-based database
- **Python** – data processing and database creation
- **Pandas** – query execution and visualization from Python

---

## 📁 Repository Structure

```
sql-for-data-analysis/
│
├── README.md
├── requirements.txt
├── create_database.py          # Converts CSV to SQLite
│
├── queries/
│   ├── 01_basics.sql           # SELECT, WHERE, ORDER BY, LIMIT
│   ├── 02_aggregations.sql     # GROUP BY, HAVING, COUNT, SUM, AVG
│   ├── 03_joins.sql            # INNER, LEFT, SELF JOIN
│   ├── 04_subqueries.sql       # Subqueries, EXISTS, IN
│   ├── 05_window_functions.sql # ROW_NUMBER, RANK, LAG, LEAD
│   ├── 06_datetime.sql         # Date functions, extracting year/month
│   └── 07_business_cases.sql   # 15 real-world business questions


## 🚀 How to Use

### 1. Clone this repository
```bash
git clone https://github.com/yourusername/sql-for-data-analysis.git
cd sql-for-data-analysis
```

### 2. Place your data
Download the **UCI Online Retail II** dataset https://archive.ics.uci.edu/dataset/502/online+retail+ii and place `online_retail_II.xlsx` in the root folder.

### 3. Create the SQLite database
```bash
python create_database.py
```

This generates `retail.db` with two tables:
- **`orders`** – transaction-level data (1M+ rows)
- **`customers`** – customer-level RFM summary

### 4. Explore the queries
Open any `.sql` file in the `/queries` folder. Run them using:
- **SQLite extension** in VSCode (recommended)
- **SQLite CLI**: `sqlite3 retail.db < queries/01_basics.sql`
- **DBeaver** or **SQLite Studio** (free GUIs)
- **Python** (see `notebooks/sql_in_python.ipynb`)

---

## 📊 Query Categories & Sample Results

| Category | File | Description |
|----------|------|-------------|
| **Basics** | `01_basics.sql` | SELECT, WHERE, ORDER BY, LIMIT, DISTINCT |
| **Aggregations** | `02_aggregations.sql` | GROUP BY, HAVING, COUNT, SUM, AVG, monthly revenue |
| **Joins** | `03_joins.sql` | INNER, LEFT, SELF JOIN, customer-order relationships |
| **Subqueries** | `04_subqueries.sql` | Correlated subqueries, EXISTS, IN, top 10% customers |
| **Window Functions** | `05_window_functions.sql` | ROW_NUMBER, RANK, LAG, LEAD, moving averages |
| **Datetime** | `06_datetime.sql` | Date extraction, month-over-month growth, recency |
| **Business Cases** | `07_business_cases.sql` | 15 real-world questions with business context |

### 🔍 Sample Query Results

#### Top 5 Countries by Revenue
| Country | Revenue | Orders |
|---------|---------|--------|
| United Kingdom | £14,723,147 | 725,250 |
| EIRE | £621,631 | 15,743 |
| Netherlands | £554,232 | 5,088 |
| Germany | £431,262 | 16,694 |
| France | £355,257 | 13,812 |

#### Top Customers by Lifetime Value
| Customer | Orders | Lifetime Value | Avg Order |
|----------|--------|----------------|-----------|
| 18102 | 145 | £608,821 | £575 |
| 14646 | 151 | £528,602 | £137 |
| 14156 | 156 | £313,946 | £77 |

#### Monthly Revenue Growth (Selected Months)
| Month | Revenue | Growth |
|-------|---------|--------|
| 2010-11 | £1,172,336 | +13.09% |
| 2011-11 | £1,161,817 | +11.79% |
| 2010-12 | £884,591 | -24.54% |

#### High vs Low Frequency Customers
| Group | Orders | Avg Order Value | Total Revenue |
|-------|--------|-----------------|---------------|
| High Frequency (>10) | 20,755 | £26.23 | £11,563,847 |
| Low Frequency (≤10) | 16,214 | £16.95 | £6,179,581 |

---

## 💡 Featured Query: Pareto Analysis

```sql
-- Top 20% of customers drive what % of revenue?
WITH customer_spend AS (
    SELECT CustomerID, SUM(TotalPrice) AS total_spent
    FROM orders
    GROUP BY CustomerID
),
ranked AS (
    SELECT CustomerID, total_spent,
           ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS rank_order,
           COUNT(*) OVER () AS total_customers
    FROM customer_spend
)
SELECT SUM(total_spent) * 100.0 / (SELECT SUM(total_spent) FROM customer_spend) AS pct_revenue
FROM ranked
WHERE rank_order <= ROUND(total_customers * 0.2, 0);
```

---

## 🎯 Why This Repository?

| Aspect | Why It's Impressive |
|--------|---------------------|
| **Structure** | 7 organized SQL files (not one monster file) |
| **Scope** | 60+ queries – shows commitment |
| **Real Data** | Not dummy data – it's a 1M+ row e-commerce dataset |
| **Business Focus** | Shows you understand *why* you're writing queries, not just *how* |
| **Python Integration** | Bridges SQL and Python (exactly how industry works) |
| **Business Insights** | Answers real questions: churn risk, customer retention, Pareto analysis |

---

## 📈 Key Business Insights

From the **Business Cases** queries:

- **Customer Retention**: 844 customers purchased in both 2009 and 2010
- **Churn Risk**: Customers with no purchase in the last 90 days
- **Pareto**: Top 20% of customers drive ~80% of revenue
- **Product Analysis**: Top 5 products by revenue identified
- **Seasonality**: November and September show highest revenue spikes

---

## 👤 Author

**Tania Sabet Imani** 

[![GitHub](https://img.shields.io/badge/GitHub-Profile-black)](https://github.com/taniasabetimani)
---

## 📄 License

MIT License – feel free to use, modify, and share.
