/* Call from C# */

DECLARE @dt DATE = GETDATE(), @ldt DATE, @week DATE
SELECT @ldt = MAX(CAST(b.backup_finish_date AS DATE)) FROM sys.sysdatabases sd LEFT OUTER JOIN msdb.dbo.backupset b ON b.database_name = sd.name WHERE sd.Name = 'StockAnalysis' GROUP BY sd.Name
SELECT @week = DATEADD(DD,7,@ldt)

IF @week < @dt
BEGIN
	EXECUTE admin.stp_StockAnalysis_Admin
END
