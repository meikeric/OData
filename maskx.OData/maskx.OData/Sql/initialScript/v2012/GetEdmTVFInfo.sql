
/****** Object:  StoredProcedure [dbo].[GetEdmTVFInfo]    Script Date: 2015/8/24 21:02:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dian Zhao
-- Create date: 2015-6-10
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
		,par.name as PARAMETER_NAME
		,type_name(par.user_type_id) as DATA_TYPE
		,par.max_length as MAX_LENGTH
		,par.scale as SCALE
	from sys.all_objects as obj
		inner join sys.all_parameters  as par on par.object_id=obj.object_id 
	where obj.[type] = N'IF' and obj.is_ms_shipped=0
	order by obj.object_id
END