# Lộ trình EDA (Exploratory Data Analysis) - Winner Group Analytics
## Data Analytics Expert Plan (Kế hoạch Chuyên gia Phân tích Dữ liệu)

---

## **TỔNG QUAN DỰ ÁN**

### **Mục tiêu chính (Primary Objectives)**

1. **Hiểu rõ bức tranh toàn cảnh doanh nghiệp** - Understanding complete business picture
2. **Phân tích xu hướng phát triển 4 năm** - Analyzing 4-year development trends (2021-2025)
3. **Khám phá patterns và insights ẩn** - Discovering hidden patterns and insights
4. **Xây dựng foundation cho phân tích sâu** - Building foundation for deep analysis

### **Phạm vi phân tích (Analysis Scope)**

- **Thời gian**: 2021-12-30 đến 2025-08-16 (gần 4 năm dữ liệu)
- **Đối tượng**: 40,236 đơn hàng, 46,611 items, 37 sản phẩm, 1 cửa hàng Winner Group
- **Kiến trúc**: Star Schema với 2 fact tables và 8 dimension tables
- **Địa lý**: Tập trung Hà Nội (warehouse locations)
- **Thanh toán**: 99% COD, các phương thức khác chiếm 1%
- **Phương pháp**: Comprehensive business intelligence analysis
- **Công cụ**: Python, SQL, Statistical Analysis, Time Series Analysis

---

## **GIAI ĐOẠN 1: EDA PHÂN TÍCH (EXPLORATORY DATA ANALYSIS)**

### **1.1 EDA_Overview.ipynb - Tổng quan Dataset**

#### **Mục tiêu (Objectives)**
- Đánh giá chất lượng dữ liệu tổng thể
- Hiểu cấu trúc và quy mô dataset qua 4 năm
- Xác định các vấn đề dữ liệu cần xử lý

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Dữ liệu có đầy đủ và chính xác không?
- Có gaps nào trong timeline 4 năm không?
- Dữ liệu có đủ để phân tích toàn diện không?
- Có outliers hoặc anomalies nào cần chú ý không?

#### **Nội dung phân tích (Analysis Content)**

```python
# 1. Data Quality Assessment (Đánh giá chất lượng dữ liệu)
- Missing values analysis across all tables
- Data consistency check between fact and dimension tables
- Data type validation and conversion
- Outlier identification in key metrics
- Data completeness by time period

# 2. Dataset Structure (Cấu trúc Dataset)
- Star Schema relationships mapping
- Fact tables: fact_orders (40,236), fact_order_items (46,611)
- Dimension tables: 8 tables with complete relationships
- Data volume analysis by year/month
- Time range coverage: 2021-2025 (4 years)
- Geographic coverage: Hà Nội focused

# 3. Business Metrics Overview (Tổng quan chỉ số kinh doanh)
- Total orders: 40,236 đơn hàng
- Total items: 46,611 items  
- Total products: 37 sản phẩm
- Total customers: Từ dim_customers
- Revenue trends over 4 years
- Growth patterns and seasonality
```

---

### **1.2 EDA_Business_Metrics.ipynb - Chỉ số Kinh doanh Cơ bản**

#### **Mục tiêu (Objectives)**
- Tính toán các KPI cơ bản của e-commerce qua 4 năm
- Phân tích xu hướng doanh thu và đơn hàng theo thời gian
- Đánh giá hiệu suất kinh doanh tổng thể

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Doanh thu có tăng trưởng ổn định qua 4 năm không?
- Tháng nào/năm nào bán chạy nhất? Tại sao?
- Giá trị đơn hàng trung bình có thay đổi theo thời gian không?
- Có mùa vụ nào đặc biệt trong năm không?
- Tỷ lệ hoàn thành đơn hàng như thế nào?

#### **Chỉ số phân tích (Key Performance Indicators)**

##### **A. Revenue Metrics (Chỉ số Doanh thu)**

```python
# 1. Total Revenue (Tổng doanh thu)
total_revenue = SUM(total_price)  # Sử dụng total_price từ fact_orders

# 2. Revenue after Discount (Doanh thu sau giảm giá)
revenue_after_discount = SUM(total_price_after_sub_discount)

# 3. Average Order Value - AOV (Giá trị đơn hàng trung bình)
aov = total_revenue / total_orders

# 4. Revenue Growth Rate (Tỷ lệ tăng trưởng doanh thu)
revenue_growth = (current_period_revenue - previous_period_revenue) / previous_period_revenue * 100

# 5. Monthly Revenue Trends (Xu hướng doanh thu hàng tháng)
monthly_revenue = SUM(total_price) GROUP BY year, month

# 6. Discount Impact Analysis (Phân tích tác động giảm giá)
total_discount = SUM(total_discount)
discount_rate = total_discount / total_revenue * 100
```

##### **B. Order Metrics (Chỉ số Đơn hàng)**

```python
# 1. Total Orders (Tổng số đơn hàng)
total_orders = COUNT(DISTINCT order_id)

# 2. Orders per Customer (Số đơn hàng trên mỗi khách hàng)
orders_per_customer = total_orders / total_customers

# 3. Order Status Analysis (Phân tích trạng thái đơn hàng)
order_status_dist = COUNT(*) GROUP BY status_name

# 4. Order Frequency (Tần suất đặt hàng)
order_frequency = total_orders / (days_in_period * total_customers)

# 5. Order Value Distribution (Phân phối giá trị đơn hàng)
order_value_segments = categorize_orders_by_value()

# 6. Order Completion Rate (Tỷ lệ hoàn thành đơn hàng)
completion_rate = completed_orders / total_orders * 100
```

##### **C. Customer Metrics (Chỉ số Khách hàng)**

