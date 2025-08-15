# 🚇 Namma Metro Ridership Data Analysis (MySQL)

## 📌 Project Overview
This project analyzes Bengaluru's Namma Metro ridership dataset using **MySQL** to generate actionable business insights.  
It demonstrates advanced SQL skills including:
- Common Table Expressions (CTEs)
- Window functions
- Rolling averages
- Anomaly detection
- Financial KPI calculations

The goal is to showcase **real-world data analysis skills** that bridge the gap between technical SQL and business decision-making.

---

## 📊 Dataset Description
**Source:** Namma Metro ridership data (sample)  
**Columns:**
- `record_date` – Date of transaction record
- `total_smart_cards` – Smart card rides
- `stored_value_card` – Stored value rides
- `one_day_pass` – 1-day pass rides
- `three_day_pass` – 3-day pass rides
- `five_day_pass` – 5-day pass rides
- `total_tokens` – Token rides
- `total_ncmc` – NCMC card rides
- `group_ticket` – Group ticket rides
- `total_qr` – Total QR ticket rides
- `qr_nammametro`, `qr_whatsapp`, `qr_paytm` – QR tickets by channel

---

## 🛠 Skills Demonstrated
- **SQL Aggregations**: SUM, AVG, ROUND
- **Date Functions**: DAYNAME, DATE_FORMAT, STR_TO_DATE
- **Conditional Logic**: CASE statements
- **Window Functions**: LAG, LEAD, ROWS BETWEEN
- **Statistical Measures**: Standard deviation, correlation
- **Financial Metrics**: Revenue calculation, growth rates

---

## 📈 Insights Generated
This analysis produced **20 business insights**, such as:
1. **Ridership Trends** – Track day-by-day ridership across ticket types.
2. **Peak Demand Days** – Identify top 5 busiest days for resource planning.
3. **Ticket Share Analysis** – Percentage contribution by ticket type.
4. **Monthly Growth Rates** – Month-over-month ridership trends.
5. **Channel Performance** – QR ticket breakdown by sales channel.
6. **Weekend vs Weekday Analysis** – Compare commuter patterns.
7. **Fastest-Growing Ticket Type** – Identify adoption shifts.
8. **QR Revenue Share** – Revenue analysis by platform.
9. **Baseline Averages** – Establish ticket sales baselines.
10. **Smart Card vs Token Ratio** – Track digital adoption.
11. **Cumulative Ridership** – Long-term growth view.
12. **Rolling Averages** – Smooth trends with 7-day rolling average.
13. **Anomaly Detection** – Identify unusually low ridership days.
14. **Ticket Correlation** – Measure substitution/complement relationships.
15. **Highest Revenue Day** – Find top-earning day.
16. **Monthly Adoption Rates** – Smart card adoption over time.
17. **Popular Days** – Most popular weekday.
18. **QR Growth Rates** – Month-over-month digital ticket growth.
19. **Cumulative Revenue** – Running total revenue tracking.
20. **Digital vs Physical Ratio** – Track cashless adoption.

