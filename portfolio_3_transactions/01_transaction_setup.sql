
-- PORTFOLIO 3: TRANSACTION TEST SETUP
-- MIT 8103 Advanced Database Systems
-- Case Study: CDR Analysis System

-- Create a separate table for transaction experiments.
-- This does not modify the main CDR dataset.

CREATE TABLE IF NOT EXISTS transaction_test (
    test_id INTEGER PRIMARY KEY,
    description VARCHAR(100),
    amount NUMERIC(12,2)
);

-- Reset the test environment.
TRUNCATE TABLE transaction_test;

-- Insert two fictional accounts.
INSERT INTO transaction_test
    (test_id, description, amount)
VALUES
    (1, 'Account A', 10000.00),
    (2, 'Account B', 5000.00);

-- Verify the initial balances.
SELECT *
FROM transaction_test
ORDER BY test_id;
