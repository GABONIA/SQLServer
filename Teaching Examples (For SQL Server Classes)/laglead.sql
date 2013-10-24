CREATE TABLE ##Al(
	Alphabet VARCHAR(1)
)

INSERT INTO ##Al
VALUES ('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H'),('I'),('J'),('K'),('L'),('M')

SELECT Alphabet
	, LEAD(Alphabet,1) OVER (ORDER BY Alphabet)
	, LEAD(Alphabet,2) OVER (ORDER BY Alphabet)
	, LEAD(Alphabet,3) OVER (ORDER BY Alphabet)
	, LEAD(Alphabet,4) OVER (ORDER BY Alphabet)
	, LEAD(Alphabet,5) OVER (ORDER BY Alphabet)
	, LEAD(Alphabet,6) OVER (ORDER BY Alphabet)
	, LAG(Alphabet,1) OVER (ORDER BY Alphabet)
	, LAG(Alphabet,2) OVER (ORDER BY Alphabet)
	, LAG(Alphabet,3) OVER (ORDER BY Alphabet)
	, LAG(Alphabet,4) OVER (ORDER BY Alphabet)
	, LAG(Alphabet,5) OVER (ORDER BY Alphabet)
	, LAG(Alphabet,6) OVER (ORDER BY Alphabet)
FROM ##Al

DROP TABLE ##Al
