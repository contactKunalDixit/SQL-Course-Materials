-- ..............................................COntinued from myStudy_Notes-1

USE sql_store;  -- Choosing the dataBase to work with 


-- ************		Module 3: Inserting, Updating and Deleting Data	(within rows )*****************

-- TOPICS:
		-- 24.	Column Attributes
        -- 25.	Inserting a row
        -- 26.	Inserting Multiple rows
        -- 27.	Inserting Hierarchical rows
        -- 28. 	Creating a copy of a table
        -- 29.	Updating a Single row
        -- 30.	updating Multiple rows
        -- 31.	Using subqueries in updates
        -- 32.	Deleting Rows 
        -- 33.	Restoring the databases
        

-- 24 ** NEW TOPIC: Column Attributes

-- PN: Primary key: Unique attribute that gives a unique identity to each row aka record
-- NN: Not NULL: 	The value of such attribute CAN NOT be left NULL. The valuse is MANDATORY
-- AI: Auto Increment: The value of this attribute increases by 1
-- Default/ Expression: The default values that will be used if no NEW value is provided to the table

-- 25 ** NEW TOPIC: Inserting a ROW:			"INSERT INTO" Statement

-- You can insert the actual desired value or 'DEFAULT' to let SQL decide the default value that it'll enter.
	
INSERT INTO customers
VALUES (
DEFAULT,
'Kunal',
'Dixit',
'1982-08-16',
NULL,						-- In this case, since the default value has already been assigned as 'NULL' in the table config aka table defination, Thus either explicitely state 'NULL' or specify 'DEFAULT', which in this case will again assign 'NULL' because default value is 'NULL' --refer to table config
"address",
"city",
"CA",
DEFAULT
);


SELECT *
from customers;

-- Another syntax for adding a row:
-- With this new Syntax, we DO NOT need to state the default values
INSERT INTO customers(
first_name,
last_name,
phone,
address,
city,
state
)
values(
"Champu",
"DIXIT",
123-456,
"address",
"city",
"DL");

-- 26 ** NEW TOPIC: Inserting MULTIPLE ROWS :			

 -- Insert three rows in the product table;
INSERT INTO shippers (name)
VALUES 
('shipper1'),
('shipper2'),
('shipper3');

SELECT *
FROM shippers;

-- EXERCISE:
-- Insert three rows in the products table:
 
 INSERT INTO products (name, quantity_in_stock,unit_price)
 VALUES ('Chattu Amaira', 50, 9.34),
		('Amu AMaira', 99, 5.5),
		('Chattu Pai', 56, 67.9899);
 
 
 
-- 27 ** NEW TOPIC: Inserting HIERARCHICAL ROWS :	
 
 -- i.e. inserting a row in one parent table and getting it updated automatically synced in the child tables

-- Till now,we have learnt how to insert data into single table, But this module will teach us how to insert a data piece in multiple tables (parent/ child tables)
-- 1 step: 		Determine parent-child relationship 
-- 2			Insert INTO 'parent' table
-- 3			Use inbuilt function 'last_insert_id()' to auto track the order_id that would've been generated the moment, a new record was added in the parent table. The fubction in a way acts like a variable that holds the value of the last generated ID which eventually then can be used further in the child table. 



INSERT INTO orders(customer_id, order_date, status)			-- Adding new row in the parent table
VALUES (1,'2020-08-16',2);

INSERT INTO order_items										-- Adding a new row in the 'child' table with the just generated common ID, being tracked through function last_insert_id()
VALUES	(last_insert_id(),2,34,2.22),
		(last_insert_id(),3,23,1.18);



 -- 28 ** NEW TOPIC: Creating a COPY of a table :	
 
 -- How to copy data from one table to another
 -- Create a duplicate of table 'order' and named it 'orders_archived'
 
 CREATE TABLE orders_archived AS		-- 'Create table' statement
	SELECT * from orders;				-- IN here, the SELECT statement is being used as a SUB QUERY. It is so called because 'SELECT' statement here is a pert of another SQL statement, and NOT the indipendent statement as it has been seen in all the casesso far.


-- NOTE:
-- This is a powerful way to create a duplicate copy of a table.
-- When using above method, make sure you visit the table defination page and MANUALLY select the PRIMARY KEY and auto increment as mySQL would not be copying these attributes even if they would have been present in the original file. 

 -- Another example: from table 'orders', select all records with order_date before 1 Jan 2019, and put the records in another table 'orders_archived'
	-- This'll make a perfect case for using a SELECT as a subQuery but this time, with the INSERT INTO statement, (since the table into which the records are to be added has already been created through 'CREATE TABLE' statement above.)
    
    INSERT INTO orders_archived
    SELECT *						
    FROM orders
    WHERE order_date < '2019-01-01';
    
    -- EXERCISE:
    -- Refer to sql_invoicing database, table 'invoices'; 
    -- Create a new table 'invoices_archived' and copy the data from table 'invoices' but copy only those records which have a payment_date as existing i.e. NOT NULL
    -- also in the new duplicate table, instead of client_id, add the names of the clients
    
    -- One effeciet way to work on such queries is to work on the sub Query forst and then move on 'CREATE TABLE' statement:
    
    USE sql_invoicing; 
    
    CREATE TABLE invoices_archived AS
    (SELECT 
    i.invoice_id, 
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
    
    FROM invoices i
    JOIN clients c
    using(client_id)
    WHERE payment_date IS NOT NULL
    );
    
    
