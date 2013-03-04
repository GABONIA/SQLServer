/* 

SQL Server Example of Importing, Manipulating, and Reporting Data Using the United States Personal Savings' Rate

GitHub directory has the text file to import.  This is the code that can be run to create the initial table, import the data,
report the data to a variable table, create a new table to report the year over year savings' rate change and report on that data.

*/

-- Table for the bulk insert
CREATE TABLE savingsrate (
	SavDate VARCHAR(50),
	SavRate VARCHAR(50)
)

-- Bulk insert the data
BULK INSERT savingsrate
FROM 'C:\savingsrate.txt'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a')
GO

-- Insert the data into a clean table
DECLARE @save TABLE(
	Date DATETIME,
	Rate DECIMAL(5,2)
)

INSERT INTO @save
SELECT LTRIM(RTRIM(SavDate)), LTRIM(RTRIM(SavRate))
FROM savingsrate
WHERE SavDate <> 'DATE'

-- Shows savings' rate by year
SELECT YEAR(Date) "Year", AVG(Rate) "Savings Rate"
FROM @save
GROUP BY YEAR(Date)

/* This calculates the year over year savings.

Example: from 1959 to 1960, the savings' rate decreased 3.35%

*/

CREATE TABLE savepercent (
	SaveID INT IDENTITY(1,1),
	Date SMALLDATETIME,
	Rate DECIMAL(5,2)
)

INSERT INTO savepercent
-- Shows savings' rate by year
SELECT MIN(Date) "Year", AVG(Rate) "Savings Rate"
FROM @save
GROUP BY YEAR(Date)

SELECT YEAR(t2.Date) "Year", (((t2.Rate - t1.Rate)/t1.Rate)*100) "Savings Rate Increase/Decrease Year Over Year"
FROM savepercent t1, savepercent t2
WHERE t1.SaveID = t2.SaveID - 1