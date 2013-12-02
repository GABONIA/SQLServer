CREATE PROCEDURE stp_GetActiveJobs
AS
BEGIN

	/* Retrieves the last run time of jobs */

	;WITH Jobs AS(
		SELECT CONVERT(DATETIME, RTRIM(run_date)) + (run_time * 9 + run_time % 10000 * 6 + run_time % 100 * 10) / 216e4 LastJobDate
			, job_id JobID
		FROM msdb.dbo.sysjobhistory
	)
	SELECT DISTINCT c.JobID
		, j.name
		, MAX(c.LastJobDate) LatestRunDate
	FROM Jobs c
		INNER JOIN msdb.dbo.sysjobs j ON c.JobID = j.job_id
	GROUP BY c.JobID, j.name


END
