SELECT Exc
  , Quarter
  , COUNT(Div) AS Cnt
FROM Extes
GROUP BY Exc, Quarter WITH CUBE
