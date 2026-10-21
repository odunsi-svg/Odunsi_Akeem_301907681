
-- PORTFOLIO 3: CONCURRENCY CONTROL
-- SESSION B: TEST ROW-LOCK CONTENTION
-- MIT 8103 Advanced Database Systems

-- Prerequisite:
-- Session A must have acquired a row lock
-- on test_id = 1 and must remain uncommitted.

-- Execute in a separate PostgreSQL Query Tool.

BEGIN;

SELECT
    test_id,
    description,
    amount
FROM transaction_test
WHERE test_id = 1
FOR UPDATE NOWAIT;

-- Expected result while Session A holds the lock:
-- ERROR: could not obtain lock on row
-- SQLSTATE: 55P03

-- After the error, the transaction is aborted.
-- Execute the following statement separately:
-- ROLLBACK;

-- Next, release the lock in Session A using COMMIT.

-- To verify that the lock has been released,
-- execute the following statements in Session B:

-- BEGIN;
-- SELECT *
-- FROM transaction_test
-- WHERE test_id = 1
-- FOR UPDATE NOWAIT;
-- COMMIT;

-- Expected result:
-- The row is returned successfully because
-- Session A no longer holds the lock.
