CREATE FUNCTION [dbo].[fn_Clean]
(
    @String NVARCHAR(MAX), 
    @Ex NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    SET @Ex =  '%[' + @Ex + ']%'

    WHILE PATINDEX(@Ex, @String) > 0
    BEGIN
        SET @String = STUFF(@String, PATINDEX(@Ex, @String), 1, '')
    END

    RETURN @String

END

