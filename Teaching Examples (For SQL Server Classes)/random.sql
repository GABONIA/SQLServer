DECLARE @l INT = ((RAND()*10)+10), @c VARCHAR(93), @r VARCHAR(20), @b INT = 1
SET @c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,''"!@#$%^&*()-+=~`<>/?[]{}\|;:'
SET @r = ''

WHILE @b <= @l
BEGIN

	SET @r = @r + SUBSTRING(@c,CONVERT(INT,(RAND())*LEN(@c)),1)
	SET @b = @b + 1

END

SELECT @r

/*




*/
