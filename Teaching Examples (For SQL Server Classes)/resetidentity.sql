CREATE TABLE Ident(
	ID SMALLINT IDENTITY(1,1),
	Minion VARCHAR(200)
)

INSERT INTO Ident (Minion)
VALUES ('One, you''re like a dream come true ...')
	, ('Two, just want to be with you ...')
	, ('Three, it''s plain to see that you''re the only one for me ...')


SELECT *
FROM Ident

DELETE FROM Ident
WHERE ID = 3

SELECT *
FROM Ident

INSERT INTO Ident (Minion)
VALUES ('Three, that''s al ... FOUR?  HUH?')

SELECT *
FROM Ident

DELETE FROM Ident
WHERE ID = 4

DBCC CHECKIDENT('dbo.Ident', RESEED, 2)

INSERT INTO Ident (Minion)
VALUES ('Three, that''s all I can count to!')

SELECT *
FROM Ident

DROP TABLE Ident
