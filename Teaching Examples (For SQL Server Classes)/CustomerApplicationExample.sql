/* 

"Entry Verification Table" For Program

*/

CREATE TABLE BasicVerification(
	VerificationID BIGINT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NULL,
	MiddleInitial VARCHAR(1) NULL,
	LastName VARCHAR(50) NULL,
	PhoneNumber VARCHAR(20) NULL,
	StreetAddress VARCHAR(150) NULL,
	City VARCHAR(50) NULL,
	State VARCHAR(2) NULL,
	ZipCode VARCHAR(10) NULL,
	SSN VARCHAR(11) NULL,
	BusinessName VARCHAR(100) NULL,
	EmployerName VARCHAR(100) NULL,
	MonthlyGrossIncome DECIMAL(20,2) NULL
)

-- Test values to verify that default values work
INSERT INTO BasicVerification (FirstName) VALUES ('John Smith'),('Jane Smith'),('Sandra Smith')

SELECT *
FROM BasicVerification

-- Creating the "Entry" stored procedure
CREATE PROCEDURE InsertBasicVerification
	@FirstName VARCHAR(50),
	@MiddleInitial VARCHAR(1),
	@LastName VARCHAR(50),
	@PhoneNumber VARCHAR(20),
	@StreetAddress VARCHAR(150),
	@City VARCHAR(50),
	@State VARCHAR(2),
	@ZipCode VARCHAR(10),
	@SSN VARCHAR(11),
	@BusinessName VARCHAR(100),
	@EmployerName VARCHAR(100),
	@MonthlyGrossIncome DECIMAL(20,2)
AS
BEGIN
	INSERT INTO BasicVerification (FirstName,MiddleInitial,LastName,PhoneNumber,StreetAddress,City,State,ZipCode,SSN,BusinessName,EmployerName,MonthlyGrossIncome)
	SELECT @FirstName, @MiddleInitial, @LastName, @PhoneNumber, @StreetAddress, @City, @State, @ZipCode, @SSN, @BusinessName, @EmployerName, @MonthlyGrossIncome
END

SELECT *
FROM BasicVerification