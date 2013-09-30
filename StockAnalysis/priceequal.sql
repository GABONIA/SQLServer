/*

CREATE TABLE ##TryMe(
	Symbol VARCHAR(250),
	TryMe DECIMAL(22,4),
	Total DECIMAL(22,4)
)

DROP TABLE ##TryMe

*/


DECLARE @sql NVARCHAR(MAX), @begin INT = 1, @max INT, @sym VARCHAR(250)
SELECT @max = MAX(ID) FROM MainStockTable

WHILE @begin <= @max
BEGIN

	SELECT @sym = StockSymbol FROM MainStockTable WHERE ID = @begin

	SET @sql ='
	;WITH SandP AS(
		SELECT s1.Price pOne
			, s2.Price pTwo
		FROM stock.' + @sym + 'HistoricalData s1
			INNER JOIN stock.' + @sym + 'HistoricalData s2 ON s1.' + @sym + 'ID = (s2.' + @sym + 'ID - 1)
	)
	INSERT INTO ##TryMe (Symbol,TryMe)
	SELECT ''' + @sym + ''', COUNT(*)
	FROM SandP
	WHERE pOne = pTwo

	DECLARE @agg DECIMAL(22,4)
	SELECT @agg = COUNT(*) FROM stock.' + @sym + 'HistoricalData
	
	UPDATE ##TryMe
	SET Total = @agg
	WHERE Symbol = ''' + @sym + ''''
	
	EXECUTE(@sql)

	SET @begin = @begin + 1
	SET @sql = ''

END

;WITH PwoofPuddin AS(
	SELECT SUM(TryMe) AS RareEvents
		, SUM(Total) AS LotsaNumbers
	FROM ##TryMe
)
SELECT (RareEvents/LotsaNumbers) AS LOLOLOLOLOL
FROM PwoofPuddin
