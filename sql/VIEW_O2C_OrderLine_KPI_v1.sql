/* VIEW_O2C_OrderLine_KPI_v1.sql
   Cel: widok linii sprzeda¿y O2C z prostymi KPI (LineNet, VAT, LineGross, OTD, ABC)
*/
CREATE OR ALTER VIEW dbo.VIEW_O2C_OrderLine_KPI_v1 AS
SELECT
    soh.SalesOrderID,
    soh.SalesOrderNumber,
    soh.OrderDate,
    c.CustomerID,
    COALESCE(c.CompanyName, c.FirstName + ' ' + c.LastName) AS CustomerName,
    d.SalesOrderDetailID         AS LineNumber,
    p.ProductID,
    p.Name                       AS ProductName,
    d.OrderQty,
    d.UnitPrice,
    CAST(d.UnitPrice * d.OrderQty AS DECIMAL(18,2))                         AS LineNet,
    CAST(ROUND((d.UnitPrice * d.OrderQty) * 0.23, 2) AS DECIMAL(18,2))      AS VAT,       -- demo 23%
    CAST(ROUND((d.UnitPrice * d.OrderQty) * 1.23, 2) AS DECIMAL(18,2))      AS LineGross,
    soh.ShipMethod,
    a.City                        AS ShipToCity,
    a.CountryRegion               AS ShipToCountry,
    /* KPI: On-Time Delivery (demo: 3 dni od z³o¿enia) */
    CASE WHEN soh.ShipDate <= DATEADD(day, 3, soh.OrderDate) THEN 1 ELSE 0 END AS OTD_Flag,
    /* KPI: ABC wg wartoœci pozycji */
    CASE 
        WHEN d.UnitPrice * d.OrderQty >= 5000 THEN 'A'
        WHEN d.UnitPrice * d.OrderQty >= 1000 THEN 'B'
        ELSE 'C'
    END AS ABC_Class
FROM SalesLT.SalesOrderHeader  AS soh
JOIN SalesLT.SalesOrderDetail  AS d   ON d.SalesOrderID = soh.SalesOrderID
JOIN SalesLT.Customer          AS c   ON c.CustomerID   = soh.CustomerID
JOIN SalesLT.Product           AS p   ON p.ProductID    = d.ProductID
LEFT JOIN SalesLT.Address      AS a   ON a.AddressID    = soh.ShipToAddressID;
GO
