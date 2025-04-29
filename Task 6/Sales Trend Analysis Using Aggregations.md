# TASK 6: Sales Trend Analysis Using Aggregations

## Objective
The primary goal of this task is to analyze sales trends using SQL aggregations. Key objectives include:

- Analyzing monthly revenue and order volume.
- Identifying top-selling products.
- Evaluating customer behavior.
- Gaining geographical insights.
- Tracking monthly trends in revenue and order activity.

## Tools Used
- Database: PostgreSQL / MySQL / SQLite
- Data Source: [Online sales dataset](https://www.kaggle.com/datasets/yusufdelikkaya/online-sales-dataset/data) Or [Online dataset]()

## Deliverables
- [SQL Script]() to process and analyze data.
- Results tables showcasing insights from the analysis.

---

## SQL Workflow

### 1. **Database and Table Creation**

```sql
-- Create a new database
CREATE DATABASE onlinedb;

-- Create a sales table
CREATE TABLE sales (
    InvoiceNo INT,
    StockCode TEXT,
    Description TEXT,
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10, 2),
    CustomerID NUMERIC(10,0),
    Country TEXT,
    Discount NUMERIC(10, 2),
    PaymentMethod TEXT,
    ShippingCost NUMERIC(10, 2),
    Category TEXT,
    SalesChannel TEXT,
    ReturnStatus TEXT,
    ShipmentProvider TEXT,
    WarehouseLocation TEXT,
    OrderPriority TEXT
);
```

### 2. **Data Import**

```sql
-- Import data from CSV file
COPY sales
FROM 'D:\DATA ANALYST\Internship\Day-6-Sales Trend Analysis Using Aggregations\Online Dataset\online_sales_dataset.csv'
DELIMITER ','
CSV HEADER;
```

### 3. **Data Cleaning and Transformation**

#### 3.1 Customer ID
```sql
-- Convert customer ID to TEXT and handle NULL values
ALTER TABLE sales ALTER COLUMN customerid TYPE TEXT;
UPDATE sales
SET customerid = 'Others'
WHERE customerid IS NULL;
```

#### 3.2 Shipping Cost
```sql
-- Set null values in ShippingCost to 0
UPDATE sales
SET ShippingCost = 0
WHERE ShippingCost IS NULL;
```

#### 3.3 Quantity and Unit Price
```sql
-- Convert negative values to positive in Quantity and UnitPrice
UPDATE sales
SET Quantity = ABS(Quantity),
    UnitPrice = ABS(UnitPrice)
WHERE Quantity < 0 OR UnitPrice < 0;
```

---

## Key Queries and Insights

### 1. **Monthly Revenue and Order Volume**

```sql
SELECT
    EXTRACT(YEAR FROM invoicedate) AS year,
    EXTRACT(MONTH FROM invoicedate) AS month,
    SUM((quantity * unitprice) - discount + shippingcost) AS total_revenue,
    COUNT(DISTINCT invoiceno) AS order_volume
FROM
    sales
WHERE ReturnStatus != 'Returned'
GROUP BY
    year, month
ORDER BY
    total_revenue DESC
LIMIT 10;
```
**Insight:** Identifies the months with the highest revenue and order volume.

**Result:**![Image](https://github.com/user-attachments/assets/9f046591-8575-446d-9c04-d2e16387f4a0)
### 2. **Transaction Revenue Calculation**

```sql
SELECT
  invoiceno,
  stockcode,
  description,
  (Quantity * UnitPrice) - Discount + ShippingCost AS Revenue
FROM sales;
```
**Insight:** Adds a derived column for revenue on each transaction.

**Result:**![Image](https://github.com/user-attachments/assets/53f258aa-3313-4e6d-9aa0-2314455f5c1d)
### 3. **Top-Selling Products**

```sql
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
```
**Insight:** Highlights the top 10 products by revenue and quantity sold.

**Result:**![Image](https://github.com/user-attachments/assets/988fc2de-fdc6-433d-835a-cea52b3383eb)
### 4. **Customer Analysis**

```sql
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS OrderFrequency,
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue
FROM sales
WHERE ReturnStatus != 'Returned'
GROUP BY CustomerID
ORDER BY TotalRevenue DESC;
```
**Insight:** Lists customers with the highest revenue and order frequency.

**Result:**![Image](https://github.com/user-attachments/assets/9b5750a6-62d4-4228-baff-647737ae039c)
### 5. **Geographical Insights**

```sql
SELECT
    Country,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue,
    SUM(CASE WHEN ReturnStatus = 'Returned' THEN (Quantity * UnitPrice) + Discount - ShippingCost ELSE 0 END) AS TotalReturns
FROM sales
GROUP BY Country
ORDER BY TotalRevenue DESC;
```
**Insight:** Summarizes total revenue and order count by country.

**Result:**![Image](https://github.com/user-attachments/assets/6956e7b5-1884-430d-a678-f880bb8cf6db)
### 6. **Monthly Trends**

```sql
SELECT
    DATE_TRUNC('month', InvoiceDate) AS Month,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    SUM((Quantity * UnitPrice) - Discount + ShippingCost) AS TotalRevenue,
    SUM(CASE WHEN ReturnStatus = 'Returned' THEN (Quantity * UnitPrice) + Discount - ShippingCost ELSE 0 END) AS TotalReturns
FROM sales
GROUP BY Month
ORDER BY Month;
```
**Insight:** Provides monthly trends in revenue, order count, and returns.

**Result:**![Image](https://github.com/user-attachments/assets/847ec11a-219f-4253-a21c-e8df48df8fd6)
---

## Summary of Insights

1. **Revenue Calculation**
   - Created a derived revenue column for each transaction.

2. **Top-Selling Products**
   - Identified top 10 products by revenue and quantity sold.

3. **Customer Analysis**
   - Highlighted top customers by total revenue and order frequency.

4. **Geographical Insights**
   - Summarized total revenue and order count by country.

5. **Monthly Trends**
   - Analyzed revenue and order activity grouped by month.

---

## Additional Notes
- Ensure the dataset is clean and imported correctly for accurate analysis.
- SQL code provided is compatible with PostgreSQL and can be adapted for MySQL or SQLite as required.

