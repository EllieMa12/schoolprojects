LIBNAME ORION BASE "/folders/myfolders/OrionDB";

Question1 (a);

proc sql;
title 'EllieMa';

select 
  sum(case when int(('01JAN2015'd-Birth_Date)/365.25)< 50 then Salary else 0 end)/ sum(case when int(('01JAN2015'd-Birth_Date)/365.25)< 50 then 1 else 0 end) as under 'Under 50' format=dollar10.2,
  sum(case when int(('01JAN2015'd-Birth_Date)/365.25)>= 50 then Salary else 0 end)/sum(case when int(('01JAN2015'd-Birth_Date)/365.25)>= 50 then 1 else 0 end) as over 'Over 50' format=dollar10.2
from orion.employee_information
where Employee_Term_Date is NULL;
quit;

title;


Question1 (b);
proc sql;
title 'EllieMa';

select avg(u.over_u) as U 'Under 50' format= dollar10.2,
      (select avg(o.over_o) 
         from 
             (select Salary as over_o, avg(Salary) as avg_over
                from orion.employee_information
                  where Employee_Term_Date is NULL and
                        int(('01JAN2015'd- Birth_Date)/ 365.25) >=50) as o
         where o.over_o> o.avg_over) as O 'Over 50' format= dollar10.2
from 
    (select Salary as over_u, avg(Salary) as avg_under
       from orion.employee_information
         where Employee_Term_Date is NULL and
               int(('01JAN2015'd- Birth_Date)/ 365.25) <50) as u
where u.over_u> u.avg_under;
quit;

title;


/For verifying if the results of the query above are correct/;

proc sql;
title 'EllieMa';

select 
sum(case when int(('01JAN2015'd-Birth_Date)/365.25)< 50 and Salary>41582.74 then Salary else 0 end)/ sum(case when int(('01JAN2015'd-Birth_Date)/365.25)< 50 and Salary>41582.74 then 1 else 0 end) as under 'Under 50' format=dollar10.2,
sum(case when int(('01JAN2015'd-Birth_Date)/365.25)>= 50 and Salary>38176.80 then Salary else 0 end)/sum(case when int(('01JAN2015'd-Birth_Date)/365.25)>= 50 and Salary>38176.80 then 1 else 0 end) as over 'Over 50' format=dollar10.2
from orion.employee_information
where Employee_Term_Date is Null;
quit;

title;


                                                                                                                                                               
Question2;

proc sql;
title 'EllieMa';

select avg(m.diff_M) as M 'Avg Salary Differential for Male' format= dollar10.2,
   (select avg(f.diff_F) 
      from 
          (select (Salary-avg(Salary)) as diff_F
             from orion.employee_information
               where Employee_Term_Date is NULL and
                     Employee_Gender= 'F') as f
      where f.diff_F> 0) as F 'Avg Salary Differential for Female' format= dollar10.2
from 
    (select (Salary-avg(Salary)) as diff_M
       from orion.employee_information
         where Employee_Term_Date is NULL and
               Employee_Gender= 'M') as m
where m.diff_M> 0;
quit;

title;


/For verifying whether the results of the query above are correct/;

proc sql;
title 'EllieMa';

select avg(av.diff_M) 'Avg Salary Differential for Male' format=dollar10.2
       
from 
     (select (Salary-avg(Salary)) as diff_M
      from orion.employee_information
      where Employee_Term_Date is Null and Employee_Gender='M') as av
where av.diff_M >0;
quit;

title;

proc sql;
title 'EllieMa';

select avg(av.diff_F) 'Avg Salary Differential for Female' format=dollar10.2

from 
  (select (Salary-avg(Salary)) as diff_F
   from orion.employee_information
   where Employee_Term_Date is Null and Employee_Gender= 'F') as av
where av.diff_F>0;
quit;

title;



Question3;

proc sql;
title 'EllieMa';

select distinct ei.Manager_ID 'Manager ID',
       sum(.05*pt.TP) as Commission 'Commission' format= dollar9.2     
from orion.employee_information as ei

    inner join
    
       (select distinct of.Employee_ID,
               sum(of.Total_Retail_Price- of.Quantity* of.CostPrice_Per_Unit) as TP  
           from orion.order_fact as of
        inner join
             orion.product_dim as pd
        on (of.Product_ID= pd.Product_ID)
        where 
           year(of.Order_Date)= 2011 and
           pd.Supplier_Name contains'3Top Sports' and
           of.Employee_ID ne 99999999
        group by Employee_ID) as pt
           
    on (ei.Employee_ID= pt.Employee_ID)
    
where ei.Employee_Term_Date is NULL
group by  ei.Manager_ID
order by calculated Commission desc;
quit;

title;



Question4;

proc sql;
title 'EllieMa';

select id.Customer_ID 'Customer ID',
       Customer_Name 'Customer Name'
from 
     (select distinct a.Customer_ID
         from orion.order_fact as a
     inner join
        (select distinct b.Customer_ID 
            from orion.order_fact as b 
               where 240000000000 <b.Product_ID< 240999999999
               group by b.Customer_ID
               having count(distinct b.Order_ID)> 1)as c
      on (a.Customer_ID= c.Customer_ID)
      where 220000000000 <a.Product_ID< 220999999999
      group by a.Customer_ID
      having count(distinct a.Order_ID)>1 ) as id
  inner join 
    orion.customer as ct 
    on (id.Customer_ID= ct.Customer_ID);
quit;

title;


    






















