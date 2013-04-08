/*

Get the day number, day name and day id (meaning 1 - 7) of each day for the week.

*/

CREATE TABLE ##year(
	WeekDayID TINYINT,
	DayNumber SMALLINT IDENTITY(1,1),
	MonthDay SMALLINT,
	MonthBusinessDay SMALLINT,
	MonthID TINYINT,
	MonthName VARCHAR(10),
	DayName VARCHAR(10),
	ActualDate DATE
)

DECLARE @start DATE = '2013-01-01'
DECLARE @begin SMALLINT = 1

WHILE @begin <= 365
BEGIN

	INSERT INTO ##year (ActualDate)
	SELECT @start

	SET @start = DATEADD(DD,1,@start)
	SET @begin = @begin + 1
END

UPDATE ##year
SET MonthID = MONTH(ActualDate),
	WeekDayID = DATEPART(DW,ActualDate),
	MonthName = DATENAME(MONTH, ActualDate),
	DayName = DATENAME(DW,ActualDate),
	MonthDay = DAY(ActualDate)

DECLARE @mbegin TINYINT = 1

WHILE @mbegin <= 12
BEGIN
	
	CREATE TABLE #month(
	DayID SMALLINT IDENTITY(1,1),
	DayNumber SMALLINT
	)
	
	INSERT INTO #month (DayNumber)
	SELECT DayNumber
	FROM ##year
	WHERE MonthID = @mbegin
		AND WeekDayID <> 7
		AND WeekDayID <> 1
	
	UPDATE ##year
	SET MonthBusinessDay = DayID 
	FROM #month m
	WHERE ##year.DayNumber = m.DayNumber 
		AND ##year.MonthBusinessDay IS NULL
	
	DROP TABLE #month
	
	SET @mbegin = @mbegin + 1
END

SELECT *
FROM ##year



