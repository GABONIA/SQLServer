/*

Using a basic CSV file to calculate a simple five day moving average with the Altria Group stock.

CSV location: https://docs.google.com/file/d/0B9Ry9baXMRI9eTJ5TjhOUUphajg/edit?usp=sharing

*/


CREATE TABLE MovingDayAverageExample(
  StockSymbol VARCHAR(2),
	DateID INT IDENTITY(1,1),
	Price DECIMAL(10,4),
	StockDate DATE,
	FiveDaySMA DECIMAL(10,4)
)


CREATE TABLE StockStage(
	[Date] VARCHAR(100) NULL,
	[Open] VARCHAR(100) NULL,
	[High] VARCHAR(100) NULL,
	[Low] VARCHAR(100) NULL,
	[Close] VARCHAR(100) NULL,
	[Volume] VARCHAR(100) NULL,
	[Adj Close] VARCHAR(100) NULL
)


BULK INSERT StockStage
FROM 'E:\table.csv'
WITH (FIELDTERMINATOR = ',',ROWTERMINATOR = '0x0a')
GO

INSERT INTO MovingDayAverageExample (StockSymbol,Price,StockDate)
SELECT 'MO'
	, [Close]
	, [Date]
FROM StockStage
WHERE [Date] <> 'Date'
	AND [Open] <> 'Open'
ORDER BY Date ASC

DROP TABLE StockStage

DECLARE @first INT = 1, @second INT = 5
DECLARE @avg DECIMAL(10,4)
DECLARE @max INT
SELECT @max = MAX(DateID) FROM MovingDayAverageExample

WHILE @second <= @max
BEGIN

	SELECT @avg = AVG(Price) FROM MovingDayAverageExample WHERE DateID BETWEEN @first AND @second

	UPDATE MovingDayAverageExample
	SET FiveDaySMA = @avg
	WHERE DateID = @second

	SET @first = @first + 1
	SET @second = @second + 1

END

SELECT *
FROM MovingDayAverageExample
