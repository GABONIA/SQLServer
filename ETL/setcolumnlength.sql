DECLARE @t NVARCHAR(100) = 'OurStagingTable'

DECLARE @loop TABLE (LoopID INT IDENTITY(1,1), ColumnName NVARCHAR(250))

INSERT INTO @loop (ColumnName)
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @t

DECLARE @b INT = 1, @m INT, @c NVARCHAR(250), @s NVARCHAR(MAX), @s1 NVARCHAR(MAX), @len NVARCHAR(250)
SELECT @m = MAX(LoopID) FROM @loop

WHILE @b <= @m
BEGIN

	SELECT @c = ColumnName FROM @loop WHERE LoopID = @b
	
	SET @s1 = 'SELECT LEN(' + QUOTENAME(@c) + ') FROM ' + QUOTENAME(@t)

	DECLARE @lentab TABLE (LenVal INT)
	INSERT INTO @lentab EXECUTE(@s1)
	SELECT @len = LenVal FROM @lentab
	SET @len = @len + 2

	SET @s = 'ALTER TABLE ' + QUOTENAME(@t) + ' ALTER COLUMN ' + QUOTENAME(@c) + ' VARCHAR(' + @len + ')'
	
	--PRINT @s
	EXECUTE sp_executesql @s

	SET @b = @b + 1

END

/*

CREATE PROCEDURE stp_AutoSetColumnLength
@t NVARCHAR(200)
AS
BEGIN

	DECLARE @loop TABLE (LoopID INT IDENTITY(1,1), ColumnName NVARCHAR(250))

	INSERT INTO @loop (ColumnName)
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @t

	DECLARE @b INT = 1, @m INT, @c NVARCHAR(250), @s NVARCHAR(MAX), @s1 NVARCHAR(MAX), @len NVARCHAR(250)
	SELECT @m = MAX(LoopID) FROM @loop

	WHILE @b <= @m
	BEGIN

		SELECT @c = ColumnName FROM @loop WHERE LoopID = @b

		SET @s1 = 'SELECT LEN(' + QUOTENAME(@c) + ') FROM ' + QUOTENAME(@t)

		DECLARE @lentab TABLE (LenVal INT)
		INSERT INTO @lentab EXECUTE(@s1)
		SELECT @len = LenVal FROM @lentab

		IF @len < 10
		BEGIN
			SET @len = 15
		END
		ELSE
		BEGIN
			SET @len = @len + 25
		END

		SET @s = 'ALTER TABLE ' + QUOTENAME(@t) + ' ALTER COLUMN ' + QUOTENAME(@c) + ' VARCHAR(' + @len + ')'

		--PRINT @s
		EXECUTE sp_executesql @s

		SET @b = @b + 1

	END

END


*/
