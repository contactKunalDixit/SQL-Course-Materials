-- ****************************************************************************************************
-- CREATING A TABLE
-- DESCRIBING a Table
-- Alteration ADD a new cloumn 
-- Alteration DROP a COLUMN
-- DELETING a Table - Drop Table


USE new_schema_Test_Kunal;

CREATE TABLE student(
student_id INT PRIMARY KEY AUTO_INCREMENT,				-- Primary key means its 'NOT NULL' and'UNIQUE' CANNOT be NULL and duplicate
student_name VARCHAR(50) NOT NULL ,
majors VARCHAR(30) 
);

CREATE TABLE Teachers(
teacher_id INT,
teacher_name VARCHAR(20),
subject VARCHAR(20),
PRIMARY KEY(teacher_id)
);

DESCRIBE student;
DESCRIBE Teachers;

ALTER TABLE student ADD (GPA DECIMAL(3,2) DEFAULT "3.59");
ALTER TABLE student DROP COLUMN GPA;

ALTER TABLE Teachers ADD (star_rating INT);
ALTER TABLE Teachers DROP COLUMN star_rating;

DROP TABLE student;
DROP TABLE Teachers;


-- ****************************************************************************************************
-- Inserting rows/Data in the Tables

INSERT INTO student VALUES(1,'Jack','Biology',3.22);
INSERT INTO student VALUES(2,'Rack','Biology',2.22);
INSERT INTO student (student_id,student_name,majors) VALUES(7,NULL,'Eco');
INSERT INTO student(student_name) VALUES ('AMAIRA');
INSERT INTO STUDENT(student_name) VALUEs('Tim');

SELECT * FROM student;

-- ****************************************************************************************************
-- Updating and deleting rows from the database table:
 
 UPDATE student  
 SET majors = "BIO"
 WHERE majors = "biology";

UPDATE student
SET majors = "Economics"
WHERE student_name in( "Kunal","Sonal");
 
 SELECT *
 FROM student;
 
 UPDATE student
 SET majors = "Chemistry"
 WHERE student_id in(1,2,4,6);
 
 UPDATE student
 SET majors = "MATHS"
 WHERE student_id <> (1);
 
 UPDATE student
 SET GPA =4.3
 WHERE student_id IN(5,7,9,11);
 
 SELECT * 
 FROM student;
 
 UPDATE STUDENT
 SET GPA = 2.1
 WHERE majors IN ('MATHS', 'Chemistry');
 
 UPDATE student
 SET majors = 'BioChemistry'
 WHERE majors ="Biology" OR majors = "Chemistry";
 
 UPDATE student
 SET student_name="KIKI", majors ="Undecided"			-- Update multiple items at once
 WHERE student_id = 7;
 
 
 
 UPDATE student
 SET majors = 'undecided'
 WHERE student_name = 'Amaira';
 
 UPDATE student
 SET majors = "BIOLOGY"
 WHERE student_id = 19;

INSERT INTO student(student_name,GPA)
 VALUES ('Amaira',4.99);
  
 -- *** DELETING a row *** --
 
 DELETE FROM student
 WHERE student_id = 5;
 
 SELECT * 
 FROM student;
 
 DELETE from student
 WHERE student_name = null or student_id in (6,7);
 
 -- DELETE from student							-- DELETE ALL THE ROWS FROM THE TABLE. TABLE STILL EXISTS BUT WITHOUT ANY DATA
 
 -- ****************************************************************************************************
 
 -- BASIC QUERIES:
 
 SELECT student.student_name		-- Shows student names per Descending order of alphabets
 from student
 ORDER BY student_name DESC;
 
 SELECT student.student_name		-- shows student names in Ascending order of the student_id, EVEN if student_id itself has not been asked for
 FROM student
 ORDER BY student_id;
 
 SELECT student.student_name
 FROM student;


 SELECT *
 FROM student;
 
 SELECT *
 FROM student
 ORDER BY majors, GPA;	-- This will order them based on majors's first letter per Ascending order. If two rows have same majors, then it will sequence them as per the GPA scores. You can add as many order criterias per your requirement.
 
 SELECT *
 FROM student
 ORDER BY student_id DESC
 LIMIT 2; 			-- LIMITs the results to 2
 
 
 SELECT *
 FROM student
 WHERE student_id<=7;
 
 SELECT *
 from student
 Where student_id <= 7 AND student_name <>"rack"		-- name IS NOT equal to 'rack'