```python
# 1. Total Customers (Tổng số khách hàng)
total_customers = COUNT(DISTINCT customer_id)

# 2. New Customers (Khách hàng mới)
new_customers = COUNT(DISTINCT customer_id WHERE first_order_date = current_period)

# 3. Customer Acquisition Rate (Tỷ lệ thu hút khách hàng mới)
acquisition_rate = new_customers / total_customers * 100

# 4. Customer Value Analysis (Phân tích giá trị khách hàng)
customer_value = SUM(total_price) GROUP BY customer_id

# 5. Gender Distribution (Phân bố giới tính)
gender_dist = COUNT(*) GROUP BY gender

# 6. Customer Geographic Distribution (Phân bố địa lý khách hàng)
geo_dist = COUNT(*) GROUP BY address_province_id
```

---

### **1.3 EDA_Customer_Deep_Dive.ipynb - Phân tích Khách hàng Sâu**

#### **Mục tiêu (Objectives)**
- Phân tích hành vi mua sắm của khách hàng qua 4 năm
- Xây dựng customer segmentation dựa trên dữ liệu thực tế
- Thực hiện RFM Analysis với dữ liệu lịch sử
- Phát hiện customer lifetime value patterns

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Khách hàng nào có giá trị cao nhất qua 4 năm?
- Tại sao một số khách hàng rời bỏ? Khi nào?
- Khách hàng mới có xu hướng gì? Có trở thành khách hàng trung thành không?
- Phân khúc nào mang lại lợi nhuận cao nhất?
- Có sự khác biệt về hành vi mua giữa Nam và Nữ không?
- Khách hàng ở địa phương nào có giá trị cao nhất?

#### **Nội dung phân tích (Analysis Content)**

##### **A. RFM Analysis (Recency, Frequency, Monetary)**

```python
# RFM Scoring System dựa trên dữ liệu 4 năm
# Recency: Số ngày từ lần mua cuối
recency = DATEDIFF(current_date, last_order_date)

# Frequency: Số lần mua hàng
frequency = COUNT(DISTINCT order_id)

# Monetary: Tổng giá trị mua hàng
monetary = SUM(total_price)

# RFM Score Calculation (1-5 scale) - Điều chỉnh cho dữ liệu 4 năm
def calculate_rfm_score(value, metric_type):
    if metric_type == 'recency':
        # Recency: Càng gần đây càng cao điểm
        return 5 if value <= 30 else 4 if value <= 90 else 3 if value <= 180 else 2 if value <= 365 else 1
    elif metric_type == 'frequency':
        # Frequency: Càng nhiều lần càng cao điểm
        return 5 if value >= 10 else 4 if value >= 5 else 3 if value >= 3 else 2 if value >= 2 else 1
    elif metric_type == 'monetary':
        # Monetary: Càng chi nhiều càng cao điểm
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

# 6. Geographic Segments (Phân khúc địa lý)
hanoi_customers = customers WHERE address_province_id = 'Hanoi'
other_provinces = customers WHERE address_province_id != 'Hanoi'
```

##### **C. Customer Lifetime Value (CLV)**

```python
# CLV Calculation dựa trên dữ liệu 4 năm
# Method 1: Simple CLV
clv_simple = (average_order_value * purchase_frequency * customer_lifespan)

# Method 2: RFM-based CLV
clv_rfm = (rfm_score / 15) * average_order_value * 12

# Method 3: Historical CLV
clv_historical = total_customer_revenue / customer_age_in_days * 365
```

##### **D. Behavioral Analysis (Phân tích hành vi)**

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
- Customer acquisition channels (Kênh thu hút khách hàng)
- Customer value by demographics (Giá trị khách hàng theo nhân khẩu học)
```

---

### **1.4 EDA_Product_Deep_Dive.ipynb - Phân tích Sản phẩm Sâu**

#### **Mục tiêu (Objectives)**
- Phân tích hiệu suất 37 sản phẩm qua 4 năm
- Xác định best sellers và slow movers
- Phân tích inventory turnover
- Tối ưu hóa product mix

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Sản phẩm nào bán chạy nhất qua 4 năm? Tại sao?
- Category nào (nhân viên phụ trách) có hiệu suất tốt nhất?
- Sản phẩm nào có xu hướng tăng/giảm theo thời gian?
- Có sản phẩm nào cần ngừng bán không?
- Cross-selling opportunities ở đâu?
- Sản phẩm nào có margin tốt nhất?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Product Performance Metrics (Chỉ số hiệu suất sản phẩm)**

```python
# 1. Best Sellers (Sản phẩm bán chạy)
best_sellers = products ORDER BY total_quantity_sold DESC

# 2. Revenue Leaders (Sản phẩm dẫn đầu doanh thu)
revenue_leaders = products ORDER BY total_revenue DESC

# 3. Product Velocity (Tốc độ bán)
product_velocity = total_quantity_sold / days_active

# 4. Sell-through Rate (Tỷ lệ bán hết)
sell_through_rate = quantity_sold / (quantity_sold + remain_quantity) * 100

# 5. Product Lifecycle Analysis (Phân tích vòng đời sản phẩm)
product_lifecycle = analyze_product_performance_over_time()
```

##### **B. Category Analysis (Phân tích danh mục - Nhân viên phụ trách)**

```python
# 1. Category Performance (Hiệu suất danh mục)
category_revenue = SUM(total_price) GROUP BY category_name
category_growth = (current_period_revenue - previous_period_revenue) / previous_period_revenue

# 2. Category Mix Analysis (Phân tích hỗn hợp danh mục)
category_mix = category_revenue / total_revenue * 100

# 3. Cross-category Purchase Patterns (Mẫu mua hàng liên danh mục)
cross_category_analysis = analyze_customer_purchase_across_categories()

