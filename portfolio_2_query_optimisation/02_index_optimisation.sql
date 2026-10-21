
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 2: INDEX OPTIMISATION
-- Database: cdr_analysis_db
-- All telephone numbers are synthetic.

-- 1. Create indexes
CREATE INDEX IF NOT EXISTS idx_call_events_originating
ON call_events (originating_number);

CREATE INDEX IF NOT EXISTS idx_call_events_communication_pair
ON call_events (originating_number, receiving_number);

ANALYZE call_events;

-- 2. Test top originating numbers
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    originating_number AS phone_number,
    COUNT(*) AS total_calls_made,
    SUM(duration_seconds) AS total_duration_seconds,
    ROUND(AVG(duration_seconds), 2) AS average_duration_seconds
FROM call_events
GROUP BY originating_number
ORDER BY total_calls_made DESC, phone_number
LIMIT 10;

-- 3. Test communication pairs
EXPLAIN (ANALYZE, BUFFERS)
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

-- 4. Test targeted indexed lookup
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    event_id,
    originating_number,
    receiving_number,
    call_started_at,
    duration_seconds
FROM call_events
WHERE originating_number = '999000000000001'
ORDER BY call_started_at DESC;

-- 5. Compare with a forced sequential scan.
-- Settings are temporary and reset at transaction end.
BEGIN;

SET LOCAL enable_indexscan = off;
SET LOCAL enable_bitmapscan = off;
SET LOCAL enable_indexonlyscan = off;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    event_id,
    originating_number,
    receiving_number,
    call_started_at,
    duration_seconds
FROM call_events
WHERE originating_number = '999000000000001'
ORDER BY call_started_at DESC;

COMMIT;
