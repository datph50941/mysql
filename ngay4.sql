--  1. XÓA CSDL nếu đã tồn tại
DROP DATABASE IF EXISTS OnlineLearning;

-- 2. TẠO CSDL OnlineLearning
CREATE DATABASE OnlineLearning;

--  3. SỬ DỤNG CSDL OnlineLearning
USE OnlineLearning;

--  4. TẠO BẢNG Students
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,               -- Primary key
    full_name VARCHAR(100) NOT NULL,                         -- NOT NULL
    email VARCHAR(100) UNIQUE,                               -- UNIQUE
    join_date DATE DEFAULT (CURDATE())                       -- DEFAULT là ngày hiện tại
);

--  5. TẠO BẢNG Courses
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,                -- Primary key
    title VARCHAR(100) NOT NULL,                             -- NOT NULL
    description TEXT,
    price INT,                                               -- Giá
    CHECK (price >= 0)                                       -- CHECK >= 0
);

--  6. TẠO BẢNG Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,            -- Primary key
    student_id INT,                                          -- FK đến Students
    course_id INT,                                           -- FK đến Courses
    enroll_date DATE DEFAULT (CURDATE()),                    -- DEFAULT ngày hiện tại
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

--  7. THÊM CỘT status vào bảng Enrollments
ALTER TABLE Enrollments
ADD COLUMN status VARCHAR(20) DEFAULT 'active';

--  8. THÊM DỮ LIỆU MẪU vào Students
INSERT INTO Students (full_name, email)
VALUES
    ('Nguyễn Văn A', 'a@example.com'),
    ('Trần Thị B', 'b@example.com'),
    ('Lê Văn C', 'c@example.com');

--  9. THÊM DỮ LIỆU MẪU vào Courses
INSERT INTO Courses (title, description, price)
VALUES
    ('HTML & CSS', 'Thiết kế giao diện cơ bản.', 500000),
    ('PHP cơ bản', 'Học lập trình PHP từ đầu.', 1000000),
    ('MySQL nâng cao', 'Tối ưu và xử lý truy vấn SQL.', 800000);

-- 10. THÊM DỮ LIỆU MẪU vào Enrollments
INSERT INTO Enrollments (student_id, course_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3);

-- 11. TẠO VIEW StudentCourseView
CREATE VIEW StudentCourseView AS
SELECT 
    s.full_name AS student_name,
    c.title AS course_title,
    e.enroll_date,
    e.status
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 12. TẠO INDEX trên cột title của bảng Courses
CREATE INDEX idx_title ON Courses(title);

--  13. (TÙY CHỌN) XÓA bảng Enrollments nếu không cần
-- DROP TABLE IF EXISTS Enrollments;

-- 14. TEST truy vấn VIEW
-- SELECT * FROM StudentCourseView;
