use Lab9
GO

-- Для одной из таблиц пункта 2 задания 7 создать триггеры на вставку, удаление и добавление,
-- при выполнении заданных условий один из триггеров должен инициировать возникновение ошибки
-- (RAISERROR / THROW)
/*
IF OBJECT_ID ('Trigger_for_shop_insert', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_shop_insert;  
GO 
CREATE TRIGGER Trigger_for_shop_insert ON shop  
FOR INSERT  
AS 
	INSERT INTO employee(id_shopfk)
	SELECT id_shop FROM inserted
GO

IF OBJECT_ID ('Trigger_for_shop_update', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_shop_update;  
GO 
CREATE TRIGGER Trigger_for_shop_update ON shop  
AFTER UPDATE 
AS 
 RAISERROR ('No', 16, 1);  
GO

IF OBJECT_ID ('Trigger_for_shop_delete', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_shop_delete;  
GO   

CREATE TRIGGER Trigger_for_shop_delete ON shop  
AFTER DELETE  
AS 
	DELETE FROM employee
	WHERE id_shopfk IN (SELECT id_shop FROM deleted)
GO 

*/
IF OBJECT_ID ('Trigger_for_view_insert', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_insert;  
GO


CREATE TRIGGER Trigger_for_view_insert ON View_two
INSTEAD OF INSERT 
AS 
    BEGIN
		INSERT INTO shop(name_shop,phone,adress)
			SELECT name_shop,phone,adress FROM inserted
			WHERE name_shop NOT IN (SELECT name_shop FROM shop)

		INSERT INTO employee(id_shopfk,name_employee,surname,salary)
			SELECT id_shopfk,name_employee,surname,salary FROM inserted
			WHERE id_shopfk IN
				(SELECT id_shop FROM shop
					WHERE id_shop NOT IN 
						(SELECT id_shopfk FROM employee))
	END;
GO


IF OBJECT_ID ('Trigger_for_view_update', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_update;  
GO 


CREATE TRIGGER Trigger_for_view_update ON View_two
INSTEAD OF UPDATE 
AS 
	BEGIN
		 
		IF UPDATE(name_shop)
				UPDATE shop SET name_shop IN (SELECT name_shop FROM inserted)
		IF UPDATE(phone)
				UPDATE shop SET phone=(SELECT phone FROM inserted)
		IF UPDATE(adress)
				UPDATE shop SET adress=(SELECT adress FROM inserted)
		IF UPDATE(name_employee)
				UPDATE employee SET name_employee=(SELECT name_employee FROM inserted)
		IF UPDATE(surname)
				UPDATE employee SET surname=(SELECT surname FROM inserted)
		IF UPDATE(salary)
				UPDATE employee SET salary=(SELECT salary FROM inserted)
		IF UPDATE(adress)
			RAISERROR ('You can not update adress', 16, 1); 
	END;
GO




IF OBJECT_ID ('Trigger_for_view_delete', 'TR') IS NOT NULL  
   DROP TRIGGER Trigger_for_view_delete;  
GO 


CREATE TRIGGER Trigger_for_view_delete ON View_two
INSTEAD OF DELETE
AS 
	BEGIN

	DELETE FROM shop
	WHERE name_shop IN (SELECT name_shop FROM deleted)

	DELETE FROM employee
	WHERE id_shop=(SELECT id_shop FROM shop 
					WHERE name_shop=(SELECT name_shop 
									 FROM deleted))
	END;
GO


-------------------Запросы-------------------
INSERT INTO View_two(name_shop,phone, adress,name_employee, surname, salary)
VALUES ('7континент','67-43-23','jvhjhh','Bob','Putin','100')

--UPDATE View_two SET phone='12-34-56'
--WHERE name_shop IN (SELECT name_shop FROM shop WHERE name_shop=N'Дикси')

UPDATE View_two SET salary=45000
WHERE name_employee=N'Anastasya'

DELETE FROM View_two 
WHERE name_shop='Spar'

SELECT*
  FROM [Lab9].[dbo].[shop]

SELECT  *
  FROM [Lab9].[dbo].[employee]
  
SELECT *
 FROM View_two