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