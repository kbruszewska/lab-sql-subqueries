USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT * from inventory WHERE film_id = 439;
SELECT * from film WHERE title = 'Hunchback Impossible';

SELECT COUNT(inventory_id) FROM sakila.inventory
   WHERE film_id IN (
       SELECT film_id
       FROM sakila.film
       WHERE title = 'Hunchback Impossible'
      );

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * 
from film 
WHERE length > (SELECT AVG(length) 
				FROM film)
ORDER BY film_id ASC;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT first_name, last_name FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
	WHERE film_id IN (
       SELECT film_id
       FROM film
       WHERE title = 'Alone Trip'
      )
	)
ORDER BY last_name ASC
;

-- BONUS
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT film_id, title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
	WHERE category_id IN (
       SELECT category_id
       FROM category
       WHERE name = 'Family'
      )
	)
;

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT customer_id, first_name, last_name, email FROM customer
WHERE address_id IN (
	SELECT a.address_id 
    FROM address a 
	JOIN city c
    ON a.city_id = c.city_id
    JOIN country co
	ON c.country_id = co.country_id
	WHERE co.country = 'Canada'
	) 
    ORDER BY last_name ASC
    ;

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT title FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
WHERE fa.actor_id IN 
	(SELECT actor_id 
	FROM 
		(SELECT actor_id, COUNT(film_id) AS films_number
		FROM film_actor
		GROUP BY actor_id
		ORDER BY COUNT(film_id) DESC
        LIMIT 1
		) AS sub
	) 
;

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, 
-- i.e., the customer who has made the largest sum of payments.

SELECT title FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE customer_id = 
	(
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	ORDER BY COUNT(amount) DESC
	LIMIT 1
	) 
ORDER BY title ASC
;


-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.
