/*---------------------------------------------------------
Project: AdventureWorks Sales Analysis
Section: Product Performance Analysis
Author : Rahul Datta Roy
Started: August 10, 2026

Description:
This script evaluates product performance across the
AdventureWorks dataset by analyzing revenue, sales volume,
product rankings, category and subcategory performance,
product contribution, and other key product-related
business insights.

Dataset:
AdventureWorks (Kaggle Version)
---------------------------------------------------------*/

--3.Product Performance Analysis
---------------------------------------------------------
--Q1. Which product generated the highest total revenue?
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

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ProductDescription,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)




select  productname,
sum(revenue) as product_revenue
from sales_revenue
group by productname
order by sum(revenue) desc


--Insights:
--Mountain-200 Black is the product that produces the highest revenue of  $1,241,753.47.
--As this product is on demand , it will be most important product in the inventory


------------------------------------------------------------------------------------
--Q2. Which product sold the highest number of units?-------------------------------
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
ProductDescription,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey)

select ProductName,
sum(orderquantity) no_of_items_sold
from sales_revenue
group by ProductName
order by sum(OrderQuantity)desc

---insights:
--products with highest number of units sold is Water Bottle - 30 oz  with	7967 units
--Followed by Patch Kit/8 Patches with 5898 units and  Mountain Tire Tube with  5678 units


-------------------------------------------------------------------------------------------
--Q3. Which products have never been sold?-------------------------------------------------
-------------------------------------------------------------------------------------------[
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, unsold_product as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
productname,
productcost
from full_sales_table f  
right join products p   
on f.productkey = p.productkey
where f.ProductKey is null)

select 
productname,
productcost
from unsold_product
-----------------------------------------------------------------------------------------
--Q4. Which product categories generate the highest revenue?-----------------------------
-----------------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)

select  categoryname,
sum(revenue)revenue_as_per_categories
from sales_revenue
group by categoryname
order by sum(revenue) DESC

--Insights:
--Bikes are biggest revenue driver for the company which accounts for $23,642,495.21
--Accessories generate $906,673.09
--while clothing generates $365,418.61

------------------------------------------------------------------------------------------------------------------------
--Q5.Which product subcategories generate the highest revenue?-------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)

select subcategoryname,
round(sum(revenue),2)revenue_as_per_subcategories
from sales_revenue
group by SubcategoryName
order by sum(revenue) desc
--Insights:
--Road Bikes generated the highest revenue of $11,287,182.72.Road Bikes generated the highest revenue among the subcategories,
-- indicating strong commercial performance
--followed by mountain bikes which generates $8,583,747.77
--third on the list is Touring Bikes which generates $3,771,564.72
-------------------------------------------------------------------------------------------------------------------
--Matplotlib Graph Generator For Revenue vs Sales Volume
-------------------------------------------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)


select productname ,
sum(revenue)as revenue,
sum(orderquantity) quantity_sold
from sales_revenue
group by productname
-------------------------------------------------------------------------------------------------------------------
--Q6. What is the average selling quantity per product?------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)

select productname,
avg(orderquantity)Avg_Order_Quantity
from sales_revenue
group by productname 
order by avg(OrderQuantity) desc
--------------------------------------------------------------------------
-- Insights:
-- Water Bottle - 30 oz. records the highest average order quantity,
--   with customers purchasing approximately 2 units per order.
--
-- The top products by average quantity are mainly low-cost accessories
--   such as water bottles, bottle cages, fenders, and tire tubes rather
--   than bicycles.
--
-- This indicates that customers are more likely to purchase multiple
--   units of inexpensive accessories in a single order, whereas
--   high-value products like bicycles are generally purchased one at a time.
-----------------------------------------------------------------------------


---------------------------------------------------------------------------------
--Q7. Which products contribute the most to total revenue (Revenue %)?-----------
---------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)


select productname,
((sum(revenue)/(select sum(revenue)from sales_revenue))*100)as revenue_pct
from sales_revenue
group by ProductName
ORDER BY (sum(revenue)/(select sum(revenue)from sales_revenue))desc
----------------------------------------------------------------------------------------
--Q8. Rank products within each category based on revenue.------------------------------
----------------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)

