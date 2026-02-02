-- Marketing Experiment: Inbound lead growth (A/B)

DROP TABLE IF EXISTS web_sessions;
DROP TABLE IF EXISTS inbound_leads;
DROP TABLE IF EXISTS lead_attribution;

CREATE TABLE web_sessions (
  session_id     INTEGER PRIMARY KEY,
  session_date   TEXT NOT NULL,        -- YYYY-MM-DD
  channel        TEXT NOT NULL,        -- "organic","paid","referral","social","direct"
  variant        TEXT NOT NULL         -- "A" control, "B" treatment
);

CREATE TABLE inbound_leads (
  lead_id        INTEGER PRIMARY KEY,
  created_date   TEXT NOT NULL,        -- YYYY-MM-DD
  channel        TEXT NOT NULL,
  variant        TEXT NOT NULL,        -- "A" or "B"
  qualified      INTEGER NOT NULL      -- 1 = MQL, 0 = not qualified
);

-- Optional: connect leads to a specific experiment record you already have
CREATE TABLE lead_attribution (
  lead_id        INTEGER NOT NULL,
  experiment_id  INTEGER NOT NULL,
  variant        TEXT NOT NULL,
  PRIMARY KEY (lead_id, experiment_id),
  FOREIGN KEY (lead_id) REFERENCES inbound_leads(lead_id),
  FOREIGN KEY (experiment_id) REFERENCES experiments(experiment_id)
);
