-- ANALYSIS & INSIGHTS
-- 1. Completion Rate

SELECT
    booking_status,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS percentage 
FROM rides_final
GROUP BY booking_status
ORDER BY percentage DESC;

/*
Insight:
The ride completion rate stands at 62.21%, meaning nearly 38% of ride requests fail. 
Among failures, driver-side cancellations dominate (47.36% of failed rides), followed 
by “no driver found” (~18.4%). This clearly indicates a supply-side inefficiency, where 
driver availability and reliability are the primary bottlenecks rather than customer behavior.
*/

-- 2. Revenue Share by Payment Method

    payment_method,
    SUM(booking_value) AS revenue,
    ROUND((SUM(booking_value) * 100.0 / SUM(SUM(booking_value)) OVER())::numeric, 2) AS revenue_percentage
FROM rides_final
WHERE booking_status = 'completed'
GROUP BY payment_method
ORDER BY revenue DESC;

/*
Insight:
UPI dominates the payment ecosystem, contributing 45.01% of total revenue—nearly double 
that of the next highest method, Cash (24.88%). Digital payment methods collectively 
account for the majority of transactions, indicating strong user preference toward cashless payments.
*/

-- 3. Ride Distribution by Hour

SELECT 
    EXTRACT(HOUR FROM ride_timestamp) AS hours,
    COUNT(*) AS total_rides,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS percentage
FROM rides_final
GROUP BY hours
ORDER BY percentage DESC;

/*
Insight:
Ride demand peaks during evening hours (5 PM–8 PM), with the highest activity at 6 PM (8.26%), 
reflecting typical post-work commuting behavior. In contrast, demand drops sharply during 
early morning hours (1 AM–5 AM), indicating predictable low-usage periods.
*/

-- 4. Revenue Distribution by Hour

SELECT 
    EXTRACT(HOUR FROM ride_timestamp) AS hours,
    SUM(booking_value) AS revenue,
    ROUND((SUM(booking_value) * 100.0 / SUM(SUM(booking_value)) OVER())::numeric, 2) AS percentage
FROM rides_final
WHERE booking_status = 'completed'
GROUP BY hours
ORDER BY revenue DESC;

/*
Insight:
Revenue distribution closely follows ride demand, with peak revenue also occurring in 
the evening hours (5 PM–7 PM). This indicates that revenue is primarily driven by high demand volume 
rather than higher per-ride value.
*/


-- 5. Vehicle Type Share (Rides)
SELECT 
    vehicle_type,
    COUNT(*) AS total_rides,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS percentage
FROM rides_final
GROUP BY vehicle_type
ORDER BY percentage DESC;

/*
Insight:
Auto and Go Mini dominate ride volume, contributing ~25% and ~20% respectively. 
This highlights strong demand for affordable ride options, while premium services 
contribute minimally.
*/
-- 6. Vehicle Type Revenue Share

SELECT
    vehicle_type,
    SUM(booking_value) AS revenue,
    ROUND((SUM(booking_value) * 100.0 / SUM(SUM(booking_value)) OVER())::numeric, 2) AS percentage
FROM rides_final
WHERE booking_status = 'completed'
GROUP BY vehicle_type
ORDER BY percentage DESC;
/*
Insight:
Auto and Go Mini are the top revenue-generating vehicle types, contributing ~24.82% 
and ~19.91% respectively. Revenue is largely driven by affordable and mid-tier segments, 
while premium services contribute minimally.
*/

-- 7. Top Customers Contribution

WITH ranked AS (
    SELECT 
        customer_id,
        SUM(booking_value) AS total_revenue,
        RANK() OVER (ORDER BY SUM(booking_value) DESC) AS rnk
    FROM rides_final
    WHERE booking_status = 'completed'
    GROUP BY customer_id
)
SELECT 
    ROUND((SUM(total_revenue) * 100.0 / (SELECT SUM(total_revenue) FROM ranked))::numeric, 3) AS top10_percentage
FROM ranked
WHERE rnk <= 10;
/*
Insight:
The top 10 customers contribute only ~9.2% of total revenue, indicating that revenue 
is widely distributed across the user base with no heavy dependency on a small group of users.
*/

-- 8. Pickup Location Share
SELECT 
    pickup_location,
    SUM(booking_value) AS total_revenue,
    COUNT(*) AS total_rides,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS percentage
FROM rides_final
GROUP BY pickup_location
ORDER BY percentage DESC
LIMIT 10;
/*
Insight:
Top pickup locations each contribute less than 1% of total rides, indicating that demand 
is highly distributed across locations rather than concentrated in a few hotspots.
*/
-- 9. Cancellation Breakdown

SELECT
    booking_status,
    COUNT(*) AS rides,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS percentage
FROM rides_final
WHERE booking_status != 'completed'
GROUP BY booking_status
ORDER BY percentage DESC;
/*
Insight:
Driver cancellations account for the largest share (~47.36%), followed by “no driver found” 
(~18.43%) and customer cancellations (~18.41%). Over 65% of failures are supply-side issues.
*/
-- 10. Rating Distribution
SELECT
    driver_rating,
    COUNT(*) AS rides,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS percentage
FROM rides_final
WHERE driver_rating IS NOT NULL
GROUP BY driver_rating
ORDER BY rides DESC;
/*
Insight:
Driver ratings are concentrated between 4.0 and 4.6, with peak around 4.2–4.3, 
indicating consistently high service quality and very few poor experiences.
*/

-- FINAL COMBINED INSIGHT
/*
Despite high driver ratings, the ride completion rate is relatively low (~62%). 
This highlights a gap between service quality and operational efficiency. While 
customers are satisfied with completed rides, the platform faces challenges in 
ride fulfillment due to driver availability and cancellations. Improving supply-side 
efficiency can significantly enhance overall performance.
*/