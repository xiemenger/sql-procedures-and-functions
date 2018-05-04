
/****** Object:  StoredProcedure [dbo].[CreatePlantLivestockSymptomTable]    Script Date: 5/4/2018 3:26:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Diane Xie>
-- Create date: <5/4/2018>
-- Description:	<[CreatePlantLivestockSymptomTable]>
-- =============================================
ALTER PROCEDURE [dbo].[CreatePlantLivestockSymptomTable]
AS
BEGIN 
    -- Create tables
	IF OBJECT_ID('dbo.PlantLivestockSymptom','U') IS NOT NULL
		DROP TABLE dbo.PlantLivestockSymptom;
	
	CREATE TABLE PlantLivestockSymptom(
		PlantLivestockSymptomID int IDENTITY(1,1),
		ToxicPlantID int not null,
		LivestockSymptomID int,
		primary key (PlantLivestockSymptomID)
	)

	IF OBJECT_ID('dbo.TmpTable','U') IS NOT NULL
	DROP TABLE dbo.TmpTable;

	SELECT ToxicPlantID, SymptomsInlivestock 
	INTO TmpTable
	FROM ToxicPlant;

	ALTER TABLE TmpTable
	ADD processed INT NOT NULL
	CONSTRAINT tmp DEFAULT 0; 

	DECLARE @maxIdx int;
	DECLARE @SymptomValue Varchar(200);
	DECLARE @tmpToxicPlantID int;
	DECLARE @separator char(1);
	DECLARE @pos int;
	DECLARE @singleSymtom Varchar(50);
	DECLARE @matchId int;
	DECLARE @plantCtgIdIdx int;

	SET @separator = ',';
	SET @plantCtgIdIdx = 0;
	
	-- Start to process data
	WHILE (SELECT COUNT(*) FROM TmpTable WHERE processed = 0) > 0
	BEGIN
		SELECT TOP 1 @SymptomValue = SymptomsInlivestock,
					 @tmpToxicPlantID = ToxicPlantID
		FROM TmpTable WHERE processed = 0;

		SELECT @SymptomValue = LTRIM(RTRIM(@SymptomValue));
		SET @SymptomValue = @SymptomValue + @separator;
		SELECT @pos = PATINDEX('%' + @separator + '%', @SymptomValue);

		WHILE @pos <> 0
		BEGIN
			SELECT @singleSymtom = LEFT(@SymptomValue, @pos-1);
			SELECT @singleSymtom = LTRIM(RTRIM(@singleSymtom));
			PRINT @tmpToxicPlantID;
			PRINT @singleSymtom;
			SELECT @matchID = SymptomID FROM LivestockSymptom WHERE symptoms = @singleSymtom;
			PRINT @matchID;
			INSERT INTO PlantLivestockSymptom(ToxicPlantID, LivestockSymptomID) VALUES(@tmpToxicPlantID, @matchID);

			SELECT @SymptomValue = STUFF(@SymptomValue, 1, @pos, '');
			SELECT @pos = PATINDEX('%' +@separator + '%', @SymptomValue);
		END

		UPDATE TmpTable SET processed = 1 WHERE ToxicPlantID = @tmpToxicPlantID;
	END	

	DROP TABLE TmpTable;

END
