-- From here: http://sqlblog.com/blogs/jonathan_kehayias/archive/2009/09/29/what-session-created-that-object-in-tempdb.aspx

/* 
-- Reference:
DECLARE @path VARCHAR(250)
SELECT @path = path FROM sys.traces

SELECT *
FROM sys.fn_trace_gettable(@path, DEFAULT) AS gt  
*/

DECLARE @FileName VARCHAR(MAX)  

SELECT @FileName = SUBSTRING(path, 0, LEN(path)-CHARINDEX('\', REVERSE(path))+1) + '\Log.trc'  
FROM sys.traces   
WHERE is_default = 1

SELECT o.name,   
     o.OBJECT_ID,  
     o.create_date, 
     gt.NTUserName,  
     gt.HostName,  
     gt.SPID,  
     gt.DatabaseName,  
     gt.TEXTData 
FROM sys.fn_trace_gettable(@FileName, DEFAULT ) AS gt  
	INNER JOIN tempdb.sys.objects AS o ON gt.ObjectID = o.OBJECT_ID  
WHERE gt.DatabaseID = 2 
  AND gt.EventClass = 46
  AND o.create_date >= DATEADD(DD, -100, gt.StartTime)   
  AND o.create_date <= DATEADD(DD, 100, gt.StartTime)