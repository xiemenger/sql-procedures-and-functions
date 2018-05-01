USE [**]
GO
/****** Object:  StoredProcedure [dbo].[CovertTableColumnToString]    Script Date: 4/30/2018 12:34:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  < Diane Xie  >
-- Create date: < 4/20/2018 >
-- Description: <Extract all the values from the column to a long string>
-- =============================================
ALTER PROCEDURE [dbo].[CovertTableColumnToString]
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 
 Declare @val1 Varchar(MAX);
 Declare @val2 Varchar(MAX);
 Declare @val3 Varchar(MAX);
 Select @val1 = COALESCE(@val1 + ', ' + SymptomsInPeople, SymptomsInPeople) From ToxicPlant;
 Select @val2 = COALESCE(@val2 + ', ' + SymptomsInPets, SymptomsInPets) From ToxicPlant;
 Select @val3 = COALESCE(@val3 + ', ' + SymptomsInLivestock,SymptomsInLivestock) From ToxicPlant;
 IF OBJECT_ID('dbo.Pstring','U') IS NOT NULL
    DROP TABLE dbo.Pstring;
  
 CREATE TABLE Pstring(
    SymptomsInPeople varchar(max),
    SymptomsInPet varchar(max),
    SymptomsInLivestock varchar(max)
 );

 Insert into PString Values(@val1, @val2, @val3);

END
