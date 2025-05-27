

-- Trainees Table
CREATE TABLE Trainees (
    TraineeID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Program VARCHAR(50),
    GraduationDate DATE
);

-- Job Applicants Table
CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Source VARCHAR(20),
    AppliedDate DATE
);

-- Insert Trainees
INSERT INTO Trainees VALUES 
(1, 'Layla Al Riyami', 'layla.r@example.com', 'Full Stack .NET', '2025-04-30'),
(2, 'Salim Al Hinai', 'salim.h@example.com', 'Outsystems', '2025-03-15'),
(3, 'Fatma Al Amri', 'fatma.a@example.com', 'Database Admin', '2025-05-01');

-- Insert Applicants
INSERT INTO Applicants VALUES 
(101, 'Hassan Al Lawati', 'hassan.l@example.com', 'Website', '2025-05-02'),
(102, 'Layla Al Riyami', 'layla.r@example.com', 'Referral', '2025-05-05'),
(103, 'Aisha Al Farsi', 'aisha.f@example.com', 'Website', '2025-04-28');




-- PART 1: UNION PRACTICE

-- 1. Unique people (FullName + Email) from both tables
SELECT FullName, Email FROM Trainees
UNION
SELECT FullName, Email FROM Applicants;

-- 2. All records from both tables (with duplicates if any)
SELECT FullName, Email FROM Trainees
UNION ALL
SELECT FullName, Email FROM Applicants;

-- Observation: Layla Al Riyami appears twice because she exists in both tables with the same email.

-- 3. People who are in both tables (by Email)
SELECT t.FullName, t.Email
FROM Trainees t
INNER JOIN Applicants a ON t.Email = a.Email;



-- PART 2: DROP vs DELETE vs TRUNCATE

-- 4. DELETE a specific record (structure remains)
DELETE FROM Trainees WHERE Program = 'Outsystems';
-- Observation: One row removed; table and structure are intact.

-- 5. TRUNCATE (remove all rows fast, cannot be rolled back without transaction)
TRUNCATE TABLE Applicants;
-- Observation: All data deleted, no WHERE clause supported. Cannot rollback outside transaction.

-- 6. DROP table (structure gone)

-- Recreate Applicants table for transaction test
IF OBJECT_ID('Applicants', 'U') IS NOT NULL
    DROP TABLE Applicants;

CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Source VARCHAR(20),
    AppliedDate DATE
);



-- Transaction block to test rollback on error
BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Applicants VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');
    INSERT INTO Applicants VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11'); -- Duplicate ID
    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;

