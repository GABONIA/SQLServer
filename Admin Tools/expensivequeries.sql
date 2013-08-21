/*

Identifying expensive queries (written by Jonathan Kehayias of http://www.sqlskills.com/blogs/jonathan/)

*/

WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan'), CTE AS (
        SELECT
                qp.query_plan AS [QueryPlan],
                cp.plan_handle [PlanHandle],
                st.[Text] AS [Statement],
                n.value('(@StatementOptmLevel)[1]', 'VARCHAR(25)') AS OptimizationLevel ,
                ISNULL(CAST(n.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') as float),0) AS SubTreeCost ,
                cp.usecounts [UseCounts],
                cp.size_in_bytes [SizeInBytes]
        FROM
                sys.dm_exec_cached_plans AS cp
                CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
                CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
                CROSS APPLY query_plan.nodes ('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS qn ( n )
)
SELECT TOP 5 [Statement]
        , SubTreeCost * UseCounts AS [Cost]
        , SizeInBytes
FROM CTE
ORDER BY Cost DESC

/*

To view the query plan, add QueryPlan to the SELECT TOP 5 query

*/
