CREATE DATABASE TrainingDB;
USE TrainingDB;


CREATE TABLE Students (
StudentID INT PRIMARY KEY,
FullName NVARCHAR(100),
EnrollmentDate DATE
);


INSERT INTO Students VALUES
(1, 'Sara Ali', '2023-09-01'),
(2, 'Mohammed Nasser', '2023-10-15');



BACKUP DATABASE TrainingDB TO DISK = 'C:\backup\TrainingDB_Full.bak';


INSERT INTO Students VALUES (3, 'Fatma Said', '2024-01-10');


BACKUP DATABASE TrainingDB TO DISK = 'C:\backup\TrainingDB_Full.bak' WITH DIFFERENTIAL;


ALTER DATABASE TrainingDB SET RECOVERY FULL;
BACKUP LOG TrainingDB TO DISK = 'C:\backup\TrainingDB_Log.trn';


BACKUP DATABASE TrainingDB TO DISK = 'C:\backup\TrainingDB_CopyOnly.bak' WITH COPY_ONLY;