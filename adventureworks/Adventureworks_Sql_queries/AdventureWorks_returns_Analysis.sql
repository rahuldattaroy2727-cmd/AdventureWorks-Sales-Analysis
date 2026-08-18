/*---------------------------------------------------------
Project: AdventureWorks Sales Analysis
Section: Return Analysis
Author : Rahul Datta Roy
Started: August 14, 2026


Description:
This script evaluates product return patterns in the
AdventureWorks dataset by analyzing return quantity,
return rates, returned products, return behavior, and
return performance across different product categories
and other relevant dimensions.


Dataset:
AdventureWorks (Kaggle Version)
-----------------------------------------------------------*/
--6. Return Analysis

--------------------------------------------------------------
--Q1. What is the total quantity of products returned?
--------------------------------------------------------------\


SELECT sum(returnquantity)total_quantity
from Returns_Data
-----------------
--Insights:
--total amounts of returned product is 1828

--------------------------------------------------------------------------------
--Q2. What is the total monetary value of returned products?
--------------------------------------------------------------------------------
with product_return as (
select p.productkey as productkey,
r.ProductKey as returnproductkey,
TerritoryKey,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey

)


select sum(monetaryvalue)total_monetary_amount_returns_P
from product_return

-----------------------
--Insights:
--Total monetary value from return product is 765,277.843
--------------------------------------------------------------
--Q3. Which products have the highest number of returned units?
--------------------------------------------------------------
with product_return as (
select p.productkey as productkey,
r.ProductKey as returnproductkey,
productname,
TerritoryKey,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
)


select productkey,
productname,
sum(returnquantity) no_of_return_items
from product_return
group by productkey,productname
order by sum(returnquantity)desc
---------------------------------------------------------------------------------------
--Insights:
--Water Bottle - 30 oz. has the highest number of returned units with 155 returns,
--followed by Patch Kit/8 Patches with 95 and Mountain Tire Tube with 93 returns.
--The Water Bottle - 30 oz. has substantially more returns than the other products,
--making it the product with the highest return volume.
---------------------------------------------------------------------------------------
--Q4. Which products have the highest return value?
---------------------------------------------------------------------------------------
with product_return as (
select p.productkey as productkey,
r.ProductKey as returnproductkey,
productname,
TerritoryKey,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
)


select productkey,
productname,
sum(monetaryvalue) return_value
from product_return
group by productkey,productname
order by sum(monetaryvalue)desc
---------------------------------------------------------------------------------------
--Insights:
--Mountain-200 variants account for the highest sales value of returned products,
--with Mountain-200 Black, 42 generating the highest returned value of approximately
--$43,031, followed by Mountain-200 Black, 46 and Mountain-200 Silver, 38.
--This indicates that the Mountain-200 product line has a significantly higher
--monetary impact from returns compared with most other products.
---------------------------------------------------------------------------------------
--Q5. What is the overall return rate across all products?
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

, product_return as (
select p.productkey as productkey,
r.ProductKey as returnproductkey,
productname,
TerritoryKey,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
)

SELECT
(sum(returnquantity)*100.0/(select sum(orderquantity) from full_sales_table)) as return_rate
from product_return
-------------------------------------------------------------------------------------------
--Insights:
--The overall return rate is approximately 2.17%, meaning that around 2 out of every
--100 units sold were returned during the analysis period.
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--Q6. Which products have the highest return rates?
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

, product_return as (
select p.productkey as productkey,
r.ProductKey as rproductkey,
productname as rproductname,
TerritoryKey,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
)

