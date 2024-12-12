/* Task 1.1 */
SELECT individual.CustomerID,
      FirstName,
      LastName,
      CONCAT(FirstName, ' ', LastName) AS FullName,
      CONCAT((CASE WHEN Title IS NULL THEN 'Dear' ELSE Title END), ' ', LastName) AS Addressing_title,
      EmailAddress,
      RIGHT(Phone, LENGTH(PHONE)-STRPOS(Phone, ')')) AS Phone,
      customer.AccountNumber,
      CustomerType,
      City,
      AddressLine1,
      AddressLine2,
      state.Name AS State,
      country.Name AS Country,
      number_order,
      total_amount,
      last_order
FROM `tc-da-1.adwentureworks_db.individual` AS individual
LEFT JOIN `tc-da-1.adwentureworks_db.contact` AS contact
ON individual.ContactID = contact.ContactId
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON individual.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
ON customer.CustomerID = cust_address.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
ON cust_address.AddressID = address.AddressID 
LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
ON state.StateProvinceID = address.StateProvinceID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON state.CountryRegionCode = country.CountryRegionCode
LEFT JOIN (SELECT CustomerID,
                  COUNT(SalesOrderID) AS number_order,
                  ROUND(SUM(TotalDue),3) AS total_amount,
                  MAX(OrderDate) AS last_order
            FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
            GROUP BY CustomerID) AS aggregated
ON aggregated.CustomerID = customer.CustomerID
WHERE cust_address.AddressID IN (SELECT max_number FROM     
                                    (SELECT CustomerID,
                                          MAX(AddressID) AS max_number
                                    FROM `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
                                    GROUP BY CustomerID))
ORDER BY total_amount DESC
LIMIT 200;

/* Task 1.2 */
WITH first_data AS(
SELECT individual.CustomerID,
      FirstName,
      LastName,
      CONCAT(FirstName, ' ', LastName) AS FullName,
      CONCAT((CASE WHEN Title IS NULL THEN 'Dear' ELSE Title END), ' ', LastName) AS Addressing_title,
      EmailAddress,
      RIGHT(Phone, LENGTH(PHONE)-STRPOS(Phone, ')')) AS Phone,
      customer.AccountNumber,
      CustomerType,
      City,
      AddressLine1,
      AddressLine2,
      state.Name AS State,
      country.Name AS Country,
      number_order,
      total_amount,
      last_order
FROM `tc-da-1.adwentureworks_db.individual` AS individual
LEFT JOIN `tc-da-1.adwentureworks_db.contact` AS contact
ON individual.ContactID = contact.ContactId
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON individual.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
ON customer.CustomerID = cust_address.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
ON cust_address.AddressID = address.AddressID 
LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
ON state.StateProvinceID = address.StateProvinceID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON state.CountryRegionCode = country.CountryRegionCode
LEFT JOIN (SELECT CustomerID,
                  COUNT(SalesOrderID) AS number_order,
                  ROUND(SUM(TotalDue),3) AS total_amount,
                  MAX(OrderDate) AS last_order
            FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
            GROUP BY CustomerID) AS aggregated
ON aggregated.CustomerID = customer.CustomerID
WHERE cust_address.AddressID IN (SELECT max_number FROM     
                                    (SELECT CustomerID,
                                          MAX(AddressID) AS max_number
                                    FROM `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
                                    GROUP BY CustomerID))
ORDER BY total_amount DESC)

SELECT *
FROM first_data
WHERE last_order < (SELECT DATE_ADD(MAX(OrderDate), INTERVAL -365 DAY) FROM `tc-da-1.adwentureworks_db.salesorderheader`)
LIMIT 200;

/* Task 1.3 */
SELECT individual.CustomerID,
      FirstName,
      LastName,
      CONCAT(FirstName, ' ', LastName) AS FullName,
      CONCAT((CASE WHEN Title IS NULL THEN 'Dear' ELSE Title END), ' ', LastName) AS Addressing_title,
      EmailAddress,
      RIGHT(Phone, LENGTH(PHONE)-STRPOS(Phone, ')')) AS Phone,
      customer.AccountNumber,
      CustomerType,
      City,
      AddressLine1,
      AddressLine2,
      state.Name AS State,
      country.Name AS Country,
      number_order,
      total_amount,
      last_order,
      CASE WHEN last_order BETWEEN  (SELECT DATE_ADD(MAX(OrderDate), INTERVAL -365 DAY) FROM `tc-da-1.adwentureworks_db.salesorderheader`) 
                              AND   (SELECT MAX(OrderDate) FROM `tc-da-1.adwentureworks_db.salesorderheader`)
            THEN 'Active' ELSE 'Inactive' END AS activity
