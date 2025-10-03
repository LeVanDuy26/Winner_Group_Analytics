## 🎯 **GIAI ĐOẠN 1: PHÂN TÍCH & INSIGHTS (4-6 tuần)**

## 📊 **A. EXPLORATORY DATA ANALYSIS (EDA) - 2 TUẦN**

### **TUẦN 1: KHÁM PHÁ DỮ LIỆU CƠ BẢN**

#### **Ngày 1-2: Hiểu Cấu Trúc Dữ Liệu**

**Mục tiêu**: Nắm vững cấu trúc và chất lượng dữ liệu

**Hành động cụ thể**:

1. **Tạo Data Dictionary chi tiết**
```sql
-- Tạo bảng metadata cho từng bảng
SELECT 
    'gold_fact_orders' as table_name,
    column_name,
    data_type,
    is_nullable,
    column_default,
    column_comment
FROM information_schema.columns 
WHERE table_schema = 'winner_gold' 
AND table_name = 'gold_fact_orders';
```

2. **Kiểm tra Data Quality**
```sql
-- Kiểm tra tính toàn vẹn dữ liệu
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT order_id) as unique_orders,
    COUNT(DISTINCT customer_id) as unique_customers,
    MIN(inserted_at) as earliest_date,
    MAX(inserted_at) as latest_date,
    SUM(CASE WHEN gross_revenue < 0 THEN 1 ELSE 0 END) as negative_revenue_count
FROM gold_fact_orders;
```

3. **Phân tích Missing Values**
```python
# Tạo báo cáo missing values cho tất cả bảng
def kiem_tra_gia_tri_thieu(df, ten_bang):
    missing_report = []
    for col in df.columns:
        missing_count = df[col].isnull().sum()
        missing_pct = (missing_count / len(df)) * 100
        missing_report.append({
            'Bảng': ten_bang,
            'Cột': col,
            'Số_Giá_Trị_Thiếu': missing_count,
            'Tỷ_Lệ_Thiếu_%': round(missing_pct, 2)
        })
    return pd.DataFrame(missing_report)
```

#### **Ngày 3-4: Phân Tích Tổng Quan Kinh Doanh**

**Mục tiêu**: Hiểu quy mô và xu hướng kinh doanh

**Hành động cụ thể**:

1. **Tính Toán KPI Cơ Bản**
```sql
-- Tạo bảng tổng quan kinh doanh
WITH business_overview AS (
    SELECT 
        COUNT(DISTINCT o.order_id) as tong_don_hang,
        COUNT(DISTINCT o.customer_id) as tong_khach_hang,
        COUNT(DISTINCT oi.product_id) as tong_san_pham,
        COUNT(DISTINCT o.page_id) as tong_fanpage,
        SUM(o.gross_revenue) as tong_doanh_thu,
        SUM(o.net_revenue) as doanh_thu_rong,
        AVG(o.gross_revenue) as gia_tri_don_hang_tb,
        SUM(o.total_quantity) as tong_so_luong_ban
    FROM gold_fact_orders o
    LEFT JOIN gold_fact_order_items oi ON o.order_id = oi.order_id
)
SELECT * FROM business_overview;
```

2. **Phân Tích Xu Hướng Thời Gian**
```python
# Tạo biểu đồ xu hướng doanh thu theo thời gian
def phan_tich_xu_huong_thoi_gian():
    # Doanh thu theo ngày
    doanh_thu_ngay = df_orders.groupby('ngay_don_hang')['gross_revenue'].sum()
    
    # Doanh thu theo tuần
    df_orders['tuan'] = df_orders['inserted_at'].dt.isocalendar().week
    doanh_thu_tuan = df_orders.groupby(['nam', 'tuan'])['gross_revenue'].sum()
    
    # Doanh thu theo tháng
    doanh_thu_thang = df_orders.groupby('thang_don_hang')['gross_revenue'].sum()
    
    # Tạo visualization
    fig = make_subplots(rows=3, cols=1, 
                       subplot_titles=['Doanh Thu Theo Ngày', 'Doanh Thu Theo Tuần', 'Doanh Thu Theo Tháng'])
    # ... code visualization
```

3. **Phân Tích Mùa Vụ**
```python
# Phân tích patterns theo mùa
def phan_tich_mua_vu():
    # Thêm cột mùa
    df_orders['mua'] = df_orders['inserted_at'].dt.month.map({
        1: 'Đông', 2: 'Đông', 3: 'Xuân', 4: 'Xuân', 5: 'Xuân', 6: 'Hè',
        7: 'Hè', 8: 'Hè', 9: 'Thu', 10: 'Thu', 11: 'Thu', 12: 'Đông'
    })
    
    # Phân tích doanh thu theo mùa
    doanh_thu_mua = df_orders.groupby('mua')['gross_revenue'].sum()
    
    # Phân tích theo tháng
    doanh_thu_thang = df_orders.groupby(df_orders['inserted_at'].dt.month)['gross_revenue'].sum()
```

#### **Ngày 5-7: Phân Tích Khách Hàng**

**Mục tiêu**: Hiểu hành vi và giá trị khách hàng

**Hành động cụ thể**:

1. **Phân Tích RFM Chi Tiết**
```python
def phan_tich_rfm_chi_tiet():
    # Tính toán RFM scores
    df_customers['r_score'] = pd.qcut(df_customers['recency_days'], 5, labels=[5,4,3,2,1])
    df_customers['f_score'] = pd.qcut(df_customers['frequency'], 5, labels=[1,2,3,4,5])
    df_customers['m_score'] = pd.qcut(df_customers['monetary'], 5, labels=[1,2,3,4,5])
    
    # Tạo RFM segments
    df_customers['rfm_segment'] = (
        df_customers['r_score'].astype(str) + 
        df_customers['f_score'].astype(str) + 
        df_customers['m_score'].astype(str)
    )
    
    # Phân loại khách hàng
    def phan_loai_khach_hang(rfm):
        if rfm in ['555', '554', '544', '545', '454', '455', '445']:
            return 'Champions'
        elif rfm in ['543', '444', '435', '355', '354', '345', '344', '335']:
            return 'Loyal Customers'
        elif rfm in ['512', '511', '422', '421', '412', '411', '311']:
            return 'New Customers'
        elif rfm in ['155', '154', '144', '214', '215', '115', '114', '113']:
            return 'Promising'
        elif rfm in ['255', '254', '245', '244', '253', '252', '243', '242', '235', '234', '225', '224', '153', '152', '145', '143', '142', '135', '134', '133', '125', '124']:
            return 'Potential Loyalists'
        elif rfm in ['332', '322', '231', '241', '251', '233', '232', '223', '222', '132', '123', '122', '212', '211']:
            return 'Need Attention'
        elif rfm in ['111', '112', '121', '131', '141', '151']:
            return 'About to Sleep'
        else:
            return 'Cannot Lose Them'
    
    df_customers['phan_loai_khach_hang'] = df_customers['rfm_segment'].apply(phan_loai_khach_hang)
```

