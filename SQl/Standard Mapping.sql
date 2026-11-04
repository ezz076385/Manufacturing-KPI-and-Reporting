

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME
FROM [Project NTI].INFORMATION_SCHEMA.TABLES

SELECT * INTO [Project NTI].dbo.stg_pvc_2024 FROM master.dbo.[PVC_2024_sql$];
SELECT * INTO [Project NTI].dbo.stg_pvc_2025 FROM master.dbo.[PVC_2025_sql$];
SELECT * INTO [Project NTI].dbo.stg_pvc_2026 FROM master.dbo.[PVC_2026_sql$];
GO

DROP TABLE master.dbo.[PVC_2024_sql$];
DROP TABLE master.dbo.[PVC_2025_sql$];
DROP TABLE master.dbo.[PVC_2026_sql$];

USE [Project NTI];
GO

SELECT 
    TABLE_NAME,
    ORDINAL_POSITION AS pos,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH AS len
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('stg_pvc_2024','stg_pvc_2025','stg_pvc_2026')
ORDER BY TABLE_NAME, ORDINAL_POSITION;


SELECT 'stg_pvc_2024' AS tbl, COUNT(*) AS total_rows,
       SUM(CASE WHEN [التاريخ] IS NULL THEN 1 ELSE 0 END) AS null_date
FROM dbo.stg_pvc_2024
UNION ALL
SELECT 'stg_pvc_2025', COUNT(*), SUM(CASE WHEN [التاريخ] IS NULL THEN 1 ELSE 0 END)
FROM dbo.stg_pvc_2025
UNION ALL
SELECT 'stg_pvc_2026', COUNT(*), SUM(CASE WHEN [التاريخ] IS NULL THEN 1 ELSE 0 END)
FROM dbo.stg_pvc_2026;


DROP TABLE IF EXISTS dbo.work_pvc_2024, dbo.work_pvc_2025, dbo.work_pvc_2026;
SELECT * INTO dbo.work_pvc_2024 FROM dbo.stg_pvc_2024;
SELECT * INTO dbo.work_pvc_2025 FROM dbo.stg_pvc_2025;
SELECT * INTO dbo.work_pvc_2026 FROM dbo.stg_pvc_2026;

-- 2) جدول الـ mapping (السنة، رقم العمود، الاسم الجديد)
DROP TABLE IF EXISTS #map;
CREATE TABLE #map (yr INT, pos INT, new_name SYSNAME);

-- أعمدة مشتركة 1-17 في السنين التلاتة
INSERT #map
SELECT y.yr, v.pos, v.n
FROM (VALUES (2024),(2025),(2026)) y(yr)
CROSS JOIN (VALUES
 (1,'report_date'),(2,'machine_type'),(3,'machine_no'),(4,'die_no'),(5,'shift'),
 (6,'model_desc'),(7,'model'),(8,'model_code'),(9,'production_qty'),(10,'machine_speed'),
 (11,'supervisor'),(12,'technician_1'),(13,'technician_2'),
 (14,'stop_category'),(15,'stop_reason'),(16,'stop_from'),(17,'stop_to')
) v(pos,n);

-- 18-44 مشتركة بين 2024 و2025
INSERT #map
SELECT y.yr, v.pos, v.n
FROM (VALUES (2024),(2025)) y(yr)
CROSS JOIN (VALUES
 (18,'pvc_start_block_kg'),(19,'pvc_scrap_profile_start_kg'),(20,'pvc_scrap_profile_running_kg'),
 (21,'pvc_scrap_angle45_kg'),(22,'pvc_scrap_hole_kg'),(23,'pvc_scrap_injection_kg'),
 (24,'pvc_scrap_roughness_kg'),(25,'pvc_scrap_chamber_kg'),(26,'pvc_report_variance_kg'),
 (27,'pvc_scrap_slab_cut_kg'),(28,'mg_scrap_machine_kg'),(29,'mg_scrap_weld_return_kg'),
 (30,'material'),(31,'lot_no'),(32,'recut_from_weld_cnt'),(33,'recut_from_store_cnt'),
 (34,'stop_minutes'),(35,'stop_planned_min'),(36,'stop_minor_min'),(37,'stop_startup_min'),
 (38,'stop_model_change_min'),(39,'stop_breakdown_min'),(40,'pvc_accepted_weight_kg'),
 (41,'pvc_production_m'),(42,'pvc_abnormal_scrap_kg'),(43,'pvc_total_scrap_kg'),
 (44,'pvc_material_used_kg')
) v(pos,n);

