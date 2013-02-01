/* 

Calculates the mode of a data set 

*/

SELECT TOP 1 Value, COUNT(*) Mode
FROM research
GROUP BY Value
ORDER BY COUNT(*) DESC