2. **Phân Tích Customer Lifetime Value**
```python
def tinh_customer_lifetime_value():
    # Tính CLV cho từng khách hàng
    clv_analysis = df_customers.groupby('customer_id').agg({
        'monetary': 'sum',
        'frequency': 'sum',
        'recency_days': 'min'
    }).reset_index()
    
    # Tính CLV dự đoán (đơn giản)
    clv_analysis['clv_du_doan'] = (
        clv_analysis['monetary'] * 
        (365 / clv_analysis['recency_days']) * 
        (clv_analysis['frequency'] / 12)
    )
    
    # Phân loại khách hàng theo CLV
    clv_analysis['clv_segment'] = pd.qcut(
        clv_analysis['clv_du_doan'], 
        4, 
        labels=['Thấp', 'Trung Bình', 'Cao', 'Rất Cao']
    )
```

### **TUẦN 2: PHÂN TÍCH CHUYÊN SÂU**

#### **Ngày 8-9: Phân Tích Sản Phẩm**

**Mục tiêu**: Hiểu hiệu quả và tiềm năng sản phẩm

**Hành động cụ thể**:

1. **Phân Tích Hiệu Quả Sản Phẩm**
```sql
-- Tạo bảng phân tích sản phẩm
WITH product_analysis AS (
    SELECT 
        p.product_id,
        p.name as ten_san_pham,
        p.main_category as danh_muc,
        COUNT(DISTINCT oi.order_id) as so_don_hang,
        SUM(oi.quantity) as tong_so_luong_ban,
        SUM(oi.line_revenue) as tong_doanh_thu,
        AVG(oi.line_revenue) as gia_tri_trung_binh,
        COUNT(DISTINCT o.customer_id) as so_khach_hang_mua
    FROM gold_dim_products p
    LEFT JOIN gold_fact_order_items oi ON p.product_id = oi.product_id
    LEFT JOIN gold_fact_orders o ON oi.order_id = o.order_id
    WHERE p.is_dummy = 0
    GROUP BY p.product_id, p.name, p.main_category
)
SELECT * FROM product_analysis
ORDER BY tong_doanh_thu DESC;
```

2. **Phân Tích ABC Sản Phẩm**
```python
def phan_tich_abc_san_pham():
    # Tính tỷ lệ đóng góp doanh thu
    product_revenue = df_order_items.groupby('product_id')['line_revenue'].sum().sort_values(ascending=False)
    product_revenue['ty_le_tich_luy'] = product_revenue.cumsum() / product_revenue.sum() * 100
    
    # Phân loại ABC
    def phan_loai_abc(ty_le):
        if ty_le <= 80:
            return 'A - Sản phẩm chính'
        elif ty_le <= 95:
            return 'B - Sản phẩm phụ'
        else:
            return 'C - Sản phẩm ít bán'
    
    product_revenue['phan_loai_abc'] = product_revenue['ty_le_tich_luy'].apply(phan_loai_abc)
```

#### **Ngày 10-11: Phân Tích Kênh Bán Hàng**

**Mục tiêu**: Hiểu hiệu quả các kênh bán hàng

**Hành động cụ thể**:

1. **Phân Tích Hiệu Quả Fanpage**
```sql
-- Phân tích chi tiết từng fanpage
WITH page_performance AS (
    SELECT 
        p.page_id,
        p.page_name,
        COUNT(DISTINCT o.order_id) as so_don_hang,
        SUM(o.gross_revenue) as tong_doanh_thu,
        AVG(o.gross_revenue) as gia_tri_don_hang_tb,
        COUNT(DISTINCT o.customer_id) as so_khach_hang,
        SUM(o.total_quantity) as tong_so_luong
    FROM gold_dim_pages p
    LEFT JOIN gold_fact_orders o ON p.page_id = o.page_id
    GROUP BY p.page_id, p.page_name
)
SELECT 
    *,
    RANK() OVER (ORDER BY tong_doanh_thu DESC) as xep_hang_doanh_thu,
    RANK() OVER (ORDER BY so_don_hang DESC) as xep_hang_don_hang
FROM page_performance
ORDER BY tong_doanh_thu DESC;
```

2. **Phân Tích Conversion Rate**
```python
def phan_tich_conversion_rate():
    # Tính conversion rate cho từng fanpage
    page_conversion = df_orders.groupby('page_id').agg({
        'order_id': 'count',
        'customer_id': 'nunique'
    }).reset_index()
    
    # Giả sử có dữ liệu về số lượng visitor (cần bổ sung từ DE)
    # page_conversion['conversion_rate'] = page_conversion['order_id'] / page_conversion['visitors'] * 100
```

#### **Ngày 12-14: Phân Tích Địa Lý & Thời Gian**

**Mục tiêu**: Hiểu patterns theo địa lý và thời gian

**Hành động cụ thể**:

1. **Phân Tích Địa Lý**
```python
def phan_tich_dia_ly():
    # Phân tích theo tỉnh thành
    dia_ly_analysis = df_customers.groupby('province_name').agg({
        'customer_id': 'count',
        'monetary': 'sum',
        'frequency': 'mean'
    }).reset_index()
    
    # Top 10 tỉnh thành có doanh thu cao nhất
    top_provinces = dia_ly_analysis.nlargest(10, 'monetary')
    
    # Tạo bản đồ nhiệt (nếu có dữ liệu tọa độ)
    # import folium
    # map_heat = folium.Map(location=[10.8231, 106.6297], zoom_start=6)
    # ... code tạo bản đồ
```

2. **Phân Tích Patterns Thời Gian**
```python
def phan_tich_patterns_thoi_gian():
    # Phân tích theo giờ trong ngày
    df_orders['gio'] = df_orders['inserted_at'].dt.hour
    doanh_thu_theo_gio = df_orders.groupby('gio')['gross_revenue'].sum()
    
    # Phân tích theo ngày trong tuần
    df_orders['ngay_trong_tuan'] = df_orders['inserted_at'].dt.day_name()
    doanh_thu_theo_ngay = df_orders.groupby('ngay_trong_tuan')['gross_revenue'].sum()
    
    # Phân tích theo tuần trong tháng
    df_orders['tuan_trong_thang'] = df_orders['inserted_at'].dt.day // 7 + 1
    doanh_thu_theo_tuan_thang = df_orders.groupby('tuan_trong_thang')['gross_revenue'].sum()
```

---

## 🧠 **B. BUSINESS INTELLIGENCE - 2 TUẦN**

### **TUẦN 3: PHÂN TÍCH CHIẾN LƯỢC**

#### **Ngày 15-16: Phân Tích Cạnh Tranh & Thị Trường**

**Mục tiêu**: Hiểu vị thế cạnh tranh và cơ hội thị trường

