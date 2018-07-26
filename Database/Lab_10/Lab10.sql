USE Shop
GO
--"грязное" чтение----------------------------------------------------------------------

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;--Указывает, что инструкции МОГУТ считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--Указывает, что инструкции НЕ МОГУТ считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.

--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- 1)инструкции не могут считывать данные, которые были изменены, но еще не зафиксированы другими транзакциями,												  
												  -- 2)другие транзакции не могут изменять данные, читаемые текущей транзакцией, до ее завершения.

--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;-- Транзакция распознает только те изменения, которые были зафиксированы до ее начала. Инструкции, выполняемые текущей транзакцией, не видят изменений данных, произведенных другими транзакциями после запуска текущей транзакции. Таким образом достигается эффект получения инструкциями в транзакции моментального снимка зафиксированных данных на момент запуска транзакции.

--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   --1)Инструкции не могут считывать данные, которые были изменены другими транзакциями, но еще не были зафиксированы.
												--2)Другие транзакции не могут изменять данные, считываемые текущей транзакцией, до ее завершения.
												--3)Другие транзакции не могут вставлять новые строки со значениями ключа, которые входят в диапазон ключей, считываемых инструкциями текущей транзакции, до ее завершения.
GO
BEGIN TRANSACTION My_first_transaction;
GO

	SELECT   *
	   FROM shop
	WITH (READUNCOMMITTED)
	--WITH (READCOMMITTED)
	--WITH (REPEATABLEREAD)
	--WITH (SNAPSHOT)
	--WITH (SERIALIZABLE)

	GO 
	-- Get information about the locks held by the transaction.
	SELECT resource_type, resource_subtype, request_mode 
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@spid;
	
COMMIT TRANSACTION;
GO



--Невоспроизводимое чтение (non-repeatable read)-------------------------------------------------------------------------------------------
/*
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;--Указывает, что инструкции МОГУТ считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--Указывает, что инструкции НЕ МОГУТ считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- 1)инструкции не могут считывать данные, которые были изменены, но еще не зафиксированы другими транзакциями,												  
												  -- 2)другие транзакции не могут изменять данные, читаемые текущей транзакцией, до ее завершения.

--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;-- Транзакция распознает только те изменения, которые были зафиксированы до ее начала. Инструкции, выполняемые текущей транзакцией, не видят изменений данных, произведенных другими транзакциями после запуска текущей транзакции. Таким образом достигается эффект получения инструкциями в транзакции моментального снимка зафиксированных данных на момент запуска транзакции.

--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   --1)Инструкции не могут считывать данные, которые были изменены другими транзакциями, но еще не были зафиксированы.
												--2)Другие транзакции не могут изменять данные, считываемые текущей транзакцией, до ее завершения.
												--3)Другие транзакции не могут вставлять новые строки со значениями ключа, которые входят в диапазон ключей, считываемых инструкциями текущей транзакции, до ее завершения.
GO
BEGIN TRANSACTION My_first_transaction1;
GO
	SELECT   *
	   FROM shop
	--WITH (READUNCOMMITTED)
	--WITH (READCOMMITTED)
	WITH (REPEATABLEREAD)
	--WITH (SNAPSHOT)
	--WITH (SERIALIZABLE)
	GO
	WAITFOR DELAY '00:00:10'
	SELECT   *
	   FROM shop
	--WITH (READUNCOMMITTED)
	--WITH (READCOMMITTED)
	WITH (REPEATABLEREAD)
	--WITH (SNAPSHOT)
	--WITH (SERIALIZABLE)

	GO
	-- Get information about the locks held by the transaction.
	SELECT resource_type, resource_subtype, request_mode 
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@spid;

COMMIT TRANSACTION;
GO
*/
--Фантомное чтение---------------------------------------------------------------------

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;--Указывает, что инструкции МОГУТ считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--Указывает, что инструкции НЕ МОГУТ считывать строки, которые были изменены другими транзакциями, но еще не были зафиксированы.

--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- 1)инструкции не могут считывать данные, которые были изменены, но еще не зафиксированы другими транзакциями,												  
												  -- 2)другие транзакции не могут изменять данные, читаемые текущей транзакцией, до ее завершения.

--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;-- Транзакция распознает только те изменения, которые были зафиксированы до ее начала. Инструкции, выполняемые текущей транзакцией, не видят изменений данных, произведенных другими транзакциями после запуска текущей транзакции. Таким образом достигается эффект получения инструкциями в транзакции моментального снимка зафиксированных данных на момент запуска транзакции.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   --1)Инструкции не могут считывать данные, которые были изменены другими транзакциями, но еще не были зафиксированы.
												--2)Другие транзакции не могут изменять данные, считываемые текущей транзакцией, до ее завершения.
												--3)Другие транзакции не могут вставлять новые строки со значениями ключа, которые входят в диапазон ключей, считываемых инструкциями текущей транзакции, до ее завершения.
GO
BEGIN TRANSACTION My_first_transaction3;
GO
	SELECT   *
	   FROM shop
	--WITH (READUNCOMMITTED)
	--WITH (READCOMMITTED)
	--WITH (REPEATABLEREAD)
	WITH (SERIALIZABLE)
	GO
	WAITFOR DELAY '00:00:10'
	SELECT   *
	   FROM shop
	--WITH (READUNCOMMITTED)
	--WITH (READCOMMITTED)
	--WITH (REPEATABLEREAD)
	WITH (SERIALIZABLE)

	GO
	-- Get information about the locks held by the transaction.
	SELECT resource_type, resource_subtype, request_mode 
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@spid;

COMMIT TRANSACTION My_first_transaction3;
GO
