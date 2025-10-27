-- ===== 0. Tạo schema ba tầng =====
-- CREATE DATABASE IF NOT EXISTS winner_bronze;
-- CREATE DATABASE IF NOT EXISTS winner_silver;
-- CREATE DATABASE IF NOT EXISTS winner_gold;

-- ======================
-- 1. Tạo ROLES (vai trò người dùng)
-- ======================
CREATE ROLE 'admin_role';       -- Admin: toàn quyền hệ thống
CREATE ROLE 'de_role';          -- Data Engineer: xử lý dữ liệu ETL
CREATE ROLE 'da_role';          -- Data Analyst: phân tích dữ liệu
CREATE ROLE 'bi_role';          -- BI Developer: phát triển dashboard/BI
CREATE ROLE 'manager_role';     -- Manager: quản lý, chỉ xem báo cáo
CREATE ROLE 'auditor_role';     -- Auditor: kiểm toán, xem toàn bộ dữ liệu và cấu hình

-- ======================
-- 2. Cấp quyền cho từng ROLE
-- ======================

-- Admin: có toàn quyền trên tất cả database và bảng
GRANT ALL PRIVILEGES ON winner_bronze.* TO 'admin_role';
GRANT ALL PRIVILEGES ON winner_silver.* TO 'admin_role';
GRANT ALL PRIVILEGES ON winner_gold.* TO 'admin_role';

-- Data Engineer: có quyền ghi (INSERT, UPDATE, DELETE) ở Bronze/Silver, 
-- nhưng chỉ có quyền đọc (SELECT) ở Gold
GRANT INSERT, UPDATE, DELETE, SELECT ON winner_bronze.* TO 'de_role';
GRANT INSERT, UPDATE, DELETE, SELECT ON winner_silver.* TO 'de_role';
GRANT SELECT ON winner_gold.* TO 'de_role';

-- Data Analyst: chỉ có quyền đọc dữ liệu ở tầng Gold
GRANT SELECT ON winner_gold.* TO 'da_role';

-- BI Developer: chỉ được đọc một số bảng quan trọng trong Gold (ví dụ: top_products, revenue_summary)
GRANT SELECT ON winner_gold.* TO 'bi_role';
GRANT SELECT ON winner_gold.* TO 'bi_role';

-- Manager: chỉ được xem báo cáo tổng hợp (revenue_summary)
GRANT SELECT ON winner_gold.* TO 'manager_role';

-- Auditor: có quyền đọc tất cả dữ liệu (Bronze, Silver, Gold) 
-- và xem cấu hình hệ thống (SHOW DATABASES, SHOW VIEW)
GRANT SELECT ON winner_bronze.* TO 'auditor_role';
GRANT SELECT ON winner_silver.* TO 'auditor_role';
GRANT SELECT ON winner_gold.* TO 'auditor_role';

-- ======================
-- 3. Tạo USER và gán ROLE
-- ======================

-- Admin user: có toàn quyền
CREATE USER 'admin_user'@'%' 
IDENTIFIED WITH caching_sha2_password BY 'Admin@123';
GRANT 'admin_role' TO 'admin_user'@'%';
SET DEFAULT ROLE 'admin_role' TO 'admin_user'@'%';

-- Data Engineer user: thực hiện ETL
CREATE USER 'etl_user'@'%' 
IDENTIFIED WITH caching_sha2_password BY 'ETL@123';
GRANT 'de_role' TO 'etl_user'@'%';
SET DEFAULT ROLE 'de_role' TO 'etl_user'@'%';

-- Data Analyst user: phân tích dữ liệu, chỉ đọc Gold
CREATE USER 'analyst_user'@'%' 
IDENTIFIED WITH caching_sha2_password BY 'Analyst@123';
GRANT 'da_role' TO 'analyst_user'@'%';
SET DEFAULT ROLE 'da_role' TO 'analyst_user'@'%';

-- BI Developer user: xây dựng báo cáo/dashboards
CREATE USER 'bi_user'@'%' 
IDENTIFIED WITH caching_sha2_password BY 'BI@123';
GRANT 'bi_role' TO 'bi_user'@'%';
SET DEFAULT ROLE 'bi_role' TO 'bi_user'@'%';

-- Manager user: chỉ xem báo cáo tổng hợp
CREATE USER 'manager_user'@'%' 
IDENTIFIED WITH caching_sha2_password BY 'Manager@123';
GRANT 'manager_role' TO 'manager_user'@'%';
SET DEFAULT ROLE 'manager_role' TO 'manager_user'@'%';

-- Auditor user: kiểm toán, đọc toàn bộ dữ liệu và cấu hình
CREATE USER 'auditor_user'@'%' 
IDENTIFIED WITH caching_sha2_password BY 'Audit@123';
GRANT 'auditor_role' TO 'auditor_user'@'%';
SET DEFAULT ROLE 'auditor_role' TO 'auditor_user'@'%';

-- ======================
-- -- 4. Liệt kê tất cả roles đã tạo
-- -- ======================
-- SELECT user, host 
-- FROM mysql.user 
-- WHERE account_locked = 'Y'; 
-- -- ======================
-- -- 5. Kiểm tra quyền (privileges) của một role
-- -- ======================
-- SHOW GRANTS FOR 'de_role'@'%';
-- SHOW GRANTS FOR 'da_role'@'%';
-- SHOW GRANTS FOR 'bi_role'@'%';
-- SHOW GRANTS FOR 'manager_role'@'%';
-- SHOW GRANTS FOR 'auditor_role'@'%';
-- -- ======================

