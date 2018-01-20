/****** Object:  StoredProcedure [dbo].[GetEdmRelationship]    Script Date: 1/20/2018 20:35:03 ******/
DROP PROCEDURE [dbo].[GetEdmRelationship]
GO

/****** Object:  StoredProcedure [dbo].[GetEdmRelationship]    Script Date: 1/20/2018 20:35:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		maskx
-- Create date: 2018-1-20
-- Description:	Get the relationship of database object
-- =============================================
CREATE PROCEDURE [dbo].[GetEdmRelationship]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		fk.[name] as [FK_NAME],
		tp.[name] as [PARENT_NAME],
		[st].[name] as [PARENT_SCHEMA_NAME],
		cp.[name] [PARENT_COLUMN_NAME],
		tr.[name] [REFRENCED_NAME],
		[sr].[name] as [REFRENCED_SCHEMA_NAME],
		cr.[name] as [REFREANCED_COLUMN_NAME]
	FROM   sys.foreign_keys fk
	INNER JOIN sys.tables tp ON fk.parent_object_id = tp.[object_id]
	INNER JOIN [sys].[schemas] as [st] on [st].[schema_id]=[tp].[schema_id] 
	INNER JOIN sys.tables tr ON fk.referenced_object_id = tr.[object_id]
	inner join [sys].[schemas] as [sr] on [sr].[schema_id]=[tr].[schema_id] 
	INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
	INNER JOIN sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
	INNER JOIN sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
	ORDER BY
		tp.[name], cp.column_id
END

GO


