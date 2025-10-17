# Tổng quan tầng Gold - Winner Group Analytics

## Mục tiêu
Tầng Gold được thiết kế để cung cấp dữ liệu sạch, chuẩn hóa và tối ưu cho việc phân tích dữ liệu (EDA) và báo cáo kinh doanh. Dữ liệu từ tầng Silver được clean và load vào tầng Gold với chất lượng cao.

## Kiến trúc dữ liệu
- **Star Schema**: Thiết kế theo mô hình ngôi sao với các bảng fact và dimension
- **Fact Tables**: `fact_orders`, `fact_order_items` - chứa dữ liệu giao dịch
- **Dimension Tables**: `dim_customers`, `dim_products`, `dim_shop`, `dim_date`, `dim_order_pages`, `dim_order_warehouses`, `dim_order_shipping`, `dim_order_payments`

## Các bảng đã xử lý

### 1. Dimension Tables

#### `dim_customers` (1_Clean_dim_customers.ipynb)
- **Mục đích**: Thông tin khách hàng
- **Cleaning**: 
  - Chuẩn hóa giới tính: "Nam", "Nữ", "Unknown"
  - Xử lý giá trị âm trong `purchased_amount` (lấy trị tuyệt đối)
  - Chuẩn hóa tên, số điện thoại, địa chỉ
  - Xóa cột `customer_id` cũ, đổi tên `id` thành `customer_id`
- **Kết quả**: Dữ liệu khách hàng sạch, chuẩn hóa

#### `dim_products` (7_Clean_dim_products.ipynb)
- **Mục đích**: Thông tin sản phẩm
- **Cleaning**:
  - Xóa cột `category_ids` (không cần thiết)
  - Fillna `category_name` = "Le Van Duy"
- **Kết quả**: Dữ liệu sản phẩm đã clean

#### `dim_shop` (10_Clean_dim_shop.ipynb)
- **Mục đích**: Thông tin cửa hàng
- **Cleaning**: Không cần cleaning, load trực tiếp
- **Kết quả**: 1 record cửa hàng Winner Group

#### `dim_date` (2_dim_date.ipynb)
- **Mục đích**: Bảng thời gian cho phân tích time-series
- **Cleaning**: Không cần cleaning, load trực tiếp
- **Kết quả**: Bảng ngày tháng đầy đủ với các thuộc tính thời gian

#### `dim_order_pages` (3_Clean_dim_orders_pages.ipynb)
- **Mục đích**: Thông tin trang đặt hàng
- **Cleaning**: Xóa cột `page_username` (tỷ lệ null cao)
- **Kết quả**: Dữ liệu trang đặt hàng sạch

#### `dim_order_warehouses` (6_Clean_dim_order_warehouses.ipynb)
- **Mục đích**: Thông tin kho hàng
- **Cleaning**: 
  - Chỉ giữ 3 cột: `warehouse_id`, `warehouse_name`, `warehouse_address`
  - Tạo tên kho ngẫu nhiên từ các quận Hà Nội
  - Tạo địa chỉ ngẫu nhiên ở Hà Nội
- **Kết quả**: Dữ liệu kho hàng đa dạng, tập trung ở Hà Nội

#### `dim_order_shipping` (5_Clean_order_shipping.ipynb)
- **Mục đích**: Thông tin vận chuyển
- **Cleaning**: Không cần cleaning, load trực tiếp
- **Kết quả**: Dữ liệu vận chuyển sạch

#### `dim_order_payments` (4_Clean_dim_order_payments.ipynb)
- **Mục đích**: Thông tin thanh toán
- **Cleaning**: Không cần cleaning, load trực tiếp
- **Kết quả**: Dữ liệu thanh toán sạch

### 2. Fact Tables

#### `fact_orders` (9_Clean_fact_orders.ipynb)
- **Mục đích**: Dữ liệu đơn hàng chính
- **Cleaning**: Không cần cleaning, load trực tiếp
- **Kết quả**: 40,236 đơn hàng với đầy đủ thông tin

#### `fact_order_items` (8_Clean_fact_order_items.ipynb)
- **Mục đích**: Chi tiết sản phẩm trong đơn hàng
- **Cleaning**: Không cần cleaning, load trực tiếp
- **Kết quả**: 46,611 items với thông tin chi tiết

## Data Quality Standards

### Các tiêu chí chất lượng dữ liệu đã áp dụng:
1. **Completeness**: Đảm bảo dữ liệu đầy đủ, xử lý null values
2. **Accuracy**: Chuẩn hóa format, xử lý giá trị bất thường
3. **Consistency**: Đồng nhất format dữ liệu
4. **Validity**: Kiểm tra tính hợp lệ của dữ liệu
5. **Uniqueness**: Đảm bảo khóa chính duy nhất
6. **Timeliness**: Dữ liệu cập nhật theo thời gian thực

## Schema Mapping

### Data Types được sử dụng:
- **String(100)**: ID fields, khóa chính và khóa ngoại
- **String(255)**: Text fields ngắn
- **Text()**: Text fields dài
- **Float()**: Số thực (giá tiền, rating)
- **Integer()**: Số nguyên (số lượng, đếm)
- **DateTime()**: Thời gian

## Data Dictionary

### File: `Technical_Document/Gold_dictionary.xlsx`
- **Mục đích**: Tài liệu hóa schema và ý nghĩa business
- **Nội dung**: 
  - Tên bảng, tên cột
  - Data type, SQL type
  - Thống kê null, unique values
  - Ý nghĩa business bằng tiếng Việt
  - Thời gian tạo

## Kết quả đạt được

### Tổng số bảng: 9 bảng
- **2 Fact Tables**: `fact_orders`, `fact_order_items`
- **7 Dimension Tables**: `dim_customers`, `dim_products`, `dim_shop`, `dim_date`, `dim_order_pages`, `dim_order_warehouses`, `dim_order_shipping`, `dim_order_payments`

### Tổng số records:
- **fact_orders**: 40,236 đơn hàng
- **fact_order_items**: 46,611 items
- **dim_customers**: Dữ liệu khách hàng đã clean
- **dim_products**: 37 sản phẩm
- **dim_shop**: 1 cửa hàng Winner Group
- **dim_date**: Bảng ngày tháng đầy đủ
- **Các dimension khác**: Dữ liệu sạch và chuẩn hóa

### Chất lượng dữ liệu:
- ✅ Dữ liệu sạch, chuẩn hóa
- ✅ Schema mapping chính xác
- ✅ Data dictionary hoàn chỉnh
- ✅ Sẵn sàng cho EDA và analytics

## Sẵn sàng cho bước tiếp theo

Tầng Gold đã hoàn thành và sẵn sàng cho:
1. **Exploratory Data Analysis (EDA)**
2. **Business Intelligence và Reporting**
3. **Machine Learning và Predictive Analytics**
4. **Dashboard và Visualization**

---
*Tạo bởi: Winner Group Analytics Team*  
*Ngày: 2025-10-18*  
*Phiên bản: 1.0*
