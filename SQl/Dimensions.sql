USE [Project NTI];
GO


--##############################################################################

CREATE TABLE dbo.DimDate
(
    DateKey         INT          NOT NULL PRIMARY KEY,
    FullDate        DATE         NOT NULL,
    Year            INT          NOT NULL,
    QuarterNo       INT          NOT NULL,
    QuarterName     VARCHAR(10)  NOT NULL,
    MonthNo         INT          NOT NULL,
    MonthName       VARCHAR(20)  NOT NULL,
    YearMonth       CHAR(7)      NOT NULL,
    WeekNo          INT          NOT NULL,
    DayNo           INT          NOT NULL,
    DayName         VARCHAR(20)  NOT NULL
);
GO

INSERT INTO dbo.DimDate
(
    DateKey,
    FullDate,
    Year,
    QuarterNo,
    QuarterName,
    MonthNo,
    MonthName,
    YearMonth,
    WeekNo,
    DayNo,
    DayName
)
SELECT DISTINCT
    CONVERT(INT, CONVERT(CHAR(8), CAST(report_date AS DATE), 112)) AS DateKey,
    CAST(report_date AS DATE) AS FullDate,

    YEAR(report_date) AS Year,

    DATEPART(QUARTER, report_date) AS QuarterNo,

    CONCAT('Q', DATEPART(QUARTER, report_date)) AS QuarterName,

    MONTH(report_date) AS MonthNo,

    DATENAME(MONTH, report_date) AS MonthName,

    CONVERT(CHAR(7), CAST(report_date AS DATE), 120) AS YearMonth,

    DATEPART(WEEK, report_date) AS WeekNo,

    DAY(report_date) AS DayNo,

    DATENAME(WEEKDAY, report_date) AS DayName

FROM dbo.clean_production
WHERE report_date IS NOT NULL;
GO

SELECT
    COUNT(*) AS DateRows,
    MIN(FullDate) AS MinDate,
    MAX(FullDate) AS MaxDate
FROM dbo.DimDate;

SELECT *
FROM dbo.DimDate
ORDER BY FullDate;

--####################################################
CREATE TABLE dbo.DimMachine
(
    Machine_Key INT IDENTITY(1,1) PRIMARY KEY,

    Machine_No NVARCHAR(100) NOT NULL,

    Machine_Type NVARCHAR(50) NULL
);
GO

INSERT INTO dbo.DimMachine
(
    Machine_No,
    Machine_Type
)
SELECT DISTINCT
    machine_no,
    machine_type
FROM dbo.clean_production
WHERE machine_no IS NOT NULL;
GO


SELECT *
FROM dbo.DimMachine
ORDER BY Machine_Key;


SELECT
    Machine_Type,
    COUNT(*) AS Machine_Count
FROM dbo.DimMachine
GROUP BY Machine_Type
ORDER BY Machine_Type;


SELECT
    Machine_No,
    COUNT(*) AS Duplicate_Count
FROM dbo.DimMachine
GROUP BY Machine_No
HAVING COUNT(*) > 1;

SELECT
    Machine_No,
    COUNT(DISTINCT Machine_Type) AS Machine_Type_Count
FROM dbo.DimMachine
GROUP BY Machine_No
HAVING COUNT(DISTINCT Machine_Type) > 1;


SELECT
    Machine_Type,
    Machine_No,
    COUNT(*) AS Row_Count
FROM dbo.clean_production
GROUP BY
    Machine_Type,
    Machine_No
ORDER BY
    Machine_Type,
    Machine_No;


    SELECT
    Machine_Type,
    Machine_No,
    COUNT(*) AS Row_Count
FROM dbo.clean_production
WHERE Machine_No IS NOT NULL
GROUP BY
    Machine_Type,
    Machine_No
HAVING COUNT(*) > 1
ORDER BY
    Machine_Type,
    Machine_No;

--###############################################
CREATE TABLE dbo.DimModel
(
    Model_Key INT IDENTITY(1,1) PRIMARY KEY,

    Model_Code NVARCHAR(100) NULL,
    Model_Name NVARCHAR(255) NULL,
    Model_Description NVARCHAR(255) NULL
);
GO

