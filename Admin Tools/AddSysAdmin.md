```
-- Give role sysadmin privileges
EXEC master..sp_addsrvrolemember @loginame = N'Domain\User', @rolename = N'sysadmin'
```
