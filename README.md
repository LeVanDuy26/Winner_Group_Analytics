# 📊 Winner Group Analytics Project

## 1. Giới thiệu

Dự án **Winner Group Analytics** được xây dựng nhằm phân tích dữ liệu bán hàng từ hệ thống **Pancake POS** của Winner Group (kinh doanh thời trang, bán hàng qua gần 70 fanpage Facebook).
Hệ thống dữ liệu được thiết kế theo mô hình **Data Warehouse (Bronze → Silver → Gold)** và sử dụng để tạo các **Dashboard phân tích đa chiều** (Power BI / Tableau).

---

## 2. Mục tiêu chính

* Thu thập dữ liệu từ **Pancake API** và lưu trữ vào MySQL.
* Thiết kế hệ thống **ETL pipeline**: Bronze (raw) → Silver (clean/standardized) → Gold (data mart).
* Xây dựng **Star Schema** gồm Fact Tables và Dimension Tables.
* Phát triển các **dashboard phân tích**:

  1. Executive Dashboard (Tổng quan quản lý)
  2. Sales Performance Dashboard (Hiệu quả bán hàng)
  3. Operations Dashboard (Vận hành & Kho hàng)
  4. Customer Dashboard (Khách hàng)
  5. Product Dashboard (Sản phẩm)

---

## 3. Kiến trúc dữ liệu
```
WINNER_GROUP_ANALYTICS/
│
├── .venv/                     # Môi trường ảo Python (cài dependencies riêng cho dự án)
│
├── 1.Broze/                   # Tầng Bronze: dữ liệu gốc (raw) từ API Pancake POS
│   ├── 0_TestPancakeAPI.ipynb # Notebook test API, kết nối và tải dữ liệu
│   ├── Customers.ipynb        # Load dữ liệu khách hàng (Customers) từ API
│   ├── Orders.ipynb           # Load dữ liệu đơn hàng (Orders)
│   ├── Products.ipynb         # Load dữ liệu sản phẩm (Products)
│   └── Shop.ipynb             # Load thông tin shop
│
├── 2.Silver/                  # Tầng Silver: dữ liệu đã làm sạch & chuẩn hóa
│   ├── Customers.ipynb        # Làm sạch dữ liệu khách hàng
│   ├── Orders.ipynb           # Chuẩn hóa bảng Orders
│   ├── Products.ipynb         # Chuẩn hóa bảng Products
│   ├── Shop.ipynb             # Chuẩn hóa thông tin shop
│   ├── Fact&Dim.md            # Thiết kế Fact Table & Dimension sơ bộ
│   └── README.md              # Giải thích cách xử lý dữ liệu ở tầng Silver
│
├── 3.Gold/                    # Tầng Gold: Data Mart (Star Schema)
│   ├── gold_dim_customers.ipynb   # Dimension Customers
│   ├── gold_dim_date.ipynb        # Dimension Date (calendar)
│   ├── gold_dim_pages.ipynb       # Dimension Pages (fanpage bán hàng)
│   ├── gold_dim_product.ipynb     # Dimension Product
│   ├── gold_dim_shop.ipynb        # Dimension Shop
│   ├── gold_fact_order.ipynb      # Fact Orders (tổng quan đơn hàng)
│   └── gold_fact_orderItems.ipynb # Fact Order Items (chi tiết từng sản phẩm trong đơn hàng)
│
├── 4.Dashboards/              # Dashboard: kết nối trực tiếp từ Gold
│   └── test.ipynb             # Notebook thử nghiệm visualization/truy vấn dữ liệu
│
├── 5.Reports/                 # Báo cáo & tài liệu (Markdown, PDF, hình minh họa)
│
├── img/                       # Lưu hình ảnh, sơ đồ (ERD, kiến trúc, star schema…)
│
└── SQL/                       # Thư mục chứa file SQL scripts (DDL, phân quyền, role, data dictionary)
```