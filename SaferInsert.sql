/* 

Production Receipt

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