# 4. Category Trends Over Time (Xu hướng danh mục theo thời gian)
category_trends = analyze_category_performance_by_time()
```

##### **C. Product Lifecycle Analysis (Phân tích vòng đời sản phẩm)**

```python
# 1. Product Lifecycle Stages (Các giai đoạn vòng đời sản phẩm)
- Introduction: New products (< 30 days)
- Growth: Growing products (30-90 days, increasing sales)
- Maturity: Stable products (90+ days, stable sales)
- Decline: Declining products (decreasing sales trend)

# 2. Seasonal Product Analysis (Phân tích sản phẩm theo mùa)
seasonal_patterns = analyze_seasonal_sales_patterns()

# 3. Product Cannibalization (Sự thay thế sản phẩm)
cannibalization_analysis = analyze_product_substitution_effects()
```

---

### **1.5 EDA_Operational_Analytics.ipynb - Phân tích Vận hành**

#### **Mục tiêu (Objectives)**
- Phân tích hiệu suất warehouse và shipping
- Phân tích payment methods và success rate
- Phân tích order fulfillment process
- Phân tích customer service metrics

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Kho nào hoạt động hiệu quả nhất? Tại sao?
- Tại sao 99% thanh toán bằng COD? Có vấn đề gì không?
- Thời gian xử lý đơn hàng trung bình là bao lâu?
- Có bottleneck nào trong quy trình không?
- Tỷ lệ hoàn thành đơn hàng như thế nào?
- Có mối liên hệ nào giữa warehouse và customer satisfaction không?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Warehouse Performance Metrics (Chỉ số hiệu suất kho)**

```python
# 1. Warehouse Utilization (Sử dụng kho)
warehouse_utilization = orders_per_warehouse / warehouse_capacity

# 2. Geographic Distribution (Phân bố địa lý)
geo_distribution = orders_by_warehouse_location()

# 3. Warehouse Revenue Analysis (Phân tích doanh thu theo kho)
warehouse_revenue = SUM(total_price) GROUP BY warehouse_id

# 4. Warehouse Efficiency Trends (Xu hướng hiệu quả kho)
warehouse_efficiency = analyze_warehouse_performance_over_time()
```

##### **B. Payment Analysis (Phân tích thanh toán)**

```python
# 1. Payment Methods Distribution (Phân bố phương thức thanh toán)
payment_methods = payment_type_distribution()
# COD: 99%, Card: X%, Momo: X%, QRPay: X%

# 2. Payment Success Rate (Tỷ lệ thanh toán thành công)
payment_success_rate = successful_payments / total_payments * 100

# 3. Payment Timing Analysis (Phân tích thời gian thanh toán)
payment_timing = time_to_payment_analysis()

# 4. COD vs Other Methods Analysis (Phân tích COD vs các phương thức khác)
cod_analysis = analyze_cod_performance_vs_others()
```

##### **C. Order Fulfillment Analysis (Phân tích thực hiện đơn hàng)**

```python
# 1. Order Status Distribution (Phân bố trạng thái đơn hàng)
order_status_dist = order_status_breakdown()

# 2. Fulfillment Time Analysis (Phân tích thời gian thực hiện)
fulfillment_time = order_to_delivery_time()
# Sử dụng inserted_at và updated_at để tính thời gian xử lý

# 3. Return Rate Analysis (Phân tích tỷ lệ trả hàng)
return_rate = returned_orders / total_orders * 100

# 4. Order Processing Efficiency (Hiệu quả xử lý đơn hàng)
processing_efficiency = analyze_order_processing_times()
```

---

### **1.6 EDA_Time_Series_Analysis.ipynb - Phân tích Chuỗi Thời gian**

#### **Mục tiêu (Objectives)**
- Phân tích xu hướng dài hạn qua 4 năm
- Phát hiện seasonal patterns
- Dự đoán xu hướng tương lai
- Phân tích cyclical patterns

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Doanh thu có xu hướng tăng trưởng ổn định không?
- Có mùa vụ nào đặc biệt trong năm không?
- Có chu kỳ nào lặp lại hàng năm không?
- Xu hướng nào có thể dự đoán được?
- Có sự kiện nào ảnh hưởng đến doanh thu không?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Trend Analysis (Phân tích xu hướng)**

```python
# 1. Revenue Trend (Xu hướng doanh thu)
revenue_trend = analyze_revenue_trend_over_time()

# 2. Order Volume Trend (Xu hướng khối lượng đơn hàng)
order_volume_trend = analyze_order_volume_trend()

# 3. Customer Growth Trend (Xu hướng tăng trưởng khách hàng)
customer_growth_trend = analyze_customer_growth_trend()

# 4. Product Performance Trend (Xu hướng hiệu suất sản phẩm)
product_performance_trend = analyze_product_performance_trend()
```

##### **B. Seasonal Analysis (Phân tích theo mùa)**

```python
# 1. Monthly Patterns (Mẫu hàng tháng)
monthly_patterns = analyze_monthly_sales_patterns()

# 2. Quarterly Analysis (Phân tích theo quý)
quarterly_analysis = analyze_quarterly_performance()

# 3. Holiday Impact (Tác động ngày lễ)
holiday_impact = analyze_holiday_sales_impact()

# 4. Weekend vs Weekday (Cuối tuần vs Ngày thường)
weekend_analysis = analyze_weekend_vs_weekday_patterns()
```

##### **C. Forecasting (Dự báo)**

```python
# 1. Sales Forecasting (Dự báo bán hàng)
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.arima.model import ARIMA

# Decompose time series
decomposition = seasonal_decompose(sales_data, model='additive')

# ARIMA Model for forecasting
model = ARIMA(sales_data, order=(1,1,1))
forecast = model.fit().forecast(steps=30)

# 2. Demand Forecasting (Dự báo nhu cầu)
demand_forecast = predict_product_demand()

