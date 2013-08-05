/*

The "AT-ATs"
  Quick guide to the @@

*/

/* Displays the total number of successful and failed connections since SQL Server last began */
SELECT @@CONNECTIONS "Total Connections Since Last Start"


SELECT @@CPU_BUSY
SELECT @@CURSOR_ROWS
SELECT @@DATEFIRST
SELECT @@DBTS
SELECT @@DEF_SORTORDER_ID
SELECT @@DEFAULT_LANGID
SELECT @@FETCH_STATUS

/* Displays the last inserted identity row (see example) */
SELECT @@IDENTITY

-- Example
DECLARE @i TABLE(
	ID TINYINT IDENTITY(1,1),
	I TINYINT
)

INSERT INTO @i (I)
VALUES (10)

SELECT @@IDENTITY "Last Identity of First INSERT"

INSERT INTO @i (I)
VALUES (9),(8),(7)

SELECT @@IDENTITY "Last Identity of Second INSERT"

SELECT *
FROM @i

SELECT @@IDLE
SELECT @@IO_BUSY
SELECT @@LANGID
SELECT @@LANGUAGE
SELECT @@LOCK_TIMEOUT
SELECT @@MAX_CONNECTIONS
SELECT @@MAX_PRECISION
SELECT @@MICROSOFTVERSION
SELECT @@NESTLEVEL
SELECT @@OPTIONS
SELECT @@PACK_RECEIVED
SELECT @@PACK_SENT
SELECT @@PACKET_ERRORS
SELECT @@PROCID
SELECT @@REMSERVER

/* Displays the rowcount of previous query (see example) */
SELECT @@ROWCOUNT

-- Example:
DECLARE @r TABLE(
	R TINYINT
)

INSERT INTO @r
VALUES (1),(2),(3),(4),(5)
SELECT @@ROWCOUNT "Row count of INSERT"

SELECT *
FROM @r
WHERE R > 2

SELECT @@ROWCOUNT "Row count of SELECT"


/* Displays the name of the server */
SELECT @@SERVERNAME "Server Name"


/* Displays the registry key's name which the SQL Server is running */
SELECT @@SERVICENAME "Service Name"


/* Displays the SPID of the current process (see example) */
SELECT @@SPID

-- Example (highlight and execute both)
SELECT @@SPID "Current Process"
EXECUTE sp_who2 -- we can find the SPID in the first column


/* Displays the TEXTSIZE length */
SELECT @@TEXTSIZE

DECLARE @t TABLE(
	T TEXT
)

INSERT INTO @t
VALUES ('The quick brown fox jumped over the lazy dogs.  The dogs heard this often written idiom and immediately contacted Ruff, their attorney.  They filed a lawsuit against all the writers and developers that had used this line to test fonts, sentences, and everything else.')

SET TEXTSIZE 10
SELECT @@TEXTSIZE

SELECT *
FROM @t

SET TEXTSIZE 2147483647
SELECT @@TEXTSIZE

SELECT *
FROM @t


/* Displays microseconds per tick */
SELECT @@TIMETICKS "Microseconds/Tick"


/*  Displays the number of errors on disk write operations since SQL Server last started*/
SELECT @@TOTAL_ERRORS "Total Errors"


/* Displays only the number of disk reads since the SQL Server last started */
SELECT @@TOTAL_READ "Total Reads"


/* Displays only the number of disk writes since the SQL Server last started */
SELECT @@TOTAL_WRITE "Total Writes"


/* Displays the total BEGIN TRAN statements that have occured on the current SPID (see example) */
SELECT @@TRANCOUNT

-- Example
BEGIN TRAN
	SELECT '1' "BEGIN TRAN 1"
	SELECT @@TRANCOUNT "BEGIN TRAN Count"
	BEGIN TRAN
		SELECT '2' "BEGIN TRAN 2"
		SELECT @@TRANCOUNT "BEGIN TRAN Count"
		BEGIN TRAN
			SELECT '3'
			SELECT @@TRANCOUNT "BEGIN TRAN Count"
		COMMIT TRAN
	COMMIT TRAN
COMMIT TRAN


/* Displays the version of SQL Server, for instance whether it's 2012, or 2008R2 and whether it's developer or enterprise */
SELECT @@VERSION "Version"
