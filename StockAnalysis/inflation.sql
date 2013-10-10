CREATE PROCEDURE stp_Inflation
@original DECIMAL(22,4), @inflation DECIMAL(22,4), @years SMALLINT
AS
BEGIN

	CREATE TABLE ##Inflation(
		InflationID SMALLINT IDENTITY(1,1),
		OriginalAmount DECIMAL(22,4),
		InflatedAmountPerYear DECIMAL(22,4),
		RemainingAmount DECIMAL(22,4) 
	)

	INSERT INTO ##Inflation (OriginalAmount,InflatedAmountPerYear,RemainingAmount)
	SELECT @original AS OriginalAmount
		, (@original * @inflation) AS InflatedAmountPerYear
		, (@original - (@original * @inflation)) AS RemainingAmount

	DECLARE @begin SMALLINT = 2

	WHILE @begin <= @years
	BEGIN

		;WITH Inf AS(
			SELECT InflationID
				, RemainingAmount
			FROM ##Inflation
			WHERE InflationID = (@begin - 1)
		)
		INSERT INTO ##Inflation (OriginalAmount,InflatedAmountPerYear,RemainingAmount)
		SELECT i.RemainingAmount, (i.RemainingAmount * @inflation), (i.RemainingAmount - (i.RemainingAmount * @inflation))
		FROM Inf i

		SET @begin = @begin + 1

	END

	SELECT *
	FROM ##Inflation

	DROP TABLE ##Inflation

END

/*

EXECUTE stp_Inflation 100000,.04,40

*/