**Hành động cụ thể**:

1. **Benchmarking Nội Bộ**
```python
def benchmark_noi_bo():
    # So sánh hiệu quả giữa các fanpage
    page_benchmark = df_orders.groupby('page_id').agg({
        'gross_revenue': ['sum', 'mean', 'std'],
        'order_id': 'count',
        'customer_id': 'nunique'
    }).round(2)
    
    # Xác định best practices
    best_pages = page_benchmark.nlargest(5, ('gross_revenue', 'sum'))
    worst_pages = page_benchmark.nsmallest(5, ('gross_revenue', 'sum'))
    
    # Phân tích sự khác biệt
    return best_pages, worst_pages
```

2. **Phân Tích Market Share**
```python
def phan_tich_market_share():
    # Phân tích thị phần theo danh mục sản phẩm
    market_share = df_order_items.groupby('main_category').agg({
        'line_revenue': 'sum',
        'quantity': 'sum'
    }).reset_index()
    
    market_share['ty_le_doanh_thu'] = market_share['line_revenue'] / market_share['line_revenue'].sum() * 100
    market_share['ty_le_so_luong'] = market_share['quantity'] / market_share['quantity'].sum() * 100
    
    return market_share.sort_values('ty_le_doanh_thu', ascending=False)
```

#### **Ngày 17-18: Phân Tích Rủi Ro & Cơ Hội**

**Mục tiêu**: Xác định rủi ro và cơ hội tăng trưởng

**Hành động cụ thể**:

1. **Phân Tích Rủi Ro**
```python
def phan_tich_rui_ro():
    # Rủi ro khách hàng
    customer_risk = df_customers[df_customers['recency_days'] > 90].groupby('is_vip').agg({
        'customer_id': 'count',
        'monetary': 'sum'
    })
    
    # Rủi ro sản phẩm
    product_risk = df_order_items.groupby('product_id').agg({
        'quantity': 'sum',
        'line_revenue': 'sum'
    }).reset_index()
    
    # Sản phẩm có doanh thu giảm
    product_trend = df_order_items.groupby(['product_id', 'thang_don_hang']).agg({
        'line_revenue': 'sum'
    }).reset_index()
    
    # Tính tốc độ tăng trưởng
    product_growth = product_trend.groupby('product_id').apply(
        lambda x: x['line_revenue'].pct_change().mean()
    ).reset_index()
    product_growth.columns = ['product_id', 'toc_do_tang_truong']
    
    return customer_risk, product_risk, product_growth
```

2. **Phân Tích Cơ Hội**
```python
def phan_tich_co_hoi():
    # Cơ hội từ khách hàng tiềm năng
    potential_customers = df_customers[
        (df_customers['frequency'] >= 2) & 
        (df_customers['monetary'] < 500000)
    ]
    
    # Cơ hội từ sản phẩm underperforming
    underperforming_products = df_order_items.groupby('product_id').agg({
        'line_revenue': 'sum',
        'quantity': 'sum'
    }).reset_index()
    
    # Sản phẩm có tiềm năng nhưng chưa khai thác hết
    potential_products = underperforming_products[
        (underperforming_products['quantity'] > 10) & 
        (underperforming_products['line_revenue'] < 1000000)
    ]
    
    return potential_customers, potential_products
```

### **TUẦN 4: PHÂN TÍCH CHIẾN THUẬT**

#### **Ngày 19-20: Phân Tích Hiệu Quả Marketing**

**Mục tiêu**: Đánh giá hiệu quả các hoạt động marketing

**Hành động cụ thể**:

1. **Phân Tích ROI Marketing**
```python
def phan_tich_roi_marketing():
    # Phân tích hiệu quả theo fanpage
    marketing_roi = df_orders.groupby('page_id').agg({
        'gross_revenue': 'sum',
        'order_id': 'count',
        'customer_id': 'nunique'
    }).reset_index()
    
    # Tính các metrics marketing
    marketing_roi['gia_tri_don_hang_tb'] = marketing_roi['gross_revenue'] / marketing_roi['order_id']
    marketing_roi['ty_le_quay_lai'] = marketing_roi['order_id'] / marketing_roi['customer_id']
    
    # Phân tích customer acquisition cost (giả sử có dữ liệu chi phí)
    # marketing_roi['cac'] = marketing_roi['marketing_cost'] / marketing_roi['customer_id']
    # marketing_roi['roi'] = marketing_roi['gross_revenue'] / marketing_roi['marketing_cost']
    
    return marketing_roi
```

2. **Phân Tích Customer Journey**
```python
def phan_tich_customer_journey():
    # Phân tích hành trình khách hàng
    customer_journey = df_orders.groupby('customer_id').agg({
        'order_id': 'count',
        'gross_revenue': 'sum',
        'inserted_at': ['min', 'max'],
        'page_id': 'nunique'
    }).reset_index()
    
    # Tính thời gian giữa các đơn hàng
    customer_journey['thoi_gian_giua_don_hang'] = (
        customer_journey[('inserted_at', 'max')] - 
        customer_journey[('inserted_at', 'min')]
    ).dt.days / customer_journey[('order_id', 'count')]
    
    # Phân tích multi-channel
    customer_journey['multi_channel'] = customer_journey[('page_id', 'nunique')] > 1
    
    return customer_journey
```

#### **Ngày 21: Tổng Hợp & Chuẩn Bị Báo Cáo**

**Mục tiêu**: Tổng hợp tất cả insights và chuẩn bị báo cáo

**Hành động cụ thể**:

1. **Tạo Executive Summary**
```python
def tao_executive_summary():
    # Tổng hợp các insights chính
    insights = {
        'tong_quan_kinh_doanh': {
            'tong_doanh_thu': df_orders['gross_revenue'].sum(),
            'tong_khach_hang': df_customers['customer_id'].nunique(),
            'tong_don_hang': df_orders['order_id'].nunique(),
            'gia_tri_don_hang_tb': df_orders['gross_revenue'].mean()
        },
        'phan_tich_khach_hang': {
            'ty_le_vip': (df_customers['is_vip'] == 1).mean() * 100,
            'khach_hang_mat': (df_customers['recency_days'] > 180).sum(),
            'clv_trung_binh': df_customers['monetary'].mean()
        },
        'phan_tich_san_pham': {
            'top_san_pham': df_order_items.groupby('product_id')['line_revenue'].sum().nlargest(5),
            'san_pham_underperforming': df_order_items.groupby('product_id')['line_revenue'].sum().nsmallest(5)
        }
    }
    
    return insights
```

---

## 💡 **C. RECOMMENDATIONS - 2 TUẦN**

### **TUẦN 5: PHÂN TÍCH & ĐỀ XUẤT CHIẾN LƯỢC**

#### **Ngày 22-23: Đề Xuất Chiến Lược Khách Hàng**

