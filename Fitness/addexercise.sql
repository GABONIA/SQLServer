/*

If the exercise exists as a table in the database, it inserts the weight, repetitions and notes.  If the exercise doesn't exist as a table, it creates the table, then inserts the data into the newly created table.

*/

CREATE PROCEDURE stp_MyDailyExercise
( @movement VARCHAR(250), @weight DECIMAL(9,2), @reps SMALLINT, @notes VARCHAR(500) )
AS
BEGIN
	
	/* For testing purposes only: */
	--DECLARE @movement VARCHAR(250)
	--SET @movement = 'LatPullDown'

	DECLARE @count TINYINT
	SELECT @count = COUNT(name) FROM sys.tables WHERE LOWER(name) = LOWER(@movement)
	-- If table doesn't exist, make it.
	IF @count = 0
	BEGIN
		DECLARE @sql NVARCHAR(MAX)
		SET @sql = 'CREATE TABLE ' + QUOTENAME(@movement) + '(
			[Date] DATE DEFAULT GETDATE(),
			[Weight] DECIMAL(9,2),
			[Repetitions] SMALLINT,
			[Notes] VARCHAR(500)
			)'

		EXEC sp_executesql @sql
	END

	DECLARE @s NVARCHAR(MAX)
	SET @s = 'INSERT INTO ' + QUOTENAME(@movement) + '([Weight],[Repetitions])
		SELECT ' + CAST(@weight AS VARCHAR(11)) + ', ' + CAST(@reps AS VARCHAR(3)) + ', ' + @notes

	EXEC sp_executesql @s

END
