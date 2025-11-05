-- Hotel Management System Database Schema
-- Drop existing database and create new one
DROP DATABASE IF EXISTS hotel_management;
CREATE DATABASE hotel_management;
USE hotel_management;

-- ============================================
-- TABLE DEFINITIONS
-- ============================================

-- Guest Table
CREATE TABLE Guest (
    Guest_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Contact_Info VARCHAR(20) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Nationality VARCHAR(50),
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Check_In_Status BOOLEAN DEFAULT FALSE,
    Registration_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (Email),
    INDEX idx_check_in_status (Check_In_Status)
);

-- Staff Table
CREATE TABLE Staff (
    Staff_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Dept VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Contact_Info VARCHAR(20) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Join_Date DATE NOT NULL,
    CONSTRAINT chk_age CHECK (Age >= 18 AND Age <= 65),
    CONSTRAINT chk_salary CHECK (Salary > 0),
    INDEX idx_dept (Dept)
);

-- Room Table
CREATE TABLE Room (
    Room_No INT PRIMARY KEY,
    Category ENUM('Single', 'Double', 'Suite', 'Deluxe') NOT NULL,
    Rent DECIMAL(10, 2) NOT NULL,
    Status ENUM('Available', 'Occupied', 'Maintenance', 'Cleaning') DEFAULT 'Available',
    Last_Cleaned DATETIME,
    CONSTRAINT chk_rent CHECK (Rent > 0),
    INDEX idx_status (Status),
    INDEX idx_category (Category)
);

-- Reservation Table
CREATE TABLE Reservation (
    Reservation_ID INT PRIMARY KEY AUTO_INCREMENT,
    Guest_ID INT NOT NULL,
    Room_No INT NOT NULL,
    Check_In_Date DATE NOT NULL,
    Check_Out_Date DATE NOT NULL,
    Total_Amount DECIMAL(10, 2) NOT NULL,
    Status ENUM('Confirmed', 'CheckedIn', 'CheckedOut', 'Cancelled') DEFAULT 'Confirmed',
    Booking_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_dates CHECK (Check_Out_Date > Check_In_Date),
    CONSTRAINT fk_guest FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID) ON DELETE CASCADE,
    CONSTRAINT fk_room FOREIGN KEY (Room_No) REFERENCES Room(Room_No) ON DELETE CASCADE,
    INDEX idx_guest (Guest_ID),
    INDEX idx_room (Room_No),
    INDEX idx_status (Status),
    INDEX idx_dates (Check_In_Date, Check_Out_Date)
);

-- Payment Table
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Reservation_ID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Payment_Method ENUM('Cash', 'Card', 'UPI', 'Online') NOT NULL,
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Completed',
    CONSTRAINT fk_reservation FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID) ON DELETE CASCADE,
    CONSTRAINT chk_amount CHECK (Amount > 0),
    INDEX idx_reservation (Reservation_ID),
    INDEX idx_status (Status)
);

-- Services Table
CREATE TABLE Services (
    Service_ID INT PRIMARY KEY AUTO_INCREMENT,
    Service_Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    Charges DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_charges CHECK (Charges >= 0),
    INDEX idx_service_name (Service_Name)
);

-- Room_Services (Many-to-Many)
CREATE TABLE Room_Services (
    Room_Service_ID INT PRIMARY KEY AUTO_INCREMENT,
    Room_No INT NOT NULL,
    Service_ID INT NOT NULL,
    Quantity INT DEFAULT 1,
    Total_Charge DECIMAL(10, 2) NOT NULL,
    Service_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rs_room FOREIGN KEY (Room_No) REFERENCES Room(Room_No) ON DELETE CASCADE,
    CONSTRAINT fk_rs_service FOREIGN KEY (Service_ID) REFERENCES Services(Service_ID) ON DELETE CASCADE,
    CONSTRAINT chk_quantity CHECK (Quantity > 0),
    INDEX idx_room_service (Room_No, Service_ID)
);

-- Audit_Log Table
CREATE TABLE Audit_Log (
    Log_ID INT PRIMARY KEY AUTO_INCREMENT,
    Table_Name VARCHAR(50) NOT NULL,
    Operation ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    Record_ID INT NOT NULL,
    Old_Value TEXT,
    New_Value TEXT,
    Modified_By VARCHAR(100) DEFAULT 'SYSTEM',
    Modified_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_table_operation (Table_Name, Operation),
    INDEX idx_modified_date (Modified_Date)
);

-- ============================================
-- FUNCTIONS
-- ============================================

DELIMITER //

