BULK INSERT OurTable  -- Put the table name here
FROM 'C:\OurCSVFile.csv'  -- Put the CSV file location here
WITH (FIELDTERMINATOR = ',',ROWTERMINATOR = '\n')  -- the delimiters; they can differ per CSV or TXT file
GO