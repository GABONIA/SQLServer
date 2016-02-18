USE [DBA]
GO


CREATE PROCEDURE [dbo].[stp_AddToServerList]
AS
BEGIN


	;WITH InsertIntoMain AS(
		SELECT *
			, CASE
				WHEN SqlServerInstance LIKE 'MSSQL10.%' THEN REPLACE(SqlServerInstance,'MSSQL10.','')
				WHEN SqlServerInstance LIKE 'MSSQL10_50.%' THEN REPLACE(SqlServerInstance,'MSSQL10_50.','')
				WHEN SqlServerInstance LIKE 'MSSQL11.%' THEN REPLACE(SqlServerInstance,'MSSQL11.','')
				WHEN SqlServerInstance LIKE 'MSSQL12.%' THEN REPLACE(SqlServerInstance,'MSSQL12.','')
				ELSE NULL
			END AS InstanceName
		FROM DBA.dbo.tb_List_Staging WITH(NOLOCK)
		WHERE SqlServerInstance LIKE 'MSSQL%'
	), FinalInsert AS(
		SELECT SqlServerName AS ServerName
			, CASE
				WHEN InstanceName <> 'MSSQLSERVER' THEN SqlServerName + '\' + InstanceName
				ELSE SqlServerName
			END AS InstanceName
			, CASE 
				WHEN SqlServerVersion LIKE '9.%' THEN '2005'
				WHEN SqlServerVersion LIKE '10.5%' THEN '2008R2'
				WHEN SqlServerVersion LIKE '10.0%' THEN '2008'
				WHEN SqlServerVersion LIKE '10.1%' THEN '2008'
				WHEN SqlServerVersion LIKE '11.%' THEN '2012'
				WHEN SqlServerVersion LIKE '12.%'  THEN '2014'
				ELSE NULL
			END AS SQLVersion
		FROM InsertIntoMain
	)
	INSERT INTO DBA.dbo.tb_ServerList (ServerName,InstanceName,SQLVersion)
	SELECT t.*
	FROM FinalInsert t
	WHERE t.ServerName NOT IN (SELECT ServerName FROM DBA.dbo.tb_ServerList)


	TRUNCATE TABLE DBA.dbo.tb_List_Staging


END

