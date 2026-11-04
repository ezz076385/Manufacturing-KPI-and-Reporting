# Manufacturing KPI & Reporting Dashboard

> Turning real manufacturing production data into operational insights for better production and performance monitoring.
## Project Overview
<p align="center">
 <img width="1458" height="842" alt="Screenshot 2026-11-03 225107" src="https://github.com/user-attachments/assets/a827bf88-e559-4583-aecd-ecab885c5b5d" />
</p>




Manufacturing operations generate large amounts of production data, but raw records alone do not always provide a clear picture of operational performance.

This project focuses on analyzing real PVC manufacturing production data and transforming it into an interactive Power BI reporting solution.

The dashboard brings together production output, material consumption, waste, Overall Equipment Effectiveness (OEE), and downtime analysis.

Rather than presenting production figures alone, the project was structured around important operational questions:

- How much production output is being achieved?
- How efficiently are machines operating?
- What is the relationship between production output and material consumption?
- How much waste is generated?
- What are the main indicators of equipment effectiveness?
- How does downtime affect production operations?
- Which operational areas deserve further investigation?

The final result is an interactive Power BI dashboard designed to improve production visibility and support data-driven operational decisions.

---

## 1. Business Problem

Manufacturing teams need more than production totals to understand operational performance.

Production records may contain valuable information about output, material usage, waste, machine performance, and downtime, but these indicators need to be organized into a meaningful reporting structure.

The purpose of this project was to move from:

**Raw Production Data → Data Preparation → KPI Development → Analysis → Dashboard → Decision Support**

The analysis focuses on four main areas:

**Production Performance**

Monitoring production output and understanding production-related indicators.

**Material & Waste Analysis**

Tracking raw material consumption and waste percentages.

**Equipment Effectiveness**

Evaluating equipment performance through OEE and its three main components.

**Downtime Analysis**

Understanding machine stoppages, downtime duration, and downtime reasons.

---

## 2. Dataset

The project uses real PVC manufacturing production data covering three years:

- 2024
- 2025
- 2026

The source data comes from manufacturing production records.

The datasets were not treated as identical tables from the beginning. Their structures were reviewed and prepared to establish a consistent analytical foundation.

### Data Structure

The production records include operational information related to:

- Production dates
- Machine information
- Production types
- Models
- Molds
- Shifts
- Production quantities
- Machine speed
- Production personnel
- Downtime
- Material waste

The available fields vary across the yearly source files, which made data preparation and standardization an important part of the project.

---

## 3. Data Preparation & Analysis Process

The project followed a structured data preparation workflow before building the final dashboard.

### Step 1 — Data Understanding

The original production files were reviewed to understand:

- Data structure and column differences
- Available production fields
- Data types
- Operational dimensions
- Production measures
- Missing and repeated records

### Step 2 — Data Staging

The original yearly datasets were brought into a staging process to prepare them for further analysis.

### Step 3 — Data Standardization

Since the 2024, 2025, and 2026 datasets had different structures, the columns and data definitions needed to be standardized before combining the data.

This step focused on establishing consistent field names and compatible structures across the different years.

### Step 4 — Data Cleaning

The preparation process included reviewing:

- Missing values
- Data consistency
- Duplicate records
- Column definitions
- Production-related fields

### Step 5 — Data Modeling

The prepared data was organized into an analytical structure suitable for reporting and KPI calculations.

### Step 6 — KPI Development & Dashboard Design

Production and operational measures were used to build the reporting framework and create interactive Power BI pages.

---

## 4. Production Overview


  <img width="1265" height="138" alt="Screenshot 2026-11-04 142636" src="https://github.com/user-attachments/assets/c1e9f667-6cd0-47fe-8731-9712eb2816c5" />


<p align="center">
</p>

The Overview page provides a consolidated view of manufacturing performance.

It brings together important production and material indicators to help users monitor the overall production picture.

The analysis includes:

- Production Meters
- Good Output
- Raw Material Used
- Total Waste %
- Abnormal Waste %

These indicators help connect production output with material consumption and waste.

---

## 5. OEE Analysis

<p align="center">
<img width="1461" height="840" alt="Screenshot 2026-11-03 225128" src="https://github.com/user-attachments/assets/6aaea3d5-830b-4903-ae75-94195a9d36b1" />

</p>

Overall Equipment Effectiveness (OEE) is one of the main analytical areas of this project.

The OEE page focuses on evaluating equipment effectiveness through three fundamental components:

### Availability

Measures the proportion of planned production time during which equipment is available for operation.

### Performance

Evaluates operating performance in relation to the expected production rate.

### Quality

Represents the quality component of equipment effectiveness.

### OEE KPI Framework

The report includes:

- OEE %
- Availability %
- Performance %
- Quality %
- Planned Hours
- Net Time
- Actual Run Time

Together, these indicators provide a structured view of equipment effectiveness and production time utilization.

---

## 6. Downtime Analysis

<p align="center">
 <img width="1453" height="848" alt="Screenshot 2026-11-03 225147" src="https://github.com/user-attachments/assets/1a9ec7d7-9514-4c42-a7d3-4ab4c0e9ea06" />

</p>

Downtime analysis is essential for understanding production interruptions and machine utilization.

This page provides a detailed view of downtime-related indicators.

### Main Downtime KPIs

- Total Downtime Hours
- Unplanned Downtime
- Downtime %
- Number of Stops
- Average Stop Duration
- Cumulative Downtime % by Stop Reason

