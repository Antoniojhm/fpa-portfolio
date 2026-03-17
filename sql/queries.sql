-- ══════════════════════════════════════════════
-- FORGE Analytics · SQL Query Library
-- ══════════════════════════════════════════════

-- ── QUERY 1: Total revenue by segment ─────────
-- Question: How much revenue does each customer
-- segment generate in total?
SELECT
    segment,
    ROUND(SUM(revenue), 2)        AS total_revenue,
    COUNT(DISTINCT customer_id)   AS active_customers,
    ROUND(AVG(revenue), 2)        AS avg_monthly_revenue
FROM revenue_transactions
GROUP BY segment
ORDER BY total_revenue DESC;


-- ── QUERY 2: Monthly revenue trend ────────────
-- Question: How is total revenue growing month
-- over month across all segments?
SELECT
    month,
    ROUND(SUM(revenue), 2)  AS total_revenue,
    COUNT(DISTINCT customer_id) AS active_customers
FROM revenue_transactions
GROUP BY month
ORDER BY month ASC;


-- ── QUERY 3: Revenue by segment per month ─────
-- Question: How does each segment perform
-- month by month?
SELECT
    month,
    segment,
    ROUND(SUM(revenue), 2) AS revenue
FROM revenue_transactions
GROUP BY month, segment
ORDER BY month ASC, segment ASC;


-- ── QUERY 4: Budget vs actual by department ───
-- Question: Which departments are over or
-- under budget?
SELECT
    department,
    ROUND(SUM(budgeted_opex), 2)  AS total_budget,
    ROUND(SUM(actual_opex), 2)    AS total_actual,
    ROUND(SUM(variance), 2)       AS total_variance,
    ROUND(SUM(variance) / SUM(budgeted_opex) * 100, 1) AS variance_pct
FROM budget
GROUP BY department
ORDER BY total_variance ASC;


-- ── QUERY 5: Headcount and payroll by dept ────
-- Question: How many employees and what is
-- the total salary cost per department?
SELECT
    department,
    COUNT(employee_id)            AS headcount,
    ROUND(SUM(salary), 2)         AS total_annual_salary,
    ROUND(AVG(salary), 2)         AS avg_salary
FROM headcount
GROUP BY department
ORDER BY total_annual_salary DESC;


-- ── QUERY 6: Top 10 customers by revenue ──────
-- Question: Who are our highest value customers?
SELECT
    c.company_name,
    c.segment,
    c.country,
    ROUND(SUM(r.revenue), 2) AS total_revenue
FROM revenue_transactions r
JOIN customers c ON r.customer_id = c.customer_id
GROUP BY c.company_name, c.segment, c.country
ORDER BY total_revenue DESC
LIMIT 10;


-- ── QUERY 7: ARR summary ──────────────────────
-- Question: What is our current total ARR
-- broken down by segment?
SELECT
    c.segment,
    COUNT(ct.contract_id)       AS num_contracts,
    ROUND(SUM(ct.arr), 2)       AS total_arr,
    ROUND(AVG(ct.mrr), 2)       AS avg_mrr
FROM contracts ct
JOIN customers c ON ct.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_arr DESC;