/*USE [master]
GO


CREATE DATABASE [Shop]
 ON   
( NAME = N'Shop', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Shop.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Shop_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Shop_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO*/
USE Shop
GO

IF OBJECT_ID ('employee', 'U') IS NOT NULL  
   DROP TABLE employee;  
GO  

IF OBJECT_ID ('resources', 'U') IS NOT NULL  
   DROP TABLE resources;  
GO 
IF OBJECT_ID ('delivery', 'U') IS NOT NULL  
   DROP TABLE delivery;  
GO 
 
IF OBJECT_ID ('shop', 'U') IS NOT NULL  
   DROP TABLE shop;  
GO  

CREATE TABLE shop(
 name_shop varchar (20)  PRIMARY KEY,  
 phone char(8) NULL,
 adress varchar(30) NULL
 
);


INSERT  shop
   (name_shop,phone,adress)  
VALUES  
	( 'Магнит',  '65-44-46','М.Горького д.12'), 
    ( 'Магнолия','65-54-46','Чернышевского д.67'), 
    ( 'Дикси',   '77-44-11','Нагорная д.77'), 
    ( 'Spar',    '65-32-26','Пузакова д.23'); 

IF OBJECT_ID ('products', 'U') IS NOT NULL  
   DROP TABLE products;  
GO  
CREATE TABLE products(
 name_product varchar(30) PRIMARY KEY, 
 category varchar(30) DEFAULT('-')
);

INSERT  products 
   (name_product,category)  
VALUES  
	( 'Яблоко',  N'Фрукты'),  
	( 'Молоко',  N'Кисломолочные'),  
	( 'Сыр',     N'Кисломолочные'),  
	( 'Помидор', N'Овощи'),  
    ( 'Груша',   N'Фрукты'); 

INSERT  products 
   (name_product)  
VALUES
	('Мука'),
	('Соль');


IF OBJECT_ID ('providers', 'U') IS NOT NULL  
   DROP TABLE providers;  
GO  

CREATE TABLE providers(
 company_name varchar(50) PRIMARY KEY, 
 phone char(20) NULL,
 adress varchar(35) NULL,
 сompany_type varchar(30) NULL

);
INSERT  providers(company_name,phone,adress,сompany_type)  
VALUES  
	('Danon',           '8-915-68-59-280', 'г. Москва ул Академика Янгеля д.7', 'OAO'),  
	('FineApple',       '8-919-485-93-47', 'г. Тула ул. М.Горького д.12',       'OОO'),  
	('I_love_cheese',   '8-956-738-53-95', 'г. Орел ул. Красногвардейская д.9', 'ЗAO'),  
	('Salt_corporation','8-917-635-92-90', 'г. Сочи ул. Максимовского д.88',    'OAO'),  
    ( 'Полянка',        '8-954-675-92-90', 'г. Калуга ул. Фрунзе д.7',          'ИП'); 

UPDATE  providers 
SET phone = '8-919-543-21-11'   
WHERE company_name='Danon';  
GO  

CREATE TABLE delivery(
 fk_name_shop varchar (20),  
 fk_name_product varchar(30),
 fk_providers_company_name varchar(100),
 price int NULL,  
 amount int DEFAULT(0) NULL,
 CONSTRAINT FK_delivery FOREIGN KEY (fk_name_shop) REFERENCES shop (name_shop) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT FK_delivery2 FOREIGN KEY (fk_name_product) REFERENCES products (name_product) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT new_pk1 PRIMARY KEY (fk_name_shop, fk_name_product, fk_providers_company_name)

);

INSERT delivery 
(fk_name_shop,fk_name_product,fk_providers_company_name, price, amount)
VALUES ('Spar',    'Яблоко', 'FineApple',       34000 ,1000),
	   ('Spar',    'Груша','  FineApple',       4500,  500),
	   ('Spar',    'Молоко', 'I_love_cheese',   6800,  800),
	   ('Магнолия','Яблоко', 'FineApple',       34000, 1000),
	   ('Магнолия','Мука',   'Полянка',         4000,  1600),
	   ('Магнолия','Помидор','Danon',           6700,  1000),
	   ('Дикси',   'Груша',  'FineApple',       9000,  1000),
	   --('Дикси',   'Сыр',    'I_love_chees',    3400,  1000),
	   ('Магнит',  'Соль',   'Salt_corporation',2500,  300);


UPDATE  delivery
SET  price = 4000 
WHERE fk_name_product='Яблоко' AND  fk_providers_company_name= 'FineApple';  
GO  


CREATE TABLE resources(
 fk_name_shop varchar (20),  
 fk_name_product varchar(30),
 price int NULL,  
 amount int DEFAULT(0) NULL,
 CONSTRAINT FK_resources_1 FOREIGN KEY (fk_name_shop) REFERENCES shop (name_shop) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT FK_resources_2 FOREIGN KEY (fk_name_product) REFERENCES products (name_product) ON UPDATE CASCADE ON DELETE CASCADE,
 CONSTRAINT PK_resources PRIMARY KEY (fk_name_shop, fk_name_product)

);

