/*

Data cleaning for genetic, disease and nutrition data.

*/

--  Automatically cleans tables (we can add to this update)
DECLARE @table VARCHAR(250)
-- Change value to what table you want cleaned
SET @table = ''

DECLARE @clean TABLE(
	CleanID SMALLINT IDENTITY(1,1),
	CleanName VARCHAR(250)
)

INSERT INTO @clean (CleanName)
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE DATA_TYPE = 'nvarchar'
	AND TABLE_NAME = @table

DECLARE @begin INT = 1, @max INT, @column VARCHAR(250), @sql NVARCHAR(MAX)
SELECT @max = MAX(CleanID) FROM @clean

WHILE @begin <= @max
BEGIN

	SELECT @column = CleanName FROM @clean WHERE CleanID = @begin

	SET @sql = 'UPDATE ' + @table + '
	SET ' + @column + ' = ''ND''
	WHERE ' + @column + ' IS NULL
		OR ' + @column + ' = ''~''
		
	UPDATE ' + @table + '
	SET ' + @column + ' = RTRIM(LTRIM(' + @column + '))
	'

	EXECUTE(@sql)

	SET @sql = ''
	SET @begin = @begin + 1

END

/*

Gov data note: the cities aren't even the most populous cities; see http://en.wikipedia.org/wiki/List_of_United_States_cities_by_population.

-- Culprits
('Middle Atlantic'
, 'East North Central'
, 'Seattle-Puget Sound'
, 'Atlanta' -- #40
, 'United States'
, 'South Atlantic'
, 'Midwest'
, 'West North Central'
, 'South'
, 'San Francisco-Oakland' -- #14, #45
, 'Northeast'
, 'Mountain'
, 'West South Central'
, 'San Jose-Monterey' -- #10, Unlisted
, 'New England'
, 'Los Angeles'
, 'East South Central'
, 'West'
, 'Detroit' -- #18
, 'Pacific')

*/
