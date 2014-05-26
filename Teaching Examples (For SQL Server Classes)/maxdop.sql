/*

  MAXDOP - test depending on OLTP v. OLAP, CPUs, etc

*/

SELECT *
FROM OurTable
OPTION (MAXDOP 2)
