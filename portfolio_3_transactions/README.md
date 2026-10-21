# Portfolio 3: Transactions, Concurrency Control and Isolation Levels

## Project Overview

This portfolio demonstrates transaction management and concurrency control in PostgreSQL as part of the Call Data Record (CDR) Analysis System developed for MIT 8103 Advanced Database Systems.

The experiments were performed in the `cdr_analysis_db` database using a dedicated `transaction_test` table. This allowed transaction behaviour to be tested without modifying the synthetic CDR records.

## 1. Transaction Management

### COMMIT

A transaction was executed to transfer 2,000 units from Account A to Account B.

Initial balances:

- Account A: 10,000.00
- Account B: 5,000.00

Balances after COMMIT:

- Account A: 8,000.00
- Account B: 7,000.00

The experiment demonstrated that COMMIT permanently saves changes made within a successful transaction.

### ROLLBACK

A subsequent transaction attempted to modify the balances but was cancelled using ROLLBACK.

The experiment confirmed that ROLLBACK discards uncommitted changes and preserves the previously committed balances.

## 2. Concurrency Control

Two independent PostgreSQL sessions, Session A and Session B, were used to test concurrent access to the same record.

Session A acquired an exclusive row-level lock using `SELECT ... FOR UPDATE`.

Session B attempted to acquire the same lock using `SELECT ... FOR UPDATE NOWAIT`.

PostgreSQL returned SQLSTATE `55P03`, indicating that the row was already locked by another transaction.

After Session A released the lock, Session B was able to acquire it successfully.

This demonstrated PostgreSQL's ability to prevent conflicting concurrent modifications.

## 3. READ COMMITTED Isolation

Session A started a transaction using READ COMMITTED isolation and retrieved an account balance.

Session B updated the same record and committed the change.

When Session A executed the SELECT statement again, it observed the newly committed value.

This demonstrated that READ COMMITTED permits successive statements within one transaction to observe different committed versions of a record.

## 4. REPEATABLE READ Isolation

Session A started a transaction using REPEATABLE READ isolation and retrieved an account balance of 9,000.00.

Session B subsequently increased the balance by 1,000.00 and committed the transaction.

A second SELECT in Session A continued to return 9,000.00 because the transaction retained its original snapshot.

After Session A committed and executed a new SELECT, it retrieved the updated balance of 10,000.00.

This demonstrated consistent snapshot visibility within a REPEATABLE READ transaction.

## 5. Relevance to the CDR Analysis System

Transaction management helps maintain consistency during CDR imports and database updates.

Concurrency control prevents conflicting modifications when multiple database sessions access shared records.

Isolation levels determine which committed changes are visible to concurrent analytical operations.

Together, these mechanisms support database reliability, data integrity and predictable query behaviour.

## 6. Conclusion

The experiments successfully demonstrated PostgreSQL transaction management, row-level locking and isolation behaviour. The results confirmed that COMMIT persists changes, ROLLBACK cancels uncommitted changes, row locks coordinate concurrent access, and different isolation levels provide different guarantees for data visibility.

All experiments were conducted on a dedicated test table using fictional account records.
