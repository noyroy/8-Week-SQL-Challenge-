use pizza_runner;

-- CUSTOMER_ORDERS table Operations


UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions = 'null' OR exclusions = ''
; --Changing the empty rows and null rows to NULL.


UPDATE customer_orders
SET extras = NULL
WHERE extras = 'null' OR exclusions = ''
; -- Same as above.


ALTER TABLE customer_orders		-- Making seperate column for the Order date.	
ADD Order_date DATE;

ALTER TABLE customer_orders		-- Same as above but for order time.
ADD Order_time2 TIME;


UPDATE customer_orders
SET Order_date =  CONVERT(DATE, order_time);		--Extracting the Date

UPDATE customer_orders
SET order_time2 =  CONVERT(TIME, order_time);		--Extracting the Time


UPDATE customer_orders								-- Replacing the blank spaces in  extras colummn with NULL values.
SET extras =  NULL
WHERE extras = ' ';  



-- RUNNER_ORDERS table Operations



SELECT * FROM runner_orders;

--First convert the empty rows or null rows to NULL

UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null' OR pickup_time = ''
; --Changing the empty rows and null rows to NULL.


UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null' OR distance = ''
; --Changing the empty rows and null rows to NULL.\


UPDATE runner_orders
SET duration = NULL
WHERE duration = 'null' OR duration = ''
; --Changing the empty rows and null rows to NULL.


UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = 'null' OR cancellation = ''
; --Changing the empty rows and null rows to NULL.




UPDATE runner_orders
SET distance  = LEFT(distance,(CAST(CHARINDEX('km',distance) as int)-1))		--  Removing km from only those columns where it is present.
WHERE RIGHT(distance,2) = 'km';		

ALTER TABLE runner_orders
ALTER COLUMN distance FLOAT;


UPDATE runner_orders
SET duration  = TRIM(LEFT(duration,(CAST(CHARINDEX('min',duration) as int)-1)))		--  Removing minutes from only those columns where it is present.
WHERE CHARINDEX('min',duration) >0;


ALTER TABLE runner_orders
ALTER COLUMN duration INT;




 -- CREATING ONE SINGLE TABLE FOR PIZZA TOPPINGS


SELECT pizza_id, value 
INTO temptable
FROM pizza_recipes
CROSS APPLY string_split(CAST(toppings as  varchar),','); -- changing the comma seperated pizza reciepies to individual rows so that we can apply join with pizza toppings.


SELECT * FROM temptable;

UPDATE temptable
SET [value] = CAST([value] as INT);


SELECT t1.pizza_id, pt.topping_id, pt.topping_name
INTO temp_pizza_ingredients
FROM temptable t1
INNER JOIN pizza_toppings pt ON t1.value = pt.topping_id		-- Creation of new consolidated temp table for pizza reciepies. 
;

ALTER TABLE temp_pizza_ingredients 
ALTER COLUMN topping_name VARCHAR(100);  -- Converting this column to varchar



ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(100); -- Converting this column to varchar
