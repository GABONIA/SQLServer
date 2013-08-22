/*

Jan 2000 - Aug 2013

*/

CREATE TABLE SoHistoricalData_Stage(
	[Date] VARCHAR(250),
	Price VARCHAR(250)
)

CREATE TABLE SoHistoricalData(
	SOID INT IDENTITY(1,1),
	[Date] DATE,
	Price DECIMAL(9,4),
	TwoHundredDaySMA DECIMAL(12,4)
)

BULK INSERT SoHistoricalData_Stage
FROM 'E:\5I57W6K1.csv'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a')
GO

INSERT INTO SoHistoricalData ([Date],Price)
SELECT *
FROM SoHistoricalData_Stage
WHERE [Date] <> 'DATE'
ORDER BY [Date] ASC

SELECT *
FROM SoHistoricalData

DROP TABLE SoHistoricalData_Stage

DECLARE @first INT = 1, @second INT = 200
DECLARE @avg DECIMAL(10,4)
DECLARE @max INT
SELECT @max = MAX(SOID) FROM SoHistoricalData

WHILE @second <= @max
BEGIN

	SELECT @avg = AVG(Price) FROM SoHistoricalData WHERE SOID BETWEEN @first AND @second

	UPDATE SoHistoricalData
	SET TwoHundredDaySMA = @avg
	WHERE SOID = @second

	SET @first = @first + 1
	SET @second = @second + 1

END


SELECT *
FROM SoHistoricalData
WHERE TwoHundredDaySMA IS NOT NULL
	AND Price < TwoHundredDaySMA
-- 559 rows

SELECT *
FROM SoHistoricalData
WHERE TwoHundredDaySMA IS NOT NULL
	AND Price > TwoHundredDaySMA
-- 2665 rows

SELECT *
FROM SoHistoricalData
WHERE TwoHundredDaySMA IS NOT NULL
	AND Price < (TwoHundredDaySMA + (TwoHundredDaySMA*(-.05)))
-- 135 rows


WITH CTE AS(
	SELECT SOID
		, Price - TwoHundredDaySMA [PriceAbove]
		, (((Price - TwoHundredDaySMA)/TwoHundredDaySMA)*100) [PercentAbove]
	FROM SoHistoricalData
	WHERE TwoHundredDaySMA IS NOT NULL
)
SELECT s2.[Date]
	, s2.[Price]
	, s2.[TwoHundredDaySMA]
	, s1.[PriceAbove]
	, s1.[PercentAbove]
	, s2.[Price] PriceCompare
	, s7.[Price] FiveDaysLater
	, (((s7.[Price] - s2.[Price])/s2.[Price])*100) PercentChangeInFive
	, s30.[Price] ThirtyDaysLater
	, (((s30.[Price] - s2.[Price])/s2.[Price])*100) PercentChangeInThirtyDays
	, s60.[Price] SixtyDaysLater
	, (((s60.[Price] - s2.[Price])/s2.[Price])*100) PercentChangeInSixtyDays
	, s90.[Price] NinetyDaysLater
	, (((s90.[Price] - s2.[Price])/s2.[Price])*100) PercentChangeInNinetyDays
	, s120.[Price] OneHundredTwentyDaysLater
	, (((s120.[Price] - s2.[Price])/s2.[Price])*100) PercentChangeInOneHundredTwentyDays
	, s150.[Price] OneHundredFiftyDaysLater
	, (((s150.[Price] - s2.[Price])/s2.[Price])*100) PercentChangeInOneHundredFiftyDays
FROM CTE s1
	INNER JOIN SoHistoricalData s2 ON s1.SOID = s2.SOID
	INNER JOIN SoHistoricalData s7 ON s2.SOID = (s7.SOID - 5)
	INNER JOIN SoHistoricalData s30 ON s2.SOID = (s30.SOID - 30)
	INNER JOIN SoHistoricalData s60 ON s2.SOID = (s60.SOID - 60)
	INNER JOIN SoHistoricalData s90 ON s2.SOID = (s90.SOID - 90)
	INNER JOIN SoHistoricalData s120 ON s2.SOID = (s120.SOID - 120)
	INNER JOIN SoHistoricalData s150 ON s2.SOID = (s150.SOID - 150)
WHERE s1.[PercentAbove] < -7
ORDER BY s1.[PercentAbove] DESC

/* Twenty Year */

CREATE TABLE SoStageTwo(
	[Date] VARCHAR(100),
	[Open] VARCHAR(100),
	[High] VARCHAR(100),
	[Low] VARCHAR(100),
	[Close] VARCHAR(100),
	[Volume] VARCHAR(100)
)

BULK INSERT SoStageTwo
FROM 'E:\so.csv'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a')
GO

CREATE TABLE SoTableTwo(
	SOID INT IDENTITY(1,1),
	[Date] DATE,
	Price DECIMAL(9,4),
	TwoHundredDaySMA DECIMAL(12,4)
)

INSERT INTO SoTableTwo ([Date],Price)
SELECT CONVERT(DATE,[Date],112)
	, [Close]
FROM SoStageTwo
WHERE Date <> 'n++Date'

DECLARE @first INT = 1, @second INT = 200
DECLARE @avg DECIMAL(10,4)
DECLARE @max INT
SELECT @max = MAX(SOID) FROM SoTableTwo

WHILE @second <= @max
BEGIN

	SELECT @avg = AVG(Price) FROM SoTableTwo WHERE SOID BETWEEN @first AND @second

	UPDATE SoTableTwo
	SET TwoHundredDaySMA = @avg
	WHERE SOID = @second

	SET @first = @first + 1
	SET @second = @second + 1

END
