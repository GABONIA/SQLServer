CREATE PROCEDURE stp_BusinessDayChange
@sym VARCHAR(10), @bd SMALLINT
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = ';WITH FirstMonth AS(
		SELECT ' + @sym + 'ID 
			, [Date]
			, MONTH([Date]) AS [Month]
			, ROW_NUMBER() OVER (PARTITION BY MONTH([Date]), YEAR([Date]) ORDER BY MONTH([Date]) ASC) AS [BusinessDayofMonth]
			, Price
		FROM ' + @sym + 'HistoricalData
	)
	SELECT m.Date
		, m.BusinessDayofMonth
		, (((m2.Price - m.Price)/m.Price)*100) AS PercentChange
	FROM FirstMonth m
		INNER JOIN ' + @sym + 'HistoricalData m2 ON m.' + @sym + 'ID = (m2.' + @sym + 'ID - 1)
	WHERE BusinessDayofMonth = ' + CAST(@bd AS VARCHAR(2)) + ''

	EXECUTE(@sql)

END
