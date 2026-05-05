-- =========================================
-- CREATING VIEWS
-- =========================================

-- KPI VIEW
DROP VIEW IF EXISTS v_kpi;
CREATE OR REPLACE VIEW v_kpi AS
SELECT 
  COUNT(*) AS total_rides,
  SUM(CASE WHEN booking_status = 'completed' THEN 1 ELSE 0 END) AS completed_rides,
  SUM(booking_value) FILTER (WHERE booking_status = 'completed') AS total_revenue,
  AVG(booking_value) FILTER (WHERE booking_status = 'completed') AS avg_revenue
FROM rides_final;


-- TIME ANALYSE VIEW
DROP VIEW IF EXISTS v_time_analyse;
CREATE OR REPLACE VIEW v_time_analyse AS 
SELECT 
    DATE(ride_timestamp) AS ride_date, 
    EXTRACT(HOUR FROM ride_timestamp) AS ride_hour,
    COUNT(*) AS total_rides, 
    SUM(booking_value) AS revenue 
FROM rides_final
WHERE booking_status = 'completed'
GROUP BY ride_date, ride_hour;


-- Payment Analysis View
DROP VIEW IF EXISTS v_payment_analyse;
CREATE OR REPLACE VIEW v_payment_analyse AS
SELECT 
  payment_method, 
  COUNT(*) FILTER (WHERE booking_status = 'completed') AS total_rides,
  SUM(booking_value) AS revenue 
FROM rides_final
WHERE booking_status = 'completed'
GROUP BY payment_method
ORDER BY revenue DESC;


-- Customer Insights View
DROP VIEW IF EXISTS v_customer_stats;
CREATE OR REPLACE VIEW v_customer_stats AS
SELECT 
  customer_id,
  COUNT(*) AS total_rides,
  COUNT(*) FILTER (WHERE booking_status = 'completed') AS completed_rides,
  SUM(booking_value) AS total_spent,
  AVG(booking_value) AS avg_spent
FROM rides_final
GROUP BY customer_id;


-- STATUS DISTRIBUTION VIEW
DROP VIEW IF EXISTS v_status_distribution;
CREATE OR REPLACE VIEW v_status_distribution AS
SELECT 
  booking_status,
  COUNT(*) AS total_rides
FROM rides_final
GROUP BY booking_status;


-- CANCELLATION ANALYSIS VIEW
DROP VIEW IF EXISTS v_cancellation_view;
CREATE OR REPLACE VIEW v_cancellation_view AS 
SELECT 
    booking_status,
    COUNT(*) AS total_rides
FROM rides_final
WHERE booking_status != 'completed'
GROUP BY booking_status;


-- PAYMENT REVENUE JOIN VIEW
DROP VIEW IF EXISTS v_join_payment_revenue; 
CREATE OR REPLACE VIEW v_join_payment_revenue AS
SELECT
    p.payment_method,
    COUNT(*) AS total_rides,
    SUM(r.booking_value) AS total_revenue
FROM rides_final r
JOIN payments p 
ON p.booking_id = r.booking_id
WHERE r.booking_status = 'completed'
GROUP BY p.payment_method    
ORDER BY total_revenue DESC;


-- REVIEW COVERAGE VIEW
DROP VIEW IF EXISTS v_join_review_coverage; 
CREATE OR REPLACE VIEW v_join_review_coverage AS
SELECT
    COUNT(*) FILTER (WHERE r.booking_status = 'completed') AS completed_rides,

    COUNT(DISTINCT o.booking_id) FILTER (WHERE r.booking_status = 'completed') AS reviewed_rides,

    COUNT(DISTINCT o.booking_id)::float
    / NULLIF(COUNT(*) FILTER (WHERE r.booking_status='completed'), 0)
    AS review_rate

FROM rides_final r
LEFT JOIN reviews o
ON o.booking_id = r.booking_id;


-- RATING VS REVENUE VIEW
DROP VIEW IF EXISTS v_join_rating_vs_revenue ;
CREATE OR REPLACE VIEW v_join_rating_vs_revenue AS
SELECT
  rv.driver_rating,
  COUNT(*) AS rides,
  AVG(r.booking_value) AS avg_revenue
FROM rides_final r
JOIN reviews rv
  ON r.booking_id = rv.booking_id
WHERE r.booking_status = 'completed'
GROUP BY rv.driver_rating
ORDER BY rv.driver_rating;


-- TOP CUSTOMER PAYMENT VIEW
DROP VIEW IF EXISTS v_join_top_customer_payment;

CREATE OR REPLACE VIEW v_join_top_customer_payment AS
WITH top_cust AS (
    SELECT customer_id
    FROM rides_final
    WHERE booking_status = 'completed'  
    GROUP BY customer_id
    ORDER BY SUM(booking_value) DESC
    LIMIT 100
)
SELECT 
    p.payment_method,
    COUNT(DISTINCT r.booking_id) AS total_rides, 
    SUM(r.booking_value) AS revenue
FROM rides_final r
JOIN top_cust tc
    ON r.customer_id = tc.customer_id
JOIN payments p
    ON r.booking_id = p.booking_id
WHERE r.booking_status = 'completed'
GROUP BY p.payment_method
ORDER BY revenue DESC;