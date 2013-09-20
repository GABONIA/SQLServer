/* 

Theoretical 2-1 split where data aren't adjusted for reporting (usually not a problem)

*/

CREATE PROCEDURE stp_TwoToOneSplit
@splt DATE, @sym VARCHAR(100)
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)

	SET @sym = UPPER(@sym)

	SET @sql = 'DECLARE @early DATE, @split DATE, @late DATE
	SET @split = ''' + CAST(@splt AS VARCHAR) + '''
	SELECT @early = MIN([Date]) FROM ' + @sym + 'HistoricalData
	SELECT @late = MAX([Date]) FROM ' + @sym + 'HistoricalData


	-- Pre-split
	SELECT s1.[Date]
		, s1.SPYID 
		, s1.Price
	FROM ' + @sym + 'HistoricalData s1
	WHERE [Date] BETWEEN @early and @split
	UNION ALL
	-- Post-split
	SELECT s2.[Date] 
		, s2.SPYID 
		, (s2.Price * 2) [Price]
	FROM ' + @sym + 'HistoricalData s2
	WHERE [Date] BETWEEN @split and @late'

	EXECUTE sp_executesql @sql

END
