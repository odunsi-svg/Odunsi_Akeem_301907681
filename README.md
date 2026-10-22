# MIT 8103 — Advanced Database Systems

## Practical Database Portfolio

**Project Title:** Call Data Record (CDR) Analysis and Link Analysis System  
**Student:** Odunsi Akeem  
**Student ID:** 301907681  
**Institution:** Miva University  
**Course:** MIT 8103 — Advanced Database Systems  
**Project Status:** Five practical portfolios completed; final submission documentation in preparation.

## 1. Project Overview

This repository documents the design, implementation and evaluation of a database system for analysing synthetic telecommunications Call Data Records (CDRs).

The project demonstrates relational database design, data validation, SQL query optimisation, transaction management, concurrency control, NoSQL operations and distributed database concepts.

PostgreSQL was used for the relational database experiments, while MongoDB was used to demonstrate document-based storage, indexing, aggregation, replication and automatic failover.

All telecommunications records used in this project are synthetic and intended exclusively for academic purposes.

## 2. Project Objectives

The project was developed to:

1. Design a relational database capable of storing and managing CDR information.
2. Import and validate synthetic telecommunications records.
3. Analyse communication frequencies and relationships between telephone-number identifiers.
4. Evaluate SQL query execution plans and indexing strategies.
5. Demonstrate database transactions, concurrency and isolation levels.
6. Implement document-based data storage and aggregation using MongoDB.
7. Demonstrate database replication, automatic failover and recovery.

## 3. Technologies Used

| Technology | Application |
|---|---|
| PostgreSQL 18 | Relational database implementation |
| pgAdmin 4 | SQL execution, database administration and query analysis |
| SQL | Database design, querying, transactions and optimisation |
| Python | Synthetic dataset generation, validation and CSV processing |
| MongoDB 9.0 | NoSQL document storage and replica-set experiments |
| MongoDB Compass | Document management, aggregation and indexing |
| MongoDB Shell | Replica-set administration and verification |
| Windows PowerShell | MongoDB process management |
| GitHub | Version control, technical documentation and evidence storage |

## 4. Dataset Description

The relational database experiments used a synthetic dataset containing 10,000 generated call-event records.

Following validation:

- **9,500 records** were accepted.
- **500 records** were rejected.
- **400 fictional telephone-number identifiers** were represented.
- **25 fictional cell sites** were included.

The rejected records represented five validation categories: invalid originating numbers, invalid timestamps, negative call durations, duplicate event identifiers and unknown cell-site references.

The 9,500 validated records were subsequently imported into MongoDB for the NoSQL experiments.

## 5. Portfolio Activities

### Portfolio 1 — Database Design and Modelling

A relational database named `cdr_analysis_db` was implemented using PostgreSQL.

The database comprises five tables:

- `telephone_numbers`
- `import_batches`
- `cell_sites`
- `call_events`
- `import_rejections`

The exercise covered relational schema design, entity relationships, data integrity, synthetic dataset generation, CSV import and validation.

**Outcome:** Successful import of 9,500 validated call records and documentation of 500 rejected records.

### Portfolio 2 — Query Processing and Optimisation

SQL queries were developed to analyse originating telephone numbers, communication pairs and selected call-event records.

PostgreSQL `EXPLAIN ANALYZE` was used to examine execution plans before and after index creation.

The experiments included indexing on originating numbers and composite indexing on originating and receiving numbers.

**Outcome:** Query execution plans were compared, demonstrating the effects of indexing and the circumstances under which PostgreSQL selected sequential scans or index scans.

### Portfolio 3 — Transactions and Concurrency

A dedicated `transaction_test` table was used to demonstrate transaction processing independently of the CDR dataset.

The experiments covered:

- Successful transactions using `COMMIT`.
- Transaction reversal using `ROLLBACK`.
- Concurrent access and row-level locking using `FOR UPDATE NOWAIT`.
- Non-repeatable reads under `READ COMMITTED`.
- Consistent transaction snapshots under `REPEATABLE READ`.

**Outcome:** Successful verification of transaction control, locking behaviour and isolation-level differences.

### Portfolio 4 — NoSQL and Advanced Data Models

A MongoDB database named `cdr_analysis_nosql` was created.

The 9,500 validated CDR records were imported into the `call_events` collection.

The experiments included document retrieval, bidirectional communication searches, aggregation pipelines, communication-frequency analysis and index evaluation.

MongoDB execution plans were inspected before and after index creation.

**Outcome:** Successful document-based storage, aggregation and indexed retrieval of synthetic CDR data.

### Portfolio 5 — Distributed and Cloud Database Concepts

A three-node MongoDB replica set named `cdrReplicaSet` was configured on a Windows computer.

The nodes operated on the following ports:

| Node | Port | Initial role |
|---|---|---|
| Node 1 | 27101 | PRIMARY |
| Node 2 | 27102 | SECONDARY |
| Node 3 | 27103 | SECONDARY |

The experiments demonstrated:

- Replication of synthetic records to secondary nodes.
- Controlled shutdown of the original primary.
- Automatic election of a new primary.
- Successful write operations after failover.
- Recovery and synchronization of the previously unavailable node.

**Outcome:** Successful verification of MongoDB replication, automatic failover, continued write availability and node recovery.

The replica set was implemented using three separate MongoDB processes on one physical computer. It therefore represents a local simulation of distributed database behaviour rather than a production cloud deployment.

## 6. Repository Structure

```text
Odunsi_Akeem_301907681/
│
├── README.md
├── portfolio_1_database_design/
├── portfolio_2_query_optimisation/
├── portfolio_3_transactions/
├── portfolio_4_nosql/
├── portfolio_5_distributed_cloud/
├── evidence/
└── final_report/
```

The portfolio folders contain technical documentation and implementation scripts. The `evidence` folder contains screenshots demonstrating the experiments and their results.

The `final_report` folder is reserved for the consolidated coursework report.

## 7. Ethical Considerations and Data Protection

The project uses entirely synthetic telecommunications records.

No real subscriber identities, operational intelligence records, intercepted communications or confidential telecommunications datasets were used.

Telephone-number identifiers and cell-site references were generated for academic testing.

The system is intended to demonstrate database technologies and analytical concepts, not to process live telecommunications information.

## 8. Key Learning Outcomes

The project provided practical experience in designing relational databases, validating structured datasets, interpreting database execution plans, managing transactions and understanding concurrency behaviour.

The MongoDB exercises extended this experience to document-oriented databases, aggregation, indexing and replication.

The distributed database experiments further demonstrated how automatic elections and synchronization can support database availability, while highlighting the limitations of a replica set hosted on a single physical machine.

## 9. Academic Integrity and AI Assistance

AI-assisted guidance was used to support the learning process, explain database concepts, develop and review example scripts, troubleshoot implementation steps and assist with technical documentation.

The practical experiments were executed and verified in the student's local database environment, with supporting screenshots maintained in this repository.

AI assistance will be declared in the final coursework submission in accordance with institutional requirements.

## 10. Conclusion

All five practical portfolios have been implemented and documented.

Together, they demonstrate the application of advanced database concepts to a synthetic CDR Analysis System, covering relational modelling, data integrity, query optimisation, transaction management, NoSQL processing and distributed database replication.

The repository provides the implementation scripts, supporting documentation and experimental evidence for the MIT 8103 practical coursework.
