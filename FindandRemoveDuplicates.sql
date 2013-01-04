/* Finds duplicates in a table and returns the distinct key column of the duplicate 

OurColumn is where we put our unique column identifier
OurTableName is where we put our table that has duplicates

*/
;WITH DuplicateFinder (OurColumn,DupCounter)
AS
(SELECT OurColumn
,ROW_NUMBER() OVER(PARTITION BY OurColumn ORDER BY OurColumn) AS DupCounter
FROM OurTableName)
SELECT * INTO #investigate FROM DuplicateFinder
WHERE DupCounter > 1

SELECT DISTINCT OurColumn
FROM #investigate

/* Deletes duplicates in a table; this assumes that our table has duplicates across all columns

OurColumn is where we put our unique column identifier
OurTableName is where we put our table that has duplicates

*/
;WITH DuplicateRemover (OurColumn,DupCounter)
AS
(SELECT OurColumn
,ROW_NUMBER() OVER(PARTITION BY OurColumn ORDER BY OurColumn) AS DupCounter
FROM OurTableName)
DELETE FROM DuplicateRemover
WHERE DupCounter > 1