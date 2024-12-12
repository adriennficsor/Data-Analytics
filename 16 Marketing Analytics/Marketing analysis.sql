WITH used_dataset AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    TIMESTAMP_MICROS(event_timestamp) AS event_time,
    event_name,
    user_pseudo_id,
    purchase_revenue_in_usd AS revenue,
    campaign,
    country
  FROM tc-da-1.turing_data_analytics.raw_events
),

previous_events AS (
  SELECT
    *,
    LAG(event_time) OVER 
    (PARTITION BY user_pseudo_id ORDER BY event_time) AS previous_timestamp,
    LAG(event_name) OVER 
    (PARTITION BY user_pseudo_id ORDER BY event_time) AS previous_event
  FROM used_dataset
),

sessions AS (
  SELECT 
    *,
    CASE WHEN TIMESTAMP_DIFF(event_time, previous_timestamp, MINUTE) > 30 OR previous_timestamp IS NULL THEN 1 ELSE 0 END AS is_new_session
  FROM
    previous_events
),

session_ids AS (
SELECT 
  *,
  SUM(is_new_session) OVER (PARTITION BY user_pseudo_id ORDER BY event_time) AS session_id 
FROM sessions
ORDER BY user_pseudo_id, event_time
)

SELECT
  MIN(event_date) AS event_date,
  user_pseudo_id,
  session_id,
  country,
  STRING_AGG(DISTINCT campaign ORDER BY campaign DESC LIMIT 1) AS campaign,
  SUM(revenue) AS total_revenue,
  TIMESTAMP_DIFF(MAX(event_time), MIN(event_time), SECOND) AS session_duration
FROM session_ids
GROUP BY 2,3,4
