/* 

Records History of Various Studies: total population, sample size, the portion the sample size is to the population, and the study's description.

*/

CREATE TABLE StatisticsHistory(
	[Population] DECIMAL(20,2),
	[Sample] DECIMAL(20,2),
	[Portion] DECIMAL(11,8),
	[Description] VARCHAR(250)
)


CREATE PROCEDURE stp_InsertHistory
	@Population DECIMAL(20,2),
	@Sample DECIMAL(20,2),
	@Description VARCHAR(250)
AS
BEGIN
	INSERT INTO StatisticsHistory ([Population],[Sample],[Description]) VALUES (@Population, @Sample, @Description)
	
	UPDATE StatisticsHistory
	SET Portion = [Sample]/[Population]
END

-- C# application will call this stored procedure; below is an example
EXEC stp_InsertHistory 80000000,2000000,'Social Media Studies'


SELECT *
FROM StatisticsHistory