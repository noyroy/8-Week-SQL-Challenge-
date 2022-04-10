use pizza_runner;


-- 01. How many runners signed up for each 1 week period?

SELECT DATEPART(wk,registration_date) Week_Number, COUNT(*) no_of_runners
FROM runners
GROUP BY DATEPART(wk,registration_date)

-- 02. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT  AVG(DATEDIFF(MINUTE,c.order_time,r.pickup_time)) average_pickup_time
FROM customer_orders c
INNER JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT  c.order_id
       ,COUNT(*) number_of_pizzas
       ,AVG(DATEDIFF(MINUTE,c.order_time,r.pickup_time)) time_taken
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.order_id
ORDER BY COUNT(*) DESC
         ,AVG(DATEDIFF(MINUTE,c.order_time,r.pickup_time)) DESC;

-- For most cases the preparation time is directly proportional with the time taken

-- 4. What was the average distance travelled for each customer?

SELECT  c.customer_id
       ,ROUND(AVG(CAST(r.distance AS FLOAT)),2) AS Average_Distance
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.customer_id ;


--5. What was the difference between the longest and shortest delivery times for all orders?


WITH preparing_time
(order_id, total_time_taken
) AS 
        (
        SELECT  c.order_id
       ,    (DATEDIFF(MINUTE,c.order_time,r.pickup_time) + r.duration) AS min_taken
        FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
        )
SELECT  MAX(total_time_taken) - MIN(total_time_taken) AS TIME_DELTA
FROM preparing_time;


-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH cte
(order_id , runner_id, speed,distance
) AS (
SELECT  c.order_id
       ,r.runner_id
       ,ROUND(r.distance/(CAST(r.duration AS float)/60),2) Speed
	   ,r.distance
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL )                   

SELECT  order_id
       ,runner_id
	   ,distance
       ,AVG(speed) AS average_speed	  
FROM cte
GROUP BY  order_id
         ,runner_id
		 ,distance
ORDER BY average_speed DESC;
         

-- runner 2 drives much more aggressively compared to the rest
-- Remaining two drives on an agerage speed


-- 7. What is the successful delivery percentage for each runner?
-- All of of the runners have completed their deliveries successfully. The cancelled orders are beyond their scope of action.

-- But here is the solution.
SELECT runner_id , count(*) as Total_orders , 
    SUM(
        CASE WHEN distance IS NOT NULL THEN 1 ELSE 0 END) as Completed_orders,
    CAST(SUM(
        CASE WHEN distance IS NOT NULL THEN 1 ELSE 0 END) as FLOAT)/COUNT(*)*100 as completion_rate
FROM runner_orders
GROUP BY runner_id;

SELECT * FROM customer_orders;
SELECT * FROM runner_orders;
SELECT * FROM pizza_names;
SELECT * FROM runners;
SELECT * FROM pizza_recipes;
