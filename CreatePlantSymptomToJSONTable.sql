USE [**]
GO
/****** Object:  StoredProcedure [dbo].[CreatePlantSymptomToJSONTable]    Script Date: 5/7/2018 3:19:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Diane Xie>
-- Create date: <4/30/2018>
-- Description:	<Test Parsing function>
-- =============================================

ALTER PROCEDURE [dbo].[CreatePlantSymptomToJSONTable]
AS

BEGIN 
    -- Create tables
	IF OBJECT_ID('dbo.PlantSymptomTmpTable','U') IS NOT NULL
		DROP TABLE dbo.PlantSymptomTmpTable;

	SELECT ToxicPlantID as id, 
			SymptomsInpeople,
			SymptomsInpets, 
			SymptomsInlivestock 
	INTO PlantSymptomTmpTable
	FROM ToxicPlant;

	-- Add a new column to process row by row
	-- Will delete this column later
	ALTER TABLE PlantSymptomTmpTable
	ADD processed INT NOT NULL
	CONSTRAINT tmp DEFAULT 0; 
	
	ALTER TABLE PlantSymptomTmpTable
	ADD symphId varchar(50);

	ALTER TABLE PlantSymptomTmpTable
	ADD symppId varchar(50);

	ALTER TABLE PlantSymptomTmpTable
	ADD symplId varchar(50);

	DECLARE @maxIdx int;
	DECLARE @rowValue Varchar(200);
	DECLARE @peopleValue Varchar(200);
	DECLARE @petValue Varchar(200);
	DECLARE @livestockValue Varchar(200);
	DECLARE @tmpValue Varchar(200);
	DECLARE @tmpToxicPlantID int;
	DECLARE @separator char(1);
	DECLARE @pos int;
	DECLARE @singleSymp Varchar(50);
	DECLARE @matchId int;
	DECLARE @oldValue Varchar(200);

	SET @separator = ',';
	WHILE (SELECT COUNT(*) FROM PlantSymptomTmpTable WHERE processed = 0) > 0
	BEGIN
		SELECT TOP 1 @peopleValue = SymptomsInpeople,
					 @petValue = SymptomsInpets,
					 @livestockValue = SymptomsInlivestock,
					 @tmpToxicPlantID = id 
					 --@oldValue = symphid 
		FROM PlantSymptomTmpTable WHERE processed = 0;

		-- process SymptomsInPeople
		Set @rowValue = @peopleValue;
		SELECT @rowValue = LTRIM(RTRIM(@rowValue));
		SET @rowValue = @rowValue + @separator;
		SELECT @pos = PATINDEX('%' + @separator + '%', @rowValue);
		Set @oldValue = NULL;

		WHILE @pos <> 0
		BEGIN
			SELECT @singleSymp = LEFT(@rowValue, @pos-1);
			SELECT @singleSymp = LTRIM(RTRIM(@singleSymp));
			SELECT @matchID = SymptomID FROM PeopleSymptom WHERE symptoms = @singleSymp;

			if (@oldValue IS NULL)
				SET @oldValue = '[' + CAST(@matchID AS VARCHAR(16));
			ELSE 
				SET @oldValue = @oldValue + ',' +  CAST(@matchID AS VARCHAR(16));

			SELECT @rowValue = STUFF(@rowValue, 1, @pos, '');
			SELECT @pos = PATINDEX('%' +@separator + '%', @rowValue);
		END
		SET @oldValue = @oldValue + ']';
		UPDATE PlantSymptomTmpTable SET symphid = @oldValue WHERE id = @tmpToxicPlantID;


	-- Process SymptomsInPets
		Set @rowValue = @petValue;
		SELECT @rowValue = LTRIM(RTRIM(@rowValue));
		SET @rowValue = @rowValue + @separator;
		SELECT @pos = PATINDEX('%' + @separator + '%', @rowValue);
		Set @oldValue = NULL;

		WHILE @pos <> 0
		BEGIN
			SELECT @singleSymp = LEFT(@rowValue, @pos-1);
			SELECT @singleSymp = LTRIM(RTRIM(@singleSymp));
			SELECT @matchID = SymptomID FROM PetSymptom WHERE symptoms = @singleSymp;

			if (@oldValue IS NULL)
				SET @oldValue = '[' + CAST(@matchID AS VARCHAR(16));
			ELSE 
				SET @oldValue = @oldValue + ',' +  CAST(@matchID AS VARCHAR(16));

			SELECT @rowValue = STUFF(@rowValue, 1, @pos, '');
			SELECT @pos = PATINDEX('%' +@separator + '%', @rowValue);
		END
		SET @oldValue = @oldValue + ']';
		UPDATE PlantSymptomTmpTable SET symppId = @oldValue WHERE id = @tmpToxicPlantID;


	-- Process SymptomsInLikevstock
		Set @rowValue = @livestockValue;
		SELECT @rowValue = LTRIM(RTRIM(@rowValue));
		SET @rowValue = @rowValue + @separator;
		SELECT @pos = PATINDEX('%' + @separator + '%', @rowValue);
		Set @oldValue = NULL;

		WHILE @pos <> 0
		BEGIN
			SELECT @singleSymp = LEFT(@rowValue, @pos-1);
			SELECT @singleSymp = LTRIM(RTRIM(@singleSymp));
			SELECT @matchID = SymptomID FROM LivestockSymptom WHERE symptoms = @singleSymp;

			if (@oldValue IS NULL)
				SET @oldValue = '[' + CAST(@matchID AS VARCHAR(16));
			ELSE 
				SET @oldValue = @oldValue + ',' +  CAST(@matchID AS VARCHAR(16));

			SELECT @rowValue = STUFF(@rowValue, 1, @pos, '');
			SELECT @pos = PATINDEX('%' +@separator + '%', @rowValue);
		END
		SET @oldValue = @oldValue + ']';
		UPDATE PlantSymptomTmpTable SET symplId = @oldValue WHERE id = @tmpToxicPlantID;

		UPDATE PlantSymptomTmpTable SET processed = 1 WHERE id = @tmpToxicPlantID;
	END

END
