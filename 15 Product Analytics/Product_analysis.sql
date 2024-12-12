# Time difference between session_start and puchase
WITH raw_data AS (
  # sort out only session_start and purchase
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_date,
    TIMESTAMP_MICROS(event_timestamp) AS event_time,
    event_name,
    user_pseudo_id,
    category,
    total_item_quantity AS quantity,
    purchase_revenue_in_usd AS revenue,
    transaction_id,
    campaign,
    mobile_model_name,
    mobile_brand_name,
    operating_system,
    browser,
    browser_version,
    country
  FROM tc-da-1.turing_data_analytics.raw_events
  WHERE event_name IN ("session_start", "purchase")
),
previous_events AS (
  # getting the previous events and timestamps
  SELECT
    *,
    LAG(event_time) OVER 
    (PARTITION BY user_pseudo_id ORDER BY event_time) AS previous_timestamp,
    LAG(event_name) OVER 
    (PARTITION BY user_pseudo_id ORDER BY event_time) AS previous_event
  FROM raw_data
),
purchases AS (
  # getting only purchases with sessions
  SELECT
    *,
    TIMESTAMP_DIFF(event_time, previous_timestamp, MINUTE) AS start_to_purchase_time,
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id ORDER BY event_time) AS purchase_no
  FROM
    previous_events
  WHERE event_name = "purchase" 
  AND revenue > 0
  AND previous_event = "session_start"
),
event_number AS (
  # count events to purchase
  SELECT
    p.user_pseudo_id,
    p.event_date,
    p.purchase_no,
    COUNT(t.event_name) AS event_count
  FROM tc-da-1.turing_data_analytics.raw_events t
  JOIN purchases p
  ON t.user_pseudo_id = p.user_pseudo_id
  AND TIMESTAMP_MICROS(t.event_timestamp) >= p.previous_timestamp
  AND TIMESTAMP_MICROS(t.event_timestamp) < p.event_time
  GROUP BY p.user_pseudo_id, p.event_date, p.purchase_no
),
first_purchase AS (
SELECT 
  user_pseudo_id,
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_purchase_date
FROM tc-da-1.turing_data_analytics.raw_events
WHERE event_name = 'purchase'
GROUP BY user_pseudo_id
)

SELECT
  p.*,
  en.event_count,
  CASE WHEN p.event_date != fp.first_purchase_date THEN 1 ELSE 0 END AS returning_customer
FROM purchases p
LEFT JOIN event_number en
ON p.user_pseudo_id = en.user_pseudo_id
AND p.purchase_no = en.purchase_no
LEFT JOIN first_purchase AS fp
ON p.user_pseudo_id = fp.user_pseudo_id
WHERE start_to_purchase_time IS NOT NULL
AND start_to_purchase_time < 300
ORDER BY event_time