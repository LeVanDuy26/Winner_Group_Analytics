# Lộ trình EDA (Exploratory Data Analysis) - Winner Group Analytics
## Data Analytics Expert Plan (Kế hoạch Chuyên gia Phân tích Dữ liệu)

---

## **TỔNG QUAN DỰ ÁN**

### **Mục tiêu chính (Primary Objectives)**
1. **Hiểu rõ hiệu suất kinh doanh** - Understanding business performance
2. **Phát hiện cơ hội tăng trưởng** - Identifying growth opportunities  
3. **Tối ưu hóa trải nghiệm khách hàng** - Optimizing customer experience
4. **Cải thiện hiệu quả vận hành** - Improving operational efficiency

### **Phạm vi phân tích (Analysis Scope)**
- **Thời gian**: Dữ liệu từ Gold layer (đã clean và chuẩn hóa)
- **Đối tượng**: 40,236 đơn hàng, 46,611 items, 37 sản phẩm, 1 cửa hàng Winner Group
- **Kiến trúc**: Star Schema với 2 fact tables và 7 dimension tables
- **Phương pháp**: E-commerce analytics best practices (Thực hành tốt nhất phân tích thương mại điện tử)
- **Công cụ**: Python, SQL, Statistical Analysis (Phân tích thống kê)
- **Dữ liệu sẵn sàng**: Gold layer đã clean, có data dictionary hoàn chỉnh

---

## **GIAI ĐOẠN 1: EDA PHÂN TÍCH (EXPLORATORY DATA ANALYSIS)**

### **1.1 EDA_Overview.ipynb - Tổng quan Dataset**

#### **Mục tiêu (Objectives)**
- Đánh giá chất lượng dữ liệu tổng thể
- Hiểu cấu trúc và quy mô dataset
- Xác định các vấn đề dữ liệu cần xử lý

#### **Nội dung phân tích (Analysis Content)**
```python
# 1. Data Quality Assessment (Đánh giá chất lượng dữ liệu)
- Missing values analysis (Phân tích giá trị thiếu)
- Duplicate detection (Phát hiện trùng lặp)
- Data type validation (Xác thực kiểu dữ liệu)
- Outlier identification (Xác định giá trị ngoại lai)

# 2. Dataset Structure (Cấu trúc Dataset)
- Star Schema relationships (Mối quan hệ Star Schema)
- Fact tables: fact_orders (40,236), fact_order_items (46,611)
- Dimension tables: dim_customers, dim_products (37), dim_shop (1), dim_date, dim_order_pages, dim_order_warehouses, dim_order_shipping, dim_order_payments
- Data volume analysis (Phân tích khối lượng dữ liệu)
- Time range coverage (Phạm vi thời gian)
- Geographic coverage (Phạm vi địa lý - Hà Nội)

# 3. Business Metrics Overview (Tổng quan chỉ số kinh doanh)
- Total orders: 40,236 đơn hàng
- Total items: 46,611 items
- Total products: 37 sản phẩm
- Total customers: Từ dim_customers
- Revenue trends (Xu hướng doanh thu)
- Growth rates (Tỷ lệ tăng trưởng)
```

#### **Chỉ số đánh giá (Key Metrics)**
- **Data Completeness (Độ hoàn chỉnh dữ liệu)**: % dữ liệu hoàn chỉnh
- **Data Freshness (Độ mới của dữ liệu)**: Thời gian cập nhật cuối
- **Data Volume (Khối lượng dữ liệu)**: Số lượng records, size database

---

### **1.2 EDA_Business_Metrics.ipynb - Chỉ số Kinh doanh Cơ bản**

#### **Mục tiêu (Objectives)**
- Tính toán các KPI cơ bản của e-commerce
- Phân tích xu hướng doanh thu và đơn hàng
- Đánh giá hiệu suất kinh doanh tổng thể

#### **Chỉ số phân tích (Key Performance Indicators)**

##### **A. Revenue Metrics (Chỉ số Doanh thu)**
```python
# 1. Total Revenue (Tổng doanh thu)
total_revenue = SUM(order_value)

# 2. Average Order Value - AOV (Giá trị đơn hàng trung bình)
aov = total_revenue / total_orders

# 3. Monthly Recurring Revenue - MRR (Doanh thu định kỳ hàng tháng)
mrr = SUM(monthly_revenue)

# 4. Revenue Growth Rate (Tỷ lệ tăng trưởng doanh thu)
revenue_growth = (current_period_revenue - previous_period_revenue) / previous_period_revenue * 100
```

