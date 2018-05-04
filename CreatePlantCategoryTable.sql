USE [FFL_ToxicPlants]
GO
/****** Object:  StoredProcedure [dbo].[CreatePlantCategoryTable]    Script Date: 5/4/2018 9:45:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Diane Xie>
-- Create date: <4/30/2018>
-- Description:	<Test Parsing function>
-- =============================================
ALTER PROCEDURE [dbo].[CreatePlantCategoryTable]
AS
BEGIN 
    -- Create tables
	IF OBJECT_ID('dbo.PlantCategory','U') IS NOT NULL
		DROP TABLE dbo.PlantCategory;


	SELECT ToxicPlantID as CategoryId, ToxicPlantID, Category AS categoriesTmp 
	INTO PlantCategory
	FROM ToxicPlant;

	ALTER TABLE PlantCategory
	ALTER COLUMN CategoryId INT NOT NULL;

	ALTER TABLE PlantCategory
	ALTER COLUMN ToxicPlantID INT NOT NULL;

	ALTER TABLE PlantCategory
	ALTER COLUMN categoriesTmp varchar(100) NOT NULL;

	-- Add a new column to process row by row
	-- Will delete this column later
	ALTER TABLE PlantCategory
	ADD processed INT NOT NULL
	CONSTRAINT tmp DEFAULT 0; 

	
	ALTER TABLE PlantCategory
	ADD Categories Varchar(100);

	DECLARE @maxIdx int;
	DECLARE @rowValue Varchar(200);
	DECLARE @tmpValue Varchar(200);
	DECLARE @tmpToxicPlantID int;
	DECLARE @separator char(1);
	DECLARE @pos int;
	DECLARE @singleCategory Varchar(50);
	DECLARE @matchId int;
	DECLARE @oldValue Varchar(200);

	SET @separator = '/';
	WHILE (SELECT COUNT(*) FROM PlantCategory WHERE processed = 0) > 0
	BEGIN
		SELECT TOP 1 @rowValue = categoriesTmp,
					 @tmpToxicPlantID = ToxicPlantID,  
					 @oldValue = Categories 
		FROM PlantCategory WHERE processed = 0;

		SELECT @rowValue = LTRIM(RTRIM(@rowValue));
		SET @rowValue = @rowValue + @separator;
		SELECT @pos = PATINDEX('%' + @separator + '%', @rowValue);

		WHILE @pos <> 0
		BEGIN
			SELECT @singleCategory = LEFT(@rowValue, @pos-1);
			SELECT @singleCategory = LTRIM(RTRIM(@singleCategory));
			SELECT @matchID = CategoryID FROM Category WHERE CategoryName = @singleCategory;
			
			if (@oldValue IS NULL)
				SET @oldValue = '' +  @matchID;
			ELSE 
				SET @oldValue = @oldValue + ',' +  CAST(@matchID AS VARCHAR(16));

			UPDATE PlantCategory SET Categories = @oldValue WHERE ToxicPlantID = @tmpToxicPlantID;
			SELECT @rowValue = STUFF(@rowValue, 1, @pos, '');
			SELECT @pos = PATINDEX('%' +@separator + '%', @rowValue);
		END

		UPDATE PlantCategory SET processed = 1 WHERE ToxicPlantID = @tmpToxicPlantID;
	END
	ALTER TABLE PlantCategory DROP CONSTRAINT tmp;
	ALTER TABLE PlantCategory DROP COLUMN categoriesTmp;
	ALTER TABLE PlantCategory DROP COLUMN processed;
END
