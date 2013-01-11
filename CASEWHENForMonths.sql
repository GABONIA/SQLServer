/*

SQL File for numbering the months, if you're column is in the year this CASE WHEN will change it to a number

*/

-- Version 1: 1 or 2 digit months
CASE 
	WHEN [OurColumnName] LIKE '%January%' THEN 1 
	WHEN [OurColumnName] LIKE '%February%' THEN 2
	WHEN [OurColumnName] LIKE '%March%' THEN 3
	WHEN [OurColumnName] LIKE '%April%' THEN 4
	WHEN [OurColumnName] LIKE '%May%' THEN 5
	WHEN [OurColumnName] LIKE '%June%' THEN 6
	WHEN [OurColumnName] LIKE '%July%' THEN 7
	WHEN [OurColumnName] LIKE '%August%' THEN 8
	WHEN [OurColumnName] LIKE '%September%' THEN 9
	WHEN [OurColumnName] LIKE '%October%' THEN 10
	WHEN [OurColumnName] LIKE '%November%' THEN 11
	WHEN [OurColumnName] LIKE '%December%' THEN 12
	ELSE 99 -- This will be removed
END

-- Version 2: 2 digit months
CASE 
	WHEN [OurColumnName] LIKE '%January%' THEN 01 
	WHEN [OurColumnName] LIKE '%February%' THEN 02
	WHEN [OurColumnName] LIKE '%March%' THEN 03
	WHEN [OurColumnName] LIKE '%April%' THEN 04
	WHEN [OurColumnName] LIKE '%May%' THEN 05
	WHEN [OurColumnName] LIKE '%June%' THEN 06
	WHEN [OurColumnName] LIKE '%July%' THEN 07
	WHEN [OurColumnName] LIKE '%August%' THEN 08
	WHEN [OurColumnName] LIKE '%September%' THEN 09
	WHEN [OurColumnName] LIKE '%October%' THEN 10
	WHEN [OurColumnName] LIKE '%November%' THEN 11
	WHEN [OurColumnName] LIKE '%December%' THEN 12
	ELSE 99 -- This will be removed
END