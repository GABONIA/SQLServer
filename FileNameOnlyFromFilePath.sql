/* 

Parse Out a file name from a path 

*/

-- Build test table
DECLARE @FileName TABLE(
	FlNm VARCHAR(300)
)

-- Insert test values
INSERT INTO @FileName VALUES ('C:\OurFolder\OurNormalFile.csv')
INSERT INTO @FileName VALUES ('C:\OurServerName\OurFolderName\OurServerFile.txt')
INSERT INTO @FileName VALUES ('\\OurSharedFolder\OurSharedFile.csv')
INSERT INTO @FileName VALUES ('D:\OurBackUpDrive\OurBackUpFolder\OurBackUpFile.txt')

-- View the full paths with file names at the end
SELECT *
FROM @FileName

-- View the file names only
SELECT REPLACE(REVERSE(SUBSTRING(REVERSE(FlNm),1,CHARINDEX('\',REVERSE(FlNm)))),'\','') AS FlNm
FROM @FileName