/*---------------------------------------------------------
Project: AdventureWorks Sales Analysis
Section: Customer Analysis
Author : Rahul Datta Roy
Started: August 12, 2026


Description:
This script evaluates customer performance across the
AdventureWorks dataset by analyzing customer revenue,
sales volume, purchasing behavior, customer contribution,
order frequency, customer value, and other key
customer-related business insights.

Dataset:
AdventureWorks (Kaggle Version)
---------------------------------------------------------*/
----------------------------------------------------------------------------------------------------
----------------------------------------------------------
-- 4. Customer Analysis-----------------------------------
----------------------------------------------------------
--Q1. How many customers made at least one purchase?
---------------------------------------------------------

with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

SELECT count(distinct CustomerKey)no_of_customers
from full_sales_table
----------------------------------------------------------
--Q2. Which customers generated the highest revenue?------
-----------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)



select top 10 firstname,
lastname,
sum(revenue)cx_revenue_contribution
from customer_sales_revenue
group by  firstname,lastname
order by sum(revenue) desc
-------------------------------------------------------------------------
-- Insights:
-- Jordan Turner generated the highest total revenue among all customers,
-- making him the highest-value customer in terms of revenue contribution.

-- Maurice Shan and Janet Munoz followed closely, indicating that a small
-- group of customers contributes a significant share of the overall revenue.

-- The top customers consistently generated over $10,000 in revenue, which
-- suggests that these customers are highly valuable to the business and
-- should be prioritized for retention through personalized offers,
-- loyalty programs, or targeted marketing campaigns.
------------------------------------------------------------------------------
--Q3. What is the average revenue per customer?
------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


SELECT
avg(cx_revenue_contribution)avg_revenue_per_cx
from
(
select customerkey,
sum(revenue)cx_revenue_contribution
from customer_sales_revenue
group by  customerkey
)t
-----------------------------------------------------------------------
-- Insights:
-- The average revenue generated per customer is approximately 1,436.58
-- across the analyzed period.

-- This indicates that the average customer contributes around 1.44K
-- in revenue, providing a useful benchmark for evaluating individual
-- customer performance.

-- Customers generating revenue significantly above this benchmark can
-- be considered higher-value customers and may be prioritized for
-- retention and targeted marketing initiatives.
-----------------------------------------------------------------------
--Q4. Which customer placed the most orders?
-----------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
f.ordernumber,
orderquantity,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)

select CustomerKey,
firstname,
lastname,
count(distinct ordernumber)
from customer_sales_revenue
group by customerkey,firstname,lastname
order  by count(distinct ordernumber) desc
-- Insights:
-- Dalton Perez, Hailey Patterson, Fernando Barnes, Ryan Thompson, and
-- Samantha Jenkins have the highest purchase frequency, with 26 distinct
-- orders each during the analyzed period.

-- Jason Griffin and Ashley Henderson follow closely with 25 orders each,
-- while Mason Roberts and Henry Garcia placed 24 orders each.  

-- The highest-frequency customers placed 26 distinct orders during the
-- analyzed period, indicating a strong and consistent purchasing pattern.

-- Several customers share the highest order frequency, suggesting that
-- customer loyalty is not concentrated in a single individual.

-- Customers with 24–26 orders can be considered highly engaged customers
-- and may be valuable targets for retention programs, loyalty rewards,
-- and personalized offers.

--------------------------------------------------------------------------
--Q5. Which customers purchased the highest quantity of products?
--------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
f.ordernumber,
f.orderquantity,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)

select CustomerKey,
firstname,
lastname,
sum(orderquantity)number_of_quantities
from customer_sales_revenue
group by customerkey,firstname,lastname
order  by sum(OrderQuantity) desc
-- Insights:
-- Jennifer Simmons and Fernando Barnes purchased the highest quantity,
-- with 106 products each.

-- Samantha Jenkins, Ashley Henderson, and April Shan also show high
-- purchase volumes, ranging from 99 to 102 products.

-- The results highlight highly engaged customers who may be suitable
--------------------------------------------------------------------------
--Q6. Rank customers based on revenue.
--------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


