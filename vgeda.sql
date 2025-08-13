-- EDA PHASE --

-- TREND ANALYSIS --

-- (Yearly trends) --
-- NUMBER OF GAMES RELEASED EACH YEAR --
select year, count(*) as total_games
from public.video_game_sales
group by year
order by year asc

-- sales trends over time
select year, sum(Global_sales) as total_sales
from public.video_game_sales
group by year
order by year asc 


-- GENRE ANALYSIS --
-- top selling genre -- 
select genre, sum(Global_sales) as total_sales
from public.video_game_sales
group by genre
order by total_sales desc 

-- top genre by year based on sales popularity by years --
-- cte to rank top selling games by year and the genre they belong to --
with cte as (
Select year, genre, SUM(Global_Sales) AS total_sales,
dense_rank() 
over(partition by year order by SUM(Global_Sales) desc) as rnk
FROM public.video_game_sales
GROUP BY year, genre
ORDER By genre, total_sales DESC
)

select year, genre, total_sales, rnk
from cte
where rnk = 1
group by year, genre, total_sales, rnk
order by year

-- best selling platforms --
SELECT Platform, SUM(Global_Sales) AS total_sales
FROM public.video_game_sales
GROUP BY Platform
ORDER BY total_sales DESC;

--platform lifespan --
SELECT Platform,
       MIN(Year) AS first_year,
       MAX(Year) AS last_year
FROM public.video_game_sales
GROUP BY Platform
ORDER BY first_year;

-- PUBLISHER PERFORMANCE --
--top publishers by total sales --
SELECT Publisher, SUM(Global_Sales) AS total_sales
FROM public.video_game_sales
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY total_sales DESC
LIMIT 10;

--publishers with most game titles
SELECT Publisher, COUNT(*) AS total_games
FROM public.video_game_sales
WHERE Publisher IS NOT NULL
GROUP BY Publisher
ORDER BY total_games DESC
LIMIT 10;

-- REGIONAL INSIGHTS --

--regional sales breakdown--
SELECT
    SUM(NA_Sales) AS na_sales,
    SUM(EU_Sales) AS eu_sales,
    SUM(JP_Sales) AS jp_sales,
    SUM(Other_Sales) AS other_sales
FROM public.video_game_sales;

-- this query shows North America is the largest gaming market


-- top regions per genre --
SELECT Genre,
       CASE 
           WHEN SUM(NA_Sales) >= GREATEST(SUM(NA_Sales), SUM(EU_Sales), SUM(JP_Sales), SUM(Other_Sales)) THEN 'NA'
           WHEN SUM(EU_Sales) >= GREATEST(SUM(NA_Sales), SUM(EU_Sales), SUM(JP_Sales), SUM(Other_Sales)) THEN 'EU'
           WHEN SUM(JP_Sales) >= GREATEST(SUM(NA_Sales), SUM(EU_Sales), SUM(JP_Sales), SUM(Other_Sales)) THEN 'JP'
           ELSE 'Other'
       END AS best_region
FROM public.video_game_sales 
GROUP BY Genre;

-- Next Analysis is Market Share --











