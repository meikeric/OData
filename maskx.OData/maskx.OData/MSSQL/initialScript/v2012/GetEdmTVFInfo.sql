
/****** Object:  StoredProcedure [dbo].[GetEdmTVFInfo]    Script Date: 1/20/2018 20:37:01 ******/
DROP PROCEDURE [dbo].[GetEdmTVFInfo]
GO

/****** Object:  StoredProcedure [dbo].[GetEdmTVFInfo]    Script Date: 1/20/2018 20:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		maskx
-- Create date: 2018-1-20
-- Description:	get the table-valued function information
-- =============================================
CREATE PROCEDURE [dbo].[GetEdmTVFInfo]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select
		obj.name as SPECIFIC_NAME
		,[s].name as [SCHEMA_NAME]
		,par.name as PARAMETER_NAME
		,type_name(par.user_type_id) as DATA_TYPE
		,par.max_length as MAX_LENGTH
		,par.scale as SCALE
	from sys.all_objects as obj
		INNER JOIN sys.all_parameters  as par on par.[object_id]=obj.[object_id] 
		INNER JOIN [sys].[schemas] as [s] on [s].[schema_id]=[obj].[schema_id]
	where obj.[type] = N'IF' and obj.is_ms_shipped=0
	order by obj.object_id
END
GO


