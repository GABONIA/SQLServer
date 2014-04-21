CREATE PROCEDURE stp_TwoHundredSMA
@t NVARCHAR(250),
@v NVARCHAR(250)
AS
BEGIN

	DECLARE @id NVARCHAR(250)
	SELECT @id = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @t AND COLUMN_NAME LIKE '%ID%'

	DECLARE @s NVARCHAR(MAX)

	SET @s = 'ALTER TABLE ' + QUOTENAME(@t) + ' ADD TwoHundredSMA DECIMAL(13,4)
	
	DECLARE @first INT = 1, @second INT = 200, @avg DECIMAL(13,4), @max INT
	SELECT @max = MAX(' + QUOTENAME(@id) + ') FROM ' + QUOTENAME(@t) + '

	WHILE @second <= @max
	BEGIN

		SELECT @avg = AVG(' + QUOTENAME(@v) + ') FROM ' + QUOTENAME(@t) + ' WHERE ' + QUOTENAME(@id) + ' BETWEEN @first AND @second

		UPDATE ' + QUOTENAME(@t) + '
		SET TwoHundredDaySMA = @avg
		WHERE ' + QUOTENAME(@id) + ' = @second

		SET @first = @first + 1
		SET @second = @second + 1

	END'

	--PRINT @s
	EXECUTE sp_executesql @s

END