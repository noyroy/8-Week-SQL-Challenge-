use pizza_runner;

-- 1.  If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

SELECT
	SUM(CASE
			WHEN pizza_id = 1 THEN no_of_pizza * 12
			ELSE no_of_pizza * 10
		END) as money_made
FROM
	(SELECT pizza_id, COUNT(pizza_id)no_of_pizza
	FROM customer_orders co
	INNER JOIN runner_orders ro ON co.order_id = ro.order_id
	WHERE ro.distance IS NOT NULL
	GROUP BY pizza_id) as temptamble
	;



-- 2. What if there was an additional $1 charge for any pizza extras?

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

) AS temmptable;




-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

DROP TABLE IF EXISTS Runner_Rating;
CREATE TABLE Runner_Rating (
order_id INT,
runner_id INT,
customer_rating FLOAT,
CHECK(customer_rating >= 0 AND customer_rating <= 5),
customer_comment VARCHAR(255))
;

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

SELECT * from Runner_Rating;

/*4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas
*/

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



-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

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
