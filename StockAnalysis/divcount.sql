CREATE TABLE #DivCount(
	SymbolID ID,
	DividendYear INT,
	DivDelta DECIMAL(22,4)
)

;WITH Div AS(
	SELECT ROW_NUMBER() OVER (ORDER BY SymbolID, DividendYear) AS Link
		, SymbolID
		, Dividend
		, DividendYear
	FROM DividendTest
)
INSERT INTO #DivCount
SELECT d.SymbolID
	, d2.DividendYear
	, (((d2.Dividend - d.Dividend)/d.Dividend)*100) DivDelta
FROM Div d
	INNER JOIN Div d2 ON d.SymbolID = d2.SymbolID AND d.Link = (d2.Link - 1)


DECLARE @min INT, @begin INT = 1, @max INT, @curr INT, @del DECIMAL(22,4)
SELECT @max = MAX(ID) FROM MainStockTable


WHILE @begin <= @max
BEGIN

	SELECT @min = MIN(DividendYear) FROM #DivCount WHERE SymbolID = @begin
	SELECT @curr = MAX(DividendYear) FROM #DivCount WHERE SymbolID = @begin

	WHILE @min <= @curr
	BEGIN

		SELECT @del = DivDelta FROM #DivCount WHERE DividendYear = @min AND SymbolID = @begin

		IF @del < 0
		BEGIN

			SET @min = @curr + 1

		END
		ELSE
		BEGIN
		
			SET @min = @min + 1

		END

	END


	SET @begin = @begin + 1

END
