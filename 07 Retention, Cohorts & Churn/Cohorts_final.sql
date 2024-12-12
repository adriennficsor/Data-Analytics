WITH 
users AS ( --all users with only first sub date
  SELECT 
    user_pseudo_id AS ID,
    MIN(subscription_start) AS first_sub,
    MAX(subscription_end) AS sub_end,
    DATE_TRUNC(MIN(subscription_start), ISOWEEK) AS week_start,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 1 WEEK) AS week1,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 2 WEEK) AS week2,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 3 WEEK) AS week3,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 4 WEEK) AS week4,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 5 WEEK) AS week5,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 6 WEEK) AS week6,
    DATE_ADD(DATE_TRUNC(MIN(subscription_start), ISOWEEK), INTERVAL 7 WEEK) AS week7
  FROM tc-da-1.turing_data_analytics.subscriptions
  WHERE subscription_start >= '2020-11-02'
  GROUP BY ID
  )

SELECT 
  users.week_start,
  COUNT(ID) AS start_users,
  SUM(CASE WHEN (users.sub_end >= week1 OR sub_end IS NULL) AND week1 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend0,
  SUM(CASE WHEN (users.sub_end >= week2 OR sub_end IS NULL) AND week2 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend1,
  SUM(CASE WHEN (users.sub_end >= week3 OR sub_end IS NULL) AND week3 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend2,
  SUM(CASE WHEN (users.sub_end >= week4 OR sub_end IS NULL) AND week4 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend3,
  SUM(CASE WHEN (users.sub_end >= week5 OR sub_end IS NULL) AND week5 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend4,
  SUM(CASE WHEN (users.sub_end >= week6 OR sub_end IS NULL) AND week6 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend5,
  SUM(CASE WHEN (users.sub_end >= week7 OR sub_end IS NULL) AND week7 <= '2021-02-07' THEN 1 ELSE NULL END) AS weekend6,
FROM users 
GROUP BY users.week_start