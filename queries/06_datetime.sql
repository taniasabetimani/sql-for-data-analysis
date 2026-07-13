-- 1. Extract year from InvoiceDate
SELECT Invoice, 
       InvoiceDate,
       SUBSTR(InvoiceDate, 1, 4) AS invoice_year
FROM orders
LIMIT 10;

-- 2. Extract month
SELECT Invoice, 
       InvoiceDate,
       SUBSTR(InvoiceDate, 6, 2) AS invoice_month
FROM orders
LIMIT 10;

-- 3. Extract year-month (YYYY-MM)
SELECT Invoice, 
       InvoiceDate,
       SUBSTR(InvoiceDate, 1, 7) AS year_month
FROM orders
LIMIT 10;

-- 4. Count orders by year
SELECT SUBSTR(InvoiceDate, 1, 4) AS invoice_year,
       COUNT(*) AS order_count
FROM orders
GROUP BY invoice_year
ORDER BY invoice_year;

-- 5. Revenue by year and month
SELECT SUBSTR(InvoiceDate, 1, 7) AS year_month,
       SUM(TotalPrice) AS monthly_revenue
FROM orders
GROUP BY year_month
ORDER BY year_month;

-- 6. Month-over-month growth (using LAG)
WITH monthly AS (
    SELECT SUBSTR(InvoiceDate, 1, 7) AS year_month,
           SUM(TotalPrice) AS revenue
    FROM orders
    GROUP BY year_month
)
SELECT year_month,
       revenue,
       LAG(revenue) OVER (ORDER BY year_month) AS previous_month,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY year_month)) / LAG(revenue) OVER (ORDER BY year_month) * 100, 2) AS growth_pct
FROM monthly
ORDER BY year_month;

-- 7. Customers who bought in 2009 but not 2010 (new vs returning)
SELECT CustomerID, 
       MIN(SUBSTR(InvoiceDate, 1, 4)) AS first_year,
       MAX(SUBSTR(InvoiceDate, 1, 4)) AS last_year
FROM orders
GROUP BY CustomerID
HAVING first_year = '2009'
   AND last_year = '2009'
LIMIT 10;

-- 8. Recency: Days since last purchase (using JULIANDAY)
SELECT CustomerID,
       MAX(InvoiceDate) AS last_purchase_date,
       JULIANDAY('2011-12-10') - JULIANDAY(MAX(InvoiceDate)) AS recency_days
FROM orders
GROUP BY CustomerID
ORDER BY recency_days
LIMIT 10;

-- 9. Monthly active customers (by month)
SELECT SUBSTR(InvoiceDate, 1, 7) AS year_month,
       COUNT(DISTINCT CustomerID) AS active_customers
FROM orders
GROUP BY year_month
ORDER BY year_month;


SELECT SUBSTR(InvoiceDate, 1, 7) AS year_month,
       ROUND(SUM(TotalPrice) / COUNT(DISTINCT CustomerID), 2) AS avg_revenue_per_customer
FROM orders
GROUP BY year_month
ORDER BY avg_revenue_per_customer DESC
LIMIT 5;