-- 2024: 45-48
INSERT #map VALUES
 (2024,45,'pvc_actual_prod_time_h'),(2024,46,'pvc_standard_time_h'),
 (2024,47,'magnet_material_kg'),(2024,48,'magnet_reel_70_30');

-- 2025: 45-53
INSERT #map VALUES
 (2025,45,'pvc_actual_prod_time_h'),(2025,46,'pvc_planned_prod_hours'),(2025,47,'pvc_standard_time_h'),
 (2025,48,'pvc_performance'),(2025,49,'pvc_availability'),(2025,50,'pvc_quality'),(2025,51,'pvc_oee'),
 (2025,52,'magnet_material_kg'),(2025,53,'magnet_reel_70_30');

-- 2026: 18-76
INSERT #map VALUES
 (2026,18,'pvc_start_block_kg'),(2026,19,'pvc_scrap_profile_start_kg'),(2026,20,'pvc_scrap_cutter_adjust_kg'),
 (2026,21,'pvc_scrap_angle45_kg'),(2026,22,'pvc_scrap_hole_kg'),(2026,23,'pvc_scrap_injection_kg'),
 (2026,24,'pvc_scrap_roughness_kg'),(2026,25,'pvc_scrap_chamber_kg'),(2026,26,'pvc_report_variance_kg'),
 (2026,27,'pvc_scrap_slab_cut_kg'),(2026,28,'pvc_scrap_die_issue_kg'),
 (2026,29,'mg_start_block_kg'),(2026,30,'mg_scrap_start_kg'),(2026,31,'mg_scrap_quality_samples_kg'),
 (2026,32,'mg_scrap_line_break_kg'),(2026,33,'mg_scrap_weld_return_kg'),(2026,34,'mg_scrap_bubbles_kg'),
 (2026,35,'mg_scrap_line_split_kg'),(2026,36,'mg_scrap_no_magnet_kg'),
 (2026,37,'material'),(2026,38,'lot_no'),(2026,39,'recut_from_weld_cnt'),(2026,40,'recut_from_store_cnt'),
 (2026,41,'stop_minutes'),(2026,42,'stop_planned_min'),(2026,43,'stop_minor_min'),(2026,44,'stop_startup_min'),
 (2026,45,'stop_model_change_min'),(2026,46,'stop_breakdown_min'),
 (2026,47,'pvc_accepted_weight_kg'),(2026,48,'pvc_production_m'),(2026,49,'pvc_abnormal_scrap_kg'),
 (2026,50,'pvc_total_scrap_kg'),(2026,51,'pvc_material_used_kg'),
 (2026,52,'pvc_block_scrap_pct'),(2026,53,'pvc_angle_scrap_pct'),(2026,54,'pvc_abnormal_scrap_pct'),
 (2026,55,'pvc_total_scrap_pct'),(2026,56,'pvc_production_value'),
 (2026,57,'pvc_actual_prod_time_h'),(2026,58,'pvc_planned_prod_hours'),(2026,59,'pvc_standard_time_h'),
 (2026,60,'pvc_performance'),(2026,61,'pvc_availability'),(2026,62,'pvc_quality'),(2026,63,'pvc_oee'),
 (2026,64,'mg_accepted_weight_kg'),(2026,65,'mg_total_scrap_kg'),(2026,66,'mg_material_used_kg'),
 (2026,67,'mg_production_m'),(2026,68,'mg_actual_prod_time_h'),(2026,69,'mg_planned_prod_hours'),
 (2026,70,'mg_standard_time_h'),(2026,71,'mg_production_value'),
 (2026,72,'mg_availability'),(2026,73,'mg_performance'),(2026,74,'mg_quality'),(2026,75,'mg_oee'),
 (2026,76,'magnet_reel_70_30');

-- 3) إعادة التسمية بالرقم
DECLARE @yr INT, @pos INT, @new SYSNAME, @tbl NVARCHAR(200), @old SYSNAME, @obj NVARCHAR(400);
DECLARE c CURSOR FOR SELECT yr, pos, new_name FROM #map ORDER BY yr, pos;
OPEN c; FETCH NEXT FROM c INTO @yr, @pos, @new;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @tbl = N'dbo.work_pvc_' + CAST(@yr AS NVARCHAR(4));
    SET @old = NULL;
    SELECT @old = name FROM sys.columns WHERE object_id = OBJECT_ID(@tbl) AND column_id = @pos;
    IF @old IS NULL
        PRINT 'عمود مش موجود: ' + @tbl + ' pos ' + CAST(@pos AS NVARCHAR(5));
    ELSE
    BEGIN
        SET @obj = @tbl + N'.' + QUOTENAME(@old);
        EXEC sp_rename @obj, @new, 'COLUMN';
    END
    FETCH NEXT FROM c INTO @yr, @pos, @new;
