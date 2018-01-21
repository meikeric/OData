/****** Object:  StoredProcedure [dbo].[GetEdmModelInfo]    Script Date: 1/20/2018 20:34:01 ******/
DROP PROCEDURE [dbo].[GetEdmModelInfo]
GO

/****** Object:  StoredProcedure [dbo].[GetEdmModelInfo]    Script Date: 1/20/2018 20:34:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		maskx
-- Create date: 2018-1-19
-- Description:	get the information of table and view 
-- =============================================
CREATE PROCEDURE [dbo].[GetEdmModelInfo] 
	
AS
BEGIN
	SET NOCOUNT ON;

	with pk as (
		SELECT
			[i].[object_id],
			COL_NAME([ic].[object_id], [ic].[column_id]) AS [column_name]
		FROM [sys].[indexes] AS [i]
			JOIN [sys].[tables] AS [t] ON [i].[object_id] = [t].[object_id]
			JOIN [sys].[index_columns] AS [ic] ON [i].[object_id] = [ic].[object_id] AND [i].[index_id] = [ic].[index_id]
		where [i].[is_primary_key]=1
	)
	SELECT
		[t].[name] AS [TABLE_NAME],
		[s].[name] as [SCHEMA_NAME],
		[c].[name] AS [COLUMN_NAME],
		[tp].[name] AS [DATA_TYPE],
		[c].[IS_NULLABLE],
		pk.column_name as [KEY_COLUMN_NAME],
		CAST([c].[max_length] AS int) AS [MAX_LENGTH],
		CAST([c].[precision] AS int) AS [PRECISION],
		CAST([c].[scale] AS int) AS [SCALE],
		[c].[IS_IDENTITY]
	FROM [sys].[columns] AS [c]
		JOIN [sys].[tables] AS [t] ON [c].[object_id] = [t].[object_id]
		JOIN [sys].[types] AS [tp] ON [c].[user_type_id] = [tp].[user_type_id]
		JOIN [sys].[schemas] as [s] on [s].[schema_id]=[t].[schema_id]
		LEFT JOIN pk on pk.[object_id]=t.[object_id] and pk.column_name=c.[name]
	union ALL
	SELECT
		[t].[name] AS [TABLE_NAME],
		[s].[name] as [SCHEMA_NAME],
		[c].[name] AS [COLUMN_NAME],
		[tp].[name] AS [DATA_TYPE],
		[c].[IS_NULLABLE],
		null as [KEY_COLUMN_NAME],
		CAST([c].[max_length] AS int) AS [MAX_LENGTH],
		CAST([c].[precision] AS int) AS [PRECISION],
		CAST([c].[scale] AS int) AS [SCALE],
		[c].[IS_IDENTITY]
	FROM [sys].[columns] AS [c]
		JOIN [sys].[views] AS [t] ON [c].[object_id] = [t].[object_id]
		JOIN [sys].[types] AS [tp] ON [c].[user_type_id] = [tp].[user_type_id]
		JOIN [sys].[schemas] as [s] on [s].[schema_id]=[t].[schema_id]
	order by [TABLE_NAME],[SCHEMA_NAME]


END
GO
