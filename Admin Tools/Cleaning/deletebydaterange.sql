/*

Dev script for removing date columns by date range

*/

CREATE PROCEDURE stp_RemoveDatesByDate
       @first DATE,
       @second DATE,
	   @d VARCHAR(100)
AS
BEGIN

       DECLARE @p INT = 0, @this DATE, @that DATE
       SET @this = @first
       SET @that = @second

       IF OBJECT_ID('tempdb..##loop') IS NOT NULL
       BEGIN
              DROP TABLE ##loop
       END

       DECLARE @s NVARCHAR(MAX)
       SET @s = 'SET NOCOUNT ON
              CREATE TABLE ##loop (
                     ID INT IDENTITY(1,1),
                     ColumnName VARCHAR(100),
                     String VARCHAR(500)
              )
       
              INSERT INTO ##loop (ColumnName,String)
              SELECT COLUMN_NAME
                     , TABLE_CATALOG + ''.'' + TABLE_SCHEMA + ''.'' + TABLE_NAME
              FROM ' + @d + '.INFORMATION_SCHEMA.COLUMNS
              WHERE DATA_TYPE LIKE ''%date%''
              '

       EXEC sp_executesql @s

       SET @p = 1

       IF @p = 1
       BEGIN
              DECLARE @begin INT = 1, @max INT, @string VARCHAR(500), @c VARCHAR(100), @sq NVARCHAR(MAX)
              SELECT @max = MAX(ID) FROM ##loop

              WHILE @begin <= @max
              BEGIN
                     SELECT @c = ColumnName FROM ##loop WHERE ID = @begin
                     SELECT @string = String FROM ##loop WHERE ID = @begin

                     SET @sq = 'DELETE FROM ' + @string + '
                     WHERE ' + @c + ' BETWEEN @this AND @that'

                     EXEC sp_executesql @sq, N'@this DATE, @that DATE',@this,@that

                     SET @sq = ''
                     SET @begin = @begin + 1
              END
       END
       ELSE
       BEGIN
              PRINT 'Step One Failed.'
       END

       DROP TABLE ##loop
END
