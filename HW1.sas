LIBNAME ORION BASE  "/folders/myfolders/OrionDB";

Question1;

proc sql;
create table sales_department as 
  select Employee_ID, Job_Title, 
         int(('01JAN2015'd-Employee_Hire_Date)/365.25) as Years_at_Orion_Star format=comma6.1, 
         int(('01JAN2015'd-Birth_Date)/365.25) as Age format=comma6.1
  from orion.employee_information
  where Employee_Gender='F' and Department='Sales' and Job_Title<>'Temp. Sales Rep.' and Job_Title<>'Trainee'
  AND Employee_Term_Date is missing;  
quit;

proc sql;
title 'EllieMa';

select Employee_ID 'Employee ID', 
       Job_Title 'Job Title', 
       Years_at_Orion_Star 'Year at Orion Star', 
       Age 'Age'
from WORK.SALES_DEPARTMENT
where Years_at_Orion_Star>10 and Age>40
order by Employee_ID;
quit;

title;

ANSWER;

proc sql;
select Employee_ID, Job_Title 'Job Title', 
       ('01Jan2015'd-Start_Date )/365.25 as tenure 'Years at Orion Star' format=5.1,
       ('01Jan2015'd-Birth_Date )/365.25 as age 'Age' format=5.1
from orion.employee_information
where Department = 'Sales' and 
      Employee_gender='F' and 
      calculated tenure >= 10 and calculated age >= 40 and
      scan(Job_Title,1,' ') <> 'Temp.' and scan(Job_Title,1,' ') <> 'Trainee' and 
      Employee_Term_Date is missing
Order by Employee_ID;
quit;



Question2; 

proc sql;
create table Bonus_1 as 
  select Employee_ID , Salary format=dollar12.2, 
         .030 as Bonus_rate 'Bonus rate' format=comma12.3, 
         Salary*.03 as Bonus format=dollar12.2
  from orion.employee_information
  where Salary>200000;
quit;
proc sql;
create table Bonus_2 as 
  select Employee_ID, Salary format=dollar12.2, 
         .035 as Bonus_rate 'Bonus rate' format=comma12.3, 
         Salary*.035 as Bonus format=dollar12.2
  from orion.employee_information
  where 120000<Salary<=200000;
quit;
proc sql;
create table Bonus_3 as 
  select Employee_ID, Salary format=dollar12.2, 
         .04 as Bonus_rate 'Bonus rate' format=dollar12.2, 
         Salary*.04 as Bonus format=dollar12.2
  from orion.employee_information
  where 70000<Salary<=120000;
quit;
proc sql;
create table Bonus_4 as 
  select Employee_ID, Salary format=dollar12.2, 
         .045 as Bonus_rate 'Bonus rate' format=dollar12.2, 
         Salary*.045 as Bonus format=dollar12.2
  from orion.employee_information
  where 30000<Salary<=70000;
quit;
proc sql;
create table Bonus_5 as 
  select Employee_ID, Salary format=dollar12.2, 
         .05 as Bonus_rate 'Bonus rate' format=dollar12.2, 
         Salary*.05 as Bonus format=dollar12.2
  from orion.employee_information
  where Salary<=30000;
quit;
proc sql;
title 'EllieMa';

select * from WORK.BONUS_1
 union
select * from WORK.BONUS_2
 union
select * from WORK.BONUS_3
 union
select * from WORK.BONUS_4
 union
select * from WORK.BONUS_5
order by Bonus desc;
quit;

title;

ANSWER;
proc sql;
select Employee_ID,Salary 'Salary' format=dollar10.2, 
	case
		when Salary <= 30000 then 0.05
		when 30000 < Salary <= 70000 then 0.045
		when 70000 < Salary <= 120000 then 0.04
		when 120000 < Salary <= 200000 then 0.035
		else 0.03 
	end as bonus_rate 'Bonus rate' format=5.3, 
	calculated bonus_rate*Salary as bonus 'Bonus' format=dollar9.2
from orion.employee_information
where Employee_Term_Date is missing
Order by calculated bonus desc;
quit;


Question3A;

proc sql;
select Hour(start_time) as hour 'Hour', count(trip_id) 'No. of rentals'
   from orion.bikesharing_t3
   where 1 < weekday(start_date) < 7 
   group by calculated hour;
quit;
proc sql;
select Hour(start_time) as hour 'Hour', count(trip_id) 'No. of rentals'
   from orion.bikesharing_t3
   where 1 = weekday(start_date) or weekday(start_date)= 7 
   group by calculated hour;
quit;


Question3B;

proc sql;
title 'EllieMa';

select passholder_type 'passholder type',
       sum(1 <=month(start_date)<= 3)/ count(*) as q1 format=percent6.0 'Jan-Mar',
       sum(4 <=month(start_date)<= 6)/ count(*) as q2 format=percent6.0 'Apr-Jun',
       sum(7 <= month(start_date)<= 9)/count(*) as q3 format=percent6. 'Jul-Sep',
       sum(10 <=month(start_date)<= 12)/ count(*) as q4 format=percent6.0 'Oct-Dec'
from orion.bikesharing_t3
group by passholder_type;
quit;

title;


Question4;

proc sql;
select a.Employee_Name 'Name', 
       sum(o.Total_Retail_Price-o.CostPrice_Per_Unit*o.Quantity) as value 'Total profit' format=dollar9.2
from orion.order_fact as o, 
     orion.employee_information as e, 
     orion.employee_addresses as a
where o.employee_ID=e.employee_ID and o.employee_ID=a.employee_ID and
      year(o.order_date) = 2011 and e.Department = 'Sales'
group by a.Employee_Name
Order by calculated value desc;
quit;



Question5;

proc sql;
title 'EllieMa';

select 
 Customer_ID,
 sum(Total_Retail_Price-CostPrice_Per_Unit*Quantity)/count(DISTINCT(order_ID))
 as Avg_profit format=dollar12.2 'Avg profit per order' 
from orion.order_fact
group by Customer_ID
Having calculated Avg_profit>100;
quit;

title;







 
   









