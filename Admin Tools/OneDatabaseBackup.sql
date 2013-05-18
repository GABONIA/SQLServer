/*

Backs up a single database

*/

DECLARE @dbName VARCHAR(50)  
DECLARE @filePath VARCHAR(200) 
DECLARE @fileName VARCHAR(314)  
DECLARE @fileDate VARCHAR(10)

SET @dbName = 'OurDatabaseName'
SET @filePath = 'D:\Backup\'
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 
SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
BACKUP DATABASE @name TO DISK = @fileName