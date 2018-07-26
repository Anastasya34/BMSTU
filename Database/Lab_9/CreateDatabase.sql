USE Lab9
GO
IF OBJECT_ID ('employee', 'U') IS NOT NULL  
   DROP TABLE employee;  
GO 
IF OBJECT_ID ('resources', 'U') IS NOT NULL  
   DROP TABLE resources;  
GO 
  
IF OBJECT_ID ('shop', 'U') IS NOT NULL  
   DROP TABLE shop;  
GO  

CREATE TABLE shop(
 id_shop int  IDENTITY(1,1)  PRIMARY KEY, 
 name_shop varchar (20),  
 phone char(8) NULL,
 adress varchar(30) NULL

);


INSERT  shop
   (name_shop,phone,adress)  
VALUES  
	( 'Магнит','65-44-46','sgsdg'), 
    ( 'Магнолия','65-54-46','вапроg'), 
    ( 'Дикси','77-44-11','апро'), 
    ('Spar','65-32-26','ssgdhg'); 
   
CREATE TABLE employee(
  
 id_employee int IDENTITY(1,1) PRIMARY KEY, 
 id_shopfk int  , 
 CONSTRAINT FK FOREIGN KEY (id_shopfk) REFERENCES shop (id_shop),
 the_number_of_personal_affairs int,
 name_employee  varchar(20) NULL,  
 surname varchar(20) NULL,
 patronymic varchar(30) NULL,
 position varchar(30) NULL,
 salary int

);


INSERT  employee
   ( the_number_of_personal_affairs, name_employee ,id_shopfk, surname, patronymic, position, salary)  
VALUES  
   (233435,'Vladimir',1, 'Ilin','zzzz','ssgdhg','40000'),
   (324241,'Gosha',2, 'Ivanov','aaaa',';ljhj','32000'),
   (686754,'Anastasya',3, 'Luuna','zzzz','ssgdhg','40000'),
   (532524,'Lesha',4, 'Belogurov','aaaa',';ljhj','32000');



IF OBJECT_ID ('View_two', 'V') IS NOT NULL  
DROP VIEW View_two;  
GO 

CREATE VIEW View_two AS
	SELECT
	shop.name_shop, shop.phone, shop.adress, employee.the_number_of_personal_affairs, employee.name_employee, employee.surname, employee.salary
	FROM shop INNER JOIN employee 
	ON shop.id_shop = employee.id_shopfk
GO


