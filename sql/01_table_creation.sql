-- STEP 1: CREATE RAW TABLE

DROP TABLE IF EXISTS raw_data;

CREATE TABLE raw_data (
    date DATE,
    time TIME,
    booking_id TEXT,
    booking_status TEXT,
    customer_id TEXT,
    vehicle_type TEXT,
    pickup_location TEXT,
    drop_location TEXT,
    avg_vtat TEXT,
    avg_ctat TEXT,
    cancelled_by_customer TEXT,
    customer_cancel_reason TEXT,
    cancelled_by_driver TEXT,
    driver_cancel_reason TEXT,
    incomplete_rides TEXT,
    incomplete_reason TEXT,
    booking_value TEXT,
    ride_distance TEXT,
    driver_rating TEXT,
    customer_rating TEXT,
    payment_method TEXT
);

-- Data imported via pgAdmin Import Tool