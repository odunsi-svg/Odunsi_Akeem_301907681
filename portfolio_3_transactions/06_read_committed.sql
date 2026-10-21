
-- ============================================================
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 3: READ COMMITTED ISOLATION
-- Project: CDR Analysis and Link Analysis System
-- ============================================================

-- PURPOSE:
-- Demonstrate that a transaction using READ COMMITTED
-- can observe newly committed changes between SELECT queries.
--
-- PREREQUISITE:
-- Both sessions connect to cdr_analysis_db.
-- Account A initially has a balance of 8000.00.
--
-- IMPORTANT:
-- Execute the steps in order in TWO separate Query Tool
-- sessions. Do not run this entire file as one script.


-- ============================================================
-- STEP 1: SESSION A
-- ============================================================

-- BEGIN ISOLATION LEVEL READ COMMITTED;

-- SELECT test_id, description, amount
-- FROM transaction_test
-- WHERE test_id = 1;

-- Expected result: Account A = 8000.00
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

-- Expected result: Account A = 9000.00


-- ============================================================
-- STEP 3: SESSION A
-- ============================================================

-- SELECT test_id, description, amount
-- FROM transaction_test
-- WHERE test_id = 1;

-- Expected result: Account A = 9000.00
--
-- Session A observes the newly committed value.
-- This demonstrates a non-repeatable read under
-- READ COMMITTED isolation.


-- ============================================================
-- STEP 4: SESSION A
-- ============================================================

-- COMMIT;

-- The experiment is complete.
