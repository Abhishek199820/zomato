


----------------------------------------------------------------------------------
-- Analysis & Reports
----------------------------------------------------------------------------------

-- Q1 
-- Write a query to find the top 5 nost fequently ordered dishes by customer called
-- 'Jane Smith' in the last 1 year

/* Approach
1. join customers and orders table
2. filter for last 1 year
3. filter 'Jane Smith'
4. group by customer id, dishes and count
*/

select cus.customer_id,
	   cus.customer_name, 
	   ord.order_item as dishes,
	   count(ord.order_item) as dish_count
	   from orders as ord
join customers as cus
on cus.customer_id = ord.customer_id
where ord.order_date >= (Current_date - Interval '1 year')
and cus.customer_name = 'Jane Smith'
group by 1, 2, 3
order by dish_count desc
limit 5;


-- 2. Popular Time Slots
-- Question: Identify the time slots during the most orders are placed based on 2 hours 
-- intervals

-- Approach 1
select 
	case
		WHEN extract(hour from order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00'
		WHEN extract(hour from order_time) BETWEEN 2 AND 3 THEN '02:00 - 04:00'
		WHEN extract(hour from order_time) BETWEEN 4 AND 5 THEN '04:00 - 06:00'
		WHEN extract(hour from order_time) BETWEEN 6 AND 7 THEN '06:00 - 08:00'
		WHEN extract(hour from order_time) BETWEEN 8 AND 9 THEN '08:00 - 10:00'
		WHEN extract(hour from order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
		WHEN extract(hour from order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
		WHEN extract(hour from order_time) BETWEEN 14 AND 15 THEN '14:00 - 16:00'
		WHEN extract(hour from order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
		WHEN extract(hour from order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
		WHEN extract(hour from order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
        ELSE '22:00 - 00:00'
	end as time_slot,
	count(*) as order_count
from orders
group by time_slot
order by order_count desc;

-- Approach 2
select
		floor(extract(hour from order_time)/2)*2 as start_time,
		floor(extract(hour from order_time)/2)*2+2 as end_time,
		count(*) as total_orders
from orders
group by 1, 2
order by 3 desc;

-- 3. Order Values Analysis
-- Question: Find the average order values per customer who has placed more than 200 
-- orders. Retrun customer_name and avg orders

select * from orders
limit 1;


select 
	c.customer_name,
	avg(o.total_amount) as aov,
	count(o.order_id) as orders
from orders as o
join customers as c
on c.customer_id = o.customer_id
group by 1
having count(order_id) > 200
order by 3 desc;

-- 4. High Value Customer
-- Questions: list the customers who have spent more than 100k in total on food orders.
-- return customer_name and customer_id,

select 
	c.customer_name,
	ROUND(SUM(o.total_amount)::NUMERIC,2) as total_spent
from orders as o
join customers as c
on c.customer_id = o.customer_id
group by 1
having SUM(o.total_amount) > 100000
order by 2 desc;


-- 5. Orders Without Delivery
-- Questions: Write a query to find orders that were placed but not delivered.
-- Return each restaurant name, city and no. of not delivered orders.

SELECT 
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS not_delivered_orders
FROM orders AS o
LEFT JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
LEFT JOIN deliveries AS d ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL
GROUP BY r.restaurant_name, r.city
ORDER BY not_delivered_orders DESC;


-- Q.6
-- Restaurant Revenue Ranking:
-- Rank restaurants by their annual total reve from last year, including name.
-- total revenue and rank within their city

select 
	r.restaurant_name,
	r.city,
	round(sum(o.total_amount)::Numeric, 2) as revenue,
	RANK() over(partition by r.city order by sum(o.total_amount) desc) as city_rank
from orders as o
join 
restaurants as r
on r.restaurant_id = o.restaurant_id
where extract(year from o.order_date) = extract(year from current_date) - 1
GROUP BY r.restaurant_name, r.city
ORDER BY r.city, city_rank;


-- Q.7 
-- Most Popular Dish by City
-- Identify the most popular dish in each city based on the number of orders.

Select city, order_item, item_count
from (
select 
	r.city,
	o.order_item,
	count(o.order_item) as item_count,
	RANK() over(partition by r.city order by count(o.order_item) desc) as rank
from orders as o
join 
restaurants as r
on r.restaurant_id = o.restaurant_id
group by r.city, o.order_item
) ranked 
where rank = 1

--Q.8 Customer Churn:
-- Find customers who haven't placed an order in 2024 but did in 2023

-- 1. Find customers who has ordered in 2023
-- 2. Find customers who has ordered in 2024
-- compare 1 and 2

select distinct customer_id from orders
where extract(year from order_date) = 2025
and customer_id not in (select distinct customer_id from orders
where extract(year from order_date) = 2024)


-- Q.9 Cancellation Rate Comparison:
-- Calculate and compare the order cancellation rate for each restaurant between the
-- current year and the previous year

WITH cancel_ratio_24 AS (
    SELECT 
        o.restaurant_id,
        COUNT(o.order_id) AS total_order,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders AS o
    LEFT JOIN deliveries AS d ON o.order_id = d.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY o.restaurant_id
),
cancel_ratio_25 AS (
    SELECT 
        o.restaurant_id,
        COUNT(o.order_id) AS total_order,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders AS o
    LEFT JOIN deliveries AS d ON o.order_id = d.order_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2025
    GROUP BY o.restaurant_id
),
last_year_data AS (
    SELECT 
        restaurant_id,
        total_order,
        not_delivered,
        CASE 
            WHEN total_order = 0 THEN 0 
            ELSE ROUND(not_delivered::NUMERIC / total_order * 100, 2) 
        END AS cancel_ratio
    FROM cancel_ratio_24
),
current_year_data AS (
    SELECT 
        restaurant_id,
        total_order,
        not_delivered,
        CASE 
            WHEN total_order = 0 THEN 0 
            ELSE ROUND(not_delivered::NUMERIC / total_order * 100, 2) 
        END AS cancel_ratio
    FROM cancel_ratio_25
)
SELECT 
    cr.restaurant_id,
    cr.cancel_ratio AS current_year_cancel_ratio,
    lt.cancel_ratio AS last_year_cancel_ratio
FROM current_year_data AS cr
JOIN last_year_data AS lt ON cr.restaurant_id = lt.restaurant_id;


-- Q.10 Rider Average Delivery Time:
-- Determine each rider's average delivery time.

select 
	o.order_id,
	d.riders_id,
	o.order_time,
	d.delivery_time,
	o.order_time - d.delivery_time as time_difference,
	ROUND(EXTRACT(EPOCH from (d.delivery_time - o.order_time + case when d.delivery_time < o.order_time then interval '1 Day' ELSE
	Interval '0 day' End))/60) as time_difference_in_seconds
from orders as o
join deliveries as d
on o.order_id = d.order_id
where d.delivery_status = 'Delivered';


-- Q.11 Monthly Restaurant Growth Ratio:
-- Calculate Each Restaurant's growth ratio based on the total number of delivered
-- orders since its joining.
WITH monthly_orders AS (
    SELECT 
        o.restaurant_id,
        TO_CHAR(o.order_date, 'MM-YY') AS month,
        COUNT(o.order_id) AS cnt_orders,
		LAG(COUNT(o.order_id)) OVER (PARTITION BY restaurant_id ORDER BY TO_CHAR(o.order_date, 'MM-YY')) AS previous_month_orders
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
    GROUP BY o.restaurant_id, TO_CHAR(o.order_date, 'MM-YY')
)
SELECT 
    restaurant_id,
    month,
	previous_month_orders,
    cnt_orders,
	ROUND((cnt_orders - previous_month_orders)/previous_month_orders::Numeric * 100, 2) as growth_ratio
FROM monthly_orders

-- Q.12 Customer Segmentation:
/*
Customer Segmentation: segment customer into 'Gold' or Silver groups based on their total spending
compare to the average order values(AOV). If a customer's total spending exceeds the AOV, label them as 
'Gold' otherwise, lable them as 'Silver'. Write an SQL query to determine each segments 
total number of orders and total revenue.
*/

-- each customer total spending
-- aov
-- gold/silver
-- each category and total order and total rev
select
	cx_category,
	SUM(total_orders),
	SUM(total_spent)
from
(select 
	customer_id,
	Sum(total_amount) as total_spent,
	count(order_id) as total_orders,
	CASE WHEN Sum(total_amount) > (select AVG(total_amount) from orders) THEN 'Gold'
		ELSE 'Silver'
	END as cx_category
from orders
group by customer_id
) as t1
group by cx_category;


select AVG(total_amount) from orders -- 1046.1760299999985

-- Q.13 Riders Monthly Earnings:
-- Calculated each rider's total monthly earning they earn 8% of the order amount.

SELECT
    d.riders_id,
    TO_CHAR(o.order_date, 'MM-YY') AS month,
	ROUND(SUM(o.total_amount)::NUMERIC) AS money_collection,
    ROUND(SUM(o.total_amount) * 0.08) AS riders_earning
FROM orders AS o
JOIN deliveries AS d ON o.order_id = d.order_id
GROUP BY d.riders_id, TO_CHAR(o.order_date, 'MM-YY')
ORDER BY d.riders_id, money_collection desc;


-- Q.14 Rider Rating Analysis:
-- Find the nuber of 5-stars, 4-stars, and 3-stars ratings each rider has.
-- Rider receive this rating based on delivery time.
-- If orders are delivered in lass than 50 minutes of order received time the rider get 5 star rating.
-- If they deliver after 50 - 150 minutes the rider get 4 star rating.
-- If they deliver after 150 minutes the rider get 3 star rating.


SELECT
	riders_id,
	stars,
	count(*) as ratings
FROM
(
SELECT
	riders_id,
	delivery_duration_minutes,
	case when delivery_duration_minutes < 50 then '5 stars'
		 when delivery_duration_minutes between 50 and 150 then '4 stars'
		 else '3 stars'
	end as stars
FROM
(
SELECT
    o.order_id,
    o.order_time,
    d.delivery_time,
    ROUND(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
	case when d.delivery_time < o.order_time then interval '1 Day' ELSE
	Interval '0 day' End)) / 60) AS delivery_duration_minutes,
    d.riders_id
FROM orders AS o
JOIN deliveries AS d 
ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
) as t1
) as t2
group by riders_id, stars
order by riders_id;


-- Q.15 Order Frequency by Day:
-- Analyze order frequency per day of the week and identify the peak for each restaurant

SELECT *
FROM (
    SELECT 
        r.restaurant_name,
        TO_CHAR(o.order_date, 'Day') AS order_day,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER (PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id) DESC) AS rank
    FROM orders AS o
    LEFT JOIN restaurants AS r 
    ON r.restaurant_id = o.restaurant_id
    GROUP BY r.restaurant_name, TO_CHAR(o.order_date, 'Day')
) AS t1
WHERE rank = 1;


-- Q.16 Customer Lifetime Value(CLV):
-- Calculate the total revenue generated by each customer over all their orders.

SELECT
	o.customer_id,
	c.customer_name,
	SUM(o.total_amount) as CLV
FROM orders as o
JOIN customers as c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name;


-- Q.17 Monthly Sales  Trends:
-- Identify sales trends by comparing each month's total sales to the previous month

select 
	extract(year from order_date) as year,
	extract(month from order_date) as month,
	ROUND(sum(total_amount)::numeric, 2) as total_sales,
	lag(sum(total_amount)::numeric, 1) over (order by extract(year from order_date), extract(month from order_date))as prev_month_sales
from orders
group by 1, 2
order by 1, 2



-- Q.18 Rider Efficiency:
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest 
-- average.


WITH delivery AS (
    SELECT
        d.riders_id,
        ROUND(EXTRACT(EPOCH FROM (d.delivery_time - o.order_time + 
            CASE 
                WHEN d.delivery_time < o.order_time THEN INTERVAL '1 Day' 
                ELSE INTERVAL '0 Day' 
            END)) / 60) AS time_delivered
    FROM orders AS o 
    JOIN deliveries AS d 
    ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
),
riders_time AS (
    SELECT 
        riders_id,
        AVG(time_delivered) AS avg_time
    FROM delivery
    GROUP BY riders_id
)
SELECT 
    MIN(avg_time) AS min_avg_delivery_time,
    MAX(avg_time) AS max_avg_delivery_time
FROM riders_time;



SELECT
    order_item,
    season,
    COUNT(order_id) AS total_orders
FROM (
    SELECT *,
        EXTRACT(MONTH FROM order_date) AS month,
        CASE 
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 3 AND 5 THEN 'Spring'
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 6 AND 8 THEN 'Summer'
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 9 AND 11 THEN 'Autumn'
            ELSE 'Winter'
        END AS season
    FROM orders
) AS t1
GROUP BY order_item, season
ORDER BY order_item, total_orders DESC;


-- Q.20 Monthly Restaurant Growth Ratio:
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining.

select 
	r.city,
	ROUND(sum(o.total_amount)::numeric, 1) as total_rev,
	rank() over(order by sum(o.total_amount)DESC) as city_rank
from orders as o
join 
restaurants as r 
on o.restaurant_id = r.restaurant_id
group by 1
