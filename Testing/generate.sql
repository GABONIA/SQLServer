/*

Random String

*/

CREATE PROCEDURE stp_GenPw
	@e VARCHAR(500), @u VARCHAR(500)
AS
BEGIN
	
	-- Localize
	DECLARE @e2 VARCHAR(500), @u2 VARCHAR(500)
	SET @e2 = @e
	SET @u2 = @u

	-- Temp table
	DECLARE @p TABLE(
		E VARCHAR(500),
		U VARCHAR(500),
		R VARCHAR(50) DEFAULT NEWID(),
		P VARCHAR(25)
	)

	-- Insert the values
	INSERT INTO @p (E, U)
	SELECT @e2, @u2

	-- Randomly parse a password
	DECLARE @r INT
	SELECT @r = CAST((RAND()*13) AS INT)
	IF @r < 8
	BEGIN
		SET @r = 13
	END

	DECLARE @a VARCHAR(26) = 'abcdefghijklmnopqrstuvwxyzj'
	DECLARE @o SMALLINT
	DECLARE @s VARCHAR(1)
	SELECT @o =  CAST((RAND()*27) AS INT)
	SELECT @s = SUBSTRING(@a,@o,1)

	UPDATE @p
	SET P = @s + SUBSTRING(REPLACE(CAST(R AS VARCHAR(50)),'-',''),1,@r)
	WHERE E = @e2
		AND U = @u

	-- Return what was entered
	SELECT U, P
	FROM @p

END
