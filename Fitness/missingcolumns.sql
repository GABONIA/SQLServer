/*

Add missing columns

*/


CREATE TABLE exc.[VALUES](
  [Date] DATE,
  [Weight] DECIMAL(8,4],
  [Repetitions] DECIMAL(8,4),
  Notes VARCHAR(1000)
)

// For the few missed ALTER TABLE exc.[MISSEDTABLES] ADD Notes VARCHAR(1000)
