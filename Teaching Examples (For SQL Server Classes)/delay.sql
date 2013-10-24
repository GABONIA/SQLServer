/* 

Query Window 1

-- Execute the below code before starting:

CREATE TABLE DelayTable(
	ID SMALLINT IDENTITY(1,1),
	Name VARCHAR(100)
)

INSERT INTO DelayTable (Name)
VALUES ('John')
	, ('Joe')
	, ('Jennifer')
	, ('Jessica')

SELECT *
FROM DelayTable

*/


-- Start this first, after executing it, immediately start Query Window 2

SELECT *
FROM DelayTable


WAITFOR DELAY '00:01'


UPDATE DelayTable
SET Name = 'John'
WHERE ID = 1


SELECT *
FROM DelayTable


/*

Query Window 2

*/

-- Start immediately after executing the code in Query Window 1

SELECT *
FROM DelayTable


UPDATE DelayTable
SET Name = 'Durkah Durkah'
WHERE ID = 1


SELECT *
FROM DelayTable
