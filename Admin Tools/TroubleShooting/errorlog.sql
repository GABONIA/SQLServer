DECLARE @elog NVARCHAR(100), @c NVARCHAR(MAX)
--SET @elog = ''

CREATE TABLE ErrorLogTemp(
	LogDate DATETIME,
	ProcessInfo VARCHAR(25),
	LogText VARCHAR(1000)
)

IF @elog IS NULL
BEGIN
	SET @c = 'EXECUTE sp_readerrorlog 0,1'
END
ELSE
BEGIN
	SET @c = 'EXECUTE sp_readerrorlog 0,1' + @elog
END

INSERT INTO ErrorLogTemp
EXECUTE(@c)


SELECT *
FROM ErrorLogTemp

DROP TABLE ErrorLogTemp
