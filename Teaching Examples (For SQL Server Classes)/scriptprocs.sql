SELECT p.name
	, STUFF((SELECT ' ' + CAST(c2.colid AS VARCHAR) AS [text()] 
	FROM sys.syscomments c2 
	WHERE c.id = c2.id 
	FOR XML PATH('')),1,1,'') AS "Procs"
FROM sys.syscomments c
	INNER JOIN sys.procedures p ON c.id = p.object_id
GROUP BY p.name, c.id
