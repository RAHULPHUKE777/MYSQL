# creating database,importing dataset,checking dataset
create database Pizza_project;

use Pizza_project;

select *from order_details;
select *from orders;
select *from pizza_types;
select *from pizzas;
##===========================================================================================================================================================================##
#Retrieve the total number of orders placed

select *from orders;
select count(distinct order_id) as total_orders from orders;

##===========================================================================================================================================================================##

# Calculate the total revenue generated from pizza sales.

select *from order_details;
select *from pizzas;

select round(sum(order_details.quantity*pizzas.price),2)
as total_revenue 
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id;

##===========================================================================================================================================================================##

#Identify the highest-priced pizza.

select *from pizzas;
select pizzas.pizza_id,pizzas.price from pizzas order by price desc limit 1;

##===========================================================================================================================================================================##

#Identify the most common pizza size ordered.

select *from order_details;
select *from pizzas;

select pizzas.size,count(distinct order_id) as 'No of orders',sum(quantity) as 'Total qty ordered'
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id 
group by pizzas.size
order by count(distinct order_id) desc;

##==========================================================================================================================================================================##

#List the top 5 most ordered pizza types along with their quantities.

select *from order_details;
select *from pizza_types;
select *from pizzas;

select pizza_types.name as 'Pizza', sum(quantity) as 'Total Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name 
order by sum(quantity) desc limit 5;

##===========================================================================================================================================================================##

#Find the total quantity of each pizza category ordered

select *from order_details;
select *from pizza_types;
select *from pizzas;

select pizza_types.category as 'Category',sum(order_details.quantity) as 'Quantity'
from order_details
join pizzas on order_details.pizza_id=pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by pizza_types.category
order by sum(quantity) desc;

##===========================================================================================================================================================================##
#Determine the distribution of orders by hour of the day

select *from orders;

select
    extract(hour from cast(time as time)) as order_hour,
    count(*) as total_orders
from orders
group by order_hour
order by total_orders desc;

##===========================================================================================================================================================================##

#Find the category-wise distribution of pizzas

select *from pizza_types;
select *from order_details;

select category, count(distinct pizza_type_id) as 'No of pizzas'
from pizza_types
group by category
order by 'No of pizzas';

##===========================================================================================================================================================================##

#Group the orders by date and calculate the average number of pizzas ordered per day.

select *from order_details;
select *from orders;

select
    round(avg(daily_total),0) as avg_pizzas_per_day
from (select o.date,sum(od.quantity) as daily_total
    from orders as o
    join order_details as od on o.order_id = od.order_id
    group by o.date) as daily_pizza_counts;

##===========================================================================================================================================================================##

#Determine the top 3 most ordered pizza types based on revenue

select *from order_details;
select *from pizza_types;
select *from pizzas;

select
    pt.name as pizza_name,
    sum(od.quantity * p.price) as total_revenue
from order_details od
join pizzas p on od.pizza_id = p.pizza_id
join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_revenue desc
limit 3;

##===========================================================================================================================================================================##












