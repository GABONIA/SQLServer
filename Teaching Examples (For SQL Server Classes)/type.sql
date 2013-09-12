/* TYPES - Alternative to temp tables */

CREATE TYPE TwoHundredSMA AS TABLE(
	TwoHundredSMA DECIMAL(13,6)
	, [Date] DATE
)

DECLARE @SMA AS TwoHundredSMA

INSERT INTO @SMA
SELECT TwoHundredDaySMA, [Date]
FROM SPYHistoricalData

SELECT *
FROM @SMA

DROP TYPE TwoHundredSMA