FROM `tc-da-1.adwentureworks_db.individual` AS individual
LEFT JOIN `tc-da-1.adwentureworks_db.contact` AS contact
ON individual.ContactID = contact.ContactId
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON individual.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
ON customer.CustomerID = cust_address.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
ON cust_address.AddressID = address.AddressID 
LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
ON state.StateProvinceID = address.StateProvinceID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON state.CountryRegionCode = country.CountryRegionCode
LEFT JOIN (SELECT CustomerID,
                  COUNT(SalesOrderID) AS number_order,
                  ROUND(SUM(TotalDue),3) AS total_amount,
                  MAX(OrderDate) AS last_order
            FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
            GROUP BY CustomerID) AS aggregated
ON aggregated.CustomerID = customer.CustomerID
WHERE cust_address.AddressID IN (SELECT max_number FROM     
                                    (SELECT CustomerID,
                                          MAX(AddressID) AS max_number
                                    FROM `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
                                    GROUP BY CustomerID))
ORDER BY CustomerID DESC
LIMIT 500;

/* Task 1.4 */
WITH na_customers AS (
SELECT individual.CustomerID,
      FirstName,
      LastName,
      CONCAT(FirstName, ' ', LastName) AS FullName,
      CONCAT((CASE WHEN Title IS NULL THEN 'Dear' ELSE Title END), ' ', LastName) AS Addressing_title,
      EmailAddress,
      RIGHT(Phone, LENGTH(PHONE)-STRPOS(Phone, ')')) AS Phone,
      customer.AccountNumber,
      CustomerType,
      City,
      AddressLine1,
      REGEXP_EXTRACT (AddressLine1, r"([0-9]+)") AS Address_no,
      REGEXP_REPLACE(AddressLine1, r"^[0-9]+.", "") AS Address_st,
      AddressLine2,
      state.Name AS State,
      country.Name AS Country,
      number_order,
      total_amount,
      last_order,
      CASE WHEN last_order BETWEEN  (SELECT DATE_ADD(MAX(OrderDate), INTERVAL -365 DAY) FROM `tc-da-1.adwentureworks_db.salesorderheader`) 
                              AND   (SELECT MAX(OrderDate) FROM `tc-da-1.adwentureworks_db.salesorderheader`)
            THEN 'Active' ELSE 'Inactive' END AS activity
FROM `tc-da-1.adwentureworks_db.individual` AS individual
LEFT JOIN `tc-da-1.adwentureworks_db.contact` AS contact
ON individual.ContactID = contact.ContactId
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON individual.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
ON customer.CustomerID = cust_address.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
ON cust_address.AddressID = address.AddressID 
LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
ON state.StateProvinceID = address.StateProvinceID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON state.CountryRegionCode = country.CountryRegionCode
LEFT JOIN (SELECT CustomerID,
                  COUNT(SalesOrderID) AS number_order,
                  ROUND(SUM(TotalDue),3) AS total_amount,
                  MAX(OrderDate) AS last_order
            FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
            GROUP BY CustomerID
            HAVING total_amount >= 2500 OR number_order >= 5) AS aggregated
ON aggregated.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
ON customer.TerritoryID = territory.TerritoryID
WHERE cust_address.AddressID IN (SELECT max_number FROM     
                                    (SELECT CustomerID,
                                          MAX(AddressID) AS max_number
                                    FROM `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
                                    GROUP BY CustomerID))
      AND territory.Group = 'North America')

SELECT *
FROM na_customers
WHERE na_customers.activity = 'Active'
ORDER BY Country, State, last_order
LIMIT 500;

/* Task 2.1 */
SELECT 
  LAST_DAY(CAST(sales.OrderDate AS DATE)) AS order_month,
  country.CountryRegionCode AS region_code,
  territory.Name,
  COUNT(SalesOrderID) AS number_orders,
  COUNT(DISTINCT sales.CustomerID) AS number_customers,
  COUNT(DISTINCT SalesPersonID) AS no_salespersons,
  ROUND(SUM(TotalDue),2) AS Total_w_tax
FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON sales.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
ON sales.TerritoryID = territory.TerritoryID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON territory.CountryRegionCode = country.CountryRegionCode
GROUP BY order_month, region_code, territory.Name
ORDER BY region_code, territory.Name, order_month;

/* Task 2.2 */
WITH monthly_sales AS (
  SELECT 
  LAST_DAY(CAST(sales.OrderDate AS DATE)) AS order_month,
  country.CountryRegionCode AS region_code,
  territory.Name AS region,
  COUNT(SalesOrderID) AS number_orders,
  COUNT(DISTINCT sales.CustomerID) AS number_customers,
  COUNT(DISTINCT SalesPersonID) AS no_salespersons,
  ROUND(SUM(TotalDue),2) AS Total_w_tax
FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON sales.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
ON sales.TerritoryID = territory.TerritoryID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON territory.CountryRegionCode = country.CountryRegionCode
GROUP BY order_month, region_code, region
ORDER BY region, order_month)

