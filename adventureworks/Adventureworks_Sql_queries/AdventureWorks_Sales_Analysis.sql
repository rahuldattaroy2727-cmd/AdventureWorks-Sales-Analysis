
/*---------------------------------------------------------
Project: AdventureWorks Sales Analysis
Section: Sales Performance Analysis
Author : Rahul Datta Roy
Started: August 6, 2026

Description:
This script analyzes the overall sales performance of the
AdventureWorks dataset, including revenue trends, order
metrics, seasonal analysis, YoY growth, rolling averages,
and business KPIs.

Dataset:
AdventureWorks (Kaggle Version)
---------------------------------------------------------*/


-------------------------------------------------------------
--2. Sales Performance Analysis
----Now we start answering business questions.
-------------------------------------------------------------
--Q1.What is the total revenue generated?
-------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)
--------------------------------------------------------------------------------------------------
---------------------------Made a CTE for revenue so that i can use if needed---------------------
-------------------------------------------------------------------------------------------------
,sales_revenue as
(
select 
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)
---------------------------------------------------------------------------------------------------
SELECT round(sum(revenue),2)as total_revenue
from sales_revenue

---------------------------------------------------------------------------------------
--Q2.How many total orders were placed?-----------------------------------------------
---------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

select 
count(distinct orderNumber)as total_orders
from full_sales_table

-------------------------------------------------------------------------------------------
--Q3.What is the average order value?----------------------------------------------------
-------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as
(
select 
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

select round(sum(revenue)/(select count(distinct ordernumber) from full_sales_table),2) as Avg_order_value
from sales_revenue

----------------------------------------------------------------------
--What is the average revenue generated per customer?-----------------
----------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

select round(sum(revenue)/(select count(distinct customerkey)from customers),2)as Avg_revenue_per_cx
from  sales_revenue

----------------------------------------------------------------------
--What is the monthly sales trend + MOM growth?------------------------------------
----------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
month(orderdate) as month,
round(sum(revenue),2)as monthly_revenue
from sales_revenue
group by month(orderdate),year(orderdate)

)

select *,
lag(monthly_revenue)over(order by year,month)as previous_month_revenue,
(monthly_revenue - lag(monthly_revenue)over(order by year,month)) as growth,
(((monthly_revenue - lag(monthly_revenue)over(order by year,month)) /(lag(monthly_revenue)over(order by year,month))*100))  as growth_pct
from ini_trend

-- we can see on most months there are some considerable growth .
-----------------------------------------------------------------------------------------------------------
--Q6.What is the yearly sales trend + YOY growth?-----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

-------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
round(sum(revenue),2)as yearly_revenue
from sales_revenue
group by year(orderdate)
)

select *,
lag(yearly_revenue)over(order by year)as previous_year_revenue,
(yearly_revenue - lag(yearly_revenue)over(order by year)) as growth,
((yearly_revenue - lag(yearly_revenue)over(order by year)) /(lag(yearly_revenue)over(order by year))*100)  as growth_pct
from ini_trend

---2021 saw a rise of 45% growth however there a small dip of 1.4% in 2022


----------------------------------------------------------------------------------------------------
--Q7.Which month recorded the highest revenue?---------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
month(orderdate) as month,
round(sum(revenue),2)as monthly_revenue
from sales_revenue
group by month(orderdate),year(orderdate)

)

select top 1 year,
month, 
monthly_revenue
from ini_trend
order by monthly_revenue desc                  --june 2022 recorded the highest revenue
--------------------------------------------------------------------------------------------------
--Q8.Which year generated the highest revenue?---------------------------------------------------
--------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
round(sum(revenue),2)as yearly_revenue
from sales_revenue
group by year(orderdate)
)

select top 1 year,
yearly_revenue
from ini_trend
order by yearly_revenue desc                   ---year 2021 generated the highest revenue which is 9324203.83
--------------------------------------------------------------------
--Q9.Which days of the week generate the highest sales?----------------
--------------------------------------------------------------------

with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_Week_trend as(
select Datename(WEEKDAY,orderdate)as weekday,
round(sum(revenue),2)as weekday_revenue
from sales_revenue
group by Datename(WEEKDAY,orderdate)
)

select top 1  *
from ini_Week_trend 
ORDER BY   weekday_revenue  desc  --Tuesday generated the highest revenue 	3650911.99.

------------------------------------------------------------------------------------------------
--Q10.Which quarter contributes the most revenue?

with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_quater_trend as(
select DATEPART(QUARTER,orderdate)as quater,
round(sum(revenue),2)as quaterly_revenue
from sales_revenue
group by Datepart(QUARTER,orderdate)
)

