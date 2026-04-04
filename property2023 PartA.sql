--------------------------------------------------------------------------------
-- Tony's Toy Emporium (TTE) Ltd. - Assignment 1 
-- Concepts Used: 3NF, Triggers, Cursors, Helper Functions, Stored Procedures


-- 1. DROP TABLES (Clean Slate)
DROP TABLE IF EXISTS transfer_item;
DROP TABLE IF EXISTS stock_transfer;
DROP TABLE IF EXISTS purchase_item;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS stock;

DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS bank;

-- 2. CREATE TABLES


CREATE TABLE bank (
    sort_code VARCHAR(8) PRIMARY KEY,
    bank_name VARCHAR(50) NOT NULL,
    bank_address VARCHAR(100) NOT NULL,
    CONSTRAINT chk_bank_sortcode CHECK (sort_code ~ '^\d{2}-\d{2}-\d{2}$')
);

CREATE TABLE store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(50) NOT NULL,
    store_location VARCHAR(50) NOT NULL
);

CREATE TABLE warehouse (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(50) NOT NULL,
    warehouse_location VARCHAR(50) NOT NULL
);

CREATE TABLE product (
    product_id CHAR(5) PRIMARY KEY,
    prod_type VARCHAR(20) NOT NULL,
    prod_name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    unit_cost NUMERIC(6,2) NOT NULL CHECK (unit_cost >= 0)
);

CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    forename VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    tel_no VARCHAR(15),
    dob DATE NOT NULL,
    bank_sort_code VARCHAR(8) NOT NULL REFERENCES bank(sort_code),
    account_number VARCHAR(20) NOT NULL,
    CONSTRAINT chk_dob_past CHECK (dob < CURRENT_DATE)
);

CREATE TABLE stock (
    stock_id SERIAL PRIMARY KEY,
    product_id CHAR(5) NOT NULL REFERENCES product(product_id),
    store_id INT REFERENCES store(store_id),
    warehouse_id INT REFERENCES warehouse(warehouse_id),
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    CONSTRAINT check_location CHECK (
        (store_id IS NOT NULL AND warehouse_id IS NULL) OR 
        (store_id IS NULL AND warehouse_id IS NOT NULL)
    ),
    CONSTRAINT unique_prod_store UNIQUE (product_id, store_id),
    CONSTRAINT unique_prod_warehouse UNIQUE (product_id, warehouse_id)
);

