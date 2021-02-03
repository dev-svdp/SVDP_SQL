--Date: December 12, 2019
--These are the commands I used to create our tables/database for the SVDP Pathfinder back-end

/* 
I used this command to access the Google Cloud Platform's MySQL database
gcloud sql connect svdp --user=root --quiet
(type in password here)
*/

--This is the statement I used to create the database
CREATE DATABASE svdp;

--Type in USE 'your-database-here' to select the database
USE svdp;

---MAYBE FINAL MEMBER TABLE
CREATE TABLE members (
	members_id INT NOT NULL AUTO_INCREMENT
	,first_name VARCHAR(20) NOT NULL
	,middle_name VARCHAR(20)
	,last_name VARCHAR(20) NOT NULL
	,nick_name VARCHAR(20)
	,for_name_tag VARCHAR(50)
	,address1 VARCHAR(100)
	,address2 VARCHAR(100)
	,primary_email VARCHAR(50) NOT NULL
	,secondary_email VARCHAR(50)
	,check_email1 BOOLEAN NOT NULL DEFAULT 0
	,check_email2 BOOLEAN NOT NULL DEFAULT 0
	,primary_phone VARCHAR(10)
	,secondary_phone VARCHAR(10)
	,city VARCHAR(30)
	,state VARCHAR(2)
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,check_text BOOLEAN NOT NULL DEFAULT 0
	,check_call BOOLEAN NOT NULL DEFAULT 0
	,zip VARCHAR(5)
	,gender VARCHAR(1)
	,birthday DATE
	,birth_city VARCHAR(30)
	,occupation VARCHAR(20)
	,birth_state VARCHAR(2)
	,birth_country VARCHAR(20)
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (members_id)
);

--This code can be used as a template to insert a member into the table
INSERT INTO members (
	first_name
	,last_name
	,home_phone
	,primary_email
	,gender
) VALUES (
	'Holden'
	,'Caulfield'
	,'5127652345'
	,'phony@fakemail.com'
	,'M'
);

CREATE OR REPLACE VIEW members_v AS
SELECT 
members_id
,first_name
,last_name
,primary_email
,primary_phone
,status
FROM members;

--This created the 'users' table.
--This is for login/authentication purposes of the site
CREATE TABLE users (
	users_id INT NOT NULL AUTO_INCREMENT
	,first_name VARCHAR(50) NOT NULL
	,last_name VARCHAR(50) NOT NULL
	,email VARCHAR(100) NOT NULL
	,password VARCHAR(255) NOT NULL
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (users_id)
);

--This code can be used as a template to insert a user into the table
INSERT INTO users (
	first_name
	,last_name
	,email
	,password
) VALUES (
	'John'
	,'Osman'
	,'john@svdpparish.org'
	,'josman'
);

-- Creating the roles table
CREATE TABLE roles (
	roles_id VARCHAR(3) NOT NULL
	,description VARCHAR(20) NOT NULL
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (roles_id)
);

-- Inserting data into the roles table
INSERT INTO roles (
	roles_id
	,description
) VALUES (
	'SUP'
	,'Supporter'
);

-- Create the sub_roles table
CREATE TABLE sub_roles (
	roles_id VARCHAR(3) NOT NULL
	,sub_roles_id VARCHAR(3) NOT NULL
	,description VARCHAR(20) NOT NULL
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (sub_roles_id)
);

