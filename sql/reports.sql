-- ============================================================
-- (a) Order Totals
-- Output:
-- total_orders | total_revenue | avg_order_value
-- 180          | 99860.20      | 554.78
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    ROUND(
        SUM(
            o.quantity * p.price *
            (1 - COALESCE(o.discount_pct, 0) / 100.0)
        ),
        2
    ) AS total_revenue,
    ROUND(
        AVG(
            o.quantity * p.price *
            (1 - COALESCE(o.discount_pct, 0) / 100.0)
        ),
        2
    ) AS avg_order_value
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;
    
-- ============================================================
-- (b) COUNT(*) vs COUNT(column)
-- Output:
-- total_rows | rated_orders | unrated_orders
-- 180        | 165          | 15
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(rating) AS rated_orders,
    COUNT(*) - COUNT(rating) AS unrated_orders
FROM orders;

-- ============================================================
-- (c) LEFT JOIN
-- Output:
-- customer_id | name
-- C045        | Vihaan
-- ============================================================

SELECT
    c.customer_id,
    c.name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) = 0;

-- ============================================================
-- (c) NOT IN verification
-- Output:
-- customer_id | name
-- C045        | Vihaan
-- ============================================================

SELECT
    customer_id,
    name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);


-- ============================================================
-- (d) GROUP BY + HAVING
-- Output:
-- Jaipur      19   8   42.1
-- Lucknow     49   15  30.6
-- Bangalore   33   8   24.2
-- ============================================================

SELECT
    c.city,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.returned = 1 THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(
        100.0 * SUM(CASE WHEN o.returned = 1 THEN 1 ELSE 0 END) / COUNT(*),
        1
    ) AS return_rate_pct
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING return_rate_pct > 20
ORDER BY return_rate_pct DESC;


-- ============================================================
-- (e) Top 5 customers by spend
-- Tie-breaker:
-- Ordering by customer_id ensures deterministic results when
-- two customers have the same total spend.
--
-- Output:
-- C043 Reyansh 12920.00
-- C026 Isha     8371.60
-- C008 Meera    4564.60
-- C011 Arjun    4111.00
-- C042 Sanya    3785.00
-- ============================================================


SELECT
    c.customer_id,
    c.name,
    ROUND(
        SUM(
            o.quantity * p.price *
            (1 - COALESCE(o.discount_pct, 0) / 100.0)
        ),
        2
    ) AS total_spend
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
-- customer_id is the tie-breaker so tied spends always have a consistent order.
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 5;


-- ============================================================
-- (e) Rank 3-5 using LIMIT/OFFSET
-- Output:
-- C008 Meera
-- C011 Arjun
-- C042 Sanya
-- ============================================================


SELECT
    c.customer_id,
    c.name,
    ROUND(
        SUM(
            o.quantity * p.price *
            (1 - COALESCE(o.discount_pct, 0) / 100.0)
        ),
        2
    ) AS total_spend
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
-- customer_id is the tie-breaker so tied spends always have a consistent order.
ORDER BY total_spend DESC, c.customer_id ASC
LIMIT 3 OFFSET 2;


-- ============================================================
-- (f) Three-table JOIN
-- Output:
-- Haircare      54   44956.10
-- Skincare      60   27346.00
-- Babycare      30   16805.00
-- PersonalCare  36   10753.10
-- ============================================================


SELECT
    p.category,
    COUNT(*) AS order_count,
    ROUND(
        SUM(
            o.quantity * p.price *
            (1 - COALESCE(o.discount_pct, 0) / 100.0)
        ),
        2
    ) AS category_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY p.category
ORDER BY category_revenue DESC;


-- ============================================================
-- (g) LIKE
-- Output:
-- Exactly 10 rows
-- C001	Aarav
-- C003	Aditi
-- C004	Ananya
-- C011	Arjun
-- C021	Aryan
-- C030	Anika
-- C031	Aditya
-- C036	Aisha
-- C041	Ayaan
-- C044	Aria
-- ============================================================


SELECT
    customer_id,
    name
FROM customers
WHERE name LIKE 'A%';


-- ============================================================
-- (h) DISTINCT
-- Output:
-- Ad
-- Organic
-- Referral
-- Social
-- ============================================================


SELECT DISTINCT acquisition_source
FROM customers;


-- ============================================================
-- (i) ALTER TABLE
-- Output: 
-- Gold    28
-- Silver  17
-- ============================================================


ALTER TABLE customers
ADD COLUMN loyalty_tier VARCHAR(10);

SET SQL_SAFE_UPDATES = 0;
UPDATE customers
SET loyalty_tier =
    CASE
        WHEN city_tier = 1 THEN 'Gold'
        ELSE 'Silver'
    END;

SELECT
    loyalty_tier,
    COUNT(*) AS customer_count
FROM customers
GROUP BY loyalty_tier;


    