-- 29 ** NEW TOPIC: UPDATING A SINGLE ROW :
     
     -- Update statement followed by a table name
     -- SET new values
     -- WHERE conditions
     
     UPDATE invoices
     SET payment_total = 10, payment_date = '2021-01-01'
     WHERE invoice_id =1;
     
     
     -- The above can also be reversed by :
     
     UPDATE invoices
     SET payment_total = 0, payment_date = NULL
     WHERE invoice_id = 1;

-- SET statement also accepts mathematical expressions...e.g. 

UPDATE invoices
SET payment_total = invoice_total /2, payment_date = due_date -- mathematical expression for payment_total and variable date assignment
where invoice_id = 3;



-- 30 ** NEW TOPIC: UPDATING MULTIPLE ROWs :

-- All structure remains the same, just as above. BUT the element attribute in the 'WHERE' condition has to be more generic..so that more than one row qualifies..so pick a condition, basically which represents the entire category of eligible targetted items.


UPDATE invoices
SET payment_total = invoice_total * 0.5,
	payment_date = due_date
    where client_id = 3	;			-- If we'll want to update all records in the table, simply leave this statement out


-- EXERCISE:
-- Write a SQL statement to:
		-- give any customers born before 1990
        -- 50 extra points
        
        USE sql_store;
        
        UPDATE customers
        SET points = points + 50
        WHERE birth_date < '1990-01-01' ;
	
-- 31 ** NEW TOPIC: USING SUBQUERIES IN UPDATES :		The Beauty of Relational databases - 

-- Update without Joining tables. i.e. update a table with conditions applied on another table

USE sql_invoicing;

UPDATE invoices
SET payment_total = invoice_total * 0.5, 
	payment_date = '1982-08-16'
    
    WHERE client_id = 
			(
            SELECT client_id
            from clients
            WHERE name  = 'yadel'
            );
            
            
-- Another Example:            			-- OBSERVE the use of 'IN' in 'WHERE' conditions
UPDATE invoices
SET payment_total = invoice_total * 10,
	payment_date = '2017-03-14'
    
    WHERE client_id in (
		SELECT client_id
		from clients
		WHERE state IN ('CA','NY'));

-- Exercise : 

-- USe sql_store database
-- from orders table
-- Write a comment 'GOLD CUSTOMERS ' for customers who have placed an order and who have more than 3k Points

USE sql_store;

UPDATE orders
SET comments = 'GOLD CUSTOMERS'
WHERE customer_id in( 				-- Since there are multiple rows that will be selected i.e. in this case 3, hence using 'in'
		SELECT customer_id
		from customers
		WHERE points > 3000
);

-- 32 ** NEW TOPIC: DELETING ROWs

-- Use 'DELETE FROM <table>' statements to delete ALL the records from <table>...so be very carefull.
-- Optionally, you can use 'where' statement to state a condition so that only those records are deleted which qualify for this condition

-- E.g : Delete records with invoice_id = 1
DELETE FROM invoices
WHERE invoice_id = 1;  


-- We can also use a subQuery in above
-- E.g.: delete all records from table 'invoices' for clients named myworks
DELETE FROM invoices
WHERE client_id = 
		(
        SELECT client_id					-- subquery being used to find client named 'Myworks'
		FROM clients
		WHERE name = 'yadel'
        );
        
        -- ERRORS : 'Operand should contain 1 column(s)' : simply means that your subquery results in multiple columns, which should specifically should state 1. so instead of SELECT *, do SELECT client_id    

-- 32 ** NEW TOPIC: RESTORING THE DATABASES :	DISCLAIMER : This will only work for this course

-- This is used to restore databases to thier original form with the original data. Normally, You may want to do this when you would have deleted, added or updated data and would want the original databases back.

-- open the create-databases.sql script and execute it
-- then refresh the left side folder panel..   and that's it.



 -- ************		Module 4 : SUMMARIZNG Data		*****************
 
-- This module tells us how to summarize data so it gives a more wholistic picture in general of the data:
-- Often, business would want to know how the departments/ UNITS are performing in general..and  summarzing data techniques can help us have that picture.

 
-- TOPICS:
		-- 33.	Aggregate Functions

        
        
        -- 33 ** NEW TOPIC:	Aggregate Functions:
        
        
