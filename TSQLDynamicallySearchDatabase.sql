DECLARE @tbl VARCHAR(50)
DECLARE @db VARCHAR(50)
DECLARE @value VARCHAR(15)
DECLARE @sql VARCHAR(8000)
-- Change these two values here:
SET @tbl = 'OurTable'
SET @db = 'OurDatabase'
SET @value = 'OurValue'

SET @sql = '

SELECT *
FROM ' + @db + '..' + @tbl + '
WHERE Value = ''' + @value + '''
'
EXEC (@sql)