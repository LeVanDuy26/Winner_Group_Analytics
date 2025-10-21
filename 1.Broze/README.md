# Tầng Bronze - Data Lake (Raw Data Layer)

## Thu thập và Lưu trữ Dữ liệu Thô từ Pancake POS API

---

## **TỔNG QUAN TẦNG BRONZE**

### **Mục đích (Purpose)**

Tầng Bronze là lớp dữ liệu thô (raw data) được thu thập trực tiếp từ nguồn Pancake POS API mà không qua bất kỳ xử lý hay biến đổi nào. Đây là nền tảng dữ liệu cho toàn bộ hệ thống analytics của Winner Group.

### **Nguyên tắc thiết kế (Design Principles)**

- **Raw Data Preservation**: Giữ nguyên dữ liệu gốc từ API
- **Schema Flexibility**: Lưu trữ dữ liệu với schema linh hoạt
- **Data Lineage**: Truy xuất nguồn gốc dữ liệu rõ ràng
- **Scalability**: Hỗ trợ mở rộng khi dữ liệu tăng trưởng

---

## **CẤU TRÚC THƯ MỤC**

```
1.Broze/
├── 0_TestPancakeAPI.ipynb     # Kiểm tra giới hạn API và tối ưu hóa
├── Customers.ipynb            # Thu thập dữ liệu khách hàng
├── Orders.ipynb               # Thu thập dữ liệu đơn hàng
├── Products.ipynb             # Thu thập dữ liệu sản phẩm
├── Shop.ipynb                 # Thu thập dữ liệu cửa hàng
└── README.md                  # Tài liệu hướng dẫn
```

---

## **DANH SÁCH NOTEBOOK VÀ CHỨC NĂNG**

### **1. 0_TestPancakeAPI.ipynb - Kiểm tra API**

#### **Mục đích**

- Tìm ra giá trị `page_size` tối đa mà Pancake POS API có thể xử lý
- Tối ưu hóa quá trình ETL (Extract, Transform, Load)
- Tránh lỗi timeout và vượt rate limit

#### **Chức năng chính**

- Test các giá trị `page_size` khác nhau (100, 500, 1000, 2000, 5000)
- Đo thời gian response và success rate
- Xác định "ngưỡng vàng" cho page_size
- Đảm bảo tính toàn vẹn dữ liệu

#### **Kết quả mong đợi**

- Page size tối ưu cho từng endpoint
- Thời gian response trung bình
- Success rate cho các request

---

### **2. Customers.ipynb - Thu thập Dữ liệu Khách hàng**

#### **Mục đích**

- Thu thập thông tin khách hàng từ Pancake POS API
- Lưu trữ dữ liệu thô về khách hàng và danh mục tỉnh/thành phố

#### **Dữ liệu thu thập**

- **Thông tin khách hàng**: ID, tên, email, số điện thoại, địa chỉ
- **Demographics**: Giới tính, tuổi, địa chỉ
- **Behavioral data**: Lịch sử mua hàng, điểm thưởng
- **Geographic data**: Tỉnh/thành phố, quận/huyện

#### **API Endpoints sử dụng**

- `/customers` - Danh sách khách hàng
- `/provinces` - Danh mục tỉnh/thành phố
- `/districts` - Danh mục quận/huyện

#### **Schema dữ liệu**

```sql
-- Bảng customers_raw
customer_id, name, email, phone, address, 
gender, birth_date, created_at, updated_at,
reward_points, current_debts, count_referrals

-- Bảng provinces_raw  
province_id, province_name, province_code

-- Bảng districts_raw
district_id, district_name, province_id
```

---

### **3. Orders.ipynb - Thu thập Dữ liệu Đơn hàng**

#### **Mục đích**

- Thu thập toàn bộ dữ liệu đơn hàng từ Pancake POS API
- Lưu trữ thông tin chi tiết về đơn hàng và items

#### **Dữ liệu thu thập**

- **Order information**: ID đơn hàng, ngày tạo, trạng thái, tổng tiền
- **Customer data**: Thông tin khách hàng đặt hàng
- **Payment data**: Phương thức thanh toán, trạng thái thanh toán
- **Shipping data**: Thông tin vận chuyển, địa chỉ giao hàng
- **Order items**: Chi tiết sản phẩm trong đơn hàng

#### **API Endpoints sử dụng**

- `/orders` - Danh sách đơn hàng
- `/order-items` - Chi tiết items trong đơn hàng
- `/order-payments` - Thông tin thanh toán
- `/order-shipping` - Thông tin vận chuyển

#### **Schema dữ liệu**