select top 10 firstname,
lastname,
sum(revenue)cx_revenue_contribution,
dense_rank()over(order by sum(revenue) desc )
from customer_sales_revenue
group by  firstname,lastname

-------------------------------------------------------------------
--Insights:
--JORDAN TURNER  ranked 1 as the person with most revenue followed by Maurice shan and Janet Munoz
-------------------------------------------------------------------------------------------------
--Q7. Which customers made purchases in all available years?-------------------------------------
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

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
orderquantity,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)

select customerkey,
firstname,
lastname,
count(distinct years)no_of_years_ordered
from customer_sales_revenue
group by customerkey,firstname,lastname
having count(distinct years) = (select count( distinct years)from customer_sales_revenue )  
------------------------------------------------------------------------------------------
--Q8. What is the average order value for each customer?
------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)
----optional use  to check  why this amount $3578.27001953125 is shared by multiple customer having as average order  value also just have only one orders 
--upon checking found out  the bought the variants of Road-150 Red
--SELECT
--productname,
-- productprice
--FROM customer_sales_revenue
--WHERE revenue = 3578.27001953125
--GROUP BY productname, productprice



select customerkey,
firstname,
lastname,
sum(revenue)as revenue_per_cx,
count(distinct ordernumber)as total_order_per_cx,
((sum(revenue))/count(distinct ordernumber))revenue_per_order
from  customer_sales_revenue
group by customerkey,firstname,lastname
order by revenue_per_order desc
-- Insights:
-- The highest average order value is ₹3,578.27, shared by several
-- one-time customers. This is driven by purchases of the high-value
-- Road-150 Red variants, which all carry the same product price.
-----------------------------------------------------------------------------
--Q9. Which occupation generates the highest revenue?
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

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


select occupation,
round(sum(revenue),2)as revenue
from customer_sales_revenue
group by Occupation
order by sum(revenue) desc
------------------------------------------------------------------------
-- Insights:
-- Professional customers generate the highest revenue at approximately
-- 8.47M, followed by Skilled Manual customers at 5.37M.
-- Manual customers contribute the lowest revenue at approximately 2.46M.
-- This suggests that customers in Professional occupations are the
-- strongest revenue-generating segment.
------------------------------------------------------------------------
--Q10. Which income level contributes the most revenue?
------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
annualincome,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


select annualincome,
round(sum(revenue),2)as revenue,
count(distinct customerkey)no_of_customers
from customer_sales_revenue
group by annualincome
order by sum(revenue) desc
-- Insight:
-- Customers with an annual income of 70K represent the strongest revenue-contributing
-- income segment, suggesting that this income level may be a key customer sweet spot.
-- In contrast, higher-income segments contribute substantially less total revenue,
-- indicating that higher purchasing power does not necessarily translate into higher
-- demand for these products.

-------------------------------------------------------------------------------------
--Q11. Which age group contributes the most revenue?---------------------------------
-------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
annualincome,
datediff(year,birthdate,GETDATE()) as age,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


, age_category as(
SELECT age,
(case when  age > = 10 and age <20 then 'Teenagers' 
      when  age >=20   and age < 30  then 'Twenties'
      when  age >=30   and age < 40  then 'Thirties'
      when  age >=40   and age < 50  then 'Fourties'
      when  age >=50   and  age < 60 then 'Fifties'
      when  age >=60   and  age < 70  then 'Sixties'
      when  age >= 70  and  age <80 then 'Seventies'
      when  age >=80 and age < 90  then 'Eighties'
      when  age >=90 and age < 100 then 'Ninties'
      When  age >=100 and age <110 then '100+' else '110+'end)as Age_group,
      revenue
from customer_sales_revenue

)

select age_group,
sum(revenue)as revenue_as_per_age_category
from age_category
group by age_group
order by sum(revenue) DESC

