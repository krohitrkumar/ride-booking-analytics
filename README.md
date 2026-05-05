# 🚗 Ride Booking Analytics (SQL Project)

## 📌 Overview

This project presents a comprehensive analysis of a ride-booking dataset using **PostgreSQL**. The objective is to uncover patterns in ride completion, revenue generation, customer behavior, and operational inefficiencies through structured SQL workflows.

The project follows a complete **data pipeline approach** — from raw data ingestion to final business insights — simulating a real-world analytics workflow.

---

## 🎯 Objectives

* Analyze ride completion and failure patterns
* Understand revenue distribution across payment methods and vehicle types
* Identify peak demand hours and usage trends
* Evaluate customer contribution to overall revenue
* Assess service quality using rating distributions
* Detect operational inefficiencies (e.g., driver cancellations)

---

## 🗂️ Dataset Description

The dataset contains ride-level transactional data with the following key attributes:

* `booking_id` – Unique ride identifier
* `customer_id` – User identifier
* `booking_status` – Ride outcome (completed, cancelled, etc.)
* `ride_timestamp` – Date and time of ride
* `vehicle_type` – Type of ride selected
* `pickup_location`, `drop_location` – Ride locations
* `booking_value` – Revenue generated per ride
* `ride_distance` – Distance of ride
* `driver_rating`, `customer_rating` – Ratings
* `payment_method` – Mode of payment

---

## ⚙️ Project Workflow

```text
Raw Data → Cleaning → Transformation → Final Table → Validation 
→ Feature Engineering → Views → Analysis → Insights
```

### 1. Data Cleaning

* Standardized text fields (lowercase, trimmed, formatted)
* Converted invalid values (`'null'`, empty strings) to SQL NULL
* Created unified timestamp (`ride_timestamp`)

### 2. Transformation

* Converted numeric fields from TEXT → FLOAT safely
* Built structured table (`rides`) for analysis

### 3. Final Table Creation

* Deduplicated rides using window functions
* Created `rides_final` (one row per booking_id)

### 4. Validation

* Checked duplicates, null values, and inconsistencies
* Ensured data integrity for completed rides

### 5. Feature Engineering

* Handled missing values (e.g., payment method)
* Created performance indexes for faster querying

### 6. Analytical Views

Reusable SQL views were created for:

* KPI metrics
* Time-based analysis
* Payment insights
* Customer statistics
* Cancellation patterns
* Rating vs revenue relationships

---

## 📊 Key Insights

### 🚦 Ride Completion

* Only **62.21% of rides are completed**
* ~38% of rides fail, indicating operational inefficiency
* **Driver cancellations (~47%)** are the biggest contributor

👉 *Insight:* Problem lies in **supply-side reliability**, not customer behavior

---

### 💳 Payment Trends

* **UPI contributes ~45% of total revenue**
* Cash (~25%) is still significant
* Digital payments dominate overall

👉 *Insight:* Strong user preference for **cashless transactions**

---

### ⏰ Demand Patterns

* Peak demand: **5 PM – 8 PM (highest at 6 PM)**
* Lowest demand: **1 AM – 5 AM**

👉 *Insight:* Clear **commuting behavior pattern**

---

### 💰 Revenue Distribution

* Revenue closely follows ride volume
* No significant high-value time slots outside peak hours

👉 *Insight:* Revenue driven by **volume, not pricing differences**

---

### 🚘 Vehicle Usage

* **Auto & Go Mini dominate (~45% combined rides)**
* Premium rides contribute <3%

👉 *Insight:* Platform is driven by **affordable ride options**

---

### 👥 Customer Contribution

* Top 10 customers contribute only **~9.2% of revenue**

👉 *Insight:* Revenue is **well distributed**, not dependent on few users

---

### 📍 Location Analysis

* No single pickup location dominates (<1% each)

👉 *Insight:* Demand is **geographically distributed**

---

### ❌ Cancellation Breakdown

* Driver cancellations (~47%)
* No driver found (~18%)
* Customer cancellations (~18%)

👉 *Insight:* Over **65% failures are supply-side issues**

---

### ⭐ Ratings

* Ratings concentrated between **4.0 – 4.6**
* Very few low ratings

👉 *Insight:* **High service quality**, but poor availability

---

### 🔥 Final Combined Insight

> Despite high driver ratings, the platform experiences a relatively low completion rate.
> This indicates a gap between **service quality (post-ride experience)** and
> **operational efficiency (ride fulfillment and driver availability)**.

---

## 🛠️ Tech Stack

* **PostgreSQL**
* **SQL (Advanced)**
* **pgAdmin**
* **Git & GitHub**

---

## 📁 Project Structure

```text
ride-booking-analytics/
│
├── data/
│   └── rides_raw_data.csv
│
├── sql/
│   ├── 01_table_creation.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_transformation.sql
│   ├── 04_final_tables.sql
│   ├── 05_validation.sql
│   ├── 06_feature_engineering.sql
│   ├── 07_views.sql
│   └── 08_analysis_and_insights.sql
│
├── README.md
└── .gitignore
```

---

## 🚀 How to Run

1. Import dataset into PostgreSQL using pgAdmin
2. Execute SQL files in order:

   * Table creation → Cleaning → Transformation → Final tables
   * Validation → Feature engineering → Views → Analysis
3. Review outputs and insights

---

## 📌 Future Improvements

* Add dashboard visualization (Power BI / Tableau)
* Implement predictive modeling (demand forecasting)
* Optimize driver allocation strategies
* Real-time analytics pipeline

---

## 👨‍💻 Author

**Rohit Kumar**

---

## ⭐ If you found this useful

Give it a ⭐ on GitHub!
