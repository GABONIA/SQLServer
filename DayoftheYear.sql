/*

Get the day number, day name and day id (meaning 1 - 7) of each day for the week.

*/

-- First and long method

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
	
CREATE TABLE ##year(
	WeekDayID TINYINT,
	DayNumber SMALLINT IDENTITY(1,1),
	MonthID TINYINT,
	MonthName VARCHAR(10),
	DayName VARCHAR(10)
)

DECLARE @DayYear SMALLINT = 1
SELECT @DayYear = ISNULL(MAX(DayNumber),1) FROM ##year

WHILE @DayYear <= 365
BEGIN

	DECLARE @DayNow TINYINT = 1
	DECLARE @MaxWeekDay TINYINT
	SELECT @MaxWeekDay = MAX(DayID) FROM @day

	WHILE @DayNow <= @MaxWeekDay
	BEGIN
		
		INSERT INTO ##year (WeekDayID,DayName)
		SELECT DayID,DayName
		FROM @day
		WHERE DayID = @DayNow
		
		SET @DayNow = @DayNow + 1
		
	END
	
	SELECT @DayYear = MAX(DayNumber) FROM ##year
	
	SET @DayNow = 1
	
END

UPDATE ##year
SET MonthID = 1, MonthName = 'January'
WHERE DayNumber BETWEEN 1 AND 31
	
UPDATE ##year
SET MonthID = 2, MonthName = 'February'
WHERE DayNumber BETWEEN 32 AND 59
	
UPDATE ##year
SET MonthID = 3, MonthName = 'March'
WHERE DayNumber BETWEEN 60 AND 90
	
UPDATE ##year
SET MonthID = 4, MonthName = 'April'
WHERE DayNumber BETWEEN 91 AND 120
	
UPDATE ##year
SET MonthID = 5, MonthName = 'May'
WHERE DayNumber BETWEEN 121 AND 151
	
UPDATE ##year
SET MonthID = 6, MonthName = 'June'
WHERE DayNumber BETWEEN 151 AND 181
	
UPDATE ##year
SET MonthID = 7, MonthName = 'July'
WHERE DayNumber BETWEEN 182 AND 212
	
UPDATE ##year
SET MonthID = 8, MonthName = 'August'
WHERE DayNumber BETWEEN 213 AND 243
	
UPDATE ##year
SET MonthID = 9, MonthName = 'September'
WHERE DayNumber BETWEEN 244 AND 273
	
UPDATE ##year
SET MonthID = 10, MonthName = 'October'
WHERE DayNumber BETWEEN 274 AND 305
	
UPDATE ##year
SET MonthID = 11, MonthName = 'November'
WHERE DayNumber BETWEEN 306 AND 335
	
UPDATE ##year
SET MonthID = 12, MonthName = 'December'
WHERE DayNumber BETWEEN 336 AND 365

DELETE FROM ##year
WHERE DayNumber > 365

SELECT *
FROM ##year
WHERE WeekDayID <> 6
	AND WeekDayID <> 7

-- Second and quick method

DECLARE @year TABLE(
	WeekDayID TINYINT,
	DayNumber SMALLINT IDENTITY(1,1),
	MonthID TINYINT,
	MonthName VARCHAR(10),
	DayName VARCHAR(10),
	ActualDate DATE
)
	
DECLARE @start DATE = '2013-01-01'
DECLARE @begin SMALLINT = 1

WHILE @begin <= 365
BEGIN

	INSERT INTO @year (ActualDate)
	SELECT @start
	
	SET @start = DATEADD(DD,1,@start)
	SET @begin = @begin + 1
END

UPDATE @year
SET MonthID = MONTH(ActualDate),
	WeekDayID = DATEPART(DW,ActualDate),
	MonthName = DATENAME(MONTH, ActualDate),
	DayName = DATENAME(DW,ActualDate)

SELECT *
FROM @year
