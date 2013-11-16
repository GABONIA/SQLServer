CREATE TABLE Example(
  Name VARCHAR(100),
  OwnerEntry VARCHAR(100)
    CONSTRAINT DF_DemoTable_OwnerEntry DEFAULT(SUSER_NAME())
)

INSERT INTO Example (Name)
VALUES ('John')

SELECT *
FROM Example
