CREATE PROCEDURE stp_PointGrowth
@exercise VARCHAR(100)
AS
BEGIN
	
	DECLARE @sql NVARCHAR(MAX)
	
	SET @sql = '
	;WITH ExerciseGrowth AS(
		SELECT ROW_NUMBER() OVER (ORDER BY Date) AS ID
			, Date
			, Weight
			, Repetitions
		FROM exc.' + @exercise + '
	)
	SELECT e2.Date
		, (e2.Weight - e1.Weight) + ((e2.Repetitions - e1.Repetitions)*2.5) "Points"
	FROM ExerciseGrowth e1
		INNER JOIN ExerciseGrowth e2 ON e1.ID = (e2.ID -1)'

	EXECUTE sp_executesql @sql

END
