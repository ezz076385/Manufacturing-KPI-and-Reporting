# Manufacturing KPI & Reporting Dashboard

### Turning Shop-Floor Production Data into Operational Insights with Power BI

![Power BI](https://img.shields.io/badge/Tool-Power%20BI-yellow)
![Project Type](https://img.shields.io/badge/Project-Individual-blue)
![Data](https://img.shields.io/badge/Data-Real%20Operational%20Data-green)

---

## 1. Project Overview

This project focuses on analyzing manufacturing production data and transforming raw operational records into an interactive Power BI reporting solution.

The dashboard provides visibility into production performance, material consumption, waste, Overall Equipment Effectiveness (OEE), and downtime.

It was developed independently using real manufacturing data to support operational monitoring and data-driven decision-making.

## 2. Business Objective

The main objective is to provide a centralized reporting solution that helps monitor manufacturing performance and evaluate production efficiency.

The dashboard aims to:

- Monitor production output and operational KPIs.
- Track raw material consumption and waste.
- Evaluate OEE and its main components.
- Analyze downtime and machine stoppages.
- Identify operational patterns and potential improvement opportunities.
- Support production monitoring through interactive reporting.

## 3. Methodology & Approach

The project followed a structured data analytics workflow:

1. Data Understanding
2. Data Exploration
3. Data Cleaning and Preparation
4. KPI Definition and Calculation
5. Data Modeling
6. Dashboard Development
7. Operational Analysis

**Tools & Technologies:**

- Power BI
- Power Query
- DAX
- Data Modeling
- Data Visualization

## 4. Data Exploration & Preprocessing

The project started with examining the available manufacturing records to understand their structure, fields, and business meaning.

The preparation process focused on:

- Reviewing data structure and column consistency.
- Handling missing and inconsistent values where necessary.
- Standardizing data for reporting.
- Preparing the dataset for analysis.
- Defining the relationships and analytical structure required for reporting.

The objective was to establish a reliable foundation for KPI calculations and dashboard development.

## 5. Dashboard & Data Visualization

The report consists of four interactive pages, each designed for a specific analytical purpose.

### HOME
The main entry point of the report, providing navigation to the analytical sections.

### Overview
A consolidated view of manufacturing performance, including production output, material consumption, and waste indicators.

### OEE Analysis
An operational performance analysis based on the three main OEE components:

- Availability %
- Performance %
- Quality %

Along with the overall OEE indicator.

### Downtime Analysis
A detailed view of machine downtime and stoppages, including:

- Total Downtime Hours
- Unplanned Downtime
- Downtime %
- Number of Stops
- Average Stop Duration
- Cumulative Downtime % by Stop Reason

## 6. Analysis & KPI Framework

The dashboard includes a collection of manufacturing KPIs designed to monitor production efficiency and operational performance.

| KPI | Purpose |
|---|---|
| Production Meters | Monitor total production output |
| Good Output | Track accepted production |
| Raw Material Used | Monitor material consumption |
| Total Waste % | Evaluate overall material waste |
| Abnormal Waste % | Monitor abnormal waste |
| OEE % | Measure overall equipment effectiveness |
| Availability % | Evaluate equipment availability |
| Performance % | Measure operating performance |
| Quality % | Evaluate production quality |
| Planned Hours | Track planned production time |
| Net Time | Monitor net available production time |
| Actual Run Time | Track actual machine operating time |
| Total Downtime Hours | Measure total downtime |
| Unplanned Downtime | Monitor unplanned production losses |
| Downtime % | Evaluate downtime relative to operating time |
| Number of Stops | Track machine stoppage frequency |
| Average Stop Duration | Measure average stoppage duration |

These KPIs provide different perspectives on production efficiency, equipment utilization, material performance, and operational losses.

## 7. Key Findings & Business Use

Rather than focusing only on production totals, the dashboard provides a structured way to investigate operational performance.

It enables users to:

- Compare production performance across available reporting dimensions.
- Monitor waste and material consumption.
- Evaluate equipment effectiveness through OEE.
- Examine downtime patterns and stoppage reasons.
- Identify areas that may require further operational investigation.
- Support discussions around production efficiency and improvement opportunities.

The dashboard is designed to help users move from raw production records to actionable operational questions.

## 8. Project Summary

This project demonstrates the application of Power BI in manufacturing analytics, combining operational data, KPI development, data modeling, and interactive visualization.

It reflects the importance of connecting manufacturing knowledge with data analytics to build reporting solutions that support better operational visibility.

## 9. Future Improvements

Potential future enhancements include:

- Adding more advanced production trend analysis.
- Developing machine-level performance comparisons.
- Expanding downtime root-cause analysis.
- Introducing production targets and variance analysis.
- Implementing automated data refresh.
- Developing predictive maintenance indicators where suitable data is available.

## 10. Project Files & Review

The repository includes the Power BI report file.

**To explore the project:**

1. Download the `.pbix` file.
2. Open it using Power BI Desktop.
3. Navigate through the four report pages.
4. Explore the available filters, KPIs, and visualizations.

### Repository Structure

```text
Manufacturing-KPI-and-Reporting/
│
├── README.md
│
├── Report/
│   └── Manufacturing-KPI-and-Reporting.pbix
│
└── Screenshots/
    ├── overview.png
    ├── oee.png
    └── downtime-analysis.png