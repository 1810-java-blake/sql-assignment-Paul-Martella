-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
set schema 'chinook';
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
select * from employee;
-- Task – Select all records from the Employee table where last name is King.
select * from employee where (lastname ='King');
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
select * from employee where (firstname = 'Andrew' and REPORTSTO = null);
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
select * from album order by album.title desc;
-- Task – Select first name from Customer and sort result set in ascending order by city
select customer.firstname, customer.city from customer order by customer.city asc;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
insert into genre (genreid, name) values (26, 'synthwave'), (27, 'electroswing'); 
-- Task – Insert two new records into Employee table
insert into employee
values (9, 'Ryan', 'Andrews', 'serf', 6, '1919-01-01 00:00:00',  '1919-01-01 00:00:01', '1414 Somehwere Ave', 'Townytown', 'MI', 'Quebec', '66723B','999 999 9999'),
(10,'Ryan', 'Moe', 'serf', 6, '1920-01-01 00:00:00',  '1920-01-01 00:00:01', '1414 Somehwere Ave', 'Townytown', 'MI', 'Quebec', '66723B','999 999 9998');
-- Task – Insert two new records into Customer table
insert into customer 
values (76, 'Ryan', 'Andrews', 'the corp', 'somewhere usa', 'merica', 'tx', 'Uhmerica', '111112', '9998991234', '9998991234', 'someemail2@email.com','1'),
(77,'Ryan', 'Moe', 'a corp', 'somehow usa', 'merica', 'tx', 'Uhmerica', '111123', '9998991234', '9998991234', 'someemail1@email.com','1');
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
update customer
set firstname = 'Robert', lastname = 'Walter'
where firstname = 'Aaron' and lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
update artist
set name = 'CCR'
where name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
select * from invoice where invoice.billingaddress like 'T%';  
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
select * from invoice where total between '15' and '50';
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
select * from employee where hiredate between '2003-06-01 00:00:00' and '2004-03-01 00:00:00';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
alter table customer drop constraint fk_customersupportrepid;
alter table invoice drop constraint fk_invoicecustomerid;
delete from customer where firstname ='Robert' and lastname ='Walter';
-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
create or replace function getTime () 
returns time as $Time$
declare
	Time time;
Begin
	perform CURRENT_TIME;
    return Time;
End;
$Time$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
create or replace function getMediatype()
returns integer as $mediaLenght$
declare
        mediaLenght integer;
begin
    select name, length(name) from mediatype as medialength;
    return mediaLenght;
end;
$mediaLenght$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
create or replace function avgTotalInvoices ()
returns numeric as $avgTotal$
declare
    avgTotal numeric;
begin
    select AVG(total) from invoice;
    return avgTotal;
end;
$avgTotal$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
 create or replace function expTrack ()
 returns text as $expensiveTrack$
 declare
    expensiveTrack text;
begin
    select max(unitprice) from track;
    return expensiveTrack;
end;
$expensiveTrack$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
create or replace function  avgInvoiceLine()
returns numeric as $avgInvoiceLine$
declare 
    avgInvoiceLine numeric;
begin
    select avg(unitprice) from invoiceline; 
end;
$avgInvoiceLine$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
create or replace function employee1968()
returns text as $employee1968$
declare
    employee1968 text;
begin
    select * from employee where hiredate > '1968-01-01 00:00:00'; 
    return employee1968;
end;
$employee1968$ LANGUAGE plpgsql;
-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE PROCEDURE chinook."getEmployeeName"()
LANGUAGE 'plpgsql'

AS $BODY$begin 
select firstname, lastname 
from employee;
end;$BODY$;
-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE PROCEDURE chinook."setEmployeeInfo"(IN "userFirst" text, IN "userLast" text, IN "newAddress" text, IN "newCity" text, IN "newState" text, IN "newCountry" text, IN "newPostalCode" text, IN "newPhone" text, IN "newFax" text, IN "newEmail" text)
LANGUAGE 'plpgsql'

AS $BODY$begin
update employee
set address=newAddress, city=newCity, state=newState, country=newCountry, postalcode=newPostalCode, phone=NewPhone, fax=newfax, email=newEmail
where firstname=userFirst and lastname=userLast;
end;
$BODY$;
-- Task – Create a stored procedure that returns the managers of an employee.
CREATE OR REPLACE PROCEDURE chinook."getEmployeeManagers"(IN "searchId" text)
LANGUAGE 'plpgsql'

