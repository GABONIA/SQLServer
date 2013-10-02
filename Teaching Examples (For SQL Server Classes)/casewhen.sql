WITH BuyingTime AS(
	SELECT SPYID
		, (((TwoHundredDaySMA - Price)/Price)*100) AS SCompare
	FROM stock.SPYHistoricalData
)
SELECT *
FROM BuyingTime