##### **B. Order Metrics (Chỉ số Đơn hàng)**
```python
# 1. Total Orders (Tổng số đơn hàng)
total_orders = COUNT(DISTINCT order_id)

# 2. Orders per Customer (Số đơn hàng trên mỗi khách hàng)
orders_per_customer = total_orders / total_customers

# 3. Order Completion Rate (Tỷ lệ hoàn thành đơn hàng)
completion_rate = completed_orders / total_orders * 100

# 4. Order Frequency (Tần suất đặt hàng)
order_frequency = total_orders / (days_in_period * total_customers)
```

##### **C. Customer Metrics (Chỉ số Khách hàng)**
```python
# 1. Total Customers (Tổng số khách hàng)
total_customers = COUNT(DISTINCT customer_id)

# 2. New Customers (Khách hàng mới)
new_customers = COUNT(DISTINCT customer_id WHERE first_order_date = current_period)

# 3. Customer Acquisition Rate (Tỷ lệ thu hút khách hàng mới)
acquisition_rate = new_customers / total_customers * 100

# 4. Customer Retention Rate (Tỷ lệ giữ chân khách hàng)
retention_rate = returning_customers / previous_period_customers * 100
```

#### **Visualizations (Biểu đồ)**
- Revenue trend line chart (Biểu đồ đường xu hướng doanh thu)
- AOV distribution histogram (Biểu đồ phân phối giá trị đơn hàng trung bình)
- Monthly order volume bar chart (Biểu đồ cột khối lượng đơn hàng hàng tháng)
- Customer growth funnel (Phễu tăng trưởng khách hàng)

---

### **1.3 EDA_Customer_Deep_Dive.ipynb - Phân tích Khách hàng Sâu**

#### **Mục tiêu (Objectives)**
- Phân tích hành vi mua sắm của khách hàng
- Xây dựng customer segmentation (Phân khúc khách hàng)
- Thực hiện RFM Analysis (Phân tích RFM)
- Phát hiện customer lifetime value patterns (Mẫu giá trị trọn đời khách hàng)

#### **Nội dung phân tích (Analysis Content)**

##### **A. RFM Analysis (Recency, Frequency, Monetary)**
```python
# RFM Scoring System
# Recency: Số ngày từ lần mua cuối
recency = DATEDIFF(current_date, last_order_date)

# Frequency: Số lần mua hàng
frequency = COUNT(DISTINCT order_id)

# Monetary: Tổng giá trị mua hàng
monetary = SUM(order_value)

# RFM Score Calculation (1-5 scale)
def calculate_rfm_score(value, metric_type):
    if metric_type == 'recency':
        # Recency: Càng gần đây càng cao điểm
        return 5 if value <= 30 else 4 if value <= 90 else 3 if value <= 180 else 2 if value <= 365 else 1
    elif metric_type == 'frequency':
        # Frequency: Càng nhiều lần càng cao điểm
        return 5 if value >= 10 else 4 if value >= 5 else 3 if value >= 3 else 2 if value >= 2 else 1
    elif metric_type == 'monetary':
        # Monetary: Càng nhiều tiền càng cao điểm
        return 5 if value >= 5000000 else 4 if value >= 2000000 else 3 if value >= 1000000 else 2 if value >= 500000 else 1
```

##### **B. Customer Segmentation**
```python
# 1. VIP Customers (Khách hàng VIP)
vip_customers = customers WHERE rfm_score >= 4 AND monetary >= 5000000

# 2. Loyal Customers (Khách hàng trung thành)
loyal_customers = customers WHERE frequency >= 5 AND recency <= 90

# 3. At-Risk Customers (Khách hàng có nguy cơ rời bỏ)
at_risk_customers = customers WHERE recency > 180 AND frequency >= 2

# 4. New Customers (Khách hàng mới)
new_customers = customers WHERE first_order_date >= current_date - 30

# 5. Lost Customers (Khách hàng đã mất)
lost_customers = customers WHERE recency > 365
```

##### **C. Customer Lifetime Value (CLV)**
```python
# CLV Calculation
# Method 1: Simple CLV
clv_simple = (average_order_value * purchase_frequency * customer_lifespan)

# Method 2: RFM-based CLV
clv_rfm = (rfm_score / 15) * average_order_value * 12

# Method 3: Cohort-based CLV
clv_cohort = cohort_revenue / cohort_size
```

