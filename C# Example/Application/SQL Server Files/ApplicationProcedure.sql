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
	
	-- One method of performing data validation: we insert only valid data
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
END
