/* 

This is a safer insert: a variable automates the checking to ensure the correct number of rows are inserted

*/

BEGIN TRAN

DECLARE @check INT
SELECT @check = COUNT(*) FROM OurInsertFromTable WHERE OurColumn = Criteria

INSERT INTO OurTable
SELECT *
FROM OurInsertFromTable
WHERE OurColumn = Criteria
IF @@ROWCOUNT <> @check
BEGIN
	ROLLBACK TRAN
END
ELSE 
	COMMIT TRAN
