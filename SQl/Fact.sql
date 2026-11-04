SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT
        CONCAT(
            src_year, '|',
            CONVERT(varchar(10), report_date, 120), '|',
            ISNULL(machine_type, ''), '|',
            ISNULL(CONVERT(varchar(50), machine_no), ''), '|',
            ISNULL(CONVERT(varchar(50), die_no), ''), '|',
            ISNULL(shift_no, ''), '|',
            ISNULL(model_code, '')
        )
    ) AS Distinct_Business_Combination
FROM dbo.clean_production;

----------------------------------------------
SELECT
    COUNT(*) AS Total_Rows,

    SUM(CASE WHEN production_qty IS NULL THEN 1 ELSE 0 END) AS Null_Production_Qty,

    SUM(CASE WHEN machine_no IS NULL THEN 1 ELSE 0 END) AS Null_Machine,

    SUM(CASE WHEN report_date IS NULL THEN 1 ELSE 0 END) AS Null_Date,

    SUM(CASE WHEN machine_type IS NULL THEN 1 ELSE 0 END) AS Null_Machine_Type,

    SUM(CASE WHEN shift_no IS NULL THEN 1 ELSE 0 END) AS Null_Shift
FROM dbo.clean_production;
-----------------------------------------------------------------------

SELECT
    src_year,
    COUNT(*) AS Row_Count,
    SUM(ISNULL(production_qty, 0)) AS Total_Production_Qty
FROM dbo.clean_production
GROUP BY src_year
ORDER BY src_year;

----------------------------------------------------------------------
----------------------------------------------------------------------
CREATE TABLE dbo.FactProduction
(
    Production_Key BIGINT IDENTITY(1,1) PRIMARY KEY,

    Date_Key INT NOT NULL,
    Machine_Key INT NULL,
    Model_Key INT NULL,

    Shift NVARCHAR(50) NULL,

    Source_Year INT NOT NULL,

    Production_Qty FLOAT NULL,

    Machine_Speed FLOAT NULL,

    Downtime_Duration FLOAT NULL,

    Planned_Downtime FLOAT NULL,

    Minor_Downtime FLOAT NULL,

    Startup_Downtime FLOAT NULL,

    Model_Change_Downtime FLOAT NULL,

    Unexpected_Failure_Downtime FLOAT NULL,

    PVC_Accepted_Production FLOAT NULL,
    PVC_Production_Meter FLOAT NULL,
    PVC_Total_Waste FLOAT NULL,
    PVC_Abnormal_Waste FLOAT NULL,
    PVC_Raw_Material_Used FLOAT NULL,

    PVC_Actual_Production_Time FLOAT NULL,
    PVC_Planned_Production_Hours FLOAT NULL,
    PVC_Standard_Machine_Time FLOAT NULL,

    PVC_Availability FLOAT NULL,
    PVC_Performance FLOAT NULL,
    PVC_Quality_Rate FLOAT NULL,
    PVC_OEE FLOAT NULL
);


------------------------------------------------------------
EXEC sp_rename 'dbo.factproductuin', 'FactProduction';

SELECT *
FROM [dbo].[FactProduction]

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'clean_production'
ORDER BY ORDINAL_POSITION;


SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%fact%'
   OR TABLE_NAME LIKE '%prod%';


 


   SELECT 
    TABLE_NAME,
    STRING_AGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY ORDINAL_POSITION) AS columns_list
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME <> 'clean_production'
  AND TABLE_NAME NOT LIKE '%sql$%'
GROUP BY TABLE_NAME
ORDER BY TABLE_NAME;


