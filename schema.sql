DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS shifts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS experiments;

CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY,
  company_name TEXT NOT NULL,
  segment TEXT NOT NULL,
  created_date TEXT NOT NULL,
  competitor TEXT
);

CREATE TABLE shifts (
  shift_id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  shift_date TEXT NOT NULL,
  filled INTEGER NOT NULL,
  revenue_usd REAL NOT NULL,
  region TEXT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE experiments (
  experiment_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  variant TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL
);

CREATE TABLE events (
  event_id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  event_time TEXT NOT NULL,
  event_type TEXT NOT NULL,
  experiment_id INTEGER,
  variant TEXT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (experiment_id) REFERENCES experiments(experiment_id)
);
