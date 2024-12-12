This project investigates user behavior trends across marketing campaigns on an e-commerce website. The focus is on identifying if users spend more time on the website on certain weekdays and how this behavior varies across different campaigns.

# Objectives:
Analyze the average time users spend on the website on different weekdays.
Compare user engagement metrics across marketing campaigns to identify patterns or discrepancies.
Deliver actionable insights through dynamic visualizations and a structured presentation.
# Key Steps:
## Data Extraction:

Queried the turing_college.raw_events table in BigQuery using SQL.
Extracted key fields to calculate user time spent on the website, segmented by weekday and marketing campaign.
Developed a custom session logic to model user sessions in the absence of session identifiers, ensuring accurate calculations.
## Data Visualization:

Built dashboards in Power BI to visualize trends in user engagement:
Dynamic charts highlighting weekday duration trends across campaigns.
Comparison of time spent per campaign on different days of the week.
Enhanced visuals with filters and annotations for stakeholder clarity.
Integrated findings into a PowerPoint presentation for ease of sharing.
## Exploratory Insights:

Uncovered specific weekdays where users consistently spent more time on the website, varying by campaign.
Highlighted campaigns driving higher engagement versus underperforming ones, providing a foundation for campaign optimization.
Identified interesting anomalies, such as spikes in engagement during certain campaigns or days.

# Future Recommendations:
Segment analysis by user demographics or purchase behaviors for deeper insights.
Investigate the impact of marketing content (e.g., email vs. ad) on engagement metrics.
Explore multi-touch attribution models to assess the influence of campaigns over time.
# Tools Used:
- SQL: For data extraction and session modeling from BigQuery.
- Power BI: To create dynamic dashboards and detailed visualizations.
- PowerPoint: For presenting findings in a clear and professional format.