select CategoryName,
ProductName,
sum(revenue) as product_revenue,
dense_rank()over(partition by categoryName order by  sum(revenue)desc)as product_rank
from sales_revenue
group by productname,CategoryName

------------------------------------------------------------------------------------
--Q9. What are the Top 10 revenue-generating products?------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)

select top 10 productname,
sum(revenue)as product_revenue
from sales_revenue
group by productname
order by sum(revenue) desc
-------------------------------------------------------------------------------------------------------------------------
--insights:
-- we can see that in top 10 , 6 products are variants of Mountain-200 bikes , of which the most popular variant is the
--Mountain-200 Black one
--The other four are Road-250 variants(Black 52,red 58,Black 48) and Road-150 Red
--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------
--Q10. What are the Bottom 10 revenue-generating products?----------------------------------------------------------------
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

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)

select top 10 productname,
sum(revenue)as product_revenue
from sales_revenue
group by productname
order by sum(revenue) ASC

------------------------------------------------------------------------------------------------
-- Insight:
-- The bottom 10 revenue-generating products are predominantly
-- low-value accessories and apparel items, with Racing Socks - L
-- generating the lowest revenue at approximately $4.6K.
-- This suggests that these products have relatively low revenue
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--Q11. Which products have the highest return rate?----------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,

ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey
 )


, prod_ordered as(
select productkey,
productname,
sum(orderquantity)as order_quantities_by_product
from sales_revenue
group by productkey,productname)

, prod_returned as(
select productkey,
sum(returnquantity)as return_quantities_by_product
from Returns_Data
group by productkey)

select pog.productkey,
productname,
round((((return_quantities_by_product)*1.0/(order_quantities_by_product))*100),2)as return_rate
from prod_ordered as pog
join prod_returned as prg  
on pog.productkey = prg.productkey
ORDER BY return_rate desc
------------------------------------------------------------------------------------------------------------------------
--Insights:
--Road-650 Red, 52 had the highest return rate at 11.76%, followed by Touring-2000 Blue, 46 and Mountain-100 Silver, 44 at 8.33%. 
--These products may warrant further investigation to identify potential quality, sizing, or customer-expectation issues.
-------------------------------------------------------------------------------------------------------------------------
-- Q12. Which products have high sales volume but relatively low revenue?-
-------------------------------------------------------------------------------------------------------------------------
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
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,

ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey
 )

,product_sales_performance as
(
select productname,
sum(orderquantity)product_sales,
round(sum(revenue),2)product_revenue
from sales_revenue
group by ProductName       
)

select 
productname,
product_sales,
product_revenue
from product_sales_performance
where product_sales > (select avg(product_sales) from product_sales_performance) AND
       product_revenue < (select avg(product_revenue) from product_sales_performance ) 
ORDER BY product_sales desc

----------------------------------------------------------------------------------------
--Insights
--Water Bottle sells in large quantity however it generates very less revenue , but it is understandable as the product cost is too low
--Followed by patch kit which generates only $13,506.42 and Mountain Tire tube with $28,333.22
-- these are low price high volume products

---------------------------------------------------------------------------------------------
-- Q13. Which products generate high revenue but have relatively low sales volume?-----------
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

, sales_revenue as(
select 
f.orderdate,
f.productkey,
orderquantity,
productprice,
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,

ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey
 )

,product_sales_performance as
(
select productname,
sum(orderquantity)product_sales,
round(sum(revenue),2)product_revenue
from sales_revenue
group by ProductName       
)

select 
productname,
product_sales,
product_revenue
from product_sales_performance
where product_sales < (select avg(product_sales) from product_sales_performance) AND
       product_revenue > (select avg(product_revenue) from product_sales_performance ) 
ORDER BY product_sales desc
----------------------------------------------------------------------------------------
--Insights:
--Mountain-200 variants dominate the high-revenue, low-volume segment. 
--Despite selling fewer units than many high-volume accessories, these products generate over $1 million in revenue individually, 
--indicating that premium-priced products contribute significantly to overall revenue.

