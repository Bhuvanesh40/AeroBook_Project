CREATE VIEW vw_flight_profitability AS
SELECT 
    f.flight_number,
    a1.city AS origin_city,
    a2.city AS dest_city,
    f.total_seats,
    f.available_seats,
    (f.total_seats - f.available_seats) AS booked_seats,
    ROUND(((f.total_seats - f.available_seats)::numeric / f.total_seats) * 100, 2) AS occupancy_rate,
    SUM(b.total_amount) AS total_revenue
FROM flights f
JOIN airports a1 ON f.origin = a1.airport_code
JOIN airports a2 ON f.destination = a2.airport_code
LEFT JOIN bookings b ON f.flight_id = b.flight_id AND b.status = 'Confirmed'
GROUP BY f.flight_id, f.flight_number, a1.city, a2.city, f.total_seats, f.available_seats;

-- Rank passengers within their loyalty tier by points
SELECT 
    first_name, 
    last_name, 
    loyalty_tier,
    loyalty_points,
    RANK() OVER(PARTITION BY loyalty_tier ORDER BY loyalty_points DESC) as tier_rank
FROM passengers;

-- Calculate the running total of revenue per day (Mocking daily data)
SELECT 
    DATE(booking_date) as booking_day,
    SUM(total_amount) as daily_revenue,
    SUM(SUM(total_amount)) OVER(ORDER BY DATE(booking_date)) as running_total_revenue
FROM bookings
WHERE status = 'Confirmed'
GROUP BY DATE(booking_date)
ORDER BY booking_day;

WITH RouteRevenue AS (
    SELECT 
        origin, 
        destination, 
        SUM(total_amount) as route_revenue,
        COUNT(b.booking_id) as total_bookings
    FROM flights f
    JOIN bookings b ON f.flight_id = b.flight_id
    WHERE b.status = 'Confirmed'
    GROUP BY origin, destination
)
SELECT 
    a1.city AS from_city, 
    a2.city AS to_city, 
    route_revenue, 
    total_bookings,
    ROUND(route_revenue / total_bookings, 2) AS avg_ticket_price
FROM RouteRevenue rr
JOIN airports a1 ON rr.origin = a1.airport_code
JOIN airports a2 ON rr.destination = a2.airport_code
ORDER BY route_revenue DESC
LIMIT 5;