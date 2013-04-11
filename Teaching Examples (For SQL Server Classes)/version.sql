-- Version Contingent

DECLARE @level TABLE(
  String VARCHAR(3)
)

INSERT INTO @level
SELECT CONVERT(VARCHAR(3),SERVERPROPERTY('productlevel'))

SELECT *
	, CASE 
		WHEN String LIKE 'SP1%' THEN '2013-04-11'
		ELSE '2013' END AS VersionDate
FROM @level
