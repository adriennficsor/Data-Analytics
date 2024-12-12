# Overview
This project involves calculating and predicting Customer Lifetime Value (CLV) using cohort analysis. The goal was to create more actionable and reliable CLV insights by addressing two issues in the original analysis:

Including all users who visited the ecommerce site, not just those who made a purchase.
Providing a weekly cohort breakdown of revenue and registrations, assuming a maximum customer lifespan of 12 weeks.
The analysis was done using data from the turing_data_analytics.raw_events table. The calculations and cohort analysis were performed in Excel, with visualizations created in Power BI to provide actionable insights.

# Tasks and Solutions
## Data Extraction and Weekly Revenue Calculation

SQL Query: Used the raw_events table to extract data on user visits and revenue.
Identified each user's first visit as their "registration" date, forming the basis for cohort analysis.
Calculated the weekly revenue per cohort by dividing total revenue by the number of unique users who registered during that week.
## Cohort Analysis

Weekly Revenue by Cohorts: Created a table showing revenue per cohort, divided by the number of users who registered in each week.
Applied conditional formatting to highlight trends and variations across weeks.
## Cumulative Revenue Calculation

Cumulative Revenue by Cohorts: Calculated the cumulative revenue for each cohort, by adding the previous week’s revenue to the current week's revenue.
This helped track how revenue grows over time for each cohort.
## Percentage Growth Analysis

Weekly Percentage Growth: Calculated percentage growth based on the average cumulative revenue for each cohort.
This analysis provided insights into how the revenue grows for each cohort over time, and helped to predict future trends.
## Revenue Prediction

Prediction for Future Weeks: Using the average cumulative growth percentage, predicted future revenue for each cohort for up to 12 weeks.
The predicted revenue was calculated by multiplying the previous week's predicted revenue by the growth percentage for the next week.
# Visualization

Power BI: Created a series of visualizations to present the cohort analysis results:
Weekly Average Revenue by Cohorts (USD): Displayed the weekly revenue per cohort.
Cumulative Revenue by Cohorts (USD): Showed how revenue accumulates over time.
Revenue Prediction by Cohorts (USD): Predicted the future revenue for cohorts based on historical growth.
# Key Insights

Provided a clear view of how revenue grows by cohort over time, making it possible to track trends and identify which cohorts perform better.
The predictions offered an estimate of how much revenue to expect from new users based on their initial cohort performance.
# Tools and Techniques
Excel: Used for cohort calculations, cumulative revenue computation, and percentage growth analysis.
Power BI: Created interactive dashboards to visualize the cohort analysis, revenue growth, and predictions.
SQL (BigQuery): Extracted necessary data from the raw_events table, which was then used in Excel for further calculations.
