-- Check if the two table has the same id and same name or not:
SELECT *
FROM ToxicPlant AS t1 join ToxicPlant AS t2 on t1.ToxicPlantID = t2.ToxicPlantID
WHERE t1.toxicPlantID = t2.toxicPlantId and t1.[Common Name] != t2.[Common Name];


-- Upper the first character in the name :
UPDATE ToxicPlant
SET "Common Name" = UPPER(LEFT("Common Name",1))+LOWER(SUBSTRING("Common Name",2,LEN("Common Name")));


-- Add several foreignkey at the same time:
ALTER TABLE PlantLivestockSymptom
ADD CONSTRAINT livestockSymptomFK
FOREIGN KEY (ToxicPlantID) REFERENCES ToxicPlant (ToxicPlantID),
FOREIGN KEY (LivestockSymptomID) REFERENCES [FFL_ToxicPlants].[dbo].[LivestockSymptom] (SymptomID);
