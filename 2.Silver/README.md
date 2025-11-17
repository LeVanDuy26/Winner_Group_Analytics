## **TỔNG HỢP TẦNG SILVER**

### **Các bảng đã tạo trong Silver:**

#### **BẢNG CHIỀU - DIMENSION TABLES (7 bảng):**

1. **`dim_customers`** - Thông tin khách hàng (25 trường)
2. **`dim_products`** - Thông tin sản phẩm (23 trường)
3. **`dim_shops`** - Thông tin shop (4 trường)
4. **`dim_order_pages`** - Thông tin page bán hàng (4 trường)
5. **`dim_order_warehouses`** - Thông tin kho hàng (6 trường)
6. **`dim_order_shipping`** - Thông tin giao hàng (6 trường)
7. **`dim_order_payments`** - Thông tin thanh toán (6 trường)

#### **BẢNG SỰ KIỆN - FACT TABLES (2 bảng):**

1. **`fact_orders`** - Đơn hàng chính (25 trường)
2. **`fact_order_items`** - Chi tiết sản phẩm trong đơn (10 trường)

---

## **THIẾT KẾ STAR SCHEMA**

#### **FACT_ORDERS (Trung tâm):**

- **Khóa chính**: `order_id`
- **Khóa ngoại**:
  - `customer_id` → `dim_customers` (khách hàng)
  - `page_id` → `dim_order_pages` (trang bán)
  - `warehouse_id` → `dim_order_warehouses` (kho hàng)
  - `shipping_id` → `dim_order_shipping` (thông tin giao)
  - `payment_id` → `dim_order_payments` (thông tin thanh)
  - `shop_id` → `dim_shops` (cửa hàng)

#### **FACT_ORDER_ITEMS (Bảng sự kiện phụ):**

- **Khóa chính**: `order_item_id`
- **Khóa ngoại**:
  - `order_id` → `fact_orders` (đơn hàng)
  - `product_id` → `dim_products` (sản phẩm)

---

## **TỔNG QUAN DỮ LIỆU**

| Bảng                    | Loại | Số bản ghi | Trường khóa                               |
| ------------------------ | ----- | ------------ | -------------------------------------------- |
| `fact_orders`          | Fact  | 40,236       | order_id, customer_id, page_id, warehouse_id |
| `fact_order_items`     | Fact  | ~40,000+     | order_item_id, order_id, product_id          |
| `dim_customers`        | Dim   | ~36,000      | customer_id                                  |
| `dim_products`         | Dim   | 37           | product_id                                   |
| `dim_shops`            | Dim   | 1            | shop_id                                      |
| `dim_order_pages`      | Dim   | ~40,236      | page_id                                      |
| `dim_order_warehouses` | Dim   | ~40,236      | warehouse_id                                 |
| `dim_order_shipping`   | Dim   | ~40,236      | shipping_id                                  |
| `dim_order_payments`   | Dim   | ~40,236      | payment_id                                   |

---

## **KHẢ NĂNG PHÂN TÍCH NGHIỆP VỤ**

### **Phân tích KPI:**

- **Phân tích doanh thu**: Tổng doanh số, doanh thu theo thời kỳ, khách hàng, sản phẩm
- **Phân tích đơn hàng**: Số lượng đơn, giá trị đơn trung bình, tần suất mua
- **Phân tích khách hàng**: Phân khúc khách hàng, phân tích RFM
- **Hiệu suất sản phẩm**: Sản phẩm bán chạy/kém, phân tích danh mục
- **Phân tích địa lý**: Bán hàng theo khu vực giao, hiệu suất kho

### **Phân tích đa chiều:**

- **Theo khách hàng**: Nhân khẩu học, mẫu hành vi
- **Theo sản phẩm**: Danh mục, khoảng giá, hiệu suất
- **Theo thời gian**: Xu hướng hàng ngày, hàng tháng, theo mùa
- **Theo địa lý**: Hiệu suất khu vực giao, hiệu quả kho
- **Theo kênh**: Hiệu suất trang, phương thức thanh toán

---

## **BƯỚC TIẾP THEO - TẦNG GOLD**

Bây giờ chúng ta có thể:

1. **Chuyển đổi Silver → Gold** với logic nghiệp vụ
2. **Tạo bảng tổng hợp** cho các KPI cụ thể
3. **Xây dựng dashboard** từ tầng Gold
4. **Triển khai data mart** cho các đơn vị kinh doanh khác nhau

**Tầng Silver đã hoàn thành** với Star Schema chuẩn, sẵn sàng cho việc chuyển đổi Gold! 🎉
