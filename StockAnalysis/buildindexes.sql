USE [StockAnalysis]
GO

/****** Object:  StoredProcedure [dbo].[stp_BuildIndexes]    Script Date: 8/24/2013 5:24:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[stp_BuildIndexes]
AS
BEGIN

	DECLARE @begin INT = 1
	DECLARE @max INT
	DECLARE @symbol VARCHAR(10)
	SELECT @max = MAX(ID) FROM indexing.NewIndex

	WHILE @begin <= @max
	BEGIN
		
		SELECT @symbol = StockSymbol FROM indexing.NewIndex WHERE ID = @begin

		DECLARE @sql NVARCHAR(MAX)
		SET @sql = 'CREATE CLUSTERED INDEX [Date] ON [stock].[' + @symbol + 'HistoricalData]
		(
			[Date] ASC
		)WITH (PAD_INDEX = OFF, FILLFACTOR = 100, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		PRINT ''Clustered index created''

		CREATE NONCLUSTERED INDEX [' + @symbol + 'ID] ON [stock].[' + @symbol + 'HistoricalData]
		(
			[' + @symbol + 'ID] ASC
		)WITH (PAD_INDEX = OFF, FILLFACTOR = 100, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

		PRINT ''Non clustered index created'''

		EXECUTE(@sql)

		SET @begin = @begin + 1
		SET @sql = ''

	END

	TRUNCATE TABLE indexing.NewIndex

END
GO


