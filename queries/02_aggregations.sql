-- 1. Total revenue per country (GROUP BY)
SELECT Country, 
       SUM(TotalPrice) AS total_revenue,
       COUNT(*) AS order_count
FROM orders
GROUP BY Country
ORDER BY total_revenue DESC;

-- 2. Average order value per country
SELECT Country, 
       AVG(TotalPrice) AS avg_order_value,
       MIN(TotalPrice) AS min_order,
       MAX(TotalPrice) AS max_order
FROM orders
GROUP BY Country
ORDER BY avg_order_value DESC;

-- 3. Total revenue per customer
SELECT CustomerID, 
       SUM(TotalPrice) AS total_spent,
       COUNT(DISTINCT Invoice) AS order_count,
       AVG(TotalPrice) AS avg_order_value
FROM orders
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

-- 4. HAVING: Filter groups (countries with more than 100 orders)
SELECT Country, 
       COUNT(*) AS order_count,
       SUM(TotalPrice) AS total_revenue
FROM orders
GROUP BY Country
HAVING COUNT(*) > 100
ORDER BY total_revenue DESC;

-- 5. HAVING with revenue condition (countries with > $500K revenue)
SELECT Country, 
       SUM(TotalPrice) AS total_revenue
FROM orders
GROUP BY Country
HAVING SUM(TotalPrice) > 500000
ORDER BY total_revenue DESC;

-- 6. Number of distinct invoices per country
SELECT Country, 
       COUNT(DISTINCT Invoice) AS unique_invoices
FROM orders
GROUP BY Country
ORDER BY unique_invoices DESC;

-- 7. Total revenue by month (using string date)
SELECT SUBSTR(InvoiceDate, 1, 7) AS month,
       SUM(TotalPrice) AS monthly_revenue,
       COUNT(*) AS orders
FROM orders
GROUP BY month
ORDER BY month;

-- 8. Monthly revenue with percentage of total
SELECT SUBSTR(InvoiceDate, 1, 7) AS month,
       SUM(TotalPrice) AS monthly_revenue,
       ROUND(SUM(TotalPrice) * 100.0 / (SELECT SUM(TotalPrice) FROM orders), 2) AS pct_of_total
FROM orders
GROUP BY month
ORDER BY month;

-- 9. Average items per order
SELECT Invoice,
       SUM(Quantity) AS total_items
FROM orders
GROUP BY Invoice
ORDER BY total_items DESC
LIMIT 10;

-- 10. Top 5 customers by total spend (from orders table)
SELECT CustomerID, 
       SUM(TotalPrice) AS total_spent,
       COUNT(DISTINCT Invoice) AS num_orders
FROM orders
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 5;

-- ============================================
-- BONUS: Economics Question
-- Which country has the highest average order value?
-- ============================================
SELECT Country, 
       ROUND(AVG(TotalPrice), 2) AS avg_order_value
FROM orders
GROUP BY Country
HAVING COUNT(*) > 10 -- Exclude small samples
ORDER BY avg_order_value DESC
LIMIT 5;