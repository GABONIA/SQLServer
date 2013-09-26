;WITH CheckFillFactor AS(
	SELECT OBJECT_NAME(OBJECT_ID) [Name]
		, type_desc [Type]
		, fill_factor [Fill Factor]
	FROM sys.indexes
)
SELECT *
FROM CheckFillFactor
