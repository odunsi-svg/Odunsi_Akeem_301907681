
/*
MIT 8103 - Advanced Database Systems
Portfolio 5: Automatic Failover and Recovery
Case Study: CDR Analysis System

Replica Set: cdrReplicaSet
Node 1: 127.0.0.1:27101
Node 2: 127.0.0.1:27102
Node 3: 127.0.0.1:27103

IMPORTANT:
This file documents an experiment already completed.
Do not execute the entire script automatically.
Each step was performed separately on the specified node.
*/

// =====================================================
// STEP 1: VERIFY INITIAL REPLICA SET STATUS
// =====================================================

// Executed on Node 1, the original PRIMARY.

rs.status().members.map(m => ({
    name: m.name,
    state: m.stateStr,
    health: m.health
}));

// Observed:
// Node 1: PRIMARY, health 1
// Node 2: SECONDARY, health 1
// Node 3: SECONDARY, health 1


// =====================================================
// STEP 2: SIMULATE PRIMARY NODE FAILURE
// =====================================================

// Executed on Node 1 only.
// Commented out to prevent accidental shutdown.

// db.adminCommand({ shutdown: 1 });

// Observed:
// Connection to 127.0.0.1:27101 closed.


// =====================================================
// STEP 3: VERIFY AUTOMATIC FAILOVER
// =====================================================

// Executed on Node 2 after Node 1 shut down.

rs.status().members.map(m => ({
    name: m.name,
    state: m.stateStr,
    health: m.health
}));

// Observed:
// Node 1: Unreachable, health 0
// Node 2: PRIMARY, health 1
// Node 3: SECONDARY, health 1


// =====================================================
// STEP 4: VERIFY WRITE AVAILABILITY
// =====================================================

// Executed on Node 2, the newly elected PRIMARY.
// Commented out to prevent duplicate test records.

/*
db.getSiblingDB("cdr_replication_test")
  .call_events.insertOne({
    event_id: "REPL_TEST_002",
    originating_number: "999000000000003",
    receiving_number: "999000000000004",
    call_started_at: new Date("2026-10-22T11:00:00Z"),
    duration_seconds: 180,
    originating_cell_site_id: "SYN_SITE_003",
    receiving_cell_site_id: "SYN_SITE_004",
    test_purpose:
      "Post-failover write availability verification"
  });
*/

// Observed:
// acknowledged: true


// =====================================================
// STEP 5: RESTART NODE 1
// =====================================================

// Executed separately in Windows PowerShell:
//
// & "C:\Program Files\MongoDB\Server\9.0\bin\mongod.exe" `
//   --replSet cdrReplicaSet `
//   --port 27101 `
//   --dbpath "C:\MongoDBReplica\node1" `
//   --bind_ip 127.0.0.1


// =====================================================
// STEP 6: VERIFY NODE RECOVERY
// =====================================================

// Executed on the recovered Node 1.

rs.status().members.map(m => ({
    name: m.name,
    state: m.stateStr,
    health: m.health
}));

// Observed:
// Node 1: SECONDARY, health 1
// Node 2: PRIMARY, health 1
// Node 3: SECONDARY, health 1


// =====================================================
// STEP 7: VERIFY DATA SYNCHRONIZATION
// =====================================================

// Executed on recovered Node 1.

db.getSiblingDB("cdr_replication_test")
  .call_events.findOne({
    event_id: "REPL_TEST_002"
  });

// Observed:
// REPL_TEST_002 was successfully retrieved.
// This confirmed synchronization of the write
// performed while Node 1 was offline.
