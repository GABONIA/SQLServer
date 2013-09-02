CREATE TABLE FoodList(
	FoodID INT IDENTITY(1,1),
	Food VARCHAR(500),
	IssueCount SMALLINT
)

CREATE TABLE DailyEating(
	EatingDate DATE DEFAULT GETDATE(),
	FoodID INT,
	IssueFlag BIT DEFAULT 0
)

CREATE TABLE HealthIssues(
	HealthIssueID INT IDENTITY(1,1),
	HealthIssue VARCHAR(500)
)

CREATE TABLE DailyIssues(
	HealthIssueID INT,
	IssueDate DATE DEFAULT GETDATE()
)

CREATE TABLE FoodIssues(
	FoodID INT,
	HealthIssueID INT
)

CREATE PROCEDURE stp_IssueCheckDiet
@issue VARCHAR(500)
AS
BEGIN
	
	DECLARE @count INT
	SELECT @count = HealthIssueID FROM HealthIssues WHERE HealthIssue = @issue
	IF @count = 0
	BEGIN

		INSERT INTO HealthIssues (HealthIssue)
		SELECT @issue

	END

	DECLARE @i INT
	SELECT @i = HealthIssueID FROM HealthIssues WHERE HealthIssue = @issue

	INSERT INTO DailyIssues (HealthIssueID)
	SELECT @i

	;WITH CTE AS(
		SELECT FoodID
			, COUNT(FoodID) AS NumberOfTimesEaten
		FROM DailyEating
		GROUP BY FoodID
	)
	SELECT d.FoodID
	FROM DailyEating d
		INNER JOIN CTE c ON d.FoodID = c.FoodID
	WHERE d.EatingDate BETWEEN DATEADD(DD,-1,GETDATE()) AND GETDATE()
		AND c.NumberOfTimesEaten < 5
		OR d.IssueFlag = 1


END
