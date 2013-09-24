/*

Stock schema tables only

*/

CREATE PROCEDURE stp_StockDataJSONOuput
@sym VARCHAR(250)
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	-- Testing: DECLARE @sym VARCHAR(250) = ''

	SET @sql = 'SELECT ''{"' + @sym + 'ID": "'' + CAST(' + @sym + 'ID AS VARCHAR) + ''",
		"Date": "'' + CAST([Date] AS VARCHAR) + ''"
		"Price": "'' + CAST(Price AS VARCHAR) + ''" 
		"TwoHundredDaySMA": "'' + CAST(TwoHundredDaySMA AS VARCHAR) + ''"}''
	FROM stock.' + @sym + 'HistoricalData'

	EXECUTE(@sql)


END
