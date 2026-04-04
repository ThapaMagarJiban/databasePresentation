-- Security Management 
-- Run this AFTER the main database schema is created.
-- 1. Revoke default PUBLIC execute permissions
REVOKE EXECUTE ON ALL PROCEDURES IN SCHEMA public FROM PUBLIC;
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;

-- 2. Create roles if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'manager_role') THEN
        CREATE ROLE manager_role;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'finance_role') THEN
        CREATE ROLE finance_role;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'reg_customer_role') THEN
        CREATE ROLE reg_customer_role;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'guest_role') THEN
        CREATE ROLE guest_role;
    END IF;
END $$;

-- 3. Ensure guest_role does NOT have execute on purchase_item
REVOKE EXECUTE ON PROCEDURE purchase_item FROM guest_role;

-- 4. Ensure guest_role is not a member of reg_customer_role
REVOKE reg_customer_role FROM guest_role;

-- 5. Grant privileges 

-- Manager: full access
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO manager_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO manager_role;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO manager_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO manager_role;

-- Finance: view all data, edit only customer
GRANT SELECT ON ALL TABLES IN SCHEMA public TO finance_role;
GRANT INSERT, UPDATE, DELETE ON customer TO finance_role;
GRANT USAGE, SELECT ON SEQUENCE customer_customer_id_seq TO finance_role;

-- Registered customers: view products, make purchases
GRANT SELECT ON product, stock, store, customer TO reg_customer_role;
GRANT SELECT, INSERT, UPDATE ON purchase, purchase_item, stock TO reg_customer_role;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO reg_customer_role;
GRANT EXECUTE ON PROCEDURE purchase_item TO reg_customer_role;
-- Grant execute on helper function (critical for registered customers)
GRANT EXECUTE ON FUNCTION fn_get_stock_qty(CHAR(5), INTEGER) TO reg_customer_role;

-- Guests: only view products and register (no purchase)
GRANT SELECT ON product TO guest_role;
GRANT INSERT ON customer TO guest_role;
GRANT USAGE, SELECT ON SEQUENCE customer_customer_id_seq TO guest_role;
GRANT EXECUTE ON PROCEDURE register_customer TO guest_role;
-- No grant for purchase_item to guest_role (already revoked)

-- 6. Create users if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'manager1') THEN
        CREATE USER manager1 WITH PASSWORD 'SecurePass123!';
        GRANT manager_role TO manager1;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'finance1') THEN
        CREATE USER finance1 WITH PASSWORD 'FinPass123!';
        GRANT finance_role TO finance1;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'finance2') THEN
        CREATE USER finance2 WITH PASSWORD 'FinPass123!';
        GRANT finance_role TO finance2;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'finance3') THEN
        CREATE USER finance3 WITH PASSWORD 'FinPass123!';
        GRANT finance_role TO finance3;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'reg_user1') THEN
        CREATE USER reg_user1 WITH PASSWORD 'CustPass123!';
        GRANT reg_customer_role TO reg_user1;
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'guest1') THEN
        CREATE USER guest1 WITH PASSWORD 'GuestPass123!';
        GRANT guest_role TO guest1;
    END IF;
END $$;
-- 5. TEST SECURITY


--test 1
SET ROLE manager1;
SELECT * FROM store;
UPDATE product SET unit_cost = 55.00 WHERE product_id = 'T001';
CALL sp_generate_sales_report(1, '2023-01-01', '2026-12-31');

 
-- Test 2: Finance (Success)
SET ROLE finance1;
SELECT * FROM stock;
INSERT INTO customer (surname, forename, address, tel_no, dob, bank_sort_code, account_number)
VALUES ('FinanceTest', 'User', '123 Street', '00000', '1990-01-01', '11-22-33', '11112222');
UPDATE customer SET address = 'Updated By Finance' WHERE forename = 'User';
DELETE FROM customer WHERE forename = 'User';



-- Test 3: Registered Customer (Success)
SET ROLE reg_user1;
SELECT * FROM product;
CALL purchase_item(1, 1, 'T001', 1);


-- Test 4: Guest Customer (View works, Purchase fails - Security Block)
SET ROLE guest1;
SELECT * FROM product;
CALL purchase_item(1, 1, 'T002', 1);

RESET ROLE;