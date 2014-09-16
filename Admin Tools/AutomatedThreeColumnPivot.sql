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
	--  See dependency in notes below this procedure:
	EXECUTE stp_OutputColumns @PivotColumn, @SourceTable

	SELECT @c = S FROM @s

	SET @sql = N'SELECT ' + @NonPivotColumn + ', ' + @c + ' FROM (SELECT t.' + @NonPivotColumn + ', t.' + @PivotColumn + ', t.' + @CalcColumn + ' FROM ' + @SourceTable + ' t) p
				PIVOT (' + @Function + '(' + @CalcColumn + ') FOR ' + @PivotColumn + ' IN (' + @c + ')) AS pv;'

	EXEC sp_executesql @sql

END

/*
-- Dependency:
-- Changed to use INF_SCH

CREATE PROCEDURE stp_OutputColumns
@c_s NVARCHAR(100),
@t NVARCHAR(200)
AS
BEGIN

	DECLARE @oltpps VARCHAR(400)

	SELECT @oltpps = 'SELECT STUFF((SELECT DISTINCT ''],['' + t.' + COLUMN_NAME + ' FROM ' + TABLE_NAME + ' t FOR XML PATH('''')),1,2,'''') + '']'''
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @t
		AND COLUMN_NAME = @c_s
		
	EXEC(@oltpps)

END

*/
