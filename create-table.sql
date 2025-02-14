-- Zomato Data Analysis

-- Drop table if exists orders;
-- Drop table if exists customers;
-- Drop table if exists restaurants;
-- Drop table if exists riders;
-- Drop table if exists deliveries;


Create table customers (
	customer_id INT Primary key,
	customer_name varchar(25),
	reg_date DATE
);

create table restaurants (
	restaurant_id INT Primary Key,
	restaurant_name varchar(60),
	city varchar(15),
	opening_hours varchar(55)
);


create table orders (
	order_id INT Primary Key,
	customer_id INT, --this is coming from customers table
	restaurant_id INT,  --this is coming from restaurants table
	order_item varchar(55),
	order_date date, 
	order_time time,
	order_status varchar(55),
	total_amount float
	
);

create table riders (
	riders_id INT Primary Key,
	riders_name varchar(55),
	sign_up date
);


create table deliveries (
	delivery_id int Primary Key,
	order_id int, -- this is coming from orders table.
	delivery_status varchar(35),
	delivery_time time,
	riders_id int, -- this is coming from riders table.
	Constraint fk_orders foreign key (order_id) references orders(order_id),
	Constraint fk_riders foreign key (riders_id) references riders(riders_id)
);
