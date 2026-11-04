SELECT
    YEAR(report_date) AS yr,
    COUNT(*) AS total_rows,
    COUNT(planned_production_hours) AS planned_not_null
FROM FactProduction
GROUP BY YEAR(report_date)
ORDER BY yr;

SELECT *
FROM FactProduction
where Source_Date


UPDATE f
SET f.PVC_Planned_Production_Hours = s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ]
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id                 -- غيّر row_id لأي مفتاح موجود في الجدولين
WHERE f.PVC_Planned_Production_Hours IS NULL
  AND s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] BETWEEN 0 AND 24;

ALTER TABLE FactProduction ADD row_id INT IDENTITY(1,1);

  SELECT * INTO FactProduction_backup FROM FactProduction;

  ALTER TABLE FactProduction
ALTER COLUMN PVC_Planned_Production_Hours DECIMAL(18,4);



UPDATE f
SET f.PVC_Planned_Production_Hours =
    CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4))
FROM FactProduction AS f
JOIN[dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id  
WHERE f.PVC_Planned_Production_Hours IS NULL
  AND TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4)) BETWEEN 0 AND 24;

  SELECT COUNT(*) AS total,
       COUNT(PVC_Planned_Production_Hours) AS filled
FROM FactProduction
WHERE Source_Year = '2024';


UPDATE f
SET f.PVC_Planned_Production_Hours =
    TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4))
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id
WHERE f.PVC_Planned_Production_Hours IS NULL
  AND TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4)) BETWEEN 0 AND 24;


  SELECT COUNT(*) AS matched_rows
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id;


    SELECT
    COUNT(*) AS total_rows,
    COUNT(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ]) AS not_null,
    COUNT(TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4))) AS numeric_ok,
    SUM(CASE WHEN s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] LIKE '%,%' THEN 1 ELSE 0 END) AS comma_values
FROM [dbo].[stg_pvc_2024] AS s;

SELECT TOP 20
    s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS raw_value,
    LEN(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ]) AS len_value
FROM [dbo].[stg_pvc_2024] AS s
WHERE TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4)) IS NULL;


SELECT TOP 5
    s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS raw_value,
    DATALENGTH(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ]) AS bytes_len,
    UNICODE(LEFT(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ], 1)) AS first_char_code
FROM [dbo].[stg_pvc_2024] AS s
WHERE TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4)) IS NULL;




UPDATE f
SET f.PVC_Planned_Production_Hours =
    TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4))
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id
WHERE TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4)) BETWEEN 0 AND 24;



SELECT
    COUNT(*) AS total_fact_rows,
    COUNT(PVC_Planned_Production_Hours) AS filled,
    SUM(CASE WHEN PVC_Planned_Production_Hours > 24 THEN 1 ELSE 0 END) AS over_24
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id;


    UPDATE f
SET f.PVC_Planned_Production_Hours =
    TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4))
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id
WHERE TRY_CAST(s.[PVC_الوقت المخطط لانتاج حسب سرعه الماكينه ] AS DECIMAL(18,4)) >= 0;


SELECT
    COUNT(*) AS total_fact_rows,
    COUNT(f.PVC_Planned_Production_Hours) AS filled,
    MAX(f.PVC_Planned_Production_Hours) AS max_value
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id;

    SELECT TOP 5
    f.Production_Key,
    f.PVC_Planned_Production_Hours,
    s.*
FROM FactProduction AS f
JOIN [dbo].[stg_pvc_2024] AS s
    ON f.Production_Key = s.row_id
ORDER BY f.PVC_Planned_Production_Hours DESC;


SELECT
    COUNT(*) AS total_rows,
    COUNT(report_date) AS has_date,
    COUNT(Production_Key) AS has_key,
    COUNT(PVC_Planned_Production_Hours) AS has_planned,
    COUNT(Downtime_Duration) AS has_downtime
FROM FactProduction;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactProduction'
ORDER BY ORDINAL_POSITION;

