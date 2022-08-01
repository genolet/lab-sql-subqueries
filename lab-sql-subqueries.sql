USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(inventory_id) as copies_from_Hunchback_Impossible FROM sakila.film as f
JOIN sakila.inventory as i
ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible";

-- List all films whose length is longer than the average of all the films.

SELECT * from sakila.film
WHERE length > (SELECT avg(length) as avg_length from sakila.film);

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name as name, last_name as surname FROM sakila.actor
WHERE actor_id in (
	SELECT actor_id 
	FROM sakila.film as f
	JOIN sakila.film_actor as fa
	ON f.film_id = fa.film_id
	WHERE f.title = "Alone Trip");
    
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT title FROM sakila.film
WHERE film_id in (
SELECT film_id FROM sakila.category as c
JOIN sakila.film_category as fc
ON c.category_id = fc.category_id
WHERE c.name = "Family");

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 

SELECT first_name, last_name, email from sakila.customer 
WHERE address_id in (
SELECT address_id from sakila.address 
WHERE city_id in (
	SELECT city_id from sakila.city 
	WHERE country_id in (
		SELECT country_id FROM sakila.country
		WHERE country = "Canada")));

SELECT first_name, last_name, email FROM sakila.country as co
JOIN sakila.city as ci
ON co.country_id = ci.country_id
JOIN sakila.address as a
ON ci.city_id = a.city_id 
JOIN sakila.customer as cu
ON a.address_id = cu.address_id
WHERE co.country = "Canada";

-- Which are films starred by the most prolific actor? 

SELECT title FROM sakila.film as f
JOIN sakila.film_actor as fa
ON f.film_id = fa.film_id
WHERE actor_id in (
SELECT actor_id FROM (
SELECT first_name, last_name, fa.actor_id, count(film_id) FROM actor as a
JOIN film_actor as fa
ON a.actor_id = fa.actor_id
GROUP BY first_name, last_name, actor_id
ORDER BY count(film_id) Desc
LIMIT 1) as tb1);

-- Films rented by most profitable customer

SELECT title as movies_rented_by_most_prolific_customer FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
JOIN customer as c
ON r.customer_id = c.customer_id
WHERE c.customer_id in (
SELECT customer_id from (
SELECT customer_id, sum(amount) from sakila.payment 
GROUP BY customer_id
ORDER BY sum(amount) Desc
LIMIT 1) as tb1);

-- Customers who spent more than the average payments.

SELECT distinct customer_id FROM sakila.payment
WHERE amount > (SELECT avg(amount) from sakila.payment);