INSERT resources
(fk_name_shop,fk_name_product, price, amount)
SELECT fk_name_shop,fk_name_product, price, amount
FROM delivery 
WHERE fk_name_shop='Магнолия'

INSERT resources
(fk_name_shop,fk_name_product, price, amount)
VALUES ('Spar',    'Яблоко',  34000 ,1000),
	   ('Spar',    'Груша',   4500,  500),
	   ('Spar',    'Молоко',  6800,  800),
	   ('Дикси',   'Груша',   9000,  1000),
	   ('Дикси',   'Сыр',     3400,  1000),
	   ('Магнит',  'Соль',    2500,  300);



DELETE FROM resources 
	WHERE fk_name_shop = 'Spar' AND fk_name_product ='Груша';  
GO  

CREATE TABLE employee(
  
 number_of_personal_affairs int PRIMARY KEY, 
 fk_shop varchar (20), 
 CONSTRAINT FK FOREIGN KEY (fk_shop) REFERENCES shop (name_shop) ON UPDATE CASCADE,
 --CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE NO ACTION,
 
 --CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE SET NULL,
 --CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE SET DEFAULT ,

 --CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE NO ACTION,
--CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE CASCADE,
 --CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE SET NULL,
 --CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE SET DEFAULT ,

 name_employee  varchar(20) NULL,  
 surname varchar(20) NULL,
 patronymic varchar(30) NULL,
 position varchar(30) NULL,
 salary int CHECK (salary BETWEEN 100 AND 1000000)
);


INSERT  employee
   ( number_of_personal_affairs, name_employee ,fk_shop, surname, patronymic, position, salary)  
VALUES  
   (233435,'Vladimir','Spar', 'Vadimovich','zzzz','ssgdhg','40000'),
   (324241,'Gosha','Дикси', 'Ivanov','aaaa',';ljhj','32000'),
   (686754,'Anastasya','Магнит', 'Luuna','zzzz','ssgdhg','40000'),
   (532524,'Lesha','Магнолия', 'Belogurov','aaaa',';ljhj','32000');



IF OBJECT_ID ('Shop_workers', 'V') IS NOT NULL  
	DROP VIEW Shop_workers;  
GO 

CREATE VIEW Shop_workers AS
	SELECT
	s.name_shop,s.phone, s.adress, e.name_employee, e.surname, e.salary
	FROM shop as s INNER JOIN employee as e
	ON s.name_shop = e.fk_shop
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'index_lab11') 
    DROP INDEX index_lab11 ON shop ;  
GO 

CREATE UNIQUE NONCLUSTERED INDEX index_lab11   
    ON shop (name_shop)  
	INCLUDE (adress) ;
GO 

 IF OBJECT_ID ('Proc_Select_NameShop_and_AdressShop', 'P' ) IS NOT NULL
	DROP PROCEDURE Proc_Select_NameShop_and_AdressShop;
GO

CREATE PROCEDURE Proc_Select_NameShop_and_AdressShop
	@currency_Proc_Select_NameShop_and_AdressShop_cursor CURSOR VARYING OUTPUT 
	AS
	SET @currency_Proc_Select_NameShop_and_AdressShop_cursor = CURSOR 
	FOR
		SELECT name_shop, adress FROM shop;

	OPEN @currency_Proc_Select_NameShop_and_AdressShop_cursor;
GO 

DECLARE @authors_cursor CURSOR;
EXECUTE Proc_Select_NameShop_and_AdressShop @currency_Proc_Select_NameShop_and_AdressShop_cursor = @authors_cursor OUT 

FETCH NEXT FROM @authors_cursor 
WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM @authors_cursor 
	END
CLOSE @authors_cursor

DEALLOCATE @authors_cursor
GO

IF OBJECT_ID (N'Price_one_product', N'FN') IS NOT NULL
    DROP FUNCTION Price_one_product;
GO

CREATE FUNCTION Price_one_product(@price int,@amount int)
	RETURNS int
	AS 
	BEGIN
		---SELECT price, amount FROM delivery WHERE fk_name_product=@name_product AND fk_name_shop=@name_shop AND fk_providers_company_name=@providers_company_name
		RETURN(@price/@amount)
	END;
GO
IF OBJECT_ID ('Price', 'P' ) IS NOT NULL
	DROP PROCEDURE Price;
GO

