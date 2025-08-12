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

-- EDA PHASE --

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



-- next step will involve cleaning data --