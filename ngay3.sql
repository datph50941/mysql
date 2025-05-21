
-- Bảng Candidates
CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    years_exp INT,
    expected_salary INT
);

-- Bảng Jobs
CREATE TABLE Jobs (
    job_id INT PRIMARY KEY,
    title VARCHAR(100),
    department VARCHAR(50),
    min_salary INT,
    max_salary INT
);

-- Bảng Applications
CREATE TABLE Applications (
    app_id INT PRIMARY KEY,
    candidate_id INT,
    job_id INT,
    apply_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);

-- Bảng ShortlistedCandidates
CREATE TABLE ShortlistedCandidates (
    candidate_id INT,
    job_id INT,
    selection_date DATE
);


-- Candidates
INSERT INTO Candidates VALUES
(1, 'Nguyen Van A', 'a@gmail.com', '0900000001', 2, 800),
(2, 'Tran Thi B', 'b@gmail.com', NULL, 0, 500),
(3, 'Le Van C', 'c@gmail.com', '0900000003', 5, 1200),
(4, 'Pham Van D', 'd@gmail.com', NULL, 7, 2000);

-- Jobs
INSERT INTO Jobs VALUES
(101, 'Lập trình viên PHP', 'IT', 700, 1500),
(102, 'Nhân sự tổng hợp', 'HR', 600, 1000),
(103, 'Quản lý hệ thống', 'IT', 1000, 2000),
(104, 'Thực tập sinh Marketing', 'Marketing', 300, 500);

-- Applications
INSERT INTO Applications VALUES
(1001, 1, 101, '2024-05-01', 'Accepted'),
(1002, 2, 102, '2024-05-02', 'Pending'),
(1003, 3, 103, '2024-05-03', 'Rejected'),
(1004, 4, 103, '2024-05-04', 'Accepted');

-- ============================================
-- 3. Truy vấn yêu cầu
-- ============================================

-- 1. Ứng viên đã ứng tuyển vào phòng ban "IT"
SELECT *
FROM Candidates c
WHERE EXISTS (
    SELECT 1
    FROM Applications a
    JOIN Jobs j ON a.job_id = j.job_id
    WHERE a.candidate_id = c.candidate_id
      AND j.department = 'IT'
);

-- 2. Công việc có lương tối đa > lương mong đợi của bất kỳ ứng viên nào
SELECT *
FROM Jobs
WHERE max_salary > ANY (
    SELECT expected_salary
    FROM Candidates
);

-- 3. Công việc có lương tối thiểu > lương mong đợi của tất cả ứng viên
SELECT *
FROM Jobs
WHERE min_salary > ALL (
    SELECT expected_salary
    FROM Candidates
);

-- 4. Chèn ứng viên 'Accepted' vào bảng ShortlistedCandidates
INSERT INTO ShortlistedCandidates (candidate_id, job_id, selection_date)
SELECT candidate_id, job_id, CURRENT_DATE
FROM Applications
WHERE status = 'Accepted';

-- 5. Hiển thị ứng viên kèm mức kinh nghiệm
SELECT 
    full_name,
    years_exp,
    CASE 
        WHEN years_exp < 1 THEN 'Fresher'
        WHEN years_exp BETWEEN 1 AND 3 THEN 'Junior'
        WHEN years_exp BETWEEN 4 AND 6 THEN 'Mid-level'
        ELSE 'Senior'
    END AS experience_level
FROM Candidates;

-- 6. Liệt kê ứng viên, nếu phone NULL thì hiển thị 'Chưa cung cấp'
SELECT 
    full_name,
    email,
    COALESCE(phone, 'Chưa cung cấp') AS phone
FROM Candidates;

-- 7. Công việc có lương tối đa ≠ tối thiểu và max_salary ≥ 1000
SELECT *
FROM Jobs
WHERE max_salary != min_salary
  AND max_salary >= 1000;
