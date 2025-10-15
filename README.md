# ERP O2C — portfolio (SQL + KPI)

**Kierunek:** Konsultant/AMS → Presales (logistyka & sprzedaż, SMB/mid).  
**Wartość:** łączę O2C z SQL/Power BI (KPI: OTD, lead time, ABC).

## Artefakty
- VIEW: `VIEW_O2C_OrderLine_KPI_v1` — OTD, ABC, VAT/NET/GROSS
- PROC: `usp_SalesByCustomer` — @CustomerID + opcjonalne daty

## Szybkie uruchomienie (SSMS)
1. Połącz z AdventureWorksLT2022  
2. Uruchom: `scripts/tests/test_view_o2c.sql` i `scripts/tests/test_proc_sales_by_customer.sql`