# 3. Customer Growth Forecasting (Dự báo tăng trưởng khách hàng)
customer_forecast = predict_customer_growth()
```

---

### **1.7 EDA_Business_Intelligence.ipynb - Business Intelligence**

#### **Mục tiêu (Objectives)**
- Tổng hợp insights từ tất cả phân tích
- Tạo actionable recommendations
- Phân tích competitive advantage
- Định hướng chiến lược kinh doanh

#### **Key Questions to Answer (Câu hỏi chính cần trả lời)**
- Bức tranh toàn cảnh doanh nghiệp như thế nào?
- Điểm mạnh và điểm yếu chính là gì?
- Cơ hội tăng trưởng nào có thể nắm bắt?
- Rủi ro nào cần chú ý?
- Chiến lược nào nên ưu tiên?

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
    'retention_rate': customer_retention_rate,
    'top_products': top_5_products,
    'top_customers': top_5_customers
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

##### **C. Business Insights (Insights kinh doanh)**

```python
# 1. Customer Insights (Insights khách hàng)
customer_insights = {
    'vip_customers': vip_customer_analysis,
    'churn_risk': churn_risk_analysis,
    'acquisition_channels': acquisition_channel_analysis,
    'geographic_distribution': geographic_insights
}

# 2. Product Insights (Insights sản phẩm)
product_insights = {
    'best_sellers': best_seller_analysis,
    'category_performance': category_performance_analysis,
    'inventory_optimization': inventory_insights,
    'pricing_strategy': pricing_insights
}

# 3. Operational Insights (Insights vận hành)
operational_insights = {
    'warehouse_efficiency': warehouse_insights,
    'payment_optimization': payment_insights,
    'fulfillment_improvement': fulfillment_insights,
    'cost_optimization': cost_insights
}
```

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

### **2. Revenue Metrics (Chỉ số Doanh thu)**

#### **Revenue Growth Rate (Tỷ lệ tăng trưởng doanh thu)**
```
Growth Rate = (Current Period Revenue - Previous Period Revenue) / Previous Period Revenue × 100
```

#### **Average Order Value (AOV) (Giá trị đơn hàng trung bình)**
```
AOV = Total Revenue / Total Orders
```

### **3. Product Metrics (Chỉ số Sản phẩm)**

#### **Product Velocity (Tốc độ sản phẩm)**
```
Product Velocity = Units Sold / Days Active
```

#### **Sell-through Rate (Tỷ lệ bán hết)**
```
Sell-through Rate = Units Sold / (Units Sold + Units Remaining) × 100
```

---

## **TIMELINE (Thời gian thực hiện)**

### **Week 1-2: Data Understanding (Hiểu dữ liệu)**
- EDA_Overview.ipynb - Tổng quan Gold layer
- EDA_Business_Metrics.ipynb - KPI cơ bản với 40,236 orders

### **Week 3-4: Deep Dive Analysis (Phân tích sâu)**
- EDA_Customer_Deep_Dive.ipynb - RFM, segmentation với dim_customers
- EDA_Product_Deep_Dive.ipynb - 37 products, 46,611 items analysis

### **Week 5-6: Operational & Time Series Analysis (Phân tích vận hành và chuỗi thời gian)**
- EDA_Operational_Analytics.ipynb - Warehouse, payment, shipping analysis
- EDA_Time_Series_Analysis.ipynb - Time-series với dim_date

### **Week 7-8: Business Intelligence & Reporting (Thông tin kinh doanh và báo cáo)**
- EDA_Business_Intelligence.ipynb - Tổng hợp insights
- Insights documentation (Tài liệu insights)
- Executive presentation (Thuyết trình điều hành)

---

## **SUCCESS METRICS (Chỉ số Thành công)**

### **Technical Success (Thành công Kỹ thuật)**
- Data quality score > 95%
- Analysis reproducibility = 100%
- Code documentation completeness = 100%

### **Business Success (Thành công Kinh doanh)**
- Actionable insights generated > 20
- Complete business picture understanding
- 4-year trend analysis completed
- Strategic recommendations provided

---

## **GIAI ĐOẠN 2: PHÂN TÍCH NÂNG CAO (ADVANCED ANALYTICS)**

### **2.1 Dự báo Doanh thu và Nhu cầu (Sales & Demand Forecasting)**

#### **Mục tiêu (Objectives)**
- Dự báo doanh thu 6-12 tháng tới dựa trên dữ liệu 4 năm
- Dự báo nhu cầu cho 37 sản phẩm
- Phân tích xu hướng theo mùa và chu kỳ
- Tối ưu hóa kế hoạch kinh doanh

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Doanh thu sẽ tăng trưởng như thế nào trong 6 tháng tới?
- Sản phẩm nào sẽ có nhu cầu cao nhất?
- Có mùa vụ nào cần chuẩn bị trước không?
- Làm sao để tối ưu hóa inventory cho 37 sản phẩm?
- Có cơ hội tăng trưởng nào có thể nắm bắt?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Dự báo Doanh thu (Revenue Forecasting)**

```python
# 1. Time Series Analysis với dữ liệu 4 năm (2021-2025)
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.arima.model import ARIMA
from prophet import Prophet

# Phân tích xu hướng doanh thu theo tháng
monthly_revenue = df_orders.groupby(['year', 'month'])['total_price'].sum()

# Decompose time series để tách trend, seasonal, residual
decomposition = seasonal_decompose(monthly_revenue, model='additive')

# ARIMA Model cho dự báo ngắn hạn (3-6 tháng)
arima_model = ARIMA(monthly_revenue, order=(1,1,1))
arima_forecast = arima_model.fit().forecast(steps=6)

# Prophet Model cho dự báo dài hạn (6-12 tháng)
prophet_model = Prophet()
prophet_forecast = prophet_model.fit(monthly_revenue).predict(future_periods=12)

# 2. Dự báo theo Warehouse (Hà Nội)
warehouse_revenue_forecast = forecast_by_warehouse_location()

