/* 

  Truncate n% of a table

*/

CREATE PROCEDURE stp_CleanBigTables
@EnterRowSizeOfTablesToTruncate BIGINT
AS
BEGIN

	DECLARE @BetterBe BIGINT
	SET @BetterBe = @EnterRowSizeOfTablesToTruncate


	DECLARE @loop TABLE(
		TableID SMALLINT IDENTITY(1,1),
		TableName VARCHAR(250),
		LeftOverRows BIGINT
	)

	;WITH CountEm AS(
		SELECT DISTINCT o.name AS TableName
			, MAX(CONVERT(BIGINT, ROWS)) AS TotalRows
		FROM sys.sysindexes i
			INNER JOIN sys.objects o ON i.id = o.object_id
			INNER JOIN sys.tables t ON t.name = o.name
		WHERE t.is_ms_shipped = 0
			AND o.name NOT IN (SELECT DISTINCT o.name FROM sys.sysconstraints c INNER JOIN sys.sysobjects o ON o.id = c.id)
			AND o.name NOT IN (SELECT DISTINCT o.name FROM sys.identity_columns i INNER JOIN sys.objects o ON o.object_id = i.object_id WHERE o.is_ms_shipped = 0)
		GROUP BY o.name
	)
	INSERT INTO @loop (TableName, LeftOverRows)
	SELECT TableName
		-- Edit the below percent, depending on how many rows you want to keep (currently set to keep 10%)
		, CAST((.1 * TotalRows) AS BIGINT)
	FROM CountEm
	WHERE TotalRows > @BetterBe

	-- Loop and truncate 90% of each table
	DECLARE @begin SMALLINT = 1, @max SMALLINT, @sql NVARCHAR(MAX), @t VARCHAR(250), @p BIGINT
	SELECT @max = MAX(TableID) FROM @loop

	WHILE @begin <= @max
	BEGIN

		SELECT @t = TableName FROM @loop WHERE TableID = @begin
		SELECT @p = LeftOverRows FROM @loop WHERE TableID = @begin

		SET @sql = 'SELECT TOP ' + CAST(@p AS VARCHAR(22)) + ' *
			INTO ##Holding
			FROM ' + @t + '

			TRUNCATE TABLE ' + @t + '

			INSERT INTO ' + @t + '
			SELECT *
			FROM ##Holding

			DROP TABLE ##Holding'
	
		EXECUTE sp_executesql @sql

		SET @sql = ''
		SET @begin = @begin + 1

	END

END







/* Example: */

CREATE TABLE CleanIt(
	ID INT,
	Name VARCHAR(25)
)

INSERT INTO CleanIt
SELECT (RAND() * 1000)
	, 'durkdurkahstan'
GO 10000

SELECT *
FROM CleanIt


-- Cleaning Process:

DECLARE @cleaning INT, @sql NVARCHAR(MAX)

;WITH CTE AS(
	SELECT COUNT(*) TotalRows
	FROM CleanIt
)
-- The .1 value can be changed to any percent desired
SELECT @cleaning = (TotalRows * .1) FROM CTE

SET @sql = 'SELECT TOP ' + CAST(@cleaning AS VARCHAR(22)) + ' *
INTO ##Holding
FROM CleanIt

TRUNCATE TABLE CleanIt

INSERT INTO CleanIt
SELECT *
FROM ##Holding

DROP TABLE ##Holding'

EXECUTE sp_executesql @sql

SELECT *
FROM CleanIt
