IF (SELECT COUNT(w.blocking_session_id) "Blocks"
	FROM sys.dm_tran_locks t
		INNER JOIN sys.dm_os_waiting_tasks w ON t.lock_owner_address = w.resource_address
	WHERE w.blocking_session_id IS NOT NULL) > 25
--[SEND ALERT/KILL ALL PROCESSES]