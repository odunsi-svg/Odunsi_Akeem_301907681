# Portfolio 1 — Database Design and Modelling

## MIT 8103: Advanced Database Systems

**Project:** Call Data Record (CDR) Analysis and Link Analysis System  
**Database Management System:** PostgreSQL 18  
**Database Administration Tool:** pgAdmin 4  
**Programming Language:** Python 3.15  
**Database Name:** `cdr_analysis_db`

## 1. Introduction

This portfolio presents the design and implementation of a relational database for a Call Data Record (CDR) Analysis and Link Analysis System.

The project demonstrates how relational database concepts can be applied to organise, validate, store and retrieve telecommunications event data. It also provides a foundation for analysing communication frequency and relationships between telephone numbers.

The implementation uses entirely synthetic records for academic purposes. No actual subscriber information was included in the generated dataset.

## 2. Project Objectives

The objectives of this portfolio are to:

1. Design a relational database for storing CDR information.
2. Identify appropriate entities, attributes, primary keys and foreign keys.
3. Implement the database using PostgreSQL.
4. Apply database normalisation principles up to Third Normal Form (3NF).
5. Develop a Python-based CSV import and validation process.
6. Demonstrate referential integrity and data-quality controls.
7. Verify the successful insertion and rejection of records.

## 3. Database Design

The database was implemented using five relational tables.

| Table | Primary Key | Purpose |
|---|---|---|
| `telephone_numbers` | `phone_number` | Stores unique synthetic telephone numbers. |
| `cell_sites` | `cell_site_id` | Stores synthetic cell-site reference information. |
| `import_batches` | `batch_id` | Tracks individual CSV import operations and their results. |
| `call_events` | `event_id` | Stores validated call events and associated metadata. |
| `import_rejections` | `rejection_id` | Records rejected CSV rows and their validation errors. |

### 3.1 Entity Relationships

The database implements the following relationships:

- One import batch can contain many call events.
- One import batch can have many rejected records.
- One telephone number can originate many call events.
- One telephone number can receive many call events.
- One cell site can be referenced by many call events.

These relationships are implemented through foreign-key constraints.

The `call_events` table references `telephone_numbers` twice, representing the originating and receiving parties. It also references `cell_sites` through two optional foreign keys.

### 3.2 Entity–Relationship Diagram

An Entity–Relationship Diagram (ERD) was generated using pgAdmin 4 to illustrate the five tables, their attributes, primary keys, foreign keys and relationships.

The exported ER diagram is available in the repository's `evidence` folder.

## 4. Database Normalisation

The database was designed using relational normalisation principles to reduce unnecessary duplication and maintain data consistency.

### 4.1 First Normal Form (1NF)

First Normal Form requires that each table contain atomic attribute values and that individual records can be uniquely identified.

The database satisfies 1NF because:

- Each table has a primary key.
- Individual columns contain single values.
- Call timestamps, telephone numbers and durations are stored in separate attributes.
- Repeating call records are represented as individual rows rather than repeating column groups.

### 4.2 Second Normal Form (2NF)

Second Normal Form requires that a relation satisfy 1NF and that non-key attributes depend on the entire candidate key rather than only part of a composite key.

The five implemented tables use single-column primary keys, and their design does not introduce partial dependencies on composite candidate keys.

For example, in `call_events`, attributes such as `call_started_at` and `duration_seconds` describe the event identified by `event_id`.

### 4.3 Third Normal Form (3NF)

Third Normal Form requires that a relation satisfy 2NF and avoid inappropriate transitive dependencies between non-key attributes.

The database separates information into related tables instead of repeatedly storing reference information within each call event.

For example:

- Telephone numbers are maintained in `telephone_numbers`.
- Cell-site labels and coordinates are maintained in `cell_sites`.
- CSV import information is maintained in `import_batches`.
- Call-event details are maintained in `call_events`.
- Invalid records and their rejection reasons are maintained in `import_rejections`.

The separation of these entities reduces redundancy and helps prevent insertion, update and deletion anomalies.

## 5. Database Implementation

PostgreSQL 18 was installed and configured locally, and the database `cdr_analysis_db` was created using pgAdmin 4.

The SQL script `01_create_tables.sql` was executed successfully to create the five tables.

The implementation includes:

- Primary-key constraints.
- Foreign-key constraints.
- Data-type definitions.
- `NOT NULL` constraints.
- `CHECK` constraints for selected validation rules.
- Unique constraints.
- Identity-generated identifiers.

These mechanisms help maintain relational integrity and reject certain categories of invalid data.

## 6. Synthetic Dataset and Data Import

A synthetic dataset containing 10,000 CDR records was generated using Python.

The dataset includes:

- 400 synthetic telephone numbers.
- 25 synthetic cell sites.
- Simulated call events covering approximately 90 days.
- Deliberately invalid records for testing validation and rejection handling.

A Python import script was developed using the `psycopg` PostgreSQL driver.

The script imports reference data, validates individual call records, inserts accepted records and stores rejected records with their corresponding error descriptions.

## 7. Import and Validation Results

The import process produced the following results, subsequently verified through SQL queries in pgAdmin:

| Measurement | Verified Result |
|---|---:|
| Total records processed | 10,000 |
| Successfully accepted CDRs | 9,500 |
| Rejected CDRs | 500 |
| Acceptance rate | 95% |
| Rejection rate | 5% |
| Unique synthetic telephone numbers | 400 |
| Synthetic cell sites | 25 |

The validation exercise demonstrates that the database and Python import process can distinguish acceptable records from records that fail the implemented checks.

Rejected records are preserved separately for inspection rather than being silently discarded.

## 8. Implementation Files

| File | Description |
|---|---|
| `01_create_tables.sql` | Creates the five PostgreSQL tables and their constraints. |
| `02_generate_synthetic_cdr.py` | Generates the synthetic CDR dataset and supporting reference data. |
| `03_import_and_validate.py` | Imports and validates the synthetic records in PostgreSQL. |
| `04_verify_import.sql` | Contains SQL queries used to verify the database contents. |

The repository's `evidence` folder contains screenshots documenting database creation, import verification and the Entity–Relationship Diagram.

## 9. Challenges and Lessons Learned

The practical implementation reinforced the importance of database planning before inserting records.

In particular, foreign-key relationships required reference data to be available before related call events could be inserted.

The exercise also demonstrated the difference between database constraints and application-level validation. PostgreSQL enforces structural and relational rules, while the Python importer performs additional checks and records rejected input for review.

Finally, generating a synthetic dataset made it possible to test the system with a meaningful volume of records without exposing confidential subscriber information.

## 10. Conclusion

Portfolio 1 successfully established a working relational database for the CDR Analysis and Link Analysis System.

Five related tables were implemented in PostgreSQL, and a Python-based import process was used to process 10,000 synthetic records. Database verification confirmed that 9,500 records were accepted and 500 were rejected.

The database structure, integrity constraints, ER diagram and normalisation principles provide the foundation for subsequent portfolio activities involving SQL query optimisation, transactions, NoSQL databases and distributed or cloud database systems.

**Portfolio 1 Status: Completed — Database Design and Implementation.**
