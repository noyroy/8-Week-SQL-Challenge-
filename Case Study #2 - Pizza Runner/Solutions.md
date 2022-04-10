*This case study requires some data processing. Script for the same can be found here* [DML Script](https://github.com/noyroy/8-Week-SQL-Challenge-/blob/d2f24fefb7cb73d9d5bfa394247fefe23778b2a4/Case%20Study%20%232%20-%20Pizza%20Runner/Github%20Scripts/DML%20Operations.sql) *.*



> # A. Pizza Metrics


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


***
> # B. Runner and Customer Experience


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

***

> # C. Ingredient Optimisation


### 1. What are the standard ingredients for each pizza?

````sql
SELECT CAST(topping_name as VARCHAR) Items
FROM temptable t
INNER JOIN pizza_toppings pt
ON t.[value] = pt.topping_id
GROUP BY CAST(topping_name as VARCHAR)
HAVING COUNT(*) > 1
````
![image](https://user-images.githubusercontent.com/103337379/162616574-04021c0d-6432-4c62-8167-32f49cb198e6.png)



### 2. What was the most commonly added extra?

````sql
SELECT topping_name as most_common_topping
FROM pizza_toppings
WHERE topping_id  in    (SELECT  value
                        FROM  customer_orders
                        CROSS APPLY string_split(extras,',')
                        WHERE [value]>=1
                        GROUP BY [value]
                        HAVING count(*)>1);
````

![image](https://user-images.githubusercontent.com/103337379/162616586-0808bea5-3043-439d-8b0f-e7aaa1369c39.png)


### 3. What was the most common exclusion?

````sql
SELECT pt.topping_name
FROM (	SELECT value, COUNT(value) counts
		FROM customer_orders
		CROSS APPLY string_split(exclusions,',')
		GROUP BY value ) temptable
INNER JOIN pizza_toppings pt  ON pt.topping_id = temptable.value
WHERE counts =  (	SELECT  MAX(value) counts
					FROM customer_orders
					CROSS APPLY string_split(exclusions,','));
````

![image](https://user-images.githubusercontent.com/103337379/162616594-b35328f7-1d1f-4f83-806d-74e5150451a2.png)


### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
#### a. Meat Lovers
#### b. Meat Lovers - Exclude Beef
#### c. Meat Lovers - Extra Bacon
#### d. Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/

````sql
SELECT order_id,pizza_id, 
CASE 
	WHEN pizza_id = 1 and exclusions like '%[3]%' THEN 'Meat Lovers - Exclude Beef'
	WHEN pizza_id = 1 and extras like '%[1]%' THEN 'Meat Lovers - Extra Bacon'
	WHEN pizza_id = 1 and exclusions like '%[14]%' and  extras like '%[69]%' THEN 'Exclude Cheese, Bacon - Extra Mushroom, Peppers'
	WHEN pizza_id = 1 THEN 'Meatlover'
	ELSE 'vegan' 
END AS pizza_label
FROM customer_orders;
````

![image](https://user-images.githubusercontent.com/103337379/162616606-04bf8c6f-8471-4616-9368-7b6112e996ee.png)



### 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredientsFor example: "Meat Lovers: 2xBacon, Beef, ... , Salami"


### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


***

> # D. Pricing and Ratings

### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
SELECT
	SUM(CASE
			WHEN pizza_id = 1 THEN no_of_pizza * 12
			ELSE no_of_pizza * 10
		END) as money_made
FROM
	(
        SELECT pizza_id, COUNT(pizza_id)no_of_pizza
        FROM customer_orders co
        INNER JOIN runner_orders ro ON co.order_id = ro.order_id
        WHERE ro.distance IS NOT NULL
        GROUP BY pizza_id
    ) as temptamble
;
````

![image](https://user-images.githubusercontent.com/103337379/162617094-257fd917-d54b-451a-83f9-ee450f392011.png)


### 2. What if there was an additional $1 charge for any pizza extras?

````sql
SELECT order_id, (AddOn_Charge+Base_Cost) as PriceAfterAddon
FROM (
        SELECT co.order_id,
                CASE
                    WHEN pizza_id = 1 THEN 12
                    ELSE 10
                END AS Base_Cost,
                CASE	
                    WHEN extras IS NULL THEN 0
                    WHEN LEN(extras) = 1 THEN 1
                    ELSE LEN(extras)-LEN(REPLACE(extras,', ',''))
                END AS AddOn_Charge
        FROM customer_orders co
        INNER JOIN runner_orders ro ON co.order_id = ro.order_id
            WHERE ro.distance IS NOT NULL
    ) AS temmptable
;
````

![image](https://user-images.githubusercontent.com/103337379/162617116-b777f463-9609-457f-bf01-07e2141de1c5.png)



### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

````sql
DROP TABLE IF EXISTS Runner_Rating;
CREATE TABLE Runner_Rating (
    order_id INT,
    runner_id INT,
    customer_rating FLOAT,
    CHECK(customer_rating >= 0 AND customer_rating <= 5),
    customer_comment VARCHAR(255))
;

````

````sql
INSERT INTO Runner_Rating (order_id,runner_id, customer_rating,customer_comment)
VALUES
(1,1,4,'NA'),
(2,1,4.5,'NA'),
(3,1,4.5,'Nice Service'),
(4,2,3.5,'NA'),
(5,3,5,'Bro is fast'),
(6,3,NULL,NULL),
(7,2,4.5,'NA'),
(8,2,5,'noice'),
(9,2,NULL,NULL),
(10,1,5,'fast')
;
````

![image](https://user-images.githubusercontent.com/103337379/162617149-eb59fb86-0f5b-4d70-8019-246a7aaebba7.png)


### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

#### customer_id

#### order_id

#### runner_id

#### rating

#### order_time

#### pickup_time

#### Time between order and pickup

#### Delivery duration

#### Average speed

#### Total number of pizzas

````sql
SELECT 
        co.customer_id,
        co.order_id,
        ro.runner_id,
        rr.customer_rating, 
        co.order_time,
        ro.pickup_time,
        DATEDIFF(MINUTE,co.order_time, ro.pickup_time) AS time_between_order_pickup,  
        ro.distance, 
        ROUND(ro.distance/(CAST(ro.duration AS float)/60),2) AS Average_speed, 
        COUNT(*) as number_of_pizzas
FROM runner_orders ro
INNER JOIN customer_orders co 
        ON CO.order_id = ro.order_id
INNER JOIN Runner_Rating rr 
        ON rr.order_id = ro.order_id
GROUP BY    co.customer_id,
            co.order_id,
            ro.runner_id,
            rr.customer_rating, 
            co.order_time,
            ro.pickup_time,
            DATEDIFF(MINUTE,co.order_time, ro.pickup_time),  
            ro.distance, ROUND(ro.distance/(CAST(ro.duration AS float)/60),2)
;
````

![image](https://user-images.githubusercontent.com/103337379/162617161-552c2e20-a89e-4203-97ec-e6c9b34b5c0d.png)


### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?


````sql
SELECT 
        SUM(Revenue),
        SUM(Distance_cost) AS Net_Profit
FROM (
		SELECT co.order_id,ro.distance,
			CASE
				WHEN pizza_id = 1 THEN 12
				ELSE 10
			END AS Revenue,
		CAST(ro.distance AS FLOAT)*.30 AS Distance_cost
		FROM customer_orders co
		INNER JOIN runner_orders ro ON CO.order_id = ro.order_id
		WHERE ro.distance IS NOT NULL
) AS temptable
;
````

![image](https://user-images.githubusercontent.com/103337379/162617177-fe98747d-7c83-4fe5-adfe-0fd4e2031f67.png)


> ## THE END
