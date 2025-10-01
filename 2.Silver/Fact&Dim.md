## 1️⃣ Lý thuyết Fact Table và Dimension Table

* **Fact Table** (bảng sự kiện):

  * Lưu trữ **dữ liệu giao dịch hoặc sự kiện** (Orders, Order Items, Payments).
  * Gồm các **số liệu định lượng** (measures) có thể cộng dồn được: doanh thu, số lượng, chiết khấu, phí ship…
  * Có **foreign key** tham chiếu đến các bảng dimension.
  * Dùng trong phân tích để tính toán KPI (doanh thu, số đơn hàng, số khách hàng mới…).

* **Dimension Table** (bảng chiều):

  * Lưu thông tin mô tả (descriptive attributes) giúp phân loại, lọc, nhóm dữ liệu.
  * Ví dụ: thông tin khách hàng (giới tính, địa chỉ), sản phẩm (tên, loại, thương hiệu), page bán hàng, kho hàng…
  * Không có số liệu đo lường, nhưng cho phép đặt ngữ cảnh cho fact.
  * Dùng trong phân tích để **slice & dice** (chẻ dữ liệu theo nhiều góc nhìn: theo khách hàng, theo page, theo thời gian, theo sản phẩm…).

👉 **Kết hợp**: Fact là "cái gì đã xảy ra", Dimension là "ai, ở đâu, khi nào, bằng cách nào".

---

## 2️⃣ Vì sao chỉ thiết kế các bảng như sơ đồ của bạn

* **Giữ tối giản, tập trung**:
  → Chỉ lấy những bảng thực sự phục vụ phân tích: Orders, Order Items, Customers, Products, Shops, Pages, Warehouses, Shipping Address.
  → Những bảng phụ (tags, status_history, partner_info…) có giá trị kỹ thuật nhưng **ít dùng trong phân tích** → bỏ đi để tránh dư thừa.

* **Đúng chuẩn Star Schema**:

  * Một fact lớn (Orders) ở giữa.
  * Một fact phụ (Order Items) kết nối với Products.
  * Các dimension bao quanh cung cấp ngữ cảnh (Customers, Products, Pages, Warehouses, Shops, Shipping Addresses).
  * Thiết kế này **cân bằng**: dễ hiểu, dễ join, truy vấn nhanh.

* **Thực tế nghiệp vụ**:

  * Khi phân tích doanh thu, hiệu quả bán hàng, hành vi khách hàng, chỉ cần các dimension cơ bản trên.
  * Tránh việc phân tích "quá chi tiết" (ví dụ từng lần update status, từng lần gọi API) → làm data warehouse phình to nhưng không mang thêm insight.

