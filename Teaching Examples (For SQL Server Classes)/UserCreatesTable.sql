/*

*/

DECLARE @Name VARCHAR(50), @keyword1 VARCHAR(10), @keyword2 VARCHAR(10)
SET @Name = '##UserCreatedTableExample'
SET @keyword1 = 'ColumnOne'
SET @keyword2 = 'ColumnTwo'


DECLARE @sql NVARCHAR(MAX)
SET @sql = N'
CREATE TABLE ' + @Name + '(
  ID BIGINT IDENTITY(1,1),
	Date DATETIME, '
	+ @keyword1 + ' DECIMAL(5,2), '
	+ @keyword2 + ' DECIMAL(5,2)
)'

EXECUTE(@sql)
