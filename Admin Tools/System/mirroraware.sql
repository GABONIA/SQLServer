-- Updating connection strings

SELECT Replace(ConfiguredValue,';Initial Catalog=',';Failover Partner=[SERVER];Initial Catalog=')
FROM dbo.SSISConfig


/*

-- Example:

DECLARE @s VARCHAR(1000)
SET @s = 'Data Source=SERVERONE\INST;Initial Catalog=DB;Integrated Security=True;'

SELECT REPLACE(@s,';Initial Catalog=',';Failover Partner=SERVERTWO\INST;Initial Catalog=')

*/
