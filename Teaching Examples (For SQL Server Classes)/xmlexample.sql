-- Ordering with XML

CREATE TABLE ##finance(
  Stock VARCHAR(50),
	DividendYield VARCHAR(50)
)

INSERT INTO ##finance
VALUES ('XYZ','10 Percent')
	, ('YZA','10 Percent')
	, ('ZAB','5 Percent')
	, ('ABC','2 Percent')
	, ('BCD','5 Percent')
	, ('CDE','5 Percent')
	, ('DEF','5 Percent')
	, ('EFG','10 Percent')
	, ('FGH','2 Percent')
	, ('GHI','15 Percent')

SELECT f1.DividendYield
	, STUFF((SELECT ', ' + f2.Stock AS [text()] 
	FROM ##finance f2 
	WHERE f1.DividendYield = f2.DividendYield 
	ORDER BY f2.Stock 
	FOR XML PATH('')),1,1,'') AS "Stocks"
FROM ##finance f1
GROUP BY DividendYield