CREATE TABLE purchase (
    purchase_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customer(customer_id),
    store_id INT NOT NULL REFERENCES store(store_id),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE purchase_item (
    purchase_id INT NOT NULL REFERENCES purchase(purchase_id),
    product_id CHAR(5) NOT NULL REFERENCES product(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    line_cost NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (purchase_id, product_id)
);

CREATE TABLE stock_transfer (
    transfer_id SERIAL PRIMARY KEY,
    transfer_date DATE DEFAULT CURRENT_DATE,
    source_warehouse_id INT REFERENCES warehouse(warehouse_id),
    source_store_id INT REFERENCES store(store_id),
    dest_store_id INT NOT NULL REFERENCES store(store_id),
    CONSTRAINT check_source CHECK (
        (source_warehouse_id IS NOT NULL AND source_store_id IS NULL) OR 
        (source_warehouse_id IS NULL AND source_store_id IS NOT NULL)
    )
);

CREATE TABLE transfer_item (
    transfer_id INT NOT NULL REFERENCES stock_transfer(transfer_id),
    product_id CHAR(5) NOT NULL REFERENCES product(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (transfer_id, product_id)
);


-- 3. HELPER FUNCTIONS & TRIGGERS


CREATE OR REPLACE FUNCTION fn_get_stock_qty(p_product_id CHAR(5), p_store_id INT)
RETURNS INTEGER LANGUAGE plpgsql AS $$
DECLARE v_qty INTEGER;
BEGIN
    SELECT quantity INTO v_qty FROM stock WHERE product_id = p_product_id AND store_id = p_store_id;
    IF NOT FOUND THEN RETURN 0; END IF;
    RETURN v_qty;
END;
$$;

CREATE OR REPLACE FUNCTION fn_block_negative_stock() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantity < 0 THEN RAISE EXCEPTION 'CRITICAL ERROR: Stock cannot be negative.'; END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_block_negative_stock BEFORE UPDATE ON stock FOR EACH ROW EXECUTE FUNCTION fn_block_negative_stock();

CREATE OR REPLACE FUNCTION fn_log_new_customer() RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'AUDIT: New Customer Registered - ID: %, Name: % %', NEW.customer_id, NEW.forename, NEW.surname;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_log_new_customer AFTER INSERT ON customer FOR EACH ROW EXECUTE FUNCTION fn_log_new_customer();

-- 4. INSERT SAMPLE DATA


INSERT INTO bank (sort_code, bank_name, bank_address) VALUES 
('11-22-33', 'Lloyds Bank', '12 High St, London'),
('44-55-66', 'HSBC', '45 Market Place, Manchester'),
('77-88-99', 'NatWest', '88 Broad St, Birmingham'),
('12-34-56', 'Barclays', '105 Princes St, Edinburgh'),
('99-88-77', 'Santander', '22 Queen St, Cardiff');

INSERT INTO store (store_name, store_location) VALUES 
('London Central', 'London'), 
('Manchester North', 'Manchester'), 
('Birmingham Bullring', 'Birmingham'),
 ('Edinburgh Royal', 'Edinburgh'),
  ('Cardiff Bay', 'Cardiff');

INSERT INTO warehouse (warehouse_name, warehouse_location) VALUES 
('Main Depot', 'Coventry'), 
('North Depot', 'Leeds'),
('South Depot', 'London'),
('West Depot', 'Bristol'),
('East Depot', 'Norwich');

INSERT INTO product (product_id, prod_type, prod_name, description, unit_cost) VALUES 
('T001', 'Toy', 'Lego X-Wing', 'Star Wars Lego Set', 49.99),
('G001', 'Game', 'FIFA 24', 'Football console game', 59.99),
('T002', 'Toy', 'Action Man', 'Classic action figure', 15.50),
('G002', 'Game', 'Mario Kart', 'Racing game for Switch', 39.99),
('T003', 'Toy', 'Hot Wheels Car', 'Mini racing car', 9.99),
('G003', 'Game', 'Call of Duty', 'Action shooter game', 69.99);

INSERT INTO stock (product_id, store_id, quantity) VALUES 
('T001', 1, 10),
 ('G001', 1, 20), 
 ('T001', 2, 5),
 ('T002', 1, 15),
 ('G002', 2, 25),
 ('T003', 1, 30),
 ('G003', 2, 12);

INSERT INTO customer (surname, forename, address, tel_no, dob, bank_sort_code, account_number) VALUES 
('Smith', 'John', '10 Downing St', '0207999999', '1980-05-12', '11-22-33', '12345678'),
('Doe', 'Jane', '221B Baker St', '0207888888', '1992-11-23', '44-55-66', '87654321'),
('Brown', 'Charlie', '12 London Road', '0711111111', '1995-02-10', '11-22-33', '22223333'),
('Taylor', 'Emma', '45 Park Street', '0722222222', '1998-06-15', '44-55-66', '33334444'),
('Wilson', 'Jack', '78 High Street', '0733333333', '1993-09-20', '77-88-99', '44445555');

INSERT INTO purchase (customer_id, store_id, total_amount) VALUES
(1, 1, 99.98),
(2, 1, 59.99),
(3, 2, 31.00),
(4, 2, 69.99),
(5, 1, 19.98);

INSERT INTO purchase_item (purchase_id, product_id, quantity, line_cost) VALUES
(1, 'T001', 2, 99.98),
(2, 'G001', 1, 59.99),
(3, 'T002', 2, 31.00),
(4, 'G003', 1, 69.99),
(5, 'T003', 2, 19.98);

INSERT INTO stock_transfer (source_store_id, dest_store_id) VALUES
(1, 2),
(2, 3),
(1, 3),
(3, 1),
(2, 1);

INSERT INTO transfer_item (transfer_id, product_id, quantity) VALUES
(1, 'T001', 5),
(2, 'G001', 3),
(3, 'T002', 7),
(4, 'T003', 4),
(5, 'G003', 2);

-- 5. STORED PROCEDURES (Task 5)


-- Procedure 1: Register Customer
CREATE OR REPLACE PROCEDURE register_customer(
    p_surname VARCHAR, p_forename VARCHAR, p_address VARCHAR,
    p_tel_no VARCHAR, p_dob DATE, p_sort_code VARCHAR, p_acc_no VARCHAR
) LANGUAGE plpgsql AS $$
BEGIN
    IF p_sort_code !~ '^\d{2}-\d{2}-\d{2}$' THEN RAISE EXCEPTION 'Invalid Sort Code Format.'; END IF;
    IF NOT EXISTS (SELECT 1 FROM bank WHERE sort_code = p_sort_code) THEN RAISE EXCEPTION 'Bank does not exist.'; END IF;
    INSERT INTO customer (surname, forename, address, tel_no, dob, bank_sort_code, account_number)
    VALUES (p_surname, p_forename, p_address, p_tel_no, p_dob, p_sort_code, p_acc_no);
END;
$$;

-- Procedure 2: Purchase Item
CREATE OR REPLACE PROCEDURE purchase_item(
    p_customer_id INT, p_store_id INT, p_product_id CHAR(5), p_quantity INT
) LANGUAGE plpgsql AS $$
DECLARE
    v_unit_cost NUMERIC; v_stock_now INT; v_purchase_id INT; v_total_cost NUMERIC;
BEGIN
    v_stock_now := fn_get_stock_qty(p_product_id, p_store_id);
    IF v_stock_now < p_quantity THEN RAISE EXCEPTION 'Insufficient Stock: Have %, Need %', v_stock_now, p_quantity; END IF;
    
    SELECT unit_cost INTO v_unit_cost FROM product WHERE product_id = p_product_id;
    IF NOT FOUND THEN RAISE EXCEPTION 'Product not found'; END IF;

    v_total_cost := v_unit_cost * p_quantity;

    INSERT INTO purchase (customer_id, store_id, total_amount) VALUES (p_customer_id, p_store_id, v_total_cost) RETURNING purchase_id INTO v_purchase_id;
    INSERT INTO purchase_item (purchase_id, product_id, quantity, line_cost) VALUES (v_purchase_id, p_product_id, p_quantity, v_total_cost);
    UPDATE stock SET quantity = quantity - p_quantity WHERE store_id = p_store_id AND product_id = p_product_id;

    RAISE NOTICE 'Purchase Successful! Total: £%', v_total_cost;
END;
$$;


-- Procedure 3: Sales Report
CREATE OR REPLACE PROCEDURE sp_generate_sales_report(p_store_id INT, p_start_date DATE, p_end_date DATE) LANGUAGE plpgsql AS $$
DECLARE
    cur_sales CURSOR FOR 
        SELECT p.purchase_date, c.forename, c.surname, pr.prod_name, pr.description, pi.quantity, pi.line_cost
        FROM purchase p JOIN purchase_item pi ON p.purchase_id = pi.purchase_id
        JOIN customer c ON p.customer_id = c.customer_id JOIN product pr ON pi.product_id = pr.product_id
        WHERE p.store_id = p_store_id AND p.purchase_date::DATE BETWEEN p_start_date AND p_end_date;
    rec RECORD;
BEGIN
    RAISE NOTICE '--- SALES REPORT (Store %) ---', p_store_id;
    OPEN cur_sales;
    LOOP
        FETCH cur_sales INTO rec; EXIT WHEN NOT FOUND;
        -- Added description here to meet assignment requirements
        RAISE NOTICE 'Date: % | Cust: % % | Item: % (%) (x%) | Cost: £%', 
            rec.purchase_date::DATE, rec.forename, rec.surname, rec.prod_name, rec.description, rec.quantity, rec.line_cost;
    END LOOP;
    CLOSE cur_sales;
END;
$$;


-- 6. TASK 6: TESTING CALLS (Valid & Invalid)



-- A. Testing: register_customer Procedure

-- VALID CALL: Registering a new customer correctly.
CALL register_customer('Potter', 'Harry', 'Hogwarts', '07712345678', '1990-07-31', '11-22-33', '99887766');

-- INVALID CALL: Registering with a bank sort code that doesn't exist in the Bank table.
 CALL register_customer('Malfoy', 'Draco', 'Manor', '0000000', '1990-06-05', '99-99-99', '11111111');


--  B. Testing: purchase_item Procedure

--  VALID CALL: Customer 1 buys 2 units of Product T001 from Store 1.
CALL purchase_item(1, 1, 'T001', 2);

-- INVALID CALL (Logic Error): Trying to buy 500 units of T001 (Store only has 10). Will throw "Insufficient Stock".
CALL purchase_item(1, 1, 'T001', 500);

-- INVALID CALL (Data Error / Foreign Key): Trying to make a purchase for a Customer that doesn't exist (Customer ID: 999).
-- Purpose: To prove that Referential Integrity (Foreign Keys) prevents orphan purchase records.
CALL purchase_item(999, 1, 'T001', 1);



-- C. Testing: sp_generate_sales_report Procedure

-- VALID CALL: Generate a report for Store 1.
CALL sp_generate_sales_report(1, '2023-01-01', '2026-12-31');

-- INVALID/EDGE CALL: Generate report for a store with no sales or a future date. (Will just print headers).
CALL sp_generate_sales_report(99, '2050-01-01', '2050-12-31');