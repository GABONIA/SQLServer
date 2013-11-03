/*

Data cleaning for genetic, disease and nutrition data.

*/


UPDATE Value
SET Value = LTRIM(RTRIM(Value))


UPDATE Column
SET Column = 'ND'
WHERE Column IS NULL
	OR Column = '~'


-- Culprits
('Middle Atlantic'
, 'East North Central'
, 'Seattle-Puget Sound'
, 'Atlanta' -- #40
, 'United States'
, 'South Atlantic'
, 'Midwest'
, 'West North Central'
, 'South'
, 'San Francisco-Oakland' -- #14, #45
, 'Northeast'
, 'Mountain'
, 'West South Central'
, 'San Jose-Monterey' -- #10, Unlisted
, 'New England'
, 'Los Angeles'
, 'East South Central'
, 'West'
, 'Detroit' -- #18
, 'Pacific')

/*

Gov data note: the cities aren't even the most populous cities; see http://en.wikipedia.org/wiki/List_of_United_States_cities_by_population.



*/
