WITH 
customers_purchase AS (
  SELECT 
    customers.customer_unique_id,
    MIN(DATE(order_purchase_timestamp)) AS first_purchase,
    COUNT(*) AS purchase_count
  FROM tc-da-1.olist_db.olist_customesr_dataset customers
  JOIN tc-da-1.olist_db.olist_orders_dataset orders
  ON customers.customer_id = orders.customer_id
  GROUP BY 1
),

customers_data AS (
  SELECT
    customers.customer_id,
    first_purchase,
    purchase_count,
    customers.customer_city,
    customers.customer_state
  FROM tc-da-1.olist_db.olist_customesr_dataset customers
  JOIN customers_purchase
  ON customers_purchase.customer_unique_id = customers.customer_unique_id
),

payments AS (
  SELECT 
    order_id,
    payment_type,
    SUM(payment_value) AS payment_value
  FROM tc-da-1.olist_db.olist_order_payments_dataset
  GROUP BY 1,2
),

order_summarized AS (
  SELECT
    order_id,
    product_id,
    seller_id,
    SUM(price) AS total_price,
    SUM(freight_value) AS total_freight,
    ROUND(SUM(price) + SUM(freight_value),2) AS total_revenue
  FROM tc-da-1.olist_db.olist_order_items_dataset
  GROUP BY 1,2,3
  ORDER BY order_id
)

SELECT 
  orders.order_id,
  DATE(order_purchase_timestamp) AS purchase_time,
  DATE(order_delivered_customer_date) AS delivery_time,
  DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp , DAY) as delivery_duration,
  CASE WHEN order_estimated_delivery_date > order_delivered_customer_date THEN 'On-Time' ELSE 'Late' END AS delivery_status,
  review_score,
  customers_data.customer_id,
  customer_city,
  customer_state,
  first_purchase,
  CASE WHEN DATE(order_purchase_timestamp) != first_purchase THEN "Returning" ELSE "First-time" END AS returning_purchase,
  payment_type,
  payment_value,
  sellers.seller_id,
  seller_city,
  seller_state,
  total_price,
  total_freight,
  total_revenue,
  translation.string_field_1 as product_category
FROM tc-da-1.olist_db.olist_orders_dataset AS orders
JOIN order_summarized
ON order_summarized.order_id = orders.order_id
JOIN tc-da-1.olist_db.olist_order_reviews_dataset AS reviews
ON orders.order_id = reviews.order_id
JOIN customers_data
ON customers_data.customer_id = orders.customer_id
JOIN payments
ON payments.order_id = orders.order_id
JOIN tc-da-1.olist_db.olist_sellers_dataset AS sellers
ON order_summarized.seller_id = sellers.seller_id
JOIN tc-da-1.olist_db.olist_products_dataset AS products
ON products.product_id = order_summarized.product_id
JOIN tc-da-1.olist_db.product_category_name_translation AS translation
ON translation.string_field_0 = products.product_category_name
WHERE order_status = 'delivered'
AND first_purchase >= "2017-01-01"
ORDER BY order_id, purchase_time