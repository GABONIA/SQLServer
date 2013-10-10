SET STATISTICS TIME ON
SET STATISTICS IO ON

PRINT '

Beginning Test One ...

'



DECLARE @begin SMALLINT = 1, @max SMALLINT
SELECT @max = COUNT(name) FROM sys.databases WHERE name NOT IN ('master','model','msdb','tempdb')

WHILE @begin <= @max
BEGIN

	DECLARE @name VARCHAR(250)
	;WITH n AS(
		SELECT ROW_NUMBER() OVER (ORDER BY name) ID
			, name
		FROM sys.databases
		WHERE name NOT IN ('master','model','msdb','tempdb')
	)
	SELECT @name = name FROM n WHERE ID = @begin

	SELECT @name

	SET @begin = @begin + 1

END



PRINT '

... Test One Complete

'

PRINT '

Beginning Test Two ...

'



DECLARE @DB TABLE(
	DatabaseID SMALLINT IDENTITY(1,1),
	DatabaseName VARCHAR(200)
)


INSERT INTO @DB
SELECT name
FROM sys.databases
WHERE name NOT IN ('master','model','msdb','tempdb')


DECLARE @begin2 SMALLINT = 1, @max2 SMALLINT, @DBN VARCHAR(200)
SELECT @max = MAX(DatabaseID) FROM @DB


WHILE @begin2 <= @max2
BEGIN

	SELECT @DBN = DatabaseName FROM @DB WHERE DatabaseID = @begin2

	SELECT @DBN

	SET @begin = @begin + 1

END



PRINT '

... Test Two Complete

'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF
