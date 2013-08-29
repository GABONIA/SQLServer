/*

BULK INSERT Examples
	-  Works with other file formats than .CSV and .TXT
	-  Can complete skip the FIELDTERMINATOR if needed.
	-  The ERRORFile will produce a log showing where the BULK INSERT is breaking (excellent for fixes)

*/

BULK INSERT TableName
FROM 'File.txt'
WITH (
	-- note, if only one column exists in file, this can be removed
	FIELDTERMINATOR = ','
	,ROWTERMINATOR = '0x0a'
	-- If the data starts at a certain row, input here
	,FIRSTROW=2
	-- If the data end at a certain row
	,LASTROW=1000000
	-- Logs any rows of data causing an error (very useful for debugging)
	,ERRORFILE='C:\logfile.log')
GO
