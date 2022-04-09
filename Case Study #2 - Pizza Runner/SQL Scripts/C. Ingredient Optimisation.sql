USE pizza_runner;

-- Splitting toppings into indiviual rows (The input MUST be in VARCHAR Datatype)

SELECT pizza_id, value 
INTO temptable
FROM pizza_recipes
CROSS APPLY string_split(CAST(toppings as  varchar),',');

SELECT * FROM temptable;

UPDATE temptable
SET [value] = CAST([value] as INT); -- Previously count was posting incorret value.



-- 1. What are the standard ingredients for each pizza?

SELECT CAST(topping_name as VARCHAR) Items
FROM temptable t
INNER JOIN pizza_toppings pt
ON t.[value] = pt.topping_id
GROUP BY CAST(topping_name as VARCHAR)
HAVING COUNT(*) > 1



-- 2. What was the most commonly added extra?

SELECT topping_name as most_common_topping
FROM pizza_toppings
WHERE topping_id  in    (SELECT  value
                        FROM  customer_orders
                        CROSS APPLY string_split(extras,',')
                        WHERE [value]>=1
                        GROUP BY [value]
                        HAVING count(*)>1)


-- 3. What was the most common exclusion?

SELECT Value as Ingredient_ID, COUNT(value)no_of_times_excluded
FROM  customer_orders co
CROSS APPLY string_split(exclusions,',') s
GROUP BY Value
ORDER BY no_of_times_excluded desc;




/*4. Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/


SELECT order_id,pizza_id, 
CASE 
	WHEN pizza_id = 1 and exclusions like '%[3]%' THEN 'Meat Lovers - Exclude Beef'
	WHEN pizza_id = 1 and extras like '%[1]%' THEN 'Meat Lovers - Extra Bacon'
	WHEN pizza_id = 1 and exclusions like '%[14]%' and  extras like '%[69]%' THEN 'Exclude Cheese, Bacon - Extra Mushroom, Peppers'
	WHEN pizza_id = 1 THEN 'Meatlover'
	ELSE 'vegan' 
END AS pizza_label
FROM customer_orders;

-- 5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredientsFor example: "Meat Lovers: 2xBacon, Beef, ... , Salami"


-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
