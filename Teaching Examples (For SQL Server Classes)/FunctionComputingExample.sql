/* 

Function Computing Example: this will "rate" stocks based on criteria passed into it and return the value

*/

CREATE FUNCTION RatingAgency
(
    @PE DECIMAL(6,2),
    @Dividend DECIMAL(5,4),
    @BookValue DECIMAL(5,2)
)
RETURNS @Rating TABLE
(
    [P/E] DECIMAL(6,2) NOT NULL,
    [Dividend Yield] DECIMAL(5,4) NOT NULL,
    [Book Value] DECIMAL(5,2) NOT NULL,
    [Rating] AS (([P/E]*.33) + ([Dividend Yield]*33) + ([Book Value]*.33))
)
BEGIN
    INSERT INTO @Rating VALUES (@PE,@Dividend,@BookValue)

    RETURN
END

SELECT *
FROM RatingAgency(9,.25,3)