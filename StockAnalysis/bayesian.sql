-- First

CREATE TABLE ##QuarterTable(
	StockID INT,
	FullQuarter VARCHAR(25),
	Price DECIMAL(11,4),
	StockDate DATE
)

CREATE TABLE ##Q(
	StockID INT,
	FullQuarter VARCHAR(25),
	Price DECIMAL(11,4),
	StockDate DATE,
	QuarterCount INT
)


INSERT INTO ##QuarterTable (StockID,FullQuarter,Price,StockDate)
SELECT SPYID
	, 'Q' + CAST(DATENAME(Quarter, Date) AS VARCHAR) + ' ' + CAST(YEAR(Date) AS VARCHAR)
	, Price
	, Date
FROM SPYHistoricalData
ORDER BY Date


INSERT INTO ##Q
SELECT *
	, ROW_NUMBER() OVER(PARTITION BY FullQuarter ORDER BY StockID) AS QuarterCount
FROM ##QuarterTable

DROP TABLE ##QuarterTable

SELECT *
FROM ##Q

WITH QuarterAnalysis AS(
	SELECT DISTINCT FullQuarter AS [FullQuarter]
		, MIN(QuarterCount) AS [MinQ]
		, MAX(QuarterCount) AS [MaxQ]
	FROM ##Q
	GROUP BY FullQuarter
)
SELECT (((q2.Price - q.Price)/q.Price)*100) AS QDiff
FROM QuarterAnalysis a
	INNER JOIN ##Q q ON a.FullQuarter = q.FullQuarter AND q.QuarterCount = a.MinQ
	INNER JOIN ##Q q2 ON a.FullQuarter = q2.FullQuarter AND q2.QuarterCount = a.MaxQ