##### **D. Behavioral Analysis**
```python
# 1. Purchase Patterns (Mẫu mua hàng)
- Best selling days of week (Ngày bán chạy nhất trong tuần)
- Peak shopping hours (Giờ mua sắm cao điểm)
- Seasonal buying behavior (Hành vi mua theo mùa)
- Product preference analysis (Phân tích sở thích sản phẩm)

# 2. Geographic Analysis (Phân tích địa lý)
- Customer distribution by province (Phân bố khách hàng theo tỉnh)
- Revenue by location (Doanh thu theo địa điểm)
- Shipping cost analysis (Phân tích chi phí vận chuyển)

# 3. Demographic Analysis (Phân tích nhân khẩu học)
- Gender distribution (Phân bố giới tính)
- Age group analysis (if available) (Phân tích nhóm tuổi - nếu có)
- Customer acquisition channels (Kênh thu hút khách hàng)
```

#### **Key Insights to Extract (Insights chính cần rút ra)**
- Customer segments with highest revenue potential (Phân khúc khách hàng có tiềm năng doanh thu cao nhất)
- Optimal timing for marketing campaigns (Thời điểm tối ưu cho chiến dịch marketing)
- Geographic expansion opportunities (Cơ hội mở rộng địa lý)
- Customer churn prediction factors (Yếu tố dự đoán khách hàng rời bỏ)

---

### **1.4 EDA_Product_Deep_Dive.ipynb - Phân tích Sản phẩm Sâu**

#### **Mục tiêu (Objectives)**
- Phân tích hiệu suất sản phẩm
- Xác định best sellers và slow movers (Sản phẩm bán chạy và chậm tiêu)
- Phân tích inventory turnover (Vòng quay kho)
- Tối ưu hóa product mix (Hỗn hợp sản phẩm)

#### **Nội dung phân tích (Analysis Content)**

##### **A. Product Performance Metrics (Chỉ số hiệu suất sản phẩm)**
```python
# 1. Best Sellers (Sản phẩm bán chạy)
best_sellers = products ORDER BY total_quantity_sold DESC

# 2. Revenue Leaders (Sản phẩm dẫn đầu doanh thu)
revenue_leaders = products ORDER BY total_revenue DESC

# 3. Inventory Turnover (Vòng quay kho)
inventory_turnover = total_quantity_sold / average_inventory

# 4. Product Velocity (Tốc độ bán)
product_velocity = total_quantity_sold / days_active

# 5. Sell-through Rate (Tỷ lệ bán hết)
sell_through_rate = quantity_sold / (quantity_sold + remaining_quantity) * 100
```

##### **B. Product Category Analysis (Phân tích danh mục sản phẩm)**
```python
# 1. Category Performance (Hiệu suất danh mục)
category_revenue = SUM(revenue) GROUP BY category
category_growth = (current_period_revenue - previous_period_revenue) / previous_period_revenue

# 2. Category Mix Analysis (Phân tích hỗn hợp danh mục)
category_mix = category_revenue / total_revenue * 100

# 3. Cross-category Purchase Patterns (Mẫu mua hàng liên danh mục)
cross_category_analysis = analyze_customer_purchase_across_categories()
```

##### **C. Price Analysis (Phân tích giá)**
```python
# 1. Price Elasticity (Độ co giãn giá)
price_elasticity = %change_in_quantity_demanded / %change_in_price

# 2. Price Distribution (Phân phối giá)
price_ranges = categorize_products_by_price_range()

# 3. Discount Impact Analysis (Phân tích tác động giảm giá)
discount_impact = analyze_discount_effect_on_sales()

# 4. Competitive Pricing Analysis (Phân tích giá cạnh tranh)
competitive_positioning = compare_with_market_prices()
```

##### **D. Product Lifecycle Analysis (Phân tích vòng đời sản phẩm)**
```python
# 1. Product Lifecycle Stages (Các giai đoạn vòng đời sản phẩm)
- Introduction: New products (< 30 days) (Giới thiệu: Sản phẩm mới < 30 ngày)
- Growth: Growing products (30-90 days, increasing sales) (Tăng trưởng: Sản phẩm đang phát triển 30-90 ngày, doanh số tăng)
- Maturity: Stable products (90+ days, stable sales) (Trưởng thành: Sản phẩm ổn định 90+ ngày, doanh số ổn định)
- Decline: Declining products (decreasing sales trend) (Suy giảm: Sản phẩm suy giảm, xu hướng doanh số giảm)

# 2. Seasonal Product Analysis (Phân tích sản phẩm theo mùa)
seasonal_patterns = analyze_seasonal_sales_patterns()

# 3. Product Cannibalization (Sự thay thế sản phẩm)
cannibalization_analysis = analyze_product_substitution_effects()
```

