-- Run in pgAdmin Query Tool after importing.
SELECT batch_id, filename, total_rows, accepted_rows, rejected_rows, status
FROM import_batches ORDER BY batch_id DESC;

SELECT COUNT(*) AS imported_call_events FROM call_events;
SELECT COUNT(*) AS logged_rejections FROM import_rejections;

SELECT rejection_reason, COUNT(*) AS occurrences
FROM import_rejections
GROUP BY rejection_reason ORDER BY occurrences DESC;

-- Frequent direct communication pairs (synthetic data only)
SELECT originating_number, receiving_number,
       COUNT(*) AS call_count, SUM(duration_seconds) AS total_duration_seconds
FROM call_events
GROUP BY originating_number, receiving_number
ORDER BY call_count DESC LIMIT 15;
