;WITH YoY AS(
       SELECT YEAR(Date) DateYear
              , MIN(Date) YearFirstDay
              , MAX(Date) YearLastDay
       FROM Table
       GROUP BY YEAR(Date)
)
SELECT t2.MFYear
       , t1.Value StartClose
       , t3.Value EndClose
FROM Table t1
       INNER JOIN YoY t2 ON t1.DateYear = t2.YearFirstDay
       INNER JOIN Table t3 ON t3.DateYear = t2.YearLastDay