SELECT
    Source_Year,
    COUNT(*) AS total_rows,
    COUNT(PVC_Planned_Production_Hours) AS planned_filled,
    COUNT(Downtime_Duration) AS downtime_filled,
    COUNT(PVC_Standard_Machine_Time) AS standard_filled,
    COUNT(PVC_Accepted_Production) AS accepted_filled
FROM FactProduction
GROUP BY Source_Year
ORDER BY Source_Year;


SELECT
    COUNT(*) AS total_2024,
    COUNT(PVC_Planned_Production_Hours) AS planned,
    COUNT(Downtime_Duration) AS downtime,
    COUNT(PVC_Standard_Machine_Time) AS standard_time,
    COUNT(PVC_Accepted_Production) AS accepted,
    COUNT(PVC_Total_Waste) AS total_waste,
    COUNT(PVC_Raw_Material_Used) AS raw_material,
    COUNT(PVC_Availability) AS availability,
    COUNT(PVC_Performance) AS performance,
    COUNT(PVC_Quality_Rate) AS quality,
    COUNT(PVC_OEE) AS oee
FROM FactProduction
WHERE Source_Year = 2024;

SELECT * INTO FactProduction_backup_2024 FROM FactProduction WHERE Source_Year = 2024;



UPDATE FactProduction
SET
    PVC_Availability =
        1.0 - (Downtime_Duration / NULLIF(PVC_Planned_Production_Hours, 0)),
    PVC_Performance =
        PVC_Standard_Machine_Time / NULLIF(PVC_Planned_Production_Hours - Downtime_Duration, 0),
    PVC_Quality_Rate =
        PVC_Accepted_Production / NULLIF(PVC_Raw_Material_Used, 0)
WHERE Source_Year = 2024
  AND PVC_Planned_Production_Hours > 0;

  UPDATE FactProduction
SET PVC_OEE = PVC_Availability * PVC_Performance * PVC_Quality_Rate
WHERE Source_Year = 2024
  AND PVC_Availability IS NOT NULL
  AND PVC_Performance IS NOT NULL
  AND PVC_Quality_Rate IS NOT NULL;


  SELECT TOP 5 Downtime_Duration, PVC_Planned_Production_Hours
FROM FactProduction
WHERE Source_Year = 2024 AND PVC_Planned_Production_Hours > 0 AND Downtime_Duration > 0;


SELECT
    COUNT(PVC_Availability) AS avail_filled,
    COUNT(PVC_Performance) AS perf_filled,
    COUNT(PVC_Quality_Rate) AS quality_filled,
    COUNT(PVC_OEE) AS oee_filled,
    AVG(PVC_Availability) AS avg_avail,
    AVG(PVC_Performance) AS avg_perf,
    AVG(PVC_Quality_Rate) AS avg_quality,
    AVG(PVC_OEE) AS avg_oee,
    MAX(PVC_Availability) AS max_avail,
    MAX(PVC_Performance) AS max_perf
FROM FactProduction
WHERE Source_Year = 2024;


SELECT
    SUM(PVC_Planned_Production_Hours) AS total_planned,
    SUM(Downtime_Duration) AS total_downtime,
    COUNT(*) AS rows_with_planned,
    SUM(CASE WHEN Downtime_Duration > PVC_Planned_Production_Hours THEN 1 ELSE 0 END) AS rows_downtime_over_planned,
    MAX(Downtime_Duration) AS max_downtime,
    MAX(PVC_Planned_Production_Hours) AS max_planned
FROM FactProduction
WHERE Source_Year = 2024
  AND PVC_Planned_Production_Hours > 0;

  SELECT TOP 5 PVC_Standard_Machine_Time, PVC_Planned_Production_Hours, Downtime_Duration
FROM FactProduction
WHERE Source_Year = 2024 AND PVC_Planned_Production_Hours > 0
ORDER BY PVC_Standard_Machine_Time DESC;


USE [Project NTI];
GO

