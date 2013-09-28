;WITH NewSymbols AS(
	SELECT REPLACE(name,'HistoricalData','') NewSymbols
	FROM sys.tables
	WHERE SCHEMA_NAME(schema_id) = 'stock'
)
INSERT INTO MainStockTable
SELECT *
FROM NewSymbols
WHERE NewSymbols NOT IN (SELECT StockSymbol FROM MainStockTable)
