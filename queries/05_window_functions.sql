-- 1. ROW_NUMBER: Assign a sequential number to each customer ordered by total spend
SELECT CustomerID, 
       Monetary AS total_spent,
       ROW_NUMBER() OVER (ORDER BY Monetary DESC) AS row_num
FROM customers
LIMIT 10;

-- 2. RANK vs DENSE_RANK: Handle ties differently
SELECT CustomerID, 
       Monetary AS total_spent,
       RANK() OVER (ORDER BY Monetary DESC) AS rank_col,
       DENSE_RANK() OVER (ORDER BY Monetary DESC) AS dense_rank_col
FROM customers
LIMIT 10;

-- 3. NTILE(4): Divide customers into quartiles by spend
SELECT CustomerID, 
       Monetary AS total_spent,
       NTILE(4) OVER (ORDER BY Monetary DESC) AS spend_quartile
FROM customers
LIMIT 10;

-- 4. LAG: Previous order value for each customer (requires ordering by date)
SELECT Invoice,
       CustomerID,
       InvoiceDate,
       TotalPrice,
       LAG(TotalPrice) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS previous_order_value
FROM orders
LIMIT 20;

-- 5. LEAD: Next order value
SELECT Invoice,
       CustomerID,
       InvoiceDate,
       TotalPrice,
       LEAD(TotalPrice) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS next_order_value
FROM orders
LIMIT 20;

-- 6. Calculate gap between orders (in days) - requires dates
-- We'll convert InvoiceDate to date first
SELECT Invoice,
       CustomerID,
       InvoiceDate,
       TotalPrice,
       JULIANDAY(InvoiceDate) - LAG(JULIANDAY(InvoiceDate)) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS days_since_last_order
FROM orders
LIMIT 20;

-- 7. Running total: Cumulative sum per customer over time
SELECT Invoice,
       CustomerID,
       InvoiceDate,
       TotalPrice,
       SUM(TotalPrice) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS running_total
FROM orders
LIMIT 20;

-- 8. Moving average (3 orders): Average of last 3 orders for each customer
SELECT Invoice,
       CustomerID,
       InvoiceDate,
       TotalPrice,
       AVG(TotalPrice) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM orders
LIMIT 20;

-- 9. Ranking customers by frequency (with ties)
SELECT CustomerID, 
       Frequency,
       RANK() OVER (ORDER BY Frequency DESC) AS frequency_rank
FROM customers
LIMIT 10;

-- 10. Percentile rank: Where does each customer sit in the distribution?
SELECT CustomerID, 
       Monetary AS total_spent,
       PERCENT_RANK() OVER (ORDER BY Monetary) AS percentile_rank
FROM customers
LIMIT 10;

-- ============================================
-- BONUS: Economics Question
-- Who are the top 3 customers per country by total spend (using ROW_NUMBER with PARTITION)?
-- ============================================
WITH customer_spend AS (
    SELECT CustomerID, 
           Country, 
           SUM(TotalPrice) AS total_spent,
           ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(TotalPrice) DESC) AS country_rank
    FROM orders
    GROUP BY CustomerID, Country
)
SELECT CustomerID, Country, total_spent
FROM customer_spend
WHERE country_rank <= 3
ORDER BY Country, country_rank;