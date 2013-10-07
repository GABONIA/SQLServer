/* 

Filtering the results from sp_who2

*/

DECLARE @spwhotwo TABLE(
        SPID INT,
        Status VARCHAR(MAX),
        LOGIN VARCHAR(MAX),
        HostName VARCHAR(MAX),
        BlkBy VARCHAR(MAX),
        DBName VARCHAR(MAX),
        Command VARCHAR(MAX),
        CPUTime INT,
        DiskIO INT,
        LastBatch VARCHAR(MAX),
        ProgramName VARCHAR(MAX),
        SPID_1 INT,
        REQUESTID INT
)

INSERT INTO @spwhotwo 
EXEC sp_who2

SELECT  *
FROM @spwhotwo
WHERE [CRITERIA]
