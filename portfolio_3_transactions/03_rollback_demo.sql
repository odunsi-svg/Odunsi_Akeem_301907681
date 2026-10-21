
-- PORTFOLIO 3: ROLLBACK DEMONSTRATION
-- MIT 8103 Advanced Database Systems
-- Demonstrates cancellation of an uncommitted transaction.

-- Prerequisite:
-- Run 01_transaction_setup.sql and 02_commit_demo.sql.
-- Expected starting balances:
-- Account A = 8000.00
-- Account B = 7000.00

-- Check the balances before the transaction.
SELECT *
FROM transaction_test
ORDER BY test_id;

BEGIN;

-- Attempt to deduct 1,000 from Account A.
UPDATE transaction_test
SET amount = amount - 1000
WHERE test_id = 1;

-- Attempt to add 1,000 to Account B.
UPDATE transaction_test
SET amount = amount + 1000
WHERE test_id = 2;

-- Cancel both changes.
ROLLBACK;

-- Verify that the original balances remain unchanged.
SELECT
    test_id,
    description,
    amount
FROM transaction_test
ORDER BY test_id;

-- Expected result:
-- Account A = 8000.00
-- Account B = 7000.00
