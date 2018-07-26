USE DATABASE_13;
GO
-- 1.Создать в базах данных пункта 1 задания 13 таблицы, содержащие вертикально фрагментированные данные.

IF OBJECT_ID ('TableLab14_1', 'U') IS NOT NULL  
   DROP TABLE TableLab14_1;  
GO  

CREATE TABLE TableLab14_1 (
	ID int PRIMARY KEY,
	ColumnA int,);INSERT  TableLab14_1
   (ID,ColumnA)  
VALUES  
	( 1,111), 
    ( 2,222), 
    ( 3,333),	( 4,444), 
    ( 5,555), 
    ( 6,777);USE DATABASE_13_2;
GO

IF OBJECT_ID ('TableLab14', 'U') IS NOT NULL  
--IF EXISTS(select * FROM sys.views where name = 'View_Lab7') 
DROP TABLE TableLab14;  
GO 

CREATE TABLE TableLab14 (
	ID int PRIMARY KEY,
	ColumnB int);INSERT  TableLab14
   (ID,ColumnB)  
VALUES  
	( 1,111), 
    ( 2,222), 
    ( 3,333),	( 4,444), 
    ( 5,555), 
    ( 6,777);USE master
GO

-- 2.Создать необходимые элементы базы данных (представления, триггеры), 
-- обеспечивающие работу с данными вертикально фрагментированных таблиц 
-- (выборку, вставку, изменение, удаление). 

IF OBJECT_ID ('View14', 'V') IS NOT NULL  
	DROP VIEW View14;  
GO  

CREATE VIEW View14 AS
	SELECT TableLab14_1.ID, ColumnA, ColumnB
	FROM DATABASE_13.dbo.TableLab14_1, ASUS.DATABASE_13_2.dbo.TableLab14
	WHERE TableLab14_1.ID = TableLab14.ID
GO 

IF OBJECT_ID ('Trigger_for_view_insert', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_insert;  
GO

CREATE TRIGGER Trigger_for_view_insert ON View14
INSTEAD OF  INSERT
AS 
	BEGIN		
		INSERT INTO DATABASE_13.dbo.TableLab14_1(ID,ColumnA)
		SELECT ID,ColumnA
		FROM inserted 
		
		INSERT INTO DATABASE_13_2.dbo.TableLab14(ID,ColumnB)
		SELECT ID,ColumnB
		FROM inserted 

	END;
GO

INSERT INTO View14(ID,ColumnA,ColumnB)
VALUES(8,555,999);
GO

IF OBJECT_ID ('Trigger_for_view_delete', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_delete;  
GO

CREATE TRIGGER Trigger_for_view_delete ON View14
INSTEAD OF  DELETE
AS 
	BEGIN		

		DELETE FROM DATABASE_13.dbo.TableLab14_1
		WHERE ID IN (SELECT ID FROM deleted)
					
						
		DELETE FROM DATABASE_13_2.dbo.TableLab14
		WHERE ID IN (SELECT ID FROM deleted)
					
	END;
GO

DELETE FROM View14
WHERE ID=1
GO

INSERT INTO View14(ID,ColumnA,ColumnB)
VALUES(8,555,999);
GO

IF OBJECT_ID ('Trigger_for_view_update', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_update;  
GO

CREATE TRIGGER Trigger_for_view_update ON View14
INSTEAD OF  UPDATE
AS 
	BEGIN		
		DELETE FROM DATABASE_13.dbo.TableLab14_1
		WHERE ID IN (SELECT ID FROM deleted)

		DELETE FROM DATABASE_13_2.dbo.TableLab14
		WHERE ID IN (SELECT ID FROM deleted)

		INSERT INTO DATABASE_13.dbo.TableLab14_1(ID,ColumnA)
		SELECT ID,ColumnA FROM inserted

		INSERT INTO DATABASE_13_2.dbo.TableLab14(ID,ColumnB)
		SELECT ID,ColumnB FROM inserted
	END;
GO

UPDATE View14 SET ColumnA='987123' WHERE ID=4
UPDATE View14 SET ColumnB='123789' WHERE ID=4
SELECT * FROM View14
GO
