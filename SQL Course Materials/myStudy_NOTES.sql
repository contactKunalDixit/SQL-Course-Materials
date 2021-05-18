USE sql_store;  -- Choosing the dataBase to work with 


-- ************		Module 1: Retreiving data from a SINGLE Table	*****************

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
    -- Here above, we also see the and clause being used
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


-- ************		Module 1: Retreiving data from MULTIPLE Tables	*****************ALTER

-- 11	** NEW TOPIC: Inner Joins within the DATABASE

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
        
        -- Here in, since there is composite primary key, thus, there are multiple conditions to JOIN the tables too