# 3. Dự báo theo Payment Method (COD vs Others)
payment_method_forecast = forecast_by_payment_method()
```

##### **B. Dự báo Nhu cầu Sản phẩm (Product Demand Forecasting)**

```python
# 1. Dự báo nhu cầu cho 37 sản phẩm
product_demand_forecast = {}
for product_id in df_products['product_id']:
    product_sales = df_order_items[df_order_items['product_id'] == product_id]
    monthly_demand = product_sales.groupby(['year', 'month'])['quantity'].sum()
    
    # ARIMA cho từng sản phẩm
    product_model = ARIMA(monthly_demand, order=(1,1,1))
    product_forecast = product_model.fit().forecast(steps=6)
    
    product_demand_forecast[product_id] = product_forecast

# 2. Dự báo theo Category (Nhân viên phụ trách)
category_demand_forecast = forecast_by_category_performance()

# 3. Seasonal Product Analysis
seasonal_products = identify_seasonal_products()
```

##### **C. Phân tích Xu hướng và Mùa vụ (Trend & Seasonal Analysis)**

```python
# 1. Seasonal Decomposition
seasonal_patterns = analyze_seasonal_patterns_by_product()

# 2. Holiday Impact Analysis
holiday_impact = analyze_holiday_sales_impact()
# Tết, 8/3, 20/10, Black Friday, 11/11, Giáng sinh

# 3. Growth Rate Analysis
growth_rates = calculate_compound_annual_growth_rate()

# 4. Cyclical Patterns
cyclical_patterns = identify_cyclical_business_patterns()
```

---

### **2.2 Machine Learning và Phân đoạn Khách hàng (Customer Segmentation ML)**

#### **Mục tiêu (Objectives)**
- Xây dựng mô hình phân đoạn khách hàng tự động
- Dự đoán khách hàng có nguy cơ rời bỏ
- Tối ưu hóa chiến lược marketing cá nhân hóa
- Phân tích hành vi mua sắm phức tạp

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Làm sao để nhận diện khách hàng VIP tự động?
- Khách hàng nào có nguy cơ rời bỏ trong 3 tháng tới?
- Phân khúc nào nên được ưu tiên marketing?
- Có pattern nào ẩn trong hành vi mua sắm không?
- Làm sao để tăng customer lifetime value?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Customer Segmentation với Machine Learning**

```python
# 1. K-means Clustering cho Customer Segmentation
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# Chuẩn bị features cho clustering
customer_features = prepare_customer_features()
# - RFM scores (Recency, Frequency, Monetary)
# - Demographics (gender, age, location)
# - Behavioral patterns (purchase timing, product preferences)
# - Engagement metrics (order frequency, response rate)

# K-means clustering
kmeans = KMeans(n_clusters=5, random_state=42)
customer_segments = kmeans.fit_predict(customer_features)

# 2. Hierarchical Clustering
from sklearn.cluster import AgglomerativeClustering
hierarchical_clustering = AgglomerativeClustering(n_clusters=5)
hierarchical_segments = hierarchical_clustering.fit_predict(customer_features)

# 3. Customer Segment Analysis
segment_analysis = analyze_customer_segments()
```

##### **B. Churn Prediction (Dự đoán Khách hàng Rời bỏ)**

```python
# 1. Feature Engineering cho Churn Prediction
churn_features = prepare_churn_features()
# - Days since last order
# - Order frequency decline
# - Customer satisfaction indicators
# - Payment behavior changes
# - Product return patterns

# 2. Machine Learning Models
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC

# Random Forest cho churn prediction
rf_model = RandomForestClassifier(n_estimators=100, random_state=42)
rf_model.fit(X_train, y_train)
churn_probability = rf_model.predict_proba(X_test)

# 3. Model Evaluation
model_performance = evaluate_churn_prediction_models()

# 4. Churn Risk Scoring
churn_risk_scores = calculate_churn_risk_scores()
```

##### **C. Customer Lifetime Value Prediction (Dự đoán Giá trị Trọn đời)**

```python
# 1. CLV Prediction Models
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import GradientBoostingRegressor

# Features cho CLV prediction
clv_features = prepare_clv_features()
# - Historical purchase value
# - Purchase frequency
# - Customer age
# - Product diversity
# - Geographic factors

# 2. Regression Models
clv_model = GradientBoostingRegressor()
clv_model.fit(X_train, y_train)
predicted_clv = clv_model.predict(X_test)

# 3. CLV Segmentation
clv_segments = segment_customers_by_clv()
```

---

### **2.3 Hệ thống Gợi ý Sản phẩm (Product Recommendation System)**

#### **Mục tiêu (Objectives)**
- Xây dựng hệ thống gợi ý sản phẩm thông minh
- Tăng cross-selling và up-selling
- Cá nhân hóa trải nghiệm mua sắm
- Tối ưu hóa product mix

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Sản phẩm nào nên gợi ý cho khách hàng này?
- Làm sao để tăng giá trị đơn hàng trung bình?
- Có sản phẩm nào có thể cross-sell không?
- Làm sao để tối ưu hóa product recommendations?
- Có pattern nào trong việc mua kết hợp sản phẩm?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Collaborative Filtering (Lọc Cộng tác)**

```python
# 1. User-Item Matrix
user_item_matrix = create_user_item_matrix()
# Rows: customers, Columns: products, Values: purchase frequency/rating

# 2. Matrix Factorization
from sklearn.decomposition import NMF
nmf_model = NMF(n_components=10, random_state=42)
user_factors, item_factors = nmf_model.fit_transform(user_item_matrix)

# 3. Similarity-based Recommendations
from sklearn.metrics.pairwise import cosine_similarity
user_similarity = cosine_similarity(user_factors)
item_similarity = cosine_similarity(item_factors)
```

##### **B. Association Rules (Quy tắc Kết hợp)**

```python
# 1. Market Basket Analysis
from mlxtend.frequent_patterns import apriori, association_rules

# Frequent itemsets
frequent_itemsets = apriori(basket_data, min_support=0.01, use_colnames=True)

