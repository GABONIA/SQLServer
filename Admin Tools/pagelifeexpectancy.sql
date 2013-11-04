/* 

Note that less than 500 would be considered low.  Average value for high OLTP 189457.

*/

SELECT object_name
	, counter_name
	, cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%Manager%'
	AND counter_name = 'Page life expectancy'
