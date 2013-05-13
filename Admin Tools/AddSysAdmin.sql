-- Give role sysadmin privileges
EXEC master..sp_addsrvrolemember @loginame = N'RoleDomain\Role', @rolename = N'sysadmin'
