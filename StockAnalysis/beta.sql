-- Using return from previous day to next day

-- Variance:
SELECT VAR(Price)
FROM stock.SPYHistoricalData

-- Begin covariance and other:
DECLARE @CoVariance TABLE(
	pOne DECIMAL(15,6),
	pTwo DECIMAL(15,6)
)

;WITH CoVCTE AS(
	SELECT ROW_NUMBER() OVER (ORDER BY o.Date) AS ID
		, o.Price AS pOne
		, y.Price AS pTwo
		, o.Date AS Date
	FROM stock.SOHistoricalData o
		INNER JOIN stock.SPYHistoricalData y ON o.Date = y.Date
	WHERE o.Date > '2012-12-31'
)
INSERT INTO @CoVariance
SELECT (((c.pOne - c1.pOne)/(c1.pOne))*100) AS pOne
	, (((c.pTwo - c1.pTwo)/(c1.pTwo))*100) AS pTwo
FROM CoVCTE c
	INNER JOIN CoVCTE c1 ON c.ID = (c1.ID + 1)

DECLARE @s1 DECIMAL(15,6), @s2 DECIMAL(15,6), @s1cnt DECIMAL(15,6), @var DECIMAL(15,6), @cov DECIMAL(15,6), @beta DECIMAL(15,6)

SELECT @s1 = AVG(pOne) FROM @CoVariance
SELECT @s2 = AVG(pTwo) FROM @CoVariance
SELECT @s1cnt = COUNT(pOne) FROM @CoVariance
SELECT @var = VAR(pTwo) FROM @Covariance
SELECT @cov = (1/(@s1cnt-1))*SUM(([pOne]-@s1)*([pTwo]-@s2)) FROM @CoVariance

SELECT @s1, @s2, @s1cnt, @cov

SELECT @beta = (@cov/@var)
SELECT @beta
