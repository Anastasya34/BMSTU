USE Lab6;  
--1 Создать таблицу с автоинкрементным первичным ключом
--2 Добавить поля, для которых используются ограничения (CHECK), значения по умолчанию (DEFAULT).
IF OBJECT_ID ('dbo.Tabl1_identity', 'U') IS NOT NULL  
   DROP TABLE Tabl1_identity;  
GO  
CREATE TABLE Tabl1_identity  (  
 id_num int IDENTITY(1,1) PRIMARY KEY, 
 fname varchar (20),  
 minit char(1) DEFAULT ('A'),
 lname varchar(30),
 age   int 
);  

ALTER TABLE Tabl1_identity
ADD CONSTRAINT Age_Constraint CHECK (age<=100);
GO  

INSERT Tabl1_identity  
   (fname, minit, lname,age)  
VALUES  
   ('Karin', 'F', 'Josephs','10'); 

INSERT Tabl1_identity  
   (fname, minit, lname,age)  
VALUES  
   ('Pirkko', 'O', 'Koskitalo','99'); 

--3 Создать таблицу с первичным ключом на основе глобального уникального идентификатора
IF OBJECT_ID ('dbo.Tabl2_guid', 'U') IS NOT NULL  
   DROP TABLE Tabl2_guid;  
GO  
CREATE TABLE Tabl2_guid  (  
 rowguid uniqueidentifier ROWGUIDCOL NOT NULL
CONSTRAINT Generate_GUID DEFAULT (newid()),
CONSTRAINT PK PRIMARY KEY (rowguid),
 fname varchar (20),  
 minit char(1) DEFAULT ('A'),
 lname varchar(30),
 age   int 
);  
  
INSERT Tabl2_guid 
   (fname, minit, lname,age)  
VALUES  
   ('Karin', 'F', 'Josephs','10'); 

INSERT Tabl2_guid  
   (fname, minit, lname,age)  
VALUES  
   ('Pirkko', 'O', 'Koskitalo','99'); 

--4 Создать таблицу с первичным ключом на основе последовательности
IF OBJECT_ID ('dbo.Tabl3_sequence', 'U') IS NOT NULL  
   DROP TABLE Tabl3_sequence;  
GO  
CREATE TABLE Tabl3_sequence(
 license int PRIMARY KEY,
 fname varchar (20),  
 minit char(1) DEFAULT ('A'),
 lname varchar(30),
 age   int 
);

CREATE SEQUENCE SequenceLab6a
START WITH 1
INCREMENT BY 1;
GO 

INSERT Tabl3_sequence   
	(license,fname, minit, lname,age)   
VALUES (NEXT VALUE FOR SequenceLab6a, 'Phdsfhs', 'K', 'Koskitalo','99');
INSERT Tabl3_sequence    
	(license,fname, minit, lname,age)   
VALUES (NEXT VALUE FOR SequenceLab6a, 'Asdhj', 'L', 'Koskitalo','10');
INSERT Tabl3_sequence 
	(license,fname, minit, lname,age)   
VALUES (NEXT VALUE FOR SequenceLab6a, 'Opijng', 'T', 'Koskitalo','19');
GO

--5 Создать две связанные таблицы, и протестировать на них различные варианты действий --
-- для ограничений ссылочной целостности (NO ACTION| CASCADE | SET NULL | SET DEFAULT). --

USE Lab6;

IF OBJECT_ID ('employee', 'U') IS NOT NULL  
   DROP TABLE employee;  
GO  

IF OBJECT_ID ('shop', 'U') IS NOT NULL  
   DROP TABLE shop;  
GO 
IF OBJECT_ID ('new_employee', 'U') IS NOT NULL  
   DROP TABLE new_employees;  
GO 
 
CREATE TABLE shop(
  
 id_shop int  DEFAULT (0), 
 name varchar (20),  
 phone char(8),
 adress varchar(30),
 CONSTRAINT PK1 PRIMARY KEY (id_shop)
);

INSERT  shop
   (id_shop,name,phone,adress)  
VALUES  
   ('123', 'Fsdfs','6546','sgsdg');  

INSERT  shop
   (id_shop,name,phone,adress)  
VALUES  
   ('342', 'qwerty','656','ssgdhg'); 

CREATE TABLE employee(
  
 id_num int IDENTITY(1,1) PRIMARY KEY, 
 id_shop int DEFAULT (0), 
 --CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE NO ACTION,
--CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE CASCADE,
 --CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE SET NULL,
 --CONSTRAINT FK FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON UPDATE SET DEFAULT ,

 --CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE NO ACTION,
-- CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE CASCADE,
 --CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE SET NULL,
 --CONSTRAINT Del FOREIGN KEY (id_shop) REFERENCES shop (id_shop) ON DELETE SET DEFAULT ,


 name  varchar(20),  
 surname varchar(20),
 patronymic varchar(30),
 position varchar(30),
 salary int

);


INSERT  employee
   ( name ,id_shop, surname,patronymic,position,salary)  
VALUES  
   ('qwerty','123', 'Dgo','zzzz','ssgdhg','40000');


INSERT  employee
   ( name ,id_shop, surname,patronymic,position,salary)  
VALUES  
   ('uiop','342', 'cvbn','aaaa',';ljhj','32000');

   UPDATE shop SET id_shop = '0'
   WHERE id_shop='123';

   DELETE FROM shop  
   WHERE id_shop='342';

      