--Road-750 variants also appear in this segment, generating around $192K–$207K from fewer than 400 units sold.


---------------------------------------------------------------------------------------------------------------
---- Q14. Which products were sold consistently across all available years?------------------------------------
---------------------------------------------------------------------------------------------------------------
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
datepart(year,f.OrderDate)as years,
f.productkey,
orderquantity,
productprice,
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,

ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey

 )

select productname,
(abs(delta_20_21)+ abs(delta_21_22)) combined_delta,
(((product_sales_2021 -product_sales_2020 )*100/(product_sales_2020)))percent_variationns_20_21,
(((product_sales_2022 -product_sales_2021 )*100/(product_sales_2021)))percent_variationns_21_22,
(abs((((product_sales_2021 -product_sales_2020 )*100/(product_sales_2020))))+
abs((((product_sales_2022 -product_sales_2021 )*100/(product_sales_2021)))))combined_variations
from
(
 select productname,
 count(distinct years) no_of_years,
 sum(case when years = '2020' then orderquantity else 0 end )as product_sales_2020,
 sum(case when years = '2021' then orderquantity else 0 end )as product_sales_2021,
 sum(case when years = '2022' then orderquantity else 0 end )as product_sales_2022,
  (sum(case when years = '2020' then orderquantity else 0 end )-
   sum(case when years = '2021' then orderquantity else 0 end )) as delta_20_21,
   (sum(case when years = '2021' then orderquantity else 0 end )-
   sum(case when years = '2022' then orderquantity else 0 end )) as delta_21_22
 from sales_revenue
 group by productname
 having count(distinct years) =3
)t
order by combined_variations asc

-- Methodology
-- To measure product consistency, percentage variation was used instead of absolute
-- sales differences because products have significantly different sales volumes.
-- Using percentage variation makes the comparison fair across both low-volume and
-- high-volume products. The absolute percentage variations between 2020–2021 and
-- 2021–2022 were combined, where a lower combined variation indicates more consistent sales.


-- Insights
-- Road-550 Red showed the most consistent sales performance, recording the lowest
-- combined percentage variation across the three-year period.
-- This indicates that its sales volume experienced relatively smaller fluctuations
-- from year to year, suggesting stable and predictable demand.

----------------------------------------------------------------------------------------------
-- Q15. Which products showed the highest year-over-year revenue growth in 2020-2021?---------
----------------------------------------------------------------------------------------------

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
datepart(year,f.OrderDate)as years,
f.productkey,
orderquantity,
productprice,
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,

ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey

 )

select productname,
product_sales_2020 as product_revenue_2020,
product_sales_2021 as product_revenue_2021,
change_20_21,
(((product_sales_2021 -product_sales_2020 )*100.0/nullif(product_sales_2020,0)))as pct_change_20_21
from
(
select productname,
 sum(case when years = '2020' then revenue else 0 end )as product_sales_2020,
 sum(case when years = '2021' then revenue else 0 end )as product_sales_2021,
  (sum(case when years = '2021' then revenue else 0 end )-
   sum(case when years = '2020' then revenue else 0 end )) as change_20_21
 from sales_revenue
 group by productname)t
 WHERE (((product_sales_2021 -product_sales_2020 )*100.0/nullif(product_sales_2020,0))) is not null
 order by pct_change_20_21 desc

------------------------------------------------------------------------------------------------------
--Insights:
--Mountain-200 Silver, 46 led the biggest growth  from $103,570.98 in 2020 to $573,783.25 in 2021 account 454% increase
--Followed by  Mountain-200 Black, 38  with 436% increase
--and  Road-550-W Yellow, 44 with 430.76% increase
-- A noticeable pattern is that Red variants generally show weaker YoY revenue growth, with several Red products experiencing negative growth, 
--while many of the highest-growth products are Silver, Black and Yellow variants

