-- 2405000047, DUFATANYE GILBERT
-- PROJECT: BRALIRWA MANAGEMENT SYSTEM
show tables;
create database Bralirwa_management_system;
use Bralirwa_management_system;

CREATE TABLE Employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    position VARCHAR(100)
);

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    quantity_in_stock INT DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);

CREATE TABLE Supplier (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(100),
    address TEXT
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    supplier_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE CASCADE
);

CREATE TABLE Production (
    production_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity_produced INT NOT NULL,
    production_date DATE NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE
);


-- 2405000047, DUFATANYE GILBERT

 SQL (CRUD/COUNT, AVG, SUM) for Each Table
sql
Copy
-- CREATE
INSERT INTO Employee (Employee_ID, FirstName, LastName, Department, Position) 
VALUES (1, 'John', 'Doe', 'Production', 'Manager');

-- READ
SELECT * FROM Product WHERE Category = 'Beer';

-- UPDATE
UPDATE Sales SET TotalPrice = 150 WHERE Sale_ID = 1;

-- 2405000047, DUFATANYE GILBERT
-- DELETE
DELETE FROM Supplier WHERE Supplier_ID = 5;

-- COUNT Example
SELECT COUNT(*) FROM Sales WHERE Product_ID = 2;

-- AVG Example
SELECT AVG(Price) FROM Product;

-- SUM Example
SELECT SUM(TotalAmount) FROM Order WHERE Supplier_ID = 3;

-- 	Q 8.
SQL (View(s), Stored Procedures, Triggers)
Views:
View for Employee Sales:

sql
Copy
CREATE VIEW EmployeeSales AS
SELECT e.Employee_ID, e.FirstName, e.LastName, COUNT(s.Sale_ID) AS NumberOfSales
FROM Employee e
LEFT JOIN Sales s ON e.Employee_ID = s.Employee_ID
GROUP BY e.Employee_ID;
View for Product Inventory:

sql
Copy
CREATE VIEW ProductInventory AS
SELECT p.Product_ID, p.Name, p.QuantityInStock
FROM Product p;
Stored Procedures:
Procedure to Insert a Sale:

-- 2405000047, DUFATANYE GILBERT
sql
Copy
CREATE OR REPLACE PROCEDURE InsertSale(p_Product_ID IN INT, p_Quantity IN INT) AS
BEGIN
    INSERT INTO Sales (Product_ID, Quantity, TotalPrice)
    VALUES (p_Product_ID, p_Quantity, (SELECT Price FROM Product WHERE Product_ID = p_Product_ID) * p_Quantity);
END;
Procedure to Update Product Price:

sql
Copy
CREATE OR REPLACE PROCEDURE UpdateProductPrice(p_Product_ID IN INT, p_NewPrice IN DECIMAL) AS
BEGIN
    UPDATE Product
    SET Price = p_NewPrice
    WHERE Product_ID = p_Product_ID;
END;
Triggers:
After Insert Trigger for Sales:

-- 2405000047, DUFATANYE GILBERT
sql
Copy
CREATE OR REPLACE TRIGGER after_sale_insert
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    UPDATE Product
    SET QuantityInStock = QuantityInStock - :NEW.Quantity
    WHERE Product_ID = :NEW.Product_ID;
END;
After Update Trigger for Product:

-- 2405000047, DUFATANYE GILBERT
sql
Copy
CREATE OR REPLACE TRIGGER after_product_update
AFTER UPDATE ON Product
FOR EACH ROW
BEGIN
    IF :OLD.Price <> :NEW.Price THEN
        INSERT INTO PriceHistory (Product_ID, OldPrice, NewPrice, ChangeDate)
        VALUES (:OLD.Product_ID, :OLD.Price, :NEW.Price, SYSDATE);
    END IF;
END;

-- Q9.
 DCL (Create User and Grant Permissions)
sql
Copy
-- Create User
CREATE USER bralirwamanager IDENTIFIED BY password123;

-- 2405000047, DUFATANYE GILBERT
-- Grant Permissions
GRANT CREATE session TO Bralirwa_management_system
GRANT SELECT, INSERT, UPDATE, DELETE ON Employee TO Bralirwa_management_system
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales TO Bralirwa_management_system
GRANT SELECT, INSERT, UPDATE, DELETE ON Product TO Bralirwa_management_system