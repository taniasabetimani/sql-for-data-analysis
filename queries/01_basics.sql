-- ============================================
-- 01_basics.sql
-- SQL Basics: SELECT, WHERE, ORDER BY, LIMIT
-- ============================================

-- 1. Select all columns from orders (limit to 10 rows)
SELECT * FROM orders LIMIT 10;

-- 2. Select specific columns
SELECT Invoice, CustomerID, TotalPrice, Country FROM orders LIMIT 10;

-- 3. WHERE clause: Filter for UK customers
SELECT * FROM orders WHERE Country = 'United Kingdom' LIMIT 10;

-- 4. WHERE with numeric condition: Orders > $500
SELECT * FROM orders WHERE TotalPrice > 500 ORDER BY TotalPrice DESC LIMIT 10;

-- 5. WHERE with multiple conditions (AND)
SELECT * FROM orders 
WHERE Country = 'United Kingdom' AND TotalPrice > 200 
LIMIT 10;

-- 6. WHERE with OR
SELECT * FROM orders 
WHERE Country = 'United Kingdom' OR Country = 'France' 
LIMIT 10;

-- 7. WHERE with IN (list of values)
SELECT * FROM orders 
WHERE Country IN ('United Kingdom', 'France', 'Germany') 
LIMIT 10;

-- 8. WHERE with LIKE (pattern matching: descriptions starting with "REG")
SELECT * FROM orders 
WHERE Description LIKE 'REG%' 
LIMIT 10;

-- 9. ORDER BY: Sort by TotalPrice descending
SELECT Invoice, CustomerID, TotalPrice 
FROM orders 
ORDER BY TotalPrice DESC 
LIMIT 10;

-- 10. ORDER BY multiple columns (Country asc, TotalPrice desc)
SELECT Invoice, CustomerID, Country, TotalPrice 
FROM orders 
ORDER BY Country ASC, TotalPrice DESC 
LIMIT 10;

-- 11. LIMIT with OFFSET (pagination)
SELECT Invoice, TotalPrice FROM orders ORDER BY TotalPrice DESC LIMIT 5 OFFSET 10;

-- 12. DISTINCT: List all unique countries
SELECT DISTINCT Country FROM orders ORDER BY Country;

-- 13. COUNT: How many total rows?
SELECT COUNT(*) AS total_rows FROM orders;

-- 14. COUNT with WHERE: How many UK orders?
SELECT COUNT(*) AS uk_orders FROM orders WHERE Country = 'United Kingdom';

-- 15. IS NULL / IS NOT NULL: Find orders with missing descriptions
SELECT Invoice, StockCode FROM orders WHERE Description IS NULL;

-- ============================================
-- BONUS: Economics Question
-- What are the top 5 highest-value orders?
-- ============================================
SELECT Invoice, CustomerID, TotalPrice, Country 
FROM orders 
ORDER BY TotalPrice DESC 
LIMIT 5;