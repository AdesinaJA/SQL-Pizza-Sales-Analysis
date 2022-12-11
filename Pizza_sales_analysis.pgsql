/* Find the total number of orders made by the company */

SELECT COUNT(order_id) AS total_no_of_orders FROM ORDERS;

-- Calculate the total cost of each pizza type sold irrespective of size

SELECT DISTINCT pizza_type_id, SUM(price) as price FROM pizzas GROUP BY pizza_type_id;

-- GET TOP 5 Pizza types sold by price

SELECT DISTINCT pizza_type_id, SUM(price) as price FROM pizzas GROUP BY pizza_type_id ORDER BY price DESC LIMIT 5;

-- Total number of pizza ordered

SELECT COUNT(pizza_id) AS total_no_of_pizzas_ordered FROM order_details;

-- Sizes of pizza available and number of pizzas ordered for each size

SELECT DISTINCT pizzas.size AS size_of_pizzas, COUNT (order_details.quantity) AS quantity_ordered
FROM pizzas 
LEFT JOIN order_details 
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size;

-- Type of pizza ordered and the qantity ordered

SELECT pizzas.pizza_type_id, SUM(order_details.quantity) AS number_of_pizza
FROM pizzas
LEFT JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY number_of_pizza DESC;

-- Number of pizzas sold in each month and which month has the highest number of pizza sales

with cte AS(
            SELECT order_id, EXTRACT(MONTH FROM date) AS month, EXTRACT(DATE FROM date) as day
            FROM orders)
SELECT cte.month, COUNT(order_details.order_id) AS number_of_pizzas_sold
FROM order_details
LEFT JOIN cte
ON order_details.order_id = cte.order_id
GROUP BY cte.month
ORDER BY cte.month;

-- Number of orders made in each month of 2015

WITH cte AS(
			SELECT order_id, EXTRACT(MONTH FROM date) as month, EXTRACT(DATE FROM date) as day
			FROM orders)
SELECT month, COUNT(order_id) AS no_of_orders
FROM cte
GROUP BY month
ORDER BY month;

-- Number of orders made in each quarter of 2015

WITH cte AS(
			SELECT order_id, EXTRACT(MONTH FROM date) as month, EXTRACT(DATE FROM date) as day, EXTRACT(QUARTER FROM date) AS Quarter
			FROM orders)
SELECT Quarter, COUNT(order_id) AS no_of_orders
FROM cte
GROUP BY Quarter
ORDER BY Quarter;

-- Number of pizzas sold in each quarter

with cte AS(
            SELECT order_id, EXTRACT(MONTH FROM date) AS month, EXTRACT(DATE FROM date) as day, EXTRACT(QUARTER FROM date) AS quarter
            FROM orders)
SELECT cte.quarter, COUNT(order_details.order_id) AS number_of_pizzas_sold
FROM order_details
LEFT JOIN cte
ON order_details.order_id = cte.order_id
GROUP BY cte.quarter
ORDER BY cte.quarter;

-- Categories of Pizza and the number of orders for each category

WITH cte AS (
			SELECT order_details.order_id, order_details.pizza_id, order_details.quantity, pizzas.pizza_type_id
			FROM order_details
			LEFT JOIN pizzas
			ON order_details.pizza_id = pizzas.pizza_id)
SELECT pizza_types.category, COUNT(cte.quantity) as no_of_orders
FROM pizza_types
LEFT JOIN cte
ON pizza_types.pizza_type_id = cte.pizza_type_id
GROUP BY pizza_types.category
ORDER BY no_of_orders DESC;

/*
SELECT time,
CASE 
	WHEN time >= '09:00:00' AND time < '12:00:00' THEN 'morning'
	WHEN time >= '12:00:00' AND time < '16:00:00' THEN 'afternoon'
	WHEN time >= '16:00:00' AND time < '20:00:00' THEN 'evening'
	ELSE 'night'
END
FROM orders;
*/

-- Total Revenue in a calendar year

SELECT SUM(price) AS total_revenue_generated
FROM
(SELECT o.pizza_id, size, p.price
FROM order_details AS o
INNER JOIN pizzas AS p
ON o.pizza_id = p.pizza_id) AS price_total;

-- Revenue generated in each month

with cte AS(
        SELECT order_id, EXTRACT(MONTH FROM date) AS month, EXTRACT(DATE FROM date) as day, EXTRACT(QUARTER FROM date) AS quarter
        FROM orders)
SELECT cte.month, SUM(price_total.price) AS total_revenue_generated_per_month
	FROM
	(SELECT o.order_id, o.pizza_id, size, p.price
	FROM order_details AS o
	INNER JOIN pizzas AS p
	ON o.pizza_id = p.pizza_id) AS price_total
	INNER JOIN cte
	ON cte.order_id = price_total.order_id
	GROUP BY cte.month
	ORDER BY cte.month;
