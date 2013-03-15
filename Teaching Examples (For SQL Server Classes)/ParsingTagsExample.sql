/* 

Basic Example of Parsing Tags: Mini-Google Keyword Ranking

*/

CREATE FUNCTION ufn_Ahref (@sitetag VARCHAR(1000))
RETURNS VARCHAR(100)
BEGIN
	SET @sitetag = SUBSTRING(@sitetag,CHARINDEX('>',@sitetag)+1,CHARINDEX('<',@sitetag,2) - (CHARINDEX('>',@sitetag)+1))
	SET @sitetag = RTRIM(LTRIM(@sitetag))
RETURN @sitetag
END

DECLARE @WebsiteTable TABLE(
	AHrefTag VARCHAR(500)
)

INSERT INTO @WebsiteTable VALUES ('<a href="http://www.google.com/">Google</a>')
	,('<a href="http://www.google.com/">Google</a>')
	,('<a href="http://www.google.com/">Google</a>')
	,('<a href="http://www.google.com/">Google</a>')
	,('<a href="http://www.google.com/">Google</a>')
	,('<a href="http://www.googleisawesome.com/">Google</a>')
	,('<a href="http://www.googleisawesome.com/">Google</a>')
	,('<a href="http://www.androidiscool.com">Google</a>')

SELECT DISTINCT dbo.ufn_Ahref(AHrefTag) "Keyword"
	, AHrefTag "Website Tag"
	, COUNT(AHrefTag) "Count"
FROM @WebsiteTable
GROUP BY AHrefTag
ORDER BY COUNT(AhrefTag) DESC