/*

Safe insert to a table: this will help prevent errors

*/
USE OurDatabaseName
GO
-- The search criteria should specify what rows we want updated
SELECT *
FROM OurTableNameWeInsertFrom
WHERE OurInsertCriteria
-- COUNT OF INSERTED ROWS: (becomes N later)
/* 
Number of rows returned from the search criteria:  (put this in the value of N below this)
*/
BEGIN TRAN
INSERT OurTableName
FROM OurTableNameWeInsertFrom
WHERE OurInsertCriteria
-- Put the number of rows based on the select above this in place of N
IF @@ROWCOUNT <> N
ROLLBACK TRAN
-- Verify
SELECT *
FROM OurTableName
WHERE OurInsertCriteria
/* Highlight and commit */
/* -- COMMIT TRAN */