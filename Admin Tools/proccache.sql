SELECT plan_handle [Plan]
	, st.text [Query]
FROM sys.dm_exec_cached_plans 
	CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE text LIKE N'SELECT * FROM Table%'


DBCC FREEPROCCACHE ([Plan])