# Association rules
rules = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.5)

# 2. Product Bundling Analysis
product_bundles = analyze_product_bundling_patterns()

# 3. Cross-selling Opportunities
cross_selling_opportunities = identify_cross_selling_opportunities()
```

##### **C. Content-based Filtering (Lọc Nội dung)**

```python
# 1. Product Feature Engineering
product_features = prepare_product_features()
# - Category (nhân viên phụ trách)
# - Price range
# - Seasonal patterns
# - Customer ratings
# - Purchase frequency

# 2. Content Similarity
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

content_similarity = cosine_similarity(product_features)

# 3. Hybrid Recommendation System
hybrid_recommendations = combine_collaborative_and_content_based()
```

---

## **GIAI ĐOẠN 3: THÔNG TIN KINH DOANH (BUSINESS INTELLIGENCE)**

### **3.1 Dashboard và Báo cáo Tự động (Automated Dashboards & Reports)**

#### **Mục tiêu (Objectives)**
- Tạo dashboard thời gian thực cho lãnh đạo
- Tự động hóa báo cáo hàng ngày/tuần/tháng
- Giám sát KPI và cảnh báo sớm
- Cung cấp insights tức thời

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Làm sao để theo dõi hiệu suất kinh doanh real-time?
- KPI nào cần được giám sát liên tục?
- Làm sao để tự động phát hiện anomalies?
- Cần báo cáo nào cho từng cấp quản lý?
- Làm sao để tối ưu hóa decision-making process?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Executive Dashboard (Bảng điều khiển Điều hành)**

```python
# 1. Key Performance Indicators (KPI) Dashboard
executive_kpis = {
    'total_revenue': calculate_total_revenue(),
    'revenue_growth_rate': calculate_revenue_growth(),
    'total_customers': calculate_total_customers(),
    'customer_growth_rate': calculate_customer_growth(),
    'average_order_value': calculate_aov(),
    'order_completion_rate': calculate_completion_rate(),
    'top_products': get_top_products(),
    'customer_segments': get_customer_segment_distribution()
}

# 2. Real-time Monitoring
real_time_metrics = monitor_real_time_metrics()
# - Orders per hour
# - Revenue per hour
# - Customer acquisition rate
# - Payment success rate

# 3. Trend Analysis
trend_analysis = analyze_key_trends()
# - Revenue trends
# - Customer acquisition trends
# - Product performance trends
# - Seasonal patterns
```

##### **B. Operational Dashboard (Bảng điều khiển Vận hành)**

```python
# 1. Warehouse Performance Dashboard
warehouse_metrics = {
    'warehouse_utilization': calculate_warehouse_utilization(),
    'order_fulfillment_time': calculate_fulfillment_time(),
    'inventory_turnover': calculate_inventory_turnover(),
    'shipping_efficiency': calculate_shipping_efficiency()
}

# 2. Payment Analytics Dashboard
payment_metrics = {
    'payment_method_distribution': analyze_payment_methods(),
    'payment_success_rate': calculate_payment_success_rate(),
    'cod_vs_other_methods': analyze_cod_performance(),
    'payment_timing_analysis': analyze_payment_timing()
}

# 3. Customer Service Dashboard
customer_service_metrics = {
    'order_status_distribution': analyze_order_status(),
    'return_rate': calculate_return_rate(),
    'customer_satisfaction': measure_customer_satisfaction(),
    'response_time': measure_response_time()
}
```

##### **C. Automated Reporting System (Hệ thống Báo cáo Tự động)**

```python
# 1. Daily Reports
daily_reports = generate_daily_reports()
# - Daily sales summary
# - Top performing products
# - New customer acquisitions
# - Order status updates

# 2. Weekly Reports
weekly_reports = generate_weekly_reports()
# - Weekly revenue analysis
# - Customer segment performance
# - Product category analysis
# - Operational efficiency metrics

# 3. Monthly Reports
monthly_reports = generate_monthly_reports()
# - Monthly business review
# - Growth analysis
# - Strategic recommendations
# - Performance vs targets
```

---

### **3.2 Phân tích Cạnh tranh và Thị trường (Competitive & Market Analysis)**

#### **Mục tiêu (Objectives)**
- Phân tích vị thế cạnh tranh của Winner Group
- Xác định cơ hội thị trường mới
- Phân tích pricing strategy
- Đánh giá market share

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Winner Group có vị thế cạnh tranh như thế nào?
- Cơ hội thị trường nào chưa được khai thác?
- Pricing strategy có hiệu quả không?
- Làm sao để tăng market share?
- Đối thủ cạnh tranh có ưu thế gì?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Market Position Analysis (Phân tích Vị thế Thị trường)**

```python
# 1. Market Share Analysis
market_share_analysis = analyze_market_share()
# - Revenue share by product category
# - Customer acquisition rate vs market
# - Geographic market penetration
# - Customer retention vs competitors

# 2. Competitive Advantage Analysis
competitive_advantages = identify_competitive_advantages()
# - Unique selling propositions
# - Customer loyalty factors
# - Operational efficiency
# - Product differentiation

# 3. Market Opportunity Analysis
market_opportunities = identify_market_opportunities()
# - Underserved customer segments
# - New product opportunities
# - Geographic expansion
# - Pricing optimization
```

##### **B. Pricing Strategy Analysis (Phân tích Chiến lược Giá)**

```python
# 1. Price Elasticity Analysis
price_elasticity = analyze_price_elasticity()
# - Demand response to price changes
# - Optimal pricing points
# - Price sensitivity by customer segment
# - Competitive pricing analysis

# 2. Discount Impact Analysis
discount_impact = analyze_discount_impact()
# - Discount effectiveness
# - Customer acquisition cost
# - Revenue impact
# - Profit margin analysis

