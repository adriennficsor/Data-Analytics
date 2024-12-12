-- unique events (1388010)
WITH
  unique_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    MIN(event_timestamp) AS first_time
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    user_pseudo_id,
    event_name )
SELECT
  *
FROM
  tc-da-1.turing_data_analytics.raw_events AS turing
JOIN
  unique_events
ON
  unique_events.user_pseudo_id = turing.user_pseudo_id
  AND unique_events.first_time = turing.event_timestamp
  AND unique_events.event_name = turing.event_name
ORDER BY
  turing.user_pseudo_id

-- top 3 countries
SELECT
    country,
    COUNT(DISTINCT user_pseudo_id) AS country_events,
    RANK() OVER (ORDER BY COUNT(DISTINCT user_pseudo_id) DESC) AS country_rank
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    country
  ORDER BY
    country_events DESC
  LIMIT
    3

-- previous queries put together, unique events and top countries
-- only top3 countries 844161
WITH
unique_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    MIN(event_timestamp) AS first_time
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    user_pseudo_id,
    event_name ),

top_countries AS (
  SELECT
    country,
    COUNT(DISTINCT user_pseudo_id) AS total_users
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    country
  ORDER BY
    total_users DESC
  LIMIT 3)
  
SELECT
  *
FROM
  tc-da-1.turing_data_analytics.raw_events AS turing
JOIN
  unique_events
ON
  unique_events.user_pseudo_id = turing.user_pseudo_id
  AND unique_events.first_time = turing.event_timestamp
  AND unique_events.event_name = turing.event_name
JOIN
  top_countries
ON
  top_countries.country = turing.country
  -- only selected events: 216070
WHERE turing.event_name IN ("session_start","view_item","add_to_cart","begin_checkout","purchase")
ORDER BY
  turing.user_pseudo_id

-- group by events and countries: 15
WITH
unique_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    MIN(event_timestamp) AS first_time
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    user_pseudo_id,
    event_name ),

top_countries AS (
  SELECT
    country,
    COUNT(DISTINCT user_pseudo_id) AS total_users
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    country
  ORDER BY
    total_users DESC
  LIMIT 3)

SELECT
  turing.country,
  turing.event_name,
  COUNT(*) AS total_number
FROM
  tc-da-1.turing_data_analytics.raw_events AS turing
JOIN
  unique_events
ON
  unique_events.user_pseudo_id = turing.user_pseudo_id
  AND unique_events.first_time = turing.event_timestamp
  AND unique_events.event_name = turing.event_name
JOIN
  top_countries
ON
  top_countries.country = turing.country
WHERE turing.event_name IN ("session_start","view_item","add_to_cart","begin_checkout","purchase")
GROUP BY turing.country, turing.event_name
ORDER BY turing.event_name

/* Final SQL for the funnel table */
WITH
unique_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    MIN(event_timestamp) AS first_time
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    user_pseudo_id,
    event_name 
  ),

top_countries AS (
  SELECT
    country,
    COUNT(DISTINCT user_pseudo_id) AS country_events,
    RANK() OVER (ORDER BY COUNT(DISTINCT user_pseudo_id) DESC) AS country_rank
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    country
  ORDER BY
    country_events DESC
  LIMIT 3),

top_events AS (
  SELECT
    turing.event_name,
    turing.country,
    COUNT(*) AS event_count,
    top_countries.country_rank
  FROM
    tc-da-1.turing_data_analytics.raw_events AS turing
  JOIN
    unique_events
  ON
    unique_events.user_pseudo_id = turing.user_pseudo_id
    AND unique_events.first_time = turing.event_timestamp
    AND unique_events.event_name = turing.event_name
  JOIN
    top_countries
  ON
    top_countries.country = turing.country
  WHERE turing.event_name IN ("session_start","view_item","add_to_cart","begin_checkout","purchase")
  GROUP BY turing.country, top_countries.country_rank, turing.event_name
  ),

total_events AS (
  SELECT 
    event_name,
    SUM(event_count) AS total_event,
    SUM(CASE WHEN top_events.country_rank = 1 THEN top_events.event_count ELSE 0 END) AS first_country,
    SUM(CASE WHEN top_events.country_rank = 2 THEN top_events.event_count ELSE 0 END) AS second_country,
    SUM(CASE WHEN top_events.country_rank = 3 THEN top_events.event_count ELSE 0 END) AS third_country,
    DENSE_RANK() OVER (ORDER BY SUM(event_count) DESC) AS event_order
  FROM top_events
  GROUP BY event_name
  ),

highest_values AS (
  SELECT 
    MAX(total_event) AS highest_total,
    MAX(first_country) AS highest_first,
    MAX(second_country) AS highest_second,
    MAX(third_country) AS highest_third
  FROM total_events
  )

SELECT 
  event_order,
  total_events.event_name,
  first_country,
  second_country,
  third_country,
  ROUND(((first_country + second_country +  third_country)/ (SELECT highest_total FROM highest_values))*100,2) || '%' AS total_percentage,
  ROUND((first_country / (SELECT highest_first FROM highest_values))*100,2) || '%' AS first_percentage,
  ROUND((second_country / (SELECT highest_second FROM highest_values))*100,2) || '%' AS second_percentage,
  ROUND((third_country / (SELECT highest_third FROM highest_values))*100,2) || '%' AS third_percentage
FROM total_events
ORDER BY event_order

 -- A/B testing
  -- unique users with page_view: 269792
WITH
  page_view_users AS (
  SELECT
    COUNT(DISTINCT user_pseudo_id) AS user_count,
    event_name,
    campaign
  FROM
    tc-da-1.turing_data_analytics.raw_events
  GROUP BY
    event_name,
    campaign )
SELECT
  adsense.campaign,
  adsense.impressions,
  page_view_users.user_count
FROM
  tc-da-1.turing_data_analytics.adsense_monthly AS adsense
JOIN
  page_view_users
ON
  adsense.campaign = page_view_users.campaign
WHERE
  event_name = 'page_view'
  AND adsense.campaign IN ('NewYear_V1',
    'NewYear_V2',
    'BlackFriday_V1',
    'BlackFriday_V2')
  AND Month <> 202111