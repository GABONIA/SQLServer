-- 2 CIR
CREATE TABLE Gen(
	[Date] VARCHAR(100),
	[Open] VARCHAR(100),
	[High] VARCHAR(100),
	[Low] VARCHAR(100),
	[Close] VARCHAR(100),
	[Volume] VARCHAR(100),
	[Adj Close] VARCHAR(100)
)


BULK INSERT Gen
FROM 'C:\file.csv'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a'
	,FIRSTROW=2)


CREATE TABLE TG(
	MFID INT IDENTITY(1,1),
	[Date] DATE,
	Price DECIMAL(9,4),
	TwoHundredDaySMA DECIMAL(12,4)
)


INSERT INTO TG ([Date],Price)
SELECT CAST([Date] AS DATE)
	, [Adj Close]
FROM Gen
ORDER BY CAST([Date] AS DATE) ASC


;WITH CTE AS(
	SELECT MIN(Date) Mi
		, MAX(Date) Ma
	FROM Gen
	GROUP BY YEAR(Date)
)
SELECT c.Mi
	, m.Price
	, c.Ma
	, f.Price
	, (((f.Price - m.Price)/m.Price)*100) AS G
FROM CTE c
	INNER JOIN Gen m ON c.Mi = m.Date
	INNER JOIN Gen f ON c.Ma = f.Date

DROP TABLE Gen
