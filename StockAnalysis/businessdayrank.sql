
CREATE PROCEDURE stp_BusinessDayRankings
AS
BEGIN

	CREATE TABLE ##UpperRating(
		StockSymbol VARCHAR(10),
		MonthBusinessDay SMALLINT,
		PercentChange DECIMAL(11,4)
	)

	DECLARE @symbol VARCHAR(10), @begin INT = 1, @max INT, @sql VARCHAR(MAX)
	SELECT @max = MAX(ID) FROM StockTable

	WHILE @begin <= @max
	BEGIN

		SELECT @symbol = StockSymbol FROM StockTable WHERE ID = @begin

		SET @sql = 'INSERT INTO ##UpperRating
		EXECUTE stp_BusinessDay ' + @symbol

		EXECUTE(@sql)

		SET @begin = @begin + 1
		SET @sql = ''

	END

	SELECT *
	FROM ##UpperRating
	WHERE PercentChange > 50
	ORDER BY PercentChange DESC

	DROP TABLE ##UpperRating

END
