USE sql_store;  -- Choosing the dataBase to work with 


-- ************		Module 1: Retreiving data from a SINGLE Table	*****************

-- TOPICS:
		-- 1.	The SELECT statement/ clause
        -- 2.	The Where clause
        -- 3.	The AND, OR and NOT operators
        -- 4.	The IN Operator
        -- 5. 	The Between Operator
        -- 6.	The LIKE Operator
        -- 7.	The REGEXP Operator
        -- 8.	The IS NULL Operator
        -- 9.	The Order BY clause
        -- 10.	The LIMIT clause
        
        

-- 1 ** NEW TOPIC: SELECT statement or clause 
(SELECT 
    customer_id,
    first_name,
    last_name,
    state,
    points,
    (points + 10) * 100 AS 'Discount factor'
    -- Observe: the use of 'AS'. it gives the alias name to a new column 
FROM
    customers);

-- Another e.g. of alias "AS"
 (SELECT 
    product_id,
    name,
    unit_price,
    unit_price * 1.1 AS 'new price'         
    -- The 'AS' is used to give an alias name to a new column 
FROM
    products);
    
-- 2 **   NEW TOPIC: E.g. of "where" clause
 (   SELECT 
    *
FROM
    customers
WHERE
    -- points > 3000
    -- and state = 'tx'
    -- Here above, we also see the 'and' conditions being used
-- state ='tx' could also have been 'TX' and would ve given the same result. This means the search criteria is not case sensitive. 
-- state != 'tx' would bring the ALL the results which dont have a state value as 'tx'. EITHER USE != OR <> 

    birth_date > '1990-01-01'
    -- data can be sorted for dates too. NOTE: the dates are always in quotes while defining conditions  
    );
 
 -- Another e.g. to GET THE ORDERS PLACED THIS YEAR from the table 'orders'
 (SELECT 
    *
FROM
    orders
WHERE
    order_date > '2019-01-01');
 
 
 
 -- 3 ** NEW TOPIC: The AND, OR or NOT Operators
 
