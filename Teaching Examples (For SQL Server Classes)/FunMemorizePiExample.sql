/* 

Fun Exercise: suppose we wanted to memorize Pi to the 100th decimal place and decided to break it down.  Using a WHILE loop
with SQL Server and a table with the day number and five digits of pi that we would memorize each day, how would we break down
100 digits of pi into a table to memorize 5 digits a day.

One possible solution below this:

*/

-- Create our pi table and insert it to the 100th decimal place
CREATE TABLE #Pi(
	Value VARCHAR(102)
)

INSERT INTO #Pi VALUES ('3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679')

-- Set up three variables: one to count the full value of pi, one to declare the starting position for the SUBSTRING function, and one for the day number
DECLARE @count INT
SELECT @count = LEN(Value) FROM #Pi
DECLARE @start INT
SET @start = 0
DECLARE @day INT
SET @day = 1

-- Create our 5 digit memorize table
DECLARE @memorize TABLE(
		DayNumber VARCHAR(10),
		DailyMemorize VARCHAR(5)
	)

-- Our while loop starts with a 0 value, which is below the full count; while the start value is below the count, it continues
WHILE @start < @count
BEGIN
	INSERT INTO @memorize
	SELECT 'Day ' + CAST(@day AS VARCHAR(2))
		,SUBSTRING(Value,@start,5)
	FROM #Pi
	-- Adds five values to the start variable
	SET @start = @start + 5
	-- Adds one value to the day variable
	SET @day = @day + 1
END

-- View our results
SELECT *
FROM @memorize