USE durkah
GO

CREATE PROCEDURE stp_RebalanceStockPortfolio
AS
BEGIN

--SELECT OBJECT_ID('StockRebalance')
IF OBJECT_ID('StockRebalance') IS NULL
BEGIN
	CREATE TABLE StockRebalance(
		StockID SMALLINT IDENTITY(1,1),
		Shares DECIMAL(10,4),
		Price DECIMAL(10,2),
		Value DECIMAL(10,2),
		Allocation DECIMAL(10,2)
		)

	INSERT INTO StockRebalance (Shares,Price)
	VALUES (25,25.50)
		, (100,40.25)
		, (35,35.60)

	UPDATE StockRebalance
	SET Value = (Shares * Price)

	DECLARE @sum DECIMAL(10,2)
	SELECT @sum = SUM(Value) FROM StockRebalance

	UPDATE StockRebalance
	SET Allocation = ROUND(((Value/@sum)*100),2)

END

--SELECT OBJECT_ID('ExecuteRebalance')
IF OBJECT_ID('ExecuteRebalance') IS NULL
BEGIN
	CREATE TABLE ExecuteRebalance(
		StockID SMALLINT,
		StockOrder VARCHAR(5),
		Shares DECIMAL(10,4)
		)
END

DECLARE @begin INT, @sql VARCHAR(MAX)
SET @begin = 1

WHILE @begin <= 3
BEGIN

	SET @sql = 'DECLARE @sum DECIMAL(10,2), @userp1 DECIMAL(2,2), @userp2 DECIMAL(2,2), @userp3 DECIMAL(2,2)
	SELECT @sum = SUM(Value) FROM StockRebalance
	SET @userp1 = .2  
	SET @userp2 = .5
	SET @userp3 = .3
	
	INSERT INTO ExecuteRebalance (StockID,StockOrder,Shares)
	SELECT StockID
		, CASE
			WHEN ((@userp' + CAST(@begin AS VARCHAR(1)) + ' * @sum) - Value) > 0 THEN ''Buy''
			ELSE ''Sell'' END AS [Order]
		, (((@userp' + CAST(@begin AS VARCHAR(1)) + ' * @sum) - Value)/Shares)
	FROM StockRebalance
	WHERE StockID = ' + CAST(@begin AS VARCHAR(1))
	
	EXECUTE(@sql)
	
	SET @begin = @begin + 1

END

SELECT *
FROM ExecuteRebalance

TRUNCATE TABLE ExecuteRebalance

END

EXECUTE stp_RebalanceStockPortfolio