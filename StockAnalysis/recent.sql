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



SET @sql = 'CREATE TABLE Stage(
	[Date] VARCHAR(100),
	[Open] VARCHAR(100),
	[High] VARCHAR(100),
	[Low] VARCHAR(100),
	[Close] VARCHAR(100),
	[Volume] VARCHAR(100),
	[Adj Close] VARCHAR(100)
)

BULK INSERT Stage
FROM ''E:\Stocks\Import\table.csv''
WITH (
	FIELDTERMINATOR = '',''
	,ROWTERMINATOR = ''0x0a''
	,FIRSTROW=2)
	
WITH StCt AS(
	SELECT CAST([Adj Close] AS DECIMAL(13,4)) Price,
		CAST([Date] DATE
	FROM Stage
)
INSERT INTO Table
SELECT Price
	, Date
FROM StCT
WHERE Date NOT IN (SELECT Date FROM Table)
ORDER BY Date'