;WITH src AS (
    SELECT 2024 AS src_year, report_date, machine_type, machine_no, model_code, shift,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           pvc_accepted_weight_kg, pvc_production_m, pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           pvc_material_used_kg, pvc_actual_prod_time_h,
           NULL AS pvc_planned_prod_hours, pvc_standard_time_h,
           NULL AS pvc_availability, NULL AS pvc_performance, NULL AS pvc_quality, NULL AS pvc_oee
    FROM dbo.work_pvc_2024

    UNION ALL

    SELECT 2025, report_date, machine_type, machine_no, model_code, shift,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           pvc_accepted_weight_kg, pvc_production_m, pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           pvc_material_used_kg, pvc_actual_prod_time_h,
           pvc_planned_prod_hours, pvc_standard_time_h,
           pvc_availability, pvc_performance, pvc_quality, pvc_oee
    FROM dbo.work_pvc_2025

    UNION ALL

    SELECT 2026, report_date, machine_type, machine_no, model_code, shift,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           pvc_accepted_weight_kg, pvc_production_m, pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           pvc_material_used_kg, pvc_actual_prod_time_h,
           pvc_planned_prod_hours, pvc_standard_time_h,
           pvc_availability, pvc_performance, pvc_quality, pvc_oee
    FROM dbo.work_pvc_2026
)
INSERT INTO dbo.FactProduction
(
    Date_Key, Machine_Key, Model_Key, Shift, Source_Year,
    Production_Qty, Machine_Speed,
    Downtime_Duration, Planned_Downtime, Minor_Downtime, Startup_Downtime,
    Model_Change_Downtime, Unexpected_Failure_Downtime,
    PVC_Accepted_Production, PVC_Production_Meter, PVC_Total_Waste, PVC_Abnormal_Waste,
    PVC_Raw_Material_Used, PVC_Actual_Production_Time, PVC_Planned_Production_Hours,
    PVC_Standard_Machine_Time, PVC_Availability, PVC_Performance, PVC_Quality_Rate, PVC_OEE
)
SELECT
    d.DateKey,
    m.Machine_Key,
    mo.Model_Key,
    s.shift,
    s.src_year,
    s.production_qty, s.machine_speed,
    s.stop_minutes, s.stop_planned_min, s.stop_minor_min, s.stop_startup_min,
    s.stop_model_change_min, s.stop_breakdown_min,
    s.pvc_accepted_weight_kg, s.pvc_production_m, s.pvc_total_scrap_kg, s.pvc_abnormal_scrap_kg,
    s.pvc_material_used_kg, s.pvc_actual_prod_time_h, s.pvc_planned_prod_hours,
    s.pvc_standard_time_h, s.pvc_availability, s.pvc_performance, s.pvc_quality, s.pvc_oee
FROM src s
LEFT JOIN dbo.DimDate    d  ON s.report_date = d.FullDate
LEFT JOIN dbo.DimMachine m  ON s.machine_no = m.Machine_No
                           AND s.machine_type = m.Machine_Type
LEFT JOIN dbo.DimModel   mo ON s.model_code = mo.Model_Code;

SELECT Date_key , 
        production_Key
FROM [dbo].[FactProduction]
where Date_key is null

