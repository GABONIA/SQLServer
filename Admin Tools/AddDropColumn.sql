CREATE PROCEDURE stp_AddDropColumn
@option TINYINT, @table VARCHAR(250), @columnanddetails VARCHAR(500)
AS
BEGIN
	
	DECLARE @sql NVARCHAR(MAX)

	IF @option = 1
	BEGIN	
		SET @sql = 'ALTER TABLE ' +  @table + ' ADD ' + @columnanddetails
	END
	IF @option = 2
	BEGIN	
		SET @sql = 'ALTER TABLE ' +  @table + ' DROP COLUMN ' + @columnanddetails
	END
	IF @option > 2
	BEGIN		
		PRINT 'Ah, ah, ah, you didn''t sa.. err, type the magic word.'
	END

	EXECUTE(@sql)

END
