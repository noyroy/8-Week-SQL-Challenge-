### 1. How many pizzas were ordered?

````sql
SELECT  COUNT(*) pizza_ordered
FROM customer_orders;
````
![image](https://user-images.githubusercontent.com/69169400/162590147-58f2d288-0776-4aca-be06-21ae3e89de3a.png)


### 2.How many unique customer orders were made?

````sql
SELECT  COUNT(DISTINCT(order_id)) Distinct_orders
FROM customer_orders;
````
![image](https://user-images.githubusercontent.com/69169400/162590183-fb7c185a-6736-41da-a31e-5761c2cfa4a4.png)


### 3. How many successful orders were delivered by each runner?

````sql
SELECT  runner_id
       ,COUNT(*) No_of_orders
FROM runner_orders
WHERE pickup_time IS NOT NULL
AND cancellation IS NULL
GROUP BY  runner_id;
````
 
 ![image](https://user-images.githubusercontent.com/69169400/162590245-a599a9fa-eaaf-4294-b56c-0b74a2ebfb47.png)

 
 ### 4. How many of each type of pizza was delivered?
 
 ````sql
 SELECT  p.pizza_name
       ,COUNT(c.pizza_id) AS Number_of_pizzas
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
INNER JOIN pizza_names p
ON p.pizza_id = c.pizza_id
WHERE r.cancellation is NULL
GROUP BY  p.pizza_name
````

![image](https://user-images.githubusercontent.com/69169400/162590261-dc07b9cd-224c-4de1-8f12-831f6c9e2368.png)


### 5.How many Vegetarian AND Meatlovers were ordered by each customer?

````sql
SELECT  c.customer_id
       ,p.pizza_name
       ,COUNT(*) Count_of_pizza
FROM customer_orders c
INNER JOIN pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY  p.pizza_name
         ,c.customer_id;
 ````
 
 ![image](https://user-images.githubusercontent.com/69169400/162590320-8172a1e1-4b41-4c12-9755-de4e8d161885.png)
 
 
### 6.What was the maximum number of pizzas delivered IN a single order? 

````sql
SELECT MAX(Max_pizza) AS MAX_PIZZA
FROM(SELECT  c.order_id
       ,COUNT(c.order_id) as Max_pizza
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.order_id) as temptable;

````

![image](https://user-images.githubusercontent.com/69169400/162590351-77e318f1-ac8b-4f00-b02e-a596e6c1d313.png)


### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

````sql
SELECT  c.customer_id
       ,CASE 
            WHEN exclusions IS NULL AND extras IS NULL THEN 'default pizza'  ELSE 'Modified Pizza' END       AS Pizza_type
       ,COUNT(CASE 
                  WHEN exclusions IS NULL AND extras IS NULL THEN 'default pizza' ELSE 'Modified Pizza' END) AS Count
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.customer_id,CASE WHEN exclusions IS NULL AND extras IS NULL THEN 'default pizza'  ELSE 'Modified Pizza' END;
````

![image](https://user-images.githubusercontent.com/69169400/162590384-2133a13c-ea7a-4e0e-ae1f-d5753549519a.png)



### 8. How many pizzas were delivered that had both exclusions and extras?

````sql
SELECT  COUNT(*) AS No_of_pizzas
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
AND c.exclusions IS NOT NULL
AND c.extras IS NOT NULL; 
````
![image](https://user-images.githubusercontent.com/69169400/162590410-b05b705c-d393-45e3-a66e-cc59fd1af263.png)


### 9. What was the total volume of pizzas ordered for each hour of the day?

````sql
SELECT DATEPART(hh,order_time) as Hour_of_the_day, COUNT(*) as No_of_pizzas
FROM customer_orders
GROUP BY DATEPART(hh,order_time);
````

![image](https://user-images.githubusercontent.com/69169400/162590430-ed41f90b-fa95-4a6c-8483-2d056e08a1f9.png)


#### 10. What was the volume of orders for each day of the week?

````sql
SELECT DATENAME(dw,DATEPART(dw,order_time)-2) as day_of_the_week,COUNT(*) as No_of_pizzas
FROM customer_orders
GROUP BY DATENAME(dw,DATEPART(dw,order_time)-2);
````
![image](https://user-images.githubusercontent.com/69169400/162590455-44391f84-589f-43d6-829f-6cc2e88996dc.png)


