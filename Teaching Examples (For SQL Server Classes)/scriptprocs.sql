SELECT p.name
	, STUFF((SELECT ' ' + CAST(c2.colid AS VARCHAR) AS [text()] 
	FROM sys.syscomments c2 
	WHERE c.id = c2.id 
	FOR XML PATH('')),1,1,'') AS "Procs"
FROM sys.syscomments c
	INNER JOIN sys.procedures p ON c.id = p.object_id
GROUP BY p.name, c.id


-- If the maximum number of colids is 4


SELECT DISTINCT p.name
	, MAX(c.text)
FROM sys.syscomments c
	INNER JOIN sys.procedures p ON c.id = p.object_id
GROUP BY p.name
HAVING COUNT(c.colid) = 1


SELECT p.name
	, c.text
	, c2.text
	, c3.text
	, c4.text
	, c.text + c2.text + ISNULL(c3.text,'') + ISNULL(c4.text,'') AS "Full Procedure"
FROM sys.syscomments c
	INNER JOIN sys.procedures p ON c.id = p.object_id
	INNER JOIN sys.syscomments c2 ON c.id = c2.id AND c.colid = (c2.colid - 1)
	LEFT JOIN sys.syscomments c3 ON c.id = c3.id AND c.colid = (c3.colid - 2)
	LEFT JOIN sys.syscomments c4 ON c.id = c4.id AND c.colid = (c4.colid - 3)
WHERE c.colid = 1
	AND c2.colid = 2
	

-- Testing:


DECLARE @proc TABLE(
	ProcName VARCHAR(250),
	ProcText VARCHAR(MAX)
)

-- One
INSERT INTO @proc
SELECT DISTINCT p.name
	, MAX(c.text)
FROM sys.syscomments c
	INNER JOIN sys.procedures p ON c.id = p.object_id
GROUP BY p.name
HAVING COUNT(c.colid) = 1

-- Up to four
INSERT INTO @proc
SELECT p.name
	, c.text + c2.text + ISNULL(c3.text,'') + ISNULL(c4.text,'') AS "Full Procedure"
FROM sys.syscomments c
	INNER JOIN sys.procedures p ON c.id = p.object_id
	INNER JOIN sys.syscomments c2 ON c.id = c2.id AND c.colid = (c2.colid - 1)
	LEFT JOIN sys.syscomments c3 ON c.id = c3.id AND c.colid = (c3.colid - 2)
	LEFT JOIN sys.syscomments c4 ON c.id = c4.id AND c.colid = (c4.colid - 3)
WHERE c.colid = 1
	AND c2.colid = 2

SELECT *
FROM @proc
