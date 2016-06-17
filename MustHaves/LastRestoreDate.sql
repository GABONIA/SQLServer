---- Order the restore date by database
DECLARE @database VARCHAR(250) = 'master'
SELECT 
	t.name
	, t.state_desc
	, t.create_date
	, tt.restore_date
	--,t.*
	--,tt.*
FROM master.sys.databases t
	LEFT JOIN msdb.dbo.restorehistory tt ON t.name = tt.destination_database_name
WHERE t.name = @database
-- AND tt.create_date > DATEADD(DD,-90,GETDATE())
ORDER BY tt.restore_date DESC
