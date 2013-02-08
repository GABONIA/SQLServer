/* 

MERGE example

*/

USE OurDatabaseName
GO

CREATE TABLE zData (
	ID INT IDENTITY,
	Account INT NULL,
	CustomerID INT NULL,
	Name VARCHAR(50) NULL,
	Amount DECIMAL(5,2) NULL,
	EntryDate SMALLDATETIME
)

CREATE TABLE zFlow (
	ID INT IDENTITY,
	Account INT NULL,
	CustomerID INT NULL,
	Name VARCHAR(50) NULL,
	Amount DECIMAL(5,2) NULL,
	EntryDate SMALLDATETIME
)

INSERT INTO zData VALUES (50000,32500,'Gasoline',22.5,DATEADD(DD,-1,getdate()))
INSERT INTO zData VALUES (50001,32501,'Natural Gas',27.4,DATEADD(DD,-1,getdate()))
INSERT INTO zData VALUES (50002,32502,'Gasoline',42.5,DATEADD(DD,-1,getdate()))
INSERT INTO zData VALUES (50003,32503,'Carbon Dioxide',22.7,DATEADD(DD,-1,getdate()))
INSERT INTO zData VALUES (50004,32504,'Gasoline',56.5,DATEADD(DD,-1,getdate()))
INSERT INTO zData VALUES (50005,32505,'Gas',4.2,getdate())


INSERT INTO zFlow VALUES (50000,32500,'Gasoline',0,getdate())
INSERT INTO zFlow VALUES (50001,32501,'Natural Gas',0,getdate())
INSERT INTO zFlow VALUES (50002,32502,'Gasoline',0,getdate())
INSERT INTO zFlow VALUES (50003,32503,'Carbon Dioxide',0,getdate())
INSERT INTO zFlow VALUES (50004,32504,'Gasoline',0,getdate())
INSERT INTO zFlow VALUES (50005,32505,'Gas',18.3,getdate())

SELECT *
FROM zData

SELECT *
FROM zFlow

MERGE zData AS t
USING zFlow AS s
ON (t.Account = s.Account AND t.CustomerID = s.CustomerID AND t.EntryDate = s.EntryDate)
WHEN MATCHED THEN
	UPDATE SET t.Amount = s.Amount
WHEN NOT MATCHED THEN
	INSERT (Account,CustomerID,Name,Amount,EntryDate) VALUES (s.Account, s.CustomerID, s.Name, s.Amount, s.EntryDate);




-- Clean
DROP TABLE zData
DROP TABLE zFlow