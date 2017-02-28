SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Capitalize] (@string VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS BEGIN
      DECLARE @FirstAsciiChar INT

      SELECT   @FirstAsciiChar = 
               PATINDEX('%[^a-zA-Z][abcdefghijklmnopqurstuvwxyz]%', ' ' 
                   + @string  COLLATE Latin1_General_CS_AI)
      IF @FirstAsciiChar > 0 
         SELECT   @String = STUFF(@String, 
                                  @FirstAsciiChar, 
                                  1, 
                                  UPPER(SUBSTRING(@String, @FirstAsciiChar, 1)))
      RETURN @string
   END
GO
