USE tempdb
GO

/*

Example of querying complex XML either saved as an XML string or VARCHAR string

*/

CREATE TABLE EitherXML (
    ID TINYINT IDENTITY(1,1),
    NonXMLValue VARCHAR(2000),
	XMLValue XML
)


INSERT INTO EitherXML (NonXMLValue,XMLValue)
VALUES ('<Record ID="1" Machine="2"><Start>Six</Start><Number ID="2" Details="Maybe"><Time>2013-01-01</Time></Number></Record>','<Record ID="1" Machine="2"><Start>Six</Start><Number ID="2" Details="Maybe"><Time>2013-01-01</Time></Number></Record>')
	, ('<Record ID="2" Machine="3"><Start>Nine</Start><Number ID="4" Details="Yes"><Time>2013-01-02</Time></Number></Record>','<Record ID="2" Machine="3"><Start>Nine</Start><Number ID="4" Details="Yes"><Time>2013-01-02</Time></Number></Record>')


-- Querying XML values saved as VARCHAR strings
SELECT ID
	, NonXMLValue
	, CAST(NonXMLValue AS XML).value('(//Record/@ID)[1]', 'SMALLINT') AS RecordID
	, CAST(NonXMLValue AS XML).value('(//Record/@Machine)[1]', 'SMALLINT') AS Machine
	, CAST(NonXMLValue AS XML).value('(//Record/Start)[1]', 'VARCHAR(10)') AS Start
	, CAST(NonXMLValue AS XML).value('(//Record/Number/@ID)[1]', 'SMALLINT') AS NumberID
	, CAST(NonXMLValue AS XML).value('(//Record/Number/@Details)[1]', 'VARCHAR(10)') AS NumberDetails
	, CAST(NonXMLValue AS XML).value('(//Record/Number/Time)[1]', 'DATE') AS NumberDate
FROM EitherXML


-- Querying XML values saved as XML strings
SELECT ID
	, XMLValue
	, n.b.value('(@ID)[1]', 'SMALLINT') AS RecordID
	, n.b.value('(@Machine)[1]', 'SMALLINT') AS Machine
	, n.b.value('(Start)[1]', 'VARCHAR(10)') AS Start
	, n2.b.value('(@ID)[1]', 'SMALLINT') AS NumberID
	, n2.b.value('(@Details)[1]', 'VARCHAR(10)') AS NumberDetails
	, n2.b.value('(Time)[1]', 'DATE') AS NumberDate
FROM EitherXML xt
	CROSS APPLY xt.XMLValue.nodes('/Record') AS n(b)
	CROSS APPLY xt.XMLValue.nodes('/Record/Number') AS n2(b)


DROP TABLE EitherXML