, sales_revenue as(
select 
f.productkey as sproductkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
productname as sproductname,
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

, return_q_agg as
(
select rproductkey,
rproductname,
sum(returnquantity)as total_returns
from product_return
group by rproductkey,rproductname)

, sales_q_agg as(
select sproductkey,
sproductname,
sum(orderquantity) as Total_orders
from sales_revenue
group by sproductkey,sproductname
)
SELECT ra.rproductkey,
ra.rproductname,
(total_returns *100.0/Total_orders) as return_rate
from return_q_agg ra
join sales_q_agg  sa  
on sa.sproductkey = ra.rproductkey
order by return_rate desc
---------------------------------------------------------------------------------------
--Insights:
-- Road-650 Red, 52 has the highest return rate at approximately 11.76%.
-- Touring-2000 Blue, 46 and Mountain-100 Silver, 44 follow with return rates of 8.33%.
-- Mountain-500 Black, 52 and Mountain-100 Black, 44 also have relatively high return rates.
-- The highest return rates are mainly concentrated among specific bicycle models.
-- AWC Logo Cap has the lowest return rate at approximately 1.11%, indicating relatively low returns.
-- The product with the highest return rate is not necessarily the product with the highest
-- number of returned units, highlighting the difference between return volume and return rate.
---------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------
--Q7. Which product categories have the highest return rates?
----------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, product_return as (
select p.productkey as productkey,
r.ProductKey as rproductkey,
productname as rproductname,
pc.productcategorykey as rproductcategorykey,
categoryname as return_categoryname,
TerritoryKey,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
join Product_Subcategories ps
on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN Product_Categories pc
on pc.productcategorykey =  ps.ProductcategoryKey
)

, sales_revenue as(
select 
f.productkey as sproductkey,
f.customerkey,
c.firstname,
c.lastname,
pc.ProductCategoryKey as order_categorykey,
categoryname as order_categoryname,
orderquantity,
productprice,
productname as sproductname,
Region,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey
join Product_Subcategories ps  
on ps.ProductsubCategoryKey =p.ProductSubcategoryKey
join product_categories pc  
on ps.ProductCategoryKey = pc.productcategorykey )

, return_q_agg as
(
select rproductcategorykey,
return_categoryname,
sum(returnquantity)as total_returns
from product_return
group by rproductcategorykey,return_categoryname)

, sales_q_agg as(
select order_categorykey,
 order_categoryname,
sum(orderquantity) as Total_orders
from sales_revenue
group by order_categorykey, order_categoryname
)

SELECT ra.rproductcategorykey,
ra.return_categoryname,
(total_returns *100.0/Total_orders) as return_rate
from return_q_agg ra
join sales_q_agg  sa  
on sa.order_categorykey = ra.rproductcategorykey
order by return_rate desc
---------------------------------------------------------------
--Insights:
--Bikes have the highest return rate at 3.08%, indicating the highest proportion of returned units among the three categories.
--Clothing follows with a return rate of 2.16%.
--Accessories have the lowest return rate at 1.95%.
---------------------------------------------------------------
-----------------------------------------------------------------
--Q8. Which territories have the highest return rates?
----------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, product_return as (
select p.productkey as productkey,
r.ProductKey as rproductkey,
productname as rproductname,
pc.productcategorykey as rproductcategorykey,
categoryname as return_categoryname,
TerritoryKey as rTerritorykey,
region as rregion,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
join Product_Subcategories ps
on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN Product_Categories pc
on pc.productcategorykey =  ps.ProductcategoryKey
)

, sales_revenue as(
select 
f.productkey as sproductkey,
f.customerkey,
c.firstname,
c.lastname,
pc.ProductCategoryKey as order_categorykey,
categoryname as order_categoryname,
orderquantity,
productprice,
productname as sproductname,
TerritoryKey as oterritorykey,
Region as oregion,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey
join Product_Subcategories ps  
on ps.ProductsubCategoryKey =p.ProductSubcategoryKey
join product_categories pc  
on ps.ProductCategoryKey = pc.productcategorykey )

, return_q_agg as
(
select rTerritorykey,
rregion,
sum(returnquantity)as total_returns
from product_return
group by rTerritorykey,rregion)

, sales_q_agg as(
select oterritorykey,
 oregion,
sum(orderquantity) as Total_orders
from sales_revenue
group by oterritorykey, oregion
)

SELECT sa.oTerritorykey,
sa.oregion,
(total_returns *100.0/Total_orders) as return_rate
from return_q_agg ra
right join sales_q_agg  sa  
on sa.oterritorykey = ra.rTerritorykey
order by return_rate desc

--Insights:
--France has the highest territory return rate at 2.37%, followed by Australia at 2.25% and Canada at 2.18%.
--Northwest, Southwest, United Kingdom, Germany, and Southeast have relatively similar return rates, ranging from approximately 2.04% to 2.16%.
--Northeast and Central have no recorded returns, resulting in NULL return rates.
--Overall, return rates are relatively close across territories, with France having the highest recorded return rate.


-------------------------------------------------------------------------------------------------------------------
--Q9. Which products have high sales volume but also high return rates?
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

, product_return as (
select p.productkey as productkey,
r.ProductKey as rproductkey,
productname as rproductname,
pc.productcategorykey as rproductcategorykey,
categoryname as return_categoryname,
TerritoryKey as rTerritorykey,
region as rregion,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
join Product_Subcategories ps
on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN Product_Categories pc
on pc.productcategorykey =  ps.ProductcategoryKey
)

, sales_revenue as(
select 
f.productkey as sproductkey,
f.customerkey,
c.firstname,
c.lastname,
pc.ProductCategoryKey as order_categorykey,
categoryname as order_categoryname,
orderquantity,
productprice,
productname as sproductname,
TerritoryKey as oterritorykey,
Region as oregion,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey
join Product_Subcategories ps  
on ps.ProductsubCategoryKey =p.ProductSubcategoryKey
join product_categories pc  
on ps.ProductCategoryKey = pc.productcategorykey )

, return_q_agg as
(
select rproductname,
rproductkey,
sum(returnquantity)as total_returns
from product_return
group by rproductname,rproductkey)

, sales_q_agg as(
select sproductname,
sproductkey ,
sum(orderquantity) as Total_orders
from sales_revenue
group by sproductname,sproductkey 
)

, product_metrics as 
(
SELECT 
sa.sproductname as salesproducts,
total_orders,
total_returns,
(total_returns *100.0/Total_orders) as return_rate
from return_q_agg ra
right join sales_q_agg  sa  
on sa.sproductkey = ra.rproductkey
)


select *
from
(
select  salesproducts,
total_orders,
return_rate,
(case when total_orders > (select avg(total_orders) from  sales_q_agg) and ((total_returns *100.0/Total_orders) > 
(select avg(total_returns *100.0/Total_orders)from product_metrics)) then  'High sales & High Return Rate' 
       when total_orders > (select avg(total_orders) from  sales_q_agg) and ((total_returns *100.0/Total_orders) < 
(select avg(total_returns *100.0/Total_orders)from product_metrics)) then 'High sales & Low return rate' 
       when total_orders < (select avg(total_orders) from  sales_q_agg) and ((total_returns *100.0/Total_orders) > 
(select avg(total_returns *100.0/Total_orders)from product_metrics))  then 'Low sales & High return rate' else 'Low Sales & Low return rate'end )trends
from product_metrics
)t
where trends  = 'High sales & High Return Rate'

-------------------------------------------------------------------------------------------------------
--Insigts:
--Five products were identified as having both above-average sales volume and above-average return rates. 
--HL Mountain Tire had the highest return rate among these products at approximately 3.75%, 
--while the Sport-100 Helmet variants had the highest sales volumes. 
--These products should be prioritized for further investigation because their combination of strong sales and 
--elevated return rates may indicate potential product-quality, durability, fit, or customer-expectation issues.
------------------------------------------------------------------------------------------------------------------
--Q10. Which territories generate high revenue but also have high return rates?
-----------------------------------------------------------------------------------------------------------------
with full_sales_table as(
select *
from  Sales_Data_2020 
UNION ALL
select *
from  Sales_Data_2021 
UNION ALL
select *
from  Sales_Data_2022)

, product_return as (
select p.productkey as productkey,
r.ProductKey as rproductkey,
productname as rproductname,
pc.productcategorykey as rproductcategorykey,
categoryname as return_categoryname,
TerritoryKey as rTerritorykey,
region as rregion,
returnquantity,
productprice,
(ProductPrice*ReturnQuantity)monetaryvalue
from Returns_Data r
join products p   
on p.productkey = r.productkey
join Territory t  
on t.SalesTerritoryKey  = r.TerritoryKey
join Product_Subcategories ps
on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN Product_Categories pc
on pc.productcategorykey =  ps.ProductcategoryKey
)

, sales_revenue as(
select 
f.productkey as sproductkey,
f.customerkey,
c.firstname,
c.lastname,
pc.ProductCategoryKey as order_categorykey,
categoryname as order_categoryname,
orderquantity,
productprice,
productname as sproductname,
TerritoryKey as oterritorykey,
Region as oregion,
country,
ProductPrice*orderquantity as revenue
from full_sales_table f  
join products p   
on f.productkey = p.productkey
join customers c   
on f.customerkey =c.customerkey
join Territory t   
on f.territorykey = t.salesterritorykey
join Product_Subcategories ps  
on ps.ProductsubCategoryKey =p.ProductSubcategoryKey
join product_categories pc  
on ps.ProductCategoryKey = pc.productcategorykey )

, return_q_agg as
(
select rTerritorykey,
rregion,
sum(returnquantity)as total_returns
from product_return
group by rTerritorykey,rregion)

, sales_q_agg as(
select oterritorykey,
 oregion,
sum(orderquantity) as Total_orders,
sum(revenue)as total_revenue
from sales_revenue
group by oterritorykey, oregion
)


, territory_metrics as 
(
SELECT 
sa.oTerritorykey as sales_Territory_key,
sa.oregion as sales_region,
total_orders,
total_revenue,
total_returns,
(total_returns *100.0/Total_orders) as return_rate
from return_q_agg ra
right join sales_q_agg  sa  
on sa.oterritorykey = ra.rTerritorykey
)


,trends_territory as
(
select  sales_region,
total_orders,
total_revenue,
return_rate,
(case when total_revenue > (select avg(total_revenue) from  sales_q_agg) and ((total_returns *100.0/Total_orders) > 
(select avg(total_returns *100.0/Total_orders)from territory_metrics)) then  'High sales & High Return Rate' 
       when total_revenue > (select avg(total_revenue) from  sales_q_agg) and ((total_returns *100.0/Total_orders) < 
(select avg(total_returns *100.0/Total_orders)from territory_metrics)) then 'High sales & Low return rate' 
       when total_revenue < (select avg(total_revenue) from  sales_q_agg) and ((total_returns *100.0/Total_orders) > 
(select avg(total_returns *100.0/Total_orders)from territory_metrics))  then 'Low sales & High return rate' else 'Low Sales & Low return rate'end )trends
from territory_metrics
)

select  sales_region,
total_orders,
total_revenue,
return_rate,
trends
from trends_territory

----------------------------------------------------------------------------------------------------------------
--Insights:
-- Australia generates the highest revenue while also having a relatively high return rate, 
--making it the most important territory to investigate for potential return-related issues.

-- Northwest also combines high revenue with an above-average return rate, 
--indicating that its strong sales performance is accompanied by relatively elevated returns.

-- Southwest generates substantial revenue while maintaining a lower return rate, 
--making it one of the stronger-performing territories in terms of balancing sales and returns.

-- France has the highest return rate among the territories,
-- despite generating relatively lower revenue, suggesting a potential return-related issue that warrants further investigation.

-- Canada also has a relatively high return rate but contributes comparatively less revenue, 
--making it a lower-priority concern than Australia or Northwest.

-- Central and Northeast recorded no product returns. however it is understandable because of the low sales in these two regions

