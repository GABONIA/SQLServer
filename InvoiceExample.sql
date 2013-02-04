/*

-- Billing By Unit Table
SELECT 1 AS UnitID, 21.5 AS CostPerUnit
INTO #z1test
INSERT INTO #z8test VALUES(2, 17.9),(3,13.0),(4,12.7),(5,8.6)

SELECT *
FROM #z1test

-- Billing Cycle Table
SELECT 9 As CycleID, 'September' AS Month
INTO #z2test
INSERT INTO #z2test VALUES(2,'February'),(3,'March'),(4,'April'),(5,'May'),(6,'June'),(7,'July'),(8,'August'),(1,'January'),(10,'October'),(11,'November'),(12,'December')

SELECT *
FROM #z2test

SELECT Month
FROM #z2test
WHERE MONTH(DATEADD(MM,-1,getdate())) = CycleID

DECLARE @Month VARCHAR(9)
SELECT @Month = Month FROM #z2test WHERE MONTH(DATEADD(MM,-1,getdate())) = CycleID
SELECT @Month AS Month

DROP TABLE #z2test




*/