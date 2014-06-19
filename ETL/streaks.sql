/*

Streak Example

1.  If another column exists for things to be broken down (like Options, Stocks, Futures), add to the PARTITION BY

Add

1.  Percent
2.  Done vs. Not Done count

*/

CREATE TABLE Trading (
	TradingDate DATE,
	TradingAction VARCHAR(10)
)


INSERT INTO Trading
VALUES ('2014-01-01','Trade')
	, ('2014-01-02','Trade')
	, ('2014-01-03','Trade')
	, ('2014-01-04','No')
	, ('2014-01-05','No')
	, ('2014-01-06','Trade')
	, ('2014-01-07','Trade')
	, ('2014-01-08','No')
	, ('2014-01-09','No')
	, ('2014-01-10','Trade')
	, ('2014-01-11','No')
	, ('2014-01-12','No')
	, ('2014-01-13','No')
	, ('2014-01-14','Trade')
	, ('2014-01-15','Trade')


;WITH Streak AS(
	SELECT ROW_NUMBER() OVER (ORDER BY TradingDate) OverallID
		, ROW_NUMBER() OVER (PARTITION BY TradingAction ORDER BY TradingDate) TradeID
		, (ROW_NUMBER() OVER (ORDER BY TradingDate) - ROW_NUMBER() OVER (PARTITION BY TradingAction ORDER BY TradingDate)) IDDifference
		, *
	FROM Trading
)
SELECT ROW_NUMBER() OVER (PARTITION BY IDDifference ORDER BY TradingDate) Streak
	, TradingDate
	, TradingAction
FROM Streak
ORDER BY TradingDate


DROP TABLE Trading
