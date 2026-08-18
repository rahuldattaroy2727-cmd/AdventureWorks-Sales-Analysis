/*---------------------------------------------------------
Project: AdventureWorks Sales Analysis
Section: Territory Analysis
Author : Rahul Datta Roy
Started: August 13, 2026

Description:
This script evaluates sales performance across different
territories in the AdventureWorks dataset by analyzing
revenue, customer distribution, order volume, sales
quantity, revenue per customer, average order value,
basket size, and year-over-year territory performance.


Dataset:
AdventureWorks (Kaggle Version)
-----------------------------------------------------------*/
--5. Territory Analysis


----------------------------------------------------------
--Q1. Which territories generate the highest total revenue?
----------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)


select region,
country,
round(sum(revenue),2)revenue
from territory_revenue
group by region,country 
order by sum(revenue)  desc
----------------------------------------------------------------------------
--Insights:
--Australia makes the most revenue that is $7,416,456.24 followed by southwest region of United States that generates 4,822,794.72
--and then Northwest region of USA with 3,095,074.48
--northeast ans central region of USA makes the lowest  revenue that is only 6,401.57 and 3,143.06
-----------------------------------------------------------------------------
--Q2. Which territories have the highest number of customers?
-----------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)


select region ,
count(distinct customerkey)no_of_cx
from territory_revenue
group by Region
order by count(distinct customerkey) desc
---------------------------------------------------------------
--Insights:
--Southwest region of united states have the highest number customer  followed by australia and northwest 
--Whereas Northeast,central and southeast have the lowest 
--It shows that southeast have the biggest customer base however as per revenue genrated southeast stands second after australia.it means 
-- that australia spends a bit more that southeast customers

---------------------------------------------------------------
--Q3. Which territories have the highest number of orders?
---------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)


select region ,
count(distinct ordernumber)no_of_orders
from territory_revenue
group by Region
order by count(distinct ordernumber) desc
------------------------------------------------------------------------
--Insights:
--Australia  have the most orders amongst all the region with 6060 orders , followed by southwest with 4992 and northwest with 3675 orders
--wheres northeast and central have the lowest in the list with only  10 and 9 orders
--even though southeast have 654 customers more than australia as we saw in Q2. still australia have more 1062 orders than southeast region of US
--This solifies our previous conclusion that australians spends a bit more than southeast region

------------------------------------------------------------------------------------------------
--Q4. Which territories sell the highest quantity of products?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)


select region ,
sum(OrderQuantity)no_of_orders
from territory_revenue
group by Region
order by  sum(OrderQuantity) desc
-------------------------------------------------------------------
--Insights:
--Australia ordered the highest quantities of products(17951) follwed by southwest region of US(17191) and then the  Northwest region(12513)

------------------------------------------------------
--Q5. What is the average revenue per customer for each territory?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)


select 
region,
(sum(revenue)/count(distinct customerkey))avg_revenue_per_cx
from  territory_revenue
group by region
order by avg_revenue_per_cx desc
--------------------------------------------------------------------------------
--Insights:
--Australia has the highest average revenue per customer at approximately $2,131,
--followed by the United Kingdom ($1,593) and Germany ($1,507).
--Southwest, despite having one of the largest customer bases, generates only
--$1,167 per customer on average.
--This indicates that Australia's stronger revenue performance is not only driven
--by its customer base, but also by higher revenue generated per customer.
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--Q6. What is the average order value for each territory?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region,
(sum(revenue)/count(distinct ordernumber))avg_order_value
from territory_revenue
group by Region
order by avg_order_value desc
-------------------------------------------------------------------------------------------
--Insights:
--Australia continues to lead the territory analysis with the highest average order value
--of approximately $1,224, followed by Germany ($1,101) and the United Kingdom ($1,047).
--Southwest has a lower average order value of approximately $966 despite having a larger
--customer base.
--Combined with the previous revenue-per-customer analysis, this suggests that Australia's
--strong revenue performance is driven not only by its customer base but also by higher-value
--orders.
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--Q7. What is the average basket size for each territory?
--------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region ,
(sum(OrderQuantity)/count(distinct OrderNumber))as avg_basket_size
from territory_revenue
group by  region
order by avg_basket_size desc
-------------------------------------------------------------------
--Insights:
--Northeast has the highest average basket size at approximately 4 items per order,
--while most territories average around 3 items per order.
--Interestingly, Australia has the lowest average basket size at approximately 2 items
--per order despite leading in total revenue, revenue per customer, and average order value.
--This suggests that Australia's strong average order value is not driven by customers
--purchasing more items per order, but potentially by purchasing higher-priced products.
---------------------------------------------------------------------
--Australian customers appear to favor smaller, higher-value purchases rather than larger baskets, 
--while also placing a relatively high number of orders.

