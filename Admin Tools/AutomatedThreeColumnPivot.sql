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

/*
-- Dependency:

CREATE PROCEDURE stp_OutputColumns
@c_s NVARCHAR(250),
@t NVARCHAR(250)
AS
BEGIN

	DECLARE @s NVARCHAR(MAX) 

	SET @s = 'DECLARE @c NVARCHAR(4000)

	SELECT @c = STUFF((SELECT DISTINCT TOP 100 PERCENT ''],['' + t.' + @c_s + '
				FROM ' + @t + ' t
				FOR XML PATH('''')),1,2,'''') + '']''
				
	SELECT @c'

	EXECUTE sp_executesql @s

END

*/
