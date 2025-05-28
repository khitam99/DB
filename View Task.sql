CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(15),
    SSN CHAR(9)
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    Balance DECIMAL(10, 2),
    AccountType VARCHAR(50),
    Status VARCHAR(20)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT FOREIGN KEY REFERENCES Account(AccountID),
    Amount DECIMAL(10, 2),
    Type VARCHAR(10), -- Deposit or Withdraw
    TransactionDate DATETIME
);

CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
    LoanAmount DECIMAL(12, 2),
    LoanType VARCHAR(50),
    Status VARCHAR(20)
);

-- Customer Data
INSERT INTO Customer VALUES 
(1, 'Ali AlBusaidi', 'ali@example.com', '91234567', '123456789'),
(2, 'Sara AlZahra', 'sara@example.com', '92345678', '987654321');

-- Account Data
INSERT INTO Account VALUES 
(101, 1, 2500.00, 'Savings', 'Active'),
(102, 2, 1200.00, 'Checking', 'Inactive');

-- Transaction Data
INSERT INTO Transactions VALUES 
(1001, 101, 500.00, 'Deposit', DATEADD(DAY, -5, GETDATE())),
(1002, 102, 300.00, 'Withdraw', DATEADD(DAY, -40, GETDATE()));

-- Loan Data
INSERT INTO Loan VALUES 
(201, 1, 10000.00, 'Home', 'Approved'),
(202, 2, 5000.00, 'Auto', 'Pending');

CREATE VIEW CustomerServiceView AS
SELECT 
    c.FullName,
    c.Phone,
    a.Status AS AccountStatus
FROM Customer c
JOIN Account a ON c.CustomerID = a.CustomerID;

CREATE VIEW FinanceDeptView AS
SELECT 
    AccountID,
    Balance,
    AccountType
FROM Account;

CREATE VIEW LoanOfficerView AS
SELECT 
    LoanID,
    CustomerID,
    LoanAmount,
    LoanType,
    Status
FROM Loan;

CREATE VIEW RecentTransactionsView AS
SELECT 
    AccountID,
    Amount,
    TransactionDate
FROM Transactions
WHERE TransactionDate >= DATEADD(DAY, -30, GETDATE());

CREATE VIEW CustomerAccountSummary AS
SELECT 
    c.FullName,
    c.Phone,
    a.AccountID,
    a.Balance,
    a.Status
FROM Customer c
JOIN Account a ON c.CustomerID = a.CustomerID;



