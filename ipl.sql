create database cricket_db;

CREATE TABLE deliveries (
    match_id INT NOT NULL,
    inning INT NOT NULL,
    batting_team VARCHAR(50) NOT NULL,
    bowling_team VARCHAR(50) NOT NULL,
    over INT NOT NULL,
    ball INT NOT NULL,
    batter VARCHAR(50) NOT NULL,
    bowler VARCHAR(50) NOT NULL,
    non_striker VARCHAR(50) NOT NULL,
    batsman_runs INT NOT NULL,
    extra_runs INT NOT NULL,
    total_runs INT NOT NULL,
    extras_type VARCHAR(20),
    is_wicket BOOLEAN NOT NULL,
    player_dismissed VARCHAR(50),
    dismissal_kind VARCHAR(50),
    fielder VARCHAR(50),
    PRIMARY KEY (match_id, inning, over, ball)
);

CREATE TABLE matches (
    id INT PRIMARY KEY,
    season VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    match_type VARCHAR(20) ,
    player_of_match VARCHAR(50),
    venue VARCHAR(100),
    team1 VARCHAR(50) NOT NULL,
    team2 VARCHAR(50) NOT NULL,
    toss_winner VARCHAR(50) NOT NULL,
    toss_decision VARCHAR(10) NOT NULL,
    winner VARCHAR(50) ,
    result VARCHAR(20) ,
    result_margin VARCHAR(20),
    target_runs INT,
    target_overs INT,
    super_over CHAR(1),  -- Use CHAR(1) for 'Y' or 'N'
    method VARCHAR(50),
    umpire1 VARCHAR(50),
    umpire2 VARCHAR(50) 
);

ALTER TABLE matches
ALTER COLUMN target_overs TYPE NUMERIC;
ALTER TABLE matches
ALTER COLUMN city DROP NOT NULL;

select * from matches;
select *  from  deliveries;

-- Q1: How many matches were played in total?

SELECT COUNT(*) AS total_matches 
FROM matches;

-- Q2: How many unique teams participated in the matches?
SELECT COUNT(DISTINCT team1) + COUNT(DISTINCT team2) AS unique_teams 
FROM matches;

-- Q3: How many matches did each team win?
SELECT winner, COUNT(*) AS matches_won 
FROM matches 
GROUP BY winner;

-- Q4: How many matches were played at each venue?
SELECT venue, COUNT(*) AS matches_count 
FROM matches 
GROUP BY venue;

-- Q5: Who won the Player of the Match award the most times?
SELECT player_of_match, COUNT(*) AS awards_count 
FROM matches 
GROUP BY player_of_match 
ORDER BY awards_count DESC 
LIMIT 1;

-- Q6: What is the average total runs scored per match for each season?
SELECT 
    m.season, 
    AVG(match_runs.total_runs) AS average_runs 
FROM 
    matches m
JOIN 
    (SELECT 
         match_id, 
         SUM(batsman_runs) AS total_runs 
     FROM 
         deliveries 
     GROUP BY 
         match_id) AS match_runs
ON 
    m.id = match_runs.match_id
GROUP BY 
    m.season
ORDER BY 
    m.season;

-- Q7: Which team scored the most runs in a single match?
SELECT 
    batting_team, 
    MAX(total_runs) AS highest_score 
FROM 
    (SELECT 
         match_id, 
         SUM(batsman_runs) AS total_runs, 
         batting_team 
     FROM 
         deliveries 
     GROUP BY 
         match_id, batting_team) AS match_totals
GROUP BY 
    batting_team 
ORDER BY 
    highest_score DESC 
LIMIT 1;

-- Q8: How many times has each type of dismissal occurred?
SELECT dismissal_kind, COUNT(*) AS frequency 
FROM deliveries 
WHERE is_wicket = 1 
GROUP BY dismissal_kind 
ORDER BY frequency DESC;

-- Q9: What is the total number of runs scored by each player?
SELECT batter, SUM(batsman_runs) AS total_runs 
FROM deliveries 
GROUP BY batter 
ORDER BY total_runs DESC;

