/* 

Saves all DTS packages to a folder on the C drive called DTSPackages

1.  Copy and paste both queries into a text file.
2.  Save text file as dtssaved.bat.
3.  From the command line (cmd) run the bat file by typing dtssaved.bat (from its location).
4.  All DTS Packages will be saved on C Drive in a folder called DTSPackages.

Credit: some of the code was created by Bill Fellows

*/

SELECT 'mkdir ' + REPLACE(@@SERVERNAME,'\','') + '_DTSPackages_'

;
WITH FOLDERS AS
(
    -- Capture root node
    SELECT
        cast(PF.foldername AS varchar(max)) AS FolderPath
    ,   PF.folderid
    ,   PF.parentfolderid
    ,   PF.foldername
    FROM
        msdb.dbo.sysssispackagefolders PF
    WHERE
        PF.parentfolderid IS NULL

    -- build recursive hierarchy
    UNION ALL
    SELECT
        cast(F.FolderPath + '\' + PF.foldername AS varchar(max)) AS FolderPath
    ,   PF.folderid
    ,   PF.parentfolderid
    ,   PF.foldername
    FROM
        msdb.dbo.sysssispackagefolders PF
        INNER JOIN FOLDERS F ON F.folderid = PF.parentfolderid
)
,   PACKAGES AS
(
    -- pull information about stored SSIS packages
    SELECT
        P.name AS PackageName
    ,   P.id AS PackageId
    ,   P.description as PackageDescription
    ,   P.folderid
    ,   P.packageFormat
    ,   P.packageType
    ,   P.vermajor
    ,   P.verminor
    ,   P.verbuild
    ,   suser_sname(P.ownersid) AS ownername
    FROM
        msdb.dbo.sysssispackages P
)
SELECT 
    -- assumes default instance and localhost
    -- use serverproperty('servername') and serverproperty('instancename') 
    -- if you need to really make this generic
    'dtutil /sourceserver localhost /SQL "'+ F.FolderPath + '\' + P.PackageName + '" /copy file;C:\DTSPackages\' + P.PackageName +'.dtsx' AS cmd
FROM 
    FOLDERS F
    INNER JOIN PACKAGES P ON P.folderid = F.folderid
-- uncomment this if you want to filter out the 
-- native Data Collector packages
-- WHERE
--     F.FolderPath <> '\Data Collector'
