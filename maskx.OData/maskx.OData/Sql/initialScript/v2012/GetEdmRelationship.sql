
/****** Object:  StoredProcedure [dbo].[GetEdmRelationship]    Script Date: 2015/8/24 21:00:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		maskx
-- Create date: 2015-7-14
-- Description:	Get the relationship of database object
-- =============================================
CREATE PROCEDURE [dbo].[GetEdmRelationship]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		fk.name 'FK Name',
		tp.name 'ParentName',
		cp.name 'ParentColumnName',
		tr.name 'RefrencedName',
		cr.name 'RefreancedColumnName'
	FROM   sys.foreign_keys fk
	INNER JOIN 
		sys.tables tp ON fk.parent_object_id = tp.object_id
	INNER JOIN 
		sys.tables tr ON fk.referenced_object_id = tr.object_id
	INNER JOIN 
		sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
	INNER JOIN 
		sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
	INNER JOIN 
		sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
	ORDER BY
		tp.name, cp.column_id
END
