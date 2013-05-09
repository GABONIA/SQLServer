/*

Interesting example about counting with CASE WHEN statements

SQLFiddle link: http://sqlfiddle.com/#!3/07216

*/

CREATE TABLE DurkahDurkah (
  ID INT,
  StartDate DATE,
  LoginDate DATE
)

INSERT INTO DurkahDurkah
VALUES (1,GETDATE(),GETDATE())
        ,(2,'2013-05-08','2013-05-07')

-- First Example
SELECT COUNT(CASE 
             WHEN LoginDate >= StartDate THEN ID END) [Logons]
FROM DurkahDurkah

-- Second Example
SELECT COUNT(CASE 
             WHEN LoginDate >= StartDate THEN ID 
             ELSE '' END) [Logons]
FROM DurkahDurkah
