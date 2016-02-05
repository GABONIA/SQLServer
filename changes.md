:joy: :joy: :joy:

```
DECLARE @srv VARCHAR(100) = @@SERVERNAME

IF @srv = 'BetterBeDevelopment'
BEGIN

	BEGIN TRAN
	---- Use full database and table path
	TRUNCATE TABLE Database.Schema.Table

	PRINT @srv
	---- Eh, what?  NOOoooooo
END

---- COMMIT TRAN
---- PHEW!
```
