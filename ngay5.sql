
-- 1. Tạo bảng Rooms
CREATE TABLE Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE,
    type VARCHAR(20),
    status VARCHAR(20) CHECK (status IN ('Available', 'Occupied', 'Maintenance')),
    price INT CHECK (price >= 0)
);

-- 2. Tạo bảng Guests
CREATE TABLE Guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20)
);

-- 3. Tạo bảng Bookings
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled')),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

-- 4. Tạo bảng Invoices
CREATE TABLE Invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    total_amount INT,
    generated_date DATE,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

-- 5. Stored Procedure MakeBooking
DELIMITER $$

CREATE PROCEDURE MakeBooking (
    IN p_guest_id INT,
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE
)
BEGIN
    DECLARE room_status VARCHAR(20);
    DECLARE overlap_count INT;

    -- Kiểm tra trạng thái phòng
    SELECT status INTO room_status FROM Rooms WHERE room_id = p_room_id;

    IF room_status != 'Available' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is not available';
    END IF;

    -- Kiểm tra trùng thời gian đặt phòng
    SELECT COUNT(*) INTO overlap_count
    FROM Bookings
    WHERE room_id = p_room_id
      AND status = 'Confirmed'
      AND NOT (p_check_out <= check_in OR p_check_in >= check_out);

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is already booked during the requested period';
    END IF;

    -- Tạo đặt phòng mới
    INSERT INTO Bookings (guest_id, room_id, check_in, check_out, status)
    VALUES (p_guest_id, p_room_id, p_check_in, p_check_out, 'Confirmed');

    -- Cập nhật trạng thái phòng
    UPDATE Rooms SET status = 'Occupied' WHERE room_id = p_room_id;
END $$

DELIMITER ;

-- 6. Trigger after_booking_cancel
DELIMITER $$

CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
    DECLARE future_booking_count INT;

    IF NEW.status = 'Cancelled' AND OLD.status != 'Cancelled' THEN
        SELECT COUNT(*) INTO future_booking_count
        FROM Bookings
        WHERE room_id = NEW.room_id
          AND status = 'Confirmed'
          AND check_in > CURDATE();

        IF future_booking_count = 0 THEN
            UPDATE Rooms SET status = 'Available'
            WHERE room_id = NEW.room_id;
        END IF;
    END IF;
END $$

DELIMITER ;

-- 7. Stored Procedure GenerateInvoice
DELIMITER $$

CREATE PROCEDURE GenerateInvoice (
    IN p_booking_id INT
)
BEGIN
    DECLARE v_check_in DATE;
    DECLARE v_check_out DATE;
    DECLARE v_price INT;
    DECLARE v_room_id INT;
    DECLARE v_nights INT;
    DECLARE v_total INT;

    -- Lấy thông tin đặt phòng
    SELECT check_in, check_out, room_id
    INTO v_check_in, v_check_out, v_room_id
    FROM Bookings
    WHERE booking_id = p_booking_id;

    -- Lấy giá phòng
    SELECT price INTO v_price FROM Rooms WHERE room_id = v_room_id;

    -- Tính số đêm và tổng tiền
    SET v_nights = DATEDIFF(v_check_out, v_check_in);
    SET v_total = v_nights * v_price;

    -- Tạo hóa đơn
    INSERT INTO Invoices (booking_id, total_amount, generated_date)
    VALUES (p_booking_id, v_total, CURDATE());
END $$

DELIMITER ;

-- =====================
-- OPTIONAL: Sample Data để test
-- =====================
-- INSERT INTO Rooms (room_number, type, status, price) VALUES ('101', 'Standard', 'Available', 500);
-- INSERT INTO Guests (full_name, phone) VALUES ('Nguyen Van A', '0901234567');
-- CALL MakeBooking(1, 1, '2025-06-01', '2025-06-05');
-- CALL GenerateInvoice(1);
-- UPDATE Bookings SET status = 'Cancelled' WHERE booking_id = 1;
-- SELECT * FROM Invoices;

