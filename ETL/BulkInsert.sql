/*

BULK INSERT Examples
	-  Works with other file formats than .CSV and .TXT (files can have created formats like .cre and BULK INSERT will function).
	-  Can complete skip the FIELDTERMINATOR if needed.
	-  The ERRORFile will produce a log showing where the BULK INSERT is breaking (excellent for fixes),
	-  A NVARCHAR(MAX) table can store up to 2 GIG; one column
	-  This line was added for a video tutorial.

*/

BULK INSERT TableName
FROM 'C:\File.txt'
WITH (
	-- OPTIONS:
	-- note, if only one column exists in file, this can be removed
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a'
	-- If the data starts at a certain row, input here
	,FIRSTROW=2
	-- If the data end at a certain row
	,LASTROW=1000000
	-- Logs any rows of data causing an error (very useful for debugging)
	,ERRORFILE='C:\logfile.log'
	-- Specifies how many errors in rows can occur before it will break (almost always set this to 0)
	,MAXERRORS = 0)
GO
