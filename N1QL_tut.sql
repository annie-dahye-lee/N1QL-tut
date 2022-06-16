--string concatenation: || " " ||
SELECT fname || " " || lname AS full_name, email AS email_address, children[0:2] AS offspring -- return fname & lname as 'full_name', return email, and return 2 children in children array 
-- array[start index:finish index]
FROM tutorial USE KEYS ['dave', 'ian'] --limit query scope to specific primary keys 
        WHERE email LIKE '%@yahoo.com' 
        OR ANY child IN tutorial.children SATISFIES child.age > 10 END -- END for every SATISFIES case
-- return only if email has '@yahoo.com' OR if primary keys dave & ian has child in 
-- tutorial.children array with child.age > 10


-- group by relations
-- t = tutorial data bucket 
-- count each number of relationships (parent, friend, cousin)
--get avg age of group
-- grouping criteria: return group when age > 10, group must have more than 1 member: COUNT(*)
-- order members of that group by decreasing age
SELECT t.relation, COUNT(*) AS num_of_relationships, AVG(c.age) AS avg_age
    FROM tutorial t
    UNNEST t.children c
    WHERE c.age > 10
    GROUP BY t.relation
    HAVING COUNT(*) > 1
    ORDER BY avg_age DESC
    LIMIT 1 OFFSET 1


-- group by name & when num of purchases > 9
-- join customers where customer's ID = foreign customer's ID, customer is in specific states, converted time is in third quarter of 2013
SELECT count(p) AS num_purchases,
          c.firstName || " " || c.lastName AS name
  FROM purchases p
        INNER JOIN customer c ON (p.customerId = META(c).id)
    WHERE c.state IN["CA", "TX", "NY"]
       AND STR_TO_MILLIS(p.purchasedAt)
           BETWEEN STR_TO_MILLIS("2013-08-01") AND STR_TO_MILLIS("2013-12-31")
       GROUP BY c.firstName || " " || c.lastName 
            HAVING count(p) > 9

-- group by product name
-- join product 
SELECT p.name, COUNT(r) as reviewCount,
   ROUND(AVG(r.rating),1) AS AvgRating
  FROM product p INNER JOIN reviews r ON (META(r).id IN p.reviewList)
    GROUP BY p.name
     HAVING COUNT(r) > 10
      ORDER BY AvgRating DESC
        LIMIT 3
