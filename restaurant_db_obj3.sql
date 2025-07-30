SELECT *
FROM menu_items;

SELECT * 
FROM order_details;

-- Combine the menu_items table and order_details table into a single table
SELECT *
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id=mi.menu_item_id;

-- What were the least and most ordered itmes? what category were they in?
SELECT item_name,category,COUNT(item_name)
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id=mi.menu_item_id
GROUP BY item_name,category
ORDER BY COUNT(item_name) DESC;

-- What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spent
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id=mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC
LIMIT 5;

-- View the details of highest spent order
SELECT *
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id=mi.menu_item_id
WHERE order_id=440;

-- View the details of the top 5 highest spent orders
SELECT order_id,category,COUNT(item_id) AS num_items
FROM order_details AS od
LEFT JOIN menu_items AS mi
ON od.item_id=mi.menu_item_id
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY order_id,category;