AS $BODY$begin
select firstname, lastname 
from employee 
where reportsto = searchId;
end;$BODY$;
-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE PROCEDURE chinook."getCustomerCompany"(IN "customerFirst" text, IN "customerLast" text)
LANGUAGE 'plpgsql'

AS $BODY$begin
select firstname, lastname, company
from customer
where firstname=customerFirst and lastname=customerlast;
end;$BODY$;
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE FUNCTION chinook."deleteInvoice()"(IN "deleteInvoiceId" numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    
AS $BODY$
begin
Alter table invoice 
drop constraint pk_invoice cascade;
delete from invoice 
where invoice.invoiceid = deleteInvoiceId;
end;
$BODY$;

ALTER FUNCTION chinook."deleteInvoice()"(numeric)
    OWNER TO postgres;
-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE FUNCTION chinook."transactionInsert()"(IN customerid text, IN firstname text, IN lastname text, IN company text, IN address text, IN city text, IN statename text, IN country text, IN postalcode text, IN phone text, IN fax text, IN email text, IN supportrepid text)
    RETURNS text
    LANGUAGE 'plpgsql'
    
AS $BODY$
begin
select * from customer;
	-- nested logic goes here
	insert into customer 
values (customerid, firstname, lastname, company, address, city, statename, country, postalcode, phone, fax, email, supportrepid);
end;
$BODY$;

ALTER FUNCTION chinook."transactionInsert()"(text, text, text, text, text, text, text, text, text, text, text, text, text)
    OWNER TO postgres;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE TRIGGER "newEmployeerecord"
    AFTER INSERT
    ON chinook.employee
    FOR EACH ROW
    EXECUTE PROCEDURE chinook."newEmployeerecord"();

    CREATE FUNCTION chinook."newEmployeerecord"()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    NOT LEAKPROOF 
AS $BODY$
begin
-- some logic here
end;
$BODY$;

ALTER FUNCTION chinook."newEmployeerecord"()
    OWNER TO postgres;
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE TRIGGER "newAlbum"
    AFTER UPDATE 
    ON chinook.album
    FOR EACH ROW
    EXECUTE PROCEDURE chinook."newAlbum"();

    CREATE FUNCTION chinook."newAlbum"()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$

begin
-- logic goes here
end;

$BODY$;

ALTER FUNCTION chinook."newAlbum"()
    OWNER TO postgres;

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE TRIGGER "deleteCustomer"
    AFTER DELETE
    ON chinook.customer
    FOR EACH ROW
    EXECUTE PROCEDURE chinook."deleteCustomer"();

CREATE FUNCTION chinook."deleteCustomer"()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    NOT LEAKPROOF 
AS $BODY$
begin
-- YOU WON FREE BITCOIN!!! CALL NOW!!!
end;
$BODY$;

ALTER FUNCTION chinook."deleteCustomer"()
    OWNER TO postgres;

-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
CREATE TRIGGER restrict50
    BEFORE DELETE
    ON chinook.invoice
    FOR EACH ROW
    EXECUTE PROCEDURE chinook.restrict50();

CREATE FUNCTION chinook.restrict50()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    NOT LEAKPROOF 
AS $BODY$
begin
delete from invoice
where total < 50;
end;
$BODY$;

ALTER FUNCTION chinook.restrict50()
    OWNER TO postgres;
-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
select customer.firstname, customer.lastname, invoice.total from invoice
inner join customer on customer.customerid=invoice.customerid;
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
select customer.customerid, customer.firstname, customer.lastname, invoice.invoiceId, invoice.total
from customer
full outer join invoice on invoice.invoiceid = customer.customerid;
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
select album.title, artist.name 
from album
right join artist on album.artistid = artist.artistid;
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
select album.title, artist.name 
from album 
cross join artist
order by artist.name asc; 
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
select a.employee as employeeid, b.employee as employeeid, employee.firstname, employee.lastname
from a.employee, b.employee
where employee.employeeid = employee.reportsto;








