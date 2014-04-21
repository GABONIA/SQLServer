CREATE TABLE OldTable(
	ID INT IDENTITY(1,1),
	Value VARCHAR(5),
	ValueDate DATE
)

CREATE TABLE NewerTable(
	ID INT IDENTITY(1,1),
	Value VARCHAR(5),
	ValueDate DATE
)


INSERT INTO OldTable (Value,ValueDate)
VALUES ('A',DATEADD(DD,-1,GETDATE()))


INSERT INTO NewerTable (Value,ValueDate)
VALUES ('B',DATEADD(DD,-1,GETDATE()))
	, ('C',GETDATE())
	











	
SELECT *
FROM OldTable

SELECT *
FROM NewerTable


INSERT INTO OldTable (Value,ValueDate)
SELECT Value
	,ValueDate
FROM NewerTable
WHERE ID NOT IN (SELECT ID FROM OldTable)


UPDATE OldTable
SET OldTable.Value = NewerTable.Value
FROM OldTable
	INNER JOIN NewerTable ON NewerTable.ID = OldTable.ID AND NewerTable.Value <> OldTable.Value

















/*

DROP TABLE OldTable
DROP TABLE NewerTable

*/