SET STATISTICS TIME ON
SET STATISTICS IO ON

DECLARE @sym VARCHAR(250) = 'SO', @begin DATE = '2011-01-01', @end DATE = '2011-04-01'


PRINT '

Performing test one ...

'


SELECT Price
FROM dbo.AllHistoricalData t1
	INNER JOIN dbo.MainStockTable t2 ON t1.ID = t2.ID
WHERE t2.StockSymbol = @sym
	AND t1.Date BETWEEN @begin AND @end


PRINT '

Test one complete

'


PRINT '

Line break between tests

'


DECLARE @sql NVARCHAR(MAX)
SET @sql = 'SELECT Price
			FROM stock.' + @sym + 'HistoricalData
			WHERE Date BETWEEN ''' + CAST(@begin AS VARCHAR) + ''' AND ''' + CAST(@end AS VARCHAR) + '''
			'


PRINT '

Performing test two ...

'


EXECUTE(@sql)


PRINT '

Test two complete

'

SET STATISTICS TIME OFF
SET STATISTICS IO OFF

