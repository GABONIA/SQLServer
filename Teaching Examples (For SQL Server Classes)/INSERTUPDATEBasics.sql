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





/*

DROP TABLE OldTable
DROP TABLE NewerTable

*/