(SELECT *
FROM 
	customers
WHERE
	 NOT(birth_date > '1990-01-01' or points > 1000));  -- This is equivalent to WHERE (birth_year<='1990-01-01' AND points <=1000)
    
     -- The 'AND' operator is used to add multiple conditions. ALL the conditions should be true
     -- The 'OR' operator is used when either of the multiple condition suffices.(or in other words, atleast one of the conditions is true) 
     -- The AND operator has higher precedence thatn OR and is evaluated first between the two. You can and should use the brackets to make the code cleaner and readable
     -- The 'NOT' operator is used to negate the condition. 
     -- The below 2 statements are ABSOLUTELY same 
     -- WHERE NOT(birth_date>'1990-01-01' OR points > '1000' AND state = 'VA') 
     -- WHERE (birth_date <='1990-01-01' AND points <= '1000' OR state != 'VA')
     
     
    -- EXERCISE: 
    -- From the order_items table, get the items:
    -- for order #6
    -- where the total price is greater than 30
    
   ( SELECT *
    FROM order_items
    WHERE order_id = 6 AND (quantity*unit_price>30) );
    
    -- 4  ** NEW TOPIC : The 'IN' Operator  - Used in instead or multiple OR conditions
    
    -- Find customers who live either in 'VA', 'GA', 'FL'
    -- We can either do : WHERE state = 'VA' OR state = 'GA' OR state = 'FL' 
    -- but CANNOT do WHERE state = 'VA' OR 'GA' OR 'FL'
    -- The shorter syntax for above multiple conditions is 
    -- WHERE state IN ('VA', 'GA', 'FL')
    -- So use 'IN' operator when you need to compare an attribute with a list of values.
    
   ( SELECT *
    FROM customers
    -- WHERE state = 'VA' OR state = 'GA' OR state = 'FL'    		-- OR a shorter syntax below --
    WHERE state IN ('VA','GA', 'FL'));
    -- in case you'd like to search for all records which are values except the 3 stated above, use below syntax:
    -- WHERE state NOT IN ('VA', 'GA', 'FL')
    
    -- EXERCISE
    -- Return products with
    -- quantity instock equal to one of these values - 49,38,72
    
    (SELECT *
    FROM products
    WHERE quantity_in_stock IN (49,38,72));
    
    -- 5 ** NEW TOPIC : The 'BETWEEN' Operator
    -- 'BETWEEN' operator is used when we need to define a range which qualifies for a condition
    
    (SELECT *
    FROM customers
    -- WHERE points >=1000 AND points <=3000    -- We can rewrite this expression as below using 'BETWEEN' operator. Both mentioned values will be inclusive
    WHERE points BETWEEN 1000 AND 3000	);		-- Both the values are inclusive 
    
    -- Exercise:
    -- Return customers born between 1/1/1990 and 1/1/2000
    
    (SELECT *
    FROM customers
    WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01');
     
    
    -- 6 ** NEW TOPIC  : The 'LIKE' Operator
    -- Retirve rows aka records that match specific string patterns.
    -- WHERE last_name LIKE 'b%' 	- means last names that start with letter 'b' and '%' means any number of characters.
    -- b% - means any no. of characters string after 'b'
    -- %brush% - means any number of character strings before or after 'brush' 
    -- %bru - means any number if characters strings before the character string 'bru'
    
    -- ANOTHER SEARCH CHARACTER is '_'. '_y' means it'll bring all those last names which are exactly ...
    -- ... 2 letters long, with the first character being any letter BUT the last letter being 'y'.
    
SELECT 
    *
FROM
    customers
WHERE
    last_name LIKE 'b%';
    
    -- -- WHERE last_name LIKE '_____y' 	----
    
    -- Exercise:
    -- Situation1: Get the cust0mers whose Address contains Trail or aveanue
    -- Situation2: Phone numbers end with 9
    
    SELECT 
    *
FROM
    customers
WHERE
    address LIKE '%trail%'
        OR address LIKE '%avenue%';

     -- where phone like '%9' 
    
    
-- 7  ** NEW TOPIC  : The 'REGEXP' Operator
        -- 'REGEXP' is the newer alternative to the above 'LIKE' operator
        -- 'REGEXP' is short for Regular Expression which is extremely powerful for searching for string expression
        -- with REGEXP, you can rewrite the above expression as REGEXP 'field', without the use of '%'
        
SELECT 
    *
FROM
    customers
WHERE
    -- last_name REGEXP 'field|mac|rose'		-- is same as 	last_name LIKE '%field%'
    last_name REGEXP '[a-h]e';
    
    -- The REGEXP has certain charaters that we can make use of to make our search more precise. The same options are not available in the 'like' operator
   
   -- special REGEXP Characters
    -- ^ carrot character - indicate the Begining of the string. e.g. '^field' would mean that the last _name should start with string pattern 'field' 
    -- $ dollar character - indicate the END of the string. e.g. 'field$' would bring back the results where last_name ends with 'field'
    -- | pipe character - acts as logical 'OR'. e.g. WHERE last_name REGEXP 'field|mac|rose' means search out results which have either 'field' OR 'Mac' OR 'rose' in the last name.
    -- Thus you can have WHERE last_name REGEXP '^field|mac$|rose' means: those last_names, which have either field at the start, OR are ending with Mac at the end, OR have 'rose' anywhere appearing. 
    -- WHERE REGEXP '[gem]e' would bring all the last_names which have either ge, or ee or me appearing anywhere within
    -- WHERE REGEXP 'e[gem]' would bring all the last_names which have either eg, ee, em apppearing within
	-- WHERE REGEXP '[a-h]e' would bring all the last_names which have ae,be,ce, de,ee,fe,ge,he. Thus we dont need to explicitely write all these combinations
    -- WHERE REGEXP 'e[a-h]'  - results all options with ea,eb,ec,ed,ee,ef,eg,eh
    
    -- EXERCISE:
    -- Get the customers whose: 
			-- First names are elka or Ambur
            -- last names end with EY or ON
            -- last names start with MY or contains SE
            -- last names contain B followed by R or u
            
(SELECT 
    *
FROM
    customers
WHERE
    -- first_name REGEXP 'elka|ambur'
    -- last_name REGEXP 'EY$|ON$'
    -- last_name REGEXP '^my|se'
    last_name REGEXP 'B[r|u]' 			-- Another alternative is lst_name REGEXP 'br|bu' or 'b[ru]'
    );
    
    
    
    -- 8	** NEW TOPIC: The IS NULL Operator: to find missing values
 
 -- IS NULL helps us search for a record that miss an attribute
 -- WHERE phone is NULL  ***OR*** WHERE phone is NOT NULL 
 
 (SELECT 
    *
FROM
    customers
WHERE
    phone IS NULL
 );
    
    -- EXRECISE: Get the orders that have not been shipped. refer table orders
    (SELECT 
    *
FROM
    orders
WHERE
    shipped_date IS NULL
        OR shipper_id IS NULL);
        
        
        
-- 9 	** NEW TOPIC: The ORDER BY clause
-- helps to sort data in your SQL queries
-- In Relational databases, each table has one primary key and every record aka row is identified by a specific value of this column. 
-- and if nothing specified, the records are by default sorted by this primary key

(SELECT 
    *
FROM
    customers
ORDER BY first_name				-- arranges in ascending order
);

-- ORDER BY first_name DESC		-- arranges in descending order
-- ORDER BY state,first_name	-- arranges two columns in orders. first state names in ascending order, and then first_name in ascending order
-- ORDER BY state DESC, first_name	-- arranges first by state in DESCENDING order, and then by ascending order in names 

(select *
from customers
order by state DESC, first_name DESC
);

-- NOTE: One difference between MySQL and other RDBMS is that, in MySQL, we can sort data by any columns even if it is not in the SELECT clasuse or not.
-- For the rest of other RDBMS, the column needs to be mentioned in the SELECT clause for it to be used for ordering the data in a peculiar way.

-- In the below Example, we can SELECT first_name and last_name columns and then have them appear basis order of DESCENDING 'state', even if the state columns weasnt picked up by SELECT 
-- NO other RDBMS can do this. For other RDBMS, you can only order the result basis one of the coulmns that has been specified in 'SELECT' clause.
-- EXAMPLE
(SELECT 
    first_name, last_name
FROM
    customers
ORDER BY state DESC);

-- Another important distinction of using MySQL; You can have an ALIAS column added through 'SELECT' clause and then use it through 'order' clause
-- example:

(SELECT 
    first_name, last_name, 10 AS pointsUnits
FROM
    customers
ORDER BY pointsUnits , last_name);

-- EXERCISE:
-- Retrive the data whose order_id =2; and sort them by thier total price in desceding order 
(SELECT 
    *, quantity * unit_price AS total_price
FROM
    order_items
WHERE
    order_id = 2
ORDER BY total_price DESC);

-- 10 	** NEW TOPIC: The LIMIT clause:
-- The limit clause helps us to limit the no. of records that are returned in the result
-- The LIMIT cla
-- Example
(SELECT 
    *
FROM
    customers
LIMIT 3);					-- Limits the resultto first 3 data points

-- You can also use an offset here
(SELECT 
    *
FROM
    customers
LIMIT 6 , 3);			-- This will exclude aka offset the first 6 results,  and then picks the next 3 results

-- EXERCISE:
-- Get the top 3 customers, who have more points than the others
(SELECT 
    *
FROM
    customers
ORDER BY points DESC
LIMIT 3); 


-- ************		Module 2: Retreiving data from MULTIPLE Tables	*****************ALTER


-- TOPICS:
		-- 11.	The INNER JOINs
        -- 12.	Joining across databases
        -- 13.	SELF JOINs
        -- 14.	JOINING Multiple Tables
        -- 15. 	Compound JOINING Conditions
        -- 16.	Implicit JOIN syntax
        -- 17.	Outer JOINs
        -- 18.	Outer JOIN between MULTIPLE tables
        -- 19.	Self OUTER JOINs
        -- 20.	The USING clause
        -- 21.	NATURAL JOINs
        -- 22.	CROSS JOINs
        -- 23.	UNIONs

-- 11	** NEW TOPIC: INNER JOINS WITHIN THE DATABASE

-- Above, we've seen how to retrieve specific data from single table BUT in the real world, we often collect data from multiple tables

(SELECT 
    order_id, orders.customer_id, first_name, last_name
FROM
    orders
        INNER JOIN
    customers ON orders.customer_id = customers.customer_id	);		-- 'inner' in join, is optional 

-- THE ABOVE IS AN EXAMPLE OF JOINING @ TABLES FROM THE SAME DATABASE

-- There are two kinds of 'join'. Inner join VS outer join
-- By default, join is 'INNER'. Hence, we can do without specifying inner everytime. In simpler terms, writing INNER is optional.
-- By the above statement, we are telling SQL to join the table 'orders' with table 'customers' on customer_id columns from both tables.
-- This is because, both the tables do HAVE a customer_id attribute/column which also seems to be a common link.
-- The result should show all columns of table 'orders' first, followed by all the columns of table 'customers'
-- In above 'SELECT' clause, It is mandatory to specify which table's customer_id we would like MySQL to select. If we dont specify the table's name, then it leads to error 'ambiguity' 
-- Since the customer_id is same for both the tables, We can mention any table's name i.e. (orders.customer_id OR customers.customer_id) and the search result would show the same data.  
-- ALso, the error for 'ambiguity' only comes when the same named column appears in multiple different tables. If there a column you seek in the result, and it is only appearing in on of the tables, you can do WITHOUT '.' association


-- SEE THE USAGE OF ALIAS: when the tables names are being repeated frequently, we can replace the names with short aliases. Here , the table 'orders' is being given the alias 'o', and table 'customers' is being given the alias 'c'.
(SELECT 
    order_id, o.customer_id, first_name, last_name
FROM
    orders AS o
        INNER JOIN
    customers AS C ON o.customer_id = c.customer_id);
    
    -- Exercise:
    (SELECT 
    order_id, oi.product_id, name, quantity, oi.unit_price
FROM
    order_items oi
        INNER JOIN
    products AS p ON p.product_id = oi.product_id);
    
    -- NOTE: GENERAL LEARNING: unit_pricing in the order_items table is the unit price of items when the order was placed VS the unit_price in the product table is the current price right now.
    -- In this exercise, we are more concerned with seeking what was the unit_price at the time the shopping was done. Hence, choosing the oi.unit_price and NOT the p.unit_price.
    
    
    -- 12	** NEW TOPIC: JOINING ACROSS the DATABASES		- Joining tables across different databases
    -- In order to join a table from a different database, use '.' association
    
    
    (SELECT 
    *
FROM
    order_items oi
        JOIN
    sql_inventory.products AS p 					-- SEE '.' association... The '.' association is not required if the tables belong to the same database.  
    ON oi.product_id = p.product_id);
    
    
    
    -- 13	** NEW TOPIC: SELF JOINS
    -- In SQL, you can also join a table with ITSELF
    
    
    USE sql_hr;
    (SELECT 
    e.employee_id, e.first_name, mgr.first_name AS Manager
FROM
    employees AS e
        JOIN
    employees AS mgr ON e.reports_to = mgr.employee_id);
    
    -- FEW THINGS TO REMEMBER:
    -- Joining columns within the table is similar to joining columns from different tables.
    -- JUST REMEMBER to give different aliases. Assigning aliases is important, else how would you identify one set of column from its duplicate from the same table 
    -- and we need to prefix each column with an aliases in the 'SELECT' clause
    
    
    -- 14	** NEW TOPIC: JOINING MULTIPLE TABLES
    -- How to join more than two tables when writing a query
    -- In the below example, we are joining 3 tables and extracting a report out of it. Observe the use of 2 Join statements to the master resource table i.e. customers at this instance.
    -- finally ordering the entire result in ascending order of order_id
    USE sql_store;
    (SELECT 
    o.order_id,
    o.order_date,
    c.customer_id,
    c.first_name,
    c.last_name,
    os.name AS order_Status
FROM
    customers c
        JOIN
    orders o ON o.customer_id = c.customer_id
        JOIN
    order_statuses os ON o.status = os.order_status_id
    order by order_id); 
    
    -- EXERCISE: 
    -- JOIN db sql_invoicing >>payments table WITH payment_methods WITH  clients

use sql_invoicing;
(SELECT 
   cl.client_id, cl.name, py.date, py.invoice_id,py.amount,pm.name
FROM
    payments AS py 
        JOIN
    
    clients as cl
    ON  py.client_id = cl.client_id
        JOIN
    payment_methods AS pm 
    ON py.payment_method = pm.payment_method_id);

    
     
        -- 15	** NEW TOPIC: COMPOUND JOIN CONDITIONS
        -- at times, we CANNOT just use values in a single column to uniquely identify each row. This happens when the values are not unique but duplicate or repeat themselves.
        -- Thus in such cases, we make use of combinations of values from 2 or more columns together to give each row a uniue identifier 
        -- In such cases, Both the columns are treated as primary keys and together, the primary key is RE-TERMED as COMPOSITE PRIMARY KEY
        -- A composite primary key contains more than one column
        
        -- Now for joining such tables where there exists compound PRIMARY KEYS, we need to use COMPOUND JOIN CONDITIONS with keyword 'AND'
        
        -- Example:
        USE sql_store;
        
        (SELECT 
    *
FROM
    order_items oi
        JOIN
    order_item_notes oin 
    ON oi.order_id = oin.order_id
        AND oi.product_id = oin.product_id);
        
        -- Here in, since there is composite primary key, thus, coz of that, there are multiple conditions to JOIN the tables too
        
                -- 16	** NEW TOPIC: IMPLICIT JOIN SYNTAX:
                -- This is another way to retrieve data from multiple table:- without 'JOIN' ing the tables:
                
--              SELECT *
--                 from orders o
--                 join customers c
--                 on o.customer_id = c.customer_id 
                (
                SELECT *
				from orders o, customers c					-- Selecting multiple tables
                 where o.customer_id = c.customer_id);		-- 'Where' clause, followed by the condition
                
                -- DESPITE being an easy syntax to read (when compared to the 'JOIN'), this is still best avoided because, if we dont put the 'where' clause or forget to put it, this still works but leads to a problematic situation of CROSS JOIN i.e. each record of one table would be joining to all the records of another table, thus leading to wrong data results. 
                -- BUT if we use the 'JOIN' method i.e. EXPLICIT syntax, we use the keyword 'JOIN' and then have to state 'ON' wherein we can be a little more carefull of how we state the conditions, thus helping us be more vigilant and careful and better resluts. 
                
                
                
-- 17	** NEW TOPIC: OUTER JOINS:
 
 -- So far we've seen INNER JOIN and we learnt that , when 'JOIN' is being used without any mention of 'inner' or 'outer', it will be treatd as 'INNER' JOIN by default.

 
 (SELECT 
 c.customer_id,
 c.first_name,
 o.order_id 
 FROM customers c
JOIN orders o
 ON c.customer_id = o.customer_id
 ORDER BY c.customer_id
);

 -- WHY do we need to 'OUTER JOIN' ? 
 -- Inner join aka join would only return the results or records which qualify for the eligibility mentioned in the 'ON' condition. If there are options where a customer has not ordered anything, that will not be included in the results because the entry woudnt have been able to qualify for the 'ON' condition c.customer_id = o.customer_id. (i.e the customer because they havent ordered anything would NOT have any mention in the table 'orders', and hence, would be missing appearing in the results too )
 
 -- BUT what 'OUTER JOIN' would do is that it helps you specify the conditions in a better way. Through its 2 variants, LEFT or RIGHT, we can specify which table we'd like to kind of treat primary.
 
  (SELECT 
 c.customer_id,
 c.first_name,
 o.order_id 
 FROM customers c
 LEFT  JOIN orders o						-- NOTE the usage of 'LEFT' outer JOIN. All the record values in the customer_id gets accounted for, even when they wouldnt have ordered anything ever. Similary, if we mention 'RIGHT' then, the table 'order' and all the values there in the customer_id would be treated as primary and the final result would show filtered accordingly.
 
 ON c.customer_id = o.customer_id
 ORDER BY c.customer_id
);


-- EXERCISE:
-- Write a query that produces this result: JOINS products table with order_items table, so we can see how many times each product has been ordered

-- If we do an INNER join, we only would get to see the products that have been ordered, NOT how many times

(SELECT 
p.product_id,
p.name,
oi.quantity
FROM PRODUCTS p
LEFT JOIN order_items oi				-- All the records aka rows from the table 'products' would specifically get a mention 
ON p.product_id = oi.product_id);

-- All the records aka rows from the table 'products' would specifically get a mention 
-- If you just do INNER join aka join, Only the records which would have a corresponding appearence in the table 'order_items', would appear. So per the above example, INNER JOIN WOULD MISS 'SWEET PEA SPROUTS', BECAUSE IT HAS NEVER BEEN ORDERED, hence it doesnt get any mention in 'order_items' table.


-- 18	** NEW TOPIC: OUTER JOIN BETWEEN MULTIPLE TABLES:

 (SELECT 
 c.customer_id,
 c.first_name,
 o.shipper_id,
 sh.name as shipper
 FROM customers c
 LEFT JOIN orders o
 ON c.customer_id = o.customer_id
 LEFT JOIN shippers as sh
 on o.shipper_id = sh.shipper_id
 );
 
  -- As a good practice, use 'LEFT' JOIN rather than using a mix of LEFT and RIGHT JOINS 
 
 -- EXERCISE:
 -- JOIN the tables to give: order_date, order_id, first_name, shipper, status:
 
( SELECT 
    ord.order_date,
    ord.order_id,
    cus.first_name,
    sh.shipper_id,
    sh.name,
    ordsta.name
FROM
    orders AS ord
        LEFT JOIN customers cus 
    ON ord.customer_id = cus.customer_id
        LEFT JOIN shippers AS sh 
    ON ord.shipper_id = sh.shipper_id
        LEFT JOIN order_statuses AS ordsta 
    ON ord.status = ordsta.order_status_id
    order by ordsta.name);
 
-- 19	** NEW TOPIC: SELF OUTER JOINS

USE sql_hr;
(SELECT 
e.employee_id,
e.first_name,
e.last_name,
m.first_name as manager 
FROM employees as e
-- JOIN employees as m
LEFT JOIN  employees as m
ON e.reports_to = m.employee_id);

-- We've covered this example before at the time we were discussing 'SELF INNER JOIN'. the problem with this result output, is that though all the employee's manager info rightly shows as 'manager YOVONNDA',; there is NO entry for the manager itself, even though he is part of the same group.
-- This wholesome result which includes info on manager himself, is only possible through Outer Self JOIN 

-- 20	** NEW TOPIC: The 'USING' CLAUSE:

-- The 'USING' clause provides a simpler and cleaner syntax to replace the 'ON' condition clause
-- The 'USING' clause can ONLY be used when both the column names from the joined tables are the SAME.
-- IF the names are different, then keep using 'ON' clause.

USE sql_store;
(SELECT 
    o.order_id,
    c.customer_id,
    c.first_name,
    sh.name
FROM
    orders o
		JOIN
    customers c 
    -- ON o.customer_id = c.customer_id);			-- This query can be re-written as below, BUT only when the column names are the same in both the tables:
        USING (customer_id)
        
    left  JOIN shippers sh
        USING  (shipper_id));		-- Again, this can only be used because column header 'shipper_id' is common in tables "shippers" and "orders". Had it been different, we would have had to use the 'ON' clause.
        
    (SELECT *
	FROM order_items oi
	JOIN order_item_notes oin 
    ON oi.order_id = oin.order_id
	AND oi.product_id = oin.product_id );
    
    -- As we know, When there are composite primary keys being used in a table, we have to use the 'AND' clause and write the query as above. 
    -- But the same can also be better written with 'USING' clause as:
    (SELECT *
    FROM order_items oi
    JOIN order_item_notes oin
    USING(order_id, product_id)
    );
    
     -- EXERCISE:
     -- From the sql_invoicing database, Write a query to select payment from the payments table, to show: date; client; Amount; name payment method 
    
    USE sql_invoicing;
    
    (SELECT 
    p.date,
    c.name as client,
    p.amount,
    pm.name
    FROM clients c
    LEFT JOIN payments p
    USING(client_id)				-- Since both 'joined' tables have the same column name, hence clause 'USING' used.
    JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id) ;	-- Since both the joined tables have different column headers; hence clause "ON" used
    
    
    -- 21	** NEW TOPIC: The 'NATURAL JOINS':
    
    -- By 'Natural Joins',  you let the database management system decide how it should combine the two tables without explicitely stating the columns common to both of them. BUT THIS CAN LEAD TO ERROR, Hence should not be encouraged despite looking much ,ore simpler.
    
    -- E.g. 
   ( SELECT *
    FROM clients 
    NATURAL JOIN payments);
    
    -- The above looks cleaner in terms of syntax and the system hereby takes a decision by itself on how to combine different tables through common columns. Though this looks easy but should be best AVOIDED as it leaves the query maker, with very little or NO controlover how to join two different tables.
    
    
    
    -- 22	** NEW TOPIC: The 'CROSS JOINS':
    
    -- We use 'CROSS' Joins to connect every record from the first table to EVERY record in the second table. e.g.
    -- Unlike other 'JOIN' conditions discussed so far, CROSS JOIN doesnt have a 'ON' or 'USING' condition. That is because those conditions are stated to ensure each reacord from one table syncs with only a matching similar record from the other table. But in here, since we explicitely would want to 'CROSS' JOIN the tables, no such condition statements are required.
    USE sql_store; 
    (
    SELECT *
    FROM customers c
    CROSS JOIN products p
    );
    -- ANOTHER SYNTAX could be:
    (
    SELECT *
    FROM customers c, products p		-- Implicit syntax where we dont specify CROSS JOIN but produces the same result. But the explicit method above is preffered as its more clear. 
    );
    
    -- GOOD RELEVANT USE case for using 'CROSS' JOIN could be when you have one table comprising of SIZES of a shirt say smmall, Medium, large, x-large and then have another table comprising of different colors. 
    -- In such a scenario, it makes sense to use CROSS JOIN because it can help us get a report - all colors for all sizes.
        
        
   -- EXERCISE:
   -- Do a cross join between shippers and products
   -- using the implicit syntax
   -- using the Explicit syntax
   
   -- IMPLICIT SYNTAX
