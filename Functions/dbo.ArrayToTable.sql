SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ================================================
-- creates a table from an array created by dbo.array
--this looks fun
-- ================================================
CREATE FUNCTION [dbo].[ArrayToTable]
(	
@TheArray xml 
)
RETURNS TABLE 
AS
RETURN 
(
SELECT   x.y.value('seqno[1]', 'INT') AS [seqno],
		 x.y.value('item[1]', 'VARCHAR(200)') AS [item]
FROM     @TheArray.nodes('//stringarray/element') AS x (y)
)
GO
