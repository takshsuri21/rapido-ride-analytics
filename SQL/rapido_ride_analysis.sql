-- 1. Create database and select it
-- Purpose: Set up database environment for analysis
CREATE DATABASE rapido;
USE rapido;

-- 2. View raw data for initial sanity check
-- Purpose: Understand table structure and data quality
SELECT * FROM rapido_data;



-- 3. Completed bookings
-- Purpose: Identify all successfully completed rides
CREATE OR REPLACE VIEW complete_booking AS
SELECT Booking_ID, Booking_Status
FROM rapido_data
WHERE Booking_Status = 'Completed';

SELECT * FROM complete_booking;



-- 4. Average ride distance by vehicle type
-- Purpose: Compare average trip distance across vehicle categories
CREATE OR REPLACE VIEW ride_distance_by_vehicle AS
SELECT 
    Vehicle_Type,
    ROUND(AVG(CAST(`Ride_Distance(km)` AS DECIMAL(10,2))), 2) AS avg_distance_km
FROM rapido_data
GROUP BY Vehicle_Type;

SELECT * FROM ride_distance_by_vehicle;



-- 5. Total incomplete bookings count
-- Purpose: Measure the volume of unfinished or failed rides
CREATE OR REPLACE VIEW incomplete_booking AS
SELECT 
    COUNT(*) AS incomplete_rides
FROM rapido_data
WHERE Booking_Status = 'Incomplete';

SELECT * FROM incomplete_booking;



-- 6. Top 5 customers by number of rides
-- Purpose: Identify high-frequency customers
CREATE OR REPLACE VIEW total_ride_by_customer AS
SELECT 
    Customer_ID,
    COUNT(Booking_ID) AS total_rides
FROM rapido_data
GROUP BY Customer_ID
ORDER BY total_rides DESC
LIMIT 5;

SELECT * FROM total_ride_by_customer;



-- 7. Driver cancelled rides count
-- Purpose: Measure cancellations initiated by drivers
CREATE OR REPLACE VIEW cancel_rides_by_driver AS
SELECT 
    COUNT(*) AS driver_cancelled_rides
FROM rapido_data
WHERE Canceled_Rides_by_Driver = 1;

SELECT * FROM cancel_rides_by_driver;



-- 8. Maximum and minimum driver ratings
-- Purpose: Understand the range of driver performance
CREATE OR REPLACE VIEW max_min_driver_rating AS
SELECT 
    MAX(Driver_Rating) AS max_rating,
    MIN(Driver_Rating) AS min_rating
FROM rapido_data;

SELECT * FROM max_min_driver_rating;



-- 9. UPI payment bookings
-- Purpose: Analyze usage of UPI as a payment method
CREATE OR REPLACE VIEW upi_payment AS
SELECT *
FROM rapido_data
WHERE Payment_Method = 'UPI';

SELECT * FROM upi_payment;



-- 10. Average customer rating by vehicle type
-- Purpose: Compare customer satisfaction across vehicle types
CREATE OR REPLACE VIEW average_customer_rating AS
SELECT 
    Vehicle_Type,
    ROUND(AVG(Customer_Rating), 2) AS avg_customer_rating
FROM rapido_data
GROUP BY Vehicle_Type;

SELECT * FROM average_customer_rating;



-- 11. Total successful booking value
-- Purpose: Calculate revenue generated from completed rides
CREATE OR REPLACE VIEW total_complete_value AS
SELECT 
    ROUND(SUM(Booking_value), 2) AS total_successful_value
FROM rapido_data
WHERE Booking_Status = 'Completed';

SELECT * FROM total_complete_value;



-- 12. Incomplete rides with reasons
-- Purpose: Identify key operational failure reasons
CREATE OR REPLACE VIEW incomplete_rides AS
SELECT 
    Booking_ID,
    Incomplete_Rides_Reason
FROM rapido_data
WHERE Booking_Status = 'Incomplete';

SELECT * FROM incomplete_rides;



-- 13. Overall completion rate
-- Purpose: Measure platform efficiency using a core KPI
CREATE OR REPLACE VIEW completion_rate AS
SELECT 
    ROUND(
        SUM(CASE WHEN Booking_Status = 'Completed' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS completion_rate_pct
FROM rapido_data;

SELECT * FROM completion_rate;



-- 14. Cancellation rate by vehicle type
-- Purpose: Identify vehicle categories with higher cancellation risk
CREATE OR REPLACE VIEW cancellation_rate_by_vehicle AS
SELECT 
    Vehicle_Type,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN Booking_Status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_rides,
    ROUND(
        SUM(CASE WHEN Booking_Status = 'Cancelled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct
FROM rapido_data
GROUP BY Vehicle_Type;

SELECT * FROM cancellation_rate_by_vehicle;



-- 15. Payment method share percentage
-- Purpose: Understand customer payment preferences
CREATE OR REPLACE VIEW payment_method_share AS
SELECT 
    Payment_Method,
    COUNT(*) AS total_rides,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rapido_data), 2
    ) AS payment_share_pct
FROM rapido_data
GROUP BY Payment_Method;

SELECT * FROM payment_method_share;



-- 16. Driver rating segmentation
-- Purpose: Segment drivers based on service quality
CREATE OR REPLACE VIEW driver_rating_bucket AS
SELECT 
    CASE 
        WHEN Driver_Rating >= 4.5 THEN 'Excellent'
        WHEN Driver_Rating >= 3.5 THEN 'Good'
        ELSE 'Poor'
    END AS rating_category,
    COUNT(*) AS total_rides
FROM rapido_data
GROUP BY rating_category;

SELECT * FROM driver_rating_bucket;
