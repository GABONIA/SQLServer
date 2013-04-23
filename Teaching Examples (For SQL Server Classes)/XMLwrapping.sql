/* 

Wrap values in XML example

*/

DECLARE @xmldata TABLE(
  ID TINYINT IDENTITY(1,1),
	FirstName VARCHAR(25),
	LastName VARCHAR(25),
	Phone VARCHAR(12)
)

INSERT INTO @xmldata (FirstName,LastName,Phone)
VALUES ('John','Doe','8005551212')
	, ('Jane','Doe','8005552121')
	, ('Jacklyn','Doe','8005552211')
	, ('Jason','Doe','8005551122')
	
SELECT (SELECT ID FOR XML PATH(''))
	, (SELECT FirstName FOR XML PATH(''))
	, (SELECT LastName FOR XML PATH(''))
	, (SELECT Phone FOR XML PATH(''))
	, (SELECT ID FOR XML PATH('')) + (SELECT FirstName FOR XML PATH('')) + (SELECT LastName FOR XML PATH('')) + (SELECT Phone FOR XML PATH(''))
	, '<ID="' + CAST(ID AS VARCHAR(1)) + '">' + (SELECT FirstName FOR XML PATH('')) + (SELECT LastName FOR XML PATH('')) + (SELECT Phone FOR XML PATH('')) + '</ID>'
	, (SELECT (SELECT FirstName FOR XML PATH('')) + (SELECT LastName FOR XML PATH('')) + (SELECT Phone FOR XML PATH('')) FOR XML PATH('ID'))
FROM @xmldata
