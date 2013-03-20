DECLARE @table TABLE (
	ID INT,
	FirstName VARCHAR(25)
)

INSERT INTO @table VALUES (1,'John'),(1,'Chris'),(2,'Sandra'),(3,'Jane'),(3,NULL)

SELECT *
FROM @table t1
	INNER JOIN @table t2 ON t1.ID = t2.ID
WHERE t1.FirstName = t2.FirstName


