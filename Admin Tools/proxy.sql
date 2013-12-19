USE msdb
GO

EXEC msdb.dbo.sp_add_proxy @proxy_name=N'ProxyName',@credential_name=N'Credential',@enabled=1,@description=N'Description'
GO

EXEC msdb.dbo.sp_grant_proxy_to_subsystem @proxy_name=N'PSProxy', @subsystem_id=[IDN]
GO
EXEC msdb.dbo.sp_grant_login_to_proxy @proxy=N'PSProxy', @login_name=N'Dom\Login'
