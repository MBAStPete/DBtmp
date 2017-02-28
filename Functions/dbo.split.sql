SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[split]
   (
    @String VARCHAR(8000),
    @Delimiter VARCHAR(255) = NULL,
    @MaxSplit INT = NULL
    
   )
RETURNS XML
AS BEGIN
      DECLARE @results TABLE
         (
          seqno INT IDENTITY(1, 1),
          Item VARCHAR(MAX)
         )
      DECLARE @xml XML,
         @HowManyDone INT, 	--index of current search
         @HowMuchToDo INT,--How much more of the string to do
         @StartOfSplit INT,
         @EndOfSplit INT,
         @SplitStartCharacters VARCHAR(255),
         @SplitEndCharacters VARCHAR(255),
         @ItemCharacters VARCHAR(255),
         @ii INT
 
      SELECT   @HowMuchToDo = LEN(@string), @HowManyDone = 0,
               @StartOfSplit = 100, @SplitEndCharacters = '[a-z]',
               @SplitStartCharacters = COALESCE(@Delimiter,
                                                '[^-a-z'']'),
               @EndOfSplit = LEN(@SplitStartCharacters), @ii = 1

      WHILE @StartOfSplit > 0--we have a delimiter left to do
         AND @HowMuchToDo > 0--there is more of the string to split
         AND @ii <= COALESCE(@MaxSplit, @ii)
         BEGIN --find the delimiter or the start of the non-word block
            SELECT @StartOfSplit = PATINDEX('%' + @SplitStartCharacters + '%',
                  RIGHT(@String,@HowMuchToDo) COLLATE Latin1_General_CI_AI) 
                              
            IF @StartOfSplit > 0--if there is a non-word block
               AND @delimiter IS NULL 
               SELECT   @EndOfSplit = --find the next word
					PATINDEX('%' + @SplitEndCharacters + '%',
                    RIGHT(@string,@HowMuchToDo- @startOfSplit)
					COLLATE Latin1_General_CI_AI)
                                                                                 
            IF @StartOfSplit > 0--if there is a non-word block or delimiter 
               AND @ii < COALESCE(@MaxSplit, @ii + 1) --and there is a field
				--still to do
               INSERT   INTO @Results (item)
                        SELECT   LEFT(RIGHT(@String, @HowMuchToDo),
                                      @startofsplit - 1)
            ELSE --if not then save the rest of the string
               INSERT   INTO @Results (item)
                        SELECT   RIGHT(@String, @HowMuchToDo)
                                        
            SELECT   @HowMuchToDo = @HowMuchToDo - @StartOfSplit
                     - @endofSplit + 1, @ii = @ii + 1	
         END

--now we simply output the temporary table variable as XML
-- using our standard string-array format
      SELECT   @xml = (SELECT seqno, item
                       FROM   @results 
                      FOR
                       XML PATH('element'),
                           TYPE,
                           ELEMENTS,
                           ROOT('stringarray')
                      )
      RETURN @xml
   END


GO
