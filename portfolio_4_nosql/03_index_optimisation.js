
/*
MIT 8103 - Advanced Database Systems
Portfolio 4: MongoDB Index Optimisation
Case Study: CDR Analysis and Link Analysis System

Database: cdr_analysis_nosql
Collection: call_events
Dataset: 9,500 validated synthetic CDR records
*/

const dbCDR = db.getSiblingDB("cdr_analysis_nosql");

const collection = dbCDR.call_events;

const query = {
  originating_number: "999000000000399"
};

// =====================================================
// EXPERIMENT 1: PERFORMANCE BEFORE INDEXING
// =====================================================

// Run this before creating the index.
// The hint forces a collection scan for reproducibility.

collection.find(query)
  .hint({ $natural: 1 })
  .explain("executionStats");

// Observed baseline:
// Execution stage: COLLSCAN
// Documents examined: 9500
// Documents returned: 23
// Execution time: 5 ms


// =====================================================
// EXPERIMENT 2: CREATE AN INDEX
// =====================================================

// Create an ascending index on originating_number.

collection.createIndex(
  { originating_number: 1 },
  { name: "idx_originating_number" }
);


// =====================================================
// EXPERIMENT 3: PERFORMANCE AFTER INDEXING
// =====================================================

// Force the query to use the newly created index.

collection.find(query)
  .hint("idx_originating_number")
  .explain("executionStats");

// Observed results:
// Execution stages: IXSCAN followed by FETCH
// Index keys examined: 23
// Documents examined: 23
// Documents returned: 23
// Execution time: 0 ms (reported)


// =====================================================
// PERFORMANCE COMPARISON
// =====================================================

// Documents examined before indexing: 9500
// Documents examined after indexing: 23
//
// Reduction = ((9500 - 23) / 9500) * 100
// Reduction = 99.76%
//
// The index substantially reduced document examination.
// Execution times may vary across runs and environments.
