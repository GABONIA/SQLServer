CREATE TABLE StageInflation (
	SeriesID VARCHAR(20),
	Year VARCHAR(10),
	Period VARCHAR(5),
	Value DECIMAL(9,4)
)

BULK INSERT StageInflation
FROM 'C:\Inflation Info\testinflationdata.csv'
WITH (FIELDTERMINATOR = ',',ROWTERMINATOR = '\n')
GO

SELECT *
FROM StageInflation

DECLARE @CleanInflation TABLE(
	SeriesID VARCHAR(20),
	IMonth VARCHAR(2),
	IDay VARCHAR(2),
	IYear VARCHAR(4),
	Value DECIMAL(9,4)
)

INSERT INTO @CleanInflation (SeriesID, IMonth, IDay, IYear, Value)
SELECT s.SeriesID
	, CASE 
	WHEN Period LIKE '%M01%' THEN 01
	WHEN Period LIKE '%M02%' THEN 02
	WHEN Period LIKE '%M03%' THEN 03
	WHEN Period LIKE '%M04%' THEN 04
	WHEN Period LIKE '%M05%' THEN 05
	WHEN Period LIKE '%M06%' THEN 06
	WHEN Period LIKE '%M07%' THEN 07
	WHEN Period LIKE '%M08%' THEN 08
	WHEN Period LIKE '%M09%' THEN 09
	WHEN Period LIKE '%M10%' THEN 10
	WHEN Period LIKE '%M11%' THEN 11
	WHEN Period LIKE '%M12%' THEN 12
	ELSE 99 END AS InflationDate
	, 01
	, s.Year
	, s.Value
FROM StageInflation s

CREATE TABLE Inflation(
	InflationID INT IDENTITY(1,1),
	SeriesID VARCHAR(20),
	InflationDate SMALLDATETIME,
	Value DECIMAL(9,4)
)

INSERT INTO Inflation (SeriesID, InflationDate, Value)
SELECT si.SeriesID, si.IMonth + '-' + si.IDay + '-' + si.IYear, si.Value
FROM @CleanInflation si

SELECT *
FROM Inflation
ORDER BY InflationID ASC

CREATE CLUSTERED INDEX [IX_IDandDate] ON [dbo].[Inflation] (
	[InflationID] ASC,
	[InflationDate] ASC
)
WITH (STATISTICS_NORECOMPUTE  = OFF
	, SORT_IN_TEMPDB = OFF
	, IGNORE_DUP_KEY = OFF
	, DROP_EXISTING = OFF
	, ONLINE = OFF
	, ALLOW_ROW_LOCKS  = ON
	, ALLOW_PAGE_LOCKS  = ON
) ON [PRIMARY]


--DROP TABLE Inflation