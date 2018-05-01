ParsingArrayAndGenerateTables
USE [**]
GO
/****** Object:  StoredProcedure [dbo].[ParsingArrayAndGenerateTables]    Script Date: 4/30/2018 12:35:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  <Diane Xie>
-- Create date: <4/20/2018>
-- Description: <Test Parsing function>
-- =============================================
ALTER PROCEDURE [dbo].[ParsingArrayAndGenerateTables]
AS
BEGIN 
    -- Create tables
 IF OBJECT_ID('dbo.PeopleSymptom','U') IS NOT NULL
    DROP TABLE dbo.PeopleSymptom;
 IF OBJECT_ID('dbo.PetSymptom','U') IS NOT NULL
    DROP TABLE dbo.PetSymptom;
 IF OBJECT_ID('dbo.LivestockSymptom','U') IS NOT NULL
    DROP TABLE dbo.LivestockSymptom;
 
 CREATE TABLE PeopleSymptom(
    symptoms varchar(50),
    UNIQUE(symptoms)
 );
 CREATE TABLE PetSymptom(
    symptoms varchar(50),
    UNIQUE(symptoms)
 );
 CREATE TABLE LivestockSymptom(
    symptoms varchar(50),
    UNIQUE(symptoms)
 );
 --CREATE UNIQUE INDEX UQ_name ON PeopleSymptom (symptoms);
 --CREATE UNIQUE INDEX UQ_name ON PetSymptom (symptoms);
 --CREATE UNIQUE INDEX UQ_name ON SymptomInLivestock (symptoms);
 DECLARE @txtvar varchar(max);
 DECLARE @separator_poistion INT;
 DECLARE @array_value varchar(1000);
 DECLARE @array varchar(max);
 DECLARE @separator char(1);
 --Seperator
 SET @separator = ',';


 --Parsing symptomsInPeople string.
 SELECT @txtvar = LTRIM(RTRIM(SymptomsInPeople)) from PString;
 SET @array = @txtvar;
 SET @array = @array + @separator;
 SELECT @separator_poistion = PATINDEX('%' +@separator + '%', @array);
 
 WHILE @separator_poistion <> 0
 BEGIN
    SELECT @array_value = LEFT(@array, @separator_poistion-1);
    select @array_value= LTRIM(RTRIM(@array_value));
    Insert into PeopleSymptom(symptoms) Values(@array_value);
    SELECT @array = STUFF(@array, 1, @separator_poistion, '');
    SELECT @separator_poistion = PATINDEX('%' +@separator + '%', @array);
 END

  --Parsing symptomsInPets string.
 SELECT @txtvar = LTRIM(RTRIM(SymptomsInPet)) from PString;
 SET @array = @txtvar;
 SET @array = @array + @separator;
 SELECT @separator_poistion = PATINDEX('%' +@separator + '%', @array);

 WHILE @separator_poistion <> 0
 BEGIN
    SELECT @array_value = LEFT(@array, @separator_poistion-1);
    select @array_value= LTRIM(RTRIM(@array_value));
    Insert into PetSymptom(symptoms) Values(@array_value);
    SELECT @array = STUFF(@array, 1, @separator_poistion, '');
    SELECT @separator_poistion = PATINDEX('%' +@separator + '%', @array);
 END
 --Parsing symptomsInPets string.
 SELECT @txtvar = LTRIM(RTRIM(SymptomsInLivestock)) from PString;
 SET @array = @txtvar;
 SET @array = @array + @separator;
 SELECT @separator_poistion = PATINDEX('%' +@separator + '%', @array);

 WHILE @separator_poistion <> 0
 BEGIN
    SELECT @array_value = LEFT(@array, @separator_poistion-1);
    select @array_value= LTRIM(RTRIM(@array_value));
    Insert into LivestockSymptom(symptoms) Values(@array_value);
    SELECT @array = STUFF(@array, 1, @separator_poistion, '');
    SELECT @separator_poistion = PATINDEX('%' +@separator + '%', @array);
 END
END