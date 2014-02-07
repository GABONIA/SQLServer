-- Tracking LinkedServers and Jobs By Keyword

DECLARE @find VARCHAR(100)
-- Keyword
SET @find = 'DEV001'



CREATE TABLE ##zzLinked(
	SRV_NAME VARCHAR(100),
	SRV_PROVIDERNAME VARCHAR(250),
	SRV_PRODUCT VARCHAR(50),
	SRV_DATASOURCE VARCHAR(50),
	SRV_PROVIDERSTRING VARCHAR(1000),
	SRV_LOCATION VARCHAR(250),
	SRV_CAT VARCHAR(250)
)

INSERT INTO ##zzLinked
EXEC sp_linkedservers

SELECT *
FROM ##zzLinked
WHERE SRV_DATASOURCE LIKE '%' + @find + '%'

DROP TABLE ##zzLinked



SELECT DISTINCT j.name
FROM msdb.dbo.sysjobsteps s
	INNER JOIN msdb.dbo.sysjobs j ON s.job_id = j.job_id
WHERE s.step_name LIKE '%' + @find + '%'
	OR s.command LIKE '%' + @find + '%'



DECLARE @loop TABLE(
	ID INT IDENTITY(1,1),
	Name NVARCHAR(200)
)

CREATE TABLE ##r(
	ID INT IDENTITY(1,1),
	Name NVARCHAR(200)
)

INSERT INTO @loop
SELECT name
FROM sys.databases
WHERE database_id NOT IN (1,2,3,4)

DECLARE @b INT = 1, @m INT, @d NVARCHAR(100), @s NVARCHAR(MAX)
SELECT @m = MAX(ID) FROM @loop

WHILE @b <= @m
BEGIN

	SELECT @d = Name FROM @loop WHERE ID = @b

	SET @s = 'DECLARE @f NVARCHAR(100)
	SET @f = @find

	INSERT INTO ##r (Name)
	SELECT name
	FROM ' + @d + '.sys.procedures p
		INNER JOIN sys.syscomments c ON p.object_id = c.id
	WHERE c.text LIKE ''%'' + @f + ''%'''

	EXEC sp_executesql @s, N'@find NVARCHAR(100)',@find

	SET @b = @b + 1

END

SELECT *
FROM ##r

DROP TABLE ##r
