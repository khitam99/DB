-- STEP 1: Create Tables
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    JoinDate DATE
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100),
    InstructorID INT,
    CategoryID INT,
    Price DECIMAL(6,2),
    PublishDate DATE,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    JoinDate DATE
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollDate DATE,
    CompletionPercent INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- STEP 2: Insert Sample Data
INSERT INTO Instructors VALUES
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'),
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21');

INSERT INTO Categories VALUES
(1, 'Web Development'),
(2, 'Data Science'),
(3, 'Business');

INSERT INTO Courses VALUES
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'),
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'),
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'),
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01');

INSERT INTO Students VALUES
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'),
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'),
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10');

INSERT INTO Enrollments VALUES
(1, 201, 101, '2023-04-10', 100, 5),
(2, 202, 102, '2023-04-15', 80, 4),
(3, 203, 101, '2023-04-20', 90, 4),
(4, 201, 102, '2023-04-22', 50, 3),
(5, 202, 103, '2023-04-25', 70, 4),
(6, 203, 104, '2023-04-28', 30, 2),
(7, 201, 104, '2023-05-01', 60, 3);

-- BEGINNER LEVEL QUERIES
SELECT COUNT(*) AS TotalStudents FROM Students;
SELECT COUNT(*) AS TotalEnrollments FROM Enrollments;

SELECT CourseID, AVG(Rating) AS AvgRating
FROM Enrollments
GROUP BY CourseID;

SELECT InstructorID, COUNT(*) AS TotalCourses
FROM Courses
GROUP BY InstructorID;

SELECT CategoryID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY CategoryID;

SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollments
GROUP BY CourseID;

SELECT CategoryID, AVG(Price) AS AvgPrice
FROM Courses
GROUP BY CategoryID;

SELECT MAX(Price) AS MaxPrice FROM Courses;

SELECT CourseID, MIN(Rating), MAX(Rating), AVG(Rating)
FROM Enrollments
GROUP BY CourseID;

SELECT COUNT(*) AS Rating5Count
FROM Enrollments
WHERE Rating = 5;

-- INTERMEDIATE LEVEL QUERIES
SELECT CourseID, AVG(CompletionPercent) AS AvgCompletion
FROM Enrollments
GROUP BY CourseID;

SELECT StudentID, COUNT(*) AS Enrollments
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(*) > 1;

SELECT e.CourseID, COUNT(*) * c.Price AS Revenue
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
GROUP BY e.CourseID, c.Price;

SELECT i.FullName, COUNT(DISTINCT e.StudentID) AS UniqueStudents
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

SELECT ca.CategoryName, AVG(CourseEnrolls) AS AvgEnrollments
FROM (
    SELECT c.CategoryID, COUNT(e.StudentID) AS CourseEnrolls
    FROM Courses c
    LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
    GROUP BY c.CourseID, c.CategoryID
) AS CourseStats
JOIN Categories ca ON ca.CategoryID = CourseStats.CategoryID
GROUP BY ca.CategoryName;

SELECT i.FullName, AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

SELECT TOP 3 CourseID, COUNT(*) AS Enrollments
FROM Enrollments
GROUP BY CourseID
ORDER BY Enrollments DESC;


SELECT CourseID, AVG(DATEDIFF(DAY, EnrollDate, '2023-05-10')) AS AvgDays
FROM Enrollments
WHERE CompletionPercent = 100
GROUP BY CourseID;


SELECT CourseID,
       ROUND(100.0 * SUM(CASE WHEN CompletionPercent = 100 THEN 1 ELSE 0 END) / COUNT(*), 2) AS CompletionRate
FROM Enrollments
GROUP BY CourseID;

SELECT YEAR(PublishDate) AS Year, COUNT(*) AS CoursesPublished
FROM Courses
GROUP BY YEAR(PublishDate);


-- ADVANCED LEVEL QUERIES
SELECT TOP 1 StudentID, COUNT(*) AS CompletedCourses
FROM Enrollments
WHERE CompletionPercent = 100
GROUP BY StudentID
ORDER BY CompletedCourses DESC;


SELECT i.FullName, SUM(c.Price) AS Earnings
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

SELECT ca.CategoryName, AVG(e.Rating) AS AvgRating
FROM Categories ca
JOIN Courses c ON ca.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY ca.CategoryName
HAVING AVG(e.Rating) >= 4;

SELECT StudentID
FROM Enrollments
WHERE Rating < 3
GROUP BY StudentID
HAVING COUNT(*) > 1;

SELECT TOP 1 CourseID, AVG(CompletionPercent) AS AvgCompletion
FROM Enrollments
GROUP BY CourseID
ORDER BY AvgCompletion ASC;


SELECT e.StudentID
FROM Enrollments e
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.InstructorID = 1
GROUP BY e.StudentID
HAVING COUNT(DISTINCT c.CourseID) = (
    SELECT COUNT(*) FROM Courses WHERE InstructorID = 1
);

SELECT StudentID, CourseID, COUNT(*) AS RatingCount
FROM Enrollments
GROUP BY StudentID, CourseID, Rating
HAVING COUNT(*) > 1;

SELECT TOP 1 ca.CategoryName, AVG(e.Rating) AS AvgRating
FROM Categories ca
JOIN Courses c ON ca.CategoryID = c.CategoryID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY ca.CategoryName
ORDER BY AvgRating DESC;

