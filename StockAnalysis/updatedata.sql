-- Step 1: Drop Indexes

CREATE PROCEDURE stp_DropIndex
@sym VARCHAR(200)
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'DROP INDEX [Date] ON [stock].[' + @sym + 'HistoricalData]
	
	DROP INDEX [' + @sym + 'ID] ON [stock].[' + @sym + 'HistoricalData]'

	EXECUTE sp_executesql @sql

END

-- C# update

-- Rebuild indexes
