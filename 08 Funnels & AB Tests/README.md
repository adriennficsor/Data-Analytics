# Overview
This project revisits A/B testing results for the "NewYear" and "BlackFriday" marketing campaigns to validate clickthrough rates using alternative data sources. The focus is on estimating clicks using website tracking data instead of relying on potentially flawed original metrics. The analysis also includes conducting A/B tests to determine the statistical significance of variations in campaign performance.

# Tasks and Solutions
## Data Extraction

Used SQL in BigQuery to join marketing campaign data from the turing_data_analytics.adsense_monthly table with website tracking data from the turing_data_analytics.raw_events table.
Calculated the number of unique users who had at least one page view as a proxy for actual clicks.
Replaced the original "clicks" metric with the estimated number of unique users.
## Clickthrough Rate (CTR) Calculation

Calculated CTR for each campaign variant (V1 and V2)
​
## A/B Testing

Conducted A/B testing to assess whether the CTR differences between V1 and V2 for "NewYear" and "BlackFriday" campaigns were statistically significant.
Utilized a Binomial A/B Test Calculator to evaluate significance.
Bonus: Developed a custom A/B test method to validate the results, leveraging statistical libraries and calculations for robustness.
# Visualization

Created visualizations in Excel to illustrate:
CTR comparison for V1 and V2 across campaigns.
Statistical significance results using bar charts and annotated insights.
# Tools and Techniques
BigQuery: Extracted and transformed data from multiple tables for analysis.
SQL: Wrote queries to calculate unique user clicks and join datasets.
A/B Testing: Conducted statistical tests to evaluate campaign performance differences.
Excel: Showed the testing results.
