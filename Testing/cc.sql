CREATE TABLE CCStage(
	PostedDate VARCHAR(250),
	ReferenceNumber VARCHAR(250),
	Payee VARCHAR(250),
	PayeeAddress VARCHAR(250),
	Amount VARCHAR(250)
)

BULK INSERT CCStage
FROM 'C:\Stocks\.csv'
WITH (
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a')
GO

SELECT *
FROM CCStage

DELETE FROM CCStage
WHERE PostedDate = 'Posted Date'


CREATE TABLE CreditCardHistory(
	ID INT IDENTITY(1,1),
	CCDate DATE,
	ReferenceNumber VARCHAR(100),
	Amount DECIMAL(13,4)
)

-- Note that casting/converting failed, however, this was a good use of the new TRY_PARSE function
INSERT INTO CreditCardHistory (CCDate,ReferenceNumber,Amount)
SELECT CAST(PostedDate AS DATE)
	, ReferenceNumber
	, TRY_PARSE(Amount AS DECIMAL(7,2))
FROM CCStage
WHERE ReferenceNumber IS NOT NULL


CREATE TABLE CreditCardPayeeHistory(
	ID INT IDENTITY(1,1),
	CCDate DATE,
	ReferenceNumber VARCHAR(100),
	Payee VARCHAR(250),
	PayeeAddress VARCHAR(100)
)


INSERT INTO CreditCardPayeeHistory (CCDate,ReferenceNumber,Payee,PayeeAddress)
SELECT CAST(PostedDate AS DATE)
	, ReferenceNumber
	, Payee
	, PayeeAddress
FROM CCStage
WHERE ReferenceNumber IS NOT NULL




CREATE PROCEDURE stp_FindMerchantHistory
@merchant VARCHAR(100)
AS
BEGIN

	SET @merchant = UPPER(@merchant)

	-- Search for merchants
	SELECT h.CCDate
		, h.Amount
		, p.Payee
		, p.PayeeAddress
	FROM CreditCardHistory h
		INNER JOIN CreditCardPayeeHistory p ON h.ReferenceNumber = p.ReferenceNumber
	WHERE Payee LIKE '' + '%' + @merchant + '%' + ''
	ORDER BY CCDate

END

EXECUTE stp_FindMerchantHistory ''


-- How much spent
SELECT SUM(Amount)
FROM CreditCardHistory
WHERE Amount < 0

-- How much paid
SELECT SUM(Amount)
FROM CreditCardHistory
WHERE Amount > 0