**Mục tiêu**: Đưa ra các đề xuất để tối ưu hóa giá trị khách hàng

**Hành động cụ thể**:

1. **Chiến Lược Retention**
```python
def de_xuat_chiến_luoc_retention():
    # Phân tích khách hàng có nguy cơ churn
    at_risk_customers = df_customers[
        (df_customers['recency_days'] > 30) & 
        (df_customers['recency_days'] <= 90)
    ]
    
    # Đề xuất chiến lược
    recommendations = {
        'khach_hang_co_nguy_co': {
            'so_luong': len(at_risk_customers),
            'gia_tri_tien_te': at_risk_customers['monetary'].sum(),
            'de_xuat': [
                'Gửi email marketing với ưu đãi đặc biệt',
                'Tạo chương trình loyalty points',
                'Personalized recommendations dựa trên lịch sử mua hàng'
            ]
        }
    }
    
    return recommendations
```

2. **Chiến Lược Acquisition**
```python
def de_xuat_chiến_luoc_acquisition():
    # Phân tích khách hàng mới
    new_customers = df_customers[df_customers['frequency'] == 1]
    
    # Phân tích kênh acquisition hiệu quả nhất
    acquisition_channels = df_orders.groupby('page_id').agg({
        'customer_id': 'nunique',
        'gross_revenue': 'sum'
    }).reset_index()
    
    # Đề xuất
    recommendations = {
        'kenh_acquisition_hieu_qua': acquisition_channels.nlargest(3, 'customer_id'),
        'de_xuat': [
            'Tăng ngân sách marketing cho các kênh hiệu quả',
            'Tạo referral program',
            'Phát triển content marketing'
        ]
    }
    
    return recommendations
```

#### **Ngày 24-25: Đề Xuất Chiến Lược Sản Phẩm**

**Mục tiêu**: Tối ưu hóa danh mục sản phẩm

**Hành động cụ thể**:

1. **Chiến Lược Product Portfolio**
```python
def de_xuat_chiến_luoc_san_pham():
    # Phân tích ABC
    product_abc = phan_tich_abc_san_pham()
    
    # Đề xuất cho từng nhóm
    recommendations = {
        'san_pham_nhom_a': {
            'de_xuat': [
                'Tăng inventory cho các sản phẩm A',
                'Tạo bundle deals',
                'Phát triển variations'
            ]
        },
        'san_pham_nhom_b': {
            'de_xuat': [
                'Cross-selling với sản phẩm A',
                'Tối ưu pricing',
                'Cải thiện product description'
            ]
        },
        'san_pham_nhom_c': {
            'de_xuat': [
                'Xem xét ngừng kinh doanh',
                'Clearance sales',
                'Chuyển đổi thành sản phẩm khác'
            ]
        }
    }
    
    return recommendations
```

2. **Chiến Lược Pricing**
```python
def de_xuat_chiến_luoc_pricing():
    # Phân tích price elasticity
    price_analysis = df_order_items.groupby('product_id').agg({
        'line_revenue': 'sum',
        'quantity': 'sum'
    }).reset_index()
    
    price_analysis['gia_trung_binh'] = price_analysis['line_revenue'] / price_analysis['quantity']
    
    # Đề xuất pricing
    recommendations = {
        'san_pham_co_the_tang_gia': price_analysis[
            (price_analysis['quantity'] > 50) & 
            (price_analysis['gia_trung_binh'] < price_analysis['gia_trung_binh'].quantile(0.5))
        ],
        'de_xuat': [
            'A/B test tăng giá 10-15%',
            'Tạo premium versions',
            'Dynamic pricing based on demand'
        ]
    }
    
    return recommendations
```

### **TUẦN 6: ĐỀ XUẤT CHIẾN THUẬT & TRIỂN KHAI**

#### **Ngày 26-27: Đề Xuất Chiến Thuật Marketing**

**Mục tiêu**: Tối ưu hóa các hoạt động marketing

**Hành động cụ thể**:

1. **Chiến Lược Content Marketing**
```python
def de_xuat_chiến_luoc_content():
    # Phân tích hiệu quả theo loại content (giả sử có dữ liệu)
    # content_analysis = df_orders.groupby('content_type').agg({
    #     'gross_revenue': 'sum',
    #     'customer_id': 'nunique'
    # })
    
    recommendations = {
        'content_hieu_qua': [
            'Tạo video reviews sản phẩm',
            'Phát triển user-generated content',
            'Tạo blog về fashion trends'
        ],
        'timing_toi_uu': [
            'Post content vào 7-9h sáng và 7-9h tối',
            'Tăng frequency vào cuối tuần',
            'Tạo content cho các dịp lễ'
        ]
    }
    
    return recommendations
```

2. **Chiến Lược Social Media**
```python
def de_xuat_chiến_luoc_social_media():
    # Phân tích hiệu quả các fanpage
    social_analysis = df_orders.groupby('page_id').agg({
        'gross_revenue': 'sum',
        'order_id': 'count',
        'customer_id': 'nunique'
    }).reset_index()
    
    recommendations = {
        'fanpage_hieu_qua': social_analysis.nlargest(5, 'gross_revenue'),
        'de_xuat': [
            'Tăng ngân sách quảng cáo cho top fanpages',
            'Tạo cross-promotion giữa các fanpage',
            'Phát triển influencer partnerships'
        ]
    }
    
    return recommendations
```

#### **Ngày 28: Tạo Báo Cáo Tổng Hợp**

**Mục tiêu**: Tạo báo cáo hoàn chỉnh với tất cả insights và recommendations

**Hành động cụ thể**:

1. **Tạo Báo Cáo Executive**
```python
def tao_bao_cao_executive():
    # Tổng hợp tất cả insights và recommendations
    executive_report = {
        'tom_tat_dieu_hanh': {
            'tong_doanh_thu': df_orders['gross_revenue'].sum(),
            'tang_truong': '15% so với tháng trước',
            'kpi_chinh': {
                'gia_tri_don_hang_tb': df_orders['gross_revenue'].mean(),
                'ty_le_quay_lai': df_customers[df_customers['frequency'] > 1].shape[0] / df_customers.shape[0],
                'clv_trung_binh': df_customers['monetary'].mean()
            }
        },
        'insights_chinh': [
            '73.8% khách hàng đã không mua hàng trong 6 tháng qua',
            'Top 3 fanpage chiếm 60% tổng doanh thu',
            'Sản phẩm áo thu đông có doanh thu cao nhất',
            'Khách hàng VIP có giá trị trung bình gấp 3 lần khách hàng thường'
        ],
        'de_xuat_chiến_luoc': [
            'Triển khai chương trình win-back cho khách hàng cũ',
            'Tăng ngân sách marketing cho top 3 fanpage',
            'Phát triển thêm variations cho sản phẩm áo thu đông',
            'Tạo chương trình VIP với ưu đãi đặc biệt'
        ],
        'de_xuat_chiến_thuat': [
            'A/B test tăng giá 10% cho sản phẩm best-seller',
            'Tạo bundle deals cho sản phẩm B và C',
            'Phát triển content marketing về fashion trends',
            'Tối ưu timing post content trên social media'
        ]
    }
    
    return executive_report
```

