# 📊 Winner Group Analytics – Project Structure

## 🗂️ Cấu trúc thư mục dự án

```
.
├── 1.Extract/                # Tầng Bronze - Extract dữ liệu thô từ API Pancake
│   ├── Customers.ipynb       # Notebook lấy dữ liệu khách hàng
│   ├── Orders.ipynb          # Notebook lấy dữ liệu đơn hàng
│   ├── Products.ipynb        # Notebook lấy dữ liệu sản phẩm
│   └── Shop.ipynb            # Notebook lấy dữ liệu shop
│
├── 2.Transform/              # Tầng Silver - Làm sạch & chuẩn hóa dữ liệu
│   ├── Customers.ipynb       # Transform bảng customers
│   ├── Orders.ipynb          # Transform bảng orders + order_items
│   ├── Products.ipynb        # Transform bảng products + product_variations
│   └── Shop.ipynb            # Transform bảng shop + pages
│
├── 5.Reports/                # Phân tích & báo cáo
│   ├── Data_Dictionary.xlsx  # Từ điển dữ liệu chi tiết (schema, mô tả cột)
│   └── Document.docx         # Tài liệu mô tả dự án, kết quả phân tích
│
├── img/                      # Hình ảnh minh họa
│   ├── Data.png              # Kiến trúc pipeline Bronze → Silver → Gold
│   └── ERD.png               # ERD của Silver Layer (bảng & quan hệ)
│
├── .gitattributes
├── .gitignore
├── LICENSE
├── README.md                 # Giới thiệu & hướng dẫn dự án
└── requirements.txt          # Thư viện Python cần thiết
```
