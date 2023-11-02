-- Start by creating the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

-- Disable foreign key checks for the initial setup
SET FOREIGN_KEY_CHECKS = 0;

-- Drop the tables with foreign key references first
DROP TABLE IF EXISTS QuoteModifications;
DROP TABLE IF EXISTS QuoteResponses;
DROP TABLE IF EXISTS tree_details;
DROP TABLE IF EXISTS QuoteRequests;
DROP TABLE IF EXISTS OrdersAccepted;
DROP TABLE IF EXISTS Billings;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS signup_users;

-- Create the signup_users table
CREATE TABLE IF NOT EXISTS signup_users(
    firstname varchar(30),
    lastname varchar(30),
    password varchar(30),
    email varchar(30) PRIMARY KEY,
    role varchar(10),
    CHECK (role in ('David Smith', 'client', 'Admin root'))
);

-- Create the users table
CREATE TABLE IF NOT EXISTS users(
    clientid int auto_increment PRIMARY KEY,
    email varchar(50) UNIQUE,
    firstname varchar(50) NOT NULL,
    lastname varchar(50) NOT NULL,
    Address varchar(50),
    City varchar(20),
    State varchar(20),
    CreditCardDetails varchar(50),
    PhoneNumber CHAR(10),
    FOREIGN KEY (email) REFERENCES signup_users(email) ON DELETE CASCADE
);

-- Create the QuoteRequests table
CREATE TABLE IF NOT EXISTS QuoteRequests(
    requestid int PRIMARY KEY,
    clientid int,
    NumberofTrees int,
    FOREIGN KEY (clientid) REFERENCES users(clientid) ON DELETE CASCADE
);

-- Create the tree_details table
CREATE TABLE IF NOT EXISTS tree_details(
    requestid int,
    treeid int auto_increment,
    size float,
    height float,
    location varchar(50),
    NearHouse BOOLEAN,
    Note TEXT,
    PRIMARY KEY (treeid),
    Foreign key (requestid) references QuoteRequests(requestid) ON DELETE CASCADE
);

-- Create the QuoteResponses table
CREATE TABLE IF NOT EXISTS QuoteResponses(
    quoteid int PRIMARY KEY,
    requestid int,
    clientid int,
    status varchar(10),
    InitialPrice float,
    StartDate DATE,
    EndDate DATE,
    Note TEXT,
    CHECK (status in ('Accepted', 'Rejected')),
    FOREIGN KEY (requestid) REFERENCES QuoteRequests(requestid) ON DELETE CASCADE,
    FOREIGN KEY (clientid) REFERENCES users(clientid)  ON DELETE CASCADE
);

-- Create the QuoteModifications table
CREATE TABLE IF NOT EXISTS QuoteModifications(
    ResponseQuoteid int PRIMARY KEY,
    quoteid int,
    InitialPrice float,
    StartDate DATE,
    EndDate DATE,
    Note TEXT,
    status varchar(10),
    CHECK (status in ('Accepted', 'Rejected')),
    FOREIGN KEY (quoteid) REFERENCES QuoteResponses(quoteid) ON DELETE CASCADE
);

-- Create the OrdersAccepted table
CREATE TABLE IF NOT EXISTS OrdersAccepted(
    orderid int PRIMARY KEY,
    clientid int,
    requestid int,
    AcceptedQuoteid int,
    FOREIGN KEY (clientid) REFERENCES users(clientid) ON DELETE CASCADE,
    FOREIGN KEY (requestid) REFERENCES QuoteRequests(requestid) ON DELETE CASCADE,
    FOREIGN KEY (AcceptedQuoteid) REFERENCES QuoteResponses(quoteid) ON DELETE CASCADE
);

-- Create the Billings table
CREATE TABLE IF NOT EXISTS Billings(
    Billid int PRIMARY KEY,
    orderid int,
    TotalAmount int,
    status varchar(10),
    note TEXT,
    CHECK (status in ('Received', 'Pending')),
    FOREIGN KEY (orderid) REFERENCES OrdersAccepted(orderid) ON DELETE CASCADE
);

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert a root user
INSERT INTO signup_users(email, password, firstname, lastname, role) 
VALUES('root', 'pass1234', 'root', 'root', 'Admin root');

select * from signup_users;
select * from users;
select * from QuoteModifications;
select * from QuoteResponses;
select * from tree_details;
select * from QuoteRequests;
select * from  OrdersAccepted;
select * from  Billings;

