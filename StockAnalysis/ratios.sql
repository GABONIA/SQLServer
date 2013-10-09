;WITH GtoS AS(
	SELECT ROW_NUMBER() OVER (ORDER BY s.Date) AS ID
		, s.Date AS RatioDate
		, s.Price/g.Price AS StoGRatio
		, s.TwoHundredDaySMA/g.TwoHundredDaySMA TwoHundredRatio
	FROM stock.SPYHistoricalData s
		INNER JOIN stock.GLDHistoricalData g ON s.Date = g.Date
)
SELECT o.RatioDate
	, o.StoGRatio
	, o.TwoHundredRatio
	, two.StoGRatio AS Earlier
	, th.StoGRatio AS Later
FROM GtoS o
	INNER JOIN GtoS two ON o.ID = (two.ID + 100)
	INNER JOIN GtoS th ON o.ID = (th.ID - 100)
WHERE o.TwoHundredRatio NOT BETWEEN (o.StoGRatio - .6) AND (o.StoGRatio + .6)
