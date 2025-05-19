-- Tạo bảng Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    city VARCHAR(100),
    email VARCHAR(100)
);

--  Tạo bảng Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

--  Tạo bảng Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    price INT
);

-- Thêm dữ liệu vào Customers
INSERT INTO Customers (name, city, email) VALUES
('Nguyen An', 'Hanoi', 'an.nguyen@email.com'),
('Tran Binh', 'Ho Chi Minh', NULL),
('Le Cuong', 'Da Nang', 'cuong.le@email.com'),
('Hoang Duong', 'Hanoi', 'duong.hoang@email.com');

--  Thêm dữ liệu vào Orders
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(101, 1, '2023-01-15', 500000),
(102, 3, '2023-02-10', 800000),
(103, 2, '2023-03-05', 300000),
(104, 1, '2023-04-01', 450000);

--  Thêm dữ liệu vào Products
INSERT INTO Products (product_id, name, price) VALUES
(1, 'Laptop Dell', 15000000),
(2, 'Mouse Logitech', 300000),
(3, 'Keyboard Razer', 1200000),
(4, 'Laptop HP', 14000000);

--  1. Khách hàng đến từ Hà Nội
SELECT * FROM Customers WHERE city = 'Hanoi';

--  2. Đơn hàng trên 400.000 và sau 31/01/2023
SELECT * FROM Orders
WHERE total_amount > 400000 AND order_date > '2023-01-31';

--  3. Khách hàng chưa có email
SELECT * FROM Customers WHERE email IS NULL;

--  4. Xem toàn bộ đơn hàng, sắp xếp giảm dần theo tổng tiền
SELECT * FROM Orders ORDER BY total_amount DESC;

--  5. Thêm khách hàng mới “Pham Thanh”
INSERT INTO Customers (name, city, email)
VALUES ('Pham Thanh', 'Can Tho', NULL);

--  6. Cập nhật email cho khách hàng có mã 2
UPDATE Customers
SET email = 'binh.tran@email.com'
WHERE customer_id = 2;

--  7. Xóa đơn hàng có mã 103
DELETE FROM Orders WHERE order_id = 103;

--  8. Lấy 2 khách hàng đầu tiên
SELECT * FROM Customers LIMIT 2;

-- 9. Đơn hàng có giá trị lớn nhất và nhỏ nhất
SELECT 
    MAX(total_amount) AS max_order_value,
    MIN(total_amount) AS min_order_value
FROM Orders;

--  10. Tổng số đơn hàng, tổng tiền, trung bình mỗi đơn hàng
SELECT 
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_order_value
FROM Orders;

--  11. Sản phẩm tên bắt đầu bằng 'Laptop'
SELECT * FROM Products
WHERE name LIKE 'Laptop%';

--  12. Giải thích RDBMS và mối quan hệ
-- RDBMS (Relational Database Management System) là hệ quản trị cơ sở dữ liệu quan hệ.
-- Trong hệ thống này, các bảng được liên kết với nhau thông qua khóa chính (primary key) và khóa ngoại (foreign key).
-- Ví dụ: Bảng Orders có customer_id liên kết tới Customers để biết ai đã đặt hàng.
-- Điều này giúp đảm bảo tính toàn vẹn dữ liệu, truy vấn linh hoạt, và dễ mở rộng hệ thống.
