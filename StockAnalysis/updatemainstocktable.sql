/****** Object:  StoredProcedure [dbo].[stp_UpdateMainStockTable]    Script Date: 8/23/2013 8:21:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_UpdateMainStockTable]
AS
BEGIN
	
	DECLARE @countOne INT, @countTwo INT, @countThree INT

	INSERT INTO MainStockTable (StockSymbol)
	SELECT StockSymbol
	FROM AddedStockTable
	WHERE StockSymbol NOT IN (SELECT StockSymbol FROM MainStockTable)

	SELECT @countOne = @@ROWCOUNT
	PRINT '
	' + CAST(@countOne AS VARCHAR(2)) + ' rows insert into main stock table.
	'

	DELETE FROM AddedStockTable
	WHERE StockSymbol IN (SELECT StockSymbol FROM MainStockTable)

	SELECT @countTwo = @@ROWCOUNT
	PRINT '
	' + CAST(@countTwo AS VARCHAR(2)) + ' rows removed from added stock table.
	'

	SELECT @countThree = COUNT(*) FROM AddedStockTable

	IF @countThree = 0
	BEGIN
		TRUNCATE TABLE AddedStockTable
		PRINT '
		AddedStockTable cleaned.
		'
	END

END
GO


