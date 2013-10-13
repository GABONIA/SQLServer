CREATE PROCEDURE stp_QuadraticAlgorithm
@a DECIMAL(22,4), @b DECIMAL(22,3), @c DECIMAL(22,4), @vone VARCHAR(1), @vtwo VARCHAR(1)
AS
BEGIN

	DECLARE @xplus DECIMAL(22,4), @xminus DECIMAL(22,4), @stepone DECIMAL(22,4), @steptwo DECIMAL(22,4), @stepthree DECIMAL(22,4), @stepfour DECIMAL(22,4)
		, @stepfive DECIMAL(22,4), @stepsix DECIMAL(22,4), @stepseven DECIMAL(22,4), @stepeight DECIMAL(22,4), @stepnine DECIMAL(22,4)
	SET @stepone = (@b *-1)
	SET @steptwo = SQUARE(@b)
	SET @stepthree = (4*@a*@c)
	SET @stepfour = (2*@a)
	SET @stepfive = SQRT(@steptwo - @stepthree)
	SET @stepsix = @stepone + @stepfive
	SET @stepseven = @stepone - @stepfive
	SET @stepeight = @stepsix/@stepfour
	SET @stepnine = @stepseven/@stepfour
	SET @xplus = (((@b*-1) + SQRT((SQUARE(@b)) - (4*@a*@c)))/(2*@a))
	SET @xminus = (((@b*-1) - SQRT((SQUARE(@b)) - (4*@a*@c)))/(2*@a))

	SELECT @stepone StepOne, @steptwo StepTwo, @stepthree StepThree, @stepfour StepFour

	SELECT @stepfive StepFive

	SELECT @stepsix StepSixPlus, @stepseven StepSixMinus

	SELECT @stepeight StepSevenPlus, @stepnine StepSevenMinus

	SELECT @xplus AS "X Plus", @xminus AS "X Minus"

	DECLARE @sql NVARCHAR(MAX)

	SET @sql = 'DECLARE @checkone DECIMAL(22,4), @checktwo DECIMAL(22,4)

	SET @checkone = ((' + CAST(@a AS VARCHAR(30)) + '*(SQUARE(' + CAST(@xplus AS VARCHAR(30)) + '))) ' + @vone + ' (' + CAST(@b AS VARCHAR(30)) + '*(' + CAST(@xplus AS VARCHAR(30)) + ')) '  + @vtwo + ' ' + CAST(@c AS VARCHAR(30)) + ')
	SET @checkone = ((' + CAST(@a AS VARCHAR(30)) + '*(SQUARE(' + CAST(@xminus AS VARCHAR(30)) + '))) ' + @vone + ' (' + CAST(@b AS VARCHAR(30))+ '*(' + CAST(@xminus AS VARCHAR(30)) + ')) '  + @vtwo + ' ' + CAST(@c AS VARCHAR(30)) + ')
	
	SELECT @checkone CheckXPlus, @checktwo CheckXMinus

	IF @checkone = 0
	BEGIN
		PRINT ''X Plus is a solution''
	END

	IF @checktwo = 0
	BEGIN
		PRINT ''X Minus is a solution''
	END
	'

	EXECUTE sp_executesql @sql

END
