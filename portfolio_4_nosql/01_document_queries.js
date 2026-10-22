
/*
MIT 8103 - Advanced Database Systems
Portfolio 4: MongoDB Document Retrieval
Case Study: CDR Analysis System

Dataset: 9,500 validated synthetic CDR records
Database: cdr_analysis_nosql
Collection: call_events
*/

// Select the database.
const dbCDR = db.getSiblingDB("cdr_analysis_nosql");

// Query 1: Retrieve outgoing calls from a selected number.
dbCDR.call_events.find({
  originating_number: "999000000000399"
});

// Query 2: Retrieve both outgoing and incoming calls.
dbCDR.call_events.find({
  $or: [
    { originating_number: "999000000000399" },
    { receiving_number: "999000000000399" }
  ]
});

// Query 3: Count all imported CDR documents.
dbCDR.call_events.countDocuments({});
