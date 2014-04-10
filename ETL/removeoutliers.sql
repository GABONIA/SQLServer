CREATE PROCEDURE stp_RemoveOutliers
@t NVARCHAR(100), @v NVARCHAR(100), @dev DECIMAL(3,1), @sh NVARCHAR(15)
AS
BEGIN

	DECLARE @avg NVARCHAR(250), @stdev NVARCHAR(250), @id NVARCHAR(250), @to NVARCHAR(100)
	SELECT @id = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @t AND COLUMN_NAME LIKE 'ID%'
	SELECT @avg = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @t AND COLUMN_NAME LIKE 'Avg%'
	SELECT @stdev = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @t AND COLUMN_NAME LIKE 'StDev%'
	--SET @to = @t + '_NoOutliers'
	SET @to = QUOTENAME(@sh) + '.' + QUOTENAME(@t + '_NoOutliers')

	DECLARE @s NVARCHAR(MAX)
	SET @s = N'IF OBJECT_ID(@to) IS NULL
	BEGIN
	
		;WITH OutOutlier AS(
			SELECT ' + @id + ' NewestID
				, ' + @v + ' OutValue
				, (' + @avg + ' + (' + @stdev + ' *' + CAST(@dev AS NVARCHAR(3)) + ')) OAbove
				, (' + @avg + ' + (' + @stdev + ' *-' + CAST(@dev AS NVARCHAR(3)) + ')) OBelow
			FROM ' + QUOTENAME(@sh) + '.' + QUOTENAME(@t) + '
		)
		SELECT ROW_NUMBER() OVER (ORDER BY ' + @id + ') NoOutlierID
			, t2.*
		--INTO ' + QUOTENAME(@t + '_NoOutliers') + '
		INTO ' + QUOTENAME(@sh) + '.' + QUOTENAME(@t + '_NoOutliers') + '
		FROM OutOutlier t
			INNER JOIN ' + QUOTENAME(@sh) + '.' + QUOTENAME(@t) + ' t2 ON t.NewestID = t2.' + @id + '
		WHERE t.OutValue BETWEEN OBelow AND OAbove
		
		--ALTER TABLE ' + QUOTENAME(@t + '_NoOutliers') + ' DROP COLUMN ' + @id + '
		ALTER TABLE ' + QUOTENAME(@sh) + '.' + QUOTENAME(@t + '_NoOutliers') + ' DROP COLUMN ' + @id + '
	END'

	----Debugging:
	--PRINT @s
	EXEC sp_executesql @s,N'@to NVARCHAR(100)',@to

END

-- 

DECLARE @sh NVARCHAR(15) = 'schema', @v NVARCHAR(100) = 'Price', @b INT = 1, @m INT, @t NVARCHAR(100)

DECLARE @loop TABLE(
  LoopID INT IDENTITY(1,1),
  TableName NVARCHAR(100)
)

INSERT INTO @loop
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = @sh

SELECT @m = MAX(LoopID) FROM @loop

WHILE @b <= @m
BEGIN

	SELECT @t = TableName FROM @loop WHERE LoopID = @b

	EXECUTE stp_RemoveOutliers @t,@v,3.5,@sh

	SET @b = @b + 1

END
