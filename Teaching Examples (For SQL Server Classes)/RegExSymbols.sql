/* 

REGEX Example: Demonstrating Symbol-By-Symbol Logic

*/

-- How can we eliminate bad characters in a string?
DECLARE @Phone VARCHAR(15)
SET @Phone = '(800) 555-1212'

SET @Phone = REPLACE(@Phone,'(','')
SET @Phone = REPLACE(@Phone,')','')
SET @Phone = REPLACE(@Phone,'-','')
SET @Phone = REPLACE(@Phone,' ','')
SET @Phone = REPLACE(@Phone,'.','')
SET @Phone = RTRIM(LTRIM(@Phone))

-- Result:
SELECT @Phone

-- Now we can build a function to do it for us
CREATE FUNCTION ufn_Phone (@Phone VARCHAR(25))
RETURNS VARCHAR(10)
BEGIN
	SET @Phone = REPLACE(@Phone,'(','')
	SET @Phone = REPLACE(@Phone,')','')
	SET @Phone = REPLACE(@Phone,'-','')
	SET @Phone = REPLACE(@Phone,' ','')
	SET @Phone = REPLACE(@Phone,'.','')
	SET @Phone = REPLACE(@Phone,',','')
	SET @Phone = RTRIM(LTRIM(@Phone))
RETURN @Phone
END

-- Result:
SELECT dbo.ufn_Phone('(800) 555-1212')