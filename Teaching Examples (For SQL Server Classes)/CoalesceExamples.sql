/* 

Simple and practical example of COALESCE

*/

-- Build test table
DECLARE @null TABLE(
	ColumnOne VARCHAR(5),
	ColumnTwo VARCHAR(5),
	ColumnThree VARCHAR(5),
	ColumnFour VARCHAR(5)
)

-- Insert test values
INSERT INTO @null VALUES ('A',NULL,NULL,NULL)
INSERT INTO @null VALUES (NULL,'A',NULL,NULL)
INSERT INTO @null VALUES (NULL,NULL,'A',NULL)
INSERT INTO @null VALUES (NULL,NULL,NULL,'A')

-- Select from test values
SELECT *
FROM @null

-- Test COALESCE
SELECT COALESCE(ColumnOne,ColumnTwo,ColumnThree,ColumnFour) AS Grade
FROM @null

-- Build test table for returning preferred method of phone contact
DECLARE @phone TABLE(
	Home VARCHAR(15),
	Business VARCHAR(15),
	Cell VARCHAR(15)
)

-- Insert phone values
INSERT INTO @phone VALUES ('8005551212',NULL,NULL)
INSERT INTO @phone VALUES (NULL,'8005552121',NULL)
INSERT INTO @phone VALUES (NULL,NULL,'8005551122')
INSERT INTO @phone VALUES (NULL,'8005552121','8005551122')
INSERT INTO @phone VALUES ('8005551212','8005552121',NULL)
INSERT INTO @phone VALUES ('8005551212','8005552121','8005551122')

-- Select from phone values
SELECT *
FROM @phone

-- Business Logic: first Home, then Business, finally Cell
SELECT COALESCE(Home,Business,Cell) AS "Preferred Phone"
FROM @phone
