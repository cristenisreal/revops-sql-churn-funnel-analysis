-- Outreach Scoring + Daily Queue (Outbound Email Strategy)
-- Assumes:
-- customers: customer_id, company_name, segment, competitor (nullable)
-- shifts: customer_id, shift_date, filled (0/1), revenue_usd
-- events (optional): customer_id, event_date, event_type

-- 1) Roll up customer signals for the last 30 days
WITH shift_rollup AS (
  SELECT
    customer_id,
    COUNT(*) AS shifts_30d,
    SUM(CASE WHEN filled = 0 THEN 1 ELSE 0 END) AS unfilled_30d,
    SUM(revenue_usd) AS revenue_30d
  FROM shifts
  WHERE shift_date >= DATE('now', '-30 days')
  GROUP BY customer_id
),
engagement_rollup AS (
  -- If you don't have an events table, you can remove this CTE and set engagement_14d = 1 below.
  SELECT
    customer_id,
    COUNT(*) AS engagement_14d
  FROM events
  WHERE event_date >= DATE('now', '-14 days')
  GROUP BY customer_id
),
scored AS (
  SELECT
    c.customer_id,
    c.company_name,
    c.segment,
    c.competitor,

    COALESCE(s.shifts_30d, 0) AS shifts_30d,
    COALESCE(s.unfilled_30d, 0) AS unfilled_30d,
    COALESCE(s.revenue_30d, 0) AS revenue_30d,
    COALESCE(e.engagement_14d, 1) AS engagement_14d,

    -- Score model (simple, explainable)
    (CASE WHEN c.competitor IS NOT NULL THEN 25 ELSE 0 END) +
    (CASE WHEN COALESCE(s.unfilled_30d, 0) >= 3 THEN 30 ELSE 0 END) +
    (CASE WHEN COALESCE(s.revenue_30d, 0) >= 5000 THEN 25 ELSE 0 END) +
    (CASE WHEN COALESCE(e.engagement_14d, 1) = 0 THEN 20 ELSE 0 END) AS outreach_score,

    -- Recommended outreach theme
    CASE
      WHEN c.competitor IS NOT NULL THEN 'Competitor-switch'
      WHEN COALESCE(s.unfilled_30d, 0) >= 3 THEN 'Fill-rate rescue'
      WHEN COALESCE(s.revenue_30d, 0) >= 5000 THEN 'Expansion'
      ELSE 'Activation'
    END AS outreach_theme,

    -- Reason codes (explainable)
    TRIM(
      (CASE WHEN c.competitor IS NOT NULL THEN 'competitor;' ELSE '' END) ||
      (CASE WHEN COALESCE(s.unfilled_30d, 0) >= 3 THEN 'unfilled_30d>=3;' ELSE '' END) ||
      (CASE WHEN COALESCE(s.revenue_30d, 0) >= 5000 THEN 'revenue_30d>=5000;' ELSE '' END) ||
      (CASE WHEN COALESCE(e.engagement_14d, 1) = 0 THEN 'no_engagement_14d;' ELSE '' END)
    ) AS reason_codes

  FROM customers c
  LEFT JOIN shift_rollup s ON c.customer_id = s.customer_id
  LEFT JOIN engagement_rollup e ON c.customer_id = e.customer_id
)

-- 2) Daily work queue (Top 50)
SELECT
  customer_id,
  company_name,
  segment,
  outreach_score,
  outreach_theme,
  shifts_30d,
  unfilled_30d,
  revenue_30d,
  engagement_14d,
  reason_codes
FROM scored
ORDER BY outreach_score DESC, revenue_30d DESC
LIMIT 50;
