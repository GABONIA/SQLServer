SELECT *
FROM sys.symmetric_keys

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'HoustonWeHaveAProblem'


CREATE CERTIFICATE Testing
	WITH SUBJECT = 'Test Only'


CREATE SYMMETRIC KEY Testing_101
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Testing


SELECT *
FROM sys.symmetric_keys


CREATE TABLE EncryptedTable(
	ID TINYINT IDENTITY(1,1),
	PrivateMessage VARCHAR(100)
)

INSERT INTO EncryptedTable (PrivateMessage)
VALUES ('Hey George!   How have you been this past month?  We were thinking about coming up and visiting you.')


ALTER TABLE EncryptedTable
	ADD PrivateMessage_Encrypted VARBINARY(512)


OPEN SYMMETRIC KEY Testing_101
	DECRYPTION BY CERTIFICATE Testing


UPDATE EncryptedTable
SET PrivateMessage_Encrypted = ENCRYPTBYKEY(KEY_GUID('Testing_101'), PrivateMessage, 1, HASHBYTES('SHA1', CONVERT(VARBINARY, PrivateMessage)))


-- Encryption Saved
SELECT PrivateMessage AS "OriginalValue"
	, PrivateMessage_Encrypted AS "EncryptedValue"
FROM EncryptedTable