-------------------------------------------------------------------------------------------------------
-- Q16. Which products showed the highest year-over-year revenue growth in 21-22?-----------------------------
-------------------------------------------------------------------------------------------------------
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
datepart(year,f.OrderDate)as years,
f.productkey,
orderquantity,
productprice,
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,

ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey

 )

select productname,
product_sales_2021 as product_revenue_2021,
product_sales_2022 as product_revenue_2022,
change_21_22,
(((product_sales_2022 -product_sales_2021 )*100.0/nullif(product_sales_2021,0)))as pct_change_21_22
from
(
select productname,
 sum(case when years = '2021' then revenue else 0 end )as product_sales_2021,
 sum(case when years = '2022' then revenue else 0 end )as product_sales_2022,
  (sum(case when years = '2022' then revenue else 0 end )-
   sum(case when years = '2021' then revenue else 0 end )) as change_21_22
 from sales_revenue
 group by productname)t
 WHERE (((product_sales_2022 -product_sales_2021 )*100.0/nullif(product_sales_2021,0))) is not null
 order by pct_change_21_22 desc

--------------------------------------------------------------------------------------------------------------
--Insights
-- Mountain-500 Black, 52 recorded the highest YoY revenue growth from 2021–2022, increasing by approximately 115.38%, 
--followed by Road-350-W Yellow, 44 (+108.70%) and Mountain-500 Black, 48 (+105.56%).

-- The products that led the growth ranking in 2020–2021 did not maintain the same momentum in the following year. 
--Mountain-200 Silver, 46, which previously grew by 454%, contracted by approximately 11.9% in 2021–2022, 
--while Mountain-200 Black, 38, which previously grew by 436%, declined by 6.34%.

-- This indicates that product-level revenue growth can be highly volatile,
-- with products experiencing exceptionally high growth in one year potentially seeing a decline in the following year.
-------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------
-- Q17. Classify products into performance priority tiers based on profitability and sales performance.
-- Very High Priority
-- High Priority
-- Medium Priority
-- Low Priority
-- Very Low Priority
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

, sales_revenue as(
select 
f.orderdate,
datepart(year,f.OrderDate)as years,
f.productkey,
orderquantity,
productprice,
ProductDescription,
CategoryName,
SubcategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue,
productcost*orderquantity as cost
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey

 )


,sales_profit as(
 select productname,
 sum(revenue) as product_revenue,
 sum(cost) as product_cost,
 (sum(revenue)- sum(cost)) as gross_proft,
((sum(revenue)- sum(cost))*100 /(sum(revenue)))as profit_margin
 from sales_revenue
 GROUP BY ProductName
)
,profit_scale as(
select productname,
case when profit_margin  > 55 then 'Very High'
     when  profit_margin  <= 55 and profit_margin  > 45 then 'High'
     when  profit_margin   <= 45  and profit_margin >35  then 'Medium'
     when  profit_margin   <= 35 and profit_margin > 25 then 'Low'
     else 'Very Low'end as Profitibility,
     profit_margin
from sales_Profit
)



,sales_agg as
(
select productname,
sum(OrderQuantity) quantity_sold
from sales_revenue
GROUP BY productname 
)

,sales_pct as(
select *,
((quantity_sold -avg_sales)*100.0/avg_sales)as sales_varition_pct
from
(
sELECT productname,
quantity_sold,
(select avg(quantity_sold)from sales_agg) as avg_sales
from sales_agg)t    
)

,sales_scale as
(
select *,
(case when sales_varition_pct > 100 then  'Very High'
    when  sales_varition_pct  <= 100 and sales_varition_pct > 25 then 'High'
    when   sales_varition_pct <=25  and sales_varition_pct > -25 then 'Medium'
    when    sales_varition_pct <-25  and sales_varition_pct > -50 then 'Low'
    else 'Very Low'end  )as sales_performance
from sales_pct)


            --------------------------------Main_performance_evaluation_Code-------------------------------
