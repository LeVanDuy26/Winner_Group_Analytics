# Winner Group Analytics Project

## Tổng quan dự án

**Winner Group Analytics** là hệ thống phân tích dữ liệu bán hàng toàn diện cho Winner Group - một doanh nghiệp kinh doanh thời trang với mô hình bán hàng qua mạng xã hội (gần 70 fanpage Facebook). Dự án sử dụng dữ liệu từ **Pancake POS API** để xây dựng hệ thống Data Warehouse theo mô hình **Bronze → Silver → Gold** nhằm hỗ trợ ra quyết định kinh doanh thông qua các dashboard phân tích chuyên sâu.

## Mục tiêu chính

### 1. Thu thập và lưu trữ dữ liệu
- Kết nối và thu thập dữ liệu từ Pancake POS API
- Lưu trữ dữ liệu raw vào MySQL Database (Bronze Layer)
- Đảm bảo tính toàn vẹn và đầy đủ của dữ liệu

### 2. Xây dựng ETL Pipeline
- **Bronze Layer**: Lưu trữ dữ liệu raw từ API
- **Silver Layer**: Làm sạch, chuẩn hóa và enrich dữ liệu
- **Gold Layer**: Tạo Data Mart với Star Schema cho phân tích

### 3. Phân tích và báo cáo
- Xây dựng các dashboard phân tích đa chiều
- Phân tích hành vi khách hàng (RFM Analysis)
- Báo cáo hiệu suất kinh doanh theo thời gian thực

## Kiến trúc hệ thống

### Data Architecture (Bronze → Silver → Gold)

![Data Architecture](img/1.DataArchitecture.png)

```
WINNER_GROUP_ANALYTICS/
│
├── 1.Bronze/                     # Tầng Bronze: Dữ liệu raw từ API
│   ├── 0_TestPancakeAPI.ipynb    # Test API connection và page_size limits
│   ├── Customers.ipynb           # Extract dữ liệu khách hàng từ API
│   ├── Orders.ipynb              # Extract dữ liệu đơn hàng từ API
│   ├── Products.ipynb            # Extract dữ liệu sản phẩm từ API
│   └── Shop.ipynb                # Extract thông tin shop từ API
│
├── 2.Silver/                     # Tầng Silver: Dữ liệu đã làm sạch
│   ├── Customers.ipynb           # Transform customers_raw → dim_customers
│   ├── Orders.ipynb              # Transform orders_raw → fact_orders + dim_*
│   ├── Products.ipynb            # Transform products_raw → dim_products
│   ├── Shop.ipynb                # Transform shops_raw → dim_shops
│   ├── Fact&Dim.md               # Thiết kế Fact & Dimension tables
│   └── README.md                 # Hướng dẫn xử lý dữ liệu Silver
│
├── 3.Gold/                       # Tầng Gold: Data Mart (Star Schema)
│   ├── gold_dim_customers.ipynb  # Dimension Customers với RFM Analysis
│   ├── gold_dim_date.ipynb       # Dimension Date (Calendar table)
│   ├── gold_dim_pages.ipynb      # Dimension Pages (Facebook fanpages)
│   ├── gold_dim_product.ipynb    # Dimension Products với categories
│   ├── gold_dim_shop.ipynb       # Dimension Shops
│   ├── gold_fact_order.ipynb     # Fact Orders (tổng quan đơn hàng)
│   └── gold_fact_orderItems.ipynb # Fact Order Items (chi tiết sản phẩm)
│
├── 4.Dashboards/                 # Dashboard và Visualization
│   └── EDA_Winner_Group_Discovery.ipynb # Exploratory Data Analysis
│
├── 5.Reports/                    # Báo cáo và tài liệu
│   ├── Data_Dictionary.xlsx      # Data Dictionary
│   └── Roadmap.xlsx              # Project Roadmap
│
├── 6.Docs/                       # Tài liệu kỹ thuật
│   └── DARoadMap.md              # Data Analyst Roadmap chi tiết
│
├── img/                          # Hình ảnh và sơ đồ
│   ├── 1.DataArchitecture.png    # Sơ đồ kiến trúc dữ liệu
│   ├── 2.DataLineage.png         # Sơ đồ data lineage
│   ├── 3.Dataflow.png            # Sơ đồ luồng dữ liệu
│   └── 4.StarSchema.png          # Sơ đồ Star Schema
│
├── SQL/                          # SQL Scripts
│   ├── RBAC.sql                  # Role-Based Access Control
│   └── Guide_RBAC.sql            # Hướng dẫn RBAC
│
├── requirements.txt              # Python dependencies
├── README.md                     # Tài liệu dự án (file này)
└── LICENSE                       # Giấy phép sử dụng
```

## Công nghệ sử dụng

### Backend & Database
- **Python 3.13+**: Ngôn ngữ lập trình chính
- **MySQL**: Database chính để lưu trữ dữ liệu
- **SQLAlchemy**: ORM để tương tác với database
- **PyMySQL**: MySQL driver cho Python

### Data Processing
- **Pandas**: Xử lý và phân tích dữ liệu
- **NumPy**: Tính toán số học
- **Python-dotenv**: Quản lý biến môi trường

### Visualization & Analysis
- **Matplotlib**: Vẽ biểu đồ cơ bản
- **Seaborn**: Vẽ biểu đồ thống kê
- **Plotly**: Vẽ biểu đồ tương tác
- **Jupyter Notebook**: Môi trường phát triển
