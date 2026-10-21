
-- PORTFOLIO 3: COMMIT DEMONSTRATION
-- MIT 8103 Advanced Database Systems
-- Demonstrates a successful atomic transaction.

-- Prerequisite:
-- Run 01_transaction_setup.sql to establish initial balances.
-- Account A = 10000.00
-- Account B = 5000.00

BEGIN;

-- Deduct 2,000 from Account A.
UPDATE transaction_test
SET amount = amount - 2000
WHERE test_id = 1;

-- Add 2,000 to Account B.
UPDATE transaction_test
SET amount = amount + 2000
WHERE test_id = 2;

-- Permanently save both changes.
COMMIT;

-- Verify the committed balances.
SELECT
    test_id,
    description,
    amount
FROM transaction_test
ORDER BY test_id;

-- Expected result:
-- Account A = 8000.00
-- Account B = 7000.00
