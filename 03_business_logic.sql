CREATE OR REPLACE FUNCTION update_flight_seats()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.status = 'Confirmed' THEN
        UPDATE flights SET available_seats = available_seats - 1 WHERE flight_id = NEW.flight_id;
    ELSIF TG_OP = 'UPDATE' AND OLD.status = 'Confirmed' AND NEW.status = 'Cancelled' THEN
        UPDATE flights SET available_seats = available_seats + 1 WHERE flight_id = NEW.flight_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_booking_seat_update
AFTER INSERT OR UPDATE ON bookings
FOR EACH ROW EXECUTE FUNCTION update_flight_seats();

CREATE OR REPLACE FUNCTION log_audit_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, action_type, old_data, new_data)
    VALUES (TG_TABLE_NAME, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_passengers
AFTER UPDATE ON passengers
FOR EACH ROW EXECUTE FUNCTION log_audit_changes();

CREATE OR REPLACE PROCEDURE cancel_booking(p_booking_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Start transaction (implicit in procedures, but good to show logic)
    UPDATE bookings SET status = 'Cancelled' WHERE booking_id = p_booking_id AND status = 'Confirmed';
    
    -- If you wanted to add refund logic or email triggers, it would go here.
    -- The trigger trg_booking_seat_update will automatically handle the seat count!
    
    RAISE NOTICE 'Booking % has been successfully cancelled.', p_booking_id;
END;
$$;