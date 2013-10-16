;WITH CTE AS(
	SELECT ROW_NUMBER() OVER (ORDER BY s.Date) ID
		, s.Date
		, s.Price/e.Price AS ERatio
	FROM stock.SPYHistoricalData s
		INNER JOIN stock.HistoricalData e ON s.Date = e.Date
)
SELECT c1.Date
	, c2.Date 
	, c1.ERatio
	, c2.ERatio
	, (((c2.ERatio - c1.ERatio)/c1.ERatio)*100)
FROM CTE c1
	INNER JOIN CTE c2 ON c1.ID = (c2.ID - 250)