select top 1 *
from ini_quater_trend  
order by quaterly_revenue desc ------------------------------------ 2nd quater generated the highest revenue overall

---------------------------------------------------------------------------
--Q11.What percentage of total revenue does each year contribute?----------
---------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
round(sum(revenue),2)as yearly_revenue
from sales_revenue
group by year(orderdate)
)

select year,
yearly_revenue,
(select sum(revenue)from sales_revenue)as total_revenue,
round(((yearly_revenue/(select sum(revenue)from sales_revenue))*100),2)as revenue_pct
from ini_trend    

-- Insight:
-- 2021 given the highest revenue percent of 37.42 follwed by 2022 with 36.87 where 2020 have only given 25.71
-- 2022 seems to outperform 2021 considering  we only have 6 months of data(2022)for analysis

-----------------------------------------------------------------------------------------------
--Q12.Calculate the cumulative (running) revenue over time.------------------------------------
-----------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
month(orderdate) as month,
round(sum(revenue),2)as monthly_revenue
from sales_revenue
group by month(orderdate),year(orderdate)

)

select * ,
round(sum(monthly_revenue)over(ORDER BY year,month),2) as Cumsum
from ini_trend
order by year,month
----------------------------------------------------------------------------------
--Q13.Calculate the rolling 3-month average sales.--------------------------------
----------------------------------------------------------------------------------

with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
month(orderdate) as month,
round(sum(revenue),2)as monthly_revenue
from sales_revenue
group by month(orderdate),year(orderdate)

)

select * ,
round(avg(monthly_revenue)over(ORDER BY year,month rows between  2  preceding and current row),2) as Last_3month_avg
from ini_trend
order by year,month
--------------------------------------------------------------------------------------------------------------------
--Q14.Which months consistently underperform compared to the yearly average?----------------------------------------
--------------------------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
datename(month,orderdate) as month,
round(sum(revenue),2)as monthly_revenue
from sales_revenue
group by datename(month,orderdate),year(orderdate)

)
select month,
count(*) as No_of_times_below_yearly_avg
from
(
select * ,
avg(monthly_revenue)over(partition by year)as yearly_avg
from ini_trend

)t
where monthly_revenue < yearly_avg
group by month
order by count(*) desc
--------------------------------------
--Insights:
--February is the biggest underperformer as it constantly underperformed for  each and every year . it show that sales is doen these
--months,followed by january, march ,april
-------------------------------------------------------------------------------------------------
--Q15.Find the highest single-day sales.---------------------------------------------------------
-------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

select  top 1 OrderDate,
round(sum(revenue),2) revenue_achieved
from sales_revenue
group by OrderDate
order by sum(revenue) desc

-- Insight:
-- The highest single-day sales occurred on 2022-03-01,
-- generating a revenue of $111,978.67.
-------------------------------------------------------------------------------------------------
--Q16.Which season (Spring, Summer, Autumn, Winter) generates the highest revenue?---------------
-------------------------------------------------------------------------------------------------


with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
datename(month,orderdate) as month,
round(sum(revenue),2)as monthly_revenue
from sales_revenue
group by datename(month,orderdate),year(orderdate)
)

select top 1 seasons,
round(sum(monthly_revenue),2)as seasonal_revenue
from
(
select *,
case when month in ('March','April','May') then 'Spring'
     when month in ('June','July','August') then 'Summer'
     when month in ('September','October','November') then 'Autumn'
     else 'winter' end as Seasons
from ini_trend
)t  
group by seasons
order by sum(monthly_revenue) desc

-- Insight:
-- Spring generated the highest seasonal revenue
-- ($8,213,422.46) among all four seasons.
------------------------------------------------------------------------------------------------ 
--Q17.What is the average number of products sold per order?------------------------------------
------------------------------------------------------------------------------------------------

with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f                           
join products p   
on f.productkey = p.productkey)



select avg(no_of_items)Avg_qantities_per_order
FROM(
select ordernumber,
sum(OrderQuantity) no_of_items
from sales_revenue
group by OrderNumber
)t

------------------------------------------------------------------------------------
--Q18.Rank the years based on total revenue.----------------------------------------
------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ordernumber,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

, ini_trend as(
select year(orderdate)as year,
round(sum(revenue),2)as yearly_revenue
from sales_revenue
group by year(orderdate)
)

select year,
yearly_revenue,
dense_rank()over( order by yearly_revenue desc)as rank,
round(((yearly_revenue/(select sum(revenue)from sales_revenue))*100),2)as revenue_pct
from ini_trend  