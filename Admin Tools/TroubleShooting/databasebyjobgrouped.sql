;WITH ihaztehcodez AS(
	SELECT j.name JobName
		, CASE 
			WHEN s.database_name IS NULL THEN 'Package'
			ELSE s.database_name 
		END AS DatabaseName
	FROM msdb.dbo.sysjobs j
		INNER JOIN msdb.dbo.sysjobsteps s ON j.job_id = s.job_id
)
SELECT i.JobName
	, STUFF((SELECT ', ' + i2.DatabaseName AS [text()]
	FROM ihaztehcodez i2
	WHERE i.JobName = i2.JobName
	ORDER BY i2.DatabaseName
	FOR XML PATH('')),1,1,'') AS "Databases"
--INTO ##Compare (if needing to compare)
FROM ihaztehcodez i
GROUP BY i.JobName
