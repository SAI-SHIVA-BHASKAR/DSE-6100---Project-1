use testdb;
show tables;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS signup_users;
CREATE TABLE IF NOT EXISTS signup_users(
firstname varchar(30),
lastname varchar(30),
password varchar(30),
email varchar(30) PRIMARY KEY,
role varchar(10),
CHECK (role in ('David Smith', 'clients','Admin root'))
);

insert into signup_users(email, password, FirstName, LastName,role) values('root','pass1234','root','root','Admin root');
select * from signup_users;

DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users(
clientid int auto_increment PRIMARY KEY,
email varchar(50) UNIQUE,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
Address varchar(50),
City varchar(20),
State varchar(20),
CreditCardDetails varchar(50),
PhoneNumber CHAR(10),
Foreign Key (email) References signup_users(email)
);

select * from users;

-- Quote Request from the Customers/ Client
DROP TABLE IF EXISTS QuoteRequests;
CREATE TABLE IF NOT EXISTS QuoteRequests(
requestid int primary KEY,
clientid int,
NumberofTrees int,
FOREIGN KEY (clientid) REFERENCES users (clientid)
);
insert into QuoteRequests(requestid,clientid, NumberofTrees)
 values('1','1','3'),
		('2','2','4'),
        ('3','3','10'),
        ('4','4','6'),
        ('5','5','9'),
        ('6','6','35'),
        ('7','7','4'),
        ('8','8','1'),
        ('9','9','2'),
        ('10','10','3')
        ;

select * from QuoteRequests;


-- Quote details of each tree (size, location,height etc.,)
DROP TABLE IF EXISTS tree_details;
CREATE TABLE IF NOT EXISTS tree_details(
requestid int,
treeid int,
size float,
height float,
location varchar(50),
NearHouse BOOLEAN,
Note TEXT,
PRIMARY KEY (treeid),
Foreign key (requestid) references QuoteRequests(requestid) ON DELETE CASCADE
);




insert into tree_details(requestid, treeid, size, height, location, NearHouse)
 values('1','1','40.2','12.2','Tree near Entrance',False),
		('2','2','36.5','28.2','3rd tree on way to house',False),
        ('3','3','18.1','16.5','Tree near house',True),
		('4','4','18.1','16.5','1st tree on left',True),
        ('5','5','18.1','16.5','2nd tree on left',True),
        ('6','6','18.1','16.5','1st tree on right',False),
        ('7','7','18.1','16.5','2nd tree on right',False),
		('8','8','18.1','16.5','2nd tree on right',False),
        ('9','9','18.1','16.5','3rd tree on right',False),
        ('10','13','18.1','16.5','4th tree on right',False)
        ;

select * from tree_details;

-- Quote Response from the David
DROP TABLE IF EXISTS QuoteResponses;
CREATE TABLE IF NOT EXISTS QuoteResponses(
quoteid int PRIMARY KEY,
requestid int,
clientid int,
status varchar(10),
InitialPrice float,
StartDate Date,
EndDate Date,
Note TEXT ,
CHECK (status in ('Accepted','Rejected')), 
-- FOREIGN KEY (requestid) REFERENCES tree_details(requestid),
FOREIGN KEY (clientid) REFERENCES users (clientid)
);

insert into QuoteResponses(quoteid, requestid, clientid, status, InitialPrice, StartDate,EndDate,Note)
 values('1','1','1','Accepted','300','2020-01-01','2020-01-07',NULL),
		('2','2','2','Accepted','400','2020-01-08','2020-01-15',NULL),
        ('3','3','3','Rejected',NULL,NULL,NULL,'The request is difficult to process'),
        ('4','4','4','Accepted','1300','2021-01-01','2020-01-07',NULL),
        ('5','5','5','Rejected',NULL,NULL,NULL,'Difficulty too high'),
        ('6','6','6','Accepted','700','2020-03-01','2020-03-07',NULL),
        ('7','7','7','Accepted','800','2020-04-01','2020-04-07',NULL),
        ('8','8','8','Accepted','300','2020-05-01','2020-05-07',NULL),
        ('9','9','9','Accepted','3500','2020-06-01','2020-06-07',NULL),
        ('10','10','10','Accepted','1300','2020-06-15','2020-06-16',NULL)
        ;
select * from QuoteResponses;

-- Quote modifications from Client based on David Response
DROP TABLE IF EXISTS QuoteModifications;
CREATE TABLE IF NOT EXISTS QuoteModifications(
ResponseQuoteid int PRIMARY KEY,
quoteid int,
InitialPrice float,
StartDate Date,
EndDate Date,
Note TEXT,
status varchar(10),
CHECK (status in ('Accepted','Rejected')),
FOREIGN KEY (quoteid) REFERENCES QuoteResponses(quoteid)
);

insert into QuoteModifications(ResponseQuoteid, quoteid, InitialPrice, StartDate, EndDate, Note,status)
 values('1','1','200','2020-01-01','2020-01-07',NULL,'Accepted'),
		('2','2','200','2020-03-01','2020-03-07',NULL,'Accepted'),
        ('3','4','800','2020-03-01','2020-03-07',NULL,'Accepted'),
        ('4','6','700','2021-01-05','2021-03-02','Only works if you\'re able to provide support during this time period','Accepted'), 
        ('5','7','800','2020-03-01','2020-03-07',NULL,'Accepted'),
        ('6','8','800','2020-03-01','2020-03-07',NULL,'Accepted'),
        ('7','9','800','2020-03-01','2020-03-07',NULL,'Accepted'),
        ('8','10','800','2022-03-01','2022-03-07',NULL,'Accepted'),
        ('9','11','800','2022-03-01','2022-03-07',NULL,'Accepted'),
        ('10','12',NULL,NULL,NULL,'Price too high','Rejected')
        ;

select * from QuoteModifications;



-- Only Accepted Work orders
DROP TABLE IF EXISTS OrdersAccepted;
CREATE TABLE IF NOT EXISTS OrdersAccepted(
orderid int PRIMARY KEY,
clientid int,
requestid int,
AcceptedQuoteid int,

foreign key (clientid) REFERENCES users (clientid)
);

insert into OrdersAccepted(orderid, clientid, requestid, AcceptedQuoteid)
 values ('1','1','1','1'),
		('2','2','2','11'),
        ('3','3','4','12'),
        ('4','4','6','13'),
        ('5','5','7','14'),
        ('6','6','8','2'),
        ('7','7','12','4'),
        ('8','8','11','6'),
        ('9','9','19','7'),
        ('10','10','15','9')
        ;

select * from OrdersAccepted;

-- Billing Table if the order is accepted by Client and David
DROP TABLE IF EXISTS Billings;
CREATE TABLE IF NOT EXISTS Billings(
Billid int PRIMARY KEY,
orderid int,
 TotalAmount int,
 status varchar(10),
 note TEXT,
 CHECK (status in ('Recieved','Pending'))
);


insert into Billings(Billid, orderid, TotalAmount, status,note)
 values ('1','1','200','Recieved',NULL),
		('2','2','300','Pending','Will pay in 2 weeks'),
        ('3','3','400','Recieved',NULL),
        ('4','4','600','Recieved',NULL),
        ('5','5','700','Recieved',NULL),
        ('6','6','800','Recieved',NULL),
        ('7','7','1250','Recieved',NULL),
        ('8','8','1150','Recieved','Great work!'),
        ('9','9','1900','Pending','Unsatisfactory work'),
        ('10','10','150','Pending','Work not completed yet')
        ;

select * from Billings;

