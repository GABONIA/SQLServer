DECLARE @status TABLE(
	ServerName VARCHAR(250),
	DatabaseName VARCHAR(250),
	DatabaseState VARCHAR(25)
)

INSERT INTO @status (ServerName,DatabaseName,DatabaseState)
SELECT @@SERVERNAME
	, name
	, state_desc
FROM sys.databases
WHERE name = 'NAME'

DECLARE @st VARCHAR(25), @s TINYINT = 0, @x TINYINT = 1
SELECT @st = DatabaseState FROM @status WHERE ServerName = 'SERVER'

WHILE @s < @x
BEGIN

	IF @st = 'ONLINE'
	BEGIN

		SET @s = @x
		PRINT 'Server now available!'
		
		SELECT name
		FROM [SETRANS].[sys].[tables]
		ORDER BY name ASC
	
	END
	ELSE
	BEGIN

		WAITFOR DELAY '00:15'
		SET @s = 0

	END

END
