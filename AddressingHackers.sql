	-- Na na na na
	CREATE TABLE ##Hack(
		LogDate DATETIME,
		ProcessInfo VARCHAR(25),
		Text VARCHAR(500)
	)

	INSERT INTO ##Hack
	EXEC sp_readerrorlog 0,1,'Login failed'

	DECLARE @CountAttempts TABLE(
		UserName VARCHAR(100)
	)

	INSERT INTO @CountAttempts (UserName)
	SELECT SUBSTRING(Text,(CHARINDEX('''',Text)+1),((CHARINDEX('''',Text,(CHARINDEX('''',Text)+1))-(CHARINDEX('''',Text))))-1)
	FROM ##Hack
	WHERE Text LIKE 'Login failed for user%'
		AND LogDate BETWEEN DATEADD(HH,-2,GETDATE()) AND GETDATE()

	SELECT *
	FROM @CountAttempts

		-- Na na na na
	DECLARE @user TABLE(
		   ID INT IDENTITY(1,1),
		   UserName VARCHAR(100)
	)
 
	INSERT INTO @user (UserName)
	SELECT DISTINCT UserName
	FROM @CountAttempts
	GROUP BY UserName
	HAVING COUNT(UserName) > 30

	SELECT *
	FROM @user
 
	DECLARE @begin INT = 1, @max INT, @usr VARCHAR(100), @sql NVARCHAR(MAX)
	SELECT @max = MAX(ID) FROM @user
 
	-- Hey, hey, hey
	WHILE @begin <= @max
	BEGIN
      
		   SELECT @usr = UserName FROM @user WHERE ID = @begin
 
		   -- Goodbye
		   SET @sql = 'ALTER LOGIN ' + @usr + ' DISABLE'
 
		   EXECUTE(@sql)
 
		   SET @begin = @begin + 1
		   SET @sql = ''
 
	END

	DROP TABLE ##Hack