-- Function to calculate stay duration
CREATE FUNCTION StayDuration(inDate DATE, outDate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(outDate, inDate);
END //

DELIMITER ;

-- ============================================
-- STORED PROCEDURES
-- ============================================

DELIMITER //

-- Procedure to book a room
CREATE PROCEDURE BookRoom(
    IN p_guest_id INT,
    IN p_room_no INT,
    IN p_check_in DATE,
    IN p_check_out DATE
)
BEGIN
    DECLARE v_rent DECIMAL(10, 2);
    DECLARE v_days INT;
    DECLARE v_total DECIMAL(10, 2);
    DECLARE v_room_status VARCHAR(20);
    
    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking failed';
    END;
    
    START TRANSACTION;
    
    -- Validate dates
    IF p_check_out <= p_check_in THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Check-out date must be after check-in date';
    END IF;
    
    -- Check if guest exists
    IF NOT EXISTS (SELECT 1 FROM Guest WHERE Guest_ID = p_guest_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Guest not found';
    END IF;
    
    -- Check room availability
    SELECT Status, Rent INTO v_room_status, v_rent 
    FROM Room 
    WHERE Room_No = p_room_no;
    
    IF v_room_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room not found';
    END IF;
    
    IF v_room_status != 'Available' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room is not available';
    END IF;
    
    -- Check for overlapping reservations
    IF EXISTS (
        SELECT 1 FROM Reservation 
        WHERE Room_No = p_room_no 
        AND Status IN ('Confirmed', 'CheckedIn')
        AND (
            (p_check_in BETWEEN Check_In_Date AND Check_Out_Date)
            OR (p_check_out BETWEEN Check_In_Date AND Check_Out_Date)
            OR (Check_In_Date BETWEEN p_check_in AND p_check_out)
        )
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room already reserved for these dates';
    END IF;
    
    -- Calculate total amount
    SET v_days = StayDuration(p_check_in, p_check_out);
    SET v_total = v_rent * v_days;
    
    -- Create reservation
    INSERT INTO Reservation (Guest_ID, Room_No, Check_In_Date, Check_Out_Date, Total_Amount, Status)
    VALUES (p_guest_id, p_room_no, p_check_in, p_check_out, v_total, 'Confirmed');
    
    -- Update room status to Occupied
    UPDATE Room SET Status = 'Occupied' WHERE Room_No = p_room_no;
    
    -- Update guest check-in status
    UPDATE Guest SET Check_In_Status = TRUE WHERE Guest_ID = p_guest_id;
    
    COMMIT;
    
    SELECT LAST_INSERT_ID() AS Reservation_ID, v_total AS Total_Amount;
END //

-- Procedure to make a payment
CREATE PROCEDURE MakePayment(
    IN p_reservation_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_method VARCHAR(20)
)
BEGIN
    DECLARE v_total_amount DECIMAL(10, 2);
    DECLARE v_paid_amount DECIMAL(10, 2);
    DECLARE v_payment_status VARCHAR(20);
    
    -- Error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment failed';
    END;
    
    START TRANSACTION;
    
    -- Validate reservation exists
    SELECT Total_Amount INTO v_total_amount 
    FROM Reservation 
    WHERE Reservation_ID = p_reservation_id;
    
    IF v_total_amount IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Reservation not found';
    END IF;
    
    -- Check if amount is valid
    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid payment amount';
    END IF;
    
    -- Calculate total paid amount
    SELECT COALESCE(SUM(Amount), 0) INTO v_paid_amount
    FROM Payment
    WHERE Reservation_ID = p_reservation_id AND Status = 'Completed';
    
    -- Check if payment exceeds total
    IF (v_paid_amount + p_amount) > v_total_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment exceeds reservation total';
    END IF;
    
    -- Determine payment status
    IF (v_paid_amount + p_amount) >= v_total_amount THEN
        SET v_payment_status = 'Completed';
    ELSE
        SET v_payment_status = 'Completed';
    END IF;
    
    -- Insert payment record
    INSERT INTO Payment (Reservation_ID, Amount, Payment_Method, Status)
    VALUES (p_reservation_id, p_amount, p_method, v_payment_status);
    
    COMMIT;
    
    SELECT LAST_INSERT_ID() AS Payment_ID, v_payment_status AS Status;
END //

DELIMITER ;

-- ============================================
-- TRIGGERS
-- ============================================

DELIMITER //

-- Trigger: When reservation is checked in, mark room as occupied
CREATE TRIGGER trg_reservation_checkin
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    IF NEW.Status = 'CheckedIn' AND OLD.Status != 'CheckedIn' THEN
        UPDATE Room SET Status = 'Occupied' WHERE Room_No = NEW.Room_No;
        UPDATE Guest SET Check_In_Status = TRUE WHERE Guest_ID = NEW.Guest_ID;
    END IF;
END //

-- Trigger: When reservation is checked out, mark room as available
CREATE TRIGGER trg_reservation_checkout
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    IF NEW.Status = 'CheckedOut' AND OLD.Status != 'CheckedOut' THEN
        UPDATE Room SET Status = 'Available', Last_Cleaned = NULL WHERE Room_No = NEW.Room_No;
        UPDATE Guest SET Check_In_Status = FALSE WHERE Guest_ID = NEW.Guest_ID;
    END IF;
END //

-- Trigger: When reservation is cancelled, mark room as available
CREATE TRIGGER trg_reservation_cancel
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Cancelled' AND OLD.Status IN ('Confirmed', 'CheckedIn') THEN
        UPDATE Room SET Status = 'Available' WHERE Room_No = NEW.Room_No;
        UPDATE Guest SET Check_In_Status = FALSE WHERE Guest_ID = NEW.Guest_ID;
    END IF;
END //

-- Audit Triggers for Guest
CREATE TRIGGER trg_guest_insert
AFTER INSERT ON Guest
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Table_Name, Operation, Record_ID, New_Value)
    VALUES ('Guest', 'INSERT', NEW.Guest_ID, 
            CONCAT('Name:', NEW.Name, ', Email:', NEW.Email));
END //

CREATE TRIGGER trg_guest_update
AFTER UPDATE ON Guest
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Table_Name, Operation, Record_ID, Old_Value, New_Value)
    VALUES ('Guest', 'UPDATE', NEW.Guest_ID,
            CONCAT('Name:', OLD.Name, ', Email:', OLD.Email),
            CONCAT('Name:', NEW.Name, ', Email:', NEW.Email));
END //

CREATE TRIGGER trg_guest_delete
AFTER DELETE ON Guest
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Table_Name, Operation, Record_ID, Old_Value)
    VALUES ('Guest', 'DELETE', OLD.Guest_ID,
            CONCAT('Name:', OLD.Name, ', Email:', OLD.Email));
