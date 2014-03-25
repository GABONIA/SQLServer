ALTER PROCEDURE stp_OutputColumns
@column NVARCHAR(250),
@table NVARCHAR(250)
AS
BEGIN

	/*
	-- Testing:
	DECLARE @columns NVARCHAR(250), @table NVARCHAR(250)
	SET @columns = ''
	SET @table = ''
	*/

	DECLARE @s NVARCHAR(MAX) 

	SET @s = 'DECLARE @c NVARCHAR(4000)

	SELECT @c = STUFF((SELECT DISTINCT TOP 100 PERCENT ''],['' + t.' + @column + '
				FROM ' + @table + ' t
				FOR XML PATH('''')),1,2,'''') + '']''
				
	SELECT @c'

	EXECUTE sp_executesql @s

END

-- For an automatic two-to-many column output pivot table
CREATE PROCEDURE stp_TwoColumnPivot
@PivotColumn VARCHAR(250),
@CalcColumn VARCHAR(250),
@SourceTable VARCHAR(250),
@Function VARCHAR(10)
AS
BEGIN

	DECLARE @c NVARCHAR(4000), @sql NVARCHAR(MAX)

	DECLARE @s TABLE(
		S NVARCHAR(4000)
	)
	
	INSERT INTO @s
	EXECUTE stp_OutputColumns @PivotColumn, @SourceTable
	
	SELECT @c = S FROM @s

	SET @sql = N'SELECT ' + @c + ' FROM (SELECT t.' + @PivotColumn + ', t.' + @CalcColumn + ' FROM ' + @SourceTable + ' t) p
				PIVOT (' + @Function + '(' + @CalcColumn + ') FOR ' + @PivotColumn + ' IN (' + @c + ')) AS pv;'
				
	EXEC sp_executesql @sql
	
END

-- For an automatic three-to-many column output pivot table
CREATE PROCEDURE stp_ThreeColumnPivot
@PivotColumn VARCHAR(250),
@CalcColumn VARCHAR(250),
@NonPivotColumn VARCHAR(250),
@SourceTable VARCHAR(250),
@Function VARCHAR(10)
AS
BEGIN

	DECLARE @c NVARCHAR(4000), @sql NVARCHAR(MAX)

	DECLARE @s TABLE(
		S NVARCHAR(4000)
	)
	
	INSERT INTO @s
	EXECUTE stp_OutputColumns @PivotColumn, @SourceTable
	
	SELECT @c = S FROM @s

	SET @sql = N'SELECT ' + @NonPivotColumn + ', ' + @c + ' FROM (SELECT t.' + @NonPivotColumn + ', t.' + @PivotColumn + ', t.' + @CalcColumn + ' FROM ' + @SourceTable + ' t) p
				PIVOT (' + @Function + '(' + @CalcColumn + ') FOR ' + @PivotColumn + ' IN (' + @c + ')) AS pv;'
				
	EXEC sp_executesql @sql
	
END