INSERT INTO dbo.DimModel
(
    Model_Code,
    Model_Name,
    Model_Description
)
SELECT DISTINCT
    model_code,
    model,
    model_desc
FROM dbo.clean_production;
GO

SELECT *
FROM dbo.DimModel
ORDER BY Model_Key;

SELECT
    Model_Code,
    COUNT(*) AS Count_Rows
FROM dbo.DimModel
WHERE Model_Code IS NOT NULL
GROUP BY Model_Code
HAVING COUNT(*) > 1;


SELECT
    Model_Code,
    COUNT(*) AS Row_Count,
    COUNT(DISTINCT Model_Name) AS Model_Name_Count,
    COUNT(DISTINCT Model_Description) AS Description_Count
FROM dbo.DimModel
WHERE Model_Code IS NOT NULL
GROUP BY Model_Code
HAVING COUNT(*) > 1
ORDER BY Model_Code;


SELECT
    Model_Key,
    Model_Code,
    Model_Name,
    Model_Description
FROM dbo.DimModel
WHERE Model_Code IN (
    '18TO','27','33','40','40STO','40TO',
    '46','46S','69L','69S','C1','C2','D1','H','HD'
)
ORDER BY Model_Code, Model_Key;


ALTER TABLE dbo.DimMachine
ADD CONSTRAINT UQ_Machine_Type_No 
UNIQUE (Machine_Type, Machine_No);

CREATE UNIQUE INDEX UQ_Model_Code_NonNull
ON dbo.DimModel(Model_Code)
WHERE Model_Code IS NOT NULL;


SELECT
    shift_no,
    COUNT(*) AS Row_Count
FROM dbo.clean_production
GROUP BY shift_no
ORDER BY shift_no;

SELECT * FROM dbo.clean_production

CREATE TABLE dbo.DimShift
(
    Shift_Key INT IDENTITY(1,1) PRIMARY KEY,
    Shift_No INT NOT NULL,
    Shift_Name NVARCHAR(50) NULL
);
GO

INSERT INTO dbo.DimShift
(
    Shift_No,
    Shift_Name
)
SELECT DISTINCT
    shift_no,
    CONCAT('Shift ', shift_no)
FROM dbo.clean_production
WHERE shift_no IS NOT NULL;
GO

SELECT *
FROM dbo.DimShift
ORDER BY Shift_No;
SELECT
    Employee_Name,
    COUNT(DISTINCT Employee_Role) AS Role_Count
FROM
(
    SELECT
        technician_1 AS Employee_Name,
        'Technician' AS Employee_Role
    FROM dbo.clean_production
    WHERE technician_1 IS NOT NULL

    UNION ALL

    SELECT
        technician_2 AS Employee_Name,
        'Technician' AS Employee_Role
    FROM dbo.clean_production
    WHERE technician_2 IS NOT NULL

    UNION ALL

    SELECT
        supervisor AS Employee_Name,
        'Supervisor' AS Employee_Role
    FROM dbo.clean_production
    WHERE supervisor IS NOT NULL
) AS E
GROUP BY Employee_Name
HAVING COUNT(DISTINCT Employee_Role) > 1
ORDER BY Employee_Name;
--#############################################
CREATE TABLE dbo.DimEmployee
(
    Employee_Key INT IDENTITY(1,1) PRIMARY KEY,
    Employee_Name NVARCHAR(255) NOT NULL
);


INSERT INTO dbo.DimEmployee (Employee_Name)
SELECT DISTINCT Employee_Name
FROM
(
    SELECT technician_1 AS Employee_Name
    FROM dbo.clean_production
    WHERE technician_1 IS NOT NULL

    UNION

    SELECT technician_2
    FROM dbo.clean_production
    WHERE technician_2 IS NOT NULL

    UNION

    SELECT supervisor
    FROM dbo.clean_production
    WHERE supervisor IS NOT NULL
) E;

SELECT * 
FROM DimEmployee

--##################################################3
SELECT
    material,
    COUNT(*) AS Row_Count
