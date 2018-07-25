USE Lab8
GO

IF OBJECT_ID ('shop', 'U') IS NOT NULL  
   DROP TABLE shop;  
GO  

CREATE TABLE shop(
 id_shop int IDENTITY(1,1) PRIMARY KEY,  
 name_shop varchar (20),  
 phone char(8),
 adress varchar(30),
);

INSERT  shop
   (name_shop,phone,adress)  
VALUES  
   ( 'Магнит','65-44-46','sgsdg'), 
   ( 'Магнолия','65-54-46','вапроg'), 
   ( 'Дикси','77-44-11','апро'), 
   ( 'Spar','65-32-26','ssgdhg'); 
--------------------------------------------------------------------------------------------------------------------------
--1 Создать хранимую процедуру, производящую выборку из некоторой таблицы и возвращающую результат выборки в виде курсора.

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
---------------------------------------------------------------------------------------------------
-- 2. Модифицировать хранимую процедуру п.1. таким образом, чтобы выборка   
-- осуществлялась с формированием столбца, значение которого формируется 
-- пользовательской функцией. 

IF OBJECT_ID (N'GetWeekDay', N'FN') IS NOT NULL
    DROP FUNCTION GetWeekDay;
GO
CREATE FUNCTION GetWeekDay(@Date datetime)
	RETURNS int
	AS 
	BEGIN
		RETURN DATEPART (weekday, @Date)
	END;
GO

IF OBJECT_ID ('Proc_Select_With_Function', 'P' ) IS NOT NULL
	DROP PROCEDURE Proc_Select_With_Function;
GO
CREATE PROCEDURE Proc_Select_With_Function
	@currency_cursor CURSOR VARYING OUTPUT
	AS
	SET @currency_cursor = CURSOR FORWARD_ONLY STATIC FOR
	SELECT dbo.GetWeekDay(CONVERT(DATETIME,'20161122')); 
	OPEN @currency_cursor;
GO 

DECLARE @cursor_for_shop CURSOR;
EXEC Proc_Select_With_Function @currency_cursor = @cursor_for_shop OUTPUT;
FETCH NEXT FROM @cursor_for_shop;
WHILE (@@FETCH_STATUS = 0)
	BEGIN;
		FETCH NEXT FROM @cursor_for_shop;
	END;
CLOSE @cursor_for_shop;
DEALLOCATE @cursor_for_shop
GO
---------------------------------------------------------------------------------------------------
-- 3. Создать хранимую процедуру, вызывающую процедуру п.1., осуществляющую прокрутку возвращаемого 
-- курсора и выводящую сообщения, сформированные из записей при выполнении условия, заданного  
-- еще одной пользовательской функцией.
IF OBJECT_ID (N'Exist_Diksi_in_bd', N'FN') IS NOT NULL
    DROP FUNCTION Exist_Diksi_in_bd;
GO

CREATE FUNCTION Exist_Diksi_in_bd(@name varchar(10))
	RETURNS int
	AS 
	BEGIN
		IF (@name = N'Дикси')
			BEGIN 
				RETURN (1)
			END
		RETURN (0)
	END;
GO
IF OBJECT_ID ('Proc3', 'P' ) IS NOT NULL
	DROP PROCEDURE Proc3;
GO

CREATE PROCEDURE Proc3
	AS
	DECLARE @name varchar(10),@adress varchar(10)
	DECLARE @proc3_cursor CURSOR;
	EXECUTE Proc_Select_NameShop_and_AdressShop @currency_Proc_Select_NameShop_and_AdressShop_cursor=@proc3_cursor OUT 
	FETCH NEXT FROM @proc3_cursor INTO @name,@adress
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (dbo.Exist_Diksi_in_bd(@name)=0)
		BEGIN
			PRINT(@name)
		END
		FETCH NEXT FROM @proc3_cursor INTO @name,@adress
	END
	CLOSE @proc3_cursor
DEALLOCATE @proc3_cursor--OPEN @currency_Proc_Select_NameShop_and_AdressShop_cursor;
GO 

EXECUTE Proc3;
GO


--------------------------------------------------------------------------------------------------
--- 4. Модифицировать хранимую процедуру п.2. таким образом, чтобы выборка
--- формировалась с помощью табличной функции.
IF OBJECT_ID (N'User_function', N'IF') IS NOT NULL
    DROP FUNCTION User_function;
GO
CREATE FUNCTION User_function ()
RETURNS TABLE
AS
RETURN(
    SELECT phone
    FROM shop
);
GO

IF OBJECT_ID ('Proc_with_user_f', 'P' ) IS NOT NULL
DROP PROCEDURE Proc_with_user_f;
GO

CREATE PROCEDURE Proc_with_user_f
	@currency_cursor CURSOR VARYING OUTPUT AS
SET @currency_cursor = CURSOR FORWARD_ONLY STATIC FOR
	SELECT *
	FROM User_function();
OPEN @currency_cursor;
GO 

DECLARE @cursor_for_shop CURSOR;
EXECUTE Proc_with_user_f @currency_cursor = @cursor_for_shop
	OUTPUT;
WHILE (@@FETCH_STATUS = 0)
	BEGIN;
		FETCH NEXT FROM @cursor_for_shop;
	END;
CLOSE @cursor_for_shop;
DEALLOCATE @cursor_for_shop
GO  
