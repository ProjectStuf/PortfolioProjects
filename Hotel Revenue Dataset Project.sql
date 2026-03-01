/* This section is to join all the tables into one to create a full sorted dataset containing all important 
information in order to import the dataset into Power BI to create a visual dashboard showing everything for the stakeholders */

with hotels as (
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$'])

select * from hotels
left join dbo.market_segment$
on hotels.market_segment = market_segment$.market_segment 
left join dbo.meal_cost$
on meal_cost$.meal = hotels.meal



/* practice stakeholder questions
"Is our hotel revenue growing by year"
We have 2 hotel types so it would be good to segment revenue by hotel type

"Should we increase our parking lot size?"
We want to understand if there is a trend in guests with personal cars

"What trends can we see in the data?"
Focus on average daily rate and guests to explore seasonality
*/




/* This section is to get a very simple estimate of the revenue from both hotels through out the 3 years 2018, 2019, and 2020, 
and it can also technically answer the 1st question of "Is our hotel revenue growing by year" which is Yes, the hotel revenue is growing by year, with the exception of 2020 because of covid-19*/

with hotels as (
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$'])

select 
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue 
from hotels
group by arrival_date_year,hotel
