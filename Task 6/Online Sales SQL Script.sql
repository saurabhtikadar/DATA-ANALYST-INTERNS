--Create database
CREATE DATABASE onlinedb;
---------------------------------------------------------------------------------------------------
--Create Sales Table
CREATE TABLE sales (
    InvoiceNo INT,
    StockCode TEXT,
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10, 2),
    CustomerID NUMERIC(10,0), -- In CSV file Customer ID is in numeric format so cannot use text or varchar
    Country TEXT,
    Discount NUMERIC(10, 2),
    PaymentMethod TEXT,
    ShippingCost NUMERIC(10, 2),
    Category TEXT,
    SalesChannel TEXT,
    ReturnStatus TEXT,
    ShipmentProvider TEXT,
    WarehouseLocation TEXT,
    OrderPriority TEXT);
-------------------------------------------------------------------------------------------
--Import Data
COPY sales
FROM 'D:\DATA ANALYST\Internship\Day-6-Sales Trend Analysis Using Aggregations\Online Dataset\online_sales_dataset.csv'
DELIMITER ','
CSV HEADER;

--Show Data
select * from sales;

--------------------------------------------------------------------------------------------
--Set customerid datatype NUMERIC to TEXT And VALUE NULL to Others
ALTER TABLE sales ALTER COLUMN customerid TYPE TEXT;
UPDATE sales
SET customerid = 'Others'
WHERE customerid is null;

--Show
select * from sales Order by customerid desc;
--------------------------------------------------------------------------------------------
--Changing the Shipping Cost column null value to 0
UPDATE sales
SET ShippingCost = 0
WHERE ShippingCost IS NULL;
--Show
select * from sales order by ShippingCost;
--------------------------------------------------------------------------------------------
--Converts negative numbers to their absolute (positive) values in `quantity` And `unitprice`
UPDATE sales
SET Quantity = ABS(Quantity),
    UnitPrice = ABS(UnitPrice)
WHERE Quantity < 0 OR UnitPrice < 0;
--Show
select * from sales order by quantity,unitprice;
--------------------------------------------------------------------------------------------
--1. Extracting month and year from invoice date, getting total revenue And order volume
SELECT 
    EXTRACT(YEAR FROM invoicedate) AS year, -- Extracts the year from order_date
    EXTRACT(MONTH FROM invoicedate) AS month, -- Extracts the month from order_date
    SUM((quantity * unitprice) - discount + shippingcost) AS total_revenue, -- Calculates total revenue
    COUNT(DISTINCT invoiceno) AS order_volume -- Counts unique orders in the month
FROM 
    sales
WHERE ReturnStatus != 'Returned'
GROUP BY 
    year, month -- Groups data by year and month
ORDER BY 
    total_revenue DESC -- Sorts by revenue in descending order
lIMIT 10; -- Limits output to the top 5 months with the highest revenue
----------------------------------------------------------------------------------------------
--2. Revenue Calculation for Each Transaction
SELECT 
    invoiceno,
	stockcode,
	description,
    (Quantity * UnitPrice) - Discount + ShippingCost AS Revenue
FROM sales;
----------------------------------------------------------------------------------------------
--3. Top-Selling Products with revenue
SELECT 
    StockCode,
    Description,
    SUM(Quantity) AS TotalQuantitySold,
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue,
	SUM(CASE WHEN ReturnStatus = 'Returned' THEN (Quantity * UnitPrice) + Discount - ShippingCost ELSE 0 END) AS TotalReturns
FROM 
    sales
GROUP BY 
    StockCode, Description
ORDER BY 
    TotalQuantitySold DESC
LIMIT 10;
----------------------------------------------------------------------------------------------
--4. Customer Analysis
SELECT 
    CustomerID, 
    COUNT(DISTINCT InvoiceNo) AS OrderFrequency, 
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue
FROM sales
WHERE ReturnStatus != 'Returned'
GROUP BY CustomerID
ORDER BY TotalRevenue DESC;
------------------------------------------------------------------------------------------------
--5. Geographical Insights
SELECT 
    Country, 
    COUNT(DISTINCT InvoiceNo) AS TotalOrders, 
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue,
	SUM(CASE WHEN ReturnStatus = 'Returned' THEN (Quantity * UnitPrice) + Discount - ShippingCost ELSE 0 END) AS TotalReturns
FROM sales
GROUP BY Country
ORDER BY TotalRevenue DESC;
------------------------------------------------------------------------------------------------
--6. Monthly Trends
SELECT 
    DATE_TRUNC('month', InvoiceDate) AS Month, 
    COUNT(DISTINCT InvoiceNo) AS TotalOrders, 
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue,
	SUM(CASE WHEN ReturnStatus = 'Returned' THEN (Quantity * UnitPrice) + Discount - ShippingCost ELSE 0 END) AS TotalReturns
FROM sales
GROUP BY Month
ORDER BY Month;
-----------------------------------------------------------------------------------------------