# Portfolio 5: Distributed Databases and Cloud Computing

**Course:** MIT 8103 – Advanced Database Systems  
**Project:** Call Data Record (CDR) Analysis System  
**Database Platform:** MongoDB 9.0  
**Environment:** Windows, MongoDB Compass and MongoDB Shell

## 1. Introduction

This portfolio demonstrates the implementation of a distributed database environment using MongoDB replica sets. The experiment builds on the CDR Analysis System developed in earlier portfolios, using synthetic call records to evaluate database replication, availability, failover and recovery.

A three-node MongoDB replica set was configured locally to simulate a distributed database environment.

## 2. Objectives

The objectives of this experiment were to:

1. Configure a three-node MongoDB replica set.
2. Verify primary and secondary node assignments.
3. Demonstrate data replication across multiple nodes.
4. Simulate primary-node failure.
5. Observe automatic primary election and failover.
6. Verify continued write availability after failover.
7. Restore the failed node and confirm data synchronization.

## 3. System Architecture

The experiment used three MongoDB instances running on different local ports.

| Node | Address | Initial role |
|---|---|---|
| Node 1 | 127.0.0.1:27101 | PRIMARY |
| Node 2 | 127.0.0.1:27102 | SECONDARY |
| Node 3 | 127.0.0.1:27103 | SECONDARY |

**Replica set name:** `cdrReplicaSet`

Each MongoDB instance used a separate data directory:

- `C:\MongoDBReplica\node1`
- `C:\MongoDBReplica\node2`
- `C:\MongoDBReplica\node3`

The experiment was conducted on a single Windows computer. The three instances simulated separate database nodes; they were not deployed across separate physical machines or cloud servers.

## 4. Replica Set Configuration

The replica set was initialized using MongoDB Shell.

```javascript
rs.initiate({
  _id: "cdrReplicaSet",
  members: [
    { _id: 0, host: "127.0.0.1:27101" },
    { _id: 1, host: "127.0.0.1:27102" },
    { _id: 2, host: "127.0.0.1:27103" }
  ]
})
```

The initialization command returned `ok: 1`.

Replica-set status was inspected using:

```javascript
rs.status().members.map(m => ({
  name: m.name,
  state: m.stateStr,
  health: m.health
}))
```

The initial results confirmed one PRIMARY and two SECONDARY nodes, all reporting `health: 1`.

## 5. Data Replication Experiment

A separate database, `cdr_replication_test`, was created to isolate the replication experiment from the main CDR dataset.

A synthetic call record identified as `REPL_TEST_001` was inserted into the primary node.

The record was subsequently retrieved from both secondary nodes using:

```javascript
use cdr_replication_test

db.call_events.findOne({
  event_id: "REPL_TEST_001"
})
```

Successful retrieval confirmed that the inserted document had been replicated from the primary to the secondary nodes.

## 6. Primary Failure and Automatic Failover

The original primary node, running on port `27101`, was deliberately shut down using:

```javascript
db.adminCommand({ shutdown: 1 })
```

The shell reported that its connection to the node had closed.

Replica-set status was then checked from another available node. The results showed:

| Node | Status after failure | Health |
|---|---|---|
| 127.0.0.1:27101 | Not reachable/healthy | 0 |
| 127.0.0.1:27102 | PRIMARY | 1 |
| 127.0.0.1:27103 | SECONDARY | 1 |

The experiment demonstrated that the remaining nodes elected a new primary without requiring manual reassignment.

## 7. Write Availability After Failover

Following the primary-node failure, a second synthetic record, `REPL_TEST_002`, was inserted into the newly elected primary on port `27102`.

The insertion returned:

```javascript
{
  acknowledged: true,
  insertedId: ObjectId(...)
}
```

This confirmed that the replica set remained writable after the original primary became unavailable.

## 8. Node Recovery and Data Synchronization

The failed MongoDB instance on port `27101` was restarted.

After recovery, replica-set status confirmed that all three nodes were healthy:

| Node | Status after recovery | Health |
|---|---|---|
| 127.0.0.1:27101 | SECONDARY | 1 |
| 127.0.0.1:27102 | PRIMARY | 1 |
| 127.0.0.1:27103 | SECONDARY | 1 |

The following query was executed against the recovered Node 1:

```javascript
use cdr_replication_test

db.call_events.findOne({
  event_id: "REPL_TEST_002"
})
```

The document was retrieved successfully.

Because this record had been inserted while Node 1 was unavailable, its presence on the recovered node demonstrated successful synchronization of the previously missed write.

## 9. Results and Observations

The experiments established that:

1. The MongoDB replica set successfully operated with three healthy nodes.
2. Documents inserted into the primary were replicated to secondary nodes.
3. Failure of the original primary triggered automatic election of a replacement primary.
4. The newly elected primary accepted a write operation.
5. The failed node successfully rejoined the replica set.
6. The recovered node obtained the record inserted during its downtime.

## 10. Relevance to the CDR Analysis System

A CDR Analysis System may need to preserve large volumes of call-event data while supporting continuous analytical operations.

Replication can improve service availability by maintaining copies of data across multiple database nodes. Automatic failover can also reduce interruption when a primary database instance becomes unavailable.

However, replication alone does not replace backups, and this local experiment does not establish performance or fault tolerance across separate physical servers or cloud regions.

## 11. Limitations

The experiment was conducted using three MongoDB instances on a single computer. Consequently, it demonstrated logical node failure and recovery rather than resilience against complete machine failure.

The experiment also did not measure replication latency, throughput under concurrent workloads or cross-region performance.

## 12. Conclusion

This portfolio successfully demonstrated distributed database principles through a three-node MongoDB replica set. The experiments verified data replication, automatic primary election, continued write availability after failover and synchronization following node recovery.

The results illustrate how replication supports database availability and recovery in systems such as the proposed CDR Analysis System.

All call records used in the experiments were synthetic and created solely for academic testing.
