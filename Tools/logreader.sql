SELECT DISTINCT
	'USE msdb
	EXEC sp_start_job @job_id = ' AS ExecScrpt
	, la.job_id
	, lh.runstatus
FROM MSlogreader_agents la
		INNER JOIN MSlogreader_history lh ON la.id = lh.agent_id
WHERE lh.runstatus IN (5,6)
