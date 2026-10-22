# Portfolio 4: NoSQL Database Implementation

**Course:** MIT 8103 — Advanced Database Systems  
**Project:** Call Data Record (CDR) Analysis and Link Analysis System  
**Database Technology:** MongoDB Community Server and MongoDB Compass

## 1. Overview

This portfolio demonstrates the implementation of a document-oriented NoSQL database using MongoDB. The project extends the PostgreSQL-based CDR Analysis System developed in earlier portfolios by storing validated synthetic communication records in MongoDB and performing document retrieval, aggregation, communication-pair analysis and query optimisation.

## 2. Database Implementation

A MongoDB database named `cdr_analysis_nosql` was created with a collection named `call_events`.

The collection contains **9,500 validated synthetic CDR documents** exported from PostgreSQL. These records originated from a dataset of 10,000 synthetic records, of which 500 were rejected during the relational database validation exercise.

Each MongoDB document contains the following fields:

- `event_id`: Unique synthetic call-event identifier.
- `batch_id`: Import batch identifier.
- `originating_number`: Calling telephone number, stored as a string.
- `receiving_number`: Receiving telephone number, stored as a string.
- `call_started_at`: Call timestamp, stored as a date.
- `duration_seconds`: Call duration, stored as an integer.
- `originating_cell_site_id`: Originating cell-site identifier.
- `receiving_cell_site_id`: Receiving cell-site identifier.

MongoDB automatically generated an `_id` field for each document.

## 3. Document Retrieval

A query filtering records by `originating_number` returned **23 outgoing call records** for the selected synthetic number.

A second query using the `$or` operator searched both originating and receiving number fields and returned **45 communication records** involving the same number.

These experiments demonstrated MongoDB's ability to retrieve documents using equality conditions and compound logical filters.

## 4. Communication Frequency Analysis

An aggregation pipeline was developed using three stages:

1. `$group` — Grouped call records by originating telephone number and counted outgoing calls.
2. `$sort` — Ranked originating numbers by call frequency in descending order.
3. `$limit` — Restricted the output to the 10 most active originating numbers.

The highest-ranked originating number in the observed results recorded **318 outgoing calls**.

The pipeline was saved as `Top_10_Originating_Numbers`.

## 5. Communication-Pair Analysis

A second aggregation pipeline grouped call records by the combination of `originating_number` and `receiving_number`.

The analysis preserved communication direction, treating calls from Number A to Number B separately from calls from Number B to Number A.

The highest-ranked directed communication pair recorded **8 calls**.

The pipeline was saved as `Top_10_Communication_Pairs`.

## 6. Indexing and Query Optimisation

An indexing experiment was conducted using the `originating_number` field.

Before indexing, MongoDB used a collection scan (`COLLSCAN`) to retrieve 23 matching documents. It examined all 9,500 documents and reported an execution time of 5 milliseconds.

An ascending index named `idx_originating_number` was subsequently created.

After indexing, MongoDB used an indexed scan (`IXSCAN`) followed by `FETCH`. The number of documents examined decreased from 9,500 to 23, representing a **99.76% reduction**.

The indexed query reported an execution time of 0 milliseconds at the measurement resolution displayed by MongoDB Compass. Execution times may vary between runs and environments.

## 7. Comparison with PostgreSQL

PostgreSQL stores CDR information in structured relational tables with explicitly defined schemas, primary keys and foreign-key relationships.

MongoDB stores each CDR event as a document within a collection. Its document-oriented model supports flexible data representation and provides aggregation pipelines for analysing communication patterns.

Both database systems support filtering, indexing and aggregation. Their differences lie principally in data modelling, schema enforcement, relationships and query mechanisms.

## 8. Evidence

Supporting screenshots are available in the repository's `evidence` folder. They document the successful import, originating-number retrieval, bidirectional communication filtering, aggregation pipelines, index creation and query execution plans before and after indexing.

## 9. Conclusion

The implementation demonstrates the use of MongoDB as a NoSQL alternative for storing and analysing synthetic CDR information. The practical exercises established document-based retrieval, communication-frequency analysis, directed communication-pair analysis and measurable indexing improvements.

The portfolio complements the earlier PostgreSQL implementation and provides a practical basis for comparing relational and document-oriented database technologies.
