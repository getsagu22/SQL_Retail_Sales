-- SQL Retail Sales Analysis 
Create Database Retail_Sales;

-- Create Table
Drop table if exists retail_sales;
Create table Retail_Sales
	(
		transactions_id int Primary Key,
		sale_date Date,
		sale_time time,
		customer_id int,
		gender varchar(15),
		age int,
		category varchar(15),
		quantiy int,
		price_per_unit float,
		cogs float,
		total_sale float
	);

/* Import Data
	Schemas - Tables - Select Table - Right Click - Import & Export - 
	In options unable the header - in general click on folder & select the file */
	
Select * from retail_sales
limit 10

Select count(*)
from retail_sales;

--Find Null
Select * from retail_sales
where transactions_id is null;
Select * from retail_sales
where sale_date is null;

Select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;
	
--delet null values
delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;

-- Data exploration
--How many sales we have?
Select count(*) as total_sale from retail_sales;

--How many customers we have?
select count(customer_id) as total_count from retail_sales;

--How many unique customers
select count(distinct customer_id) as total_count from retail_sales;

--Distinct Category
Select Distinct category as total_sale from retail_sales;

--Data Analysis problems & Answers
--1. SQL query to retrive all columns from sales made on '2022-11-05', filter Gender as Male & Category as Beauty
select 	
	* from retail_sales
where 
	sale_date = '2022-11-05' 
	and 
	gender = 'Male' 
	and 
	category ='Beauty';

--2. Query to retrive all transcations where the category is Clothing & the quantity sold is more then 4 in the month of Nov-2022
Select 
 	category,
	sum(quantiy)
from retail_Sales
where category ='Clothing'
group by 1;

Select * from retail_Sales
where category ='Clothing'
	and
	to_char(sale_date, 'yyyy-mm') = '2022-11'
	and
	quantiy >= 4;

--3. Calculate the total sales (Total_sale) from each category
Select 
	category, 
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
	group by category;

--4. Find the average age of customers who purchased items from the 'Beauty' category
Select
	round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty'

--5. Write a SQL query to find all transcations where the total_sale is greater then 1000.

Select * from retail_sales
where total_sale > 1000;

--6. Write a SQL query to find the total number of transcations(Transaction_id) made by each gender in each category.

Select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group 
	By 
	category,
	gender
order by 1;

--7. to calculate the avg sale for each month. Find out best selling month in each year
Select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as total_sale
from retail_sales
group by 1, 2
order by 1, 3 desc;

--another approach using rank
Select 
	year,
	month,
	total_sale
from	
(
Select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as total_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank = 1;

-- 8. to find the top 5 customers based on the highest total sales
select 
	customer_id,
	sum(total_sale) as totalsales
from retail_sales
group by customer_id
order by totalsales desc
limit 5;

--9. to find the no. of unique customers who purcahased items from each category
select 
	category,
    count(distinct customer_id) as count
from retail_sales
group by category;

--10. SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) < 12 Then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;