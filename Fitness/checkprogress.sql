CREATE PROCEDURE stp_CheckProgress
(@exercise VARCHAR(100))
AS
BEGIN
	
	DECLARE @sql NVARCHAR(MAX)
	SET @sql = ';WITH CTE AS(
		SELECT ROW_NUMBER() OVER(ORDER BY [Date] ASC) AS [ID]
			, [Date]  
			, [Weight]
			, [Repetitions]
		FROM exc.' + @exercise + '
	)
	SELECT c2.[Date]
		, c.[Weight] AS [Previous Weight]
		, c2.[Weight] AS [Recent Weight]
		, (((c2.[Weight] - c.[Weight])/c.[Weight])*100) AS [Percent Change]
	FROM CTE c
		INNER JOIN CTE c2 ON c.ID = (c2.ID - 1)'

	EXECUTE(@sql)

END
