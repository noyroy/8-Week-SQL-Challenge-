use pizza_runner;


-- A. Pizza Metrics
SELECT  *
FROM customer_orders;

SELECT  *
FROM runner_orders;

       SELECT  *
       FROM pizza_names;

-- 1. How many pizzas were ordered?
SELECT  COUNT(*) pizza_ordered
FROM customer_orders;

-- 2.How many unique customer orders were made?
SELECT  COUNT(DISTINCT(order_id)) Distinct_orders
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT  runner_id
       ,COUNT(*) No_of_orders
FROM runner_orders
WHERE pickup_time IS NOT NULL
AND cancellation IS NULL
GROUP BY  runner_id;

-- 4. How many of each type of pizza was delivered?
-- The pizza_name column IN PIZZA_NAME TABLE is stored IN text data type. this needs to be modified to varchar before running the below query. ref. https://stackoverflow.com/questions/14979413/the-text-ntext-and-image-data-types-cannot-be-compared-or-sorted-except-whe

SELECT  p.pizza_name
       ,COUNT(c.pizza_id) AS Number_of_pizzas
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
INNER JOIN pizza_names p
ON p.pizza_id = c.pizza_id
WHERE r.cancellation is NULL
GROUP BY  p.pizza_name;

-- 5. How many Vegetarian AND Meatlovers were ordered by each customer?

SELECT  c.customer_id
       ,p.pizza_name
       ,COUNT(*) Count_of_pizza
FROM customer_orders c
INNER JOIN pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY  p.pizza_name
         ,c.customer_id;

-- 6.What was the maximum number of pizzas delivered IN a single order? 

SELECT MAX(Max_pizza)AS MAX_PIZZA
FROM(SELECT  c.order_id
       ,COUNT(c.order_id) as Max_pizza
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.order_id) as temptable;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT  c.customer_id
       ,CASE WHEN exclusions IS NULL AND extras IS NULL THEN 'default pizza'  ELSE 'Modified Pizza' END       AS Pizza_type
       ,COUNT(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 'default pizza' ELSE 'Modified Pizza' END) AS Count
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.customer_id,CASE WHEN exclusions IS NULL AND extras IS NULL THEN 'default pizza'  ELSE 'Modified Pizza' END;



-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT  COUNT(*) AS No_of_pizzas
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
AND c.exclusions IS NOT NULL
AND c.extras IS NOT NULL; 


-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT DATEPART(hh,order_time) as Hour_of_the_day, COUNT(*) as No_of_pizzas
FROM customer_orders
GROUP BY DATEPART(hh,order_time);


-- 10. What was the volume of orders for each day of the week?

SELECT DATENAME(dw,DATEPART(dw,order_time)-2) as day_of_the_week,COUNT(*) as No_of_pizzas
FROM customer_orders
GROUP BY DATENAME(dw,DATEPART(dw,order_time)-2);

SELECT * FROM customer_orders;
SELECT * FROM runner_orders;
SELECT * FROM pizza_names;


SELECT DATENAME(dw,DATEPART(dw,order_time)-2), order_time
from customer_orders