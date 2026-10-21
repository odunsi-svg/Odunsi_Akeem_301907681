# Practical Implementation Evidence

## MIT 8103 — Advanced Database Systems

**Project:** Call Data Record (CDR) Analysis and Link Analysis System

This folder contains screenshots and diagrams documenting the practical implementation of the Advanced Database Systems assessment.

All call records and telephone numbers used in the project are synthetic.

## Portfolio 1 — Database Design and Modelling

The evidence includes:

- PostgreSQL database schema showing the five relational tables.
- SQL verification of the import results: 9,500 accepted records, 500 rejected records, 400 synthetic telephone numbers and 25 synthetic cell sites.
- Entity–Relationship Diagram showing the tables, primary keys, foreign keys and relationships.

These materials support the database design, implementation, integrity constraints and normalisation documentation presented in Portfolio 1.

## Portfolio 2 — Query Processing and Optimisation

The evidence includes:

- Query 1: Top ten originating telephone numbers.
- Query 2: Top ten directed communication pairs.
- Query 1 and Query 2 baseline execution plans.
- Successful creation of two PostgreSQL indexes.
- Query 1 and Query 2 execution plans after indexing.
- Query 3: Targeted indexed lookup.
- Query 3: Forced sequential-scan comparison.

The targeted lookup recorded an execution time of **4.604 ms using an index**, compared with **9.612 ms using a forced sequential scan**.

These single-run measurements demonstrate an observed performance advantage for the indexed lookup. The aggregation queries continued to use sequential scans.

## Evidence Collection Status

- Portfolio 1: Evidence collected.
- Portfolio 2: Evidence collected.
- Portfolio 3: Pending.
- Portfolio 4: Pending.
- Portfolio 5: Pending.

Further evidence will be added as the remaining portfolios are completed.
