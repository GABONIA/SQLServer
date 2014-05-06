/*

Debugging either error 3313, 3314, 3414 or 3456, see the below errors (ordered by earliest).

"The transaction log for database 'DatabaseName' is full due to 'ACTIVE_TRANSACTION'
"Error: 3314 Severity: 21 State: 3."
"Database MLS was shutdown due to error 3314 in routine 'XdesRMReadWrite::RollbackToLsn'. Restart for non-snapshot databases will be attempted after all connections to the database are aborted."
"Error during rollback. shutting down database (location: 1)."
"Error: 9001 Severity: 21 State: 5."
"The log for database 'DatabaseName' is not available. Check the event log for related error messages. Resolve any errors and restart the database."
"Error: 3314 Severity: 21 State: 3."
"During undoing of a logged operation in database 'DatabaseName' an error occurred at log record ID ([n]). Typically the specific failure is logged previously as an error in the Windows Event Log service. Restore the database or file from a backup or repair the database."
"Error: 3314 Severity: 21 State: 5."


-- See: http://msdn.microsoft.com/en-us/library/ff713991(v=sql.100).aspx

*/

/*

  1.  Database goes offline; check the SQL Server Logs under Management.
  2.  If the database auto-recovers ("Reovery of database 'DatabaseName' is n% complete"), wait until it's finished.
  3.  Check the database state (see below query):

*/

SELECT name
	, log_reuse_wait_desc
	, state_desc
	, *
FROM sys.databases
WHERE name = 'DatabaseName'

/*

  4.  Run DBCC CHECKDB on database.
  5.  If no errors, run the below query:
  
*/

DBCC SQLPERF('LogSpace');

/*

  6.  If other errors, then refer to the top article.

*/


/*
-- Checks:

DBCC LOGINFO(1) -- number should be database_id
DBCC SQLPERF('LogSpace')
DBCC LOG('DatabaseName')
DBCC CHECKDB

*/
