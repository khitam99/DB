Schema (All levels share these tables)
-------------------------------------------------------------------------------
-- Company table
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY,
    Name VARCHAR(100),
    Industry VARCHAR(50),
    City VARCHAR(50)
);

-- Job Seekers
CREATE TABLE JobSeekers (
    SeekerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    ExperienceYears INT,
    City VARCHAR(50)
);

-- Job Postings
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY,
    Title VARCHAR(100),
    CompanyID INT,
    Salary DECIMAL(10, 2),
    Location VARCHAR(50),
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);

-- Applications
CREATE TABLE Applications (
    AppID INT PRIMARY KEY,
    JobID INT,
    SeekerID INT,
    ApplicationDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (SeekerID) REFERENCES JobSeekers(SeekerID)
);

Sample Data
-------------------------------------------------------------------------
-- Companies
INSERT INTO Companies VALUES
(1, 'TechWave', 'IT', 'Muscat'),
(2, 'GreenEnergy', 'Energy', 'Sohar'),
(3, 'EduBridge', 'Education', 'Salalah');

-- Job Seekers
INSERT INTO JobSeekers VALUES
(101, 'Sara Al Busaidi', 'sara.b@example.com', 2, 'Muscat'),
(102, 'Ahmed Al Hinai', 'ahmed.h@example.com', 5, 'Nizwa'),
(103, 'Mona Al Zadjali', 'mona.z@example.com', 1, 'Salalah'),
(104, 'Hassan Al Lawati', 'hassan.l@example.com', 3, 'Muscat');

-- Jobs
INSERT INTO Jobs VALUES
(201, 'Software Developer', 1, 900, 'Muscat'),
(202, 'Data Analyst', 1, 800, 'Muscat'),
(203, 'Science Teacher', 3, 700, 'Salalah'),
(204, 'Field Engineer', 2, 950, 'Sohar');

-- Applications
INSERT INTO Applications VALUES
(301, 201, 101, '2025-05-01', 'Pending'),
(302, 202, 104, '2025-05-02', 'Shortlisted'),
(303, 203, 103, '2025-05-03', 'Rejected'),
(304, 204, 102, '2025-05-04', 'Pending');



-- Task 1: Show each applicant’s full name, the job title they applied for, and the company name
SELECT js.FullName, j.Title, c.Name AS CompanyName
FROM Applications a
INNER JOIN JobSeekers js ON a.SeekerID = js.SeekerID
INNER JOIN Jobs j ON a.JobID = j.JobID
INNER JOIN Companies c ON j.CompanyID = c.CompanyID;


-- Task 2: Show all job titles and their company names, even if nobody has applied
SELECT j.Title, c.Name AS CompanyName
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
INNER JOIN Companies c ON j.CompanyID = c.CompanyID;



-- Task 3: Find job seekers who applied to jobs in their own city
SELECT js.FullName, j.Title, js.City
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID
WHERE js.City = j.Location;



-- Task 4: List all job seekers and, if available, the job titles they applied to and status
SELECT js.FullName, j.Title, a.Status
FROM JobSeekers js
LEFT JOIN Applications a ON js.SeekerID = a.SeekerID
LEFT JOIN Jobs j ON a.JobID = j.JobID;


-- Task 5: Show each job title with the name of the job seeker who applied (if any)
SELECT j.Title, js.FullName
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
LEFT JOIN JobSeekers js ON a.SeekerID = js.SeekerID;


-- Task 6: Find job seekers who haven’t applied to any job (no NOT IN)
SELECT js.FullName, js.Email
FROM JobSeekers js
LEFT JOIN Applications a ON js.SeekerID = a.SeekerID
WHERE a.AppID IS NULL;


-- Task 7: Find companies that have no jobs posted at all
SELECT c.Name, c.City
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
WHERE j.JobID IS NULL;


-- Task 8: List all pairs of job seekers who live in the same city but are not the same person
SELECT js1.FullName AS Seeker1, js2.FullName AS Seeker2, js1.City
FROM JobSeekers js1
JOIN JobSeekers js2 ON js1.City = js2.City AND js1.SeekerID <> js2.SeekerID;


-- Task 9: Job seekers who applied to jobs with salary > 850 in different city
SELECT js.FullName, j.Title, j.Salary, js.City AS SeekerCity, j.Location AS JobCity
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID
WHERE j.Salary > 850 AND js.City <> j.Location;


-- Task 10: All job seekers and the job city they applied to (even if cities don't match)
SELECT js.FullName, js.City AS SeekerCity, j.Location AS JobLocation
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID;


-- Task 11: Show all job titles where no application has been submitted
SELECT j.Title
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
WHERE a.AppID IS NULL;


-- Task 12: Find job seekers who applied to jobs in their city
SELECT js.FullName, j.Title, js.City
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID
WHERE js.City = j.Location;


-- Task 13: Two job seekers who live in the same city but applied to different jobs
SELECT js1.FullName AS Seeker1, js2.FullName AS Seeker2, js1.City
FROM JobSeekers js1
JOIN Applications a1 ON js1.SeekerID = a1.SeekerID
JOIN Jobs j1 ON a1.JobID = j1.JobID
JOIN JobSeekers js2 ON js1.City = js2.City AND js1.SeekerID <> js2.SeekerID
JOIN Applications a2 ON js2.SeekerID = a2.SeekerID
JOIN Jobs j2 ON a2.JobID = j2.JobID
WHERE j1.JobID <> j2.JobID;


-- Task 14: Jobs applied to by seekers not from the same city as the job
SELECT js.FullName, j.Title, js.City AS SeekerCity, j.Location AS JobCity
FROM Applications a
JOIN JobSeekers js ON a.SeekerID = js.SeekerID
JOIN Jobs j ON a.JobID = j.JobID
WHERE js.City <> j.Location;


-- Task 15: List cities where job seekers live but no company is located
SELECT DISTINCT js.City
FROM JobSeekers js
LEFT JOIN Companies c ON js.City = c.City
WHERE c.CompanyID IS NULL;


