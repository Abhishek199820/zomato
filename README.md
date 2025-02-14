# ZOMATO SQL PROJECT

## **Project Overview: Food Delivery Data Analytics**  

### **📌 Objective:**  
This project focuses on analyzing a food delivery dataset to extract meaningful insights about customer behavior, restaurant performance, delivery efficiency, and seasonal trends. The dataset consists of **customers, restaurants, orders, riders, and deliveries**, covering various aspects of the food ordering process in India.  

---

## **🛠️ Data Components:**  

### **1️⃣ Customers**  
- Stores customer details such as `customer_id`, `customer_name`, and other relevant information.  
- Used for analyzing **customer loyalty, order frequency, and spending habits**.  

### **2️⃣ Restaurants**  
- Stores `restaurant_id`, `restaurant_name`, `city`, and other business details.  
- Used for tracking **restaurant revenue, growth trends, and most popular dishes**.  

### **3️⃣ Orders**  
- Stores information like `order_id`, `customer_id`, `restaurant_id`, `order_item`, `order_date`, `order_time`, `order_status`, and `total_amount`.  
- Used for analyzing **popular time slots, order values, and customer preferences**.  

### **4️⃣ Riders**  
- Contains `riders_id`, `rider_name`, and `sign_up_date`.  
- Used for evaluating **rider performance and delivery efficiency**.  

### **5️⃣ Deliveries**  
- Stores `delivery_id`, `order_id`, `delivery_status`, `delivery_time`, and `riders_id`.  
- Used to **measure delivery time, efficiency, and cancellation rates**.  

---

## **📊 Key Analysis Performed:**

### **1️⃣ Order Trends & Popularity**  
- ✅ **Popular Time Slots:** Identifies the busiest ordering hours in **2-hour intervals**.  
- ✅ **Most Popular Dish by City:** Determines **top-selling dishes** across different cities.  
- ✅ **Order Item Popularity:** Tracks **seasonal demand spikes** for various dishes.  

### **2️⃣ Restaurant Performance Analysis**  
- ✅ **Order Values Analysis:** Finds **high-value customers** who place **750+ orders**.  
- ✅ **Restaurant Revenue Ranking:** Ranks **restaurants by revenue** in each city.  
- ✅ **Monthly Restaurant Growth Ratio:** Measures **monthly growth in delivered orders**.  

### **3️⃣ Delivery Performance & Efficiency**  
- ✅ **Orders Without Delivery:** Identifies **orders that were never delivered**.  
- ✅ **Delivery Efficiency:** Analyzes **average delivery time** for riders.  
- ✅ **Cancellation Rate Comparison:** Compares **cancellation rates between years** for each restaurant.  

### **4️⃣ Customer & Market Insights**  
- ✅ **Order Frequency by Day:** Identifies **peak ordering days** for each restaurant.  
- ✅ **Rider Money Collection:** Tracks **total revenue collected by each rider per month**.  
- ✅ **Customer Spending Trends:** Helps **identify high-value customers** and order behaviors.  

---

## **🔎 Business Use Cases & Impact**  

### **🎯 For Restaurants:**  
- Optimize menu offerings based on **popular dishes and seasonal demand**.  
- Improve revenue by identifying **high-value customers**.  
- Adjust staffing and inventory **based on peak order times**.  

### **🚴 For Delivery Services:**  
- Track **rider performance and efficiency**.  
- Reduce **order cancellations and delivery delays**.  
- Improve **service reliability** by analyzing customer order patterns.  

### **📈 For Market Analysts:**  
- Understand **food ordering trends in India**.  
- Identify **growth opportunities for new restaurants**.  
- Predict **future demand for different cuisines**.  

---

## **📝 Summary:**  
This project provides **actionable insights** into food ordering trends, restaurant performance, and delivery efficiency. By leveraging **SQL-based analytics**, it helps **optimize business strategies, improve customer experience, and enhance operational efficiency** for food delivery services in India. 🚀


## ERD
https://github.com/Abhishek199820/zomato/blob/main/Zomato-DB-ERD.png