2. **Tạo Action Plan**
```python
def tao_action_plan():
    action_plan = {
        'ngan_han_1_thang': [
            'Triển khai chương trình win-back email',
            'Tăng ngân sách quảng cáo cho top fanpages',
            'Tạo bundle deals cho sản phẩm underperforming'
        ],
        'trung_han_3_thang': [
            'Phát triển chương trình loyalty points',
            'Tạo premium product lines',
            'Phát triển influencer partnerships'
        ],
        'dai_han_6_thang': [
            'Mở rộng sang các kênh bán hàng mới',
            'Phát triển mobile app',
            'Triển khai AI-powered recommendations'
        ]
    }
    
    return action_plan
```

## 📊 **GIAI ĐOẠN 2: DASHBOARD & REPORTING (4-6 tuần)**

---

## 🎯 **TUẦN 7-8: THIẾT KẾ & PHÁT TRIỂN DASHBOARD**

### **TUẦN 7: THIẾT KẾ DASHBOARD CƠ BẢN**

#### **Ngày 29-30: Phân Tích Yêu Cầu & Thiết Kế**

**Mục tiêu**: Hiểu nhu cầu của từng phòng ban và thiết kế dashboard phù hợp

**Hành động cụ thể**:

1. **Phỏng Vấn Stakeholders**
```python
# Tạo bảng yêu cầu cho từng phòng ban
yeu_cau_dashboard = {
    'c_level': {
        'nguoi_dung': ['CEO', 'COO', 'CFO'],
        'muc_dich': 'Theo dõi KPI chiến lược và ra quyết định',
        'tần_suất_xem': 'Hàng ngày',
        'kpi_quan_trong': [
            'Tổng doanh thu',
            'Tăng trưởng doanh thu',
            'Lợi nhuận',
            'Số khách hàng mới',
            'Customer retention rate',
            'Market share'
        ],
        'yeu_cau_dac_biet': [
            'Drill-down capability',
            'Export to PDF/Excel',
            'Mobile responsive',
            'Real-time updates'
        ]
    },
    'operations': {
        'nguoi_dung': ['Quản lý kho', 'Quản lý vận chuyển', 'Quản lý chất lượng'],
        'muc_dich': 'Theo dõi hiệu quả vận hành và tối ưu hóa quy trình',
        'tần_suất_xem': 'Hàng ngày',
        'kpi_quan_trong': [
            'Tỷ lệ hoàn thành đơn hàng',
            'Thời gian xử lý đơn hàng',
            'Tỷ lệ lỗi',
            'Hiệu quả kho hàng',
            'Chi phí vận chuyển'
        ]
    },
    'sales': {
        'nguoi_dung': ['Quản lý bán hàng', 'Nhân viên bán hàng', 'Telesales'],
        'muc_dich': 'Theo dõi hiệu quả bán hàng và đạt target',
        'tần_suất_xem': 'Hàng ngày',
        'kpi_quan_trong': [
            'Doanh thu theo kênh',
            'Conversion rate',
            'Average order value',
            'Sales pipeline',
            'Customer acquisition cost'
        ]
    },
    'marketing': {
        'nguoi_dung': ['Quản lý marketing', 'Content creator', 'Social media manager'],
        'muc_dich': 'Đo lường hiệu quả chiến dịch và tối ưu hóa ROI',
        'tần_suất_xem': 'Hàng ngày',
        'kpi_quan_trong': [
            'ROI marketing',
            'Cost per acquisition',
            'Engagement rate',
            'Click-through rate',
            'Brand awareness'
        ]
    },
    'product': {
        'nguoi_dung': ['Quản lý sản phẩm', 'Merchandiser', 'Buyer'],
        'muc_dich': 'Theo dõi hiệu quả sản phẩm và tối ưu hóa danh mục',
        'tần_suất_xem': 'Hàng tuần',
        'kpi_quan_trong': [
            'Product performance',
            'Inventory turnover',
            'Profit margin',
            'Product lifecycle',
            'Customer satisfaction'
        ]
    }
}
```

2. **Thiết Kế Wireframe**
```python
def thiet_ke_wireframe():
    # Tạo wireframe cho từng dashboard
    wireframes = {
        'c_level': {
            'layout': '4 cột x 3 hàng',
            'components': [
                'KPI cards (tổng quan)',
                'Revenue trend chart',
                'Customer metrics',
                'Geographic distribution',
                'Top products',
                'Alerts & notifications'
            ]
        },
        'operations': {
            'layout': '3 cột x 4 hàng',
            'components': [
                'Order fulfillment metrics',
                'Processing time charts',
                'Error rate indicators',
                'Inventory levels',
                'Shipping performance',
                'Quality metrics'
            ]
        }
        # ... tiếp tục cho các phòng ban khác
    }
    
    return wireframes
```

#### **Ngày 31-32: Tạo Data Models cho Dashboard**

**Mục tiêu**: Tạo các data models tối ưu cho từng dashboard

**Hành động cụ thể**:

1. **Tạo Views cho C-Level Dashboard**
```sql
-- Tạo view tổng quan cho C-Level
CREATE VIEW c_level_overview AS
SELECT 
    DATE(inserted_at) as ngay,
    COUNT(DISTINCT order_id) as so_don_hang,
    COUNT(DISTINCT customer_id) as so_khach_hang,
    SUM(gross_revenue) as tong_doanh_thu,
    SUM(net_revenue) as doanh_thu_rong,
    AVG(gross_revenue) as gia_tri_don_hang_tb,
    COUNT(DISTINCT CASE WHEN is_vip = 1 THEN customer_id END) as so_khach_vip
FROM gold_fact_orders o
JOIN gold_dim_customers c ON o.customer_id = c.customer_id
GROUP BY DATE(inserted_at);

-- Tạo view xu hướng doanh thu
CREATE VIEW revenue_trends AS
SELECT 
    YEAR(inserted_at) as nam,
    MONTH(inserted_at) as thang,
    WEEK(inserted_at) as tuan,
    DATE(inserted_at) as ngay,
    SUM(gross_revenue) as doanh_thu,
    COUNT(DISTINCT order_id) as so_don_hang,
    COUNT(DISTINCT customer_id) as so_khach_hang
FROM gold_fact_orders
GROUP BY YEAR(inserted_at), MONTH(inserted_at), WEEK(inserted_at), DATE(inserted_at);
```