, Overall_product_performance as(
select p.productname as productname ,
profit_margin,
Profitibility,
sales_varition_pct,
sales_performance,
(case when  Profitibility  = 'Very High' and sales_performance = 'Very High' then 'Very High Priority'
       WHEN Profitibility = 'High' AND sales_performance IN ('High', 'Very High')
        THEN 'High Priority'
       WHEN Profitibility = 'Very High' AND sales_performance = 'High'
        THEN 'Very High Priority'
        WHEN Profitibility = 'Medium' AND sales_performance = 'Medium'
        THEN 'Medium Priority'
        WHEN Profitibility IN ('Low', 'Very Low')
         AND sales_performance IN ('Low', 'Very Low')
        THEN 'Very Low Priority'
        WHEN Profitibility = 'High'
         AND sales_performance = 'Medium'
        THEN 'High Priority'

    WHEN Profitibility = 'Medium'
         AND sales_performance IN ('High', 'Very High')
        THEN 'High Priority'

    ELSE 'Low Priority'
END) AS priority_tier 
from profit_scale p
join sales_scale  s
on p.ProductName = s.ProductName)
                   -----------------------------------------------------------------
--SELECT *
--FROM Overall_product_performance                   



----For finding the VERY low priority item that should be sent for reviews--
select * 
from Overall_product_performance
where priority_tier = 'Very Low Priority'
-----------------------------------------------------------------------------------------
-- Insights:
-- Overall, product performance varies considerably when both sales performance
-- and profitability are considered together.

-- Very High Priority products combine strong sales with high profit margins,
-- making them the strongest-performing products and good candidates for
-- maintaining inventory and increasing business focus.

-- Water Bottle - 30 oz. was a standout performer, with a profit margin of
-- approximately 62.6% and sales more than 1,100% above the overall average.

-- Very Low Priority products show both weak sales performance and low
-- profitability, making them the most important products for management review.

-- Short-Sleeve Classic Jersey products had profit margins of approximately
-- 23% and sales around 40%-45% below the overall average, indicating weak
-- performance on both dimensions.

-- Long-Sleeve Logo Jersey products also showed relatively low profitability
-- at approximately 34% and sales around 34%-41% below the overall average.

-- These Very Low Priority products should be reviewed for possible
-- discontinuation, repricing, cost reduction, or replacement.

-- Products with high profitability but low sales should not necessarily be
-- discontinued, as their strong margins may indicate an opportunity to
-- improve sales through pricing, marketing, or promotion.

---------------------------------------------------------------------------------------------------------------
-- Q18. What is the total product cost associated with products that have never been sold?---------------------
---------------------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, unsold_product as(
select 
f.productkey,
orderquantity,
productprice,
productname,
productcost
from full_sales_table f  
right join products p   
on f.productkey = p.productkey
where f.ProductKey is null)

select 
round(sum(productcost),2)total_production_cost_unsold
from unsold_product
-----------------------------------------------------------------------------------------------
--Insights:
--The combined unit cost of products that have never appeared in the sales data is $38,653.24.
-- the amount is pretty less and we can consider discontinuing some items or send for review for--
-- further assessment.
------------------------------------------------------------------------------------------------
-- Q19. Which product categories generate the most revenue relative to their product count?-----
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
ProductDescription,
CategoryName,
ordernumber,
productname,
productcost,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join Product_Subcategories ps    
on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
join Product_Categories  pc  
on pc.ProductCategoryKey =ps.ProductCategoryKey)


select categoryname,
count( distinct productname) as product_count,
round(sum(revenue),2)category_wise_revenue,
round((sum(revenue)/count(distinct productname)),2) as revenue_per_product
from sales_revenue
group by categoryname 
order by (round(sum(revenue),2)/count(distinct productname)) desc
---------------------------------------------------------------------------
--Insights:
--it is very much understandable that bikes generate the most revenue as these are the primary products
-- And accessories are the items or parts that supports the bikes generate the second largest revenue generator
--Clothing is much more like a lifestyle choice or optional as many riders can choose clothing from different 
--manufacturers ,whereas Accessories generate the second-highest revenue per product, possibly because customers may preferably 
--choose accessories from the same brand for better compatibility with their bicycles.
