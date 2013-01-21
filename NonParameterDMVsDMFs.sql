/* 

Non Parameter DMV/DMFs of SQL Server

*/

SELECT *
FROM sys.dm_exec_connections
-- Shows detailed information about the server's connections, such as Session ID, Connect Time, etc.

SELECT *
FROM sys.dm_exec_sessions
-- Shows login details about active users as well as the amount of the server is processing (total)

SELECT *
FROM sys.dm_exec_requests
-- Provides information about each server request

SELECT *
FROM sys.dm_exec_cached_plans
-- Provides each query plan cached by the server to reduce execution time

SELECT *
FROM sys.dm_exec_query_stats
-- Provides statistics about cached query plans, such as reads, writes, etc

SELECT *
FROM sys.dm_db_index_usage_stats
--

SELECT *
FROM sys.dm_os_performance_counters
--

SELECT *
FROM sys.dm_os_schedulers
--

SELECT *
FROM sys.dm_os_nodes
--

SELECT *
FROM sys.dm_os_waiting_tasks
--

SELECT *
FROM sys.dm_os_wait_stats
--