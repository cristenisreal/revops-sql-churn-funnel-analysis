-- MARKETING EXPERIMENT READOUT: Inbound leads target +75% (1.75x)

-- 1) Inbound lead lift by variant
WITH lead_counts AS (
  SELECT
    variant,
    COUNT(*) AS inbound_leads,
    SUM(CASE WHEN qualified = 1 THEN 1 ELSE 0 END) AS qualified_leads
  FROM inbound_leads
  GROUP BY variant
),
session_counts AS (
  SELECT
    variant,
    COUNT(*) AS sessions
  FROM web_sessions
  GROUP BY variant
),
joined AS (
  SELECT
    s.variant,
    s.sessions,
    l.inbound_leads,
    l.qualified_leads,
    ROUND(1.0 * l.inbound_leads / s.sessions, 4) AS lead_conversion_rate,
    ROUND(1.0 * l.qualified_leads / l.inbound_leads, 4) AS mql_rate
  FROM session_counts s
  JOIN lead_counts l ON l.variant = s.variant
),
baseline AS (
  SELECT inbound_leads AS a_leads, lead_conversion_rate AS a_cvr
  FROM joined WHERE variant = 'A'
),
treatment AS (
  SELECT inbound_leads AS b_leads, lead_conversion_rate AS b_cvr
  FROM joined WHERE variant = 'B'
)
SELECT
  j.variant,
  j.sessions,
  j.inbound_leads,
  j.qualified_leads,
  j.lead_conversion_rate,
  j.mql_rate
FROM joined j
ORDER BY j.variant;

-- 2) Lift summary + target check (B vs A)
WITH a AS (
  SELECT COUNT(*) AS leads_a FROM inbound_leads WHERE variant='A'
),
b AS (
  SELECT COUNT(*) AS leads_b FROM inbound_leads WHERE variant='B'
)
SELECT
  leads_a,
  leads_b,
  ROUND(1.0 * (leads_b - leads_a) / leads_a, 3) AS lift_pct,
  CASE
    WHEN (1.0 * leads_b / leads_a) >= 1.75 THEN 'TARGET_MET (>= 75% lift)'
    ELSE 'TARGET_NOT_MET'
  END AS target_status
FROM a, b;

-- 3) Channel breakdown to show *where* lift comes from
SELECT
  channel,
  variant,
  COUNT(*) AS inbound_leads,
  SUM(CASE WHEN qualified=1 THEN 1 ELSE 0 END) AS qualified_leads
FROM inbound_leads
GROUP BY channel, variant
ORDER BY channel, variant;