# 3. Dynamic Pricing Opportunities
dynamic_pricing = identify_dynamic_pricing_opportunities()
# - Seasonal pricing adjustments
# - Demand-based pricing
# - Customer segment pricing
# - Product lifecycle pricing
```

---

## **GIAI ĐOẠN 4: KỸ THUẬT DỮ LIỆU (DATA ENGINEERING)**

### **4.1 Tối ưu hóa Pipeline Dữ liệu (Data Pipeline Optimization)**

#### **Mục tiêu (Objectives)**
- Tối ưu hóa quy trình ETL từ Silver sang Gold
- Tự động hóa data quality monitoring
- Xây dựng real-time data processing
- Cải thiện performance và reliability

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Làm sao để tăng tốc độ xử lý dữ liệu?
- Có thể tự động hóa data quality checks không?
- Làm sao để xử lý dữ liệu real-time?
- Có thể cải thiện data pipeline performance không?
- Làm sao để đảm bảo data consistency?

#### **Nội dung phân tích (Analysis Content)**

##### **A. ETL Pipeline Optimization (Tối ưu hóa ETL)**

```python
# 1. Data Processing Optimization
etl_optimization = optimize_etl_pipeline()
# - Parallel processing
# - Memory optimization
# - Query optimization
# - Data compression

# 2. Data Quality Automation
data_quality_automation = automate_data_quality_checks()
# - Automated null detection
# - Data type validation
# - Outlier detection
# - Consistency checks

# 3. Incremental Processing
incremental_processing = implement_incremental_processing()
# - Delta processing
# - Change data capture
# - Incremental updates
# - Data versioning
```

##### **B. Real-time Data Processing (Xử lý Dữ liệu Thời gian Thực)**

```python
# 1. Stream Processing
stream_processing = implement_stream_processing()
# - Real-time order processing
# - Live customer analytics
# - Instant inventory updates
# - Real-time KPI monitoring

# 2. Data Pipeline Monitoring
pipeline_monitoring = monitor_data_pipeline()
# - Processing time monitoring
# - Error rate tracking
# - Data quality metrics
# - Performance alerts

# 3. Data Governance
data_governance = implement_data_governance()
# - Data lineage tracking
# - Access control
# - Data security
# - Compliance monitoring
```

---

### **4.2 Infrastructure và Cloud Migration (Hạ tầng và Chuyển đổi Cloud)**

#### **Mục tiêu (Objectives)**
- Chuyển đổi lên cloud platform
- Tối ưu hóa database performance
- Xây dựng scalable architecture
- Đảm bảo data security và compliance

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Làm sao để chuyển đổi lên cloud hiệu quả?
- Database nào phù hợp nhất cho analytics?
- Làm sao để scale hệ thống khi dữ liệu tăng?
- Có thể đảm bảo data security không?
- Làm sao để tối ưu hóa costs?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Cloud Architecture Design (Thiết kế Kiến trúc Cloud)**

```python
# 1. Cloud Platform Selection
cloud_platform = select_cloud_platform()
# - AWS vs Azure vs GCP
# - Cost analysis
# - Feature comparison
# - Migration strategy

# 2. Database Optimization
database_optimization = optimize_database()
# - Index optimization
# - Query performance tuning
# - Partitioning strategy
# - Caching implementation

# 3. Scalability Planning
scalability_planning = plan_scalability()
# - Horizontal scaling
# - Vertical scaling
# - Load balancing
# - Auto-scaling
```

##### **B. Security và Compliance (Bảo mật và Tuân thủ)**

```python
# 1. Data Security Implementation
data_security = implement_data_security()
# - Encryption at rest and in transit
# - Access control
# - Audit logging
# - Data masking

# 2. Compliance Framework
compliance_framework = implement_compliance()
# - GDPR compliance
# - Data retention policies
# - Privacy protection
# - Regulatory reporting

# 3. Backup và Disaster Recovery
backup_recovery = implement_backup_recovery()
# - Automated backups
# - Disaster recovery plan
# - Data replication
# - Business continuity
```

---

## **GIAI ĐOẠN 5: TRIỂN KHAI CHIẾN LƯỢC (STRATEGIC IMPLEMENTATION)**

### **5.1 Chiến lược Tăng trưởng (Growth Strategy)**

#### **Mục tiêu (Objectives)**
- Xây dựng chiến lược tăng trưởng dài hạn
- Tối ưu hóa customer acquisition
- Phát triển sản phẩm mới
- Mở rộng thị trường

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Làm sao để tăng trưởng doanh thu 20% mỗi năm?
- Khách hàng mới nên tập trung vào đâu?
- Sản phẩm nào nên phát triển thêm?
- Có thể mở rộng ra thị trường nào?
- Làm sao để tối ưu hóa marketing ROI?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Customer Acquisition Strategy (Chiến lược Thu hút Khách hàng)**

```python
# 1. Customer Acquisition Cost Optimization
cac_optimization = optimize_customer_acquisition_cost()
# - Channel performance analysis
# - Cost per acquisition by channel
# - Conversion rate optimization
# - ROI by marketing channel

# 2. Target Customer Identification
target_customers = identify_target_customers()
# - Demographic analysis
# - Behavioral patterns
# - Geographic concentration
# - Psychographic profiling

# 3. Marketing Channel Optimization
marketing_optimization = optimize_marketing_channels()
# - Digital marketing performance
# - Social media effectiveness
# - Email marketing optimization
# - Referral program analysis
```

##### **B. Product Development Strategy (Chiến lược Phát triển Sản phẩm)**

```python
# 1. Product Portfolio Analysis
product_portfolio = analyze_product_portfolio()
# - Product lifecycle analysis
# - Market demand forecasting
# - Competitive positioning
# - Profit margin analysis

# 2. New Product Opportunities
new_product_opportunities = identify_new_product_opportunities()
# - Market gap analysis
# - Customer demand analysis
# - Competitive analysis
# - Feasibility assessment

