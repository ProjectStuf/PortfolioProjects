/*SKILL USED
* Conducted end-to-end data analysis of a bike share dataset to evaluate company performance, 
  rider demographic, and usage trends using SQL and Power BI. 
* Imported Excel data into SQL and wrote queries to polish, alter, and aggregate trip and usage data and used SQL to 
  calculate key metrics such as rider type distribution, peak usage periods, and revenue by season. 
* Joined SQL queries to Power BI to build an interactive dashboard for stakeholder reporting and designed 
  visualizations to communicate insights related to operational performance, demand patterns, and rider behavior.
*/


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
