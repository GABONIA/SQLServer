CREATE PROCEDURE stp_QuadraticAlgorithm
@a DECIMAL(22,4), @b DECIMAL(22,3), @c DECIMAL(22,4)
AS
BEGIN

	DECLARE @xplus DECIMAL(22,4), @xminus DECIMAL(22,4)
	SET @xplus = (((@b*-1) + SQRT((SQUARE(@b)) - (4*@a*@c)))/(2*@a))
	SET @xminus = (((@b*-1) - SQRT((SQUARE(@b)) - (4*@a*@c)))/(2*@a))

	SELECT @xplus AS "X Plus", @xminus AS "X Minus"

END
