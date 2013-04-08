/*

Get the day number, day name and day id (meaning 1 - 7) of each day for the week.

*/

DECLARE @day TABLE(
  DayID TINYINT,
	DayName VARCHAR(10)
)

INSERT INTO @day
VALUES (1,'Monday')
	, (2,'Tuesday')
	, (3,'Wednesday')
	, (4,'Thursday')
	, (5,'Friday')
	, (6,'Saturday')
	, (7,'Sunday')
	
DECLARE @year TABLE(
	DayID TINYINT,
	DayNumber SMALLINT IDENTITY(1,1),
	DayName VARCHAR(10)
)

DECLARE @DayYear SMALLINT = 1
SELECT @DayYear = ISNULL(MAX(DayNumber),1) FROM @year

WHILE @DayYear <= 365
BEGIN

	DECLARE @DayNow TINYINT = 1
	DECLARE @MaxWeekDay TINYINT
	SELECT @MaxWeekDay = MAX(DayID) FROM @day

	WHILE @DayNow <= @MaxWeekDay
	BEGIN
		
		INSERT INTO @year (DayID,DayName)
		SELECT DayID,DayName
		FROM @day
		WHERE DayID = @DayNow
		
		SET @DayNow = @DayNow + 1
		
	END
	
	SELECT @DayYear = MAX(DayNumber) FROM @year
	
	SET @DayNow = 1
	
END

SELECT *
FROM @year