END


-- لازم ترجّع صفر صفوف
SELECT OBJECT_NAME(object_id) AS tbl, column_id, name
FROM sys.columns
WHERE object_id IN (OBJECT_ID('dbo.work_pvc_2024'),OBJECT_ID('dbo.work_pvc_2025'),OBJECT_ID('dbo.work_pvc_2026'))
  AND name COLLATE Latin1_General_100_BIN2 LIKE '%[^a-z0-9_]%';

SELECT TOP 5 * FROM dbo.work_pvc_2024;


USE [Project NTI];

-- 1) توحيد الأعمدة: ضيف الناقص بـ NULL
ALTER TABLE dbo.work_pvc_2024 ADD pvc_scrap_cutter_adjust_kg FLOAT NULL, pvc_scrap_die_issue_kg FLOAT NULL,
    mg_start_block_kg FLOAT NULL, mg_scrap_start_kg FLOAT NULL, mg_scrap_quality_samples_kg FLOAT NULL,
    mg_scrap_line_break_kg FLOAT NULL, mg_scrap_bubbles_kg FLOAT NULL, mg_scrap_line_split_kg FLOAT NULL,
    mg_scrap_no_magnet_kg FLOAT NULL, mg_accepted_weight_kg FLOAT NULL, mg_production_m FLOAT NULL;

ALTER TABLE dbo.work_pvc_2025 ADD pvc_scrap_cutter_adjust_kg FLOAT NULL, pvc_scrap_die_issue_kg FLOAT NULL,
    mg_start_block_kg FLOAT NULL, mg_scrap_start_kg FLOAT NULL, mg_scrap_quality_samples_kg FLOAT NULL,
    mg_scrap_line_break_kg FLOAT NULL, mg_scrap_bubbles_kg FLOAT NULL, mg_scrap_line_split_kg FLOAT NULL,
    mg_scrap_no_magnet_kg FLOAT NULL, mg_accepted_weight_kg FLOAT NULL, mg_production_m FLOAT NULL;

ALTER TABLE dbo.work_pvc_2026 ADD pvc_scrap_profile_running_kg FLOAT NULL, mg_scrap_machine_kg FLOAT NULL;

-- 2) الجدول الموحد
DROP TABLE IF EXISTS dbo.clean_production;
CREATE TABLE dbo.clean_production (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    src_year SMALLINT, report_date DATE, machine_type NVARCHAR(20), machine_no INT,
    die_no NVARCHAR(50), shift_no TINYINT, model_desc NVARCHAR(100), model NVARCHAR(100),
    model_code NVARCHAR(100), production_qty DECIMAL(18,2), machine_speed DECIMAL(18,4),
    supervisor NVARCHAR(200), technician_1 NVARCHAR(200), technician_2 NVARCHAR(200),
    material NVARCHAR(100), lot_no NVARCHAR(100),
    stop_category NVARCHAR(100), stop_reason NVARCHAR(200),
    stop_from TIME(0), stop_to TIME(0), stop_minutes DECIMAL(18,2),
    pvc_accepted_weight_kg DECIMAL(18,4), pvc_production_m DECIMAL(18,4), pvc_material_used_kg DECIMAL(18,4),
    mg_accepted_weight_kg DECIMAL(18,4), mg_production_m DECIMAL(18,4),
    pvc_start_block_kg DECIMAL(18,4), pvc_scrap_profile_start_kg DECIMAL(18,4),
    pvc_scrap_profile_running_kg DECIMAL(18,4), pvc_scrap_cutter_adjust_kg DECIMAL(18,4),
    pvc_scrap_angle45_kg DECIMAL(18,4), pvc_scrap_hole_kg DECIMAL(18,4), pvc_scrap_injection_kg DECIMAL(18,4),
    pvc_scrap_roughness_kg DECIMAL(18,4), pvc_scrap_chamber_kg DECIMAL(18,4),
    pvc_report_variance_kg DECIMAL(18,4), pvc_scrap_slab_cut_kg DECIMAL(18,4), pvc_scrap_die_issue_kg DECIMAL(18,4),
    mg_start_block_kg DECIMAL(18,4), mg_scrap_machine_kg DECIMAL(18,4), mg_scrap_start_kg DECIMAL(18,4),
    mg_scrap_quality_samples_kg DECIMAL(18,4), mg_scrap_line_break_kg DECIMAL(18,4),
    mg_scrap_weld_return_kg DECIMAL(18,4), mg_scrap_bubbles_kg DECIMAL(18,4),
    mg_scrap_line_split_kg DECIMAL(18,4), mg_scrap_no_magnet_kg DECIMAL(18,4)
);