#### **Key Insights to Extract (Insights chính cần rút ra)**
- Products to promote/discontinue (Sản phẩm cần quảng bá/ngừng kinh doanh)
- Optimal pricing strategies (Chiến lược giá tối ưu)
- Inventory optimization opportunities (Cơ hội tối ưu hóa kho)
- New product development insights (Insights phát triển sản phẩm mới)

---

### **1.5 EDA_Operational_Analytics.ipynb - Phân tích Vận hành**

#### **Mục tiêu (Objectives)**
- Phân tích hiệu suất warehouse và shipping
- Phân tích payment methods và success rate
- Phân tích order fulfillment process
- Phân tích customer service metrics

#### **Nội dung phân tích (Analysis Content)**

##### **A. Warehouse Performance Metrics (Chỉ số hiệu suất kho)**
```python
# 1. Warehouse Utilization (Sử dụng kho)
warehouse_utilization = orders_per_warehouse / warehouse_capacity

# 2. Shipping Efficiency (Hiệu quả vận chuyển)
shipping_efficiency = on_time_deliveries / total_deliveries * 100

# 3. Geographic Distribution (Phân bố địa lý)
geo_distribution = orders_by_warehouse_location()

# 4. Inventory Turnover by Warehouse (Vòng quay kho theo warehouse)
inventory_turnover = total_orders / warehouse_inventory
```

##### **B. Payment Analysis (Phân tích thanh toán)**
```python
# 1. Payment Methods Distribution (Phân bố phương thức thanh toán)
payment_methods = payment_type_distribution()

# 2. Payment Success Rate (Tỷ lệ thanh toán thành công)
payment_success_rate = successful_payments / total_payments * 100

# 3. Payment Timing Analysis (Phân tích thời gian thanh toán)
payment_timing = time_to_payment_analysis()

# 4. Payment Issues Analysis (Phân tích vấn đề thanh toán)
payment_issues = failed_payment_reasons()
```

##### **C. Order Fulfillment Analysis (Phân tích thực hiện đơn hàng)**
```python
# 1. Order Status Distribution (Phân bố trạng thái đơn hàng)
order_status_dist = order_status_breakdown()

# 2. Fulfillment Time Analysis (Phân tích thời gian thực hiện)
fulfillment_time = order_to_delivery_time()

# 3. Return Rate Analysis (Phân tích tỷ lệ trả hàng)
return_rate = returned_orders / total_orders * 100

# 4. Customer Service Metrics (Chỉ số dịch vụ khách hàng)
cs_metrics = customer_service_performance()
```

#### **Key Insights to Extract (Insights chính cần rút ra)**
- Warehouse efficiency optimization opportunities (Cơ hội tối ưu hiệu quả kho)
- Payment method preferences and success rates (Sở thích và tỷ lệ thành công phương thức thanh toán)
- Order fulfillment bottlenecks (Điểm nghẽn trong thực hiện đơn hàng)
- Customer service improvement areas (Lĩnh vực cải thiện dịch vụ khách hàng)

---

### **1.6 EDA_Predictive_Insights.ipynb - Insights Dự đoán**

#### **Mục tiêu (Objectives)**
- Dự đoán xu hướng bán hàng
- Phân tích customer churn risk (Rủi ro khách hàng rời bỏ)
- Dự báo demand forecasting (Dự báo nhu cầu)
- Phân tích seasonal patterns (Mẫu theo mùa)

#### **Nội dung phân tích (Analysis Content)**

##### **A. Sales Forecasting (Dự báo bán hàng)**
```python
# 1. Time Series Analysis (Phân tích chuỗi thời gian)
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.arima.model import ARIMA

# Decompose time series (Phân tích chuỗi thời gian)
decomposition = seasonal_decompose(sales_data, model='additive')

# ARIMA Model for forecasting (Mô hình ARIMA cho dự báo)
model = ARIMA(sales_data, order=(1,1,1))
forecast = model.fit().forecast(steps=30)
```

