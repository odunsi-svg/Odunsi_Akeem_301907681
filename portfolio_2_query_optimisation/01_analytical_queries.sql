
-- ============================================================
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 2: QUERY PROCESSING AND OPTIMISATION
-- Project: CDR Analysis and Link Analysis System
-- File: 01_analytical_queries.sql
-- Database: cdr_analysis_db (PostgreSQL 18)
-- Dataset: Synthetic CDR records only
-- ============================================================

-- QUERY 1: TOP 10 ORIGINATING TELEPHONE NUMBERS
-- Identifies numbers with the highest outgoing call frequency
-- and calculates total and average call durations.

SELECT
    originating_number AS phone_number,
    COUNT(*) AS total_calls_made,
    SUM(duration_seconds) AS total_duration_seconds,
    ROUND(AVG(duration_seconds), 2) AS average_duration_seconds
FROM call_events
GROUP BY originating_number
ORDER BY total_calls_made DESC, phone_number
LIMIT 10;


-- QUERY 2: TOP 10 DIRECTED COMMUNICATION PAIRS
-- Identifies the most frequently occurring caller-recipient
-- combinations and their combined call durations.
-- A -> B and B -> A are treated as separate pairs.

SELECT
    originating_number,
    receiving_number,
    COUNT(*) AS total_calls,
    SUM(duration_seconds) AS total_duration_seconds
FROM call_events
GROUP BY originating_number, receiving_number
ORDER BY total_calls DESC,
         originating_number,
         receiving_number
LIMIT 10;


-- QUERY 3: TARGETED CALL RECORD LOOKUP
-- Retrieves call records originated by a selected synthetic
-- telephone number, ordered from newest to oldest.
-- This query was used for the indexing performance experiment.

SELECT
    event_id,
    originating_number,
    receiving_number,
    call_started_at,
    duration_seconds
FROM call_events
WHERE originating_number = '999000000000001'
ORDER BY call_started_at DESC;