-- Q10: How many matches ended with no result?
SELECT COUNT(*) AS no_result_matches 
FROM matches 
WHERE result = 'no result';

-- Q11: Which team had the best win record in each season (most wins)?
SELECT season, winner, COUNT(*) AS wins
FROM matches
GROUP BY season, winner
HAVING COUNT(*) = (
    SELECT MAX(wins) FROM (
        SELECT winner, COUNT(*) AS wins
        FROM matches
        WHERE season = m.season
        GROUP BY winner
    ) AS season_wins
)
FROM matches m
ORDER BY season;

-- Q12: Compare the top 5 players with the highest runs scored in the first half of matches (first 10 overs).
SELECT batter, SUM(batsman_runs) AS total_runs
FROM deliveries
WHERE over <= 10
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 5;

-- Q13: How many matches were won by teams based on wickets?
SELECT COUNT(*) AS matches_won_by_wickets
FROM matches
WHERE result = 'wickets';

-- Q14: Compare average runs scored in the first 6 overs vs. the last 6 overs.
SELECT 
    AVG(CASE WHEN over <= 6 THEN batsman_runs ELSE 0 END) AS average_powerplay_runs,
    AVG(CASE WHEN over >= 15 THEN batsman_runs ELSE 0 END) AS average_death_runs
FROM deliveries;

-- Q15: What were the top 5 matches with the largest winning margins (runs or wickets)?
SELECT id, season, winner, result_margin
FROM matches
ORDER BY result_margin DESC
LIMIT 5;

-- Comparison of MS Dhoni vs. Virat Kohli

-- 1. Total Runs Scored by Each Player
SELECT 
    'MS Dhoni' AS player,
    SUM(batsman_runs) AS total_runs 
FROM 
    deliveries 
WHERE 
    batter = 'MS Dhoni'
UNION ALL
SELECT 
    'Virat Kohli' AS player,
    SUM(batsman_runs) AS total_runs 
FROM 
    deliveries 
WHERE 
    batter = 'Virat Kohli';

-- 2. Batting Average
SELECT 
    'MS Dhoni' AS player,
    SUM(batsman_runs) / NULLIF(COUNT(CASE WHEN is_wicket = 1 THEN 1 END), 0) AS batting_average 
FROM 
    deliveries 
WHERE 
    batter = 'MS Dhoni'
UNION ALL
SELECT 
    'Virat Kohli' AS player,
    SUM(batsman_runs) / NULLIF(COUNT(CASE WHEN is_wicket = 1 THEN 1 END), 0) AS batting_average 
FROM 
    deliveries 
WHERE 
    batter = 'Virat Kohli';

-- 3. Total Matches Played
SELECT 
    'MS Dhoni' AS player,
    COUNT(DISTINCT match_id) AS matches_played 
FROM 
    deliveries 
WHERE 
    batter = 'MS Dhoni'
UNION ALL
SELECT 
    'Virat Kohli' AS player,
    COUNT(DISTINCT match_id) AS matches_played 
FROM 
    deliveries 
WHERE 
    batter = 'Virat Kohli';

-- 4. Total Sixes Hit
SELECT 
    'MS Dhoni' AS player,
    COUNT(*) AS total_sixes 
FROM 
    deliveries 
WHERE 
    batter = 'MS Dhoni' AND batsman_runs = 6
UNION ALL
SELECT 
    'Virat Kohli' AS player,
    COUNT(*) AS total_sixes 
FROM 
    deliveries 
WHERE 
    batter = 'Virat Kohli' AND batsman_runs = 6;

-- 5. Total Fours Hit
SELECT 
    'MS Dhoni' AS player,
    COUNT(*) AS total_fours 
FROM 
    deliveries 
WHERE 
    batter = 'MS Dhoni' AND batsman_runs = 4
UNION ALL
SELECT 
    'Virat Kohli' AS player,
    COUNT(*) AS total_fours 
FROM 
    deliveries 
WHERE 
    batter = 'Virat Kohli' AND batsman_runs = 4;




