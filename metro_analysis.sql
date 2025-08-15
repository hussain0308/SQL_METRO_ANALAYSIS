CREATE TABLE metro (
    record_date DATE PRIMARY KEY,
    total_smart_cards INT,
    stored_value_card INT,
    one_day_pass INT,
    three_day_pass INT,
    five_day_pass INT,
    total_tokens INT,
    total_ncmc INT,
    group_ticket INT,
    total_qr INT,
    qr_nammametro INT,
    qr_whatsapp INT,
    qr_paytm INT
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/NammaMetro_Ridership_Dataset.csv'
INTO TABLE metro
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@record_date, total_smart_cards, stored_value_card, one_day_pass,
 three_day_pass, five_day_pass, total_tokens, total_ncmc, group_ticket,
 total_qr, qr_nammametro, qr_whatsapp, qr_paytm)
SET record_date = STR_TO_DATE(@record_date, '%d-%m-%Y');

SELECT * FROM metro LIMIT 10;

SELECT 
    record_date,
    total_smart_cards,
    total_tokens,
    total_qr,
    (total_smart_cards + total_tokens + total_qr) AS total_ridership
FROM metro
ORDER BY record_date;
# INSIGHT: Shows day-by-day ridership volumes across the main ticketing channels.

SELECT 
    record_date,
    (total_smart_cards + total_tokens + total_qr) AS total_ridership
FROM metro
ORDER BY total_ridership DESC
LIMIT 5;
# INSIGHT: Identifies peak days — critical for resource planning, staffing, and maintenance scheduling

SELECT 
    record_date,
    ROUND((total_smart_cards / (total_smart_cards + total_tokens + total_qr)) * 100, 2) AS smart_card_pct,
    ROUND((total_tokens / (total_smart_cards + total_tokens + total_qr)) * 100, 2) AS tokens_pct,
    ROUND((total_qr / (total_smart_cards + total_tokens + total_qr)) * 100, 2) AS qr_pct
FROM metro;
# INSIGHT:Shows how much each ticket type contributes to daily ridership share. This could be used for marketing strategies or deciding where to invest infrastructure

WITH monthly_data AS (
    SELECT 
        DATE_FORMAT(record_date, '%Y-%m') AS month,
        SUM(total_smart_cards + total_tokens + total_qr) AS total_ridership
    FROM metro
    GROUP BY month
)
SELECT 
    month,
    total_ridership,
    ROUND(
        (total_ridership - LAG(total_ridership) OVER (ORDER BY month)) 
        / LAG(total_ridership) OVER (ORDER BY month) * 100, 2
    ) AS growth_pct
FROM monthly_data;
# INSIGHT:Tracks growth or decline in ridership on a monthly basis — helps in long-term strategic planning.

SELECT 
    record_date,
    qr_nammametro,
    qr_whatsapp,
    qr_paytm,
    ROUND((qr_nammametro / total_qr) * 100, 2) AS nammametro_pct,
    ROUND((qr_whatsapp / total_qr) * 100, 2) AS whatsapp_pct,
    ROUND((qr_paytm / total_qr) * 100, 2) AS paytm_pct
FROM metro;
# INSGIHT:Breaks down QR ticket sales by channel — helps decide which partnerships or platforms deserve marketing investment.

