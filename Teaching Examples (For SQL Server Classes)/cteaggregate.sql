/*

CTEs for aggregation

*/

CREATE TABLE ##Sales(
  Person VARCHAR(25),
	Sales INT
)

INSERT INTO ##Sales
VALUES ('John',100)
	, ('John',100)
	, ('John',250)
	, ('Jane',300)
	, ('Jane',50)
	, ('John',400)
	, ('Bob',200)
	, ('Belize',150)
	, ('Bob',20)
	, ('Belize',40)
	, ('Belize',20)
	, ('Bob',100)
	, ('John',250)
	, ('Fred',50)
	, ('Francesca',500)
	, ('Fred',20)
	, ('Jane',100)
	, ('Fred',30)
	, ('Fred',10)
	, ('Fred',20)
	, ('Francesca',300)
	, ('John',200)
	, ('Belize',80)
	, ('Fred',10)
	, ('Bob',100)

;WITH CTE AS(
	SELECT DISTINCT Person
		, SUM(Sales) [TotalSalesAmount]
		, COUNT(Sales) [TotalSales]
		, (SUM(Sales)/COUNT(Sales)) [AmountPerSale]
	FROM ##Sales
	GROUP BY Person
)
SELECT *
FROM CTE
ORDER BY TotalSalesAmount DESC


;WITH CTE AS(
	SELECT DISTINCT Person
		, SUM(Sales) [TotalSalesAmount]
		, COUNT(Sales) [TotalSales]
	FROM ##Sales
	GROUP BY Person
)
SELECT TOP (25)PERCENT TotalSalesAmount, Person
FROM CTE
ORDER BY [TotalSalesAmount] DESC


;WITH CTE AS(
	SELECT DISTINCT Person
		, SUM(Sales) [TotalSalesAmount]
		, COUNT(Sales) [TotalSales]
	FROM ##Sales
	GROUP BY Person
)
SELECT TOP (25)PERCENT TotalSalesAmount, Person
FROM CTE
ORDER BY [TotalSalesAmount] ASC


DROP TABLE ##Sales