-- Values to insert into each table
/*
-- Insert a root user
INSERT INTO signup_users(email, password, firstname, lastname, role) 
VALUES('root', 'pass1234', 'root', 'root', 'Admin root'),
    ('user1@gmail.com', 'password1', 'John', 'Doe', 'client'),
    ('user2@gmail.com', 'password2', 'Jane', 'Smith', 'client'),
    ('user3@gmail.com', 'password3', 'Robert', 'Johnson', 'client'),
    ('user4@gmail.com', 'password4', 'Alice', 'Wilson', 'client'),
    ('user5@gmail.com', 'password5', 'David', 'Lee', 'client'),
    ('user6@gmail.com', 'password6', 'Sarah', 'Brown', 'client'),
    ('user7@gmail.com', 'password7', 'Michael', 'Jones', 'client'),
    ('user8@gmail.com', 'password8', 'Emily', 'Davis', 'client'),
    ('user9@gmail.com', 'password9', 'William', 'Clark', 'client'),
    ('user10@gmail.com', 'password10', 'Olivia', 'Harris', 'client'),
    ('user11@gmail.com', 'password11', 'Will', 'Clark', 'client'),
    ('user12@gmail.com', 'password12', 'liam', 'Clark', 'client');

-- Insert data for users table
INSERT INTO users(clientid, email, firstname, lastname, Address, City, State, CreditCardDetails, PhoneNumber)
VALUES
    ('1', 'user1@gmail.com', 'John', 'Doe', '123 Main St', 'City1', 'State1', '1111-2222-3333-4444', '5555555555'),
    ('2', 'user2@gmail.com', 'Jane', 'Smith', '456 Elm St', 'City2', 'State2', '2222-3333-4444-5555', '6666666666'),
    ('3', 'user3@gmail.com', 'Robert', 'Johnson', '789 Oak St', 'City3', 'State3', '3333-4444-5555-6666', '7777777777'),
    ('4', 'user4@gmail.com', 'Alice', 'Wilson', '101 Pine St', 'City4', 'State4', '4444-5555-6666-7777', '8888888888'),
    ('5', 'user5@gmail.com', 'David', 'Lee', '202 Birch St', 'City5', 'State5', '5555-6666-7777-8888', '9999999999'),
    ('6', 'user6@gmail.com', 'Sarah', 'Brown', '303 Cedar St', 'City6', 'State6', '6666-7777-8888-9999', '0000000000'),
    ('7', 'user7@gmail.com', 'Michael', 'Jones', '404 Redwood St', 'City7', 'State7', '7777-8888-9999-0000', '1111222233'),
    ('8', 'user8@gmail.com', 'Emily', 'Davis', '505 Walnut St', 'City8', 'State8', '8888-9999-0000-1111', '2222333344'),
    ('9', 'user9@gmail.com', 'William', 'Clark', '606 Maple St', 'City9', 'State9', '9999-0000-1111-2222', '3333444455'),
    ('10', 'user10@gmail.com', 'Olivia', 'Harris', '707 Ash St', 'City10', 'State10', '1234-5678-9012-3456', '4444555566'),
    ('11', 'user11@gmail.com', 'Olvia', 'Har', '707 Ash St', 'City11', 'State11', '1234-5678-9012-3456', '4446555566'),
    ('12', 'user12@gmail.com', 'Em', 'Das', '505 Walnut St', 'City12', 'State12', '8888-9999-0000-1111', '2221333344');


-- Insert data into the QuoteRequests table
INSERT INTO QuoteRequests(requestid, clientid, NumberofTrees)
VALUES
    ('1', '1', '3'),
    ('2', '2', '4'),
    ('3', '3', '10'),
    ('4', '4', '6'),
    ('5', '5', '9'),
    ('6', '6', '35'),
    ('7', '7', '4'),
    ('8', '8', '1'),
    ('9', '9', '2'),
    ('10', '10', '3'),
    ('11','11','4'),
    ('12','12','5');

-- Insert data into the tree_details table
INSERT INTO tree_details(requestid, size, height, location, NearHouse)
VALUES
    ('1', '40.2', '12.2', 'Tree near Entrance', False),
    ('2', '36.5', '28.2', '3rd tree on the way to the house', False),
    ('3', '18.1', '16.5', 'Tree near the house', True),
    ('4', '18.1', '16.3', '1st tree on the left', True),
    ('5', '12.1', '16.5', '2nd tree on the left', True),
    ('6', '11.1', '12.5', '1st tree on the right', False),
    ('7', '1.1', '18.5', '2nd tree on the right', False),
    ('8', '8.1', '16.5', '3rd tree on the right', False),
    ('9', '19.1', '6.5', '4th tree on the right', False),
    ('10', '68.1', '9.5', '4th tree on the right', False),
    ('11', '12.1', '9.9', '4th tree on the right', False),
    ('12', '18.2', '2.5', '4th tree on the right', False)    
    ;
    
-- Insert data into the QuoteResponses table
INSERT INTO QuoteResponses(quoteid, requestid, clientid, status, InitialPrice, StartDate, EndDate, Note)
VALUES
    ('1', '1', '1', 'Accepted', '300', '2020-01-01', '2020-01-07', NULL),
    ('2', '2', '2', 'Accepted', '400', '2020-01-08', '2020-01-15', NULL),
    ('3', '3', '3', 'Rejected', NULL, NULL, NULL, 'The request is difficult to process'),
    ('4', '4', '4', 'Accepted', '1300', '2021-01-01', '2020-01-07', NULL),
    ('5', '5', '5', 'Rejected', NULL, NULL, NULL, 'Difficulty too high'),
    ('6', '6', '6', 'Accepted', '700', '2020-03-01', '2020-03-07', NULL),
    ('7', '7', '7', 'Accepted', '800', '2020-04-01', '2020-04-07', NULL),
    ('8', '8', '8', 'Accepted', '300', '2020-05-01', '2020-05-07', NULL),
    ('9', '9', '9', 'Accepted', '3500', '2020-06-01', '2020-06-07', NULL),
    ('10', '10', '10', 'Accepted', '1300', '2020-06-15', '2020-06-16', NULL),
    ('11', '11', '11', 'Accepted', '1300', '2020-06-15', '2020-06-16', NULL),
    ('12', '12', '12', 'Accepted', '1300', '2020-06-15', '2020-06-16', NULL)
    ;
    
-- Insert data into the QuoteModifications table
INSERT INTO QuoteModifications(ResponseQuoteid, quoteid, InitialPrice, StartDate, EndDate, Note, status)
VALUES
    ('1', '1', '200', '2020-01-01', '2020-01-07', NULL, 'Accepted'),
    ('2', '2', '200', '2020-03-01', '2020-03-07', NULL, 'Accepted'),
    ('3', '4', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),
    ('4', '6', '700', '2021-01-05', '2021-03-02', 'Only works if you\'re able to provide support during this time period', 'Accepted'),
    ('5', '7', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),
    ('6', '8', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),
    ('7', '9', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),
    ('8', '10', '800', '2022-03-01', '2022-03-07', NULL, 'Accepted'),
    ('9', '11', '800', '2022-03-01', '2022-03-07', NULL, 'Accepted'),
    ('10', '12', NULL, NULL, NULL, 'Price too high', 'Accepted');

-- Insert data into the OrdersAccepted table
INSERT INTO OrdersAccepted(orderid, clientid, requestid, AcceptedQuoteid)
VALUES
    ('1', '1', '1', '1'),
    ('2', '2', '2', '2'),
    ('3', '4', '4', '4'),
    ('4', '6', '6', '6'),
    ('5', '7', '7', '7'),
    ('6', '8', '8', '8'),
    ('7', '9', '9', '9'),
    ('8', '10', '10', '10'),
    ('9', '11', '11', '11'),
    ('10', '12', '12', '12');

-- Insert data into the Billings table
INSERT INTO Billings(Billid, orderid, TotalAmount, status, note)
VALUES
    ('1', '1', '200', 'Received', NULL),
    ('2', '2', '300', 'Pending', 'Will pay in 2 weeks'),
    ('3', '3', '400', 'Received', NULL),
    ('4', '4', '600', 'Received', NULL),
    ('5', '5', '700', 'Received', NULL),
    ('6', '6', '800', 'Received', NULL),
    ('7', '7', '1250', 'Received', NULL),
    ('8', '8', '1150', 'Received', 'Great work!'),
    ('9', '9', '1900', 'Pending', 'Unsatisfactory work'),
    ('10', '10', '150', 'Pending', 'Work not completed yet');

select * from signup_users;
*/

