DECLARE @remove TABLE(
	TableID INT IDENTITY(1,1),
	TableName VARCHAR(250),
	CreateDate DATE
)

INSERT INTO @remove (TableName,CreateDate)
SELECT name
	, create_date
FROM sys.tables
WHERE name LIKE '%_TBD%'
	OR name LIKE '%_BAK%'
	OR name LIKE '%_BU%'

DECLARE @begin INT = 1, @max INT, @tn VARCHAR(250), @d DATE, @sql NVARCHAR(MAX)
SELECT @max = MAX(TableID) FROM @remove

WHILE @begin <= @max
BEGIN

	SELECT @tn = TableName FROM @remove WHERE TableID = @begin
	SELECT @d = CreateDate FROM @remove WHERE TableID = @begin
	SET @sql = 'DROP TABLE ' + @tn

	IF @d < DATEADD(DD,-60,GETDATE())
	BEGIN
		EXECUTE sp_executesql @sql
	END
	ELSE
	BEGIN
		PRINT 'Backup table still required.'
	END

	SET @sql = ''
	SET @begin = @begin + 1

END
