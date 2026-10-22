// MIT 8103 - Portfolio 5
// MongoDB Replication Verification
// Case Study: CDR Analysis System
//
// All records are synthetic.
// This script documents the replication experiment.
//
// IMPORTANT:
// Execute the insertion on the PRIMARY node only.
// Execute the verification query separately on each SECONDARY.
// Do not rerun the insertion if REPL_TEST_001 already exists.

// STEP 1: Select the test database.
use("cdr_replication_test");

// STEP 2: Insert a synthetic CDR on the PRIMARY.
db.call_events.insertOne({
    event_id: "REPL_TEST_001",
    originating_number: "999000000000001",
    receiving_number: "999000000000002",
    call_started_at: new Date("2026-10-22T10:00:00Z"),
    duration_seconds: 120,
    originating_cell_site_id: "SYN_SITE_001",
    receiving_cell_site_id: "SYN_SITE_002",
    test_purpose: "MongoDB replication verification"
});

// STEP 3: On each SECONDARY node, select the same
// database and retrieve the replicated document.
//
// In MongoDB Compass, direct secondary connections
// were used for this verification.
//
// Run the following query separately on Node 2 and Node 3:

db.call_events.findOne({
    event_id: "REPL_TEST_001"
});
