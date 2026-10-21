
-- ============================================================
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 3: REPEATABLE READ ISOLATION
-- Project: CDR Analysis and Link Analysis System
-- ============================================================

-- PURPOSE:
-- Demonstrate that PostgreSQL's REPEATABLE READ isolation
-- maintains a consistent snapshot throughout a transaction.
--
-- PREREQUISITE:
-- Both sessions connect to cdr_analysis_db.
-- Account A initially has a balance of 9000.00.
--
-- IMPORTANT:
-- Execute the steps in order in TWO separate Query Tool
-- sessions. Do not run this entire file as one script.


-- ============================================================
-- STEP 1: SESSION A
-- ============================================================

-- BEGIN ISOLATION LEVEL REPEATABLE READ;

-- SELECT test_id, description, amount
-- FROM transaction_test
-- WHERE test_id = 1;

-- Expected result: Account A = 9000.00
-- This SELECT establishes Session A's snapshot.
-- Leave Session A's transaction open.


-- ============================================================
-- STEP 2: SESSION B
-- ============================================================

-- BEGIN;

-- UPDATE transaction_test
-- SET amount = amount + 1000
-- WHERE test_id = 1;

-- COMMIT;

-- SELECT test_id, description, amount
-- FROM transaction_test
-- WHERE test_id = 1;

-- Expected result: Account A = 10000.00


-- ============================================================
-- STEP 3: SESSION A
-- ============================================================

-- SELECT test_id, description, amount
-- FROM transaction_test
-- WHERE test_id = 1;

-- Expected result: Account A = 9000.00
--
-- Despite Session B committing the updated value,
-- Session A continues to see its original snapshot.


-- ============================================================
-- STEP 4: SESSION A
-- ============================================================

-- COMMIT;

-- SELECT test_id, description, amount
-- FROM transaction_test
-- WHERE test_id = 1;

-- Expected result: Account A = 10000.00
--
-- After the transaction ends, the new SELECT
-- observes the latest committed value.


-- ============================================================
-- CONCLUSION
-- ============================================================

-- READ COMMITTED:
-- Successive SELECT statements can observe newly
-- committed changes from other transactions.

-- REPEATABLE READ:
-- Successive SELECT statements within the same
-- transaction observe a consistent snapshot.

-- This experiment demonstrates PostgreSQL's
-- multiversion concurrency control (MVCC).
