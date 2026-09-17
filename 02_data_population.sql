-- Insert Airports
INSERT INTO airports (airport_code, city, country, timezone) VALUES
('JFK', 'New York', 'USA', 'America/New_York'),
('LAX', 'Los Angeles', 'USA', 'America/Los_Angeles'),
('LHR', 'London', 'UK', 'Europe/London'),
('DXB', 'Dubai', 'UAE', 'Asia/Dubai');

-- Insert Flights (Using a loop/generate series for bulk data)
INSERT INTO flights (flight_number, origin, destination, departure_time, arrival_time, base_price, total_seats, available_seats)
SELECT 
    'AB' || generate_series || LPAD((generate_series % 99)::text, 2, '0'),
    (ARRAY['JFK', 'LAX', 'LHR', 'DXB'])[ceil(random()*4)],
    (ARRAY['JFK', 'LAX', 'LHR', 'DXB'])[ceil(random()*4)],
    CURRENT_TIMESTAMP + (generate_series || ' hours')::interval,
    CURRENT_TIMESTAMP + ((generate_series + 5) || ' hours')::interval,
    200.00 + (random() * 800),
    150,
    150
FROM generate_series(1, 50);

-- Insert Passengers
INSERT INTO passengers (first_name, last_name, email, phone, loyalty_tier, loyalty_points)
SELECT 
    'FirstName' || generate_series,
    'LastName' || generate_series,
    'user' || generate_series || '@aerobook.com',
    '555-' || LPAD((generate_series % 10000)::text, 4, '0'),
    (ARRAY['Bronze', 'Silver', 'Gold', 'Platinum'])[ceil(random()*4)],
    floor(random() * 50000)
FROM generate_series(1, 100);