CREATE PROCEDURE Price
	AS
	DECLARE @price int,@amount int
	DECLARE price_cursor CURSOR FOR   
								SELECT price, amount
								FROM delivery 
								WHERE fk_name_shop='Spar' AND fk_name_product='Яблоко' AND fk_providers_company_name='FineApple' 


	OPEN price_cursor;
	FETCH NEXT FROM price_cursor INTO @price,@amount
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(dbo.Price_one_product(@price,@amount))
		FETCH NEXT FROM price_cursor INTO @price,@amount
	END
	CLOSE price_cursor
DEALLOCATE price_cursor--OPEN @currency_Proc_Select_NameShop_and_AdressShop_cursor;
GO 

EXECUTE Price;
GO


IF OBJECT_ID ('Trigger_for_shop_delete', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_shop_delete;  
GO


CREATE TRIGGER Trigger_for_shop_delete ON shop
INSTEAD OF DELETE
AS 
    BEGIN
	
	DELETE FROM employee
	WHERE fk_shop IN (SELECT DISTINCT name_shop 
					  FROM deleted)

	DELETE FROM resources
	WHERE  fk_name_shop IN (SELECT DISTINCT name_shop 
					  FROM deleted)

	DELETE FROM delivery
	WHERE fk_name_shop IN (SELECT DISTINCT name_shop 
					  FROM deleted)
	DELETE FROM shop
	WHERE name_shop IN (SELECT name_shop 
					  FROM deleted)
	END;
GO
/*
DELETE FROM shop
Where name_shop='Spar'
GO*/
  
IF OBJECT_ID ('Shop_workers_LEFT', 'V') IS NOT NULL  
	DROP VIEW  Shop_workers_LEFT;  
GO 
CREATE VIEW Shop_workers_LEFT AS
	SELECT
	s.name_shop,s.phone, s.adress, e.name_employee, e.surname, e.salary
	FROM shop as s LEFT JOIN employee as e
	ON s.name_shop = e.fk_shop
GO

IF OBJECT_ID ('Shop_workers_RIGHT', 'V') IS NOT NULL  
	DROP VIEW  Shop_workers_RIGHT;  
GO 

CREATE VIEW Shop_workers_RIGHT AS
	SELECT
	s.name_shop,s.phone, s.adress, e.name_employee, e.surname, e.salary
	FROM shop as s RIGHT JOIN employee as e
	ON s.name_shop = e.fk_shop
GO

IF OBJECT_ID ('Shop_workers_FULL_OUTER', 'V') IS NOT NULL  
	DROP VIEW  Shop_workers_FULL_OUTER;  
GO 
CREATE VIEW Shop_workers_FULL_OUTER  AS
	SELECT
	s.name_shop,s.phone, s.adress, e.name_employee, e.surname, e.salary
	FROM shop as s FULL OUTER  JOIN employee as e
	ON s.name_shop = e.fk_shop
GO

SELECT *   
FROM shop  
WHERE name_shop LIKE N'_агнит'; 

SELECT name_employee, surname
        FROM employee
        ORDER BY name_employee ASC
GO

SELECT name_employee, surname
        FROM employee
        ORDER BY name_employee DESC
GO 

SELECT fk_name_product, MAX(price), AVG(price), MIN(price), SUM(amount)
        FROM resources
		GROUP BY fk_name_product
		HAVING MAX(price)>500
GO 

SELECT fk_name_shop, COUNT(fk_name_product)
        FROM resources
		GROUP BY fk_name_shop
		HAVING  COUNT(fk_name_product) > 1
GO 

IF OBJECT_ID ('View1', 'V') IS NOT NULL  
	DROP VIEW View1;  
GO  
CREATE VIEW View1 AS
SELECT fk_name_product, price,amount FROM resources
UNION ALL
SELECT fk_name_product,price,amount FROM delivery
GO

SELECT *
 FROM View1

 IF OBJECT_ID ('View2', 'V') IS NOT NULL  
	DROP VIEW View2;  
GO  

CREATE VIEW View2 AS
SELECT fk_name_product, price,amount FROM resources
UNION 
SELECT fk_name_product,price,amount FROM delivery
GO

SELECT *
 FROM View2

  IF OBJECT_ID ('View3', 'V') IS NOT NULL  
	DROP VIEW View3;  
GO  

CREATE VIEW View3 AS
SELECT fk_name_product, price,amount FROM resources
EXCEPT
SELECT fk_name_product,price,amount FROM delivery
GO

SELECT *
 FROM View3
  IF OBJECT_ID ('View4', 'V') IS NOT NULL  
	DROP VIEW View4;  
GO 
 CREATE VIEW View4 AS
SELECT fk_name_product, price,amount FROM resources
INTERSECT
SELECT fk_name_product,price,amount FROM delivery
GO

SELECT *
 FROM View4
--SELECT *
--  FROM delivery

--SELECT *
--  FROM shop

--SELECT *
--  FROM products


--SELECT *
--  FROM providers

  
--SELECT *
--  FROM employee

--  SELECT *
--  FROM resources