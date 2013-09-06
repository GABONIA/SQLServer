/* 

Relative to how the data are stored, this will get the ID from the next business day.

1.  Assumes that IDs are organized by next business day.
2.  Assumes non-business day dates are not stored (holidays, weekends, etc).

*/


-- EXAMPLE:
DECLARE @begin DATE = '1998-09-04'
DECLARE @add TINYINT = 0, @nope TINYINT = 0, @id INT

WHILE @nope = 0
BEGIN

	SELECT @id = ID FROM HistoricalData WHERE Date = DATEADD(DD,@add,@begin)
	IF @@ROWCOUNT > 0
	BEGIN
		SET @nope = 1
	END

	SET @add = @add + 1

END

SELECT Date
FROM HistoricalData
WHERE ID = @id
