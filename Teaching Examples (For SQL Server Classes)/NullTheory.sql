/* 

NULL Theory

 */

DECLARE @num TABLE(
	Num INT
)

INSERT INTO @num VALUES (1),(3),(5),(''),(NULL),(3)

SELECT Num
FROM @num
WHERE ISNUMERIC(Num) = 0

SELECT Num
FROM @num
WHERE Num = 0

SELECT Num
FROM @num
WHERE Num <> 0