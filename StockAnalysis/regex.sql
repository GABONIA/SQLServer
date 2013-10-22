DECLARE @min TABLE(
	Price VARCHAR(10)
)


INSERT INTO @min
SELECT Price
FROM stock.SPYHistoricalData


INSERT INTO @min
VALUES ('2z4.46')
	, ('t78.1')
	, ('3.4ll')


SELECT Price
FROM @min
WHERE Price LIKE '%[0-9][0-9][0-9][0-9]%'


SELECT Price
FROM @min
WHERE Price NOT LIKE '%[0-9][0-9][0-9][0-9]%'
