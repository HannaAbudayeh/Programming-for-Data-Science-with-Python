-- set 1 Q1
-- part1
SELECT 
    c.name AS "category",
    SUM(COUNT(r.rental_id)) OVER(PARTITION BY c.name) AS "total rental count"
FROM 
    category AS c
    JOIN film_category AS fc
        ON c.category_id = fc.category_id
        AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    JOIN film AS f
        ON f.film_id = fc.film_id
    JOIN inventory AS i
        ON f.film_id = i.film_id
    JOIN rental AS r
        ON i.inventory_id = r.inventory_id
GROUP BY c.name;
-- part 2 
SELECT 
    c.name AS "category",
    COUNT(DISTINCT f.film_id) AS "film count"
FROM 
    category AS c
    JOIN film_category AS fc
        ON c.category_id = fc.category_id
        AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    JOIN film AS f
        ON f.film_id = fc.film_id
GROUP BY c.name;

-- set1 Q3
SELECT t.name,
       t.standard_quartile,
       COUNT(*)
  FROM (SELECT c.name,
               f.rental_duration,
               NTILE(4) OVER(ORDER BY f.rental_duration) AS standard_quartile
          FROM category AS c
               JOIN film_category AS fc
                ON c.category_id = fc.category_id 
                AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
               JOIN film AS f
                ON f.film_id = fc.film_id) AS t
 GROUP BY t.name, t.standard_quartile
 ORDER BY t.name, t.standard_quartile;


-- set 2 Q1 
SELECT DATE_PART('month', r1.rental_date) AS rental_month, 
       DATE_PART('year', r1.rental_date) AS rental_year,
       ('Store ' || s1.store_id) AS store,
       COUNT(*)
  FROM store AS s1
       JOIN staff AS s2
        ON s1.store_id = s2.store_id
		
       JOIN rental r1
        ON s2.staff_id = r1.staff_id
 GROUP BY  rental_month, rental_year, store
 ORDER BY rental_year, rental_month;

-- set 2 Q2
WITH t1 AS (SELECT (first_name || ' ' || last_name) AS name, 
                   c.customer_id, 
                   p.amount, 
                   p.payment_date
              FROM customer AS c
                   JOIN payment AS p
                    ON c.customer_id = p.customer_id),

     t2 AS (SELECT t1.customer_id
              FROM t1
             GROUP BY 1
             ORDER BY SUM(t1.amount) DESC
             LIMIT 10)

SELECT t1.name,
       DATE_PART('month', t1.payment_date) AS payment_month, 
       DATE_PART('year', t1.payment_date) AS payment_year,
       COUNT (*) AS payment_count,
       SUM(t1.amount) AS total_amount
  FROM t1
       JOIN t2
        ON t1.customer_id = t2.customer_id
 WHERE t1.payment_date BETWEEN '20070101' AND '20080101'
 GROUP BY t1.name, payment_month, payment_year
 ORDER BY payment_year, payment_month;