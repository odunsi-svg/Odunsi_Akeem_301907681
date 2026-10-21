# Portfolio 2 — Query Processing and Optimisation

## MIT 8103: Advanced Database Systems

**Project:** Call Data Record (CDR) Analysis and Link Analysis System  
**Database:** PostgreSQL 18  
**Database Name:** `cdr_analysis_db`  
**Dataset:** 9,500 validated synthetic CDR records

## 1. Introduction

This portfolio examines SQL query processing, execution plans and index optimisation using the relational database developed in Portfolio 1.

The practical exercise evaluates how PostgreSQL processes analytical queries and how indexing affects the retrieval of call records.

All records used in this exercise are synthetic and contain no actual subscriber information.

## 2. Objectives

The objectives are to:

1. Develop SQL queries for analysing call records.
2. Identify frequently originating telephone numbers.
3. Examine communication frequencies between telephone-number pairs.
4. Analyse query execution plans using `EXPLAIN ANALYZE`.
5. Implement indexes to support data retrieval.
6. Compare indexed and sequential-scan performance.
7. Evaluate the circumstances under which indexing improves query performance.

## 3. SQL Query Implementation

Three analytical queries were developed and executed.

### 3.1 Query 1 — Top Originating Telephone Numbers

This query identifies the ten telephone numbers with the highest number of outgoing calls.

It uses `GROUP BY`, `COUNT`, `SUM`, `AVG`, `ORDER BY` and `LIMIT` to calculate call frequency and duration statistics.

The query successfully returned ten records. The highest-ranked synthetic number originated 318 calls.

### 3.2 Query 2 — Communication-Pair Analysis

This query identifies the ten most frequent directed communication pairs.

It groups call events by originating and receiving telephone numbers and calculates their communication frequency and total duration.

The highest-ranked directed pair recorded eight calls.

Calls from A to B are treated separately from calls from B to A.

### 3.3 Query 3 — Targeted CDR Lookup

This query retrieves call records for a selected synthetic originating telephone number.

It filters the `call_events` table using a `WHERE` condition and sorts matching records by call timestamp.

The query was used to evaluate index-based retrieval against a forced sequential scan.

## 4. Query Execution Plan Analysis

PostgreSQL's `EXPLAIN (ANALYZE, BUFFERS)` command was used to inspect query execution plans and measure execution performance.

The plans provided information about:

- Sequential and index-based access methods.
- Aggregation and sorting operations.
- Rows processed and returned.
- Shared buffer activity.
- Query planning and execution times.

Baseline tests were performed before creating the additional indexes. The same analytical queries were subsequently tested after indexing.

## 5. Index Implementation

Two indexes were created on the `call_events` table:

| Index | Indexed Columns |
|---|---|
| `idx_call_events_originating` | `originating_number` |
| `idx_call_events_communication_pair` | `originating_number`, `receiving_number` |

The `ANALYZE` command was executed to update PostgreSQL's table statistics.

These indexes were intended to support lookups and queries involving originating telephone numbers and communication pairs.

## 6. Performance Evaluation

### 6.1 Aggregation Query Results

| Query | Before Indexing | After Indexing |
|---|---:|---:|
| Query 1 — Top originating numbers | Approximately 8.06 ms | 8.675 ms |
| Query 2 — Communication pairs | Approximately 12.05 ms | 14.808 ms |

The before-indexing measurements are approximate timings observed at the `Limit` nodes of the execution plans. The after-indexing measurements are final execution times. Therefore, these figures are indicative and should not be interpreted as strictly equivalent benchmark measurements.

PostgreSQL continued to use sequential scans for the aggregation queries after indexing.

This behaviour is reasonable because the queries aggregate records across the entire dataset. Reading the complete table can be more efficient than using an index when most records must be processed.

### 6.2 Targeted Lookup Performance

The targeted lookup was executed using an index-based access path and compared with a forced sequential scan.

| Measurement | Indexed Lookup | Sequential Scan |
|---|---:|---:|
| Execution time | 4.604 ms | 9.612 ms |
| Access method | Index-based | Sequential scan |
| Dataset size | 9,500 records | 9,500 records |

The indexed lookup was approximately 52.1% faster in the observed single-run measurements, representing a speed ratio of approximately 2.09.

These results demonstrate the potential benefit of indexing for selective queries.

However, execution times can vary because of caching, system workload, planning overhead and other factors. The measurements are therefore presented as practical observations rather than statistically established performance guarantees.

## 7. Discussion of Findings

The practical tests produced two important findings.

First, creating indexes did not automatically improve full-table aggregation queries. PostgreSQL's query planner continued selecting sequential scans because the operations required processing most or all available call records.

Second, the targeted telephone-number lookup benefited from an index-based execution plan in the observed experiment.

These findings demonstrate that database optimisation should be guided by query characteristics and actual execution plans rather than simply creating indexes on frequently referenced columns.

The exercise also demonstrated how PostgreSQL's planner settings can be temporarily adjusted to compare alternative execution strategies.

After the comparison, the normal index-planning settings were restored.

## 8. Implementation Files

| File | Description |
|---|---|
| `01_analytical_queries.sql` | Contains the three CDR analytical queries. |
| `02_index_optimisation.sql` | Contains index creation, execution-plan tests and sequential-scan comparison. |

The repository's `evidence` folder contains screenshots of the SQL results, index creation and execution-plan experiments.

## 9. Challenges and Lessons Learned

One challenge was distinguishing the time reported by pgAdmin for an entire query operation from the execution time reported within PostgreSQL's query plan.

Another was understanding why PostgreSQL did not use the newly created indexes for aggregation queries.

The experiments reinforced the importance of inspecting execution plans, interpreting scan methods and testing performance empirically.

The results also highlighted the need for repeated measurements and consistent benchmarking conditions when making stronger performance claims.

## 10. Conclusion

Portfolio 2 successfully demonstrated SQL query processing and index optimisation using 9,500 synthetic CDR records stored in PostgreSQL.

Three analytical queries were implemented, execution plans were examined and two indexes were created.

The experiments showed that full-table aggregation queries continued to favour sequential scanning, while a targeted telephone-number lookup demonstrated a measurable advantage from index-based retrieval in the observed test.

These findings provide a practical foundation for understanding PostgreSQL query planning and database performance optimisation.

**Portfolio 2 Status: Completed — Query Processing and Optimisation.**