-- 3) نفس الاستعلام للسنين التلاتة
DECLARE @tpl NVARCHAR(MAX) = N'
INSERT dbo.clean_production (
    src_year, report_date, machine_type, machine_no, die_no, shift_no, model_desc, model, model_code,
    production_qty, machine_speed, supervisor, technician_1, technician_2, material, lot_no,
    stop_category, stop_reason, stop_from, stop_to, stop_minutes,
    pvc_accepted_weight_kg, pvc_production_m, pvc_material_used_kg, mg_accepted_weight_kg, mg_production_m,
    pvc_start_block_kg, pvc_scrap_profile_start_kg, pvc_scrap_profile_running_kg, pvc_scrap_cutter_adjust_kg,
    pvc_scrap_angle45_kg, pvc_scrap_hole_kg, pvc_scrap_injection_kg, pvc_scrap_roughness_kg,
    pvc_scrap_chamber_kg, pvc_report_variance_kg, pvc_scrap_slab_cut_kg, pvc_scrap_die_issue_kg,
    mg_start_block_kg, mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
    mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg, mg_scrap_line_split_kg,
    mg_scrap_no_magnet_kg)
SELECT
    {Y},
    TRY_CAST(report_date AS DATE),
    NULLIF(LTRIM(RTRIM(machine_type)), SPACE(0)),
    TRY_CAST(machine_no AS INT),
    COALESCE(CONVERT(NVARCHAR(50), TRY_CAST(die_no AS BIGINT)), NULLIF(LTRIM(RTRIM(CONVERT(NVARCHAR(50), die_no))), SPACE(0))),
    CASE WHEN REPLACE(LTRIM(RTRIM(shift)), NCHAR(448), SPACE(0)) = SPACE(0)
         THEN TRY_CAST(NULLIF(LEN(LTRIM(RTRIM(shift))), 0) AS TINYINT) END,
    NULLIF(LTRIM(RTRIM(model_desc)), SPACE(0)),
    NULLIF(LTRIM(RTRIM(model)), SPACE(0)),
    NULLIF(LTRIM(RTRIM(model_code)), SPACE(0)),
    TRY_CAST(production_qty AS DECIMAL(18,2)),
    TRY_CAST(machine_speed AS DECIMAL(18,4)),
    NULLIF(LTRIM(RTRIM(supervisor)), SPACE(0)),
    NULLIF(LTRIM(RTRIM(technician_1)), SPACE(0)),
    NULLIF(LTRIM(RTRIM(technician_2)), SPACE(0)),
    NULLIF(LTRIM(RTRIM(material)), SPACE(0)),
    COALESCE(CONVERT(NVARCHAR(100), TRY_CAST(lot_no AS BIGINT)), NULLIF(LTRIM(RTRIM(CONVERT(NVARCHAR(100), lot_no))), SPACE(0))),
    NULLIF(LTRIM(RTRIM(stop_category)), SPACE(0)),
    NULLIF(LTRIM(RTRIM(stop_reason)), SPACE(0)),
    TRY_CAST(stop_from AS TIME(0)),
    TRY_CAST(stop_to AS TIME(0)),
    TRY_CAST(stop_minutes AS DECIMAL(18,2)),
    TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_production_m AS DECIMAL(18,4)),
    TRY_CAST(pvc_material_used_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_accepted_weight_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_production_m AS DECIMAL(18,4)),
    TRY_CAST(pvc_start_block_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_profile_start_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_profile_running_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_cutter_adjust_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_angle45_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_hole_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_injection_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_roughness_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_chamber_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_report_variance_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_slab_cut_kg AS DECIMAL(18,4)),
    TRY_CAST(pvc_scrap_die_issue_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_start_block_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_machine_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_start_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_quality_samples_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_line_break_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_weld_return_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_bubbles_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_line_split_kg AS DECIMAL(18,4)),
    TRY_CAST(mg_scrap_no_magnet_kg AS DECIMAL(18,4))
