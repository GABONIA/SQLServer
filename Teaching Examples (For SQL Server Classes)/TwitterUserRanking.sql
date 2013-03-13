/* 

Build a Twitter Ranking Table which will use an algorithm to rank a user

Logic is as follows:
1.  A large followers to following ratio is positive
2.  A followers to tweets ratio of 1 to 6 is positive, but anything greater than 6 could be a spammer, so we "cap" it at 6.
3.  A large average of hashtags per tweet is negative.
4.  A large average of links per tweet is negative.

*/

CREATE TABLE TwitterRanking(
	TwitterUser VARCHAR(30),
	Tweets DECIMAL(20,2),
	Hashtags DECIMAL(20,2),
	Links DECIMAL(20,2),
	Followers DECIMAL(20,2),
	Following DECIMAL(20,2),
	Rating DECIMAL(5,2)
)

INSERT INTO TwitterRanking (TwitterUser,Tweets,Hashtags,Links,Followers,Following)
VALUES('UserXYZSpam',300,5000,800,32,1001),('EvenUser',100,100,100,100,100)

SELECT *
FROM TwitterRanking

-- Logic of the FUNCTION
UPDATE TwitterRanking
SET Rating = (Followers/Following) + (Followers/Tweets) + (-.1*Hashtags) + (-.25*Links)
-- Can you see the problem with this ranking system?  How can we use a function to correct this problem?
-- Answer: we haven't placed a cap on the followers to tweets ratio.


-- Placing a cap using a CASE/WHEN, step-by-step (in the columns):
SELECT TwitterUser
	, CAST((Followers/Following) + (-.1*Hashtags) + (-.25*Links) AS DECIMAL(20,2)) AS Rating1
	, CASE
	WHEN CAST(Followers/Tweets AS DECIMAL(5,2)) > 6 THEN 6.00
	ELSE CAST(Followers/Tweets AS DECIMAL(5,2)) END AS Rating2
	, CAST((Followers/Following) + (-.1*Hashtags) + (-.25*Links) AS DECIMAL(20,2)) + CASE WHEN CAST(Followers/Tweets AS DECIMAL(5,2)) > 6 THEN 6.00 ELSE CAST(Followers/Tweets AS DECIMAL(5,2)) END AS Combined
FROM TwitterRanking
-- Notice that "Combined" combines Rating1 and Rating2, which is the aggregate user rating


/* ONLY USE FOR TESTING: 

-- DROP TABLE TwitterRanking

*/