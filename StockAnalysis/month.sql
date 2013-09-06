USE StockAnalysis
GO


-- Ranking for each month
CREATE PROCEDURE stp_MonthToMonth
@sym VARCHAR(10)
AS
BEGIN

	SET @sym = UPPER(@sym)
	
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = ';WITH CTE AS(
		SELECT DATENAME(MONTH, s2.Date) EachMonth
			, (((s2.Price - s.Price)/s.Price)*100) MonthGrowth
		FROM ' + @sym + 'HistoricalData s
			INNER JOIN ' + @sym + 'HistoricalData s2 ON s.Date = DATEADD(MM,-1,s2.Date)
		WHERE DAY(s.Date) = 1
	)
	SELECT DISTINCT EachMonth
		, SUM(MonthGrowth) AS "TotalGrowth"
	FROM CTE
	GROUP BY EachMonth
	ORDER BY TotalGrowth DESC'

	EXECUTE sp_executesql @sql

END


-- All months listed and ranked
CREATE PROCEDURE stp_IndividualMonth
@sym VARCHAR(10)
AS
BEGIN

	SET @sym = UPPER(@sym)
	
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = ';WITH CTE AS(
		SELECT DATENAME(MONTH, s2.Date) EachMonth
			, YEAR(s2.Date) EachYear
			, (((s2.Price - s.Price)/s.Price)*100) MonthGrowth
		FROM ' + @sym + 'HistoricalData s
			INNER JOIN ' + @sym + 'HistoricalData s2 ON s.Date = DATEADD(MM,-1,s2.Date)
		WHERE DAY(s.Date) = 1
	)
	SELECT EachMonth + '' '' + CAST(EachYear AS VARCHAR(4))
		, MonthGrowth
	FROM CTE
	ORDER BY MonthGrowth DESC'


	EXECUTE sp_executesql @sql
END