-- This module tells us how to summarize data so it gives a more wholistic picture in general of the data:
-- Aggregate functions are a set of built-in functions which help us aggregate individual values to give a wholistic value representing the entire data set.
-- Some of the functions are:

-- MAX()
-- MIN()
-- SUM()
-- AVG()
-- COUNT()

-- DEMO:

USE sql_invoicing;



SELECT 	MAX(invoice_total) AS highest,
		MIN(invoice_total) AS lowest,
        SUM(invoice_total) AS sum_invoice_total,
        AVG(invoice_total),
        count(invoice_total) AS 'No of invoices',
        MAX(payment_date) AS latest_Pay_dates,			-- -- MAX(date):	gives us the latest/ recent date 
        count(payment_date) AS count_payment,
        count(*) AS total_entries,						-- -- Count(*) gives us the total entries including 'NULL' values. Otherwise, normally count() would only include 'NOT NULL' values.
		count(client_id) AS client_count,				-- COUNT(client_id) would even include duplicate values as it is quoting the number of total items in the client_id column. 
        count(DISTINCT client_id) AS unique_count,		-- BUT if you'd like to count 'DISTINCT' aka UNIQUE values. SELECT statement with 'DISTINCT' clause elimainates the repetative appearance of the same data.
        SUM(invoice_total *1.1)							-- -- BODMAS applies i.e. every entry gets multiplied with 1.1 and then after bracket values calculated, SQL goes for the SUM.
        
FROM invoices 
WHERE invoice_date >  '2019-07-01'	;					-- Adding a FILTER through 'WHERE' would apply the functions only on the elements that qualified for the conditions. In this example now. the result shows up for the later half of year 2019.

-- 

-- The above functions can also be applied to 'DATES' and 'STRING' values.
-- NOTE: THESE FUNCTIONS IGORE THE NULL VALUE. So if there's a null value in these columns, they will be ignored
-- -- Count(*) gives us the total entries including 'NULL' values. Otherwise, normally count() would only include 'NOT NULL' values.

        -- EXERCISE:
        -- refer invoice table
        -- 1st column header should be date_range and should have 3 entries:First half of 2019, Second half of 2019, Total
        -- 2nd column named total_sales corresponding to 'First half of 2019', 'Second half of 2019' and the total_sales sum corresponding to Total
        -- 3rd column should be named 'total_payment' corresponding to the respective time periods
        -- 4th column should be what_we_expect which is the difference for invoice amount generated and payment recieved in the respective time periods.
        
        
        
        SELECT 
			'First half of 2019' AS date_range,
			 SUM(invoice_total) AS total_sales,
			 SUM(payment_total) AS total_payment,
			 SUM(invoice_total - payment_total) AS What_we_expect
		FROM invoices
        WHERE due_date 
			BETWEEN '2019-01-01' AND '2019-06-30'
UNION
        SELECT 
			'Second half of 2019' AS date_range,
			 SUM(invoice_total) AS total_sales,
			 SUM(payment_total) AS total_payment,
			 SUM(invoice_total - payment_total) AS What_we_expect
		FROM invoices
        WHERE due_date 
			BETWEEN '2019-07-01' AND '2019-12-31'
UNION
		SELECT 
			'Total' AS date_range,
			 SUM(invoice_total) AS total_sales,
			 SUM(payment_total) AS total_payments, 
			 SUM(invoice_total - payment_total) AS What_we_expect
		FROM invoices
        WHERE due_date 
			BETWEEN '2019-01-01' AND '2019-12-31';
            
            
            
               -- 34 ** NEW TOPIC:	The GROUP BY clause
	
    -- The GROUP BY clause helps with grouping the data
    -- If you'd like to see the sum of invoice amounts generated for each client. i.e sorted by client_id
    
    USE sql_invoicing;
    SELECT 
		client_id,
		SUM(invoice_total) as Client_amount
    FROM invoices 
    WHERE
		invoice_date >= '2019-07-01'
    GROUP BY client_id    				-- The clause 'GROUP BY' allows the system to group together the data based on the arguement
    ORDER BY Client_amount DESC;
    
    -- NOTE: Always remember the sequence : FROM; WHERE(optional); GROUP BY; ORDER BY(optional)
    
    -- ANother Example:
    -- show the sales figures state and city wise post joining the clients table with invoices
    
    SELECT 
			c.City,
			c.State,
			SUM(invoice_total) as invoice_total
        FROM invoices i
        JOIN clients c using (client_id)
        GROUP BY state,city;
        
        -- EXERCISE:				REWORK ON THIS EXAMPLE
        SELECT 
			p.date,
            p.payment_method,
            pm.name,
            SUM(p.amount)
		FROM payments AS p
           JOIN payment_methods AS pm 
			ON p.payment_method = pm.payment_method_id
		GROUP BY(date,name)
           
        