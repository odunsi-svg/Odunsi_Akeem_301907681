
/*
MIT 8103 - Advanced Database Systems
Portfolio 4: MongoDB Aggregation Pipelines
Case Study: CDR Analysis and Link Analysis System

Database: cdr_analysis_nosql
Collection: call_events
Dataset: 9,500 validated synthetic CDR records
*/

const dbCDR = db.getSiblingDB("cdr_analysis_nosql");

// =====================================================
// QUERY 1: TOP 10 ORIGINATING NUMBERS
// =====================================================

// Count outgoing calls for each originating number,
// rank by frequency, and return the top 10.

dbCDR.call_events.aggregate([
  {
    $group: {
      _id: "$originating_number",
      total_calls: { $sum: 1 }
    }
  },
  {
    $sort: {
      total_calls: -1
    }
  },
  {
    $limit: 10
  }
]);

// Observed highest outgoing call frequency: 318


// =====================================================
// QUERY 2: TOP 10 DIRECTED COMMUNICATION PAIRS
// =====================================================

// Group calls by originating and receiving numbers.
// Call direction is preserved.

dbCDR.call_events.aggregate([
  {
    $group: {
      _id: {
        originating_number: "$originating_number",
        receiving_number: "$receiving_number"
      },
      total_calls: { $sum: 1 }
    }
  },
  {
    $sort: {
      total_calls: -1
    }
  },
  {
    $limit: 10
  }
]);

// Observed highest directed-pair frequency: 8 calls
