-- ============================================
-- HƯỚNG DẪN TẠO ROLE VÀ PHÂN QUYỀN (Guide_RBAC)
-- File này chỉ mang tính chất hướng dẫn, 
-- KHÔNG chứa mật khẩu hoặc thông tin nhạy cảm.
-- ============================================

-- 1. Tạo các ROLE (vai trò người dùng)
CREATE ROLE 'admin_role';       -- Admin: toàn quyền
CREATE ROLE 'de_role';          -- Data Engineer: xử lý dữ liệu ETL
CREATE ROLE 'da_role';          -- Data Analyst: phân tích dữ liệu
CREATE ROLE 'bi_role';          -- BI Developer: phát triển dashboard
CREATE ROLE 'manager_role';     -- Manager: chỉ xem báo cáo tổng hợp
CREATE ROLE 'auditor_role';     -- Auditor: kiểm toán

-- 2. Cấp quyền cho ROLE
-- Admin: toàn quyền
GRANT ALL PRIVILEGES ON *.* TO 'admin_role';

-- Data Engineer: ghi Bronze, Silver; chỉ đọc Gold
GRANT INSERT, UPDATE, DELETE, SELECT ON winner_bronze.* TO 'de_role';
GRANT INSERT, UPDATE, DELETE, SELECT ON winner_silver.* TO 'de_role';
GRANT SELECT ON winner_gold.* TO 'de_role';

-- Data Analyst: chỉ đọc dữ liệu Gold
GRANT SELECT ON winner_gold.* TO 'da_role';

-- BI Developer: chỉ đọc một số bảng báo cáo
GRANT SELECT ON winner_gold.top_products TO 'bi_role';
GRANT SELECT ON winner_gold.revenue_summary TO 'bi_role';

-- Manager: chỉ được xem báo cáo tổng hợp
GRANT SELECT ON winner_gold.revenue_summary TO 'manager_role';

-- Auditor: có quyền đọc tất cả và xem cấu hình
GRANT SELECT ON winner_bronze.* TO 'auditor_role';
GRANT SELECT ON winner_silver.* TO 'auditor_role';
GRANT SELECT ON winner_gold.* TO 'auditor_role';
GRANT SHOW DATABASES, SHOW VIEW ON *.* TO 'auditor_role';

-- ============================================
-- 3. Tạo USER từ ROLE (chỉ hướng dẫn, KHÔNG có mật khẩu thật)
-- Khi áp dụng thực tế, thay 'password_here' bằng mật khẩu thật
-- và lưu trong file RBAC.sql riêng (đã ignore trong git).
-- ============================================

-- Admin user
CREATE USER 'admin_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password_here';
GRANT 'admin_role' TO 'admin_user'@'%';
SET DEFAULT ROLE 'admin_role' TO 'admin_user'@'%';

-- Data Engineer user
CREATE USER 'etl_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password_here';
GRANT 'de_role' TO 'etl_user'@'%';
SET DEFAULT ROLE 'de_role' TO 'etl_user'@'%';

-- Data Analyst user
CREATE USER 'analyst_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password_here';
GRANT 'da_role' TO 'analyst_user'@'%';
SET DEFAULT ROLE 'da_role' TO 'analyst_user'@'%';

-- BI Developer user
CREATE USER 'bi_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password_here';
GRANT 'bi_role' TO 'bi_user'@'%';
SET DEFAULT ROLE 'bi_role' TO 'bi_user'@'%';

-- Manager user
CREATE USER 'manager_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password_here';
GRANT 'manager_role' TO 'manager_user'@'%';
SET DEFAULT ROLE 'manager_role' TO 'manager_user'@'%';

-- Auditor user
CREATE USER 'auditor_user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password_here';
GRANT 'auditor_role' TO 'auditor_user'@'%';
SET DEFAULT ROLE 'auditor_role' TO 'auditor_user'@'%';
