/*---------------------------------------------------------
Project: AdventureWorks Sales Analysis
Section: Data Exploration
Author : Rahul Datta Roy
Started: August 6, 2026

Description:
This script performs an initial exploration of the
AdventureWorks dataset by examining table structures,
record counts, unique entities, data completeness,
date ranges, product hierarchy, territories, and
potential duplicate records. The objective is to
understand the dataset before performing business
analysis.

Dataset:
AdventureWorks (Kaggle Version)
---------------------------------------------------------*/---------------------------------------------------------------

--1. Data Exploration-------------------------------------------
----------------------------------------------------------------
--Q1.How many records are present in each table?
-----------------------------------------------------------------
select 'calendar'as tables,
count(*) as  total_records
from calendar

union all

select 'Customers',
count(*)
from customers

union all

select 'products',
count(*)
from products

union all

select 'product_categories',
count(*)
from Product_categories

union all

select 'product_subcategories',
count(*)
from product_subcategories

union all

select 'returns',
count(*)
from Returns_Data

union ALL

select 'Sales_Data_2020',
count(*)
from Sales_Data_2020

union ALL

select 'Sales_Data_2021',
count(*)
from Sales_Data_2021

union ALL

select 'Sales_Data_2022',
count(*)
from Sales_Data_2022


union all

select 'Territory',
count(*)
from Territory
-------------------------------------------------------
--Q2.How many unique customers are there?--------------
-------------------------------------------------------
select count(distinct customerkey) as unique_customers
from  customers
-------------------------------------------------------
--Q3.How many unique products are available?-----------
-------------------------------------------------------
select count(distinct productkey) as unique_products
from products
-------------------------------------------------------
--Q4.How many product categories and subcategories exist?-
-------------------------------------------------------
select count(distinct productcategorykey)as unique_product_categories
from product_categories

select count(distinct productsubcategorykey)as unique_product_subcategories
from product_subcategories
--------------------------------------------------------
--Q5.How many territories does the company operate in?
select count(distinct SalesTerritoryKey)  as unique_terretory
from territory
--------------------------------------------------------
--Q6What is the overall date range of sales?--------------
--------------------------------------------------------
WITH all_dates as(
select  orderdate 
from Sales_Data_2020
UNION ALL
select orderdate
from Sales_Data_2021
UNION ALL 
select orderdate
from Sales_Data_2022
)
select min(orderdate)as first_orderdate,
max(orderdate)as last_orderdate
from all_dates
--------------------------------------------------------
--Q7.How many orders were placed each year?-------------
--------------------------------------------------------
select '2020' as year,
count(distinct ordernumber)as number_of_orders
from Sales_Data_2020

union all

select '2021',
count(distinct ordernumber)as number_of_orders
from Sales_Data_2021

UNION ALL

select '2022',
count(distinct ordernumber)as number_of_orders
from Sales_Data_2022
------------------------------------------------------
--Q8.How many products have never been sold?----------
------------------------------------------------------
with  productsold_cte as(
select distinct productkey as pkey
from Sales_Data_2020
UNION 
select distinct productkey
from Sales_Data_2021
UNION 
select distinct productkey
from Sales_Data_2022
)
select count(ProductKey)as no_of_products_did_not_sold
from products p  
left join  productsold_cte c   
on p.productkey = c.pkey
where c.pkey is  null
------------------------------------------------------------
--Q9.Which product categories contain the most products?----
------------------------------------------------------------
select CategoryName,
count(ProductKey) no_of_products
from Product_Categories p  
join Product_Subcategories s  
on p.ProductCategoryKey =s.ProductCategoryKey
join products pk
on s.productsubcategorykey=pk.productsubcategorykey 
group by CategoryName


-------------------------------------------------------------
--Q10.Are there any duplicate customer IDs or product IDs?
-------------------------------------------------------------
select 'Customerkey'as keys,
case when count(customerkey)=count(distinct customerkey)then 'false' else 'True' end as Is_Duplicate
from customers
UNION ALL
select 'productkey',
case when count(productkey)=count(distinct productkey)then 'false' else 'True' end 
from products
----------------------------------------------------------------------------------
--Q11.Write the query for revenue by year
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

, sales_revenue as(
select 
f.productkey as sproductkey,
f.customerkey,
c.firstname,
c.lastname,
orderquantity,
productprice,
year(orderdate) as years,
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


select years,
sum(revenue) as revenue
from sales_revenue
group by years 
ORDER BY years


-------------------------------------------------------------------------------------------------------------
--End of Data Exploration-----------------------------------------------------------------------------------
