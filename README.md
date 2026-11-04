# Manufacturing KPI & Reporting Dashboard | Power BI

An individual Power BI project focused on manufacturing performance monitoring and operational reporting. The report uses real production data and brings production output, machine efficiency, OEE, waste, and downtime indicators into one interactive reporting experience.

> **Data note:** This repository contains a Power BI report built from real operational data. The repository owner has confirmed authorization to publish the included material. Please do not reuse, redistribute, or extract the underlying operational data for other purposes without the relevant owner's permission.

## Project Overview

The goal of this project is to provide a consolidated view of manufacturing performance and help users monitor production results, machine effectiveness, material waste, and downtime patterns.

The report was designed and developed independently by the repository owner.

## Report Pages

### 1. Home
A landing page that provides navigation to the report's analytical sections.

### 2. Production Overview
Monitors production volume, good output, raw material consumption, and waste. It includes breakdowns by production month, machine, machine type, model, and shift.

### 3. OEE
Tracks Overall Equipment Effectiveness (OEE) and its three components:

- Availability
- Performance
- Quality

The page also presents supporting time measures such as planned hours, net time, actual run time, availability loss hours, and performance loss hours, with machine- and month-level views.

### 4. Downtime Analysis
Explores downtime and its operational impact through:

- Total downtime hours and unplanned downtime
- Downtime percentage
- Number of stops
- Average stop duration
- Downtime by stop reason with cumulative percentage
- Production and downtime trends
- Waste analysis by material and supervisor

## Key KPIs Included

| Area | KPI / Measure |
|---|---|
| Production | Production Meters |
| Production | Good Output |
| Materials | Raw Material Used |
| Quality / Waste | Total Waste % |
| Quality / Waste | Abnormal Waste % |
| Equipment Effectiveness | OEE % |
| Equipment Effectiveness | Availability % |
| Equipment Effectiveness | Performance % |
| Equipment Effectiveness | Quality % |
| Time | Planned Hours |
| Time | Net Time |
| Time | Actual Run Time |
| Downtime | Total Downtime Hours |
| Downtime | Unplanned Downtime |
| Downtime | Downtime % |
| Downtime | Number of Stops |
| Downtime | Average Stop Duration (min) |
| Downtime | Cumulative % by Stop Reason |

## Tools & Technologies

- Microsoft Power BI Desktop
- Power Query / Power BI data model (as used in the report)
- DAX measures and KPI calculations
- Interactive visuals, slicers, and report-page navigation

## Interactivity

The report includes filtering controls for reporting period, date, and shift on the analytical pages. Users can explore the production, OEE, and downtime views at different levels of detail.

## Repository Structure

```text
Manufacturing-KPI-and-Reporting/
├── README.md
├── Report/
│   └── Manufacturing-KPI-and-Reporting.pbix
└── Screenshots/
    └── (report page screenshots to be added)
```

## How to View the Project

1. Download `Report/Manufacturing-KPI-and-Reporting.pbix`.
2. Open the file using Microsoft Power BI Desktop.
3. Use the report navigation and slicers to explore each analytical page.

## Screenshots

Screenshots of the four report pages will be added here to make the project easier to review directly from GitHub.

## Project Ownership

- **Project type:** Individual project
- **Role:** Power BI Developer / Data Analyst
- **Data:** Real manufacturing production data

## Disclaimer

This project is presented for portfolio and demonstration purposes. The report's measures and visuals should be interpreted in the context of the underlying production process and the definitions used by the organization. No business improvement, financial impact, or performance increase is claimed unless separately measured and documented.
