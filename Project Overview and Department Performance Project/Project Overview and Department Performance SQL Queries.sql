/*SKILL USED
* Performed end-to-end data analysis of a project overview dataset to extract employee data, salaries, department budgets, and 
  project details to create a unified and structured data model for analysis using SQL and Power BI.
* Extracted, cleaned, and transformed raw Excel data using SQL and wrote queries to clean, transform, and ensure data accuracy to 
  identify projects and departments at risk of being over budget or underperforming relative to two-year budget cycles.
* Connected SQL queries to Power BI to build an interactive dashboard that visualized project health, departmental performance, 
  salary distribution, and budget utilization for stakeholder decision-making.
*/


--project status
with project_status as(
select 
project_id,
project_name,
project_budget,
'upcoming' as status
from dbo.upcoming_projects
union all
select 
project_id,
project_name,
project_budget,
'completed' as status
from dbo.completed_projects)



--big table
select 
e.employee_id,
e.first_name,
e.last_name,
e.job_title,
e.salary,
d.Department_Name,
pa.project_id,
p.project_name,
p.status
from dbo.employees e
join dbo.departments d
on e.department_id = d.department_id
join dbo.project_assignments pa
on pa.employee_id = e.employee_id
join project_status p

on p.project_id = pa.project_id
