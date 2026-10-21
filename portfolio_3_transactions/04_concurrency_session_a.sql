
-- PORTFOLIO 3: CONCURRENCY CONTROL
-- SESSION A: ACQUIRE A ROW LOCK
-- MIT 8103 Advanced Database Systems

-- Run this script in Session A only.
-- Execute the BEGIN and SELECT statements first.
-- Keep the transaction open while testing Session B.

BEGIN;

SELECT
    test_id,
    description,
    amount
FROM transaction_test
WHERE test_id = 1
FOR UPDATE;

-- IMPORTANT:
-- Do not execute COMMIT until Session B
-- has attempted to acquire the same lock.

-- After Session B reports SQLSTATE 55P03,
-- execute the following statement separately
-- in Session A to release the lock:

-- COMMIT;
