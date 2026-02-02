# Revenue Operations SQL: Churn, Funnel, and Experiment Analysis

This project demonstrates how I use SQL to answer common Revenue Strategy & Operations questions, including:

- Which outbound experiment variant performs better?
- Which high-utilization customers show churn risk signals?
- How revenue trends by segment over time
- How to build clean, repeatable analysis for decision-making
- Inbound lead growth measurement using SQL A/B testing (+75% lift target)


## Tools
- SQL (SQLite)
- Relational modeling
- Funnel analysis
- KPI reporting

## Project Structure
- `schema.sql` – database schema
- `seed.sql` – sample data
- `queries.sql` – analysis queries

## Example Questions Answered
- Funnel conversion rates (sent → open → reply)
- Churn-risk identification for high-usage customers
- Competitor-sourced account targeting
- Revenue trends by segment and month
- Revenue efficiency and utilization optimization (revenue per shift, unfilled demand)
- Territory prioritization scoring to guide country-wide sales focus (revenue upside + fill gaps)
- Outbound email strategy using SQL lead scoring and a prioritized daily outreach queue


## How to Run
```bash
sqlite3 revops.db < schema.sql
sqlite3 revops.db < seed.sql
sqlite3 -header -column revops.db < queries.sql
