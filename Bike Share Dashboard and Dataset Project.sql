/*creating a CTE to join all the tables into one to create a dataset containing all important information*/

with cte /*common table expression*/ as (
select * from dbo.bike_share_yr_0
union all
select * from dbo.bike_share_yr_1)


/*the SQL code that is used to import all the relevant information needed for the Power BI dashboard*/

select 
dteday,
season,
A.yr,
weekday,
hr,
rider_type,
riders,
price,
COGS, /*cost of goods*/
riders*price as revenue,
riders*price - COGS as profit
from cte A /*common table expression*/
left join dbo.cost_table B
on A.yr = B.yr