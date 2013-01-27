/* 

Data dirty reading: consistency and locking

*/

-- Popular, but problems coming later:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Better method
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