##### **B. Customer Churn Prediction (Dự đoán khách hàng rời bỏ)**
```python
# 1. Churn Indicators (Chỉ số rời bỏ)
churn_indicators = [
    'days_since_last_order > 90',
    'decreasing_order_frequency',
    'decreasing_order_value',
    'customer_service_complaints',
    'payment_issues'
]

# 2. Churn Probability Score (Điểm xác suất rời bỏ)
churn_score = weighted_sum_of_indicators()

# 3. Retention Strategies by Segment (Chiến lược giữ chân theo phân khúc)
retention_strategies = recommend_strategies_by_churn_risk()
```

##### **C. Demand Forecasting (Dự báo nhu cầu)**
```python
# 1. Product Demand Prediction (Dự báo nhu cầu sản phẩm)
demand_forecast = predict_product_demand(product_id, time_horizon)

# 2. Inventory Optimization (Tối ưu hóa kho)
optimal_inventory = calculate_optimal_stock_levels()

# 3. Seasonal Demand Patterns (Mẫu nhu cầu theo mùa)
seasonal_demand = analyze_seasonal_patterns_by_category()
```

#### **Key Insights to Extract (Insights chính cần rút ra)**
- Sales trend predictions for next quarter (Dự đoán xu hướng bán hàng quý tới)
- High-risk customer segments for retention campaigns (Phân khúc khách hàng rủi ro cao cho chiến dịch giữ chân)
- Product demand forecasts for inventory planning (Dự báo nhu cầu sản phẩm cho kế hoạch kho)
- Seasonal opportunities for marketing campaigns (Cơ hội theo mùa cho chiến dịch marketing)

---

### **1.7 EDA_Business_Intelligence.ipynb - Business Intelligence (Thông tin kinh doanh)**

#### **Mục tiêu (Objectives)**
- Tổng hợp insights từ tất cả phân tích
- Tạo actionable recommendations (Khuyến nghị có thể thực hiện)
- Phân tích competitive advantage (Lợi thế cạnh tranh)
- Định hướng chiến lược kinh doanh

#### **Nội dung phân tích (Analysis Content)**

##### **A. Executive Summary Dashboard (Bảng tổng quan điều hành)**
```python
# 1. Key Business Metrics (Chỉ số kinh doanh chính)
kpi_dashboard = {
    'total_revenue': total_revenue,
    'revenue_growth': revenue_growth_rate,
    'customer_count': total_customers,
    'customer_growth': customer_growth_rate,
    'aov': average_order_value,
    'retention_rate': customer_retention_rate
}

# 2. Performance vs Targets (Hiệu suất so với mục tiêu)
performance_vs_target = compare_with_business_targets()

# 3. Trend Analysis (Phân tích xu hướng)
trend_analysis = analyze_key_metrics_trends()
```

##### **B. Strategic Recommendations (Khuyến nghị chiến lược)**
```python
# 1. Growth Opportunities (Cơ hội tăng trưởng)
growth_opportunities = identify_growth_opportunities()

# 2. Risk Mitigation (Giảm thiểu rủi ro)
risk_mitigation = identify_and_mitigate_risks()

# 3. Operational Improvements (Cải thiện vận hành)
operational_improvements = recommend_operational_changes()

# 4. Marketing Optimization (Tối ưu hóa marketing)
marketing_optimization = optimize_marketing_strategies()
```

##### **C. Competitive Analysis (Phân tích cạnh tranh)**
```python
# 1. Market Position Analysis (Phân tích vị thế thị trường)
market_position = analyze_competitive_position()

# 2. Differentiation Opportunities (Cơ hội khác biệt hóa)
differentiation = identify_differentiation_opportunities()

# 3. Pricing Strategy (Chiến lược giá)
pricing_strategy = recommend_pricing_changes()
```

---

## **BỔ SUNG DỰA TRÊN DỮ LIỆU GOLD LAYER**

### **Dữ liệu thực tế có sẵn:**
- **fact_orders**: 40,236 đơn hàng với đầy đủ thông tin
- **fact_order_items**: 46,611 items chi tiết
- **dim_customers**: Dữ liệu khách hàng đã clean (giới tính: Nam/Nữ/Unknown)
- **dim_products**: 37 sản phẩm với category_name
- **dim_shop**: 1 cửa hàng Winner Group
- **dim_date**: Bảng thời gian đầy đủ cho time-series analysis
- **dim_order_pages**: Thông tin trang đặt hàng (đã xóa page_username)
- **dim_order_warehouses**: Kho hàng ở Hà Nội (tên và địa chỉ ngẫu nhiên)
- **dim_order_shipping**: Thông tin vận chuyển
- **dim_order_payments**: Thông tin thanh toán

