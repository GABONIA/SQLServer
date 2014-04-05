SELECT *
FROM BitPriceData
WHERE PriceStDev IS NOT NULL

/*

DECLARE @b INT = 1, @m INT, @v INT = 100, @stdev DECIMAL(13,2), @avg DECIMAL(13,2)
SELECT @m = MAX(ID) FROM BitPriceData

WHILE @b <= @m
BEGIN
	
	--SELECT @stdev = STDEV(CAST(Price AS DECIMAL(13,2))) FROM BitPriceData WHERE ID BETWEEN @b AND @v
	SELECT @avg = AVG(CAST(Price AS DECIMAL(13,2))) FROM BitPriceData WHERE ID BETWEEN @b AND @v

	UPDATE BitPriceData
	--SET PriceStDev = @stdev
	SET PriceAvg = @avg
	WHERE ID = @v

	SET @b = @b + 1
	SET @v = @v + 1

END

*/

;WITH Outlier AS(
	SELECT ID
		, PriceDate
		, Price
		, (PriceAvg + (PriceStDev * 3)) ThreeAbove
		, (PriceAvg + (PriceStDev * -3)) ThreeBelow
	FROM BitPriceData
	WHERE PriceStDev IS NOT NULL
)
SELECT *
FROM Outlier
WHERE Price BETWEEN ThreeBelow AND ThreeAbove


CREATE PROCEDURE stp_OutOutliers
@t NVARCHAR(500), @id NVARCHAR(250), @v NVARCHAR(250), @avg NVARCHAR(250), @stdev NVARCHAR(250)
AS
BEGIN

	DECLARE @s NVARCHAR(MAX)
	SET @s = ';WITH OutOutlier AS(
		SELECT ' + @id + '
			, ' + @v + ' OutValue
			, (' + @avg + ' + (' + @stdev + ' *3)) ThreeAbove
			, (' + @avg + ' + (' + @stdev + ' *-3)) ThreeBelow
		FROM ' + @t + '
	)
	SELECT t2.*
	FROM OutOutlier t
		INNER JOIN ' + @t + ' t2 ON t.ID = t2.ID
	WHERE t.OutValue BETWEEN ThreeBelow AND ThreeAbove'

	EXEC sp_executesql @s
	
END

EXECUTE stp_OutOutliers 'BitPriceData','ID','Price','PriceAvg','PriceStDev'