2. **Tạo Views cho Operations Dashboard**
```sql
-- Tạo view hiệu quả vận hành
CREATE VIEW operations_metrics AS
SELECT 
    DATE(inserted_at) as ngay,
    COUNT(*) as tong_don_hang,
    COUNT(CASE WHEN status = 3 THEN 1 END) as don_hang_hoan_thanh,
    COUNT(CASE WHEN status = 0 THEN 1 END) as don_hang_moi,
    COUNT(CASE WHEN status = 1 THEN 1 END) as don_hang_dang_xu_ly,
    AVG(CASE WHEN status = 3 THEN DATEDIFF(updated_at, inserted_at) END) as thoi_gian_xu_ly_tb,
    SUM(total_quantity) as tong_so_luong,
    SUM(shipping_fee) as tong_phi_van_chuyen
FROM gold_fact_orders
GROUP BY DATE(inserted_at);
```

#### **Ngày 33-35: Phát Triển Dashboard Cơ Bản**

**Mục tiêu**: Tạo các dashboard cơ bản với Power BI hoặc Python

**Hành động cụ thể**:

1. **Tạo C-Level Dashboard**
```python
def tao_c_level_dashboard():
    import streamlit as st
    import plotly.express as px
    import plotly.graph_objects as go
    
    # Tạo layout
    st.set_page_config(page_title="C-Level Dashboard", layout="wide")
    
    # Sidebar filters
    st.sidebar.title("Bộ Lọc")
    date_range = st.sidebar.date_input("Chọn khoảng thời gian", value=[df_orders['inserted_at'].min(), df_orders['inserted_at'].max()])
    
    # KPI Cards
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        st.metric("Tổng Doanh Thu", f"{tong_doanh_thu:,.0f} VND", f"+{tang_truong_doanh_thu:.1f}%")
    
    with col2:
        st.metric("Số Đơn Hàng", f"{tong_don_hang:,}", f"+{tang_truong_don_hang:.1f}%")
    
    with col3:
        st.metric("Khách Hàng Mới", f"{khach_hang_moi:,}", f"+{tang_truong_khach_hang:.1f}%")
    
    with col4:
        st.metric("Giá Trị Đơn Hàng TB", f"{gia_tri_don_hang_tb:,.0f} VND", f"+{tang_truong_aov:.1f}%")
    
    # Charts
    col1, col2 = st.columns(2)
    
    with col1:
        # Revenue trend
        fig_revenue = px.line(doanh_thu_theo_ngay, x='ngay_don_hang', y='gross_revenue', 
                             title='Xu Hướng Doanh Thu')
        st.plotly_chart(fig_revenue, use_container_width=True)
    
    with col2:
        # Customer segments
        fig_customer = px.pie(df_customers, names='is_vip', values='monetary',
                             title='Phân Bố Khách Hàng VIP vs Thường')
        st.plotly_chart(fig_customer, use_container_width=True)
    
    # Geographic distribution
    st.subheader("Phân Bố Địa Lý")
    fig_geo = px.bar(dia_ly_analysis.head(10), x='province_name', y='monetary',
                    title='Top 10 Tỉnh Thành Theo Doanh Thu')
    st.plotly_chart(fig_geo, use_container_width=True)
```

### **TUẦN 8: PHÁT TRIỂN DASHBOARD CHUYÊN SÂU**

#### **Ngày 36-37: Operations Dashboard**

**Mục tiêu**: Tạo dashboard cho phòng vận hành

**Hành động cụ thể**:

1. **Tạo Operations Dashboard**
```python
def tao_operations_dashboard():
    st.set_page_config(page_title="Operations Dashboard", layout="wide")
    
    # KPI Cards
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        ty_le_hoan_thanh = (df_orders['status'] == 3).sum() / len(df_orders) * 100
        st.metric("Tỷ Lệ Hoàn Thành", f"{ty_le_hoan_thanh:.1f}%")
    
    with col2:
        thoi_gian_xu_ly_tb = df_orders[df_orders['status'] == 3]['thoi_gian_xu_ly'].mean()
        st.metric("Thời Gian Xử Lý TB", f"{thoi_gian_xu_ly_tb:.1f} giờ")
    
    with col3:
        ty_le_loi = (df_orders['status'] == 4).sum() / len(df_orders) * 100
        st.metric("Tỷ Lệ Lỗi", f"{ty_le_loi:.1f}%")
    
    with col4:
        tong_phi_van_chuyen = df_orders['shipping_fee'].sum()
        st.metric("Tổng Phí Vận Chuyển", f"{tong_phi_van_chuyen:,.0f} VND")
    
    # Charts
    col1, col2 = st.columns(2)
    
    with col1:
        # Order status distribution
        status_counts = df_orders['status_name'].value_counts()
        fig_status = px.pie(values=status_counts.values, names=status_counts.index,
                           title='Phân Bố Trạng Thái Đơn Hàng')
        st.plotly_chart(fig_status, use_container_width=True)
    
    with col2:
        # Processing time trend
        fig_time = px.line(operations_metrics, x='ngay', y='thoi_gian_xu_ly_tb',
                          title='Xu Hướng Thời Gian Xử Lý')
        st.plotly_chart(fig_time, use_container_width=True)
    
    # Inventory levels
    st.subheader("Mức Tồn Kho")
    inventory_data = df_order_items.groupby('product_id').agg({
        'quantity': 'sum'
    }).reset_index()
    
    fig_inventory = px.bar(inventory_data.head(10), x='product_id', y='quantity',
                          title='Top 10 Sản Phẩm Bán Chạy')
    st.plotly_chart(fig_inventory, use_container_width=True)
```

#### **Ngày 38-39: Sales Dashboard**

**Mục tiêu**: Tạo dashboard cho phòng bán hàng

**Hành động cụ thể**:

1. **Tạo Sales Dashboard**
```python
def tao_sales_dashboard():
    st.set_page_config(page_title="Sales Dashboard", layout="wide")
    
    # KPI Cards
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        doanh_thu_hom_nay = df_orders[df_orders['inserted_at'].dt.date == pd.Timestamp.today().date()]['gross_revenue'].sum()
        st.metric("Doanh Thu Hôm Nay", f"{doanh_thu_hom_nay:,.0f} VND")
    
    with col2:
        conversion_rate = len(df_orders) / len(df_customers) * 100
        st.metric("Conversion Rate", f"{conversion_rate:.1f}%")
    
    with col3:
        aov = df_orders['gross_revenue'].mean()
        st.metric("Average Order Value", f"{aov:,.0f} VND")
    
    with col4:
        khach_hang_moi = df_customers[df_customers['frequency'] == 1].shape[0]
        st.metric("Khách Hàng Mới", f"{khach_hang_moi:,}")
    
    # Sales performance by channel
    st.subheader("Hiệu Quả Bán Hàng Theo Kênh")
    col1, col2 = st.columns(2)
    
    with col1:
        # Revenue by page
        page_revenue = df_orders.groupby('page_id')['gross_revenue'].sum().sort_values(ascending=False)
        fig_page = px.bar(x=page_revenue.index, y=page_revenue.values,
                         title='Doanh Thu Theo Fanpage')
        st.plotly_chart(fig_page, use_container_width=True)
    
    with col2:
        # Sales trend
        daily_sales = df_orders.groupby(df_orders['inserted_at'].dt.date)['gross_revenue'].sum()
        fig_trend = px.line(x=daily_sales.index, y=daily_sales.values,
                           title='Xu Hướng Bán Hàng')
        st.plotly_chart(fig_trend, use_container_width=True)
    
    # Top products
    st.subheader("Top Sản Phẩm Bán Chạy")
    top_products = df_order_items.groupby('product_id')['line_revenue'].sum().sort_values(ascending=False).head(10)
    fig_products = px.bar(x=top_products.index, y=top_products.values,
                         title='Top 10 Sản Phẩm Theo Doanh Thu')
    st.plotly_chart(fig_products, use_container_width=True)
```