### **Điều chỉnh phân tích dựa trên dữ liệu thực tế:**

#### **1. Customer Analysis - Tập trung vào:**
- Phân tích giới tính: Nam/Nữ/Unknown (đã clean)
- Phân tích địa lý: Tập trung Hà Nội (warehouse locations)
- RFM Analysis với dữ liệu thực tế
- Customer segmentation dựa trên purchased_amount

#### **2. Product Analysis - Tập trung vào:**
- 37 sản phẩm với category_name
- Phân tích best sellers trong 46,611 items
- Product performance với 40,236 orders
- Category analysis với "Le Van Duy" category

#### **3. Order Analysis - Tập trung vào:**
- 40,236 orders với order_status, payment_status, shipping_status
- Order value analysis với total_amount, discount_amount, shipping_fee
- Time-series analysis với dim_date
- Order fulfillment với warehouse và shipping data

#### **4. Operational Analysis - Tập trung vào:**
- Warehouse performance (Hà Nội locations)
- Payment methods và success rates
- Shipping efficiency
- Order processing time

---

## **CÔNG THỨC TÍNH TOÁN CHI TIẾT**

### **1. Customer Metrics (Chỉ số Khách hàng)**

#### **Customer Acquisition Cost (CAC) (Chi phí thu hút khách hàng)**
```
CAC = Total Marketing Spend / Number of New Customers Acquired
```

#### **Customer Lifetime Value (CLV) (Giá trị trọn đời khách hàng)**
```
CLV = (Average Order Value × Purchase Frequency × Customer Lifespan) - CAC
```

#### **Customer Retention Rate (Tỷ lệ giữ chân khách hàng)**
```
Retention Rate = (Customers at End of Period - New Customers) / Customers at Start of Period × 100
```

#### **Customer Churn Rate (Tỷ lệ khách hàng rời bỏ)**
```
Churn Rate = (Lost Customers / Total Customers) × 100
```

### **2. Revenue Metrics (Chỉ số Doanh thu)**

#### **Monthly Recurring Revenue (MRR) (Doanh thu định kỳ hàng tháng)**
```
MRR = Sum of all monthly subscription revenues
```

#### **Average Revenue Per User (ARPU) (Doanh thu trung bình trên mỗi người dùng)**
```
ARPU = Total Revenue / Number of Active Customers
```

#### **Revenue Growth Rate (Tỷ lệ tăng trưởng doanh thu)**
```
Growth Rate = (Current Period Revenue - Previous Period Revenue) / Previous Period Revenue × 100
```

### **3. Product Metrics (Chỉ số Sản phẩm)**

#### **Inventory Turnover (Vòng quay kho)**
```
Inventory Turnover = Cost of Goods Sold / Average Inventory Value
```

#### **Sell-through Rate (Tỷ lệ bán hết)**
```
Sell-through Rate = Units Sold / (Units Sold + Units Remaining) × 100
```

#### **Product Velocity (Tốc độ sản phẩm)**
```
Product Velocity = Units Sold / Days Active
```

### **4. Marketing Metrics (Chỉ số Marketing)**

#### **Return on Ad Spend (ROAS) (Lợi nhuận trên chi phí quảng cáo)**
```
ROAS = Revenue Generated from Ads / Ad Spend
```

#### **Cost Per Click (CPC) (Chi phí mỗi lượt click)**
```
CPC = Total Ad Spend / Total Clicks
```

#### **Conversion Rate (Tỷ lệ chuyển đổi)**
```
Conversion Rate = (Number of Conversions / Number of Visitors) × 100
```

---

## **PHƯƠNG PHÁP PHÂN TÍCH**

### **1. Statistical Methods (Phương pháp Thống kê)**
- **Descriptive Statistics (Thống kê mô tả)**: Mean, median, mode, standard deviation
- **Correlation Analysis (Phân tích tương quan)**: Pearson, Spearman correlation
- **Regression Analysis (Phân tích hồi quy)**: Linear, logistic regression
- **Time Series Analysis (Phân tích chuỗi thời gian)**: ARIMA, seasonal decomposition
- **Clustering (Phân cụm)**: K-means, hierarchical clustering

