# Nintendo Market Analysis

## 📌 Project Overview
This project investigates why Nintendo’s global market share fluctuated between 2010–2016, identifies top-performing genres and regions, and builds predictive models to forecast sales and regional performance. It culminates in specific, actionable recommendations to grow market share.
----

## 📊 Dataset
That data set was sourced from [`Kaggle`](https://www.kaggle.com/datasets/sheemazain/video-game-sales-by-sheema-zain) with the following columns:

- Rank: The ranking of the game based on total global sales.
- Name: The title of the video game.
- Platform: The gaming system the game was released on (e.g., PlayStation, Xbox, Nintendo Switch, PC).
- Year_of_Release: The year the game was released.
- Genre: The category of the game (e.g., Action, Sports, RPG, Shooter).
- Publisher: The company responsible for publishing the game (e.g., Nintendo, Electronic Arts, Activision).
Sales figures are often segmented by region in millions of units: 7. NA_Sales: Sales in North America.
-EU_Sales: Sales in Europe.
- JP_Sales: Sales in Japan.
- Other_Sales: Sales in the rest of the world.****
- Global_Sales: Total worldwide sales (sum of all regions).

### 🗂️ Data Quality and Preparation Process
The csv file was imported in Postgres Admin after creating a Sales database, with a table being creaated to store the valeues.

```
-- This SQL statement creates a new table to store video game sales data.
CREATE TABLE video_game_sales (
    -- The primary key for the table. It stores the game's rank as an integer.
    Rank INT PRIMARY KEY,

    -- The name of the game. VARCHAR(255) is used to accommodate various title lengths.
    Name VARCHAR(255) NULL,

    -- The gaming platform (e.g., 'Wii', 'NES'). VARCHAR(50) should be sufficient.
    Platform VARCHAR(50) NULL,

    -- The year the game was released. INT is used for the year value.
    Year INT NULL,

    -- The genre of the game. VARCHAR(50) is used to store values like 'Sports' or 'Platform'.
    Genre VARCHAR(50) NULL,

    -- The publisher of the game. VARCHAR(255) is used for the company name.
    Publisher VARCHAR(255) NULL,

    -- North American sales in millions. DECIMAL(10, 2) allows for up to 10 total digits with 2 decimal places.
    NA_Sales DECIMAL(10, 2) NULL,

    -- European sales in millions.
    EU_Sales DECIMAL(10, 2) NULL,

    -- Japanese sales in millions.
    JP_Sales DECIMAL(10, 2) NULL,

    -- Other regional sales in millions.
    Other_Sales DECIMAL(10, 2) NULL,

    -- Global sales in millions.
    Global_Sales DECIMAL(10, 2) NULL
);

```


Since the data set was very large with over 16000 rows; it was checked for duplicates and nulls values. 

```
-- checking name duplicates --
select name, year, count(name)
from public.video_game_sales
group by name, year
having count(name) > 1
```

1. Trend analysis was crucial so it was essential to check for null values in the `Year` column. Duplicate game titles with missing null values were filled by a self join process to fill in the years.

```
-- using self join to find games that dropped the same year and updates the null values--
UPDATE public.video_game_sales AS g1
SET year = g2.known_year
FROM (
    SELECT 
        name, 
        MAX(year) AS known_year
    FROM public.video_game_sales
    WHERE year IS NOT NULL
    GROUP BY name
) AS g2
WHERE g1.name = g2.name AND g1.year IS NULL;
```
About 120 rows were updated through this process. the other few remaining null rows were deleted.

2. The same process was repeated for Publishers with null values with the remaining null values being set to unknown.
```
--finding similar publishers from games with missing values to grab publishers from other rows with same name--
UPDATE public.video_game_sales AS g1
SET publisher = g2.known_pub
FROM (
    SELECT
        name,
        MAX(publisher) AS known_pub
    FROM public.video_game_sales
    WHERE publisher IS NOT NULL
    GROUP BY name
) AS g2
WHERE g1.name = g2.name AND g1.publisher IS NULL;

-- the other 35 row are going to be set to unknown --
update public.video_game_sales
set publisher = 'Unknown'
where publisher is null;
```

- After completing cleaning the dataset the cleaned data sat was downloaded as a csv file for further analysis on python and predictive modelling



----
## 📌 Executive Summary

Context: EDA confirms fluctuating global market share for Nintendo from 2010–2016. Additionally,the most profitable markets for the publisher during that time period are North America, Japan, then Europe. Further insights are needed to diagnose the causes of this and the quality of the data for predictive modelling.

Focus Areas and Outcomes:

* Diagnose drivers of market share swings (titles, platform lifecycle, genre mix).

* Forecast global & regional sales.

* Predict regional performance for genres.

* Recommend levers to stabilize & grow market share.

## 🔍 Business Goals & Questions

Primary Goal: Improve Nintendo’s worldwide market share by prioritizing regions, genres, that maximize ROI.

Key Questions

1. How has Nintendo’s market share evolved annually since 2010, and what explains volatility?

2. Which genres (top 3 annually) drove outsized performance across 2010–2016?

3. Which regions (NA, JP, EU, Other) contribute most to sales, and where are the growth opportunities?

4. What is the forecast for total sales and regional sales over the next 3 years?

5. Given a future title’s attributes (platform, genre), what is its expected regional performance?

6. Which levers (genre mix, portfolio allocation) increase market share?

KPIs

* Global & regional unit sales (M).

* Annual market share (% of global industry sales).

* Title-level first-year sales (k units).

* Genre mix contribution (%) and ROI proxy.

----

















```
Author: Kwasi Dankwa
Role: Business Analyst
Nintendo (Portfolio Project)
Tech: SQL(PostGresAdmin), Python (pandas, scikit-learn), Jupyter, Views, Tableau
Business Window: 2010–2016
```
