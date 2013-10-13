CREATE PROCEDURE stp_QuadraticAlgorithm
@a DECIMAL(22,4), @b DECIMAL(22,3), @c DECIMAL(22,4)
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

END
