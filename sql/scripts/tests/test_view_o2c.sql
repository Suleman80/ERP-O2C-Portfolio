USE AdventureWorksLT2022;

-- 1) Widok istnieje?
IF OBJECT_ID('dbo.VIEW_O2C_OrderLine_KPI_v1', 'V') IS NULL
    RAISERROR('VIEW_O2C_OrderLine_KPI_v1 not found', 16, 1);

-- 2) Zwraca dane?
SELECT TOP 20 *
FROM dbo.VIEW_O2C_OrderLine_KPI_v1
ORDER BY LineGross DESC;

-- 3) Sanity: żadnych NULL w kluczowych polach i dodatnia wartość brutto
SELECT COUNT(*) AS BadRows
FROM dbo.VIEW_O2C_OrderLine_KPI_v1
WHERE CustomerID IS NULL OR ProductID IS NULL OR LineGross <= 0;
