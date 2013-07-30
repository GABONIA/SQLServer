/*

Get remaining free space in MDF

*/

USE DatabaseName
GO

CREATE TABLE ##ShowFileStats(
  FileID SMALLINT,
	FileGroup SMALLINT,
	TotalExtents DECIMAL(20,2),
	UsedExtents DECIMAL(20,2),
	Name VARCHAR(100),
	FileName VARCHAR(250)
)

INSERT INTO ##ShowFileStats
EXEC('DBCC SHOWFILESTATS')

SELECT ((TotalExtents - UsedExtents) * (8 * 8096)) AS [Remaining Space In MDF]
FROM ##ShowFileStats
