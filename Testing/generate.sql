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

	-- Randomly parse a username
	DECLARE @r INT
	SELECT @r = CAST((RAND()*25) AS INT)
	IF @r < 7
	BEGIN
		SET @r = 10
	END

	UPDATE @p
	SET P = SUBSTRING(REPLACE(CAST(R AS VARCHAR(50)),'-',''),1,@r)
	WHERE E = @e2
		AND U = @u

	-- Return what was entered
	SELECT U, P
	FROM @p

END