-- Add a foreign key constraint (roles_id)
ALTER TABLE sub_roles ADD FOREIGN KEY (roles_id)
	REFERENCES roles (roles_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

-- Insert data into sub_roles table
INSERT INTO sub_roles (
	roles_id
	,sub_roles_id
	,description
) VALUES (
	'INI'
	,'NEO'
	,'Neophyte'
);

-- Create the communications table
CREATE TABLE event_type (
	event_type_id VARCHAR(3) NOT NULL
	,description VARCHAR(25) NOT NULL
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (event_type_id)
);

-- Insert data into the event_type table
INSERT INTO event_type (
	event_type_id
	,description
) VALUES (
	'EVE'
	,'Event'
);


--Sample statement to update a table
UPDATE users 
   SET password = 'jchan'
 WHERE first_name = 'Johnny';

--Update members
UPDATE members 
   SET first_name = 'Marcy'
       ,last_name = 'Penny'
       ,phone = '2072439988'
       ,address = '631 June Street, Dallas, TX 42631' 
       ,primary_email = 'marcypennies@example.com'
       ,secondary_email = 'jcp@mysales.com'
       ,gender = 'F'
 WHERE members_id = 2;

--Update users
UPDATE users
   SET email = 'mrshermes2002@gmail.com'
 WHERE users_id = 2;

--Bridge table for members and roles
CREATE TABLE members_roles (
	members_roles_id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,roles_id VARCHAR(3) NOT NULL
	,member_path VARCHAR(20)
	,EIM_training DATE
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (members_roles_id)
);

--Creating the table to capture the relational data between member and roles 
CREATE TABLE members_roles (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,roles_id VARCHAR(3) NOT NULL
	,member_path VARCHAR(20) NOT NULL
	,EIM_training DATE
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (id)
);

ALTER TABLE members_roles ADD FOREIGN KEY (members_id)
	REFERENCES members (members_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

--Creating table to capture the relational data between members and communications
CREATE TABLE members_events (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,event_type_id VARCHAR(3) NOT NULL
	,notes TEXT
	,communication_date_time DATETIME
	,title VARCHAR(25)
	,private BOOLEAN NOT NULL DEFAULT 1
	,milestone BOOLEAN NOT NULL DEFAULT 0
	,follow_up_date_time DATETIME
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (id)
);

ALTER TABLE members_events ADD FOREIGN KEY (event_type_id)
	REFERENCES event_type (event_type_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE members_sub_roles (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,roles_id VARCHAR(3) NOT NULL
	,sub_roles_id VARCHAR(3) NOT NULL
	,start_date DATE
	,end_date DATE
	,supporter_name VARCHAR(50) 
	,status VARCHAR(1) NOT NULL DEFAULT 'A'
	,notes TEXT
	,created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
	,last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	,PRIMARY KEY (id)
);

ALTER TABLE members_sub_roles ADD FOREIGN KEY (sub_roles_id)
	REFERENCES sub_roles (sub_roles_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO members_sub_roles (
	members_id
	,roles_id
	,sub_roles_id
	,start_date
	,notes
) VALUES (
	3
	,'MIN'
	,'RTC'
	,'2004-02-15'
	,"Vacation in the Bahamas please!"
);

UPDATE members_sub_roles 
   SET status = 'I'
 WHERE members_id = 5 AND sub_roles_id = 'CAT';

-------
--Join to get the homepage information

CREATE OR REPLACE VIEW homepage_basic AS
SELECT 
members.`members_id`
,members.`first_name`
,members.`last_name`
,members.`primary_phone`
,members.`primary_email`
,members.`status` AS members_status
,members_sub_roles.`roles_id`
,members_sub_roles.`sub_roles_id`
,members_sub_roles.`status` AS roles_status
,DATE(members_sub_roles.`last_updated`) AS last_update
FROM members
LEFT JOIN members_sub_roles ON members.`members_id` = members_sub_roles.`members_id`;

--------------------------
--------------------------
--Report commands

SELECT COUNT(sub_roles_id), roles_id FROM homepage_basic
WHERE status = 'A'
GROUP BY roles_id
ORDER BY roles_id ASC;

--------------------------
--------------------------

CREATE TABLE members_baptism (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,church_name VARCHAR(50)
	,contact_phone VARCHAR(10)
	,church_address VARCHAR(100)
	,baptism_date DATE
	,denomination VARCHAR(20)
	,PRIMARY KEY (id)
);

ALTER TABLE members_baptism ADD FOREIGN KEY (members_id)
	REFERENCES members (members_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE members_marriage (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,spouse_name VARCHAR(50)
	,spouse_baptismal_status VARCHAR(2)
	,marriage_type VARCHAR(2)
	,marriage_date DATE
	,convalidation_date DATE
	,PRIMARY KEY (id)
);

ALTER TABLE members_marriage ADD FOREIGN KEY (members_id)
	REFERENCES members (members_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE members_confirmation (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,church_name VARCHAR(50)
	,contact_phone VARCHAR(10)
	,church_address VARCHAR(100)
	,confirmation_date DATE
	,officiant VARCHAR(25)
	,PRIMARY KEY (id)
);

ALTER TABLE members_confirmation ADD FOREIGN KEY (members_id)
	REFERENCES members (members_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE members_first_communion (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,church_name VARCHAR(50)
	,contact_phone VARCHAR(10)
	,church_address VARCHAR(100)
	,communion_date DATE
	,officiant VARCHAR(25)
	,PRIMARY KEY (id)
);

CREATE TABLE members_prior_marriage (
	id INT NOT NULL AUTO_INCREMENT
	,members_id INT NOT NULL
	,spouse_name VARCHAR(50)
	,marriage_type VARCHAR(2)
	,divorce_date DATE
	,PRIMARY KEY (id)
);

ALTER TABLE members_first_communion ADD FOREIGN KEY (members_id)
	REFERENCES members (members_id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE baptism_document (
	id INT NOT NULL AUTO_INCREMENT
	,members_baptism_id INT NOT NULL
	,photo BLOB
	,PRIMARY KEY (id)
);

ALTER TABLE baptism_document ADD FOREIGN KEY (members_baptism_id)
	REFERENCES members_baptism (id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE marriage_document (
	id INT NOT NULL AUTO_INCREMENT
	,members_marriage_id INT NOT NULL
	,photo BLOB
	,PRIMARY KEY (id)
);

ALTER TABLE marriage_document ADD FOREIGN KEY (members_marriage_id)
	REFERENCES members_marriage (id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE communion_document (
	id INT NOT NULL AUTO_INCREMENT
	,members_communion_id INT NOT NULL
	,photo BLOB
	,PRIMARY KEY (id)
);

ALTER TABLE communion_document ADD FOREIGN KEY (members_communion_id)
	REFERENCES members_first_communion (id)
	ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE prior_marriage_document (
	id INT NOT NULL AUTO_INCREMENT
	,members_prior_marriage_id INT NOT NULL
	,photo BLOB
	,PRIMARY KEY (id)
);

ALTER TABLE prior_marriage_document ADD FOREIGN KEY (members_prior_marriage_id)
	REFERENCES members_prior_marriage (id)
	ON DELETE CASCADE ON UPDATE CASCADE;

---
CREATE OR REPLACE VIEW notification_follow_up AS
SELECT 
members_events.`members_id`
,members_events.`follow_up_date_time`
,members.`first_name`
,members.`last_name`
,members_events.`id`
FROM members_events
LEFT JOIN members ON members.`members_id` = members_events.`members_id`
WHERE follow_up_date_time > NOW() AND follow_up_date_time < DATE_ADD(NOW(), INTERVAL 30 DAY);

CREATE OR REPLACE VIEW notification_birthday AS
SELECT members_id, birthday, first_name, last_name
FROM members
WHERE DATE_FORMAT(members.birthday, '%m-%d')
BETWEEN DATE_FORMAT(NOW(), '%m-%d') 
AND DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 30 DAY), '%m-%d');

CREATE OR REPLACE VIEW notification_marriage AS
SELECT 
members_marriage.`members_id`
,members_marriage.`marriage_date`
,members.`first_name`
,members.`last_name`
FROM members_marriage
LEFT JOIN members ON members.`members_id` = members_marriage.`members_id`
WHERE DATE_FORMAT(members_marriage.marriage_date, '%m-%d')
BETWEEN DATE_FORMAT(NOW(), '%m-%d') 
AND DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 30 DAY), '%m-%d');

CREATE OR REPLACE VIEW notification_baptism AS
SELECT 
members_baptism.`members_id`
,members_baptism.`baptism_date`
,members.`first_name`
,members.`last_name`
FROM members_baptism
LEFT JOIN members ON members.`members_id` = members_baptism.`members_id`
WHERE DATE_FORMAT(members_baptism.baptism_date, '%m-%d')
BETWEEN DATE_FORMAT(NOW(), '%m-%d') 
AND DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 30 DAY), '%m-%d');
---


ALTER TABLE sub_roles ADD FOREIGN KEY (roles_id)
	REFERENCES roles (roles_id)
	ON DELETE CASCADE ON UPDATE CASCADE;