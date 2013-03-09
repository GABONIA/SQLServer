/* 

Records History of Various Studies: total population, sample size, the portion the sample size is to the population, and the study's description.

*/

CREATE TABLE StatisticsHistory(
	[Population] DECIMAL(20,2),
	[Sample] DECIMAL(20,2),
	[Portion] DECIMAL(11,8),
	[Description] VARCHAR(250)
)

INSERT INTO StatisticsHistory ([Population],[Sample],[Description]) VALUES (80000000,2000000,'Social Media Studies')

UPDATE StatisticsHistory
SET Portion = [Sample]/[Population]

SELECT *
FROM StatisticsHistory