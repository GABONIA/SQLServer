-- CREATE SCHEMA weather

CREATE TABLE AURainfall(
	[Product code] VARCHAR(25),
	[Bureau of Meteorology station number] VARCHAR(25),
	[Year] VARCHAR(25),
	[Month] VARCHAR(25),
	[Day] VARCHAR(25),
	[Rainfall amount (millimetres)] VARCHAR(25),
	[Period over which rainfall was measured (days)] VARCHAR(25),
	[Quality] VARCHAR(25)
)

/* 
-- IF needed:
DROP TABLE AURainfall

*/

BULK INSERT AURainfall
FROM 'E:\Datasets\AURainfall.csv'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a',
	FIRSTROW=2)
GO

ALTER SCHEMA weather TRANSFER dbo.AURainfall

CREATE TABLE weather.AUSRainfall(
	AUSRainfallID INT IDENTITY(1,1),
	[Year] VARCHAR(4),
	[Month] VARCHAR(2),
	[Day] VARCHAR(2),
	[Date] DATE,
	[RainfallAmountMM] DECIMAL(9,2)
)

INSERT INTO weather.AUSRainfall ([Year],[Month],[Day],[Date],[RainfallAmountMM])
SELECT [Year]
	, [Month]
	, [Day]
	, [Year] + '-' + [Month] + '-' + [Day]
	, [Rainfall amount (millimetres)]
FROM weather.AURainfall


SELECT [Year]
	,SUM(RainfallAmountMM)
FROM weather.AUSRainfall
GROUP BY [Year]
ORDER BY [Year] DESC
