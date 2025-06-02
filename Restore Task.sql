-- Step 1: Simulate system failure
DROP DATABASE TrainingDB;

-- Step 2: Restore the FULL backup
RESTORE DATABASE TrainingDB
FROM DISK = 'C:\Backup\TrainingDB_Full.bak'
WITH NORECOVERY;

-- Step 2: Restore the DIFFERENTIAL backup (if available)
RESTORE DATABASE TrainingDB
FROM DISK = 'C:\Backup\TrainingDB_Diff.bak'
WITH NORECOVERY;

-- Step 2: Restore the TRANSACTION LOG backup (if available)
RESTORE LOG TrainingDB
FROM DISK = 'C:\Backup\TrainingDB_Log.trn'
WITH RECOVERY;

-- Step 3: Verify the data
USE TrainingDB;
SELECT * FROM Students;
