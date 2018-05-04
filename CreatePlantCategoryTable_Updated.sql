USE [FFL_ToxicPlants]
GO
/****** Object:  StoredProcedure [dbo].[CreatePlantCategoryTable]    Script Date: 5/4/2018 11:42:52 AM ******/
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
	
	CREATE TABLE PlantCategory(
		PlantCategoryID int NOT NULL,
		ToxicPlantID int NOT NULL,
		CategoryID int,
		primary key (PlantCategoryID)
	)

	-- Create a temporary table, will drop it in the end
	IF OBJECT_ID('dbo.PlantCategoryTmp','U') IS NOT NULL
	DROP TABLE dbo.PlantCategoryTmp;

	SELECT ToxicPlantID, Category 
	INTO PlantCategoryTmp
	FROM ToxicPlant;

	ALTER TABLE PlantCategoryTmp
	ADD processed INT NOT NULL
	CONSTRAINT tmp DEFAULT 0; 

	DECLARE @maxIdx int;
	DECLARE @rowValue Varchar(200);
	DECLARE @tmpToxicPlantID int;
	DECLARE @separator char(1);
	DECLARE @pos int;
	DECLARE @singleCategory Varchar(50);
	DECLARE @matchId int;
	DECLARE @plantCtgIdIdx int;

	SET @separator = '/';
	SET @plantCtgIdIdx = 0;
	
	-- Start to process data
	WHILE (SELECT COUNT(*) FROM PlantCategoryTmp WHERE processed = 0) > 0
	BEGIN
		SELECT TOP 1 @rowValue = Category,
					 @tmpToxicPlantID = ToxicPlantID
		FROM PlantCategoryTmp WHERE processed = 0;

		SELECT @rowValue = LTRIM(RTRIM(@rowValue));
		SET @rowValue = @rowValue + @separator;
		SELECT @pos = PATINDEX('%' + @separator + '%', @rowValue);

		WHILE @pos <> 0
		BEGIN
			SET @plantCtgIdIdx = @plantCtgIdIdx + 1;
			SELECT @singleCategory = LEFT(@rowValue, @pos-1);
			SELECT @singleCategory = LTRIM(RTRIM(@singleCategory));
			SELECT @matchID = CategoryID FROM Category WHERE CategoryName = @singleCategory;
			
			INSERT INTO PlantCategory(PlantCategoryID, ToxicPlantID, CategoryID) VALUES(@plantCtgIdIdx, @tmpToxicPlantID, @matchID);

			SELECT @rowValue = STUFF(@rowValue, 1, @pos, '');
			SELECT @pos = PATINDEX('%' +@separator + '%', @rowValue);
		END

		UPDATE PlantCategoryTmp SET processed = 1 WHERE ToxicPlantID = @tmpToxicPlantID;
	END	

	DROP TABLE PlantCategoryTmp;
END