ALTER TABLE dbo.FactProduction ADD
    Supervisor_Key  INT NULL,
    Technician1_Key INT NULL,
    Technician2_Key INT NULL;
GO

ALTER TABLE dbo.FactProduction
    ADD CONSTRAINT FK_Fact_Supervisor  FOREIGN KEY (Supervisor_Key)  REFERENCES dbo.DimEmployee(Employee_Key);
ALTER TABLE dbo.FactProduction
    ADD CONSTRAINT FK_Fact_Technician1 FOREIGN KEY (Technician1_Key) REFERENCES dbo.DimEmployee(Employee_Key);
ALTER TABLE dbo.FactProduction
    ADD CONSTRAINT FK_Fact_Technician2 FOREIGN KEY (Technician2_Key) REFERENCES dbo.DimEmployee(Employee_Key);
GO


SELECT * 
FROM [dbo].[DimEmployee]



UPDATE s SET s.Supervisor_Key = e.Employee_Key
FROM dbo.Staging_PVC_2026 s
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(s.[إسم المشرف]));

UPDATE s SET s.Technician1_Key = e.Employee_Key
FROM dbo.Staging_PVC_2026 s
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(s.[إسم الفنى الأول]));

UPDATE s SET s.Technician2_Key = e.Employee_Key
FROM dbo.Staging_PVC_2026 s
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(s.[إسم الفنى الثانى]));
GO


USE [Project NTI];
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    ORDINAL_POSITION AS Col_No,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_NAME, ORDINAL_POSITION;

USE [Project NTI];
GO

ALTER TABLE dbo.clean_production ADD
    supervisor_key  INT NULL,
    technician1_key INT NULL,
    technician2_key INT NULL;
GO

UPDATE c
SET c.supervisor_key = e.Employee_Key
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(c.supervisor));

UPDATE c
SET c.technician1_key = e.Employee_Key
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(c.technician_1));

UPDATE c
SET c.technician2_key = e.Employee_Key
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(c.technician_2));
GO


USE [Project NTI];
GO

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'clean_production'
  AND COLUMN_NAME IN ('supervisor_key', 'technician1_key', 'technician2_key');

  
UPDATE c
SET c.supervisor_key = e.Employee_Key
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(c.supervisor));

UPDATE c
SET c.technician1_key = e.Employee_Key
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(c.technician_1));

UPDATE c
SET c.technician2_key = e.Employee_Key
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Name = LTRIM(RTRIM(c.technician_2));
GO   


SELECT COUNT(*) AS total_rows,
       COUNT(supervisor_key)  AS sup_filled,
       COUNT(technician1_key) AS tech1_filled,
       COUNT(technician2_key) AS tech2_filled
FROM dbo.clean_production;

SELECT DISTINCT supervisor
FROM dbo.clean_production
WHERE supervisor_key IS NULL
  AND LTRIM(RTRIM(supervisor)) <> '';

SELECT DISTINCT technician_1
FROM dbo.clean_production
WHERE technician1_key IS NULL
  AND LTRIM(RTRIM(technician_1)) <> '';

SELECT DISTINCT technician_2
FROM dbo.clean_production
WHERE technician2_key IS NULL
  AND LTRIM(RTRIM(technician_2)) <> '';


  USE [Project NTI];
GO

SELECT
    e.Employee_Name AS supervisor,
    COUNT(*) AS production_rows,
    SUM(c.pvc_material_used_kg) AS material_used_kg,
    SUM(c.pvc_material_used_kg - c.pvc_accepted_weight_kg) AS waste_kg,
    CAST(
        100.0 * SUM(c.pvc_material_used_kg - c.pvc_accepted_weight_kg)
        / NULLIF(SUM(c.pvc_material_used_kg), 0)
    AS DECIMAL(5,2)) AS waste_pct,
    SUM(c.stop_minutes) AS downtime_min
FROM dbo.clean_production c
JOIN dbo.DimEmployee e ON e.Employee_Key = c.supervisor_key
GROUP BY e.Employee_Name
ORDER BY waste_pct DESC;