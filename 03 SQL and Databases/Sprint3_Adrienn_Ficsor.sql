  /* Task 1.1 */
SELECT
  p.ProductID,
  p.Name AS Product,
  p.ProductNumber,
  p.Size,
  p.Color,
  p.ProductSubcategoryID,
  s.Name AS Subcategory
FROM  `tc-da-1.adwentureworks_db.product` AS p
JOIN  `tc-da-1.adwentureworks_db.productsubcategory` AS s
ON  p.ProductSubcategoryID = s.ProductSubcategoryID
ORDER BY  Subcategory;

 /* Task 1.2 */
SELECT
  p.ProductID,
  p.Name AS Product,
  p.ProductNumber,
  p.Size,
  p.Color,
  p.ProductSubcategoryID,
  s.Name AS Subcategory,
  c.Name AS Category
FROM  `tc-da-1.adwentureworks_db.product` AS p
JOIN  `tc-da-1.adwentureworks_db.productsubcategory` AS s
ON  p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN  `tc-da-1.adwentureworks_db.productcategory` AS c
ON  s.ProductCategoryID = c.ProductCategoryID
ORDER BY  Category;

 /* Task 1.3 */
SELECT
  p.ProductID,
  p.Name AS Product,
  p.ProductNumber,
  p.Size,
  p.Color,
  p.ProductSubcategoryID,
  s.Name AS Subcategory,
  c.Name AS Category,
  p.ListPrice
FROM  `tc-da-1.adwentureworks_db.product` AS p
JOIN  `tc-da-1.adwentureworks_db.productsubcategory` AS s
ON  p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN  `tc-da-1.adwentureworks_db.productcategory` AS c
ON  s.ProductCategoryID = c.ProductCategoryID
WHERE  c.Name LIKE 'Bikes' AND p.ListPrice > 2000 AND p.SellEndDate IS NULL
ORDER BY  p.ListPrice DESC;

 /* Task 2.1 */
SELECT
  LocationID,
  COUNT(DISTINCT WorkOrderID) AS no_work_order,
  COUNT(DISTINCT ProductID) AS no_unique_product,
  SUM(ActualCost) AS actual_cost
FROM  `tc-da-1.adwentureworks_db.workorderrouting`
WHERE  ActualStartDate >= '2004-01-01'AND ActualStartDate <= '2004-01-31'
GROUP BY  LocationID
ORDER BY  actual_cost DESC;

 /* Task 2.2 */
SELECT
  w.LocationID,
  l.Name,
  COUNT(DISTINCT w.WorkOrderID) AS no_work_order,
  COUNT(DISTINCT w.ProductID) AS no_unique_product,
  SUM(w.ActualCost) AS actual_cost,
  ROUND(AVG(DATE_DIFF(w.ActualEndDate,w.ActualStartDate,day)),2) AS avg_date_diff
FROM  `tc-da-1.adwentureworks_db.workorderrouting` AS w
JOIN  `tc-da-1.adwentureworks_db.location` AS l
ON  l.LocationID = w.LocationID
WHERE  ActualStartDate >= '2004-01-01'AND ActualStartDate <= '2004-01-31'
GROUP BY  w.LocationID, l.Name
ORDER BY  actual_cost DESC;
  
 /* Task 2.3 */
SELECT
  WorkOrderID,
  SUM(ActualCost) AS actual_cost
FROM  `tc-da-1.adwentureworks_db.workorderrouting`
WHERE  ActualStartDate >= '2004-01-01'  AND ActualStartDate <= '2004-01-31'
GROUP BY  WorkOrderID
HAVING  actual_cost > 300;
  
 /* Task 3.1 */
SELECT
  sales_detail.SalesOrderId,
  sales_detail.OrderQty,
  sales_detail.UnitPrice,
  sales_detail.LineTotal,
  sales_detail.ProductId,
  sales_detail.SpecialOfferID,
  spec_offer.Category,
  spec_offer.Description
FROM
  `tc-da-1.adwentureworks_db.salesorderdetail` AS sales_detail
LEFT JOIN
  `tc-da-1.adwentureworks_db.specialofferproduct` AS spec_offer_product
ON
  sales_detail.productId = spec_offer_product.ProductID
LEFT JOIN
  `tc-da-1.adwentureworks_db.specialoffer` AS spec_offer
ON
  sales_detail.SpecialOfferID = spec_offer.SpecialOfferID
WHERE
  sales_detail.productId = spec_offer_product.ProductID
  AND sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID
ORDER BY
  SalesOrderID;
  
 /* Task 3.2 */
SELECT
  a.VendorId AS Id,
  b.ContactId,
  b.ContactTypeId,
  a.Name,
  a.CreditRating,
  a.ActiveFlag,
  c.AddressId,
  d.City
FROM
  `tc-da-1.adwentureworks_db.vendor` AS a
LEFT JOIN
  `tc-da-1.adwentureworks_db.vendorcontact` AS b
ON
 a.VendorId = b.VendorId
LEFT JOIN
  `tc-da-1.adwentureworks_db.vendoraddress` AS c
ON
 a.VendorId = c.VendorId
LEFT JOIN
  `tc-da-1.adwentureworks_db.address` AS d
ON
 c.AddressId = d.AddressId
ORDER BY Id;