FROM dbo.work_pvc_{Y}
WHERE report_date IS NOT NULL
ORDER BY report_date;';

DECLARE @sql NVARCHAR(MAX);
SET @sql = REPLACE(@tpl, N'{Y}', N'2024'); EXEC sp_executesql @sql;
SET @sql = REPLACE(@tpl, N'{Y}', N'2025'); EXEC sp_executesql @sql;
SET @sql = REPLACE(@tpl, N'{Y}', N'2026'); EXEC sp_executesql @sql;

-- 1) الأعداد: المفروض 7879 و6962 و2820، وshift_null و bad_type صفر
SELECT src_year, COUNT(*) AS rows_n,
       SUM(CASE WHEN shift_no IS NULL THEN 1 ELSE 0 END) AS shift_null,
       SUM(CASE WHEN machine_type IS NULL OR machine_type NOT IN ('PVC','MG') THEN 1 ELSE 0 END) AS bad_type,
       MIN(report_date) AS d_min, MAX(report_date) AS d_max
FROM dbo.clean_production GROUP BY src_year ORDER BY src_year;



SELECT *
FROM  dbo.work_pvc_2024


SELECT
    src_year,
    COUNT(*) AS row_count,
    COUNT(report_date) AS date_count,
    COUNT(machine_no) AS machine_count,
    COUNT(model_code) AS model_code_count,
    COUNT(production_qty) AS production_qty_count
FROM dbo.clean_production
GROUP BY src_year
ORDER BY src_year;

SELECT
    src_year,
    COUNT(*) AS rows_with_missing_model_code
FROM dbo.clean_production
WHERE model_code IS NULL
GROUP BY src_year
ORDER BY src_year;

SELECT
    src_year,
    COUNT(*) AS missing_production_qty
FROM dbo.clean_production
WHERE production_qty IS NULL
GROUP BY src_year
ORDER BY src_year;


SELECT
    src_year,
    machine_type,
    COUNT(*) AS rows_count
FROM dbo.clean_production
WHERE model_code IS NULL
GROUP BY
    src_year,
    machine_type

ORDER BY
    src_year,
    machine_type

    SELECT *
FROM dbo.clean_production
WHERE machine_no IS NULL;


-- 1) Pattern بتاع Missing Model Code
SELECT
    src_year,
    machine_type,
    COUNT(*) AS rows_count
FROM dbo.clean_production
WHERE model_code IS NULL
GROUP BY
    src_year,
    machine_type
ORDER BY
    src_year,
    machine_type



    -- 2) Missing Production Quantity
SELECT
    src_year,
    machine_type,
    COUNT(*) AS missing_production_qty
FROM dbo.clean_production
WHERE production_qty IS NULL
GROUP BY
    src_year,
    machine_type
ORDER BY
    src_year,
    machine_type;


    -- 3) الـ Machine الوحيد الناقص في 2026
SELECT *
FROM dbo.clean_production
WHERE machine_no IS NULL;


SELECT
    src_year,
    COUNT(*) AS total_missing_code,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS model_also_null,
    SUM(CASE WHEN model IS NOT NULL THEN 1 ELSE 0 END) AS model_exists
FROM dbo.clean_production
WHERE model_code IS NULL
GROUP BY src_year
ORDER BY src_year;

----------------------------------------------------------
SELECT
    src_year,
    machine_type,
    COUNT(*) AS missing_production_qty
FROM dbo.clean_production
WHERE production_qty IS NULL
GROUP BY
    src_year,
    machine_type
ORDER BY
    src_year,
    machine_type;


    SELECT
    src_year,
    machine_type,
    stop_category,
    stop_reason,
    COUNT(*) AS rows_count
FROM dbo.clean_production
WHERE production_qty IS NULL
GROUP BY
    src_year,
    machine_type,
    stop_category,
    stop_reason
ORDER BY
    src_year,
    machine_type;



    SELECT
    src_year,
    report_date,
    machine_type,
    machine_no,
    model,
    model_code,
    production_qty,
    stop_category,
    stop_reason,
    stop_from,
    stop_to
FROM dbo.clean_production
WHERE machine_no IS NULL;