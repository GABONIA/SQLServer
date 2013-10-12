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

-- Step 3: Rebuild indexes

CREATE PROCEDURE stp_UpdateData_RebuildIndexes
@sym VARCHAR(200)
AS
BEGIN

	DECLARE @sql NVARCHAR(MAX)
	SET @sql = 'CREATE CLUSTERED INDEX [Date] ON [stock].[' + @sym + 'HistoricalData]
	(
		[Date] ASC
	)WITH (PAD_INDEX = OFF, FILLFACTOR = 100, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	PRINT ''Clustered index created''

	CREATE NONCLUSTERED INDEX [' + @sym + 'ID] ON [stock].[' + @sym + 'HistoricalData]
	(
		[' + @sym + 'ID] ASC
	)WITH (PAD_INDEX = OFF, FILLFACTOR = 100, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	PRINT ''Non clustered index created'''

END