# 3. Product Mix Optimization
product_mix_optimization = optimize_product_mix()
# - Cross-selling opportunities
# - Bundle pricing strategy
# - Inventory optimization
# - Category expansion
```

---

### **5.2 Kế hoạch Triển khai (Implementation Plan)**

#### **Mục tiêu (Objectives)**
- Xây dựng roadmap triển khai chi tiết
- Phân bổ nguồn lực hiệu quả
- Đo lường success metrics
- Quản lý rủi ro và thay đổi

#### **Câu hỏi chính cần trả lời (Key Questions to Answer)**
- Lộ trình triển khai như thế nào?
- Cần nguồn lực gì cho từng giai đoạn?
- Làm sao để đo lường thành công?
- Rủi ro nào cần quản lý?
- Làm sao để đảm bảo adoption?

#### **Nội dung phân tích (Analysis Content)**

##### **A. Implementation Roadmap (Lộ trình Triển khai)**

```python
# 1. Phase-by-Phase Implementation
implementation_phases = {
    'Phase 1': {
        'duration': '3 months',
        'focus': 'Data Foundation & EDA',
        'deliverables': ['Data Quality', 'EDA Reports', 'Initial Insights'],
        'resources': ['Data Analysts', 'Business Analysts'],
        'budget': 'X VND'
    },
    'Phase 2': {
        'duration': '4 months',
        'focus': 'Advanced Analytics & ML',
        'deliverables': ['Predictive Models', 'ML Pipelines', 'Automation'],
        'resources': ['Data Scientists', 'ML Engineers'],
        'budget': 'Y VND'
    },
    'Phase 3': {
        'duration': '3 months',
        'focus': 'BI & Dashboards',
        'deliverables': ['Dashboards', 'Reports', 'Monitoring'],
        'resources': ['BI Developers', 'UI/UX Designers'],
        'budget': 'Z VND'
    },
    'Phase 4': {
        'duration': '4 months',
        'focus': 'Data Engineering & Infrastructure',
        'deliverables': ['Cloud Migration', 'ETL Optimization', 'Security'],
        'resources': ['Data Engineers', 'DevOps Engineers'],
        'budget': 'W VND'
    },
    'Phase 5': {
        'duration': '2 months',
        'focus': 'Strategy & Implementation',
        'deliverables': ['Growth Strategy', 'Implementation Plan', 'Training'],
        'resources': ['Strategy Consultants', 'Change Managers'],
        'budget': 'V VND'
    }
}

# 2. Resource Allocation
resource_allocation = allocate_resources()
# - Human resources
# - Technology resources
# - Budget allocation
# - Timeline management

# 3. Risk Management
risk_management = manage_implementation_risks()
# - Technical risks
# - Business risks
# - Resource risks
# - Timeline risks
```

##### **B. Success Metrics và KPIs (Chỉ số Thành công)**

```python
# 1. Technical Success Metrics
technical_metrics = {
    'data_quality_score': '> 95%',
    'system_uptime': '> 99.9%',
    'processing_speed': '50% improvement',
    'automation_rate': '> 80%',
    'user_adoption': '> 90%'
}

# 2. Business Success Metrics
business_metrics = {
    'revenue_growth': '20% YoY',
    'customer_acquisition': '30% increase',
    'operational_efficiency': '25% improvement',
    'decision_speed': '50% faster',
    'cost_reduction': '15% savings'
}

# 3. ROI Calculation
roi_calculation = calculate_roi()
# - Investment cost
# - Expected returns
# - Payback period
# - Net present value
```

---

## **TỔNG KẾT VÀ DELIVERABLES**

### **Deliverables Kỹ thuật (Technical Deliverables)**
- ✅ **Giai đoạn 1**: EDA Reports, Data Quality Assessment, Business Insights
- 🔄 **Giai đoạn 2**: Predictive Models, ML Pipelines, Recommendation Systems
- 🔄 **Giai đoạn 3**: Interactive Dashboards, Automated Reports, Real-time Monitoring
- 🔄 **Giai đoạn 4**: Optimized Data Pipeline, Cloud Infrastructure, Security Framework
- 🔄 **Giai đoạn 5**: Growth Strategy, Implementation Plan, Change Management

### **Deliverables Kinh doanh (Business Deliverables)**
- ✅ **Giai đoạn 1**: Complete Business Picture, 4-year Trend Analysis, Strategic Insights
- 🔄 **Giai đoạn 2**: Forecasting Capabilities, Customer Segmentation, Product Recommendations
- 🔄 **Giai đoạn 3**: Real-time Business Intelligence, Automated Decision Support
- 🔄 **Giai đoạn 4**: Scalable Data Infrastructure, Cost Optimization
- 🔄 **Giai đoạn 5**: Growth Strategy, Market Expansion, Competitive Advantage

### **Timeline Tổng thể (Overall Timeline)**
- **Giai đoạn 1**: 8 tuần (EDA và Business Intelligence)
- **Giai đoạn 2**: 12 tuần (Advanced Analytics và ML)
- **Giai đoạn 3**: 8 tuần (BI Dashboards và Reporting)
- **Giai đoạn 4**: 10 tuần (Data Engineering và Infrastructure)
- **Giai đoạn 5**: 6 tuần (Strategic Implementation)
- **Tổng cộng**: 44 tuần (~11 tháng)

### **Investment và ROI (Đầu tư và Lợi nhuận)**
- **Tổng đầu tư**: X VND
- **ROI dự kiến**: 300-500% trong 2 năm
- **Payback period**: 8-12 tháng
- **NPV**: Y VND

---

*Lộ trình này được thiết kế để chuyển đổi Winner Group từ một doanh nghiệp dựa trên kinh nghiệm sang một doanh nghiệp dựa trên dữ liệu, với khả năng dự đoán, tối ưu hóa và tăng trưởng bền vững.*