The analysis helps users investigate downtime patterns and identify operational areas that may require further review.

It also provides a foundation for deeper investigation into machine stoppages and their potential production implications.

---

## 7. Key Performance Indicators

The dashboard includes a collection of manufacturing KPIs designed to monitor production performance and operational efficiency.

| KPI | Analytical Purpose |
|---|---|
| Production Meters | Monitor production output |
| Good Output | Track accepted production |
| Raw Material Used | Monitor material consumption |
| Total Waste % | Evaluate overall waste |
| Abnormal Waste % | Monitor abnormal waste |
| OEE % | Measure equipment effectiveness |
| Availability % | Evaluate equipment availability |
| Performance % | Measure operating performance |
| Quality % | Evaluate the quality component |
| Planned Hours | Track planned production time |
| Net Time | Monitor net production time |
| Actual Run Time | Track actual operating time |
| Total Downtime Hours | Measure total downtime |
| Unplanned Downtime | Monitor unplanned production losses |
| Downtime % | Evaluate downtime |
| Number of Stops | Track stoppage frequency |
| Average Stop Duration | Measure average stoppage duration |

---

## 8. Business Questions This Dashboard Helps Answer

The dashboard was designed to support investigation of important manufacturing questions:

- How is production output performing?
- How much raw material is being consumed?
- What percentage of production is classified as waste?
- How effective is equipment operation?
- Which OEE component requires further investigation?
- How much production time is lost to downtime?
- How frequently do machines stop?
- What are the main recorded downtime reasons?
- Where should production teams focus their operational investigations?

---

## 9. Business Value

The purpose of this dashboard is not simply to display production statistics.

It provides a structured reporting environment that can support:

- Production performance monitoring
- Material consumption analysis
- Waste monitoring
- Equipment effectiveness evaluation
- Downtime investigation
- Operational performance reviews
- Data-driven production discussions

By bringing different manufacturing indicators together, the dashboard makes operational information easier to explore and interpret.

---

## 10. Limitations & Considerations

The interpretation of manufacturing KPIs depends on the quality and definitions of the underlying production records.

Important considerations include:

- KPI definitions should remain consistent across reporting periods.
- Differences in yearly source structures must be considered during data preparation.
- Downtime indicators should be interpreted according to the available recorded downtime information.
- Identifying a downtime pattern does not automatically establish its root cause.
- Operational improvement claims require additional validation and measurement.

These considerations help distinguish between observed data patterns and conclusions that require further investigation.

---

## 11. Tools & Technologies

**Tools**

- Microsoft Power BI
- Power Query
- DAX
- SQL Server
- Microsoft Excel

**Analytical Techniques**

- Data exploration
- Data cleaning
- Data standardization
- Data modeling
- KPI development
- Operational analysis
- OEE analysis
- Downtime analysis
- Interactive data visualization

---

## 12. Dashboard Structure

The Power BI report consists of four pages:

### Home

<p align="center">
<img width="1465" height="757" alt="Screenshot 2026-11-03 224931" src="https://github.com/user-attachments/assets/8abc3696-9b80-4652-be09-c64e1bfb6ea9" />


</p>

The main navigation page for accessing the report sections.

### Overview

<p align="center">
 <img width="1458" height="842" alt="Screenshot 2026-11-03 225107" src="https://github.com/user-attachments/assets/1a8fc882-b7d4-4524-b2c2-4706d071f26b" />

</p>

A consolidated view of production output, material consumption, and waste indicators.

### OEE

<p align="center">
<img width="1461" height="840" alt="Screenshot 2026-11-03 225128" src="https://github.com/user-attachments/assets/74c92f80-7d0a-4095-b801-87d67f7c6c6e" />

</p>

A focused analysis of equipment effectiveness and its main components.

### Downtime Analysis

<p align="center">
<img width="1453" height="848" alt="Screenshot 2026-11-03 225147" src="https://github.com/user-attachments/assets/cc3bfb99-bfa4-4c76-8a3d-ccf74b4eab30" />

</p>

A detailed view of downtime hours, stoppages, and recorded downtime reasons.

---

## 13. Portfolio Takeaway

This project demonstrates a practical application of data analytics in manufacturing operations.

The focus was not only on creating visualizations, but also on understanding production data, handling different source structures, preparing a consistent analytical foundation, and developing meaningful operational KPIs.

It reflects the value of combining manufacturing knowledge with data analytics to turn production records into a structured reporting solution.

**Raw Data → Standardization → Data Modeling → KPI Development → Operational Insights**

---

## Project Files

The repository includes the Power BI report:

`Report/Manufacturing-KPI-and-Reporting.pbix`

To explore the project:

1. Download the PBIX file.
2. Open it using Power BI Desktop.
3. Navigate through the four report pages.
4. Explore the available KPIs and visualizations.

---

## Author

**Mohamed Ezz**

Data Analyst | Manufacturing & Operations Analytics

Focused on transforming operational data into meaningful insights using Power BI, Excel, SQL, and data analytics techniques.

- GitHub: [ezz076385](https://github.com/ezz076385)
- LinkedIn: [Mohamed Ezz](https://www.linkedin.com/in/mohamedezz076385/)

---

*This is an independently developed portfolio project based on real manufacturing production data. The dashboard demonstrates analytical and reporting capabilities. No specific financial impact or operational improvement is claimed without separately validated measurements.*
