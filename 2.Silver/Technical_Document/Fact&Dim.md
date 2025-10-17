# 📊 Lý thuyết mô hình Star Schema

## 1️⃣ Tổng quan về Star Schema

**Star Schema** (mô hình hình sao) là một kiến trúc cơ sở dữ liệu được thiết kế đặc biệt cho **Data Warehouse** và **Business Intelligence**. Mô hình này được gọi là "hình sao" vì sơ đồ trông giống như một ngôi sao với một bảng trung tâm (fact table) và các bảng xung quanh (dimension tables).

### 🎯 Đặc điểm chính của Star Schema:
- **Đơn giản**: Dễ hiểu và dễ sử dụng
- **Hiệu quả**: Truy vấn nhanh cho phân tích
- **Linh hoạt**: Dễ mở rộng và bảo trì
- **Chuẩn**: Được sử dụng rộng rãi trong ngành

---

## 2️⃣ Cấu trúc Star Schema

### ⭐ **FACT TABLE (Bảng sự kiện) - Trung tâm**

**Fact Table** là bảng trung tâm chứa các **sự kiện kinh doanh** và **số liệu đo lường**:

#### 🔑 Đặc điểm:
- **Chứa dữ liệu định lượng**: Doanh thu, số lượng, chiết khấu, phí ship
- **Có khóa ngoại**: Tham chiếu đến các bảng dimension
- **Dữ liệu giao dịch**: Orders, payments, deliveries
- **Có thể cộng dồn**: SUM, COUNT, AVG cho phân tích

#### 📊 Ví dụ trong dự án:
```sql
fact_orders (
    order_id,           -- Khóa chính
    customer_id,        -- FK → dim_customers
    page_id,           -- FK → dim_order_pages
    warehouse_id,      -- FK → dim_order_warehouses
    shipping_id,       -- FK → dim_order_shipping
    payment_id,        -- FK → dim_order_payments
    shop_id,           -- FK → dim_shops
    total_price,       -- Số liệu: Tổng giá trị đơn hàng
    total_quantity,    -- Số liệu: Tổng số lượng
    shipping_fee,      -- Số liệu: Phí vận chuyển
    tax,               -- Số liệu: Thuế
    discount,          -- Số liệu: Chiết khấu
    inserted_at,       -- Thời gian tạo đơn
    status             -- Trạng thái đơn hàng
)
```

### 🎯 **DIMENSION TABLES (Bảng chiều) - Xung quanh**

**Dimension Tables** chứa thông tin **mô tả** và **ngữ cảnh** cho các sự kiện:

#### 🔑 Đặc điểm:
- **Thông tin mô tả**: Tên, địa chỉ, loại, danh mục
- **Khóa chính**: ID duy nhất cho mỗi bản ghi
- **Ít thay đổi**: Dữ liệu tương đối ổn định
- **Hỗ trợ phân tích**: Slice & dice, filtering, grouping

#### 📊 Ví dụ trong dự án:

**dim_customers** - Thông tin khách hàng:
```sql
dim_customers (
    customer_id,        -- Khóa chính
    full_name,         -- Tên đầy đủ
    gender,            -- Giới tính
    phone_number,      -- Số điện thoại
    email,             -- Email
    address,           -- Địa chỉ
    province_id,       -- Mã tỉnh
    birthday,          -- Ngày sinh
    created_at         -- Ngày tạo
)
```

**dim_products** - Thông tin sản phẩm:
```sql
dim_products (
    product_id,        -- Khóa chính
    name,              -- Tên sản phẩm
    category_name,     -- Tên danh mục
    brand_id,          -- Mã thương hiệu
    min_price,         -- Giá thấp nhất
    max_price,         -- Giá cao nhất
    total_quantity,    -- Tổng số lượng
    colors,            -- Màu sắc
    sizes,             -- Kích thước
    is_active          -- Trạng thái hoạt động
)
```

---

## 3️⃣ Nguyên tắc thiết kế Star Schema

### 🎯 **1. Normalization Level**
- **Fact Tables**: Denormalized (chứa nhiều số liệu)
- **Dimension Tables**: Slightly normalized (cân bằng giữa hiệu suất và chuẩn hóa)

### 🎯 **2. Granularity (Độ chi tiết)**
- **Fact Table**: Mức độ chi tiết thấp nhất cần thiết
- **Dimension Tables**: Mức độ chi tiết phù hợp với phân tích

### 🎯 **3. Surrogate Keys**
- **Fact Tables**: Sử dụng surrogate keys cho foreign keys
- **Dimension Tables**: Surrogate keys cho primary keys

### 🎯 **4. Slowly Changing Dimensions (SCD)**
- **Type 1**: Ghi đè dữ liệu cũ
- **Type 2**: Lưu trữ lịch sử thay đổi
- **Type 3**: Lưu trữ giá trị trước và sau

---

## 4️⃣ Ưu điểm của Star Schema

### ✅ **Hiệu suất truy vấn cao**
- **JOIN đơn giản**: Chỉ cần JOIN giữa fact và dimension
- **Index hiệu quả**: Dễ dàng tạo index trên khóa chính
- **Aggregation nhanh**: SUM, COUNT, AVG trên fact table

