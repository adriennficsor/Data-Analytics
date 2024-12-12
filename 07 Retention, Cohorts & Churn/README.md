# Overview
This project focuses on analyzing weekly subscription retention rates to identify customer behavior trends and churn patterns. The goal is to provide insights into how many subscribers remain active over a six-week period, enabling data-driven decision-making for product management.

# Tasks and Solutions
## Data Extraction

Used SQL in BigQuery to extract weekly subscription data from the turing_data_analytics.subscriptions table.
Queried data to calculate weekly retention cohorts, tracking subscriber activity for six weeks from their subscription start date.
## Cohort Analysis

Organized data into weekly cohorts to monitor retention trends.
Analyzed how many subscribers from each weekly cohort remained active over subsequent weeks (week 0 to week 6).
## Visualization

Exported results to Excel for initial data formatting and verification.
Created clear and insightful visualizations in Power BI, including heatmaps and trend lines, to represent retention patterns effectively.
# Insights and Commentary

Observed retention trends across different subscription weeks, highlighting key drop-off points and periods of higher engagement.
Provided actionable recommendations for improving retention, such as targeting specific cohorts with engagement strategies.
# Tools and Techniques
BigQuery: Wrote and executed SQL queries to extract and transform subscription data.
Excel: Organized and cleaned the extracted data for visualization readiness.
Power BI: Developed dynamic dashboards and heatmaps for an intuitive view of retention and churn trends.
Cohort Analysis: Applied to understand user retention and identify opportunities to reduce churn.
