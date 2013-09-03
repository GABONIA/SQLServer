-- Basics
CREATE TABLE Clients(
	ClientID SMALLINT IDENTITY(1,1),
	ClientName VARCHAR(250),
	ClientAddress VARCHAR(250),
	ClientEmail VARCHAR(250),
	ClientPhone VARCHAR(15),
	FreeLessons TINYINT,
	BillingRate DECIMAL(9,4)
)

CREATE TABLE Billing(
	ClientID SMALLINT,
	BillingHours DECIMAL(8,4),
	BillingMonth VARCHAR(15) DEFAULT DATENAME(MONTH, GETDATE())
)

-- Testing

INSERT INTO Clients (ClientName,ClientAddress,ClientEmail,ClientPhone,FreeLessons,BillingRate)
VALUES ('Anne','123 Made Up Dr','haha@haha.com','800-555-1212',1,25.00)
	, ('Richard','456 Made Up Dr','lol@lol.com','800-555-2121',0,25.00)


-- Billing
DECLARE @c INT
SELECT @c = ClientID FROM Clients WHERE ClientName = 'Anne'

INSERT INTO Billing (ClientID,BillingHours)
SELECT @c, 2


-- Report
SELECT c.ClientName
	, (b.BillingHours * c.BillingRate) AS InitialCost
	, (c.BillingRate * c.FreeLessons) AS FreeLessonDiscount
	, ((b.BillingHours * c.BillingRate) - (c.BillingRate * c.FreeLessons)) AS TotalCost
	, c.FreeLessons AS [Free Lessons Used]
	, b.BillingMonth
FROM Billing b
	INNER JOIN Clients c ON c.ClientID = b.ClientID


-- Post free lessons used
UPDATE Clients
SET FreeLessons = (FreeLessons - 1)
WHERE ClientName = 'Anne'


DROP TABLE Billing
DROP TABLE Clients
