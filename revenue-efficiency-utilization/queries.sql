-- Revenue Efficiency & Utilization Optimization

-- High-revenue accounts with unfilled demand
SELECT
  c.customer_id,
  c.company_name,
  c.segment,
  COUNT(s.shift_id) AS total_shifts,
  SUM(CASE WHEN s.filled = 0 THEN 1 ELSE 0 END) AS unfilled_shifts,
  SUM(s.revenue_usd) AS total_revenue,
  ROUND(SUM(s.revenue_usd) * 1.0 / COUNT(s.shift_id), 2) AS revenue_per_shift
FROM customers c
JOIN shifts s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.company_name, c.segment
HAVING unfilled_shifts >= 2
ORDER BY total_revenue DESC;

-- Revenue efficiency ranking
SELECT
  c.customer_id,
  c.company_name,
  ROUND(SUM(s.revenue_usd) * 1.0 / COUNT(s.shift_id), 2) AS revenue_per_shift
FROM customers c
JOIN shifts s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY revenue_per_shift DESC;

-- Repeated unfilled shifts (supply–demand friction)
SELECT
  customer_id,
  COUNT(*) AS unfilled_count
FROM shifts
WHERE filled = 0
GROUP BY customer_id
HAVING unfilled_count >= 2;
