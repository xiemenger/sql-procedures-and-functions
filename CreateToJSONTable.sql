USE [**]
GO
/****** Object:  StoredProcedure [dbo].[CreateToJSONTable]    Script Date: 5/8/2018 10:46:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CreateToJSONTable] 
AS
BEGIN
	IF OBJECT_ID('dbo.ToJSON','U') IS NOT NULL
		DROP TABLE dbo.ToJSON;

	SELECT 
		ToxicplantID as id, 
		"common name" as cname,
		"other name" as oname,
		"Scientific Name" as sname,
		"Plant Family" as  family,
		Category as cate,
		"Toxic Plant Parts" as part, 
		"Toxicity Level" as level,
		symphid as symphId,
		symppid as symppId,
		symplid as sympLId,
		"Toxic to people" as toxich,
		"Toxic to pets" as toxicp,
		"Toxic to livestock" as toxicl,
		Notes,
		"photoFile1 (name)" as img1,
		"photocaption1 (description)" as img1t,
		"photocredit (if needed)" as img1c,
		"photoFile2 (name)" as img2,
		"photocaption2 (description)" as img2t,
		"photocredit (if needed)1" as img2c,
		"photoFile3 (name)" as img3,
		"photocaption3 (description)" as img3t,
		"photocredit (if needed)2" as img3c,
		"photoFile4 (name)" as img4,
		"photocaption4 (description)" as img4t,
		"photocredit (if needed)3" as img4c,
		"photoFile5 (name)" as img5,
		"photocaption5 (description)" as img5t,
		"photocredit (if needed)4" as img5c
	INTO ToJSON
	FROM ToxicPlant
	INNER JOIN PLantSymptomTmpTable ON ToxicPlant.ToxicPlantID = PLantSymptomTmpTable.pid;

END
