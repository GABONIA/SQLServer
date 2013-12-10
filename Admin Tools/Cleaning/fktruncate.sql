-- No FK constraints
DECLARE @loop TABLE(
	TableID INT IDENTITY(1,1),
	TableName VARCHAR(250)
)

;WITH CTE AS(
	SELECT OBJECT_NAME(k.referenced_object_id) Referenced
        , OBJECT_NAME(k.parent_object_id) Parent
	FROM sys.objects o
        INNER JOIN sys.foreign_key_columns k ON o.object_id = k.parent_object_id
)
INSERT INTO @loop (TableName)
SELECT o.name
FROM sys.objects o
        INNER JOIN sys.tables t ON o.object_id = t.object_id
WHERE o.name NOT IN (SELECT Referenced FROM CTE)
        AND o.is_ms_shipped = 0
        AND t.is_ms_shipped = 0


-- FK constraints, order by dependency
INSERT INTO @loop (TableName)
SELECT o.name
	, OBJECT_NAME(k.referenced_object_id) Referenced
	, OBJECT_NAME(k.parent_object_id) Parent
FROM sys.objects o
	INNER JOIN sys.foreign_key_columns k ON o.object_id = k.parent_object_id







/* 
-- Testing:

CREATE TABLE AssociativeTable(
	UniqueID INT IDENTITY(1,1) PRIMARY KEY,
	OtherTableID INT,
	YetAnotherTableID VARCHAR(1),
	CONSTRAINT FFK_OtherTableID UNIQUE(OtherTableID),
	CONSTRAINT FFK_YetAnotherTableID UNIQUE(YetAnotherTableID)
)


CREATE TABLE OtherTable(
	OtherTableID INT PRIMARY KEY,
	Name VARCHAR(50),
	FOREIGN KEY (OtherTableID) REFERENCES AssociativeTable (OtherTableID)
)

CREATE TABLE YetAnotherTable(
	YetAnotherTableID VARCHAR(1) PRIMARY KEY,
	Name VARCHAR(50), 
	FOREIGN KEY (YetAnotherTableID) REFERENCES AssociativeTable (YetAnotherTableID)
)

/* 

DROP TABLE AssociativeTable
DROP TABLE OtherTable
DROP TABLE YetAnotherTable

*/


INSERT INTO AssociativeTable (OtherTableID, YetAnotherTableID)
VALUES (1,'A')
	, (2,'B')
	, (3,'C')

-- Works:
INSERT INTO OtherTable
VALUES (1,'Sarah')
	, (2,'George')
	, (3,'Bob')

*/
