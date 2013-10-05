-- Catch the outliers
-- Business day for every month

-- If outlier, flag
SELECT BusinessDaysEachMonth
FROM BusinessDayTable
WHERE PercentChange > 10

-- If consistent, highlight
SELECT BusinessDaysEachMonth
FROM BusinessDayTable
WHERE PercentChange < 10


WITH MonthCTE AS(
	SELECT SOID 
		, Price
		, Date
		, ROW_NUMBER() OVER(PARTITION BY MONTH(Date), YEAR(Date) ORDER BY MONTH(Date) DESC) AS BusinessDaysEachMonth
	FROM stock.SOHistoricalData
)
SELECT c.Date
	, (((s.Price - c.Price)/c.Price)*100) AS PercentChange
FROM MonthCTE c
	INNER JOIN stock.SOHistoricalData s ON c.SOID = (s.SOID - 1)
