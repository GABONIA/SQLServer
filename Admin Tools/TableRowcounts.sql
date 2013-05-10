SELECT O.Name [Table Name]
    , I.Rows [Row Count]
FROM sysobjects O
    INNER JOIN sysindexes I ON O.id = I.id
WHERE I.IndId < 2
ORDER BY I.Rows DESC
