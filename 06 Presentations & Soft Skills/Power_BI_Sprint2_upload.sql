/* Top SalesPerson */
SELECT DISTINCT 
  CASE WHEN sales.SalesPersonID IS NULL THEN "Online" ELSE CAST(sales.SalesPersonID AS string) END AS SalesPersonID,
  employee.Title,
  employee.ContactID,
  IF(MiddleName IS NULL, CONCAT(FirstName, " ", LastName), CONCAT(FirstName, " ", MiddleName, " ", LastName)) AS FullName,
  territory.Name AS Territory,
  territory.CountryRegionCode
FROM tc-da-1.adwentureworks_db.salesorderheader as sales
LEFT JOIN tc-da-1.adwentureworks_db.employee as employee
ON sales.SalesPersonID = employee.EmployeeID
LEFT JOIN tc-da-1.adwentureworks_db.contact AS contact
ON employee.ContactID = contact.ContactID
LEFT JOIN tc-da-1.adwentureworks_db.salesperson AS salesperson
ON sales.SalesPersonID = salesperson.SalesPersonID
LEFT JOIN tc-da-1.adwentureworks_db.salesterritory AS territory
ON salesperson.TerritoryID = territory.TerritoryID
ORDER BY SalesPersonID;


/* Top customers, query from SQL Sprint4 Task 1.3 */
WITH
aggregated_table AS(
  SELECT
    CustomerID,
    COUNT(SalesOrderID) AS number_order,
    ROUND(SUM(TotalDue),3) AS total_amount,
    MAX(OrderDate) AS last_order
  FROM
    `tc-da-1.adwentureworks_db.salesorderheader` AS sales
  GROUP BY
    CustomerID),

latest_address AS(
  SELECT
    max_address
  FROM (
    SELECT
      CustomerID,
      MAX(AddressID) AS max_address
    FROM
      `tc-da-1.adwentureworks_db.customeraddress` AS cust_address
    GROUP BY
      CustomerID))

SELECT 
DISTINCT sales.CustomerID,
FirstName,
LastName,
CONCAT(FirstName, ' ', LastName) AS FullName,
EmailAddress,
Phone,
customer.AccountNumber,
City,
AddressLine1,
AddressLine2,
stateprovince.Name AS State,
stateprovince.CountryRegionCode,
country.Name AS Country,
territory.Name AS Territory,
territory.Group AS Region,
number_order,
total_amount,
last_order,
CASE
    WHEN last_order BETWEEN ( SELECT DATE_ADD(MAX(OrderDate), INTERVAL -365 DAY) FROM `tc-da-1.adwentureworks_db.salesorderheader`) AND ( SELECT MAX(OrderDate) FROM `tc-da-1.adwentureworks_db.salesorderheader`) THEN 'Active'
  ELSE
  'Inactive'
  END AS activity

FROM tc-da-1.adwentureworks_db.salesorderheader AS sales
LEFT JOIN tc-da-1.adwentureworks_db.contact AS contact
ON sales.ContactID = contact.ContactID
LEFT JOIN `tc-da-1.adwentureworks_db.customer` AS customer
ON sales.CustomerID = customer.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
ON customer.CustomerID = customer_address.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
ON customer_address.AddressID = address.AddressID
LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS stateprovince
ON stateprovince.StateProvinceID = address.StateProvinceID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
ON stateprovince.CountryRegionCode = country.CountryRegionCode
LEFT JOIN tc-da-1.adwentureworks_db.salesterritory as territory
ON sales.TerritoryID = territory.TerritoryID
LEFT JOIN aggregated_table
ON sales.CustomerID = aggregated_table.CustomerID
WHERE customer_address.AddressID IN (SELECT max_address FROM latest_address)
ORDER BY total_amount DESC


/*Products table */
SELECT 
sod.SalesOrderID,
SalesOrderDetailID,
OrderDate,
SalesPersonID,
TerritoryID,
TotalDue,
product.ProductID,
product.Name AS ProductName,
subcat.Name AS Subcategory,
category.Name AS Category,
product.SellStartDate,
product.SellEndDate,
sod.UnitPrice,
sod.OrderQty,
sod.LineTotal AS Revenue,
product.StandardCost,
product.StandardCost*sod.OrderQty AS Cost,
sod.LineTotal - (product.StandardCost*sod.OrderQty) AS GrossProfit
FROM tc-da-1.adwentureworks_db.salesorderdetail AS sod
LEFT JOIN tc-da-1.adwentureworks_db.salesorderheader AS sales
ON sod.SalesOrderID = sales.SalesOrderID
LEFT JOIN tc-da-1.adwentureworks_db.product AS product
ON product.ProductID = sod.ProductID
LEFT JOIN tc-da-1.adwentureworks_db.productsubcategory AS subcat
ON subcat.ProductSubcategoryID = product.ProductSubcategoryID
LEFT JOIN tc-da-1.adwentureworks_db.productcategory AS category
ON category.ProductCategoryID = subcat.ProductCategoryID
ORDER BY SalesOrderID