------------------------------------------------------------------------------------
--Q8. Which territories have the highest average item price?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region,
(sum(revenue)/sum(orderquantity))as avg_revenue_peritem
from territory_revenue
group by region 
ORDER BY avg_revenue_peritem desc
--------------------------------------------------------------------------------------------
--Insights:
--Australia has the highest average item price at approximately $413,
--significantly higher than Germany ($318) and Southwest ($281).
--Combined with Australia's lowest average basket size of approximately 2 items per order
--and its high order volume, this suggests that Australian customers tend to make
--smaller but higher-value purchases rather than purchasing large quantities in a single order.
--This purchasing pattern helps explain Australia's strong revenue performance.
----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
--Q9. How does revenue contribution vary across territories?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region ,
sum(revenue)revenue,
(sum(revenue))*100.0/(select sum(revenue) from territory_revenue)revenue_contri_pct
from territory_revenue 
group by region 
order by revenue_contri_pct desc
----------------------------------------------------------------------------------
--Insights:
--Australia contributes the largest share of total revenue at approximately 29.77%,
--followed by Southwest at 19.36% and Northwest at 12.42%.
--Australia alone contributes nearly one-third of the company's total revenue,
--highlighting its importance as the strongest revenue-generating territory.
--The substantial gap between Australia and the other territories indicates a
--high concentration of revenue in the Australian market.
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--Q10. Which territories have a high customer count but relatively low revenue per customer?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region,
count(distinct customerkey)no_of_cx,
(sum(revenue)/count(distinct customerkey))rev_per_cx,
dense_rank()over(order by count(distinct customerkey) desc)customers_rank,
DENSE_RANK()over(order by sum(revenue)/count(distinct customerkey)desc )rev_per_cxrank
from territory_revenue
group by Region
order by no_of_cx desc,rev_per_cx asc
----------------------------------------
--Ranking Methodology:
--Both the metrics that is customer count rank and revenue per customer rank is  from highest to lowest 
---------------------------------------------------------------------------------------
--Insights:
--Southwest has the highest customer count with 4,134 customers, ranking 1st in customer
--count, but ranks only 6th in revenue per customer at approximately $1,167.
--Northwest also has a relatively large customer base of 3,075 customers, ranking 3rd,
--but ranks only 8th in revenue per customer at approximately $1,007.
--This indicates that Southwest and Northwest have strong customer bases but relatively
--weak revenue generation compared with territories such as Australia and the United Kingdom.
---------------------------------------------------------------------------------------------
--Q11. Which territories have a low customer count but relatively high revenue per customer?
---------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region,
count(distinct customerkey)no_of_cx,
(sum(revenue)/count(distinct customerkey))rev_per_cx,
dense_rank()over(order by count(distinct customerkey) desc)customers_rank,
DENSE_RANK()over(order by sum(revenue)/count(distinct customerkey)desc )rev_per_cxrank
from territory_revenue
group by Region
order by no_of_cx asc ,rev_per_cx desc


---------------------------------------------------------------------------------------
---Q12. How does territory revenue performance change year over year?
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

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
datepart(year,orderdate) as years,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)


, territory_yearwise_rev as
(
SELECT region,
sum(revenue_2020)as total_rev_2020,
sum(revenue_2021)total_rev_2021,
sum(revenue_2022)total_rev_2022
from
(
select region,
(case when years = 2020 then revenue end )as revenue_2020,
(case when years = 2021 then revenue end )as revenue_2021,
(case when years = 2022 then revenue end )as revenue_2022
from territory_revenue 
)t
GROUP BY region
)

select region ,
 round((total_rev_2021 - total_rev_2020),2)growth2020_2021,
 round(((total_rev_2021 - total_rev_2020)*100.0/total_rev_2020),2)growth_pct_20_21,
 (case when total_rev_2021 > total_rev_2020 then 'Increased'
       when total_rev_2021 = total_rev_2020  then 'Stayed same'
       when total_rev_2020 is null then 'No 2020 data' else 'Decreased'end )as trend_20_21,
round((total_rev_2022-total_rev_2021),2)growth2021_2022,
round(((total_rev_2022 - total_rev_2021)*100.0/total_rev_2021),2)growth_pct_21_22,
(case when total_rev_2022 > total_rev_2021 then 'Increased'
       when total_rev_2022 = total_rev_2021  then 'Stayed same' 
       when total_rev_2021 is null then 'No 2021 data' else 'Decreased'end )as trend_21_22
from territory_yearwise_rev
---------------------------------------------------------------------------------------
--Insights:
--Southeast showed the strongest revenue growth across both periods,
--increasing by 321.33% from 2020 to 2021 and by a further 169.60% from 2021 to 2022.
--
--Southwest and Northwest demonstrated consistent positive revenue growth
--across both periods, indicating a stable upward trend.
--
--Germany, Australia, the United Kingdom and France experienced strong revenue
--growth from 2020 to 2021, but most of them saw slower growth or a decline
--from 2021 to 2022.
--
--Canada declined by 14.71% from 2020 to 2021 but recovered with a 22.55%
--increase from 2021 to 2022.
--
--Overall, Southeast recorded the most significant growth, while Southwest
--and Northwest showed the most consistent year-over-year growth.
----------------------------------------------------------------------------
--Q13. Which territory represents the strongest growth opportunity based on revenue, customers, and revenue per customer?
--------------------------------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, territory_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
ordernumber,
datepart(year,orderdate) as years,
orderquantity,
productprice,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey)

select region,
sum(revenue) revenue,
count(distinct customerkey) no_of_cx,
(sum(revenue)/count(distinct customerkey))revnue_per_cx
from territory_revenue
group by region
order by no_of_cx desc ,revnue_per_cx asc ,revenue asc 
---------------------------------------------------------------------------------------
--Insights:
--Northwest has the strongest growth opportunity, with a large customer base but
--comparatively low revenue per customer, while Southwest has the largest customer
--base and Australia has the highest revenue and revenue per customer.
----------------------------------------------------------------------------------------