#### **Ngày 40-42: Marketing Dashboard**

**Mục tiêu**: Tạo dashboard cho phòng marketing

**Hành động cụ thể**:

1. **Tạo Marketing Dashboard**
```python
def tao_marketing_dashboard():
    st.set_page_config(page_title="Marketing Dashboard", layout="wide")
    
    # KPI Cards
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        # ROI Marketing (giả sử có dữ liệu chi phí)
        # roi = (doanh_thu - chi_phi_marketing) / chi_phi_marketing * 100
        st.metric("ROI Marketing", "15.2%")
    
    with col2:
        # Cost per acquisition
        # cpa = chi_phi_marketing / so_khach_hang_moi
        st.metric("Cost Per Acquisition", "50,000 VND")
    
    with col3:
        # Engagement rate
        st.metric("Engagement Rate", "3.5%")
    
    with col4:
        # Click-through rate
        st.metric("Click-Through Rate", "2.1%")
    
    # Campaign performance
    st.subheader("Hiệu Quả Chiến Dịch")
    col1, col2 = st.columns(2)
    
    with col1:
        # Performance by page
        page_performance = df_orders.groupby('page_id').agg({
            'gross_revenue': 'sum',
            'order_id': 'count',
            'customer_id': 'nunique'
        }).reset_index()
        
        fig_campaign = px.scatter(page_performance, x='order_id', y='gross_revenue',
                                 size='customer_id', title='Hiệu Quả Theo Fanpage')
        st.plotly_chart(fig_campaign, use_container_width=True)
    
    with col2:
        # Customer acquisition trend
        customer_acquisition = df_orders.groupby(df_orders['inserted_at'].dt.date)['customer_id'].nunique()
        fig_acquisition = px.line(x=customer_acquisition.index, y=customer_acquisition.values,
                                 title='Xu Hướng Thu Hút Khách Hàng')
        st.plotly_chart(fig_acquisition, use_container_width=True)
    
    # Marketing funnel
    st.subheader("Marketing Funnel")
    funnel_data = {
        'Giai_doan': ['Awareness', 'Interest', 'Consideration', 'Purchase'],
        'So_luong': [10000, 5000, 2000, 500]
    }
    fig_funnel = px.funnel(funnel_data, x='So_luong', y='Giai_doan',
                          title='Marketing Funnel')
    st.plotly_chart(fig_funnel, use_container_width=True)
```

---

## 🎯 **TUẦN 9-10: PHÁT TRIỂN DASHBOARD NÂNG CAO**

#### **Ngày 43-44: Product Dashboard**

**Mục tiêu**: Tạo dashboard cho phòng sản phẩm

**Hành động cụ thể**:

1. **Tạo Product Dashboard**
```python
def tao_product_dashboard():
    st.set_page_config(page_title="Product Dashboard", layout="wide")
    
    # KPI Cards
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        # Product performance
        top_product_revenue = df_order_items.groupby('product_id')['line_revenue'].sum().max()
        st.metric("Sản Phẩm Tốt Nhất", f"{top_product_revenue:,.0f} VND")
    
    with col2:
        # Inventory turnover
        inventory_turnover = df_order_items['quantity'].sum() / len(df_products)
        st.metric("Inventory Turnover", f"{inventory_turnover:.1f}")
    
    with col3:
        # Profit margin
        profit_margin = (df_orders['net_revenue'].sum() / df_orders['gross_revenue'].sum()) * 100
        st.metric("Profit Margin", f"{profit_margin:.1f}%")
    
    with col4:
        # Product lifecycle
        st.metric("Sản Phẩm Mới", "5")
    
    # Product analysis
    st.subheader("Phân Tích Sản Phẩm")
    col1, col2 = st.columns(2)
    
    with col1:
        # ABC Analysis
        product_abc = df_order_items.groupby('product_id')['line_revenue'].sum().sort_values(ascending=False)
        product_abc['ty_le_tich_luy'] = product_abc.cumsum() / product_abc.sum() * 100
        
        fig_abc = px.bar(x=product_abc.index, y=product_abc['ty_le_tich_luy'],
                        title='Phân Tích ABC Sản Phẩm')
        st.plotly_chart(fig_abc, use_container_width=True)
    
    with col2:
        # Product performance by category
        category_performance = df_order_items.groupby('main_category')['line_revenue'].sum()
        fig_category = px.pie(values=category_performance.values, names=category_performance.index,
                             title='Doanh Thu Theo Danh Mục')
        st.plotly_chart(fig_category, use_container_width=True)
    
    # Product lifecycle
    st.subheader("Product Lifecycle")
    lifecycle_data = df_order_items.groupby(['product_id', 'thang_don_hang'])['line_revenue'].sum().reset_index()
    
    # Chọn top 5 sản phẩm
    top_products = df_order_items.groupby('product_id')['line_revenue'].sum().nlargest(5).index
    
    for product in top_products:
        product_data = lifecycle_data[lifecycle_data['product_id'] == product]
        fig_lifecycle = px.line(product_data, x='thang_don_hang', y='line_revenue',
                               title=f'Lifecycle - {product}')
        st.plotly_chart(fig_lifecycle, use_container_width=True)
```

#### **Ngày 45-46: Tối Ưu Hóa & Tích Hợp**

**Mục tiêu**: Tối ưu hóa performance và tích hợp các dashboard

**Hành động cụ thể**:

1. **Tối Ưu Hóa Performance**
```python
def toi_uu_hoa_performance():
    # Tạo cached data
    @st.cache_data
    def load_dashboard_data():
        return {
            'orders': df_orders,
            'customers': df_customers,
            'products': df_products,
            'order_items': df_order_items
        }
    
    # Tối ưu hóa queries
    def optimize_queries():
        # Sử dụng indexes
        # Tạo materialized views
        # Cache frequently used data
        pass
    
    # Responsive design
    def responsive_design():
        # Sử dụng CSS media queries
        # Tối ưu hóa cho mobile
        # Adaptive layouts
        pass
```