SELECT *,
  ROUND(SUM(Total_w_tax) OVER (PARTITION BY region ORDER BY order_month),2) AS cumulative_sum
FROM monthly_sales;

SELECT *,
  SUM(Total_w_tax) OVER (PARTITION BY region_code ORDER BY order_month) AS cumulative_sum
FROM monthly_sales;

/* Task 2.3 */
WITH monthly_sales AS (
  SELECT 
  LAST_DAY(CAST(sales.OrderDate AS DATE)) AS order_month,
  country.CountryRegionCode AS region_code,
  territory.Name AS region,
  COUNT(SalesOrderID) AS number_orders,
  COUNT(DISTINCT sales.CustomerID) AS number_customers,
  COUNT(DISTINCT SalesPersonID) AS no_salespersons,
  ROUND(SUM(TotalDue),2) AS Total_w_tax
FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON sales.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
ON sales.TerritoryID = territory.TerritoryID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON territory.CountryRegionCode = country.CountryRegionCode
GROUP BY order_month, region_code, region
ORDER BY region_code, territory.Name, order_month)

SELECT *,
  RANK() OVER (PARTITION BY region ORDER BY Total_w_tax DESC) AS sales_rank,
  ROUND(SUM(Total_w_tax) OVER (PARTITION BY region ORDER BY order_month),2) AS cumulative_sum
FROM monthly_sales
ORDER BY region, sales_rank;

/* Task 2.4 */
WITH 
monthly_sales AS (
  SELECT 
    LAST_DAY(CAST(sales.OrderDate AS DATE)) AS order_month,
    country.CountryRegionCode AS region_code,
    territory.Name AS region,
    COUNT(SalesOrderID) AS number_orders,
    COUNT(DISTINCT sales.CustomerID) AS number_customers,
    COUNT(DISTINCT SalesPersonID) AS no_salespersons,
    ROUND(SUM(TotalDue),2) AS Total_w_tax
  FROM `tc-da-1.adwentureworks_db.salesorderheader` AS sales
  LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
  ON sales.CustomerID = customer.CustomerID
  LEFT JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
  ON sales.TerritoryID = territory.TerritoryID
  LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
  ON territory.CountryRegionCode = country.CountryRegionCode
  GROUP BY order_month, region_code, territory.Name
  ORDER BY region_code, territory.Name, order_month),
avg_table AS (
  WITH
max_tax_table AS (
  SELECT StateProvinceID,
    MAX(TaxRate) AS max_tax
  FROM `tc-da-1.adwentureworks_db.salestaxrate` AS tax_rate
  GROUP BY StateProvinceID)
  SELECT
    DISTINCT country.CountryRegionCode,
    ROUND(AVG(max_tax),2) AS mean_tax_rate
  FROM `tc-da-1.adwentureworks_db.salestaxrate` AS tax_rate
  LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
  ON tax_rate.StateProvinceID = state.StateProvinceID
  LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
  ON state.CountryRegionCode = country.CountryRegionCode
  JOIN max_tax_table
  ON max_tax_table.StateProvinceID = tax_rate.StateProvinceID
  WHERE TaxRate = max_tax_table.max_tax
  GROUP BY country.CountryRegionCode),
percentage AS (
  SELECT 
    CountryRegionCode,
    ROUND(COUNT(tax_rate.StateProvinceID) /
    COUNT(StateProvinceCode),2) AS perc_provinces_w_tax
  FROM `tc-da-1.adwentureworks_db.stateprovince` AS state
  LEFT JOIN `tc-da-1.adwentureworks_db.salestaxrate` AS tax_rate
  ON tax_rate.StateProvinceID = state.StateProvinceID
  GROUP BY CountryRegionCode)

SELECT 
  order_month,
  region_code,
  region,
  number_orders,
  number_customers,
  no_salespersons,
  Total_w_tax,
  RANK() OVER (PARTITION BY region ORDER BY Total_w_tax DESC) AS sales_rank,
  ROUND(SUM(Total_w_tax) OVER (PARTITION BY region ORDER BY order_month),2) AS cumulative_sum,
  avg_table.mean_tax_rate,
  perc_provinces_w_tax
FROM monthly_sales
LEFT JOIN avg_table
ON monthly_sales.region_code = avg_table.CountryRegionCode
LEFT JOIN percentage
ON monthly_sales.region_code = percentage.CountryRegionCode
ORDER BY region, sales_rank;