-------------------------------------------------------------------
-- Insights:
-- Customers in their 50s generated the highest revenue, followed by customers in their 60s and 70s.
-- The 20s and 30s age groups are not present in the dataset.
-- Age has been calculated as of the analysis date using GETDATE().My Date of Analysis[2026-08-12].
-- Overall, customers aged 50+ represent the dominant revenue-generating segment.
---------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--Q12. Compare revenue by gender.-----------------------------------------------
--------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
gender,
annualincome,
datediff(year,birthdate,GETDATE()) as age,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)

select gender,
round(sum(revenue),2) revenue
from customer_sales_revenue
group by gender
order by sum(revenue) desc
---------------------------------------------------------------------------------
-- Insight:
-- Female customers generated slightly higher revenue than male customers,
-- indicating a relatively balanced revenue contribution by gender.
----------------------------------------------------------------------------------
--Q13. Which customers have the highest average basket size?
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

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
gender,
annualincome,
datediff(year,birthdate,GETDATE()) as age,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)

SELECT customerkey,
firstname,
lastname,
sum(OrderQuantity) total_order_quantity,
count(distinct ordernumber)total_orders,
(sum(OrderQuantity)/count(distinct OrderNumber))as avg_basket_size
from customer_sales_revenue
group by customerkey,firstname,lastname
having count(distinct ordernumber) >= 2
order by (sum(OrderQuantity)/count(distinct OrderNumber)) desc

----------------------------------------------------------------------------------------
--Methodology:
--Considered at least 2 orders from the customer as to calculate Average basket size 
--the customers with have 1 order may not fully explore the problem 
----------------------------------------------------------------------------------------
-- Insight:
-- Edward Miller and Ruben Sara have the highest average basket size,
-- purchasing an average of 8 products per order.
-- Several other repeat customers have an average basket size of 7 products per order.
-- This indicates that these customers tend to purchase relatively larger quantities
-- in each order compared with other repeat customers.
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--Q14. Identify one-time customers vs repeat customers.-----------------------------------
------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
gender,
annualincome,
datediff(year,birthdate,GETDATE()) as age,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


select
concat(firstname ,' ',lastname)customer_name,
 (case when no_of_orders = 1  then 'One-time customer'
        when no_of_orders >=2  then  'Repeat-Customer'end)as customer_type,
no_of_orders
 from
(
select customerkey ,
firstname,
lastname,
count(distinct ordernumber)no_of_orders
from customer_sales_revenue
group by customerkey,firstname,lastname
)t
--------------------------------------------------------------------------------------------------
--Q15. What percentage of total company revenue is contributed by the Top 10 customers?
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

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
occupation,
gender,
annualincome,
datediff(year,birthdate,GETDATE()) as age,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


select sum(revenue_percx) top_10cxrevenue,
((sum(revenue_percx)*100.0)/(select sum(revenue)from customer_sales_revenue)) astop10_vs_total_revenue
from
(
select top 10
customerkey,
sum(revenue)as revenue_percx
from customer_sales_revenue
group by customerkey
order by sum(revenue)desc
)t
-- Insight:
-- The Top 10 customers generated approximately 1.10M in revenue,
-- contributing only around 0.44% of total company revenue.
-- This indicates that company revenue is highly distributed across
-- a large customer base rather than being concentrated among a few
-- high-value customers.

-------------------------------------------------------------------------
--Q16. Do homeowners generate more revenue than non-homeowners?
-------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, customer_sales_revenue as(
select 
f.productkey,
f.customerkey,
c.firstname,
c.lastname,
YEAR(orderdate) as years,
OrderNumber,
orderquantity,
productname,
productprice,
HomeOwner,
occupation,
gender,
annualincome,
datediff(year,birthdate,GETDATE()) as age,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey)


select 
(case when homeowner  =  1 then 'Home Owner' else 'non-homeowners ' end)as is_homeOwner,
revenue
from
(
select 
homeowner,
round(sum(revenue),2)as revenue
from customer_sales_revenue
group by HomeOwner
)t
order by revenue desc
--------------------------------------------------------------------------
-- Insight:
-- Homeowners generated significantly higher revenue than non-homeowners,
-- This indicates that homeowners represent a stronger revenue-generating
-- customer segment in the dataset.
-------------------------------------------------------------------------
