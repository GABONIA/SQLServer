CREATE TABLE ##Rec (
	Symbol VARCHAR(25),
	StDate DATE
)

DECLARE @begin INT = 1, @max INT, @sql NVARCHAR(MAX), @s VARCHAR(25)
SELECT @max = MAX(ID) FROM MainStockTable

WHILE @begin <= @max
BEGIN

	SELECT @s = StockSymbol FROM MainStockTable WHERE ID = @begin
	
	SET @sql = 'INSERT INTO ##Rec
	SELECT ''' + @s + '''
		, MAX(Date)
	FROM stock.' + @s + 'HistoricalData'

	EXEC sp_executesql @sql

	SET @begin = @begin + 1
	SET @sql = ''

END

SELECT *
FROM ##Rec

DROP TABLE ##Rec
