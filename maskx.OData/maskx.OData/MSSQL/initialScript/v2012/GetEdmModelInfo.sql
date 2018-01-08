
/****** Object:  StoredProcedure [dbo].[GetEdmModelInfo]    Script Date: 2015/8/24 20:59:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		maskx
-- Create date: 2015-6-10
-- Description:	get table and view information
-- =============================================
CREATE PROCEDURE [dbo].[GetEdmModelInfo] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
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
		[t].[name] AS [table_name],
		[c].[name] AS [column_name],
		[tp].[name] AS DATA_TYPE,
		[c].[is_nullable],
		pk.column_name as KEY_COLUMN_NAME,
		CAST([c].[max_length] AS int) AS [max_length],
		CAST([c].[precision] AS int) AS [precision],
		CAST([c].[scale] AS int) AS [scale],
		[c].[is_identity]
	FROM [sys].[columns] AS [c]
	JOIN [sys].[tables] AS [t] ON [c].[object_id] = [t].[object_id]
	JOIN [sys].[types] AS [tp] ON [c].[user_type_id] = [tp].[user_type_id]
	left join pk on pk.object_id=t.object_id and pk.column_name=c.name
	order by [t].[name]
END