ALTER TABLE dbo.FactProduction ADD
    MG_Accepted_Production        DECIMAL(18,3) NULL,
    MG_Production_Meter           DECIMAL(18,3) NULL,
    MG_Start_Block                DECIMAL(18,3) NULL,
    MG_Scrap_Machine              DECIMAL(18,3) NULL,
    MG_Scrap_Start                DECIMAL(18,3) NULL,
    MG_Scrap_Quality_Samples      DECIMAL(18,3) NULL,
    MG_Scrap_Line_Break           DECIMAL(18,3) NULL,
    MG_Scrap_Weld_Return          DECIMAL(18,3) NULL,
    MG_Scrap_Bubbles              DECIMAL(18,3) NULL,
    MG_Scrap_Line_Split           DECIMAL(18,3) NULL,
    MG_Scrap_No_Magnet            DECIMAL(18,3) NULL,
    MG_Total_Waste                DECIMAL(18,3) NULL,
    MG_Raw_Material_Used          DECIMAL(18,3) NULL,
    MG_Actual_Production_Time     DECIMAL(18,3) NULL,
    MG_Planned_Production_Hours   DECIMAL(18,3) NULL,
    MG_Standard_Machine_Time      DECIMAL(18,3) NULL,
    MG_Availability               DECIMAL(18,3) NULL,
    MG_Performance                DECIMAL(18,3) NULL,
    MG_Quality_Rate               DECIMAL(18,3) NULL,
    MG_OEE                        DECIMAL(18,3) NULL;


    TRUNCATE TABLE dbo.FactProduction;


    ;WITH src AS (
    SELECT 2024 AS src_year, report_date, machine_type, machine_no, model_code, shift,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           pvc_accepted_weight_kg, pvc_production_m, pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           pvc_material_used_kg, pvc_actual_prod_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_planned_prod_hours, pvc_standard_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_availability,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_performance,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_quality,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_oee,
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_total_scrap_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_material_used_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_actual_prod_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS mg_planned_prod_hours,
           CAST(NULL AS DECIMAL(18,3)) AS mg_standard_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS mg_availability,
           CAST(NULL AS DECIMAL(18,3)) AS mg_performance,
           CAST(NULL AS DECIMAL(18,3)) AS mg_quality,
           CAST(NULL AS DECIMAL(18,3)) AS mg_oee
    FROM dbo.work_pvc_2024

    UNION ALL

    SELECT 2025, report_date, machine_type, machine_no, model_code, shift,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           pvc_accepted_weight_kg, pvc_production_m, pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           pvc_material_used_kg, pvc_actual_prod_time_h,
           pvc_planned_prod_hours, pvc_standard_time_h,
           pvc_availability, pvc_performance, pvc_quality, pvc_oee,
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM dbo.work_pvc_2025

    UNION ALL

    SELECT 2026, report_date, machine_type, machine_no, model_code, shift,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           pvc_accepted_weight_kg, pvc_production_m, pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           pvc_material_used_kg, pvc_actual_prod_time_h,
           pvc_planned_prod_hours, pvc_standard_time_h,
           pvc_availability, pvc_performance, pvc_quality, pvc_oee,
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           mg_total_scrap_kg, mg_material_used_kg, mg_actual_prod_time_h,
           mg_planned_prod_hours, mg_standard_time_h,
           mg_availability, mg_performance, mg_quality, mg_oee
    FROM dbo.work_pvc_2026
)
INSERT INTO dbo.FactProduction
(
    Date_Key, Machine_Key, Model_Key, Shift, Source_Year,
    Production_Qty, Machine_Speed,
    Downtime_Duration, Planned_Downtime, Minor_Downtime, Startup_Downtime,
    Model_Change_Downtime, Unexpected_Failure_Downtime,
    PVC_Accepted_Production, PVC_Production_Meter, PVC_Total_Waste, PVC_Abnormal_Waste,
    PVC_Raw_Material_Used, PVC_Actual_Production_Time, PVC_Planned_Production_Hours,
    PVC_Standard_Machine_Time, PVC_Availability, PVC_Performance, PVC_Quality_Rate, PVC_OEE,
    MG_Accepted_Production, MG_Production_Meter, MG_Start_Block,
    MG_Scrap_Machine, MG_Scrap_Start, MG_Scrap_Quality_Samples,
    MG_Scrap_Line_Break, MG_Scrap_Weld_Return, MG_Scrap_Bubbles,
    MG_Scrap_Line_Split, MG_Scrap_No_Magnet,
    MG_Total_Waste, MG_Raw_Material_Used, MG_Actual_Production_Time,
    MG_Planned_Production_Hours, MG_Standard_Machine_Time,
    MG_Availability, MG_Performance, MG_Quality_Rate, MG_OEE
)
SELECT
    d.DateKey, m.Machine_Key, mo.Model_Key, s.shift, s.src_year,
    s.production_qty, s.machine_speed,
    s.stop_minutes, s.stop_planned_min, s.stop_minor_min, s.stop_startup_min,
    s.stop_model_change_min, s.stop_breakdown_min,
    s.pvc_accepted_weight_kg, s.pvc_production_m, s.pvc_total_scrap_kg, s.pvc_abnormal_scrap_kg,
    s.pvc_material_used_kg, s.pvc_actual_prod_time_h, s.pvc_planned_prod_hours,
    s.pvc_standard_time_h, s.pvc_availability, s.pvc_performance, s.pvc_quality, s.pvc_oee,
    s.mg_accepted_weight_kg, s.mg_production_m, s.mg_start_block_kg,
    s.mg_scrap_machine_kg, s.mg_scrap_start_kg, s.mg_scrap_quality_samples_kg,
    s.mg_scrap_line_break_kg, s.mg_scrap_weld_return_kg, s.mg_scrap_bubbles_kg,
    s.mg_scrap_line_split_kg, s.mg_scrap_no_magnet_kg,
    s.mg_total_scrap_kg, s.mg_material_used_kg, s.mg_actual_prod_time_h,
    s.mg_planned_prod_hours, s.mg_standard_time_h,
    s.mg_availability, s.mg_performance, s.mg_quality, s.mg_oee
FROM src s
LEFT JOIN dbo.DimDate    d  ON s.report_date = d.FullDate
LEFT JOIN dbo.DimMachine m  ON s.machine_no = m.Machine_No
                           AND s.machine_type = m.Machine_Type
LEFT JOIN dbo.DimModel   mo ON s.model_code = mo.Model_Code;


SELECT COLUMN_NAME,
       STRING_AGG(RIGHT(TABLE_NAME, 4) + ':' + DATA_TYPE, ' | ') AS types_per_year
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('work_pvc_2024', 'work_pvc_2025', 'work_pvc_2026')
  AND COLUMN_NAME NOT IN ('report_date','machine_type','die_no','model_desc','model','model_code',
                          'supervisor','technician_1','technician_2','stop_category','stop_reason',
                          'stop_from','stop_to','material','lot_no')
