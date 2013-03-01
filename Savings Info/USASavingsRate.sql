-- Insert the data into a clean table
DECLARE @save TABLE(
	Date DATETIME,
	Rate DECIMAL(5,2)
)

INSERT INTO @save
SELECT LTRIM(RTRIM(Date)), LTRIM(RTRIM(Rate))
FROM savingsrate

-- Shows savings' rate by year
SELECT YEAR(Date) "Year", AVG(Rate) "Savings Rate"
FROM @save
GROUP BY YEAR(Date)