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

CREATE TABLE CleanInflation(
	InflationID INT IDENTITY(1,1),
	SeriesID VARCHAR(20),
	InflationDate SMALLDATETIME,
	Value DECIMAL(9,4)
)

INSERT INTO CleanInflation (SeriesID, InflationDate, Value)
SELECT SeriesID
	, CASE 
	WHEN Period LIKE '%M01%' THEN 01-01 + Year
	WHEN Period LIKE '%M02%' THEN 02-01 + Year
	WHEN Period LIKE '%M03%' THEN 03-01 + Year
	WHEN Period LIKE '%M04%' THEN 04-01 + Year
	WHEN Period LIKE '%M05%' THEN 05-01 + Year
	WHEN Period LIKE '%M06%' THEN 06-01 + Year
	WHEN Period LIKE '%M07%' THEN 07-01 + Year
	WHEN Period LIKE '%M08%' THEN 08-01 + Year
	WHEN Period LIKE '%M09%' THEN 09-01 + Year
	WHEN Period LIKE '%M10%' THEN 10-01 + Year
	WHEN Period LIKE '%M11%' THEN 11-01 + Year
	WHEN Period LIKE '%M12%' THEN 12-01 + Year
	ELSE 99 END AS InflationDate
	, Value
FROM StageInflation
