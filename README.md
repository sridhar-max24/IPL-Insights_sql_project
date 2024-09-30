# IPL-Insights Data Analysis using SQL
![ipl logo](https://images.deccanherald.com/deccanherald%2F2024-03%2Fddd16e79-f241-4a8c-bf06-ac40de765387%2FFsdglE4XsAE3YkJ.jpg?rect=0%2C0%2C2048%2C1152&auto=format%2Ccompress&fmt=webp&fit=max&format=webp&q=70&w=1200&dpr=1.5)

### Overview
IPL Insights is a comprehensive database project that captures the rich history of the Indian Premier League (IPL) from its inception in 2008 to 2024. This project aims to provide in-depth analysis and insights into match statistics, player performances, and team dynamics throughout the seasons.

### Objective
To analyze IPL data to derive insights on team performances, player statistics, and match outcomes, enabling data-driven decision-making for fans and analysts.

### Dataset
The dataset consists of two key tables:

 - **Matches**: Contains details about each match.
 - **Deliveries**: Captures detailed information for each delivery bowled in the matches.

### Dataset Link
dataset link: (https://www.kaggle.com/datasets/patrickb1912/ipl-complete-dataset-20082020).

## Problems and Solutions

### SQL Queries
Here are some of the key SQL queries used to analyze the data:

## Total Matches Played ?
   ```sql
   SELECT COUNT(*) AS total_matches FROM matches;
   ```
## How many matches did each team win?
     ```sql
     SELECT winner, 
     COUNT(*) AS matches_won
     FROM matches
     GROUP BY winner;
     ```
## Who won the Player of the Match award the most times?
     ```sql
     SELECT player_of_match,
     COUNT(*) AS awards_count
     FROM matches
     GROUP BY player_of_match
     ORDER BY awards_count DESC LIMIT 1;
     ```
     
## What is the average total runs scored per match for each season?
     ```sql
     SELECT m.season,
     AVG(match_runs.total_runs) AS average_runs
     FROM matches m
     JOIN (SELECT match_id, SUM(batsman_runs) AS total_runs FROM 
     deliveries GROUP BY match_id) AS match_runs
     ON m.id = match_runs.match_id
     GROUP BY m.season
     ORDER BY m.season;
     ```
     
## Which team scored the most runs in a single match?
     ```sql
     SELECT batting_team,
     MAX(total_runs) AS highest_score
     FROM (SELECT match_id, SUM(batsman_runs) AS total_runs, 
     batting_team FROM deliveries 
     GROUP BY match_id, batting_team) AS match_totals
     GROUP BY batting_team ORDER BY highest_score DESC LIMIT 1;
     ```
     
## How many times has each type of dismissal occurred?
     ```sql
     SELECT dismissal_kind, COUNT(*) AS frequency
     FROM deliveries WHERE is_wicket = 1 
     GROUP BY dismissal_kind ORDER BY frequency DESC;
     ```
   
## What is the total number of runs scored by each player?
     ```sql
     SELECT batter, SUM(batsman_runs) AS total_runs
     FROM deliveries
     GROUP BY batter ORDER BY total_runs DESC;
     ```
     
## How many matches ended with no result?
     ```sql
     SELECT COUNT(*) AS no_result_matches 
     FROM matches 
     WHERE result = 'no result';
     ```
     
 ## Compare average runs scored in the first 6 overs vs. the last 6 overs ?
     ```sql
     SELECT AVG(CASE WHEN over <= 6 THEN batsman_runs ELSE 0 END) AS 
     average_powerplay_runs, AVG;
     ```
     
 ## How many matches were won by teams based on wickets?
     ```sql
     SELECT COUNT(*) AS matches_won_by_wickets
     FROM matches
     WHERE result = 'wickets';
     ```
     
 ## Which team had the best win record in each season (most wins)?
     ```sql
     SELECT season, winner, COUNT(*) AS wins
     FROM matches
     GROUP BY season, winner
     HAVING COUNT(*) = (SELECT MAX(wins) 
     FROM ( SELECT winner, COUNT(*) AS wins FROM matches
     WHERE season = m.season GROUP BY winner ) AS season_wins)
     FROM matches m ORDER BY season;
     ```
   
## Compare the top 5 players with the highest runs scored in the first half of matches (first 10 overs)
     ```sql
     SELECT batter, SUM(batsman_runs) AS total_runs
     FROM deliveries
     WHERE over <= 10
     GROUP BY batter;
     ```
    ORDER BY total_runs DESC LIMIT 5;```
   