### **2. Business Analytics Methods (Phương pháp Phân tích Kinh doanh)**
- **RFM Analysis (Phân tích RFM)**: Recency, Frequency, Monetary scoring
- **Cohort Analysis (Phân tích nhóm)**: Customer behavior over time
- **Funnel Analysis (Phân tích phễu)**: Conversion funnel optimization
- **A/B Testing (Thử nghiệm A/B)**: Statistical significance testing
- **Market Basket Analysis (Phân tích giỏ hàng)**: Product association rules

### **3. Visualization Techniques (Kỹ thuật Trực quan hóa)**
- **Time Series Plots (Biểu đồ chuỗi thời gian)**: Trend analysis
- **Distribution Plots (Biểu đồ phân phối)**: Histograms, box plots
- **Correlation Heatmaps (Bản đồ nhiệt tương quan)**: Relationship analysis
- **Geographic Maps (Bản đồ địa lý)**: Location-based insights
- **Interactive Dashboards (Bảng điều khiển tương tác)**: Real-time monitoring

---

## **DELIVERABLES (Sản phẩm đầu ra)**

### **1. Analysis Notebooks (Sổ tay Phân tích)**
- 7 Jupyter notebooks với phân tích chi tiết
- Code có thể tái sử dụng và mở rộng
- Documentation đầy đủ cho từng bước

### **2. Insights Reports (Báo cáo Insights)**
- `customer_insights.md`: Customer behavior insights (Insights hành vi khách hàng)
- `product_insights.md`: Product performance insights (Insights hiệu suất sản phẩm)
- `sales_insights.md`: Sales channel insights (Insights kênh bán hàng)
- `recommendations.md`: Actionable recommendations (Khuyến nghị có thể thực hiện)

### **3. Data Visualizations (Trực quan hóa Dữ liệu)**
- Interactive dashboards (Bảng điều khiển tương tác)
- Executive summary charts (Biểu đồ tóm tắt điều hành)
- Detailed analysis plots (Biểu đồ phân tích chi tiết)
- Export-ready visualizations (Trực quan hóa sẵn sàng xuất)

### **4. Action Plans (Kế hoạch Hành động)**
- Priority matrix for recommendations (Ma trận ưu tiên cho khuyến nghị)
- Implementation timeline (Thời gian thực hiện)
- Resource requirements (Yêu cầu tài nguyên)
- Success metrics (Chỉ số thành công)

---

## **TIMELINE (Thời gian thực hiện)**

### **Week 1-2: Data Understanding (Hiểu dữ liệu)**
- EDA_Overview.ipynb - Tổng quan Gold layer
- EDA_Business_Metrics.ipynb - KPI cơ bản với 40,236 orders

### **Week 3-4: Deep Dive Analysis (Phân tích sâu)**
- EDA_Customer_Deep_Dive.ipynb - RFM, segmentation với dim_customers
- EDA_Product_Deep_Dive.ipynb - 37 products, 46,611 items analysis

### **Week 5-6: Operational & Predictive Analysis (Phân tích vận hành và dự đoán)**
- EDA_Operational_Analytics.ipynb - Warehouse, payment, shipping analysis
- EDA_Predictive_Insights.ipynb - Time-series với dim_date

### **Week 7-8: Business Intelligence & Reporting (Thông tin kinh doanh và báo cáo)**
- EDA_Business_Intelligence.ipynb - Tổng hợp insights
- Insights documentation (Tài liệu insights)
- Executive presentation (Thuyết trình điều hành)

---

## **SUCCESS METRICS (Chỉ số Thành công)**

### **Technical Success (Thành công Kỹ thuật)**
- Data quality score > 95% (Điểm chất lượng dữ liệu > 95%)
- Analysis reproducibility = 100% (Khả năng tái tạo phân tích = 100%)
- Code documentation completeness = 100% (Hoàn thiện tài liệu code = 100%)

### **Business Success (Thành công Kinh doanh)**
- Actionable insights generated > 20 (Insights có thể thực hiện được tạo ra > 20)
- Implementation rate of recommendations > 80% (Tỷ lệ thực hiện khuyến nghị > 80%)
- Business impact measurable within 3 months (Tác động kinh doanh có thể đo lường trong 3 tháng)

---

*Lộ trình này được thiết kế bởi Data Analytics Expert (Chuyên gia Phân tích Dữ liệu) để đảm bảo phân tích toàn diện và actionable insights (insights có thể thực hiện) cho Winner Group Analytics.*