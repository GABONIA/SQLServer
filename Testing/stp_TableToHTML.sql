CREATE PROCEDURE [dbo].[stp_TableToHTML] 
(
  @query nvarchar(MAX),
  @order nvarchar(MAX) = NULL,
  @html nvarchar(MAX) = NULL OUTPUT
)
AS
BEGIN   

  ---- From SO
	IF @order IS NULL BEGIN
		SET @order = ''  
	END

	SET @order = REPLACE(@order, '''', '''''');

	DECLARE @passquery nvarchar(MAX) = '
		DECLARE @headerRow nvarchar(MAX);
		DECLARE @cols nvarchar(MAX);    

		SELECT * INTO ##zSaveTempThenRem FROM (' + @query + ') sub;

		SELECT @cols = COALESCE(@cols + '', '''''''', '', '''') + ''['' + name + ''] AS ''''td''''''
		FROM tempdb.sys.columns 
		WHERE object_id = object_id(''tempdb..##zSaveTempThenRem'');

		SET @cols = ''SET @html = CAST(( SELECT '' + @cols + '' FROM ##zSaveTempThenRem ' + @order + ' FOR XML PATH(''''tr''''), ELEMENTS XSINIL) AS nvarchar(max))''    

		EXEC sp_executesql @cols, N''@html nvarchar(MAX) OUTPUT'', @html=@html OUTPUT

		SELECT @headerRow = COALESCE(@headerRow + '''', '''') + ''<th>'' + name + ''</th>'' 
		FROM tempdb.sys.columns 
		WHERE object_id = object_id(''tempdb..##zSaveTempThenRem'');

		SET @headerRow = ''<tr>'' + @headerRow + ''</tr>'';

		SET @html = ''<table border="1">'' + @headerRow + @html + ''</table>'';    
	';

	EXEC sp_executesql @passquery, N'@html nvarchar(MAX) OUTPUT', @html=@html OUTPUT


END
