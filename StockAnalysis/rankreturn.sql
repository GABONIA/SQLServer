USE StockAnalysis
GO

CREATE PROCEDURE stp_BusinessDayMinion
AS
BEGIN
	/* 
	-- Reference
	
	SELECT *
	FROM temp.BizMinion
	WHERE PercentChange > 10
		AND StockSymbol = 'M'

	*/

	SELECT b1.StockSymbol
		, STUFF((SELECT ', ' + CAST(b2.MonthBusinessDay AS VARCHAR) AS [text()] 
		FROM temp.BizMinion b2
		WHERE b1.StockSymbol = b2.StockSymbol
			AND b2.PercentChange > 10
		ORDER BY b2.StockSymbol
		FOR XML PATH('')),1,1,'') AS "BusinessDays"
	INTO #check
	FROM temp.BizMinion b1
	GROUP BY b1.StockSymbol

	SELECT DISTINCT b.StockSymbol
		, SUM(b.PercentChange) AS Total
		, c.BusinessDays
	FROM temp.BizMinion b
		INNER JOIN #check c ON c.StockSymbol = b.StockSymbol
	WHERE b.PercentChange > 10
	GROUP BY b.StockSymbol, c.BusinessDays
	ORDER BY Total DESC

	DROP TABLE #check

END
