
#1.Select the first name, last name, and email address of all the customers who have rented a movie.
USE sakila;

SELECT 
    c.first_name, c.last_name, c.email
FROM
    customer c
        RIGHT JOIN
    rental r USING (customer_id);


#2.What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT 
    p.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    AVG(p.amount) AS avg_payment
FROM
    payment p
        JOIN
    customer c USING (customer_id)
GROUP BY p.customer_id , c.first_name , c.last_name;


#3.Select the name and email address of all the customers who have rented the "Action" movies.

#3.1 Write the query using multiple join statements

SELECT concat(c.first_name, " ", c.last_name) as full_name, c.email
FROM customer c
JOIN rental r using (customer_id)
JOIN inventory i using (inventory_id)
JOIN film_category fc using (film_id)
JOIN category cat using (category_id)
WHERE cat.name = "Action";

#3.2 Write the query using sub queries with multiple WHERE clause and IN condition

SELECT 
    concat(first_name, " ", last_name) as full_name, email
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            rental
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    inventory
                WHERE
                    film_id IN (SELECT 
                            film_id
                        FROM
                            film_category
                        WHERE
                            category_id IN (SELECT 
                                    category_id
                                FROM
                                    category
                                WHERE
                                    name = 'Action'))));

#Verify if the above two queries produce the same results or not
#Yes, both queries returned 500 rows.

#4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
#If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.


SELECT 
    customer_id,
    amount,
    CASE
        WHEN amount BETWEEN '0' AND '2' THEN 'low'
        WHEN amount BETWEEN '2' AND '4' THEN 'medium'
        WHEN amount > '4' THEN 'high'
    END AS transaction_level
FROM
    payment;