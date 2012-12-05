/* 

This is the most basic document in TSQL for preventing MAJOR mistakes. 

Use this for any INSERTS, UPDATES or DELETES in production 

*/

-- Before preforming a write operation (INSERT, UPDATE DELETE), we highlight and execute the below code

BEGIN TRAN


-- We place our code in this comment section, NOT outside of it so that we can test it
/*

INSERT 


UPDATE


DELETE

*/

-- Search the changes you made
SELECT *
FROM [TableChanged]


-- By default will rollback the changes we made
ROLLBACK TRAN

-- If you made no mistakes highlight the below code and execute it
/*

COMMIT TRAN

*/