```sql
-- Bảng orders_raw
order_id, customer_id, shop_id, status, 
total_price, total_discount, payment_status,
created_at, updated_at, inserted_at

-- Bảng order_items_raw
order_item_id, order_id, product_id, quantity,
price, discount, total_price

-- Bảng order_payments_raw
payment_id, order_id, payment_method, amount,
status, created_at

-- Bảng order_shipping_raw
shipping_id, order_id, address, phone,
status, created_at, delivered_at
```

---

### **4. Products.ipynb - Thu thập Dữ liệu Sản phẩm**

#### **Mục đích**

- Thu thập thông tin sản phẩm và danh mục từ Pancake POS API
- Lưu trữ dữ liệu thô về sản phẩm, categories, và warehouses

#### **Dữ liệu thu thập**

- **Product information**: ID, tên, mô tả, giá, SKU
- **Category data**: Danh mục sản phẩm, nhân viên phụ trách
- **Inventory data**: Số lượng tồn kho, warehouse
- **Pricing data**: Giá gốc, giá bán, chiết khấu

#### **API Endpoints sử dụng**

- `/products` - Danh sách sản phẩm
- `/categories` - Danh mục sản phẩm
- `/warehouses` - Thông tin kho hàng

#### **Schema dữ liệu**

```sql
-- Bảng products_raw
product_id, name, description, sku,
min_price, max_price, category_ids,
created_at, updated_at

-- Bảng categories_raw
category_id, category_name, parent_id,
created_at, updated_at

-- Bảng warehouses_raw
warehouse_id, warehouse_name, address,
created_at, updated_at
```

---

### **5. Shop.ipynb - Thu thập Dữ liệu Cửa hàng**

#### **Mục đích**

- Thu thập thông tin cửa hàng và cấu hình hệ thống
- Lưu trữ metadata về shop và settings

#### **Dữ liệu thu thập**

- **Shop information**: ID, tên, địa chỉ, liên hệ
- **Settings data**: Cấu hình hệ thống, preferences
- **User data**: Thông tin người dùng, quyền hạn
- **System data**: Metadata về hệ thống

#### **API Endpoints sử dụng**

- `/shop` - Thông tin cửa hàng
- `/users` - Danh sách người dùng
- `/settings` - Cấu hình hệ thống

#### **Schema dữ liệu**

```sql
-- Bảng shop_raw
shop_id, shop_name, address, phone, email,
created_at, updated_at, status

-- Bảng users_raw
user_id, username, email, role, permissions,
created_at, updated_at, is_active

-- Bảng settings_raw
setting_id, key, value, description,
created_at, updated_at
```

---

## 🔧 **CÔNG NGHỆ VÀ CÔNG CỤ SỬ DỤNG**

### **API Integration**

- **Pancake POS API**: RESTful API để thu thập dữ liệu
- **Authentication**: API Key-based authentication
- **Rate Limiting**: Xử lý giới hạn request/giây
- **Error Handling**: Retry mechanism và error logging

### **Data Storage**

- **MySQL Database**: Lưu trữ dữ liệu thô
- **SQLAlchemy**: ORM để tương tác với database
- **Pandas**: Xử lý và chuyển đổi dữ liệu
- **JSON**: Format dữ liệu từ API

### **Data Processing**

- **Python**: Ngôn ngữ chính cho ETL
- **Requests**: HTTP client cho API calls
- **DateTime**: Xử lý timestamp và timezone
- **Environment Variables**: Quản lý configuration

---

## **BẢO MẬT VÀ QUẢN LÝ**

### **API Security**

- **API Key Protection**: Lưu trữ trong environment variables
- **Rate Limiting**: Tuân thủ giới hạn API
- **Error Handling**: Xử lý lỗi và retry logic
- **Data Validation**: Kiểm tra tính hợp lệ của dữ liệu

### **Database Security**

- **Connection Security**: Sử dụng SSL cho database connection
- **Access Control**: Phân quyền truy cập database
- **Data Backup**: Backup định kỳ dữ liệu
- **Audit Logging**: Ghi log các hoạt động

---

## **CHẤT LƯỢNG DỮ LIỆU**

### **Data Quality Checks**

- **Completeness**: Kiểm tra dữ liệu thiếu
- **Consistency**: Đảm bảo tính nhất quán
- **Accuracy**: Xác thực độ chính xác
- **Timeliness**: Kiểm tra tính cập nhật

### **Monitoring**

- **Data Volume**: Theo dõi khối lượng dữ liệu
- **API Performance**: Giám sát hiệu suất API
- **Error Rate**: Theo dõi tỷ lệ lỗi
- **Data Freshness**: Kiểm tra độ mới của dữ liệu

---

*Tầng Bronze là nền tảng của toàn bộ hệ thống analytics. Dữ liệu ở đây được giữ nguyên trạng thái thô để đảm bảo tính toàn vẹn và khả năng truy xuất nguồn gốc.*
