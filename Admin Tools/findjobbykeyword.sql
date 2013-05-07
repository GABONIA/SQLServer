/*

Useful script for finding a job by a keyword in either its name, description, step name or actual code.

*/

SELECT j.name
  , j.description
	, st.step_name
	, st.command
FROM msdb.dbo.sysjobs j
	INNER JOIN msdb.dbo.sysjobsteps st ON st.job_id = j.job_id
WHERE j.enabled = 1
	AND j.name LIKE '%[keyword]%'
	OR j.description LIKE '%[keyword]%'
	OR st.step_name LIKE '%[keyword]%'e
	OR st.command LIKE '%[keyword]%'
