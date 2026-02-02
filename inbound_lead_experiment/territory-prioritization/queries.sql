-- Territory Prioritization Score (Country-wide Sales Strategy)
-- Assumes shifts has: shift_date, revenue_usd, filled (0/1), and territory fields (region/state/city).

-- A) Territory scoring using the best available geography field.
-- If you have "region" use that. If not, replace region with state or city.

SELECT
  region AS territory,
  COUNT(*) AS shifts_total,
  SUM(CASE WHEN filled = 1 THEN 1 ELSE 0 END) AS shifts_filled,
  SUM(CASE WHEN filled = 0 THEN 1 ELSE 0 END) AS shifts_unfilled,
  ROUND(AVG(CASE WHEN filled = 1 THEN 1.0 ELSE 0.0 END), 3) AS fill_rate,
  SUM(revenue_usd) AS revenue_usd,
  ROUND(SUM(revenue_usd) * 1.0 / COUNT(*), 2) AS revenue_per_shift,

  -- Revenue upside: unfilled rate * revenue (simple proxy for missed opportunity)
  ROUND((1.0 - AVG(CASE WHEN filled = 1 THEN 1.0 ELSE 0.0 END)) * SUM(revenue_usd), 2) AS revenue_upside_score

FROM shifts
GROUP BY region
HAVING shifts_total >= 5
ORDER BY revenue_upside_score DESC;

-- B) Month-over-month territory trend (supports planning)
SELECT
  region AS territory,
  substr(shift_date, 1, 7) AS year_month,
  SUM(revenue_usd) AS revenue_usd,
  ROUND(AVG(CASE WHEN filled = 1 THEN 1.0 ELSE 0.0 END), 3) AS fill_rate,
  COUNT(*) AS shifts_total
FROM shifts
GROUP BY region, year_month
ORDER BY territory, year_month;
