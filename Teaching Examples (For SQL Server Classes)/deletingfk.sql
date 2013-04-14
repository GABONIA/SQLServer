/* 

This example will delete all foreign key references; if other tables reference the MainTableID, they will also be removed.

*/

ALTER TABLE MainTable
ADD FOREIGN KEY (MainTableID)
REFERENCES ForeignKeyTable(MainTableID)
ON DELETE CASCADE;
