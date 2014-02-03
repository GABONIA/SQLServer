/*

--  See comments (CHANGE) for where to edit this script

*/


SET NOCOUNT ON


DECLARE @loop TABLE(
	ID INT IDENTITY(1,1),
	Name VARCHAR(25)
)


INSERT INTO @loop (Name)
SELECT name
FROM sys.databases
-- CHANGE the below code:
WHERE name LIKE 'Name%'


DECLARE @b INT = 1, @m INT, @s NVARCHAR(MAX), @d NVARCHAR(25)
SELECT @m = MAX(ID) FROM @loop

WHILE @b <= @m
BEGIN

	SELECT @d = Name FROM @loop WHERE ID = @b

	SET @s = N'
	  -- CHANGE: only if the database is part of an availability group as a Secondary Database
	  ALTER DATABASE ' + @d + ' SET HADR OFF;
	
		DROP DATABASE ' + @d + '
		IF @@ERROR = 0
		BEGIN
			PRINT ''Removed database ' + @d + '.''
		END
		ELSE
		BEGIN
			RAISERROR(''Failed to remove database ' + @d + ''',16,1)
		END'

	EXECUTE sp_executesql @s

	SET @b = @b + 1

END
