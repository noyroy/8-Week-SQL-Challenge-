# B. Runner and Customer Experience


### 01. How many runners signed up for each 1 week period?

````sql
SELECT 
    DATEPART(wk,registration_date) Week_Number
    ,COUNT(*) no_of_runners
FROM runners
GROUP BY DATEPART(wk,registration_date);
````
![image](https://user-images.githubusercontent.com/103337379/162602648-d9079e3e-59d0-4bc3-9dca-c28fe44dbef2.png)


### 02. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
SELECT  
    AVG(DATEDIFF(MINUTE,c.order_time,r.pickup_time)) average_pickup_time
FROM customer_orders c
INNER JOIN runner_orders r ON c.order_id = r.order_id
WHERE r.cancellation IS NULL;
````

![image](https://user-images.githubusercontent.com/103337379/162602738-47c1c3ee-391b-41ca-9bce-5c4cdc4ceb01.png)


### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

````sql
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
````
![image](https://user-images.githubusercontent.com/103337379/162602842-5f7c881f-f44e-4a93-9fa5-82fed1dab225.png)


##### *For most cases the preparation time is directly proportional with the time taken.*


### 4. What was the average distance travelled for each customer?

````sql
SELECT  c.customer_id
       ,ROUND(AVG(CAST(r.distance AS FLOAT)),2) AS Average_Distance
FROM customer_orders c
INNER JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY  c.customer_id ;
````

![image](https://user-images.githubusercontent.com/103337379/162602884-bf763150-3dcb-4a35-a681-339d6d2a8ae2.png)


### 5. What was the difference between the longest and shortest delivery times for all orders?

````sql
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

SELECT  
    MAX(total_time_taken) - MIN(total_time_taken) AS TIME_DELTA
FROM preparing_time;
````

![image](https://user-images.githubusercontent.com/103337379/162602904-9fb4ea93-a860-4e49-8e73-9a3548309818.png)


### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

````sql
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


SELECT  
        order_id
       ,runner_id
	   ,distance
       ,AVG(speed) AS average_speed	  
FROM cte
GROUP BY  
          order_id
         ,runner_id
		 ,distance
ORDER BY average_speed DESC;
````

![image](https://user-images.githubusercontent.com/103337379/162603011-38bc18a6-a841-46e8-aef3-ecb89c8c99f4.png)


##### *Runner 2 drives much more aggressively compared to the rest.*
##### *Remaining two drives on an agerage speed.*


### 7. What is the successful delivery percentage for each runner?


##### *All of of the runners have completed their deliveries successfully. The cancelled orders are beyond their scope of action.*

##### *But here is the solution.*
````sql
SELECT 
    runner_id 
    ,COUNT(*) AS Total_orders , 
    SUM(CASE 
            WHEN distance IS NOT NULL THEN 1 ELSE 0 END) AS Completed_orders,
    CAST(SUM(CASE 
                WHEN distance IS NOT NULL THEN 1 ELSE 0 END)
    AS FLOAT)/COUNT(*)*100 AS completion_rate
FROM runner_orders
GROUP BY runner_id;
````

![image](https://user-images.githubusercontent.com/103337379/162603059-02744c69-2b0e-44d0-b5d4-a595d4bdbbd9.png)