SELECT 
    CASE 
        WHEN DAYOFWEEK(record_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    ROUND(AVG(total_smart_cards + total_tokens + total_qr), 0) AS avg_ridership
FROM metro
GROUP BY day_type;
# INSIGHT: Reveals whether weekends or weekdays have higher average ridership — useful for adjusting train frequency and staffing schedules.

WITH daily_totals AS (
    SELECT 
        record_date,
        total_smart_cards,
        total_tokens,
        total_qr
    FROM metro
),
growth_calc AS (
    SELECT
        record_date,
        (total_smart_cards - LAG(total_smart_cards) OVER (ORDER BY record_date)) AS smart_card_growth,
        (total_tokens - LAG(total_tokens) OVER (ORDER BY record_date)) AS tokens_growth,
        (total_qr - LAG(total_qr) OVER (ORDER BY record_date)) AS qr_growth
    FROM daily_totals
)
SELECT 
    record_date,
    smart_card_growth,
    tokens_growth,
    qr_growth
FROM growth_calc
ORDER BY record_date;
# INSIGHT: Identifies daily growth per ticket type, showing which category is accelerating fastest — key for marketing targeting.

SELECT 
    record_date,
    qr_nammametro * 50 AS revenue_nammametro,
    qr_whatsapp * 50 AS revenue_whatsapp,
    qr_paytm * 50 AS revenue_paytm,
    ROUND((qr_nammametro * 50) / ((qr_nammametro + qr_whatsapp + qr_paytm) * 50) * 100, 2) AS nammametro_pct,
    ROUND((qr_whatsapp * 50) / ((qr_nammametro + qr_whatsapp + qr_paytm) * 50) * 100, 2) AS whatsapp_pct,
    ROUND((qr_paytm * 50) / ((qr_nammametro + qr_whatsapp + qr_paytm) * 50) * 100, 2) AS paytm_pct
FROM metro;
# INSIGHT: Calculates daily revenue and percentage share per QR channel — informs which partnerships bring in the most income.

SELECT 
    ROUND(AVG(total_smart_cards), 0) AS avg_smart_cards,
    ROUND(AVG(total_tokens), 0) AS avg_tokens,
    ROUND(AVG(total_qr), 0) AS avg_qr
FROM metro;
#INSIGHT: Gives a baseline daily sales number per channel — helps detect anomalies when numbers suddenly deviate.

SELECT 
    record_date,
    ROUND(total_smart_cards / total_tokens, 2) AS smart_to_token_ratio
FROM metro
ORDER BY smart_to_token_ratio DESC
LIMIT 1;
#INSIGHT: Finds the day when smart card usage dominated over tokens — useful to evaluate smart card adoption campaigns.

SELECT 
    record_date,
    SUM(total_smart_cards + total_tokens + total_qr) 
        OVER (ORDER BY record_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_ridership
FROM metro;
# INSIGHT: Tracks how total ridership builds over time — great for visual storytelling and understanding growth momentum.

SELECT 
    record_date,
    ROUND(AVG(total_smart_cards + total_tokens + total_qr) 
          OVER (ORDER BY record_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 0) AS rolling_7day_avg
FROM metro;
# INSIGHT:Calculates the 7-day rolling average of ridership to smooth out daily fluctuations. This is useful for identifying long-term trends without being misled by single-day spikes.

WITH daily_total AS (
    SELECT 
        record_date,
        (total_smart_cards + total_tokens + total_qr) AS total_ridership
    FROM metro
),
stats AS (
    SELECT 
        AVG(total_ridership) AS avg_rider,
        STDDEV(total_ridership) AS std_rider
    FROM daily_total
)
SELECT 
    d.record_date,
    d.total_ridership
FROM daily_total d
CROSS JOIN stats s
WHERE d.total_ridership < (s.avg_rider - 2 * s.std_rider);
# INSIGHT: Flags days with ridership more than two standard deviations below the average — useful for investigating operational issues or external events affecting travel.

SELECT 
    record_date,
    (total_smart_cards * 40 + total_tokens * 30 + total_qr * 50) AS total_revenue
FROM metro
ORDER BY total_revenue DESC
LIMIT 1;
# INSIGHT: Identifies the single highest revenue day, combining all ticket types with assumed prices — useful for financial reporting and campaign performance tracking.

WITH monthly AS (
    SELECT 
        DATE_FORMAT(record_date, '%Y-%m') AS month,
        SUM(total_smart_cards) AS total_smart_cards,
        SUM(total_smart_cards + total_tokens + total_qr) AS total_ridership
    FROM metro
    GROUP BY month
)
SELECT 
    month,
    ROUND((total_smart_cards / total_ridership) * 100, 2) AS smart_card_adoption_pct
FROM monthly;
# INSIGHT: Tracks monthly smart card adoption percentage to measure how quickly commuters are shifting from tokens or QR to stored-value smart cards.

SELECT 
    DAYNAME(record_date) AS day_of_week,
    ROUND(AVG(total_smart_cards + total_tokens + total_qr), 0) AS avg_ridership
FROM metro
GROUP BY day_of_week
ORDER BY avg_ridership DESC
LIMIT 1;
# INSIGHT: Reveals the day of the week with the highest average ridership — helpful for targeted promotions or service optimization.

WITH monthly_qr AS (
    SELECT 
        DATE_FORMAT(record_date, '%Y-%m') AS month,
        SUM(total_qr) AS total_qr
    FROM metro
    GROUP BY month
)
SELECT 
    month,
    total_qr,
    ROUND((total_qr - LAG(total_qr) OVER (ORDER BY month)) / LAG(total_qr) OVER (ORDER BY month) * 100, 2) AS qr_growth_pct
FROM monthly_qr;
# INSIGHT: Measures month-over-month growth in QR ticket usage — valuable for evaluating adoption of digital payment channels.

SELECT 
    record_date,
    SUM(total_smart_cards * 40 + total_tokens * 30 + total_qr * 50)
        OVER (ORDER BY record_date) AS cumulative_revenue
FROM metro;
# INSIGHT:Tracks total revenue accumulated over time — a simple yet powerful financial metric for annual or quarterly reports.

SELECT 
    record_date,
    ROUND((total_qr + total_smart_cards) / (total_tokens) , 2) AS digital_to_physical_ratio
FROM metro;
# INSIGHT: Measures the daily ratio of digital (smart cards + QR) to physical token sales — an important KPI for tracking progress toward cashless transactions.
