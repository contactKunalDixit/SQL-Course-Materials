USE YTube_company_DataBase;

CREATE TABLE Employee(
emp_id INT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
birth_date DATE,
sex VARCHAR(1),
salary INT,
super_id INT,
brach_id INT,
PRIMARY KEY(emp_id) );

ALTER TABLE Employee DROP COLUMN brach_id;
ALTER TABLE EMPLOYEE ADD COLUMN branch_id INT;

CREATE TABLE Branch(
branch_id INT,
branch_name VARCHAR(20),
mgr_id INT,
mgr_start_date DATE,
PRIMARY KEY(branch_id)
);


DESCRIBE EMPLOYEE;
DESCRIBE branch;

ALTER TABLE EMPLOYEE ADD FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;
ALTER TABLE EMPLOYEE ADD FOREIGN KEY (super_id) REFERENCES Employee(emp_id) ON DELETE SET NULL;
ALTER TABLE BRANCH ADD FOREIGN KEY (mgr_id) REFERENCES EMPLOYEE(emp_id) ON DELETE SET NULL;  


CREATE TABLE CLIENT(
client_id INT,
client_name VARCHAR(30),
branch_id INT,
FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

ALTER TABLE CLIENT ADD PRIMARY KEY(client_id);

CREATE TABLE Works_With(
emp_id INT,
client_id INT,
total_sales INT,
PRIMARY KEY(emp_id,client_id),
FOREIGN KEY(emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE
);

-- NOTE:: TABLE 'Works_With' has 2 foreign keys i.e. emp_id and client_id. There is still a Foriegn KEy statement and in this case...ON DELETE CASCADE.. ON DELETE CASCADE vs ON DELETE SET NULL.

CREATE TABLE Branch_Supplier(
branch_id INT,
supplier_name VARCHAR (30),
supply_type VARCHAR (20),
PRIMARY KEY(branch_id, supplier_name),
FOREIGN KEY (branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE
);

-- NOTE: Only branch_id is a foreign key. The supplier_name is NOT a foreign Key.


-- ******************	After Table creation ** ** Insert data within tables:

INSERT INTO Employee
VALUES(100,'David','Wallace','1967-11-17','M',250000,NULL,NULL);

INSERT INTO BRANCH
VALUES (1,'corporate',100,'2006-02-09');

UPDATE EMPLOYEE
SET branch_id=1
WHERE emp_id=100;

INSERT INTO Employee
VALUES(101,'Jan','Levingston','1961-05-11','F',110000,100,1);

INSERT INTO BRANCH
VALUES (2,'scranton',NULL,'1992-04-06');
INSERT INTO Employee
VALUES(102,'Michael','Scott','1964-03-15','M',75000,100,2);

INSERT INTO EMPLOYEE
VALUES	(103,'Angela','Martin','1971-06-25','F',63000,102,2),
		(104,'Kelly','Kapoor','1990-02-05','F',55000,102,2),
        (105,'Stanley','Hudson','1958-02-19','M',69000,102,2),
        (106,'Josh','Porter','1969-09-05','M',78000,100,3),
        (107,'Andy','Bernard','1973-07-22','M',65000,106,3),
        (108,'Jim','Halpert','1978-10-01','M',71000,106,3);
        
        
UPDATE EMPLOYEE
SET branch_id = 2
WHERE emp_id=102;

UPDATE Branch
SET mgr_id = 102
WHERE branch_id = 2;



UPDATE EMPLOYEE
SET branch_id=1
WHERE emp_id=100;


INSERT INTO BRANCH
VALUES(3,'STAMFORD',NULL,'1998-02-13');

UPDATE Branch
SET mgr_id = 106
WHERE branch_id=3;


INSERT INTO Branch
VALUES(4,'Buffalo',NULL,NULL);

INSERT INTO Client
VALUES 	(400,'DunMore HighSchool',2),
		(401,'Lackawana Country',2),
        (402,'FedEx',3),
        (403,'John Daly Law,LLC',3),
        (404,'Scranton Whitepages',2),
        (405,'Times Newspaper',3),
        (406,'FedEx',2);


INSERT INTO works_With
VALUES	(105,400,55000),
		(102,401,267000),
        (108,402,22500),
        (107,403,5000),
        (108,403,12000),
        (105,404,33000),
        (107,405,26000),
        (102,406,15000),
        (105,406,130000);
        

INSERT INTO Branch_Supplier
VALUES	(2,'Hammer Mill','paper'),
		(2,'Uniball','Writing Utensils'),
        (3,'Patriot Paper','Paper'),
        (2,'J.T. Forms & Labels', 'Custom Forms'),
        (3,'Uniball','Writing Utensils'),
        (3,'Hammer Mill','Paper'),
        (3,'Stamford Labels','Custom Forms');

SELECT *
FROM EMPLOYEE;

SELECT *
FROM BRANCH;

SELECT *
FROM CLIENT;

SELECT *
FROM Works_With;

SELECT *
FROM Branch_Supplier;

SELECT *
FROM Employee
ORDER by salary DESC;

SELECT *
FROM Employee
ORDER BY sex,first_name,last_name;

SELECT *
FROM Employee
ORDER BY sex,first_name
LIMIT 5;

-- *******************. Keywords and FUNCTIONS. *******************

-- FIND ALL THE DIFFERENT GENDER:  DISTINCT keyword helps to specifically showcase the unique entries in the table

SELECT DISTINCT sex
FROM EMPLOYEE;

-- CONCAT - Joins the values of two columns together
SELECT CONCAT(first_name,' ',last_name) AS FULL_NAME
FROM Employee;

-- Find the total number of employeesAlways try n put primary key because that's surely would not have any duplicate entries in it.:
SELECT COUNT(emp_id)
FROM employee;

SELECT COUNT(emp_id)
FROM EMPLOYEE
WHERE birth_date >'1971-01-01'
AND sex = 'F';

SELECT AVG(salary)			-- Find the average of salary of all employees
FROM EMPLOYEE; 

SELECT AVG(salary)			-- Average salary of all Males
FROM Employee
Where sex='M';

SELECT SUM(salary)			-- Sum of all employee's salary
FROM Employee;

SELECT COUNT(emp_id),sex	-- AGGREGATION Technique - GROUP BY -- Count how many Males and Females are there. See this one and next 2 e.g.s
FROM Employee
GROUP BY sex;

SELECT SUM(total_sales),emp_id		-- Show sum of total sales by all employees
FROM Works_With
GROUP BY emp_id; 


SELECT SUM(total_sales),client_id	-- Show over all total money spent by each client 	
FROM Works_With
GROUP BY client_id; 



-- *******************. WILDCARDS % or _. ***. OR REGEXP *******************
-- % = Multiple characters
-- _ = One character

-- USAGE: WHen a user using your application enters a term that needs to be searched, then in the backend, this is how the terms gets searched.


SELECT *							-- Find any client who has an LLC in its name
FROM client
WHERE client_name like '%LLC';		-- DEFINE a pattern with keyword 'Like' 


SELECT *							-- Find any employee born in October or Feb
FROM Employee
WHERE birth_date  LIKE '____-10%' OR birth_date LIKE '____-02%';




-- *******************. UNION *******************

-- UNION is a special keyword by which we can combine results of multiple SELECT statements into one result.

-- RULES for using UNION:
			-- 	Ensure to have the same number of columns in both SELECT statements.
			-- 	ENSURE that both SELECT statements are targeting the same DATA TYPE. If the targetted values are not same data type, they might not necessarily work.
			-- By default, The resultant column header would be the column header from Table Employee. But you can change that using 'AS' statement.
            
SELECT emp_id AS ID, first_name AS Name 					
FROM Employee
UNION
SELECT branch_id AS ID,branch_name AS Name
FROM branch
UNION
SELECT client_id, client_name
FROM Client;



-- Another E.g.: Find a list of all clients and branch suppliers names

SELECT client_name AS client_and_Supplier_Names, client.branch_id
FROM client
UNION
SELECT supplier_name, Branch_supplier.branch_id
FROM Branch_supplier;


-- Find a list of all money spent or earned by the company
SELECT Employee.salary
FROM EMPLOYEE
UNION 
SELECT total_sales
FROM Works_With;
 
 
 -- *******************. JOIN *******************

-- Combine rows n columns from 2 or more tables based on a related column between these tables.
-- JOIN can be really useful for combining information from different tables into a single result which we can then use to find out specific info.

-- In our Databse, e.g. Both table 'Branch' and table 'Employee' have a similar attribute column - Employee_id and mgr_id - and thus 'JOIN'able.

SELECT 	Employee.Emp_id,		-- Find all manager names and the info of Branches they manage
		Employee.first_name,
        Employee.last_name,
        Branch.branch_name,
        Branch.mgr_start_date
        FROM Employee
         JOIN BRANCH							-- 	Try doing Left JOIN and Right JOIN
        ON Employee.emp_id = Branch.mgr_id
 
