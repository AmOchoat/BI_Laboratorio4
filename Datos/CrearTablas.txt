CREATE TABLE IF NOT EXISTS city(
City_Key INT PRIMARY KEY,
City VARCHAR(150),
State_Province VARCHAR(150),
Country VARCHAR(150),
Continent VARCHAR(150),
Sales_Territory VARCHAR(150),
Region VARCHAR(150),
Subregion VARCHAR(150),
Latest_Recorded_Population INT
);

CREATE TABLE IF NOT EXISTS customer(
Customer_Key INT PRIMARY KEY,
Customer VARCHAR(150),
Bill_To_Customer VARCHAR(150),
Category VARCHAR(150),
Buying_Group VARCHAR(150),
Primary_Contact VARCHAR(150),
Postal_Code INT
);

CREATE TABLE IF NOT EXISTS employee(
Employee_Key INT PRIMARY KEY,
Employee VARCHAR(150),
Preferred_Name VARCHAR(150),
Is_Salesperson BOOLEAN
);

CREATE TABLE IF NOT EXISTS stockitem(
Stock_Item_Key INT PRIMARY KEY,
WWI_Stock_Item_ID INT,
Stock_Item VARCHAR(200),
Color VARCHAR(50),
Selling_Package VARCHAR(50),
Buying_Package VARCHAR(50),
Brand VARCHAR(50),
Size_val VARCHAR(50),
Lead_Time_Days INT,
Quantity_Per_Outer INT,
Is_Chiller_Stock BOOLEAN,
Tax_Rate DECIMAL,
Unit_Price DECIMAL,
Recommended_Retail_Price DECIMAL,
Typical_Weight_Per_Unit DECIMAL
);


CREATE TABLE IF NOT EXISTS fact_order(
Order_Key INT PRIMARY KEY,
City_Key INT REFERENCES city (city_key),
Customer_Key INT REFERENCES customer (customer_key),
Stock_Item_Key INT REFERENCES stockitem (stock_item_key),
Order_Date_Key DATE REFERENCES date_table (date_key),
Picked_Date_Key DATE REFERENCES date_table (date_key),
Salesperson_Key INT REFERENCES employee (employee_key),
Picker_Key INT REFERENCES employee (employee_key),
Package VARCHAR(50),
Quantity INT,
Unit_Price DECIMAL,
Tax_Rate DECIMAL,
Total_Excluding_Tax DECIMAL,
Tax_Amount DECIMAL,
Total_Including_Tax DECIMAL
);

