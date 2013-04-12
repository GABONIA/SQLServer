/* 

Spearman's rank correlation coefficient

*/

USE TableCheckTool
GO

CREATE TABLE PearsonTable(
  XRank INT IDENTITY(1,1) NOT NULL,
	XValue DECIMAL(8,4) NOT NULL,
	YRank INT,
	YValue DECIMAL(8,4) NOT NULL,
	XYDiff DECIMAL(8,4),
	XYDiffSq DECIMAL(10,4)
)

DECLARE @YTable TABLE(
	YRank INT IDENTITY(1,1),
	YValue DECIMAL(8,4)
)

INSERT INTO @YTable (YValue)
SELECT YValue
FROM PearsonTable
ORDER BY YValue ASC

UPDATE PearsonTable
SET YRank = @YTable.YRank FROM @YTable INNER JOIN @YTable ON YValue = @YTable.YValue

UPDATE PearsonTable
SET XYDiff = XRank - YRank

UPDATE PearsonTable
SET XYDiffSq = XYDiff * XYDiff

DECLARE @sum DECIMAL(10,4), @total INT
SELECT @sum = SUM(XYDiffSq) FROM PearsonTable
SELECT @total = COUNT(*) FROM PearsonTable

DECLARE @pearson DECIMAL(18,4)
SET @pearson = (6*@sum)/(@total*((@total*@total)-1))
