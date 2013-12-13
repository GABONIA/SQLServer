;WITH CTE AS(
	SELECT DISTINCT CAST(TableDate AS DATE) Date
		, AVG(TablePrice) AvgPrice
	FROM TablelData
	GROUP BY CAST(TableDate AS DATE)
)
SELECT c.Date
	, CAST((c.AvgPrice/g.Price) AS DECIMAL(13,4)) AS TToGoldRatio
	, CAST((g.Price/c.AvgPrice) AS DECIMAL(13,4)) AS GoldToTRatio
FROM CTE c
	INNER JOIN GData g ON c.Date = g.Date
ORDER BY c.Date
