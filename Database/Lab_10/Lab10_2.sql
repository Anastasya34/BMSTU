USE Shop
GO
--"грязное" чтение
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--Указывает, что инструкции могут считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.
GO
BEGIN TRANSACTION My_transaction_1;
GO
	INSERT  INTO shop
	WITH(READCOMMITTED) 
		(name_shop,phone,adress) 
	VALUES  
	   ('H&M','34-26-41','М.Горького д12 кв44');

	GO 
	-------------------------
	WAITFOR DELAY '00:00:05' 
	-------------------------

	-- Get information about the locks held by the transaction.
	SELECT resource_type, resource_subtype, request_mode 
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@spid;
	-- End the transaction
	SELECT 
			tran_locs.resource_type,
			tran_locs.resource_database_id,
			tran_locs.resource_associated_entity_id,
			tran_locs.request_mode,
			tran_locs.request_session_id,
			os_waiting_tasks.blocking_session_id
		FROM sys.dm_tran_locks as tran_locs
		INNER JOIN sys.dm_os_waiting_tasks as os_waiting_tasks
			ON tran_locs.lock_owner_address = os_waiting_tasks.resource_address;

ROLLBACK;
GO

--невоспроизводимое чтение (non-repeatable read) –


/*
SELECT resource_type, resource_associated_entity_id,
    request_status, request_mode,request_session_id,
    resource_description 
    FROM sys.dm_tran_locks
    WHERE resource_database_id IN (SELECT database_id FROM sys.databases)
GO

COMMIT TRANSACTION My_first_transaction;  
GO
*/
--невоспроизводимое чтение (non-repeatable read)------------------------------------------------------------------
/*
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; --Указывает, что инструкции могут считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.
GO
BEGIN TRANSACTION My_transaction_2;
GO
	UPDATE  shop
	WITH(READCOMMITTED)
	SET adress='Gogolevskaya'
	--SET adress=N'Пузакова д.23'
	WHERE name_shop='Spar' 
	SELECT  *
	   FROM shop
	WITH (READCOMMITTED)
	GO

	-- Get information about the locks held by the transaction.
	SELECT resource_type, resource_subtype, request_mode 
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@spid;
	-- End the transaction
	SELECT 
			tran_locs.resource_type,
			tran_locs.resource_database_id,
			tran_locs.resource_associated_entity_id,
			tran_locs.request_mode,
			tran_locs.request_session_id,
			os_waiting_tasks.blocking_session_id
		FROM sys.dm_tran_locks as tran_locs
		INNER JOIN sys.dm_os_waiting_tasks as os_waiting_tasks
			ON tran_locs.lock_owner_address = os_waiting_tasks.resource_address;

COMMIT TRANSACTION;
GO

*/

--Фантомное чтение---------------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; --Указывает, что инструкции могут считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.
GO
BEGIN TRANSACTION My_transaction_3;
GO
	INSERT INTO  shop(name_shop,phone,adress)
	VALUES ('ALiexpress','23-45-67','Internet');


	SELECT  *
	   FROM shop
	WITH (READCOMMITTED)
	GO

	-- Get information about the locks held by the transaction.
	SELECT resource_type, resource_subtype, request_mode 
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@spid;
	-- End the transaction
	SELECT 
			tran_locs.resource_type,
			tran_locs.resource_database_id,
			tran_locs.resource_associated_entity_id,
			tran_locs.request_mode,
			tran_locs.request_session_id,
			os_waiting_tasks.blocking_session_id
		FROM sys.dm_tran_locks as tran_locs
		INNER JOIN sys.dm_os_waiting_tasks as os_waiting_tasks
			ON tran_locs.lock_owner_address = os_waiting_tasks.resource_address;

COMMIT TRANSACTION;
GO

DELETE FROM  shop
WHERE name_shop='ALiexpress';
