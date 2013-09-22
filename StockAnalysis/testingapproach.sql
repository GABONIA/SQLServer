/*

Similar to a straight vs. M-Red approach (not exact, but does break down each)

*/


SET STATISTICS TIME ON


SELECT m.StockSymbol
	, a.Price
FROM dbo.AllHistoricalData a
	INNER JOIN MainStockTable m ON a.ID = m.ID
WHERE m.StockSymbol = 'SO'
	AND a.Date BETWEEN '2011-01-01' AND '2011-03-31' 


PRINT '

First test done

'


DECLARE @sql NVARCHAR(MAX), @sym VARCHAR(250), @begin DATE, @end DATE
SET @sym = '' -- Any enter here
SET @begin = '2011-01-01'
SET @end = '2011-03-31'

SET @sql = 'SELECT ''' + @sym + '''
				, Price
			FROM ' + @sym + 'HistoricalData
			WHERE Date BETWEEN ''' + CAST(@begin AS VARCHAR) + ''' AND ''' + CAST(@end AS VARCHAR) + ''''

EXECUTE(@sql)


PRINT '

Second test done

'


SET STATISTICS TIME OFF


/*

M-Red is 8 times faster; test with more symbols

*/
