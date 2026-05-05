-- FINAL TABLE
DROP TABLE IF EXISTS rides_final;

CREATE TABLE rides_final AS
SELECT * FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY booking_id
            ORDER BY
                CASE WHEN booking_status = 'completed' THEN 1 ELSE 2 END,
                ride_timestamp DESC
        ) AS rn
    FROM rides
) t
WHERE rn = 1;

ALTER TABLE rides_final DROP COLUMN rn;
ALTER TABLE rides_final ADD PRIMARY KEY (booking_id);

-- CUSTOMERS
CREATE TABLE customers AS
SELECT DISTINCT customer_id FROM rides_final;

ALTER TABLE customers ADD PRIMARY KEY (customer_id);

-- PAYMENTS
CREATE TABLE payments AS
SELECT booking_id, payment_method FROM rides_final;

ALTER TABLE payments ADD COLUMN payment_id SERIAL PRIMARY KEY;

-- REVIEWS
CREATE TABLE reviews AS
SELECT booking_id, driver_rating, customer_rating
FROM rides_final
WHERE driver_rating IS NOT NULL OR customer_rating IS NOT NULL;

ALTER TABLE reviews ADD COLUMN review_id SERIAL PRIMARY KEY;