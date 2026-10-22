// MIT 8103 - Portfolio 5
// MongoDB Replica Set Configuration
// Case Study: CDR Analysis System
//
// Run only when initializing a new, unconfigured replica set.
// Requires three mongod instances already started with
// --replSet cdrReplicaSet on the specified ports.

rs.initiate({
    _id: "cdrReplicaSet",
    members: [
        { _id: 0, host: "127.0.0.1:27101" },
        { _id: 1, host: "127.0.0.1:27102" },
        { _id: 2, host: "127.0.0.1:27103" }
    ]
});

// Verify replica-set membership and health.
// Run after initialization and primary election.
rs.status().members.map(m => ({
    name: m.name,
    state: m.stateStr,
    health: m.health
}));
