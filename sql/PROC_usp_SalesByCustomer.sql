/* usp_SalesByCustomer.sql
   Cel: Raport sprzeda¿y dla pojedynczego klienta (O2C) z opcjonalnym okresem dat.
   U¿ywa AdventureWorksLT (SalesLT.Customer, SalesLT.SalesOrderHeader, SalesLT.SalesOrderDetail)
*/
CREATE OR ALTER PROCEDURE dbo.usp_SalesByCustomer
    @CustomerID INT,
    @DateFrom   DATE = NULL,
    @DateTo     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1) Walidacja: czy taki klient istnieje?
    IF NOT EXISTS (SELECT 1 FROM SalesLT.Customer WHERE CustomerID = @CustomerID)
    BEGIN
        RAISERROR('CustomerID not found.', 16, 1);
        RETURN;
    END;

    -- 2) Raport sprzeda¿y (linie zamówieñ) dla danego klienta
    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        sod.SalesOrderDetailID     AS LineNumber,
        p.ProductID,
        p.Name                     AS ProductName,
        sod.OrderQty,
        sod.UnitPrice,
        sod.UnitPriceDiscount,
        sod.LineTotal              AS LineNet -- w LT jest to wartoœæ pozycji po rabacie
    FROM SalesLT.SalesOrderHeader AS soh
    JOIN SalesLT.SalesOrderDetail AS sod
        ON sod.SalesOrderID = soh.SalesOrderID
    JOIN SalesLT.Customer AS c
        ON c.CustomerID = soh.CustomerID
    JOIN SalesLT.Product AS p
        ON p.ProductID = sod.ProductID
    WHERE
        c.CustomerID = @CustomerID
        AND (@DateFrom IS NULL OR soh.OrderDate >= @DateFrom)
        AND (@DateTo   IS NULL OR soh.OrderDate <  DATEADD(day, 1, @DateTo))
    ORDER BY soh.OrderDate DESC;
END
GO

-- Testy:
-- EXEC dbo.usp_SalesByCustomer @CustomerID = 29736;
-- EXEC dbo.usp_SalesByCustomer @CustomerID = 29736, @DateFrom = '2013-01-01', @DateTo = '2013-12-31';
