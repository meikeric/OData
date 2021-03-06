
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

	select 
		c.TABLE_NAME
		,c.COLUMN_NAME
		,c.DATA_TYPE
		,c.IS_NULLABLE
		,k.COLUMN_NAME as KEY_COLUMN_NAME
	from INFORMATION_SCHEMA.COLUMNS as c
		left Join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as k on 
			OBJECTPROPERTY(OBJECT_ID(k.CONSTRAINT_NAME), 'IsPrimaryKey')=1
			and k.COLUMN_NAME=c.COLUMN_NAME 
			and k.TABLE_NAME=c.TABLE_NAME
	order by c.TABLE_NAME
END