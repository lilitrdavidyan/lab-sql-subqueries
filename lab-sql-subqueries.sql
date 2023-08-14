USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
    COUNT(*)
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
    title, length
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film)
ORDER BY length;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 
    actor_id, last_name, first_name
FROM
    actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'))
ORDER BY last_name;

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT 
    film_id, title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id = (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
-- 5.1 Using subquery.

SELECT 
    last_name, first_name,  email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id = (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')))
ORDER BY last_name;

-- 5.2 Using joins.
SELECT 
    c.last_name, c.first_name, c.email
FROM
    customer c
        JOIN
    address a USING (address_id)
        JOIN
    city ci USING (city_id)
        JOIN
    country co USING (country_id)
WHERE
    co.country = 'Canada'
ORDER BY c.last_name;

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id 
-- to find the different films that he or she starred in.

SELECT 
    title
FROM
    film 
WHERE
    film_id IN (
        SELECT 
            film_id 
        FROM 
            film_actor
        WHERE 
            actor_id = (
                SELECT 
                    actor_id
                FROM
                    film_actor
                GROUP BY actor_id
                ORDER BY COUNT(film_id) DESC
                LIMIT 1
            )
    )
ORDER BY title;

-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, 
-- i.e., the customer who has made the largest sum of payments.

SELECT 
    title
FROM 
    film 
WHERE 
    film_id IN (
        SELECT 
            film_id
        FROM 
            inventory 
        WHERE 
            inventory_id IN (
                SELECT 
                    inventory_id
                FROM 
                    rental
                WHERE 
                    customer_id = (
                        SELECT 
                            customer_id 
                        FROM 
                            payment 
                        GROUP BY 
                            customer_id 
                        ORDER BY 
                            SUM(amount) DESC 
                        LIMIT 1
                    )
            )
    )
ORDER BY title;

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.
SELECT 
    customer_id, SUM(amount) AS total_amount_spent
FROM
    payment
GROUP BY customer_id
HAVING total_amount_spent > (SELECT 
        AVG(total_amount)
    FROM
        (SELECT 
            SUM(amount) AS total_amount
        FROM
            payment
        GROUP BY customer_id) AS sums)
ORDER BY total_amount_spent;


