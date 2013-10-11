CREATE TABLE DropMeNow(
	ID VARCHAR(2)
)

INSERT INTO DropMeNow
VALUES ('a'),('b'),('c')


CREATE PROCEDURE stp_SQLInjectExOne
@s VARCHAR(300)
AS
BEGIN
	
	
	EXECUTE('SELECT * FROM DropMeNow WHERE ID = ''' + @s + '''')

END

EXECUTE stp_SQLInjectExOne @s = 'a'

EXECUTE stp_SQLInjectExOne @s = 'a'';SELECT * FROM DropMeNow WHERE ''1''=''1'';PRINT ''I controlz teh databaze!'


CREATE PROCEDURE stp_SQLInjectExTwo
@s VARCHAR(300)
AS
BEGIN
	
	DECLARE @sql NVARCHAR(MAX), @vars NVARCHAR(MAX)
	SET @sql = 'SELECT * FROM DropMeNow WHERE ID = @s'
	SET @vars = '@s VARCHAR(300)'
	EXECUTE sp_executesql @sql, @vars

END

EXECUTE stp_SQLInjectExOne @s = 'a'

EXECUTE stp_SQLInjectExTwo @s = 'a'';SELECT * FROM DropMeNow WHERE ''1''=''1'';PRINT ''I controlz teh databaze!'


DROP TABLE DropMeNow
