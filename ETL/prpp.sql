DECLARE @begin DATE, @end DATE, @b INT = 1, @m INT
SELECT @m = DATEDIFF(MONTH,MIN(date_field),GETDATE()) FROM RecTable
SELECT @begin = MIN(date_field) FROM RecTable
SET @end = DATEADD(MONTH,1,@begin)


WHILE @b <= @m
BEGIN

	CHECKPOINT;

	EXECUTE stp_Procedure @begin, @end

	CHECKPOINT;

	SET @begin = @end
	SET @end = DATEADD(MONTH,1,@end)
	SET @b = @b + 1

END
