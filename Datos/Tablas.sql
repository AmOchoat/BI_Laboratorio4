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
Stock_Item VARCHAR(200),
Color VARCHAR(50),
Selling_Package VARCHAR(50),
Buying_Package VARCHAR(50),
Size_val VARCHAR(50),
Lead_Time_Days INT,
Quantity_Per_Outer INT,
Is_Chiller_Stock BOOLEAN,
Tax_Rate DECIMAL,
Unit_Price DECIMAL,
Recommended_Retail_Price DECIMAL,
Typical_Weight_Per_Unit DECIMAL
);

COPY PUBLIC.city FROM 'C:\Users\Familia8A\Desktop\OneDrive - Universidad de los Andes\Universidad\Sexto Semestre\Inteligencia de Negocios\Laboratorios\Laboratorio 4\Laboratorio_4\Datos Procesados\dimension_city.csv' DELIMITER ',' CSV HEADER;

COPY PUBLIC.customer FROM 'C:\Users\Familia8A\Desktop\OneDrive - Universidad de los Andes\Universidad\Sexto Semestre\Inteligencia de Negocios\Laboratorios\Laboratorio 4\Laboratorio_4\Datos Procesados\dimension_customer.csv' DELIMITER ',' CSV HEADER;

COPY PUBLIC.employee FROM 'C:\Users\Familia8A\Desktop\OneDrive - Universidad de los Andes\Universidad\Sexto Semestre\Inteligencia de Negocios\Laboratorios\Laboratorio 4\Laboratorio_4\Datos Procesados\dimension_employee.csv' DELIMITER ',' CSV HEADER;

COPY PUBLIC.stockitem FROM 'C:\Users\Familia8A\Desktop\OneDrive - Universidad de los Andes\Universidad\Sexto Semestre\Inteligencia de Negocios\Laboratorios\Laboratorio 4\Laboratorio_4\Datos Procesados\dimension_stock_item.csv' DELIMITER ',' CSV HEADER;

DROP TABLE stockitem;

SELECT COUNT(*) FROM city;
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM employee;
SELECT COUNT(*) FROM stockitem;G