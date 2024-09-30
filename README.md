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
You can access the dataset (https://www.kaggle.com/datasets/patrickb1912/ipl-complete-dataset-20082020).

## Problems and Solutions

### SQL Queries
Here are some of the key SQL queries used to analyze the data:

1. **Total Matches Played**
   ```sql
   SELECT COUNT(*) AS total_matches FROM matches;
   ```
