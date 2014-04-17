DECLARE @aCount NVARCHAR(MAX) = ''


SELECT @aCount += 'MAX(LEN(' + COLUMN_NAME + ')) AS [' + COLUMN_NAME + '], ' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'OurTable'
SELECT @aCount = 'SELECT ' + LEFT(@aCount, LEN(@aCount)-1) + ' FROM OurTable'
EXECUTE(@aCount)
