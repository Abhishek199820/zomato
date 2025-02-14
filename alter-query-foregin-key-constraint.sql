-- Alter Query to add constraint
ALTER Table orders
Add constraint fk_customers
foreign key (customer_id)
references customers(customer_id)


ALTER Table orders
Add constraint fk_restaurants
foreign key (restaurant_id)
references restaurants(restaurant_id)