GROUP BY COLUMN_NAME
HAVING MAX(CASE WHEN DATA_TYPE LIKE '%char%' THEN 1 ELSE 0 END) = 1
ORDER BY COLUMN_NAME;


SELECT DISTINCT pvc_availability   -- اسم العمود
FROM dbo.work_pvc_2025             -- السنة
WHERE pvc_availability IS NOT NULL
  AND TRY_CAST(pvc_availability AS DECIMAL(18,3)) IS NULL;


  DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 
  'SELECT ''' + TABLE_NAME + ''' AS tbl, ''' + COLUMN_NAME + ''' AS col, COUNT(*) AS bad_rows, '
+ 'MIN(CAST(' + QUOTENAME(COLUMN_NAME) + ' AS NVARCHAR(100))) AS sample_value '
+ 'FROM dbo.' + QUOTENAME(TABLE_NAME)
+ ' WHERE ' + QUOTENAME(COLUMN_NAME) + ' IS NOT NULL '
+ 'AND TRY_CAST(' + QUOTENAME(COLUMN_NAME) + ' AS DECIMAL(18,3)) IS NULL '
+ 'HAVING COUNT(*) > 0 UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('work_pvc_2024','work_pvc_2025','work_pvc_2026')
  AND DATA_TYPE LIKE '%char%'
  AND COLUMN_NAME NOT IN ('machine_type','die_no','model_desc','model','model_code','supervisor',
                          'technician_1','technician_2','stop_category','stop_reason','material','lot_no');

IF @sql = '' PRINT 'No text columns found';
ELSE
BEGIN
    SET @sql = LEFT(@sql, LEN(@sql) - 10);   -- remove the last UNION ALL
    EXEC (@sql);
END


SELECT COLUMN_NAME, DATA_TYPE, NUMERIC_PRECISION, NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'FactProduction'
ORDER BY ORDINAL_POSITION;


-- 1) شكل قيم الوردية الفعلية
SELECT shift, LEN(shift) AS len_chars, COUNT(*) AS cnt
FROM (SELECT shift FROM dbo.work_pvc_2024
      UNION ALL SELECT shift FROM dbo.work_pvc_2025
      UNION ALL SELECT shift FROM dbo.work_pvc_2026) x
GROUP BY shift
ORDER BY shift;

-- 2) الفاكت فاضي؟ (الانسرت اللي فشل مبيسيبش صفوف)
SELECT COUNT(*) AS fact_rows FROM dbo.FactProduction;

------------------------------------------------------------

;WITH src AS (
    SELECT 2024 AS src_year, report_date, machine_type, machine_no, model_code,
           LEN(REPLACE(LTRIM(RTRIM(shift)) COLLATE Latin1_General_BIN2, N'ǁ', N'ǀǀ')) AS shift_no,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,3)) AS pvc_accepted_weight_kg,
           TRY_CAST(pvc_production_m       AS DECIMAL(18,3)) AS pvc_production_m,
           pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           TRY_CAST(pvc_material_used_kg   AS DECIMAL(18,3)) AS pvc_material_used_kg,
           TRY_CAST(pvc_actual_prod_time_h AS DECIMAL(18,3)) AS pvc_actual_prod_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_planned_prod_hours,
           TRY_CAST(pvc_standard_time_h    AS DECIMAL(18,3)) AS pvc_standard_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_availability,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_performance,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_quality,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_oee,
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_total_scrap_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_material_used_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_actual_prod_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS mg_planned_prod_hours,
           CAST(NULL AS DECIMAL(18,3)) AS mg_standard_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS mg_availability,
           CAST(NULL AS DECIMAL(18,3)) AS mg_performance,
           CAST(NULL AS DECIMAL(18,3)) AS mg_quality,
           CAST(NULL AS DECIMAL(18,3)) AS mg_oee
    FROM dbo.work_pvc_2024

    UNION ALL

    SELECT 2025, report_date, machine_type, machine_no, model_code,
           LEN(REPLACE(LTRIM(RTRIM(shift)) COLLATE Latin1_General_BIN2, N'ǁ', N'ǀǀ')),
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,3)),
           TRY_CAST(pvc_production_m       AS DECIMAL(18,3)),
           pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           TRY_CAST(pvc_material_used_kg   AS DECIMAL(18,3)),
           TRY_CAST(pvc_actual_prod_time_h AS DECIMAL(18,3)),
           TRY_CAST(pvc_planned_prod_hours AS DECIMAL(18,3)),
           TRY_CAST(pvc_standard_time_h    AS DECIMAL(18,3)),
           TRY_CAST(pvc_availability       AS DECIMAL(18,3)),
           TRY_CAST(pvc_performance        AS DECIMAL(18,3)),
           TRY_CAST(pvc_quality            AS DECIMAL(18,3)),
           TRY_CAST(pvc_oee                AS DECIMAL(18,3)),
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM dbo.work_pvc_2025

    UNION ALL

    SELECT 2026, report_date, machine_type, machine_no, model_code,
           LEN(REPLACE(LTRIM(RTRIM(shift)) COLLATE Latin1_General_BIN2, N'ǁ', N'ǀǀ')),
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,3)),
           TRY_CAST(pvc_production_m       AS DECIMAL(18,3)),
           pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           TRY_CAST(pvc_material_used_kg   AS DECIMAL(18,3)),
           TRY_CAST(pvc_actual_prod_time_h AS DECIMAL(18,3)),
           TRY_CAST(pvc_planned_prod_hours AS DECIMAL(18,3)),
           TRY_CAST(pvc_standard_time_h    AS DECIMAL(18,3)),
           TRY_CAST(pvc_availability       AS DECIMAL(18,3)),
           TRY_CAST(pvc_performance        AS DECIMAL(18,3)),
           TRY_CAST(pvc_quality            AS DECIMAL(18,3)),
           TRY_CAST(pvc_oee                AS DECIMAL(18,3)),
           mg_accepted_weight_kg,
           TRY_CAST(mg_production_m        AS DECIMAL(18,3)),
           mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           mg_total_scrap_kg, mg_material_used_kg,
           TRY_CAST(mg_actual_prod_time_h  AS DECIMAL(18,3)),
           TRY_CAST(mg_planned_prod_hours  AS DECIMAL(18,3)),
           TRY_CAST(mg_standard_time_h     AS DECIMAL(18,3)),
           TRY_CAST(mg_availability        AS DECIMAL(18,3)),
           TRY_CAST(mg_performance         AS DECIMAL(18,3)),
           TRY_CAST(mg_quality             AS DECIMAL(18,3)),
           TRY_CAST(mg_oee                 AS DECIMAL(18,3))
    FROM dbo.work_pvc_2026
)
INSERT INTO dbo.FactProduction
(
    Date_Key, Machine_Key, Model_Key, Shift, Source_Year,
    Production_Qty, Machine_Speed,
    Downtime_Duration, Planned_Downtime, Minor_Downtime, Startup_Downtime,
    Model_Change_Downtime, Unexpected_Failure_Downtime,
    PVC_Accepted_Production, PVC_Production_Meter, PVC_Total_Waste, PVC_Abnormal_Waste,
    PVC_Raw_Material_Used, PVC_Actual_Production_Time, PVC_Planned_Production_Hours,
    PVC_Standard_Machine_Time, PVC_Availability, PVC_Performance, PVC_Quality_Rate, PVC_OEE,
    MG_Accepted_Production, MG_Production_Meter, MG_Start_Block,
    MG_Scrap_Machine, MG_Scrap_Start, MG_Scrap_Quality_Samples,
    MG_Scrap_Line_Break, MG_Scrap_Weld_Return, MG_Scrap_Bubbles,
    MG_Scrap_Line_Split, MG_Scrap_No_Magnet,
    MG_Total_Waste, MG_Raw_Material_Used, MG_Actual_Production_Time,
    MG_Planned_Production_Hours, MG_Standard_Machine_Time,
    MG_Availability, MG_Performance, MG_Quality_Rate, MG_OEE
)
SELECT
    d.DateKey, m.Machine_Key, mo.Model_Key, s.shift_no, s.src_year,
    s.production_qty, s.machine_speed,
    s.stop_minutes, s.stop_planned_min, s.stop_minor_min, s.stop_startup_min,
    s.stop_model_change_min, s.stop_breakdown_min,
    s.pvc_accepted_weight_kg, s.pvc_production_m, s.pvc_total_scrap_kg, s.pvc_abnormal_scrap_kg,
    s.pvc_material_used_kg, s.pvc_actual_prod_time_h, s.pvc_planned_prod_hours,
    s.pvc_standard_time_h, s.pvc_availability, s.pvc_performance, s.pvc_quality, s.pvc_oee,
    s.mg_accepted_weight_kg, s.mg_production_m, s.mg_start_block_kg,
    s.mg_scrap_machine_kg, s.mg_scrap_start_kg, s.mg_scrap_quality_samples_kg,
    s.mg_scrap_line_break_kg, s.mg_scrap_weld_return_kg, s.mg_scrap_bubbles_kg,
    s.mg_scrap_line_split_kg, s.mg_scrap_no_magnet_kg,
    s.mg_total_scrap_kg, s.mg_material_used_kg, s.mg_actual_prod_time_h,
    s.mg_planned_prod_hours, s.mg_standard_time_h,
    s.mg_availability, s.mg_performance, s.mg_quality, s.mg_oee
FROM src s
LEFT JOIN dbo.DimDate    d  ON s.report_date = d.FullDate
LEFT JOIN dbo.DimMachine m  ON s.machine_no = m.Machine_No
                           AND s.machine_type = m.Machine_Type
LEFT JOIN dbo.DimModel   mo ON ISNULL(s.model_code, N'') = ISNULL(mo.Model_Code, N'')
                           AND ISNULL(s.model,      N'') = ISNULL(mo.Model_Name, N'')
                           AND ISNULL(s.model_desc, N'') = ISNULL(mo.Model_Description, N'');

SELECT
    COUNT(*)                                               AS fact_rows,        -- المفروض 17661
    SUM(CASE WHEN Date_Key    IS NULL THEN 1 ELSE 0 END)   AS null_date,
    SUM(CASE WHEN Machine_Key IS NULL THEN 1 ELSE 0 END)   AS null_machine,
    SUM(CASE WHEN Model_Key   IS NULL THEN 1 ELSE 0 END)   AS null_model,
    SUM(CASE WHEN Shift NOT IN (1,2,3) OR Shift IS NULL THEN 1 ELSE 0 END) AS bad_shift
FROM dbo.FactProduction;


-- أي سنة اتضاعفت؟ (المفروض 7879 / 6962 / 2820)
SELECT Source_Year, COUNT(*) AS rows_cnt FROM dbo.FactProduction GROUP BY Source_Year;

-- مفاتيح مكررة في الـ Dimensions
SELECT 'DimModel' AS dim, Model_Code AS k, COUNT(*) AS cnt
FROM dbo.DimModel GROUP BY Model_Code HAVING COUNT(*) > 1
UNION ALL
SELECT 'DimMachine', CAST(Machine_No AS NVARCHAR(50)) + '/' + Machine_Type, COUNT(*)
FROM dbo.DimMachine GROUP BY Machine_No, Machine_Type HAVING COUNT(*) > 1
UNION ALL
SELECT 'DimDate', CAST(FullDate AS NVARCHAR(50)), COUNT(*)
FROM dbo.DimDate GROUP BY FullDate HAVING COUNT(*) > 1;



SELECT *
FROM dbo.DimModel
WHERE Model_Code IN (
    SELECT Model_Code FROM dbo.DimModel
    GROUP BY Model_Code HAVING COUNT(*) > 1
)
ORDER BY Model_Code, Model_Key;

TRUNCATE TABLE dbo.FactProduction;






SELECT Source_Year, COUNT(*) AS rows_cnt FROM dbo.FactProduction GROUP BY Source_Year;
-- المفروض: 2024 → 7879 / 2025 → 6962 / 2026 → 2820

SELECT COUNT(*) AS total_rows,
       SUM(CASE WHEN Model_Key   IS NULL THEN 1 ELSE 0 END) AS null_model,
       SUM(CASE WHEN Machine_Key IS NULL THEN 1 ELSE 0 END) AS null_machine
FROM dbo.FactProduction;













TRUNCATE TABLE dbo.FactProduction;

;WITH src AS (
    SELECT 2024 AS src_year, report_date, machine_type, machine_no, model_code, model, model_desc,
           LEN(REPLACE(LTRIM(RTRIM(shift)) COLLATE Latin1_General_BIN2, N'ǁ', N'ǀǀ')) AS shift_no,
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,3)) AS pvc_accepted_weight_kg,
           TRY_CAST(pvc_production_m       AS DECIMAL(18,3)) AS pvc_production_m,
           pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           TRY_CAST(pvc_material_used_kg   AS DECIMAL(18,3)) AS pvc_material_used_kg,
           TRY_CAST(pvc_actual_prod_time_h AS DECIMAL(18,3)) AS pvc_actual_prod_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_planned_prod_hours,
           TRY_CAST(pvc_standard_time_h    AS DECIMAL(18,3)) AS pvc_standard_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_availability,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_performance,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_quality,
           CAST(NULL AS DECIMAL(18,3)) AS pvc_oee,
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_total_scrap_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_material_used_kg,
           CAST(NULL AS DECIMAL(18,3)) AS mg_actual_prod_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS mg_planned_prod_hours,
           CAST(NULL AS DECIMAL(18,3)) AS mg_standard_time_h,
           CAST(NULL AS DECIMAL(18,3)) AS mg_availability,
           CAST(NULL AS DECIMAL(18,3)) AS mg_performance,
           CAST(NULL AS DECIMAL(18,3)) AS mg_quality,
           CAST(NULL AS DECIMAL(18,3)) AS mg_oee
    FROM dbo.work_pvc_2024

    UNION ALL

    SELECT 2025, report_date, machine_type, machine_no, model_code, model, model_desc,
           LEN(REPLACE(LTRIM(RTRIM(shift)) COLLATE Latin1_General_BIN2, N'ǁ', N'ǀǀ')),
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,3)),
           TRY_CAST(pvc_production_m       AS DECIMAL(18,3)),
           pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           TRY_CAST(pvc_material_used_kg   AS DECIMAL(18,3)),
           TRY_CAST(pvc_actual_prod_time_h AS DECIMAL(18,3)),
           TRY_CAST(pvc_planned_prod_hours AS DECIMAL(18,3)),
           TRY_CAST(pvc_standard_time_h    AS DECIMAL(18,3)),
           TRY_CAST(pvc_availability       AS DECIMAL(18,3)),
           TRY_CAST(pvc_performance        AS DECIMAL(18,3)),
           TRY_CAST(pvc_quality            AS DECIMAL(18,3)),
           TRY_CAST(pvc_oee                AS DECIMAL(18,3)),
           mg_accepted_weight_kg, mg_production_m, mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM dbo.work_pvc_2025

    UNION ALL

    SELECT 2026, report_date, machine_type, machine_no, model_code, model, model_desc,
           LEN(REPLACE(LTRIM(RTRIM(shift)) COLLATE Latin1_General_BIN2, N'ǁ', N'ǀǀ')),
           production_qty, machine_speed,
           stop_minutes, stop_planned_min, stop_minor_min, stop_startup_min,
           stop_model_change_min, stop_breakdown_min,
           TRY_CAST(pvc_accepted_weight_kg AS DECIMAL(18,3)),
           TRY_CAST(pvc_production_m       AS DECIMAL(18,3)),
           pvc_total_scrap_kg, pvc_abnormal_scrap_kg,
           TRY_CAST(pvc_material_used_kg   AS DECIMAL(18,3)),
           TRY_CAST(pvc_actual_prod_time_h AS DECIMAL(18,3)),
           TRY_CAST(pvc_planned_prod_hours AS DECIMAL(18,3)),
           TRY_CAST(pvc_standard_time_h    AS DECIMAL(18,3)),
           TRY_CAST(pvc_availability       AS DECIMAL(18,3)),
           TRY_CAST(pvc_performance        AS DECIMAL(18,3)),
           TRY_CAST(pvc_quality            AS DECIMAL(18,3)),
           TRY_CAST(pvc_oee                AS DECIMAL(18,3)),
           mg_accepted_weight_kg,
           TRY_CAST(mg_production_m        AS DECIMAL(18,3)),
           mg_start_block_kg,
           mg_scrap_machine_kg, mg_scrap_start_kg, mg_scrap_quality_samples_kg,
           mg_scrap_line_break_kg, mg_scrap_weld_return_kg, mg_scrap_bubbles_kg,
           mg_scrap_line_split_kg, mg_scrap_no_magnet_kg,
           mg_total_scrap_kg, mg_material_used_kg,
           TRY_CAST(mg_actual_prod_time_h  AS DECIMAL(18,3)),
           TRY_CAST(mg_planned_prod_hours  AS DECIMAL(18,3)),
           TRY_CAST(mg_standard_time_h     AS DECIMAL(18,3)),
           TRY_CAST(mg_availability        AS DECIMAL(18,3)),
           TRY_CAST(mg_performance         AS DECIMAL(18,3)),
           TRY_CAST(mg_quality             AS DECIMAL(18,3)),
           TRY_CAST(mg_oee                 AS DECIMAL(18,3))
    FROM dbo.work_pvc_2026
)
INSERT INTO dbo.FactProduction
(
    Date_Key, Machine_Key, Model_Key, Shift, Source_Year,
    Production_Qty, Machine_Speed,
    Downtime_Duration, Planned_Downtime, Minor_Downtime, Startup_Downtime,
    Model_Change_Downtime, Unexpected_Failure_Downtime,
    PVC_Accepted_Production, PVC_Production_Meter, PVC_Total_Waste, PVC_Abnormal_Waste,
    PVC_Raw_Material_Used, PVC_Actual_Production_Time, PVC_Planned_Production_Hours,
    PVC_Standard_Machine_Time, PVC_Availability, PVC_Performance, PVC_Quality_Rate, PVC_OEE,
    MG_Accepted_Production, MG_Production_Meter, MG_Start_Block,
    MG_Scrap_Machine, MG_Scrap_Start, MG_Scrap_Quality_Samples,
    MG_Scrap_Line_Break, MG_Scrap_Weld_Return, MG_Scrap_Bubbles,
    MG_Scrap_Line_Split, MG_Scrap_No_Magnet,
    MG_Total_Waste, MG_Raw_Material_Used, MG_Actual_Production_Time,
    MG_Planned_Production_Hours, MG_Standard_Machine_Time,
    MG_Availability, MG_Performance, MG_Quality_Rate, MG_OEE
)
SELECT
    d.DateKey, m.Machine_Key, mo.Model_Key, s.shift_no, s.src_year,
    s.production_qty, s.machine_speed,
    s.stop_minutes, s.stop_planned_min, s.stop_minor_min, s.stop_startup_min,
    s.stop_model_change_min, s.stop_breakdown_min,
    s.pvc_accepted_weight_kg, s.pvc_production_m, s.pvc_total_scrap_kg, s.pvc_abnormal_scrap_kg,
    s.pvc_material_used_kg, s.pvc_actual_prod_time_h, s.pvc_planned_prod_hours,
    s.pvc_standard_time_h, s.pvc_availability, s.pvc_performance, s.pvc_quality, s.pvc_oee,
    s.mg_accepted_weight_kg, s.mg_production_m, s.mg_start_block_kg,
    s.mg_scrap_machine_kg, s.mg_scrap_start_kg, s.mg_scrap_quality_samples_kg,
    s.mg_scrap_line_break_kg, s.mg_scrap_weld_return_kg, s.mg_scrap_bubbles_kg,
    s.mg_scrap_line_split_kg, s.mg_scrap_no_magnet_kg,
    s.mg_total_scrap_kg, s.mg_material_used_kg, s.mg_actual_prod_time_h,
    s.mg_planned_prod_hours, s.mg_standard_time_h,
    s.mg_availability, s.mg_performance, s.mg_quality, s.mg_oee
FROM src s
LEFT JOIN dbo.DimDate    d  ON s.report_date = d.FullDate
LEFT JOIN dbo.DimMachine m  ON s.machine_no = m.Machine_No
                           AND s.machine_type = m.Machine_Type
LEFT JOIN dbo.DimModel   mo ON ISNULL(s.model_code, N'') = ISNULL(mo.Model_Code, N'')
                           AND ISNULL(s.model,      N'') = ISNULL(mo.Model_Name, N'')
                           AND ISNULL(s.model_desc, N'') = ISNULL(mo.Model_Description, N'');



SELECT Source_Year, Date_Key, Shift, Production_Qty, Model_Key
FROM dbo.FactProduction
WHERE Machine_Key IS NULL;




                           SELECT 'work_pvc_2024' AS tbl, report_date, machine_type, machine_no
FROM dbo.work_pvc_2024
WHERE NOT EXISTS (SELECT 1 FROM dbo.DimMachine m
                  WHERE m.Machine_No = work_pvc_2024.machine_no
                    AND m.Machine_Type = work_pvc_2024.machine_type)
UNION ALL
SELECT 'work_pvc_2025', report_date, machine_type, machine_no
FROM dbo.work_pvc_2025
WHERE NOT EXISTS (SELECT 1 FROM dbo.DimMachine m
                  WHERE m.Machine_No = work_pvc_2025.machine_no
                    AND m.Machine_Type = work_pvc_2025.machine_type)
UNION ALL
SELECT 'work_pvc_2026', report_date, machine_type, machine_no
FROM dbo.work_pvc_2026
WHERE NOT EXISTS (SELECT 1 FROM dbo.DimMachine m
                  WHERE m.Machine_No = work_pvc_2026.machine_no
                    AND m.Machine_Type = work_pvc_2026.machine_type);


SELECT *
FROM dbo.FactProduction
WHERE Machine_Key IS NULL;


DELETE FROM dbo.FactProduction
WHERE Machine_Key IS NULL
  AND Date_Key = 20260330
  AND ISNULL(Production_Qty, 0) = 0;

SELECT
    COUNT(*)                                               AS fact_rows,        -- المفروض 17661
    SUM(CASE WHEN Date_Key    IS NULL THEN 1 ELSE 0 END)   AS null_date,
    SUM(CASE WHEN Machine_Key IS NULL THEN 1 ELSE 0 END)   AS null_machine,
    SUM(CASE WHEN Model_Key   IS NULL THEN 1 ELSE 0 END)   AS null_model,
    SUM(CASE WHEN Shift NOT IN (1,2,3) OR Shift IS NULL THEN 1 ELSE 0 END) AS bad_shift
FROM dbo.FactProduction;