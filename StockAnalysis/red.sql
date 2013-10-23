DECLARE @red TABLE(
	MovementDate DATE,
	Occurance VARCHAR(10)
)


;WITH UpAndDown AS(
	SELECT t1.Date AS MovementDate
		, (((t1.Price - t.Price)/t.Price)*100) AS UpDown
	FROM stock.SPYHistoricalData t
		INNER JOIN stock.SPYHistoricalData t1 ON t.SPYID = (t1.SPYID - 1)
)
INSERT INTO @red
SELECT MovementDate
	, CASE 
	WHEN UpDown > 0 THEN 'Up'
	WHEN UpDown < 0 THEN 'Down'
	ELSE 'Nothing' END AS Occurance
FROM UpAndDown


SELECT DISTINCT Occurance
	, COUNT(Occurance)
FROM @red
GROUP BY Occurance
