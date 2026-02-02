# Outreach Scoring + Daily Queue (Outbound Email Strategy)

## Objective
Generate a prioritized outbound list using SQL scoring based on revenue signals and operational friction.

## Scoring Signals
- Competitor flag (displacement opportunity)
- Unfilled demand (fill-rate rescue)
- Revenue volume (expansion priority)
- Recent inactivity (save-at-risk accounts)

## Files
- `queries.sql` – scoring logic and daily outreach queue outputs

## Outcome
Produces a top 50 daily worklist with an outreach theme and explainable reason codes.
