/*

Database integrity check and verify

*/

IF OBJECT_ID('##DatabaseConsistency') IS NOT NULL
BEGIN
	DROP TABLE ##DatabaseConsistency
END

CREATE TABLE ##DatabaseConsistency(
	Error VARCHAR(10),
	Level VARCHAR(10),
	State VARCHAR(10),
	MessageText VARCHAR(2000),
	RepairLevel VARCHAR(250),
	Status VARCHAR(10),
	DbId VARCHAR(10),
	ObjectID VARCHAR(25),
	IndexID VARCHAR(10),
	PartitionID VARCHAR(10),
	AllocUnitId VARCHAR(10),
	[File] VARCHAR(10),
	Page VARCHAR(10),
	Slot VARCHAR(10),
	RefFile VARCHAR(10),
	RefPage VARCHAR(10),
	RefSlot VARCHAR(10),
	Allocation VARCHAR(10)
)

INSERT INTO ##DatabaseConsistency
EXEC('DBCC CHECKDB(OurDatabaseName) WITH TABLERESULTS')

SELECT *
FROM ##DatabaseConsistency

INSERT INTO admin.IntegrityCheck (Error,Level,State,MessageText,RepairLevel,Status)
SELECT Error, Level ,State, MessageText, RepairLevel, Status
FROM ##DatabaseConsistency

DROP TABLE ##DatabaseConsistency