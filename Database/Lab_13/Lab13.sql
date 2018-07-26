--USE [master]
--GO

--CREATE DATABASE [DATABASE_13_2]
--ON   
--( NAME = N'DATABASE_13_2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DATABASE_13_2.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
--LOG ON 
--( NAME = N'DATABASE_13_2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DATABASE_13_2_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
-- 1. Создать в базах данных горизонтально фрагментированные таблицы.
USE DATABASE_13;
GO

IF OBJECT_ID ('TableLab13', 'U') IS NOT NULL  
   DROP TABLE TableLab13;  
GO  

CREATE TABLE TableLab13 (
	ID int PRIMARY KEY CHECK (ID BETWEEN 1 AND 4),
	ColumnA int,
	ColumnB int);INSERT  TableLab13
   (ID,ColumnA,ColumnB)  
VALUES  
	( 1,111,777), 
    ( 2,111,777), 
    ( 3,111,777);USE DATABASE_13_2;
GO

IF OBJECT_ID ('TableLab13', 'U') IS NOT NULL  
--IF EXISTS(select * FROM sys.views where name = 'View_Lab7') 
DROP TABLE TableLab13;  
GO 

CREATE TABLE TableLab13 (
	ID int PRIMARY KEY CHECK (ID BETWEEN 5 AND 8),
	ColumnA int,
	ColumnB int);INSERT  TableLab13
   (ID,ColumnA,ColumnB)  
VALUES  
	( 5,222,888), 
    ( 6,222,888), 
    ( 7,222,888);USE master
GO

-- 2. Создать секционированные представления,  обеспечивающие работу с данными таблиц
-- (выборку, вставку, изменение, удаление).
IF OBJECT_ID ('View13', 'V') IS NOT NULL  
	DROP VIEW View13;  
GO  

CREATE VIEW View13 AS
SELECT * FROM DATABASE_13.dbo.TableLab13
UNION ALL
SELECT * FROM ASUS.DATABASE_13_2.dbo.TableLab13
GO

IF OBJECT_ID ('Trigger_for_view_insert', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_insert;  
GO

CREATE TRIGGER Trigger_for_view_insert ON View13
INSTEAD OF  INSERT
AS 
	BEGIN		
		DECLARE @ID int
		DECLARE @columnA int
		DECLARE @columnB int

		DECLARE insert_cursor CURSOR FOR
			SELECT ID,ColumnA,ColumnB
			FROM inserted
			
		OPEN insert_cursor	
		FETCH NEXT FROM insert_cursor  INTO @ID,@columnA,@columnB
		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF (@ID < 5 AND EXISTS(SELECT @ID FROM DATABASE_13.dbo.TableLab13))
					BEGIN
						INSERT INTO DATABASE_13.dbo.TableLab13(ID,ColumnA,ColumnB)
						VALUES (@ID,@columnA,@columnB);
					END;
				IF (@ID >4 AND @ID<8 AND NOT EXISTS(SELECT @ID FROM ASUS.DATABASE_13_2.dbo.TableLab13))
					BEGIN
						INSERT INTO ASUS.DATABASE_13_2.dbo.TableLab13(ID,ColumnA,ColumnB)
						VALUES (@ID,@columnA,@columnB);
					END;
				FETCH NEXT FROM insert_cursor INTO @ID,@columnA,@columnB
			END
		CLOSE insert_cursor

		DEALLOCATE insert_cursor
	END;
GO

INSERT INTO View13(ID,ColumnA,ColumnB)
VALUES (4,555,999),
	   (8,555,999);
GO

UPDATE View13
SET ColumnA=111
WHERE ID=4
GO

DELETE View13
WHERE ID=6;
GO

SELECT * FROM View13
GO