CREATE TABLE InsertID(
	ID SMALLINT IDENTITY(1,1),
	Name VARCHAR(50)
)

INSERT INTO InsertID (Name)
VALUES ('Joe')

SELECT SCOPE_IDENTITY()

INSERT INTO InsertID (Name)
VALUES ('David')
	, ('Andrew')
	, ('Jessica')
	, ('Hannah')
	, ('Jane')

SELECT SCOPE_IDENTITY()

DECLARE @m SMALLINT, @s SMALLINT

INSERT INTO InsertID (Name)
VALUES ('Jack')
	, ('Jill')

SELECT @m = MAX(ID) FROM InsertID
SELECT @s = SCOPE_IDENTITY()

IF @m = @s
BEGIN
	PRINT 'Equal'
END
ELSE
BEGIN
	PRINT 'Oh noez!!'
END
