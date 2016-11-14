
SELECT
  session_id [SessionID]
  , [text] [QueryText]
  , wait_type [CurrentWait]
  , last_wait_type [LastWaitType]
  , blocking_session_id [BlockingSessionID]
  , [status] [QueryStatus]
  , (total_elapsed_time)/1000
FROM sys.dm_exec_requests
  CROSS APPLY sys.dm_exec_sql_text(sql_handle)
