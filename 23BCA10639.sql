Create DATABASE PROJECT;
USE PROJECT;
CREATE TABLE brands (
    bid NUMBER(5),
    bname VARCHAR2(20)
);
ALTER TABLE brands ADD PRIMARY KEY (bid);

CREATE TABLE inv_user (
    user_id VARCHAR2(20),
    name VARCHAR2(20),
    password VARCHAR2(20),
    last_login TIMESTAMP,
    user_type VARCHAR2(10)
);
ALTER TABLE inv_user ADD PRIMARY KEY (user_id);

CREATE TABLE categories (
    cid NUMBER(5),
    category_name VARCHAR2(20)
);
ALTER TABLE categories ADD PRIMARY KEY (cid);

CREATE TABLE stores (
    sid NUMBER(5),
    sname VARCHAR2(20),
    address VARCHAR2(20),
    mobno NUMBER(10)
);
ALTER TABLE stores ADD PRIMARY KEY (sid);

CREATE TABLE product (
    pid NUMBER(5) PRIMARY KEY,
    cid NUMBER(5),
    bid NUMBER(5),
    sid NUMBER(5),
    pname VARCHAR2(20),
    p_stock NUMBER(5),
    price NUMBER(5),
    added_date DATE,
    FOREIGN KEY (cid) REFERENCES categories(cid),
    FOREIGN KEY (bid) REFERENCES brands(bid),
    FOREIGN KEY (sid) REFERENCES stores(sid)
);

CREATE TABLE provides (
    bid NUMBER(5),
    sid NUMBER(5),
    discount NUMBER(5),
    FOREIGN KEY (bid) REFERENCES brands(bid),
    FOREIGN KEY (sid) REFERENCES stores(sid)
);

CREATE TABLE customer_cart (
    cust_id NUMBER(5) PRIMARY KEY,
    name VARCHAR2(20),
    mobno NUMBER(10)
);