END //

-- Audit Triggers for Reservation
CREATE TRIGGER trg_reservation_insert
AFTER INSERT ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Table_Name, Operation, Record_ID, New_Value)
    VALUES ('Reservation', 'INSERT', NEW.Reservation_ID,
            CONCAT('Guest:', NEW.Guest_ID, ', Room:', NEW.Room_No, ', Status:', NEW.Status));
END //

CREATE TRIGGER trg_reservation_update
AFTER UPDATE ON Reservation
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Table_Name, Operation, Record_ID, Old_Value, New_Value)
    VALUES ('Reservation', 'UPDATE', NEW.Reservation_ID,
            CONCAT('Status:', OLD.Status),
            CONCAT('Status:', NEW.Status));
END //

DELIMITER ;

-- ============================================
-- SEED DATA
-- ============================================

-- Insert Rooms
INSERT INTO Room (Room_No, Category, Rent, Status, Last_Cleaned) VALUES
(101, 'Single', 1500.00, 'Available', NOW()),
(102, 'Single', 1500.00, 'Available', NOW()),
(103, 'Double', 2500.00, 'Available', NOW()),
(104, 'Double', 2500.00, 'Available', NOW()),
(105, 'Suite', 5000.00, 'Available', NOW()),
(106, 'Suite', 5000.00, 'Maintenance', NULL),
(201, 'Deluxe', 7500.00, 'Available', NOW()),
(202, 'Deluxe', 7500.00, 'Available', NOW()),
(203, 'Single', 1500.00, 'Cleaning', NOW()),
(204, 'Double', 2500.00, 'Available', NOW());

-- Insert Services
INSERT INTO Services (Service_Name, Description, Charges) VALUES
('Room Service', 'Food and beverage delivery to room', 200.00),
('Laundry', 'Washing and ironing clothes', 150.00),
('Spa', 'Relaxing spa and massage services', 1500.00),
('Airport Transfer', 'Pick-up and drop service', 800.00),
('Extra Bed', 'Additional bed in room', 500.00),
('Breakfast', 'Complimentary breakfast service', 300.00),
('Mini Bar', 'In-room refreshments', 250.00),
('Gym Access', '24/7 gym facilities', 100.00);

-- Insert Staff
INSERT INTO Staff (Name, Dept, Age, Contact_Info, Salary, Join_Date) VALUES
('Rajesh Kumar', 'Front Desk', 28, '9876543210', 25000.00, '2023-01-15'),
('Priya Sharma', 'Housekeeping', 25, '9876543211', 20000.00, '2023-03-20'),
('Amit Patel', 'Maintenance', 35, '9876543212', 30000.00, '2022-11-10'),
('Sneha Reddy', 'Front Desk', 26, '9876543213', 24000.00, '2023-05-05'),
('Vikram Singh', 'Kitchen', 32, '9876543214', 28000.00, '2023-02-18');

-- Insert Sample Guests
INSERT INTO Guest (Name, Contact_Info, Email, Nationality, Gender) VALUES
('John Doe', '9123456789', 'john.doe@email.com', 'USA', 'Male'),
('Sarah Williams', '9123456788', 'sarah.w@email.com', 'UK', 'Female'),
('Rahul Verma', '9123456787', 'rahul.verma@email.com', 'India', 'Male'),
('Emily Chen', '9123456786', 'emily.chen@email.com', 'China', 'Female');
