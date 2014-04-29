CREATE TABLE CheckTable (
	ID INT,
	CheckStat VARCHAR(3)
) WITH (DATA_COMPRESSION = PAGE)

INSERT INTO asg_Dim_MLS_Bits
VALUES (0,'N')
	, (1,'Y')
	, (2,'N/A')

DECLARE @test TABLE(
	Number INT,
	AnotherNumber INT,
	YetAnotherNumber INT
)

INSERT INTO @test
VALUES (2,2,0)
	, (2,2,1)
	, (1,2,1)

SELECT b.CheckStat Number
	, bb.CheckStat AnotherNumber
	, bbb.CheckStat YetAnotherNumber
FROM @test t
	INNER JOIN CheckTable b ON t.Number = b.ID
	INNER JOIN CheckTable bb ON t.AnotherNumber = bb.ID
	INNER JOIN CheckTable bbb ON t.YetAnotherNumber = bbb.ID
