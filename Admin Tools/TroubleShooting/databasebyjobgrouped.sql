;WITH ihaztehcodez AS(
	SELECT j.name JobName
		, s.database_name DatabaseName
	FROM msdb.dbo.sysjobs j
		INNER JOIN msdb.dbo.sysjobsteps s ON j.job_id = s.job_id
	WHERE s.database_name NOT IN ('master','msdb','tempdb','model')
)
SELECT i.JobName
	, STUFF((SELECT ', ' + i2.DatabaseName AS [text()]
	FROM ihaztehcodez i2
	WHERE i.JobName = i2.JobName
	ORDER BY i2.DatabaseName
	FOR XML PATH('')),1,1,'') AS "Databases"
FROM ihaztehcodez i
GROUP BY i.JobName
