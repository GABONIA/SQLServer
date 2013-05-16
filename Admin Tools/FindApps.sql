/*

Find the connected applications

*/

SELECT program_name 
FROM sys.dm_exec_sessions
WHERE program_name IS NOT NULL
