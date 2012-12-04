/* 

Tips for use:
1.  These comments /* */ start a new section
2.  These comments -- explain the steps and process
3.  Feel free to use!

*/

USE [DATABASE]
GO


/* Remove Duplicates By Most Recent Date Example */


-- Creates a temp table 
CREATE TABLE #remove (A INT, B INT, Date DATETIME)

-- Insert values into the temp table
INSERT INTO #remove VALUES(1,1,getdate())
INSERT INTO #remove VALUES(1,1,DATEADD(DD,-2,getdate()))
INSERT INTO #remove VALUES(1,1,DATEADD(DD,-5,getdate()))
INSERT INTO #remove VALUES(1,2,DATEADD(DD,-10,getdate()))
INSERT INTO #remove VALUES(1,2,DATEADD(DD,-15,getdate()))
INSERT INTO #remove VALUES(3,1,getdate())

SELECT A
, B
, Date
, ROW_NUMBER() OVER (PARTITION BY A, B ORDER BY Date DESC) AS CTable
FROM #remove

SELECT A
, B
, Date
, ROW_NUMBER() OVER (PARTITION BY A, B ORDER BY Date DESC) AS CTable
FROM #remove
WHERE A = 1 AND B = 1

WITH CTE AS (
SELECT A
, B
, Date
, ROW_NUMBER() OVER (PARTITION BY A, B ORDER BY Date DESC) AS CTable
FROM #remove
WHERE A = 1 AND B = 1) 
DELETE CTE WHERE CTable > 1

-- Clean up
DROP TABLE #remove


/* Remove the leading one off a phone number 18005551212 so that you can return one digit */


UPDATE [Table]
SET Phone = RIGHT(Phone, LEN(Phone)-1)
WHERE LEFT(Phone,1) = 1


/* Format a 8005551212 phone number like (800) 555-1212 */


SELECT '(' + SUBSTRING(Phone,1,3) + ') ' + SUBSTRING(Phone,4,3) + '-' + SUBSTRING(Phone,7,4) AS "Phone Number"
FROM [Table]


/* Compare Table Types */


-- Build a temporary table for comparing tables
CREATE TABLE #quickcompare ([Table Name] varchar(100),[Column Name] varchar(100), [Data Type] varchar(25), [Length] INT)

-- Just change the name of "YourFirstTable" to the first table's name.  
-- You can also then do this for the second table name and insert it as well or use the next one for this.
INSERT INTO #quickcompare ([Table Name],[Column Name],[Data Type],[Length])
SELECT table_name 'Table Name',
column_name 'Column Name',
data_type 'Data Type',
character_maximum_length 'Length'
FROM information_schema.columns
WHERE table_name = 'YourFirstTable'

INSERT INTO #quickcompare ([Table Name],[Column Name],[Data Type],[Length])
SELECT table_name 'Table Name',
column_name 'Column Name',
data_type 'Data Type',
character_maximum_length 'Length'
FROM information_schema.columns
WHERE table_name = 'YourSecondTable'

-- Compare
SELECT * FROM #quickcompare

-- Drop the temp table
DROP TABLE #quickcompare