(SELECT 
sh.name AS shipper,
p.name AS product
    FROM shippers sh, products p);  
    
    -- EXPLICI SYNTAX
   (
   SELECT 
   sh.name AS shipper,
   p.name AS product
   FROM shippers sh
   CROSS JOIN products p
   ORDER BY shipper
   );
        
        
    -- 23	** NEW TOPIC: UNIONS:    
    
    -- Just like different variants of 'JOIN' clause can help you connect different columns through multiple tables.
    -- Similarly, UNIONs' can help you connect different 'rows' from multiple queries/ different tables. 
    -- UNION can help us combine records from multiple queries. In more simpler terms, 'UNION' helps you to combine results from 2 different queries.
    
    -- -- A string value i.e. 'Active'. This vale should appear against all records which have date after "2019-01-01". all the records qwwith previous date stamp should have 'Archived' against them in the column - "status"
    
    -- NOTE: 
    -- 1. When using 'UNION' clause, make sure that the no. of specific coulumns SELECTED should be the same for both the 'SELECT' statements. ELSe, the SQL gives an error... ERROR because, SQL would not know how to combine the different number of columns.
    -- 2. The colunmn header would be the default header name of the first queried column/s
    -- Example: These 2 queries are from the same table
    (
    SELECT 
    order_id,
    order_date,
    "ACTIVE" AS status			
    FROM orders o
    WHERE order_date >= "2019-01-01"
    UNION										-- 'UNION' clause combines the 2 queries together     
    SELECT 
    order_id,
    order_date,
    "ARCHVED" AS status			
    FROM orders o
    WHERE order_date < "2019-01-01"
    );
    
    
        -- Example: These 2 queries are from different tables:

    -- (SELECT  first_name					-- ALso, as observed before, the no. of columns mentioned in the 2 'SELECT' statements is same.
--     FROM customers c
--     UNION
--     SELECT name 
--     FROM shippers sh);
    
    
    -- EXERCISE:
    
    -- Write a query to produce the result : customer_id; first_name; points; type (refer to type details below)
    -- The 'type' column conditions: if points=<2000 = Bronze; if points>2000 AND points<3000 = Silver; If points =>3000 = GOLD
    -- Sort the result by the first_name
    
    (SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    "Bronze" AS type
    FROM customers c
    WHERE points <= 2000
    UNION
    SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    "Silver" AS type
    FROM customers c
    WHERE points >2000
    AND points <= 3000
    UNION
    SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    "Gold" AS type
    FROM customers c
    WHERE points>3000
    ORDER BY first_name);
    
    