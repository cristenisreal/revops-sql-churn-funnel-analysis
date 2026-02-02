-- Funnel metrics (sent -> open -> reply) by experiment variant
WITH sent AS (
  SELECT variant, COUNT(*) AS sent
  FROM events
  WHERE event_type = 'email_sent'
  GROUP BY variant
),
opened AS (
  SELECT variant, COUNT(*) AS opened
  FROM events
  WHERE event_type = 'email_open'
  GROUP BY variant
),
replied AS (
  SELECT variant, COUNT(*) AS replied
  FROM events
  WHERE event_type = 'email_reply'
  GROUP BY variant
)
SELECT
  s.variant,
  s.sent,
  COALESCE(o.opened, 0) AS opened,
  COALESCE(r.replied, 0) AS replied,
  ROUND(1.0 * COALESCE(o.opened, 0) / s.sent, 2) AS open_rate,
  ROUND(1.0 * COALESCE(r.replied, 0) / s.sent, 2) AS reply_rate
FROM sent s
LEFT JOIN opened o ON o.variant = s.variant
LEFT JOIN replied r ON r.variant = s.variant
ORDER BY s.variant;


-- Churn-risk flag: high usage historically but $0 revenue in the most recent window
-- High usage = 2+ filled shifts all time; recent window uses the latest dates in sample data
WITH hist AS (
  SELECT
    customer_id,
    SUM(CASE WHEN filled = 1 THEN 1 ELSE 0 END) AS filled_shifts_all_time
  FROM shifts
  GROUP BY customer_id
),
recent AS (
  SELECT
    customer_id,
    SUM(revenue_usd) AS revenue_recent
  FROM shifts
  WHERE shift_date >= '2026-01-03'
  GROUP BY customer_id
)
SELECT
  c.company_name,
  c.segment,
  h.filled_shifts_all_time,
  COALESCE(r.revenue_recent, 0) AS revenue_recent,
  CASE
    WHEN h.filled_shifts_all_time >= 2 AND COALESCE(r.revenue_recent, 0) = 0 THEN 'HIGH_RISK'
    ELSE 'OK'
  END AS churn_risk_flag
FROM customers c
JOIN hist h ON h.customer_id = c.customer_id
LEFT JOIN recent r ON r.customer_id = c.customer_id
ORDER BY churn_risk_flag DESC, revenue_recent ASC;


-- Competitor targeting list
SELECT
  company_name,
  segment,
  competitor,
  created_date
FROM customers
WHERE competitor IS NOT NULL
ORDER BY created_date DESC;


-- Revenue trend by segment and month
SELECT
  c.segment,
  substr(s.shift_date, 1, 7) AS year_month,
  SUM(s.revenue_usd) AS revenue_usd
FROM shifts s
JOIN customers c ON c.customer_id = s.customer_id
GROUP BY c.segment, year_month
ORDER BY c.segment, year_month;