2. **Tích Hợp Dashboard**
```python
def tich_hop_dashboard():
    # Tạo main navigation
    st.sidebar.title("Navigation")
    page = st.sidebar.selectbox("Chọn Dashboard", [
        "C-Level Dashboard",
        "Operations Dashboard", 
        "Sales Dashboard",
        "Marketing Dashboard",
        "Product Dashboard"
    ])
    
    # Route to appropriate dashboard
    if page == "C-Level Dashboard":
        tao_c_level_dashboard()
    elif page == "Operations Dashboard":
        tao_operations_dashboard()
    elif page == "Sales Dashboard":
        tao_sales_dashboard()
    elif page == "Marketing Dashboard":
        tao_marketing_dashboard()
    elif page == "Product Dashboard":
        tao_product_dashboard()
```

---

## 🎯 **TUẦN 11-12: TRIỂN KHAI & ĐÀO TẠO**

#### **Ngày 47-49: Triển Khai Production**

**Mục tiêu**: Triển khai dashboard lên production environment

**Hành động cụ thể**:

1. **Setup Production Environment**
```python
def setup_production():
    # Deploy to cloud (AWS/Azure/GCP)
    # Setup CI/CD pipeline
    # Configure monitoring
    # Setup backup & recovery
    pass
```

2. **Security & Access Control**
```python
def setup_security():
    # User authentication
    # Role-based access control
    # Data encryption
    # Audit logging
    pass
```

#### **Ngày 50-52: Đào Tạo & Hỗ Trợ**

**Mục tiêu**: Đào tạo người dùng và cung cấp hỗ trợ

**Hành động cụ thể**:

1. **Tạo Tài Liệu Hướng Dẫn**
```python
def tao_tai_lieu_huong_dan():
    # User manual cho từng dashboard
    # Video tutorials
    # FAQ
    # Best practices
    pass
```

2. **Đào Tạo Người Dùng**
```python
def dao_tao_nguoi_dung():
    # Training sessions cho từng phòng ban
    # Hands-on workshops
    # Q&A sessions
    # Follow-up support
    pass
```

---

## 📊 **CHI TIẾT DASHBOARD CHO TỪNG PHÒNG BAN**

### **1. C-LEVEL DASHBOARD (Ban Giám Đốc)**

#### **Mục tiêu**: Theo dõi KPI chiến lược và ra quyết định

#### **KPI Chính**:
- **Tổng doanh thu** (hàng ngày, tuần, tháng)
- **Tăng trưởng doanh thu** (YoY, MoM)
- **Lợi nhuận** (gross margin, net margin)
- **Số khách hàng mới** (daily, weekly)
- **Customer retention rate**
- **Market share**

#### **Visualizations**:
- **Revenue trend chart** (line chart)
- **KPI cards** (metrics)
- **Geographic distribution** (map/bar chart)
- **Top products** (bar chart)
- **Customer segments** (pie chart)
- **Alerts & notifications** (table)

#### **Features**:
- **Drill-down capability**
- **Export to PDF/Excel**
- **Mobile responsive**
- **Real-time updates**
- **Custom date ranges**

### **2. OPERATIONS DASHBOARD (Vận Hành)**

#### **Mục tiêu**: Theo dõi hiệu quả vận hành và tối ưu hóa quy trình

#### **KPI Chính**:
- **Tỷ lệ hoàn thành đơn hàng** (fulfillment rate)
- **Thời gian xử lý đơn hàng** (processing time)
- **Tỷ lệ lỗi** (error rate)
- **Hiệu quả kho hàng** (inventory turnover)
- **Chi phí vận chuyển** (shipping cost)

#### **Visualizations**:
- **Order status distribution** (pie chart)
- **Processing time trend** (line chart)
- **Inventory levels** (bar chart)
- **Error rate by type** (bar chart)
- **Shipping performance** (line chart)

#### **Features**:
- **Real-time monitoring**
- **Alert system**
- **Performance benchmarks**
- **Process optimization suggestions**

### **3. SALES DASHBOARD (Bán Hàng)**

#### **Mục tiêu**: Theo dõi hiệu quả bán hàng và đạt target

#### **KPI Chính**:
- **Doanh thu theo kênh** (revenue by channel)
- **Conversion rate** (conversion rate)
- **Average order value** (AOV)
- **Sales pipeline** (pipeline)
- **Customer acquisition cost** (CAC)

#### **Visualizations**:
- **Sales performance by channel** (bar chart)
- **Sales trend** (line chart)
- **Top products** (bar chart)
- **Sales funnel** (funnel chart)
- **Customer acquisition** (line chart)

#### **Features**:
- **Target vs actual**
- **Sales forecasting**
- **Performance rankings**
- **Commission calculations**

### **4. MARKETING DASHBOARD (Marketing)**

#### **Mục tiêu**: Đo lường hiệu quả chiến dịch và tối ưu hóa ROI

#### **KPI Chính**:
- **ROI marketing** (return on investment)
- **Cost per acquisition** (CPA)
- **Engagement rate** (engagement)
- **Click-through rate** (CTR)
- **Brand awareness** (awareness)

#### **Visualizations**:
- **Campaign performance** (scatter plot)
- **Marketing funnel** (funnel chart)
- **Customer acquisition trend** (line chart)
- **Channel effectiveness** (bar chart)
- **ROI by campaign** (bar chart)

#### **Features**:
- **A/B testing results**
- **Campaign comparison**
- **Budget allocation**
- **Performance optimization**

### **5. PRODUCT DASHBOARD (Sản Phẩm)**

#### **Mục tiêu**: Theo dõi hiệu quả sản phẩm và tối ưu hóa danh mục

#### **KPI Chính**:
- **Product performance** (revenue, quantity)
- **Inventory turnover** (turnover)
- **Profit margin** (margin)
- **Product lifecycle** (lifecycle)
- **Customer satisfaction** (satisfaction)

#### **Visualizations**:
- **ABC analysis** (bar chart)
- **Product performance by category** (pie chart)
- **Product lifecycle** (line chart)
- **Inventory levels** (bar chart)
- **Profitability analysis** (scatter plot)

#### **Features**:
- **Product recommendations**
- **Inventory optimization**
- **Pricing analysis**
- **Product portfolio optimization**

---

## 🎯 **KẾT QUẢ MONG ĐỢI**

Sau khi hoàn thành Giai đoạn 2, DA sẽ có:

1. **5 Dashboard chuyên biệt** cho từng phòng ban
2. **Hệ thống báo cáo tự động** (daily, weekly, monthly)
3. **Self-service analytics** cho business users
4. **Documentation và training materials**
5. **Monitoring và support system**

**Timeline tổng thể**: 12 tuần (3 tháng)
**Deliverables**: 5 dashboard + báo cáo + documentation
**Success metrics**: User adoption rate, business impact, user satisfaction