### ✅ **Dễ hiểu và sử dụng**
- **Mô hình trực quan**: Như ngôi sao với fact ở trung tâm
- **Business-friendly**: Phù hợp với cách suy nghĩ của business users
- **Self-documenting**: Cấu trúc bảng rõ ràng, dễ hiểu

### ✅ **Linh hoạt trong phân tích**
- **Multi-dimensional**: Phân tích theo nhiều góc độ
- **Drill-down**: Từ tổng quan đến chi tiết
- **Roll-up**: Từ chi tiết đến tổng quan

---

## 5️⃣ Nhược điểm và hạn chế

### ❌ **Data Redundancy**
- **Dimension tables**: Có thể chứa dữ liệu trùng lặp
- **Storage overhead**: Tốn nhiều dung lượng lưu trữ

### ❌ **Maintenance Complexity**
- **SCD handling**: Phức tạp khi xử lý thay đổi dimension
- **Data quality**: Cần đảm bảo tính nhất quán dữ liệu

### ❌ **Limited Flexibility**
- **Schema changes**: Khó thay đổi cấu trúc khi cần
- **Complex relationships**: Khó mô hình hóa mối quan hệ phức tạp

---

## 6️⃣ So sánh với các mô hình khác

### 🔄 **Star Schema vs Snowflake Schema**

| Tiêu chí | Star Schema | Snowflake Schema |
|----------|-------------|------------------|
| **Cấu trúc** | Đơn giản, phẳng | Phức tạp, phân cấp |
| **Performance** | Nhanh hơn | Chậm hơn (nhiều JOIN) |
| **Storage** | Nhiều redundancy | Ít redundancy hơn |
| **Maintenance** | Dễ bảo trì | Khó bảo trì |
| **Flexibility** | Ít linh hoạt | Linh hoạt hơn |

### 🔄 **Star Schema vs Third Normal Form (3NF)**

| Tiêu chí | Star Schema | 3NF |
|----------|-------------|-----|
| **Mục đích** | OLAP, BI | OLTP |
| **Performance** | Tối ưu cho read | Tối ưu cho write |
| **Complexity** | Đơn giản | Phức tạp |
| **Redundancy** | Cho phép | Loại bỏ |

---

## 7️⃣ Best Practices cho Star Schema

### 🎯 **Thiết kế Fact Table**
1. **Chọn đúng granularity**: Mức độ chi tiết phù hợp
2. **Surrogate keys**: Sử dụng surrogate keys cho foreign keys
3. **Additive measures**: Ưu tiên các số liệu có thể cộng dồn
4. **Partitioning**: Phân vùng theo thời gian

### 🎯 **Thiết kế Dimension Table**
1. **Natural keys**: Lưu trữ natural keys từ source system
2. **Descriptive attributes**: Thêm nhiều thuộc tính mô tả
3. **Hierarchies**: Thiết kế hierarchies phù hợp
4. **SCD strategy**: Chọn chiến lược SCD phù hợp

### 🎯 **Performance Optimization**
1. **Indexing**: Tạo index trên khóa chính và khóa ngoại
2. **Materialized views**: Sử dụng materialized views cho queries phức tạp
3. **Aggregation tables**: Tạo bảng tổng hợp cho queries thường dùng
4. **Compression**: Sử dụng compression để tiết kiệm storage

---

## 8️⃣ Triển khai trong dự án Winner Group Analytics

### 🏗️ **Kiến trúc hiện tại**
```
BRONZE (Raw Data) → SILVER (Star Schema) → GOLD (Data Marts)
```

### 📊 **Star Schema trong Silver Layer**
- **1 Fact Table chính**: `fact_orders` (40,236 records)
- **1 Fact Table phụ**: `fact_order_items` (~40,000+ records)
- **7 Dimension Tables**: customers, products, shops, pages, warehouses, shipping, payments

### 🎯 **Lợi ích đạt được**
- **Query performance**: Truy vấn nhanh cho dashboard
- **Business understanding**: Dễ hiểu cho business users
- **Scalability**: Dễ mở rộng khi thêm dữ liệu mới
- **Maintainability**: Dễ bảo trì và cập nhật

---

## 9️⃣ Kết luận

**Star Schema** là mô hình cơ sở dữ liệu lý tưởng cho **Data Warehouse** và **Business Intelligence**. Với thiết kế đơn giản, hiệu suất cao và dễ hiểu, Star Schema giúp:

- ✅ **Tăng tốc độ phân tích** dữ liệu
- ✅ **Đơn giản hóa** việc truy vấn
- ✅ **Hỗ trợ** các hoạt động BI hiệu quả
- ✅ **Mở rộng** dễ dàng khi cần thiết

Trong dự án **Winner Group Analytics**, Star Schema đã được triển khai thành công ở tầng Silver, tạo nền tảng vững chắc cho việc phân tích dữ liệu bán hàng và khách hàng.

---

*Tài liệu này cung cấp cái nhìn toàn diện về Star Schema và cách triển khai trong thực tế. Để biết thêm chi tiết về implementation cụ thể, tham khảo các notebook trong thư mục `2.Silver/`.*
