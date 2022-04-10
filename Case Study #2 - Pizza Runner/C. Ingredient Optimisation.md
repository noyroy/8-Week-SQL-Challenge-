# C. Ingredient Optimisation


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
