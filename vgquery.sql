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

-- Cleaning PHASE --

-- total rows --
SELECT count(*) 
FROM public.video_game_sales

-- viewing distinct genres --
select distinct genre
from public.video_game_sales

-- number of null values in year column--
select count(*)
from public.video_game_sales
where year is null


select distinct platform
from public.video_game_sales

-- has null values --
select distinct publisher
from public.video_game_sales

-- checking for duplicate values in rank --
select rank
from public.video_game_sales
group by rank
having count(rank) > 1

select Global_Sales
from public.video_game_sales
where Global_Sales is null



-- checking name duplicates --
select name, year, count(name)
from public.video_game_sales
group by name, year
having count(name) > 1

select *
from public.video_game_sales
where year is null

-- updating null year value which is crucial for trend analysis--
UPDATE public.video_game_sales
SET year = 2005
WHERE name = 'Madden NFL 06' AND year IS NULL;

UPDATE public.video_game_sales
SET year = 2003
WHERE name like '%2004%' AND year IS NULL;

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

-- i was able to update 121 rows with this query--
-- other empty year columns are going to be dropped--

delete from public.video_game_sales
where year is null

select *
from public.video_game_sales
where publisher is null

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

-- other rows don't have empty columns this ends the data cleaning/wrangling phase--
