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
	
-- Proc approach

CREATE PROCEDURE stp_QuarterGrowth
@sym VARCHAR(50)
AS
BEGIN

	SET @sym = UPPER(@sym)
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = 'CREATE TABLE ##QuarterTable(
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
	SELECT ' + @sym + 'ID
		, ''Q'' + CAST(DATENAME(Quarter, Date) AS VARCHAR) + '' '' + CAST(YEAR(Date) AS VARCHAR)
		, Price
		, Date
	FROM ' + @sym + 'HistoricalData
	ORDER BY Date

	INSERT INTO ##Q
	SELECT *
		, ROW_NUMBER() OVER(PARTITION BY FullQuarter ORDER BY StockID) AS QuarterCount
	FROM ##QuarterTable

	DROP TABLE ##QuarterTable

	;WITH QuarterAnalysis AS(
		SELECT DISTINCT FullQuarter AS [FullQuarter]
			, MIN(QuarterCount) AS [MinQ]
			, MAX(QuarterCount) AS [MaxQ]
		FROM ##Q
		GROUP BY FullQuarter
	)
	SELECT a.FullQuarter 
		, (((q2.Price - q.Price)/q.Price)*100) AS QDiff
	FROM QuarterAnalysis a
		INNER JOIN ##Q q ON a.FullQuarter = q.FullQuarter AND q.QuarterCount = a.MinQ
		INNER JOIN ##Q q2 ON a.FullQuarter = q2.FullQuarter AND q2.QuarterCount = a.MaxQ

	DROP TABLE ##Q'

	EXECUTE(@sql)

END

-- Monthly data reported by quarter

DECLARE @monthly TABLE(
	ID INT,
	MonthlyDate DATE,
	MonthlyRate DECIMAL(9,4),
	QuarterAvg DECIMAL(11,6)
)

INSERT INTO @monthly (ID,MonthlyDate,MonthlyRate)
SELECT ROW_NUMBER() OVER (ORDER BY MonthlyDate) AS ID
	, MonthlyDate
	, MonthlyRate
FROM OurMonthlyData
WHERE MonthlyDate > '1998-12-01'

DECLARE @begin INT = 1, @max INT, @avg DECIMAL(11,6)
SELECT @max = MAX(ID) FROM @monthly

WHILE @begin <= @max
BEGIN
	
	SELECT @avg = AVG(MonthlyRate) FROM @monthly WHERE ID BETWEEN @begin AND (@begin + 2)

	UPDATE @monthly
	SET QuarterAvg = @avg
	WHERE ID = (@begin + 2)

	SET @begin = @begin + 3

END

SELECT MonthlyDate
	, 'Q' + CAST(DATENAME(Quarter, MonthlyDate) AS VARCHAR) + ' ' + CAST(YEAR(MonthlyDate) AS VARCHAR) AS [Quarter]
	, QuarterAvg
FROM @monthly
WHERE QuarterAvg IS NOT NULL