FROM dbo.clean_production
WHERE material IS NOT NULL
GROUP BY material
ORDER BY material;


SELECT
    material,
    COUNT(DISTINCT machine_type) AS Machine_Type_Count,
    COUNT(DISTINCT model_code) AS Model_Code_Count
FROM dbo.clean_production
WHERE material IS NOT NULL
GROUP BY material
ORDER BY material;


SELECT
    material,
    COUNT(*) AS Row_Count,
    COUNT(DISTINCT machine_type) AS Machine_Type_Count,
    COUNT(DISTINCT model_code) AS Model_Code_Count
FROM dbo.clean_production
WHERE material IS NOT NULL
GROUP BY material
ORDER BY material;


CREATE TABLE dbo.DimMaterial
(
    Material_Key INT IDENTITY(1,1) PRIMARY KEY,
    Material_Name NVARCHAR(100) NULL
);
GO

INSERT INTO dbo.DimMaterial
(
    Material_Name
)
SELECT DISTINCT
    material
FROM dbo.clean_production
WHERE material IS NOT NULL;
GO

SELECT
    Material_Key,
    Material_Name
FROM dbo.DimMaterial
ORDER BY Material_Name;

SELECT
    Material_Name,
    COUNT(*) AS Duplicate_Count
FROM dbo.DimMaterial
GROUP BY Material_Name
HAVING COUNT(*) > 1;

UPDATE dbo.DimMaterial
SET Material_Name = CASE
    WHEN Material_Name = N'محمد على' THEN N'محمد علي'
    WHEN Material_Name = N'تيلاندى' THEN N'تيلاند'
    ELSE Material_Name
END;
GO
--##########################################################

CREATE TABLE dbo.DimDowntime
(
    Downtime_Key INT IDENTITY(1,1) PRIMARY KEY,

    Stop_Category NVARCHAR(255) NULL,
    Stop_Reason   NVARCHAR(255) NULL
);
GO



INSERT INTO dbo.DimDowntime
(
    Stop_Category,
    Stop_Reason
)
SELECT DISTINCT
    stop_category,
    stop_reason
FROM dbo.clean_production
WHERE stop_category IS NOT NULL
   OR stop_reason IS NOT NULL;
GO


SELECT *
FROM dbo.DimDowntime
ORDER BY Downtime_Key;

SELECT
    Stop_Category,
    Stop_Reason,
    COUNT(*) AS Duplicate_Count
FROM dbo.DimDowntime
GROUP BY
    Stop_Category,
    Stop_Reason
HAVING COUNT(*) > 1;

--######################################################

SELECT TOP 5 *
FROM DimDate

SELECT TOP 5 *
FROM DimDowntime

SELECT *
FROM DimEmployee

SELECT TOP 5 *
FROM DimMachine

SELECT *
FROM DimMaterial

SELECT TOP 5 *
FROM DimModel

SELECT TOP 5 *
FROM DimShift


-- 1) تكرار Material
SELECT
    Material_Name,
    COUNT(*) AS Row_Count
FROM dbo.DimMaterial
GROUP BY Material_Name
HAVING COUNT(*) > 1;

-------------------------------------
DROP TABLE IF EXISTS dbo.DimMaterial;
GO

CREATE TABLE dbo.DimMaterial
(
    Material_Key INT IDENTITY(1,1) PRIMARY KEY,
    Material_Name NVARCHAR(255) NOT NULL
);
GO

INSERT INTO dbo.DimMaterial (Material_Name)
SELECT DISTINCT
    CASE
        WHEN LTRIM(RTRIM(material)) IN (N'محمد علي', N'محمد على')
            THEN N'محمد علي'

        WHEN LTRIM(RTRIM(material)) IN (N'تيلاندى', N'تيلاند')
            THEN N'تيلاند'

        ELSE LTRIM(RTRIM(material))
    END AS Material_Name
FROM dbo.clean_production
WHERE material IS NOT NULL
  AND LTRIM(RTRIM(material)) <> '';
GO


SELECT
    Material_Key,
    Material_Name
FROM dbo.DimMaterial
ORDER BY Material_Key;

