DECLARE @short DECIMAL(13,4), @long DECIMAL(13,4), @avg DECIMAL(13,4)

DECLARE @shmed TABLE(
	Price DECIMAL(22,4),
	PriceDate DATE
)

INSERT INTO @shmed
SELECT TOP 10 Price, Date
FROM stock.SPYHistoricalData
ORDER BY Date DESC

;WITH ShortMedian AS(
	-- 10 is key:
	SELECT TOP 10 Price
		, ROW_NUMBER() OVER (ORDER BY Price ASC) PA
		, ROW_NUMBER() OVER (ORDER BY Price DESC) PD
	FROM @shmed
	ORDER BY PriceDate DESC
)
SELECT @short = AVG(Price) FROM ShortMedian WHERE PD BETWEEN (PA - 1) AND (PA + 1)


DECLARE @i INT

;WITH Median AS(
        SELECT Date
        , Price
        , ROW_NUMBER() OVER (ORDER BY Price DESC) PD
        FROM stock.SPYHistoricalData
)
SELECT Price
        , PD
        , ROW_NUMBER() OVER (ORDER BY PD DESC) PA
INTO ##Median
FROM Median

SELECT @i = COUNT(*) FROM ##Median
SELECT @i = @i%2

IF @i = 1
	BEGIN
			SELECT @long = Price FROM ##Median WHERE PD = PA
	END
	ELSE
	BEGIN
			SELECT @long = AVG(Price) FROM ##Median WHERE PD BETWEEN (PA - 1) AND (PA + 1)
	END

DROP TABLE ##Median

SELECT @avg = AVG(Price) FROM stock.SPYHistoricalData

SELECT @short "Short"
	, @long "Long"
	, @avg "Avg"
