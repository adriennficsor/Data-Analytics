WITH fm AS(
  SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) as frequency,
    ROUND(SUM(Quantity * UnitPrice), 2) as monetary,
    MAX(InvoiceDate) as last_purchase
  FROM tc-da-1.turing_data_analytics.rfm
  WHERE CustomerID IS NOT NULL
  AND InvoiceDate BETWEEN '2010-12-01' AND '2011-12-01 23:59:59'
  GROUP BY CustomerID
),
r AS (
  SELECT 
    *,
    DATE_DIFF('2011-12-01', DATE(fm.last_purchase), DAY) as recency
  FROM fm
),
quartiles AS(
  SELECT
    r.*,
    rper.rpercentile [OFFSET(25)] AS r25,
    rper.rpercentile [OFFSET(50)] AS r50,
    rper.rpercentile [OFFSET(75)] AS r75,
    fper.fpercentile [OFFSET(25)] AS f25,
    fper.fpercentile [OFFSET(50)] AS f50,
    fper.fpercentile [OFFSET(75)] AS f75,
    mper.mpercentile [OFFSET(25)] AS m25,
    mper.mpercentile [OFFSET(50)] AS m50,
    mper.mpercentile [OFFSET(75)] AS m75
  FROM 
  r,
  (SELECT APPROX_QUANTILES(recency, 100) AS rpercentile FROM r) AS rper,
  (SELECT APPROX_QUANTILES(frequency, 100) AS fpercentile FROM r) AS fper,
  (SELECT APPROX_QUANTILES(monetary, 100) AS mpercentile FROM r) AS mper
),
score AS(
  SELECT
    *,
    r_score || f_score || m_score AS rfm_score
  FROM (
    SELECT 
      *, 
      CASE WHEN monetary <= m25 THEN 1
            WHEN monetary <= m50 AND monetary > m25 THEN 2 
            WHEN monetary <= m75 AND monetary > m50 THEN 3 
            ELSE 4 
      END AS m_score,
      CASE WHEN frequency <= f25 THEN 1
            WHEN frequency <= f50 AND frequency > f25 THEN 2 
            WHEN frequency <= f75 AND frequency > f50 THEN 3 
            ELSE 4 
      END AS f_score,
      CASE WHEN recency <= r25 THEN 4
            WHEN recency <= r50 AND recency > r25 THEN 3 
            WHEN recency <= r75 AND recency > r50 THEN 2 
            ELSE 1 
      END AS r_score,
        FROM quartiles) AS scoring_table
),
segments AS (
  SELECT
    *,
    CASE 
      WHEN rfm_score IN ('444', '443', '434', '344') THEN 'Champions'
      WHEN rfm_score IN ('441', '442', '433', '432', '424', '343', '342', '334', '333') THEN 'Loyal Customers'
      WHEN rfm_score IN ('431', '423', '422', '421', '341', '332', '324', '323') THEN 'Potential Loyalists'
      WHEN rfm_score IN ('411', '412', '413', '414') THEN 'Recent Customers'
      WHEN rfm_score IN ('311', '312', '321', '322', '331') THEN 'Promising'
      WHEN rfm_score IN ('223', '224', '313', '314') THEN 'Customers Needing Attention'
      WHEN rfm_score IN ('211', '212', '213', '214', '221', '222') THEN 'About to Sleep'
      WHEN rfm_score IN ('141', '142', '241', '242', '231', '232') THEN 'At Risk'
      WHEN rfm_score IN ('133', '134', '143', '144', '233', '234', '243', '244') THEN "Can\'t Lose Them"
      WHEN rfm_score IN ('121', '122', '123', '124', '131', '132') THEN 'Hibernating'
      WHEN rfm_score IN ('111', '112', '113', '114') THEN 'Lost'
    END AS rfm_segment
  FROM score
) --,
-- rfm_total AS (  - For grouping by segments
SELECT 
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_score,
  rfm_segment
FROM segments
/*  )
SELECT 
  rfm_segment,
  ROUND(SUM(monetary),2) AS revenue,
  COUNT(CustomerID) AS cust_count
FROM rfm_total
GROUP BY rfm_segment */
;


-- CLV - Graded task
WITH 
first_visit AS (  -- gets dates for cohorts and users with first visits
  SELECT
    DISTINCT user_pseudo_id AS distinct_users,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', event_date), WEEK) AS week_start,
  FROM tc-da-1.turing_data_analytics.raw_events AS turing
  WHERE event_name = 'first_visit'
),
users AS (        -- adds number of users in each cohorts
  SELECT 
    *
  FROM (
    SELECT 
      *,
      COUNT(distinct_users) OVER (PARTITION BY week_start ORDER BY week_start) AS user_count
    FROM first_visit)
),
user_revenue AS ( --calculates revenue per users in turing table
  SELECT 
    user_pseudo_id,
    SUM(purchase_revenue_in_usd) as revenue,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', event_date), WEEK) AS purchase_week
  FROM tc-da-1.turing_data_analytics.raw_events
  WHERE event_name = 'purchase'
  GROUP BY user_pseudo_id, purchase_week
  ORDER BY user_pseudo_id
)
SELECT 
  week_start,
  user_count,
  ROUND(SUM(IF(purchase_week = week_start, revenue/ user_count, NULL)),4) AS week_0,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 1 WEEK), revenue/ user_count, NULL)),4) AS week_1,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 2 WEEK), revenue/ user_count, NULL)),4) AS week_2,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 3 WEEK), revenue/ user_count, NULL)),4) AS week_3,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 4 WEEK), revenue/ user_count, NULL)),4) AS week_4,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 5 WEEK), revenue/ user_count, NULL)),4) AS week_5,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 6 WEEK), revenue/ user_count, NULL)),4) AS week_6,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 7 WEEK), revenue/ user_count, NULL)),4) AS week_7,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 8 WEEK), revenue/ user_count, NULL)),4) AS week_8,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 9 WEEK), revenue/ user_count, NULL)),4) AS week_9,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 10 WEEK), revenue/ user_count, NULL)),4) AS week_10,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 11 WEEK), revenue/ user_count, NULL)),4) AS week_11,
  ROUND(SUM(IF(purchase_week = DATE_ADD(week_start, INTERVAL 12 WEEK), revenue/ user_count, NULL)),4) AS week_12,
FROM user_revenue
LEFT JOIN users ON users.distinct_users = user_revenue.user_pseudo_id
GROUP BY week_start, user_count
HAVING week_start <= '2021-01-24'
ORDER BY week_start