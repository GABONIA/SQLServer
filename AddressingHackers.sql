DECLARE @hacker TABLE (
	LogDate DATETIME,
	ProcessInfo VARCHAR(12),
	Text VARCHAR(500)	
)

INSERT INTO @hacker
EXEC sp_readerrorlog 0, 1, 'Login failed' 

INSERT INTO @hacker VALUES (DATEADD(HOUR,-1,getdate()),'Logon','Login failed for user 20')
INSERT INTO @hacker VALUES (DATEADD(HOUR,-1,getdate()),'Logon','Login failed for user 20')
INSERT INTO @hacker VALUES (DATEADD(HOUR,-1,getdate()),'Logon','Login failed for user 22')
INSERT INTO @hacker VALUES (DATEADD(HOUR,-1,getdate()),'Logon','Login failed for user 22')
INSERT INTO @hacker VALUES (DATEADD(HOUR,-1,getdate()),'Logon','Login failed for user 21')
INSERT INTO @hacker VALUES (DATEADD(HOUR,-1,getdate()),'Logon','Login failed for user 19')

IF (SELECT COUNT([Text]) AS "Failed Logins"
	FROM @hacker
	WHERE LogDate BETWEEN DATEADD(HOUR,-2,getdate()) AND getdate()) > 5
-- [SEND ALERT; FLAG USERS]