CREATE TABLE select_product (
    cust_id NUMBER(5),
    pid NUMBER(5),
    quantity NUMBER(4),
    FOREIGN KEY (cust_id) REFERENCES customer_cart(cust_id),
    FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE transaction (
    id NUMBER(5) PRIMARY KEY,
    total_amount NUMBER(5),
    paid NUMBER(5),
    due NUMBER(5),
    gst NUMBER(3),
    discount NUMBER(5),
    payment_method VARCHAR2(10),
    cart_id NUMBER(5),
    FOREIGN KEY (cart_id) REFERENCES customer_cart(cust_id)
);

CREATE TABLE invoice (
    item_no NUMBER(5),
    product_name VARCHAR2(20),
    quantity NUMBER(5),
    net_price NUMBER(5),
    transaction_id NUMBER(5),
    FOREIGN KEY (transaction_id) REFERENCES transaction(id)
);
-- Brands
INSERT INTO brands VALUES (1, 'Apple');
INSERT INTO brands VALUES (2, 'Samsung');
INSERT INTO brands VALUES (3, 'Nike');
INSERT INTO brands VALUES (4, 'Fortune');

-- Users
INSERT INTO inv_user VALUES ('vidit@gmail.com', 'vidit', '1234', TO_TIMESTAMP('31-OCT-18 12:40', 'DD-MON-YY HH24:MI'), 'admin');
INSERT INTO inv_user VALUES ('harsh@gmail.com', 'Harsh Khanelwal', '1111', TO_TIMESTAMP('30-OCT-18 10:20', 'DD-MON-YY HH24:MI'), 'Manager');
INSERT INTO inv_user VALUES ('prashant@gmail.com', 'Prashant', '0011', TO_TIMESTAMP('29-OCT-18 10:20', 'DD-MON-YY HH24:MI'), 'Accountant');

-- Categories
INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO categories VALUES (2, 'Clothing');
INSERT INTO categories VALUES (3, 'Grocery');

-- Stores
INSERT INTO stores VALUES (1, 'Ram kumar', 'Katpadi vellore', 9999999999);
INSERT INTO stores VALUES (2, 'Rakesh kumar', 'chennai', 8888555541);
INSERT INTO stores VALUES (3, 'Suraj', 'Haryana', 7777555541);

-- Products
INSERT INTO product VALUES (1, 1, 1, 1, 'IPHONE', 4, 45000, TO_DATE('31-OCT-18', 'DD-MON-YY'));
INSERT INTO product VALUES (2, 1, 1, 1, 'Airpods', 3, 19000, TO_DATE('27-OCT-18', 'DD-MON-YY'));
INSERT INTO product VALUES (3, 1, 1, 1, 'Smart Watch', 3, 19000, TO_DATE('27-OCT-18', 'DD-MON-YY'));
INSERT INTO product VALUES (4, 2, 3, 2, 'Air Max', 6, 7000, TO_DATE('27-OCT-18', 'DD-MON-YY'));
INSERT INTO product VALUES (5, 3, 4, 3, 'REFINED OIL', 6, 750, TO_DATE('25-OCT-18', 'DD-MON-YY'));

-- Provides
INSERT INTO provides VALUES (1, 1, 12);
INSERT INTO provides VALUES (2, 2, 7);
INSERT INTO provides VALUES (3, 3, 15);
INSERT INTO provides VALUES (1, 2, 7);
INSERT INTO provides VALUES (4, 2, 19);
INSERT INTO provides VALUES (4, 3, 20);

-- Customer Cart
INSERT INTO customer_cart VALUES (1, 'Ram', 9876543210);
INSERT INTO customer_cart VALUES (2, 'Shyam', 7777777777);
INSERT INTO customer_cart VALUES (3, 'Mohan', 7777777775);

-- Select Product
INSERT INTO select_product VALUES (1, 2, 2);
INSERT INTO select_product VALUES (1, 3, 1);
INSERT INTO select_product VALUES (2, 3, 3);
INSERT INTO select_product VALUES (3, 2, 1);

-- Transactions
INSERT INTO transaction VALUES (1, 25000, 20000, 5000, 350, 350, 'card', 1);
INSERT INTO transaction VALUES (2, 57000, 57000, 0, 570, 570, 'cash', 2);
INSERT INTO transaction VALUES (3, 19000, 17000, 2000, 190, 190, 'cash', 3);

-- 1. List all products along with their category and brand names
SELECT p.pname, c.category_name, b.bname
FROM product p
JOIN categories c ON p.cid = c.cid
JOIN brands b ON p.bid = b.bid;

-- 2. Show customer names and the total amount they paid in transactions
SELECT cc.name, t.total_amount, t.paid, t.due
FROM transaction t
JOIN customer_cart cc ON t.cart_id = cc.cust_id;

-- 3. Find the products selected by customer 'Ram'
SELECT cc.name, p.pname, sp.quantity
FROM select_product sp
JOIN customer_cart cc ON sp.cust_id = cc.cust_id
JOIN product p ON sp.pid = p.pid
WHERE cc.name = 'Ram';

-- 4. Show stock status for all products (Low stock < 4)
SELECT pname, p_stock
FROM product
WHERE p_stock < 4;

-- 5. List invoices with transaction and net price info
SELECT i.item_no, i.product_name, i.quantity, i.net_price, t.payment_method
FROM invoice i
JOIN transaction t ON i.transaction_id = t.id;

-- 6. Show all stores and which brands they provide
SELECT s.sname, b.bname, p.discount
FROM provides p
JOIN stores s ON p.sid = s.sid
JOIN brands b ON p.bid = b.bid;

-- 7. Count number of products per category
SELECT c.category_name, COUNT(p.pid) AS total_products
FROM categories c
JOIN product p ON c.cid = p.cid
GROUP BY c.category_name;

-- 8. Show last login time for all inventory users
SELECT name, user_type, TO_CHAR(last_login, 'DD-MON-YYYY HH24:MI') AS last_login
FROM inv_user;

-- 9. Calculate total revenue (sum of paid amounts)
SELECT SUM(paid) AS total_revenue
FROM transaction;

-- 10. List customers who used 'cash' as payment method
SELECT cc.name, t.payment_method-- Create the database and use it
CREATE DATABASE PROJECT;
USE PROJECT;

-- Create tables
CREATE TABLE brands (
    bid INT,
    bname VARCHAR(20),
    PRIMARY KEY (bid)
);

CREATE TABLE inv_user (
    user_id VARCHAR(20),
    name VARCHAR(20),
    password VARCHAR(20),
    last_login DATETIME,
    user_type VARCHAR(10),
    PRIMARY KEY (user_id)
);

CREATE TABLE categories (
    cid INT,
    category_name VARCHAR(20),
    PRIMARY KEY (cid)
);

CREATE TABLE stores (
    sid INT,
    sname VARCHAR(20),
    address VARCHAR(50),
    mobno BIGINT,
    PRIMARY KEY (sid)
);

CREATE TABLE product (
    pid INT,
    cid INT,
    bid INT,
    sid INT,
    pname VARCHAR(20),
    p_stock INT,
    price INT,
    added_date DATE,
    PRIMARY KEY (pid),
    FOREIGN KEY (cid) REFERENCES categories(cid),
    FOREIGN KEY (bid) REFERENCES brands(bid),
    FOREIGN KEY (sid) REFERENCES stores(sid)
);

CREATE TABLE provides (
    bid INT,
    sid INT,
    discount INT,
    FOREIGN KEY (bid) REFERENCES brands(bid),
    FOREIGN KEY (sid) REFERENCES stores(sid)
);

CREATE TABLE customer_cart (
    cust_id INT,
    name VARCHAR(20),
    mobno BIGINT,
    PRIMARY KEY (cust_id)
);

CREATE TABLE select_product (
    cust_id INT,
    pid INT,
    quantity INT,
    FOREIGN KEY (cust_id) REFERENCES customer_cart(cust_id),
    FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE transaction (
    id INT,
    total_amount INT,
    paid INT,
    due INT,
    gst INT,
    discount INT,
    payment_method VARCHAR(10),
    cart_id INT,
    PRIMARY KEY (id),
    FOREIGN KEY (cart_id) REFERENCES customer_cart(cust_id)
);

CREATE TABLE invoice (
    item_no INT,
    product_name VARCHAR(20),
    quantity INT,
    net_price INT,
    transaction_id INT,
    FOREIGN KEY (transaction_id) REFERENCES transaction(id)
);

-- Insert data
-- Brands
INSERT INTO brands VALUES (1, 'Apple');
INSERT INTO brands VALUES (2, 'Samsung');
INSERT INTO brands VALUES (3, 'Nike');
INSERT INTO brands VALUES (4, 'Fortune');

-- Users
INSERT INTO inv_user VALUES ('vidit@gmail.com', 'vidit', '1234', '2018-10-31 12:40:00', 'admin');
INSERT INTO inv_user VALUES ('harsh@gmail.com', 'Harsh Khanelwal', '1111', '2018-10-30 10:20:00', 'Manager');
INSERT INTO inv_user VALUES ('prashant@gmail.com', 'Prashant', '0011', '2018-10-29 10:20:00', 'Accountant');

-- Categories
INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO categories VALUES (2, 'Clothing');
INSERT INTO categories VALUES (3, 'Grocery');

-- Stores
INSERT INTO stores VALUES (1, 'Ram kumar', 'Katpadi vellore', 9999999999);
INSERT INTO stores VALUES (2, 'Rakesh kumar', 'Chennai', 8888555541);
INSERT INTO stores VALUES (3, 'Suraj', 'Haryana', 7777555541);

-- Products
INSERT INTO product VALUES (1, 1, 1, 1, 'IPHONE', 4, 45000, '2018-10-31');
INSERT INTO product VALUES (2, 1, 1, 1, 'Airpods', 3, 19000, '2018-10-27');
INSERT INTO product VALUES (3, 1, 1, 1, 'Smart Watch', 3, 19000, '2018-10-27');
INSERT INTO product VALUES (4, 2, 3, 2, 'Air Max', 6, 7000, '2018-10-27');
INSERT INTO product VALUES (5, 3, 4, 3, 'REFINED OIL', 6, 750, '2018-10-25');

-- Provides
INSERT INTO provides VALUES (1, 1, 12);
INSERT INTO provides VALUES (2, 2, 7);
INSERT INTO provides VALUES (3, 3, 15);
INSERT INTO provides VALUES (1, 2, 7);
INSERT INTO provides VALUES (4, 2, 19);
INSERT INTO provides VALUES (4, 3, 20);

-- Customer Cart
INSERT INTO customer_cart VALUES (1, 'Ram', 9876543210);
INSERT INTO customer_cart VALUES (2, 'Shyam', 7777777777);
INSERT INTO customer_cart VALUES (3, 'Mohan', 7777777775);

-- Select Product
INSERT INTO select_product VALUES (1, 2, 2);
INSERT INTO select_product VALUES (1, 3, 1);
INSERT INTO select_product VALUES (2, 3, 3);
INSERT INTO select_product VALUES (3, 2, 1);

-- Transactions
INSERT INTO transaction VALUES (1, 25000, 20000, 5000, 350, 350, 'card', 1);
INSERT INTO transaction VALUES (2, 57000, 57000, 0, 570, 570, 'cash', 2);
INSERT INTO transaction VALUES (3, 19000, 17000, 2000, 190, 190, 'cash', 3);

-- Invoices (sample data)
INSERT INTO invoice VALUES (1, 'Airpods', 2, 38000, 1);
INSERT INTO invoice VALUES (2, 'Smart Watch', 1, 19000, 1);
INSERT INTO invoice VALUES (3, 'Smart Watch', 3, 57000, 2);
INSERT INTO invoice VALUES (4, 'Airpods', 1, 19000, 3);

-- Queries

-- 1. List all products with category and brand
SELECT p.pname, c.category_name, b.bname
FROM product p
JOIN categories c ON p.cid = c.cid
JOIN brands b ON p.bid = b.bid;

-- 2. Show customer names and total transaction info
SELECT cc.name, t.total_amount, t.paid, t.due
FROM transaction t
JOIN customer_cart cc ON t.cart_id = cc.cust_id;

-- 3. Products selected by customer 'Ram'
SELECT cc.name, p.pname, sp.quantity
FROM select_product sp
JOIN customer_cart cc ON sp.cust_id = cc.cust_id
JOIN product p ON sp.pid = p.pid
WHERE cc.name = 'Ram';

-- 4. Low stock products (< 4)
SELECT pname, p_stock
FROM product
WHERE p_stock < 4;

-- 5. Invoices with transaction details
SELECT i.item_no, i.product_name, i.quantity, i.net_price, t.payment_method
FROM invoice i
JOIN transaction t ON i.transaction_id = t.id;

-- 6. Stores and brands they provide
SELECT s.sname, b.bname, p.discount
FROM provides p
JOIN stores s ON p.sid = s.sid
JOIN brands b ON p.bid = b.bid;

-- 7. Count products per category
SELECT c.category_name, COUNT(p.pid) AS total_products
FROM categories c
JOIN product p ON c.cid = p.cid
GROUP BY c.category_name;

-- 8. Last login of inventory users
SELECT name, user_type, DATE_FORMAT(last_login, '%d-%b-%Y %H:%i') AS last_login
FROM inv_user;

-- 9. Total revenue
SELECT SUM(paid) AS total_revenue
FROM transaction;

-- 10. Customers who used 'cash'
SELECT cc.name, t.payment_method
FROM transaction t
JOIN customer_cart cc ON t.cart_id = cc.cust_id
WHERE t.payment_method = 'cash';

FROM transaction t
JOIN customer_cart cc ON t.cart_id = cc.cust_id
WHERE t.payment_method = 'cash';
