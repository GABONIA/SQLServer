CREATE PROCEDURE stp_GetStockData
(@symbol VARCHAR(10), @percent DECIMAL(5,2))
AS
BEGIN
	
	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'WITH CTE AS(
		SELECT t1.Date AS [Date]
			, t1.Price
			, t1.TwoHundredDaySMA
			, (((t1.TwoHundredDaySMA - t1.Price)/t1.Price)*100) AS [SMAPercentAboveOrBelowPrice]
			, t2.Price AS [PriceNinetyDaysLater]
		FROM ' + @symbol + 'HistoricalData t1
			INNER JOIN ' + @symbol + 'HistoricalData t2 ON t1.' + @symbol + 'ID = (t2.' + @symbol + 'ID - 90)
	)
	SELECT *
	FROM CTE
	WHERE SMAPercentAboveOrBelowPrice < ' + CAST(@percent AS NVARCHAR(5)) + '
	ORDER BY SMAPercentAboveOrBelowPrice DESC'

	EXECUTE(@sql)

END
