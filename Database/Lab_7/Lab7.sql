-------------------------------------------------------------------------------
-- Создать представление на основе одной из таблиц задания 6.

use Lab6;
GO
IF OBJECT_ID ('View_Lab7', 'V') IS NOT NULL  
--IF EXISTS(select * FROM sys.views where name = 'View_Lab7') 
DROP VIEW View_Lab7;  
GO  

CREATE VIEW View_Lab7 AS
	SELECT
	shop.name_shop, shop.adress
	FROM  shop  
GO
-------------------------------------------------------------------------------
-- Создать представление на основе полей обеих связанных таблиц задания 6. 

IF OBJECT_ID ('View_two', 'V') IS NOT NULL  
DROP VIEW View_two;  
GO 

CREATE VIEW View_two AS
	SELECT
	shop.name_shop,shop.phone, shop.adress, employee.name_employee, employee.surname, employee.salary
	FROM shop INNER JOIN employee 
	ON shop.id_shop = employee.id_shop
GO

SELECT * FROM View_two
GO
---------------------------------------------------------------------------
-- Создать индекс для одной из таблиц задания 6, включив в него дополнительные неключевые поля. 

IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'index_lab7') 
    DROP INDEX index_lab7 ON shop ;  
GO 

CREATE UNIQUE NONCLUSTERED INDEX index_lab7   
    ON shop (name_shop)  
	INCLUDE (adress) ;
GO  
-----------------------------------------------------------------------------
-- Создать индексированное представление --
IF OBJECT_ID ('View_with_index', 'V') IS NOT NULL  
--IF EXISTS(select * FROM sys.views where name = 'View_Lab7') 

DROP VIEW View_with_index;  
GO  

CREATE VIEW View_with_index 
  WITH SCHEMABINDING AS
	SELECT
	shop.name_shop, shop.adress, shop.phone
	FROM  dbo.shop  
GO

--Create an index on the view.  
CREATE UNIQUE CLUSTERED INDEX index_for_view   
    ON View_with_index (name_shop);  
GO  

