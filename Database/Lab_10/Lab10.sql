USE Shop
GO
--"�������" ������----------------------------------------------------------------------

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;--���������, ��� ���������� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--���������, ��� ���������� �� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.

--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- 1)���������� �� ����� ��������� ������, ������� ���� ��������, �� ��� �� ������������� ������� ������������,												  
												  -- 2)������ ���������� �� ����� �������� ������, �������� ������� �����������, �� �� ����������.

--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;-- ���������� ���������� ������ �� ���������, ������� ���� ������������� �� �� ������. ����������, ����������� ������� �����������, �� ����� ��������� ������, ������������� ������� ������������ ����� ������� ������� ����������. ����� ������� ����������� ������ ��������� ������������ � ���������� ������������� ������ ��������������� ������ �� ������ ������� ����������.

--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   --1)���������� �� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.
												--2)������ ���������� �� ����� �������� ������, ����������� ������� �����������, �� �� ����������.
												--3)������ ���������� �� ����� ��������� ����� ������ �� ���������� �����, ������� ������ � �������� ������, ����������� ������������ ������� ����������, �� �� ����������.
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



--����������������� ������ (non-repeatable read)-------------------------------------------------------------------------------------------
/*
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;--���������, ��� ���������� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--���������, ��� ���������� �� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- 1)���������� �� ����� ��������� ������, ������� ���� ��������, �� ��� �� ������������� ������� ������������,												  
												  -- 2)������ ���������� �� ����� �������� ������, �������� ������� �����������, �� �� ����������.

--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;-- ���������� ���������� ������ �� ���������, ������� ���� ������������� �� �� ������. ����������, ����������� ������� �����������, �� ����� ��������� ������, ������������� ������� ������������ ����� ������� ������� ����������. ����� ������� ����������� ������ ��������� ������������ � ���������� ������������� ������ ��������������� ������ �� ������ ������� ����������.

--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   --1)���������� �� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.
												--2)������ ���������� �� ����� �������� ������, ����������� ������� �����������, �� �� ����������.
												--3)������ ���������� �� ����� ��������� ����� ������ �� ���������� �����, ������� ������ � �������� ������, ����������� ������������ ������� ����������, �� �� ����������.
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
--��������� ������---------------------------------------------------------------------

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;--���������, ��� ���������� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;--���������, ��� ���������� �� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.

--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;-- 1)���������� �� ����� ��������� ������, ������� ���� ��������, �� ��� �� ������������� ������� ������������,												  
												  -- 2)������ ���������� �� ����� �������� ������, �������� ������� �����������, �� �� ����������.

--SET TRANSACTION ISOLATION LEVEL SNAPSHOT;-- ���������� ���������� ������ �� ���������, ������� ���� ������������� �� �� ������. ����������, ����������� ������� �����������, �� ����� ��������� ������, ������������� ������� ������������ ����� ������� ������� ����������. ����� ������� ����������� ������ ��������� ������������ � ���������� ������������� ������ ��������������� ������ �� ������ ������� ����������.

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   --1)���������� �� ����� ��������� ������, ������� ���� �������� ������� ������������, �� ��� �� ���� �������������.
												--2)������ ���������� �� ����� �������� ������, ����������� ������� �����������, �� �� ����������.
												--3)������ ���������� �� ����� ��������� ����� ������ �� ���������� �����, ������� ������ � �������� ������, ����������� ������������ ������� ����������, �� �� ����������.
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
