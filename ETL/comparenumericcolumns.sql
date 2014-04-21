/*

  Compares two numeric columns to each other; useful for identifying contradictory data (NEVER USE!), if data source has repeat column values.
  
  Pass in parameters:
  1.  First column
  2.  Second column
  3.  Staging table
  4.  Note that ID is assumed here; add ID to parameter if there's multiple ID fields


*/


CREATE PROCEDURE stp_CompareNumericColumns
@c1 NVARCHAR(250),
@c2 NVARCHAR(250),
@t NVARCHAR(250)
AS
BEGIN

	DECLARE @s NVARCHAR(MAX), @id NVARCHAR(25)
	SELECT @id = COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @t AND COLUMN_NAME LIKE '%ID%'
	
	SET @s = 'SELECT ' + QUOTENAME(@id) + '
		, ' + QUOTENAME(@c1) + '
		, ' + QUOTENAME(@c2) + '
	FROM ' + QUOTENAME(@t) + '
	WHERE CAST(' + QUOTENAME(@c1) + ' AS DECIMAL(13,4)) NOT BETWEEN (CAST(' + QUOTENAME(@c2) + ' AS DECIMAL(13,4)) - 0.5) AND (CAST(' + QUOTENAME(@c2) + ' AS DECIMAL(13,4)) + 0.5)
		AND ' + QUOTENAME(@c1) + ' IS NOT NULL
		AND ' + QUOTENAME(@c2) + ' IS NOT NULL
		AND ' + QUOTENAME(@c1) + ' <> ''''
		AND ' + QUOTENAME(@c2) + ' <> ''''
	'

	--PRINT @s
	EXECUTE sp_executesql @s

END
