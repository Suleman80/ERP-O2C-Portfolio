USE AdventureWorksLT2022;

-- znajdź istniejącego klienta
DECLARE @AnyCustomerID INT = (
  SELECT TOP 1 CustomerID
  FROM SalesLT.Customer
  ORDER BY CustomerID
);

-- 1) Procedura istnieje?
IF OBJECT_ID('dbo.usp_SalesByCustomer', 'P') IS NULL
    RAISERROR('usp_SalesByCustomer not found', 16, 1);

-- 2) Zwraca dane (bez dat)
EXEC dbo.usp_SalesByCustomer @CustomerID = @AnyCustomerID;

-- 3) Zwraca dane (z datami w realnym zakresie)
DECLARE @d1 DATE = (SELECT DATEADD(year, -1, MAX(OrderDate)) FROM SalesLT.SalesOrderHeader);
DECLARE @d2 DATE = (SELECT MAX(OrderDate) FROM SalesLT.SalesOrderHeader);
EXEC dbo.usp_SalesByCustomer @CustomerID = @AnyCustomerID, @DateFrom = @d1, @DateTo = @d2;
