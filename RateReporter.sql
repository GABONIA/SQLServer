/* Example of how to calculate a rate based off a table and report it 

Note: this example uses direct declares - we could easily base it off an actual table*/

DECLARE @inflation TABLE(
	InYear INT,
	CPIBegin DECIMAL(18,4),
	CPIEnd DECIMAL(18,4),
	InRate DECIMAL(7,4)
)

DECLARE @Year INT
DECLARE @Beg DECIMAL(18,4)
DECLARE @End DECIMAL(18,4)
SET @Year = 2004 
SET @Beg = 21
SET @End = 24


INSERT INTO @inflation VALUES (@Year,@Beg,@End,(((@End - @Beg)/@Beg)*100))

SELECT *
FROM @inflation