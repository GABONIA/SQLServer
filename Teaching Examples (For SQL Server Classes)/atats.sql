/*

The "AT-ATs"
       Quick reference guide to the @@s

*/

/* Displays the total number of successful and failed connections since SQL Server last began */
SELECT @@CONNECTIONS "Total Connections Since Last Start"


/* Displays how long SQL Server has been working since last start in ticks and is the aggregate for every CPU.*/
SELECT @@CPU_BUSY


/* Displays the total qualifying rows opened in the connection's last cursor */
SELECT @@CURSOR_ROWS


/*  Displays the value of SET DATEFIRST*/
SELECT @@DATEFIRST


/* Displays the databases' timestamp data type */
SELECT @@DBTS


/* Displays the default collation */
SELECT @@DEF_SORTORDER_ID


/* Displays the default language ID */
SELECT @@DEFAULT_LANGID


/* Displays the status of the last FETCH statement from a cursor during any opened cursor in a connection */
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


/* Displays the time that SQL Server has remained idle since the last start in ticks. */
SELECT @@IDLE


/* Displays the total time SQL Server has performed input and output tasks since SQL Server's last start */
SELECT @@IO_BUSY


/* Displays the language ID in use */
SELECT @@LANGID


/* Displays the language in use (not the language ID) */
SELECT @@LANGUAGE


/* Displays the current session's lock out setting (shown in milliseconds) */
SELECT @@LOCK_TIMEOUT


/* Displays the total amount of concurrent user connections allowed  */
SELECT @@MAX_CONNECTIONS


/* Displays how precise a decimal or numeric type is set to be */
SELECT @@MAX_PRECISION


/* Displays the numeric version of SQL Server */
SELECT @@MICROSOFTVERSION


/* Displasy the nest level of a exeuction of a stored procedure (ie: if a procedure calls another procedure - see example) */
SELECT @@NESTLEVEL

-- Example:
CREATE PROCEDURE stp_LevelThree AS
BEGIN
	SELECT @@NESTLEVEL
END

CREATE PROCEDURE stp_LevelTwo AS
BEGIN
	SELECT @@NESTLEVEL
	EXECUTE stp_LevelTwo
END

CREATE PROCEDURE stp_LevelOne AS
BEGIN
	SELECT @@NESTLEVEL
	EXECUTE stp_LevelOne
END

EXECUTE stp_LevelZero

DROP PROCEDURE stp_LevelThree
DROP PROCEDURE stp_LevelTwo
DROP PROCEDURE stp_LevelOne


/* Displays information about SET options */
SELECT @@OPTIONS


/* Displays total input packs read by SQL Server from the network since last start */
SELECT @@PACK_RECEIVED


/* Displays total output packs written by SQL Server from the network since last start */
SELECT @@PACK_SENT


/* Displays total network pack errors hat happened on the SQL Server connection since last start */
SELECT @@PACKET_ERRORS


/* Displays the ID of the current stored procedure (see example) */
SELECT @@PROCID

-- Example:
CREATE PROCEDURE stp_ProcIDAt
AS
BEGIN
       SELECT @@PROCID
END

EXECUTE stp_ProcIDAt

DROP PROCEDURE stp_ProcIDAt


/* Displays the remote SQL Server database server name shown in the login record (see example) */
SELECT @@REMSERVER

-- Example:
CREATE PROCEDURE stp_RemServerAt
AS
BEGIN
       SELECT @@REMSERVER
END

EXECUTE stp_RemServerAt

DROP PROCEDURE stp_RemServerAt


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
