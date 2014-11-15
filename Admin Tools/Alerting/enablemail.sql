USE master
GO

sp_configure 'show advanced options',1
GO

RECONFIGURE
GO

sp_configure 'Database Mail XPs',1
GO

RECONFIGURE 
GO

ALTER DATABASE [DatabaseName] SET ENABLE_BROKER
GO

/*
SELECT *
FROM sysmail_allitems
--vm-ps
*/
