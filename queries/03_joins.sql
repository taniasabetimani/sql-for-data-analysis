-- 1. INNER JOIN: Orders with customer RFM data
SELECT o.Invoice, 
       o.CustomerID, 
       o.TotalPrice AS order_value,
       c.Frequency, 
       c.Monetary AS total_customer_spend
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
LIMIT 10;

-- 2. LEFT JOIN: All customers, even if they have no orders (shouldn't happen here)
SELECT c.CustomerID, 
       c.Frequency, 
       c.Monetary,
       o.Invoice,
       o.TotalPrice
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
LIMIT 10;

-- 3. Self JOIN: Find customers who bought the same product as another customer
-- (Find customers who bought StockCode '85123A')
SELECT DISTINCT o1.CustomerID AS customer1, 
                o2.CustomerID AS customer2,
                o1.StockCode
FROM orders o1
INNER JOIN orders o2 ON o1.StockCode = o2.StockCode
WHERE o1.CustomerID < o2.CustomerID -- Avoid duplicates
  AND o1.StockCode = '85123A'
LIMIT 10;

-- 4. JOIN with aggregation: Customer lifetime value (from orders) + RFM
SELECT c.CustomerID,
       c.Frequency AS rfm_frequency,
       c.Monetary AS rfm_monetary,
       COUNT(DISTINCT o.Invoice) AS actual_orders,
       SUM(o.TotalPrice) AS actual_total_spent
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY actual_total_spent DESC
LIMIT 10;

-- 5. JOIN with WHERE: High-value orders from high-frequency customers
SELECT o.Invoice,
       o.CustomerID,
       o.TotalPrice,
       c.Frequency
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
WHERE o.TotalPrice > 1000 
  AND c.Frequency > 10
ORDER BY o.TotalPrice DESC
LIMIT 10;

-- 6. JOIN with multiple conditions: Orders from UK, joined to customers with high frequency
SELECT o.Invoice,
       o.CustomerID,
       o.Country,
       o.TotalPrice,
       c.Frequency
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
WHERE o.Country = 'United Kingdom' 
  AND c.Frequency > 20
ORDER BY o.TotalPrice DESC
LIMIT 10;

SELECT 
    CASE 
        WHEN c.Frequency > 10 THEN 'High Frequency (>10)'
        ELSE 'Low Frequency (≤10)'
    END AS frequency_group,
    COUNT(DISTINCT o.Invoice) AS total_orders,
    AVG(o.TotalPrice) AS avg_order_value,
    SUM(o.TotalPrice) AS total_revenue
FROM customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY frequency_group;