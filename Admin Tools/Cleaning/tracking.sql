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