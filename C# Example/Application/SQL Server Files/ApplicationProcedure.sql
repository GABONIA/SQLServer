USE Application
GO

CREATE PROCEDURE InsertBasicVerification
	@FirstName VARCHAR(100),
	@MiddleInitial VARCHAR(100),
	@LastName VARCHAR(100),
	@PhoneNumber VARCHAR(100),
	@StreetAddress VARCHAR(100),
	@City VARCHAR(100),
	@State VARCHAR(100),
	@ZipCode VARCHAR(100),
	@SSN VARCHAR(100),
	@BusinessName VARCHAR(100),
	@EmployerName VARCHAR(100),
	@MonthlyGrossIncome VARCHAR(100)
AS
BEGIN
	INSERT INTO BasicVerificationStage (FirstName,MiddleInitial,LastName,PhoneNumber,StreetAddress,City,State,ZipCode,SSN,BusinessName,EmployerName,MonthlyGrossIncome)
	SELECT @FirstName, @MiddleInitial, @LastName, @PhoneNumber, @StreetAddress, @City, @State, @ZipCode, @SSN, @BusinessName, @EmployerName, @MonthlyGrossIncome
	
	/*
	-- Method One of performing data validation: we insert only valid data
	INSERT INTO BasicVerification (FirstName,MiddleInitial,LastName,PhoneNumber,StreetAddress,City,State,ZipCode,SSN,BusinessName,EmployerName,MonthlyGrossIncome)
	SELECT FirstName
		,SUBSTRING(MiddleInitial,0,1) AS MiddleInitial
		,LastName
		,PhoneNumber
		,StreetAddress
		,City
		,State
		,ZipCode
		,SSN
		,BusinessName
		,EmployerName
		,MonthlyGrossIncome
	FROM BasicVerificationStage
	WHERE ISNUMERIC(PhoneNumber) = 1
		AND LEN(PhoneNumber) = 10
		AND LEN(State) = 2
		AND ISNUMERIC(ZipCode) = 1
		AND LEN(ZipCode) = 5
		AND ISNUMERIC(SSN) = 1
		AND LEN(SSN) = 9
		AND ISNUMERIC(MonthlyGrossIncome) = 1 
	*/
	
	-- Method Two: We update "Valid" status to one if it's valid, if not, we state why
	
	-- Updating the staging table to invalidate the bad data, we note why it's invalid for tracking purposes
	UPDATE BasicVerificationStage
	SET Valid = 0, InvalidReason = 'Incorrect phone format'
	WHERE ISNUMERIC(PhoneNumber) = 0 OR LEN(PhoneNumber) <> 10
	
	UPDATE BasicVerificationStage
	SET Valid = 0, InvalidReason = 'Invalid State format'
	WHERE LEN(State) <> 2
	
	UPDATE BasicVerificationStage
	SET Valid = 0, InvalidReason = 'Incorrect Zip Code format'
	WHERE ISNUMERIC(ZipCode) = 0 OR LEN(ZipCode) <> 5
	
	UPDATE BasicVerificationStage
	SET Valid = 0, InvalidReason = 'Incorrect SSN format'
	WHERE ISNUMERIC(SSN) = 0 OR LEN(SSN) <> 9
	
	UPDATE BasicVerificationStage
	SET Valid = 0, InvalidReason = 'Invalid gross income amount'
	WHERE ISNUMERIC(MonthlyGrossIncome) = 0
	
	-- Insert the good data from the stage table
	INSERT INTO BasicVerification (FirstName,MiddleInitial,LastName,PhoneNumber,StreetAddress,City,State,ZipCode,SSN,BusinessName,EmployerName,MonthlyGrossIncome)
	SELECT FirstName
		,SUBSTRING(MiddleInitial,0,1) AS MiddleInitial
		,LastName
		,PhoneNumber
		,StreetAddress
		,City
		,State
		,ZipCode
		,SSN
		,BusinessName
		,EmployerName
		,MonthlyGrossIncome
	FROM BasicVerificationStage
	WHERE Valid = 1
	
	-- Remove the valid data from the stage table (it will be in the main table now)
	DELETE FROM BasicVerificationStage
	WHERE Valid = 1
	
	/*
	
	Now only invalid data exist in the stage table, so that we can solve the mystery as to why we're receiving bad data
	
	*/
END
