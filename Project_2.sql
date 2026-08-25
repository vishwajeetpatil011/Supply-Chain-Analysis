USE supply_chain_db;

-- Total Orders
SELECT COUNT(ï»¿Order_ID) AS Total_Orders
FROM fact_orders;  

-- Total Sales Revenue
SELECT SUM(Unit_Price * Order_Quantity) AS Total_Sales_Revenue
FROM fact_orders;

-- Average Order Value (AOV)
SELECT SUM(Unit_Price * Order_Quantity) / COUNT(ï»¿Order_ID) AS Avg_Order_Value
FROM fact_orders;

USE supply_chain_db;

-- Orders by Region/Country/City;
USE supply_chain_db;

SELECT w.Warehouse_Region,
       w.Warehouse_Country,
       w.Warehouse_City,
       COUNT(ï»¿Order_ID) AS Orders_Count
FROM fact_orders o
JOIN dim_warehouse w
  ON o.Warehouse_ID = w.ï»¿Warehouse_ID
GROUP BY w.Warehouse_Region, w.Warehouse_Country, w.Warehouse_City; 

-- Stock on Hand
SELECT SUM(Stock_On_Hand) AS Total_Stock_On_Hand
FROM fact_Inventory;

-- Reorder Status (% products below reorder level)
SELECT (SUM(CASE WHEN Stock_On_Hand < Reorder_Level THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Reorder_Percentage
FROM fact_inventory;

-- Average Lead Time
SELECT AVG(Delay_Days) AS Avg_Lead_Time
FROM fact_orders;

-- Inventory Turnover Ratio 
USE supply_chain_db;

SELECT 
    SUM(o.Unit_Cost) / SUM(i.Stock_On_Hand) AS Inventory_Turnover_Ratio
FROM fact_orders o
JOIN fact_inventory i
  ON o.Warehouse_ID = i.Warehouse_ID;

-- Procurement Cost
SELECT SUM(Unit_Cost * Order_Quantity) AS Procurement_Cost
FROM fact_orders;


-- Transportation Cost
SELECT SUM(Shipping_Cost) AS Total_Transportation_Cost
FROM fact_orders;

-- Total Supply Chain Cost
SELECT SUM(Order_Quantity * Unit_Cost + Shipping_Cost) AS Total_supplychaincost
FROM fact_orders;


-- Cost per Unit
SELECT SUM(COGS) / SUM(Order_Quantity) AS Cost_Per_Unit
FROM fact_orders;
--- On-Time Delivery %
SELECT (SUM(CASE WHEN Delivery_Status = 'On-Time' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS OnTime_Delivery_Percentage
FROM fact_orders;

-- Average Delay (days)
SELECT AVG(Delay_Days) AS Avg_Delay
FROM fact_orders;

-- Orders by Ship Mode
SELECT Ship_Mode, COUNT(ï»¿Order_ID) AS Orders_Count
FROM fact_orders
GROUP BY Ship_Mode;

-- Transport Mode Utilization
USE supply_chain_db;

SELECT Ship_Mode,
       COUNT(ï»¿Order_ID) AS Orders_Count,
       (COUNT(ï»¿Order_ID) * 100.0 / (SELECT COUNT(*) FROM fact_orders)) AS Utilization_Percentage
FROM fact_orders
GROUP BY Ship_Mode;

-- Forecast Accuracy
SELECT 
    1 - (ABS(SUM(Order_Quantity) - SUM(Shipped_Quantity))  / SUM(Order_Quantity)) AS Accuracy
FROM fact_orders;


-- Fill Rate
SELECT AVG(Fill_Rate_Pct) AS Avg_Fill_Rate
FROM fact_orders;

-- Backorder Rate
SELECT (SUM(CASE WHEN Shipped_Quantity < Order_Quantity THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Backorder_Rate
FROM fact_orders;


-- Demand vs Actual Sales Trend
SELECT Order_Date,
       SUM(Order_Quantity) AS Demand,
       SUM(Shipped_Quantity) AS Actual_Sales
FROM fact_orders
GROUP BY Order_Date
ORDER BY Order_Date;

-- forecast_Accuracy_month_year
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS Period,
    1 - (ABS(SUM(Order_Quantity) - SUM(Shipped_Quantity)) * 1.0 / SUM(Order_Quantity)) AS Accuracy
FROM fact_orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Period;
