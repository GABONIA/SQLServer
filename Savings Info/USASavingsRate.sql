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
