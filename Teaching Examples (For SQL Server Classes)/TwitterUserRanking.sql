/* 

Build a Twitter Ranking Table which will use an algorithm to rank a user

Logic is as follows:
1.  A large followers to following ratio is positive
2.  A followers to tweets ratio of 1 to 5 is positive, but anything greater than 5 could be a spammer.  Anything less than 1 might be a spammer.
3.  A large average of hashtag per tweet is negative.
4.  A large average of links per tweet is negative.

*/

CREATE TABLE TwitterRanking(
	TwitterUser VARCHAR(30),
	Tweets DECIMAL(20,2),
	Hashtags DECIMAL(20,2),
	Link DECIMAL(20,2),
	Followers DECIMAL(20,2),
	Following DECIMAL(20,2),
	Rating DECIMAL(5,2)
)

INSERT INTO TwitterRanking (TwitterUser,Tweets,Hashtags,Link,Followers,Following)
VALUES('UserXYZSpam',300,5000,800,32,1001),('Even',100,100,100,100,100)

SELECT *
FROM TwitterRanking

-- Logic of the FUNCTION
UPDATE TwitterRanking
SET Rating = (Followers/Following) + (Followers/Tweets) + (-.1*Hashtags) + (-.25*Link)
-- Can you see the problem with this ranking system?  How can we use a function to correct this problem?

SELECT TwitterUser
	, CASE
	WHEN CAST(Followers/Tweets AS DECIMAL(5,2)) > 6 THEN 6.00
	ELSE CAST(Followers/Tweets AS DECIMAL(5,2)) END AS Rating2
FROM TwitterRanking

/* ONLY USE FOR TESTING: 

-- DROP TABLE TwitterRanking

*/