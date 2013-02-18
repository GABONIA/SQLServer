/* 

For teaching class about foreign and primary keys

*/

USE OurDatabaseName
GO

-- Build experiment tables
CREATE TABLE Customer (
	CustomerID INT NOT NULL PRIMARY KEY,
	FirstName VARCHAR(50) NULL,
	LastName VARCHAR(50) NULL
)

CREATE TABLE Orders (
	OrderID INT NOT NULL PRIMARY KEY,
	CustomerID INT FOREIGN KEY REFERENCES Cust(CustID),
	Amount INT
)

-- Insert experimental values
-- Try inserting an order that doesn't have an associated customer to it
INSERT INTO Orders VALUES (1,1,25)
-- Fails; why?

-- Insert a customer
INSERT INTO Customer VALUES (1,'John','Doe')
-- Then insert the order
INSERT INTO Orders VALUES (1,1,25)