--USE [master]
--GO

--CREATE DATABASE [DATABASE_13_2]
--ON   
--( NAME = N'DATABASE_13_2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DATABASE_13_2.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
--LOG ON 
--( NAME = N'DATABASE_13_2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DATABASE_13_2_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO

USE DATABASE_13;
GO

IF OBJECT_ID ('TableBoss', 'U') IS NOT NULL  
   DROP TABLE TableBoss;  
GO  

CREATE TABLE TableBoss (
	ID_Boss int PRIMARY KEY,
	ColumnA int,
	ColumnB int);INSERT  TableBoss
   (ID_Boss,ColumnA,ColumnB)  
VALUES  
	( 1,123,777), 
    ( 2,111,777), 
    ( 3,111,777),	( 4,111,777);USE DATABASE_13_2;
GO

IF OBJECT_ID ('TableLab15', 'U') IS NOT NULL  
--IF EXISTS(select * FROM sys.views where name = 'View_Lab7') 
DROP TABLE TableLab15;  
GO 

CREATE TABLE TableLab15 (
	ID int  PRIMARY KEY,
	ColumnC int,
	ColumnD int,	FK_ID_Boss int NULL	--CONSTRAINT FK FOREIGN KEY (FK_ID_Boss) REFERENCES DATABASE_13.dbo.TableBoss (ID_Boss));INSERT  TableLab15
   (ID,ColumnC,ColumnD,FK_ID_Boss)  
VALUES  
	( 1,222,888,1), 
    ( 2,222,888,2), 
    ( 3,222,888,3),	( 4,222,888,4);--USE master
--GO

--IF OBJECT_ID ('View15', 'V') IS NOT NULL  
--	DROP VIEW View15;  
--GO  

--CREATE VIEW View15 AS
--SELECT ColumnA,ColumnB,ColumnD,ColumnC 
--			FROM  DATABASE_13.dbo.TableBoss INNER JOIN DATABASE_13_2.dbo.TableLab15
--			ON DATABASE_13.dbo.TableBoss.ID_Boss = DATABASE_13_2.dbo.TableLab15.FK_ID_Boss
--GO

--SELECT * FROM View15
--GO
----------------------------------------------------
USE  DATABASE_13
GO
----------------INSERT PARENT TABLE----------
IF OBJECT_ID ('Trigger_for_TableBoss_update', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_TableBoss_update;  
GO


CREATE TRIGGER Trigger_for_TableBoss_update ON TableBoss
INSTEAD OF UPDATE
AS 
	BEGIN	
		DECLARE @ID_Boss_New int
		DECLARE @ID_Boss int 
		DECLARE @ColumnA int
		DECLARE @COlumnB int
		DECLARE insert_cursor1 CURSOR FOR
			SELECT ID_Boss,ColumnA,ColumnB
			FROM inserted

		DECLARE delete_cursor1 CURSOR FOR
			SELECT ID_Boss
			FROM deleted

		OPEN delete_cursor1	
		FETCH NEXT FROM delete_cursor1  INTO @ID_Boss		
		OPEN insert_cursor1	
		FETCH NEXT FROM insert_cursor1  INTO @ID_Boss_New,@ColumnA,@ColumnB
		WHILE @@FETCH_STATUS = 0
			BEGIN
				UPDATE TableBoss SET ColumnA = @ColumnA,
									 ColumnB = @ColumnB
				IF (NOT (@ID_Boss=@ID_Boss_New))
					BEGIN
						UPDATE DATABASE_13.dbo.TableBoss SET ID_Boss = @ID_Boss_New
						WHERE  ID_Boss=@ID_Boss
						UPDATE DATABASE_13_2.dbo.TableLab15 SET FK_ID_Boss = @ID_Boss_New
						WHERE  FK_ID_Boss=@ID_Boss
					END
				
				FETCH NEXT FROM delete_cursor1 
				FETCH NEXT FROM insert_cursor1 
			END
		CLOSE delete_cursor1
		CLOSE insert_cursor1
		
		DEALLOCATE insert_cursor1
		DEALLOCATE delete_cursor1		
	END;
GO
----------------DELETE PARENT TABLE----------
IF OBJECT_ID ('Trigger_for_TableBoss_delete', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_TableBoss_delete;  
GO

CREATE TRIGGER Trigger_for_TableBoss_delete ON TableBoss
INSTEAD OF DELETE
AS 
	BEGIN		
		DELETE FROM DATABASE_13_2.dbo.TableLab15
		WHERE FK_ID_Boss IN (SELECT ID_Boss FROM deleted)

				
		DELETE FROM TableBoss
		WHERE ID_Boss IN (SELECT ID_Boss FROM deleted)
	END;
GO
-------------------------------------------------------------------------------------------------------
USE  DATABASE_13_2
GO

------INSERT CHILD TABLE---------------
IF OBJECT_ID ('Trigger_for_TableLab15_insert', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_TableLab15_insert;  
GO

CREATE TRIGGER Trigger_for_TableLab15_insert ON TableLab15
INSTEAD OF INSERT
AS 
	BEGIN	
		--IF (NOT EXISTS (SELECT ID_Boss FROM DATABASE_13.dbo.TableBoss
		--			    WHERE ID_Boss IN (SELECT FK_ID_Boss FROM inserted)))
		--	BEGIN
		--		RAISERROR (N'Not EXIST parent, change FK', 18,1,5);
		--	END
		--ELSE 
		--	BEGIN
		--		INSERT INTO DATABASE_13_2.dbo.TableLab15(ID,ColumnC,ColumnD,FK_ID_Boss)
		--		SELECT ID,ColumnC,ColumnD,FK_ID_Boss FROM inserted
		--	END
		DECLARE @ID int
		DECLARE @ColumnC int
		DECLARE @COlumnD int	
		DECLARE @FK_ID_Boss int
		SET @FK_ID_Boss=NULL

		DECLARE insert_cursor1 CURSOR FOR
			SELECT ID,ColumnC,ColumnD,FK_ID_Boss
			FROM inserted
			
		OPEN insert_cursor1	
		FETCH NEXT FROM insert_cursor1  INTO @ID,@ColumnC,@ColumnD,@FK_ID_Boss
		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF (@FK_ID_Boss IS NULL)
					BEGIN
						RAISERROR (N'You could insert FK_ID_Boss', 18,1,5);
					END
				
				ELSE 
					BEGIN
						IF (NOT EXISTS(SELECT ID_Boss FROM DATABASE_13.dbo.TableBoss
									   WHERE ID_Boss=@FK_ID_Boss))
						BEGIN
							RAISERROR (N'Not EXIST parent for FK ', 18,1,5);
						END
						INSERT INTO DATABASE_13_2.dbo.TableLab15(ID,ColumnC,ColumnD,FK_ID_Boss)
						VALUES (@ID,@ColumnC,@ColumnD,@FK_ID_Boss)
					END
				FETCH NEXT FROM insert_cursor1 
			END
		CLOSE insert_cursor1

		DEALLOCATE insert_cursor1
		
	END;
GO

------UPDATE CHILD TABLE---------------
IF OBJECT_ID ('Trigger_for_TableLab15_update', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_TableLab15_update;  
GO

CREATE TRIGGER Trigger_for_TableLab15_update ON TableLab15
INSTEAD OF UPDATE
AS 
	BEGIN

		DECLARE @ID int
		DECLARE @ColumnC int
		DECLARE @COlumnD int	
		DECLARE @FK_ID_Boss int

		DECLARE update_cursor1 CURSOR FOR
			SELECT ID,ColumnC,ColumnD,FK_ID_Boss
			FROM inserted
			
		IF (NOT EXISTS (SELECT ID_Boss FROM DATABASE_13.dbo.TableBoss
					WHERE ID_Boss IN (SELECT FK_ID_Boss FROM inserted)))
			BEGIN
				RAISERROR (N'Not EXIST parent, change FK', 18,1,5);
			END
		ELSE 
			BEGIN
				OPEN update_cursor1	
				FETCH NEXT FROM update_cursor1  INTO @ID,@ColumnC,@ColumnD,@FK_ID_Boss
				WHILE @@FETCH_STATUS = 0
					BEGIN
						UPDATE TableLab15 SET ID=@ID, ColumnC=@ColumnC, ColumnD=@ColumnD, FK_ID_Boss=@FK_ID_Boss
						WHERE  ID=@ID
				
						FETCH NEXT FROM update_cursor1 
					END
				CLOSE update_cursor1
			END

		DEALLOCATE update_cursor1
			
	END;
GO
-------------------------------------------------------------------------------------- 
USE master
GO

UPDATE DATABASE_13.dbo.TableBoss
SET ID_Boss=123
WHERE ID_Boss=2
GO


DELETE DATABASE_13.dbo.TableBoss
WHERE ID_Boss=1;
GO
-------------------------------------------------------------------------------------------
--INSERT INTO DATABASE_13_2.dbo.TableLab15(ID,ColumnC,ColumnD,FK_ID_Boss)
--VALUES (4,555,999,1);
--GO


--INSERT INTO DATABASE_13_2.dbo.TableLab15(ID,ColumnC,ColumnD)
--VALUES (10,555,999),
--	   (11,555,999);
--GO

INSERT INTO DATABASE_13_2.dbo.TableLab15(ID,ColumnC,ColumnD,FK_ID_Boss)
VALUES (9,555,999,3);
GO

--UPDATE DATABASE_13_2.dbo.TableLab15
--SET FK_ID_Boss=56
--WHERE ID=4
--GO

UPDATE DATABASE_13_2.dbo.TableLab15
SET FK_ID_Boss=3
WHERE ID=4
GO

SELECT * FROM DATABASE_13.dbo.TableBoss

SELECT * FROM DATABASE_13_2.dbo.TableLab15