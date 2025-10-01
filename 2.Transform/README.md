## 🛠 Workflow chuẩn (Bronze → Silver)

### **1. Extract dữ liệu từ Bronze**

* Đọc từ bảng `*_raw` (Bronze), trong đó thường có:

  * `id` (internal id trong Bronze).
  * `raw_json` (payload gốc từ API Pancake).
  * `_ingested_at` (timestamp ETL từ API về Bronze).
* Mục tiêu: đảm bảo **dữ liệu thô gốc** luôn còn nguyên, không chỉnh sửa.

---

### **2. Parse & Flatten JSON**

* Parse `raw_json` thành dict.
* Flatten nested fields (ví dụ `shop_customer_addresses`, `order_items`, `payments`).
* Chọn các **field quan trọng** theo business requirement (không lấy hết, chỉ những gì cần thiết).
* Mapping tên cột → chuẩn hoá (snake_case).

---

### **3. Chuẩn hoá dữ liệu (Cleaning & Standardizing)**

* **Datetime**: convert sang `datetime64` chuẩn (`inserted_at`, `updated_at`, …).
* **Numeric**: ép kiểu số (`order_count`, `purchased_amount`).
* **Boolean**: convert `true/false` sang `TINYINT(1)` hoặc `BOOLEAN`.
* **List/Array**: flatten thành string join hoặc tạo bảng phụ (nếu nhiều giá trị).
* **Text**: trim khoảng trắng, lowercase cho field như `gender`, `status`.

---

### **4. Data Quality Check**

* **Null check**: đếm % null mỗi cột → quyết định drop/giữ.
* **Duplicate check**: check duplicate theo primary key tự nhiên (ví dụ `customer_id`, `order_id`).
* **Referential integrity**: với bảng fact (Orders), check xem khóa ngoại (customer_id, product_id) có tồn tại trong dimension không.

---

### **5. Enrich / Standardize**

* Thêm cột lineage:

  * `bronze_id` (id của record ở Bronze, để trace ngược).
  * `_ingested_at` (thời điểm ETL).
* Mapping/chuẩn hoá value:

  * Gender: `male/female/nam/nữ` → `M/F`.
  * Order status: map về 1 set chuẩn (`pending`, `completed`, `canceled`).
  * Province ID → join với bảng provinces để ra tên tỉnh.

---

### **6. Load vào Silver**

* Load dữ liệu đã làm sạch vào bảng `*_clean` ở schema Silver.
* Dùng `to_sql` hoặc batch insert.
* Nếu bảng lớn (Orders, Order_Items) → incremental load (chỉ load record mới/updated).

---

### **7. Sinh Data Dictionary tự động**

* Tạo bảng metadata mô tả:

  * column name
  * data type
  * null %
  * unique count
  * sample value
* Lưu lại cho Data Governance & dễ đối chiếu với business.

---

## 📌 Tóm lại

Workflow chung Silver gồm:
**(Extract từ Bronze → Parse JSON → Clean & Standardize → DQ Check → Enrich → Load Silver → Generate Data Dictionary)**