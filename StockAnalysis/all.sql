/*

CREATE TABLE AllHistoricalData(
	ID INT,
	[Date] DATE,
	Price DECIMAL(15,4)
)

DROP TABLE AllHistoricalData

*/


DECLARE @begin INT = 1, @symid INT, @sym VARCHAR(10), @max INT, @sql NVARCHAR(MAX)
SELECT @max = MAX(ID) FROM MainStockTable

WHILE @begin <= @max
BEGIN

	SELECT @symid = ID FROM MainStockTable WHERE ID = @begin
	SELECT @sym = StockSymbol FROM MainStockTable WHERE ID = @begin

	SET @sql = 'INSERT INTO AllHistoricalData
		SELECT ' + CAST(@symid AS VARCHAR(10)) + ' 
			, Date
			, Price
		FROM ' + @sym + 'HistoricalData
		ORDER BY Date ASC'

	EXECUTE(@sql)

	SET @begin = @begin + 1
	SET @sql = ''

END

SELECT *
FROM AllHistoricalData
