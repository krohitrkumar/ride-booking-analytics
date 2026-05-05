-- =========================================
-- FEATURE ENGINEERING / DATA FIXES
-- =========================================

-- Handle missing payment method
UPDATE rides_final
SET payment_method = 'unknown'
WHERE payment_method IS NULL
   OR LOWER(TRIM(payment_method)) IN ('', 'null');

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_rf_time ON rides_final(ride_timestamp);
CREATE INDEX IF NOT EXISTS idx_rf_customer ON rides_final(customer_id);