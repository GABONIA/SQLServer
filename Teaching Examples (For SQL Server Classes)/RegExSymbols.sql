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
	SET @Phone = REPLACE(@Phone,'/','')
	SET @Phone = REPLACE(@Phone,'\','')
	SET @Phone = REPLACE(@Phone,'|','')
	SET @Phone = REPLACE(@Phone,'*','')
	SET @Phone = REPLACE(@Phone,'&','')
	SET @Phone = RTRIM(LTRIM(@Phone))
RETURN @Phone
END

-- Result:
SELECT dbo.ufn_Phone('(800) 555-1212')

-- View our function on a table

DECLARE @PhoneTest TABLE(
	Name VARCHAR(25),
	Phone VARCHAR(15)
)

INSERT INTO @PhoneTest VALUES ('John Doe','(800) 555-1212')
	,('Jane Doe','800.555.2121')
	,('John Smith','800,555,1122')
	,('Jane Smith','800 555/2211')
	,('John Johnson','800-555,1221')
	
SELECT Name
	, dbo.ufn_Phone(Phone) AS Phone
FROM @PhoneTest