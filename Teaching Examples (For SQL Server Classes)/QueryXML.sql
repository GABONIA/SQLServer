/* 

Query XML: Assumes the table in question has XML data; if it doesn't and it's in XML format, we can insert the XML formatted data into a table that is set for XML.

*/

CREATE TABLE XMLTable(
  ID SMALLINT,
  XMLValue XML
)


INSERT INTO XMLTable Values(1,'<name>Bob</name><zip>94952</zip><phone>8005551212</phone>')


SELECT ID
  , XMLValue.query('name')
  , XMLValue.query('zip')
  , XMLValue.query('phone').value('.','VARCHAR(MAX)') -- note this will be text without the tags
FROM XMLTable
