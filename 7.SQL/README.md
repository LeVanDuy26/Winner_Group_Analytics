# Winner Group Analytics - Bộ Dữ Liệu Luyện Tập SQL

## 🏢 Tổng Quan Công Ty

**Winner Group** là một doanh nghiệp kinh doanh thời trang chuyên bán quần áo với mô hình bán hàng chủ yếu qua **mạng xã hội Facebook**. Công ty vận hành gần **70 fanpage Facebook** để tiếp cận khách hàng và thực hiện giao dịch.

### Mô Hình Kinh Doanh
- **Kênh bán hàng chính**: Facebook fanpages (social commerce)
- **Sản phẩm**: Quần áo thời trang (áo, quần, váy, phụ kiện)
- **Đối tượng khách hàng**: Người tiêu dùng Việt Nam
- **Hệ thống POS**: Sử dụng Pancake POS để quản lý đơn hàng và kho

## 📊 Cấu Trúc Dữ Liệu

### Tầng Gold (Data Mart) - Dữ liệu đã chuẩn hóa

#### **Fact Tables (Bảng Sự Kiện)**
- **`gold_fact_orders`**: Thông tin đơn hàng chính
  - Doanh thu, số lượng, trạng thái đơn hàng
  - Thông tin khách hàng, fanpage, thời gian
  - Phí vận chuyển, chiết khấu

- **`gold_fact_order_items`**: Chi tiết sản phẩm trong đơn hàng
  - Sản phẩm cụ thể, số lượng, giá
  - Doanh thu từng dòng sản phẩm

#### **Dimension Tables (Bảng Chiều)**
- **`gold_dim_customers`**: Thông tin khách hàng
  - Thông tin cá nhân, địa chỉ
  - Phân tích RFM (Recency, Frequency, Monetary)
  - Phân loại VIP/Thường

- **`gold_dim_products`**: Thông tin sản phẩm
  - Tên, danh mục, thương hiệu
  - Phân loại theo mùa, loại sản phẩm

- **`gold_dim_pages`**: Thông tin fanpage Facebook
  - Tên fanpage, loại trang
  - Hiệu quả bán hàng theo kênh

- **`gold_dim_shop`**: Thông tin cửa hàng/kho
  - Địa điểm, loại kho
  - Quản lý inventory

- **`gold_dim_date`**: Bảng lịch (Calendar table)
  - Ngày, tuần, tháng, quý, năm
  - Thông tin ngày lễ, mùa

## 🎯 Các Phân Tích Có Thể Thực Hiện

### 1. **Phân Tích Kinh Doanh**
- Doanh thu theo thời gian (ngày, tuần, tháng)
- Hiệu quả bán hàng theo fanpage
- Phân tích mùa vụ và xu hướng

### 2. **Phân Tích Khách Hàng**
- Phân tích RFM (khách hàng VIP, tiềm năng, có nguy cơ rời bỏ)
- Hành vi mua hàng theo địa lý
- Customer Lifetime Value

### 3. **Phân Tích Sản Phẩm**
- Sản phẩm bán chạy nhất
- Phân tích ABC (sản phẩm chính, phụ, ít bán)
- Hiệu quả theo danh mục

### 4. **Phân Tích Vận Hành**
- Trạng thái đơn hàng và thời gian xử lý
- Hiệu quả kho hàng
- Chi phí vận chuyển

## 📈 Quy Mô Dữ Liệu (Ước Tính)
- **Đơn hàng**: ~40,000 đơn hàng
- **Khách hàng**: ~20,000 khách hàng
- **Sản phẩm**: ~1,000 sản phẩm
- **Fanpage**: ~70 fanpage Facebook
- **Thời gian**: Dữ liệu trong vài tháng gần đây

## 🔍 Đặc Điểm Dữ Liệu

### **Điểm Mạnh**
- Dữ liệu thực tế từ hoạt động kinh doanh
- Cấu trúc Star Schema chuẩn
- Đầy đủ thông tin cho phân tích đa chiều
- Dữ liệu đã được làm sạch và chuẩn hóa

### **Lưu Ý Khi Phân Tích**
- Mô hình kinh doanh B2C qua social media
- Khách hàng chủ yếu là người tiêu dùng cá nhân
- Sản phẩm thời trang có tính mùa vụ
- Đơn hàng có giá trị trung bình thấp, tần suất mua cao

## 🎓 Mục Đích Luyện Tập SQL

Bộ dữ liệu này phù hợp để luyện tập:
- **SQL cơ bản**: SELECT, WHERE, GROUP BY, ORDER BY
- **SQL nâng cao**: Window functions, CTE, Subqueries
- **Phân tích dữ liệu**: Aggregations, Pivot tables
- **Business Intelligence**: KPI calculations, Trend analysis
- **Data modeling**: Star schema, Fact-Dimension relationships

## 📚 Tài Liệu Tham Khảo

- **Data Dictionary**: `5.Reports/Data_Dictionary.xlsx`
- **Star Schema**: `img/4.StarSchema.png`
- **EDA Analysis**: `4.Dashboards/EDA_Winner_Group_Discovery.ipynb`
- **Project Roadmap**: `6.Docs/DARoadMap.md`

---

*Bộ dữ liệu này được xây dựng từ dữ liệu thực tế của Winner Group thông qua Pancake POS API, phục vụ mục đích học tập và nghiên cứu.*
