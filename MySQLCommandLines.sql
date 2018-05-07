-- Check if the two table has the same id and same name or not:
SELECT *
FROM ToxicPlant AS t1 join ToxicPlant AS t2 on t1.ToxicPlantID = t2.ToxicPlantID
WHERE t1.toxicPlantID = t2.toxicPlantId and t1.[Common Name] != t2.[Common Name];
