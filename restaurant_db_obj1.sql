USE restaurant_db;

-- View the menu_items table
SELECT *
FROM menu_items;

-- Find the number of items on the menu
SELECT COUNT(item_name)
FROM menu_items;

-- What are the least and most expensive items on the menu?
SELECT *
FROM menu_items
ORDER BY price;

SELECT *
FROM menu_items
ORDER BY price DESC;

-- How many italian dishes are on the menu?
SELECT COUNT(category) AS num_italian
FROM menu_items
WHERE category='italian';

-- What are the least and most expensive italian dishes on the menu?
SELECT *
FROM menu_items
WHERE category='italian'
ORDER BY price;

-- How many dishes are in each category?
SELECT category,COUNT(item_name)
FROM menu_items
GROUP BY category;

-- What is the average dish price in each category?
SELECT category,AVG(price)
FROM menu_items
GROUP BY category;