﻿create database ProjectDB

use ProjectDB 

-- Table to store library branch information
CREATE TABLE Library(
  LibraryID INT PRIMARY KEY, -- Unique ID for each library
  Name VARCHAR(100) NOT NULL, -- Name of the library
  Location VARCHAR(255) NOT NULL, -- Address or city location
  ContactNumber VARCHAR(15) NOT NULL, -- Phone number
  EstablishedYear INT CHECK (EstablishedYear > 1800) -- Year the library was founded
);


-- Table to store books in the library
CREATE TABLE Book(
  BookID INT PRIMARY KEY, -- Unique ID for each book
  ISBN VARCHAR(20) UNIQUE NOT NULL, -- International standard book number
  Title VARCHAR(255) NOT NULL, -- Book title
  Genre VARCHAR(50) CHECK (Genre IN ('Fiction', 'Non-fiction', 'Reference', 'Children')), -- Only allowed genres
  Price DECIMAL(10, 2) CHECK (Price > 0), -- Price must be positive
  IsAvailable BIT DEFAULT 1, -- TRUE = available, FALSE = issued
  ShelfLocation VARCHAR(50), -- Physical shelf location in the library
  LibraryID INT, -- FK to link book to a library
  FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID) ON DELETE CASCADE -- Delete book if library is deleted
);

-- Table to store registered members
CREATE TABLE Member(
  MemberID INT PRIMARY KEY, -- Unique ID for each member
  FullName VARCHAR(100) NOT NULL, -- Full name of the member
  Email VARCHAR(100) UNIQUE NOT NULL, -- Email must be unique
  PhoneNumber VARCHAR(15), -- Optional phone number
  MembershipStartDate DATE NOT NULL -- Date the membership started
);

-- Table to track book loans
CREATE TABLE Loan(
  LoanID INT PRIMARY KEY, -- Unique loan transaction ID
  MemberID INT, -- FK to member who borrowed the book
  BookID INT, -- FK to book that was borrowed
  LoanDate DATE NOT NULL, -- Date when the book was issued
  DueDate DATE NOT NULL, -- Expected return date
  ReturnDate DATE, -- Actual return date (can be NULL if not returned)
  LoanStatus VARCHAR(20) DEFAULT 'Issued'
    CHECK (LoanStatus IN ('Issued', 'Returned', 'Overdue')), -- Status of loan
  FOREIGN KEY (MemberID) REFERENCES Member(MemberID), -- Link to Member
  FOREIGN KEY (BookID) REFERENCES Book(BookID) -- Link to Book
);

-- Table to track payments made for fines
CREATE TABLE Payment(
  PaymentID INT PRIMARY KEY, -- Unique ID for each payment
  LoanID INT, -- FK to the related loan
  PaymentDate DATE NOT NULL, -- Date payment was made
  Amount DECIMAL(10,2) CHECK (Amount > 0), -- Fine amount must be > 0
  Method VARCHAR(50) NOT NULL, -- Payment method (e.g., cash, card)
  FOREIGN KEY (LoanID) REFERENCES Loan(LoanID) ON DELETE CASCADE -- Delete payment if loan is deleted
);

-- Table to store staff working at libraries
CREATE TABLE Staff(
  StaffID INT PRIMARY KEY, -- Unique ID for each staff member
  FullName VARCHAR(100) NOT NULL, -- Full name of the staff
  Position VARCHAR(50), -- Job title or role
  ContactNumber VARCHAR(15), -- Phone number
  LibraryID INT, -- FK to the library where they work
  FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID) -- Each staff works at one library
);



-- Table to store book reviews by members
CREATE TABLE Review(
  ReviewID INT PRIMARY KEY, -- Unique ID for each review
  MemberID INT, -- FK to the member who wrote the review
  BookID INT, -- FK to the book being reviewed
  Rating INT CHECK (Rating BETWEEN 1 AND 5), -- Star rating (1-5)
  Comments TEXT DEFAULT 'No comments', -- Optional review text
  ReviewDate DATE, -- Date of the review
  FOREIGN KEY (MemberID) REFERENCES Member(MemberID), -- Reviewer
  FOREIGN KEY (BookID) REFERENCES Book(BookID) -- Book being reviewed
);


-- Libraries
INSERT INTO Library VALUES
(1, 'Downtown Central Library', 'Downtown, NY', '212-555-1000', 1950),
(2, 'Eastside Public Library', 'Eastside, CA', '310-555-2000', 1975),
(3, 'West Valley Library', 'West Valley, TX', '713-555-3000', 1995);

-- Staff
INSERT INTO Staff VALUES
(1, 'Alice Martin', 'Senior Librarian', '212-555-1111', 1),
(2, 'Brian Thompson', 'Archivist', '310-555-2222', 2),
(3, 'Catherine Lopez', 'Librarian', '713-555-3333', 3),
(4, 'David Chen', 'Assistant Librarian', '212-555-4444', 1);

-- Members
INSERT INTO Member VALUES
(1, 'Emma Stone', 'emma.stone@example.com', '111-222-3333', '2023-01-10'),
(2, 'Liam Johnson', 'liam.johnson@example.com', '222-333-4444', '2023-02-12'),
(3, 'Sophia Davis', 'sophia.davis@example.com', '333-444-5555', '2023-03-15'),
(4, 'Noah Wilson', 'noah.wilson@example.com', '444-555-6666', '2023-04-18'),
(5, 'Ava Miller', 'ava.miller@example.com', '555-666-7777', '2023-05-20'),
(6, 'Elijah Taylor', 'elijah.taylor@example.com', '666-777-8888', '2023-06-22');

-- Books
INSERT INTO Book VALUES
(1, '978-0143127741', 'The Alchemist', 'Fiction', 12.99, 1, 'A1', 1),
(2, '978-0451524935', '1984', 'Fiction', 10.50, 1, 'A2', 1),
(3, '978-0062315007', 'Sapiens', 'Non-fiction', 15.75, 1, 'B1', 2),
(4, '978-0131103627', 'C Programming Language', 'Reference', 32.00, 1, 'R1', 2),
(5, '978-0439064873', 'Harry Potter', 'Children', 9.99, 1, 'C1', 1),
(6, '978-0307465351', 'The Lean Startup', 'Non-fiction', 20.00, 0, 'B2', 3),
(7, '978-1593279509', 'Eloquent JavaScript', 'Reference', 25.99, 1, 'R2', 2),
(8, '978-0316769488', 'Catcher in the Rye', 'Fiction', 8.99, 0, 'A3', 1),
(9, '978-0064400558', 'Charlotte''s Web', 'Children', 7.49, 1, 'C2', 2),
(10, '978-1451673319', 'Fahrenheit 451', 'Fiction', 11.25, 1, 'A4', 3);

-- Loans
INSERT INTO Loan VALUES
(1, 1, 1, '2024-05-01', '2024-05-15', '2024-05-10', 'Returned'),
(2, 2, 2, '2024-05-03', '2024-05-17', NULL, 'Issued'),
(3, 3, 3, '2024-05-05', '2024-05-19', NULL, 'Overdue'),
(4, 4, 4, '2024-05-07', '2024-05-21', '2024-05-20', 'Returned'),
(5, 5, 5, '2024-05-08', '2024-05-22', NULL, 'Issued'),
(6, 6, 6, '2024-05-10', '2024-05-24', NULL, 'Issued'),
(7, 1, 7, '2024-05-12', '2024-05-26', NULL, 'Issued'),
(8, 2, 8, '2024-05-13', '2024-05-27', NULL, 'Issued'),
(9, 3, 9, '2024-05-15', '2024-05-29', NULL, 'Issued'),
(10, 4, 10, '2024-05-16', '2024-05-30', NULL, 'Issued');

-- Payments
INSERT INTO Payment VALUES
(1, 1, '2024-05-12', 5.00, 'Cash'),
(2, 3, '2024-05-22', 7.50, 'Card'),
(3, 4, '2024-05-21', 3.00, 'Online'),
(4, 6, '2024-05-25', 2.50, 'Cash');

-- Reviews
INSERT INTO Review VALUES
(1, 1, 1, 5, 'Amazing story!', '2024-05-11'),
(2, 2, 2, 4, 'Very thought-provoking.', '2024-05-12'),
(3, 3, 3, 5, 'Eye-opening read.', '2024-05-13'),
(4, 4, 4, 3, 'A bit technical.', '2024-05-14'),
(5, 5, 5, 5, 'Magical!', '2024-05-15'),
(6, 6, 6, 4, 'Great for entrepreneurs.', '2024-05-16');


-- Mark book as returned
UPDATE Loan SET ReturnDate = GETDATE(), LoanStatus = 'Returned' WHERE LoanID = 2;
UPDATE Book SET IsAvailable = 1 WHERE BookID = (SELECT BookID FROM Loan WHERE LoanID = 2);

-- Delete a review (simulate cleanup)
DELETE FROM Review WHERE ReviewID = 1;

-- Delete a payment (refund)
DELETE FROM Payment WHERE PaymentID = 1;


-- GET /loans/overdue
SELECT L.LoanID, M.FullName, B.Title, L.DueDate
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
JOIN Book B ON L.BookID = B.BookID
WHERE L.LoanStatus = 'Overdue';

-- GET /books/unavailable
SELECT BookID, Title FROM Book WHERE IsAvailable = 0;

-- GET /members/top-borrowers
SELECT M.FullName, COUNT(*) AS BooksBorrowed
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
GROUP BY M.FullName
HAVING COUNT(*) > 2;

-- GET /books/:id/ratings
SELECT B.Title, AVG(R.Rating) AS AvgRating
FROM Review R
JOIN Book B ON R.BookID = B.BookID
GROUP BY B.Title;

-- GET /libraries/:id/genres
SELECT Genre, COUNT(*) AS BookCount
FROM Book
WHERE LibraryID = 1
GROUP BY Genre;

-- GET /members/inactive
SELECT * FROM Member
WHERE MemberID NOT IN (SELECT DISTINCT MemberID FROM Loan);

-- GET /payments/summary
SELECT M.FullName, SUM(P.Amount) AS TotalPaid
FROM Payment P
JOIN Loan L ON P.LoanID = L.LoanID
JOIN Member M ON L.MemberID = M.MemberID
GROUP BY M.FullName;

-- GET /reviews
SELECT M.FullName, B.Title, R.Rating, R.Comments, R.ReviewDate
FROM Review R
JOIN Member M ON R.MemberID = M.MemberID
JOIN Book B ON R.BookID = B.BookID;

--Advance SELECT Queries

-- 1. GET /books/popular → Top 3 books by loan count
SELECT TOP 3 B.BookID, B.Title, COUNT(*) AS TimesLoaned
FROM Loan L
JOIN Book B ON L.BookID = B.BookID
GROUP BY B.BookID, B.Title
ORDER BY TimesLoaned DESC;

-- 2. GET /members/:id/history → Member's loan history
SELECT B.Title, L.LoanDate, L.ReturnDate
FROM Loan L
JOIN Book B ON L.BookID = B.BookID
WHERE L.MemberID = 1;

-- 3. GET /books/:id/reviews → Book reviews with member info
SELECT M.FullName, R.Rating, R.Comments, R.ReviewDate
FROM Review R
JOIN Member M ON R.MemberID = M.MemberID
WHERE R.BookID = 1;

-- 4. GET /libraries/:id/staff → Staff list by library
SELECT FullName, Position
FROM Staff
WHERE LibraryID = 1;

-- 5. GET /books/price-range?min=5&max=15 → Books by price range
SELECT BookID, Title, Price
FROM Book
WHERE Price BETWEEN 5 AND 15;

-- 6. GET /loans/active → Loans not yet returned
SELECT M.FullName, B.Title, L.LoanDate, L.DueDate
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
JOIN Book B ON L.BookID = B.BookID
WHERE L.ReturnDate IS NULL;

-- 7. GET /members/with-fines → Members who paid fines
SELECT DISTINCT M.MemberID, M.FullName
FROM Payment P
JOIN Loan L ON P.LoanID = L.LoanID
JOIN Member M ON L.MemberID = M.MemberID;

-- 8. GET /books/never-reviewed
SELECT BookID, Title
FROM Book
WHERE BookID NOT IN (SELECT DISTINCT BookID FROM Review);

-- 9. GET /members/:id/loan-history
SELECT B.Title, L.LoanDate, L.ReturnDate, L.LoanStatus
FROM Loan L
JOIN Book B ON L.BookID = B.BookID
WHERE L.MemberID = 1;

-- 10. GET /members/inactive
SELECT *
FROM Member
WHERE MemberID NOT IN (SELECT DISTINCT MemberID FROM Loan);

-- 11. GET /books/never-loaned
SELECT BookID, Title
FROM Book
WHERE BookID NOT IN (SELECT DISTINCT BookID FROM Loan);

-- 12. GET /payments → All payments with member & book info
SELECT M.FullName, B.Title, P.Amount, P.PaymentDate
FROM Payment P
JOIN Loan L ON P.LoanID = L.LoanID
JOIN Member M ON L.MemberID = M.MemberID
JOIN Book B ON L.BookID = B.BookID;

-- 13. GET /loans/overdue
SELECT M.FullName, B.Title, L.DueDate
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
JOIN Book B ON L.BookID = B.BookID
WHERE L.LoanStatus = 'Overdue';

-- 14. GET /books/:id/loan-count
SELECT B.BookID, B.Title, COUNT(*) AS TotalLoans
FROM Loan L
JOIN Book B ON L.BookID = B.BookID
WHERE B.BookID = 1
GROUP BY B.BookID, B.Title;

-- 15. GET /members/:id/fines → Total fines paid
SELECT M.FullName, SUM(P.Amount) AS TotalFines
FROM Payment P
JOIN Loan L ON P.LoanID = L.LoanID
JOIN Member M ON L.MemberID = M.MemberID
WHERE M.MemberID = 1
GROUP BY M.FullName;

-- 16. GET /libraries/:id/book-stats
SELECT
  SUM(CASE WHEN IsAvailable = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
  SUM(CASE WHEN IsAvailable = 0 THEN 1 ELSE 0 END) AS UnavailableBooks
FROM Book
WHERE LibraryID = 1;

-- 17. GET /reviews/top-rated
SELECT B.Title, AVG(R.Rating) AS AvgRating, COUNT(*) AS TotalReviews
FROM Review R
JOIN Book B ON R.BookID = B.BookID
GROUP BY B.Title
HAVING COUNT(*) > 5 AND AVG(R.Rating) > 4.5;


--Simple Views

-- 1. ViewAvailableBooks: Books that are available
CREATE VIEW ViewAvailableBooks AS
SELECT BookID, Title, Genre, Price
FROM Book
WHERE IsAvailable = 1;

-- 2. ViewActiveMembers: Members who joined in the last 12 months
CREATE VIEW ViewActiveMembers AS
SELECT MemberID, FullName, Email, MembershipStartDate
FROM Member
WHERE MembershipStartDate >= DATEADD(YEAR, -1, GETDATE());

-- 3. ViewLibraryContacts: Basic library directory
CREATE VIEW ViewLibraryContacts AS
SELECT LibraryID, Name, ContactNumber
FROM Library;


SELECT * FROM ViewAvailableBooks;
SELECT * FROM ViewActiveMembers;
SELECT * FROM ViewLibraryContacts;


--Transactions Simulation


BEGIN TRANSACTION;

BEGIN TRY
    -- Step 1: Insert a new loan record
    INSERT INTO Loan (LoanID, MemberID, BookID, LoanDate, DueDate, LoanStatus)
    VALUES (11, 1, 7, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Issued');

    -- Step 2: Mark the book as unavailable
    UPDATE Book
    SET IsAvailable = 0
    WHERE BookID = 7;

    -- Commit the transaction
    COMMIT;
    PRINT '✅ Transaction successful: Book loaned and availability updated.';
END TRY

BEGIN CATCH
    -- Roll back all changes if any error occurred
    ROLLBACK;

    -- Print the error
    PRINT '❌ Transaction failed. Error:';
    PRINT ERROR_MESSAGE();
END CATCH;


-- Aggregation Functions

-- 1. Count total books in each genre
SELECT Genre, COUNT(*) AS TotalBooks
FROM Book
GROUP BY Genre;

-- 2. Average rating per book
SELECT BookID, AVG(Rating) AS AvgRating
FROM Review
GROUP BY BookID;

-- 3. Total fine paid by each member
SELECT M.MemberID, M.FullName, SUM(P.Amount) AS TotalFines
FROM Payment P
JOIN Loan L ON P.LoanID = L.LoanID
JOIN Member M ON L.MemberID = M.MemberID
GROUP BY M.MemberID, M.FullName;

-- 4. Highest payment ever made
SELECT MAX(Amount) AS HighestPayment
FROM Payment;

-- 5. Number of loans per member
SELECT M.MemberID, M.FullName, COUNT(*) AS LoanCount
FROM Loan L
JOIN Member M ON L.MemberID = M.MemberID
GROUP BY M.MemberID, M.FullName;

-- 6. Book with the minimum price
SELECT Title, MIN(Price) OVER () AS MinPrice
FROM Book;

-- 7. Total number of active (unreturned) loans
SELECT COUNT(*) AS ActiveLoans
FROM Loan
WHERE ReturnDate IS NULL;

-- Full Backup 
BACKUP DATABASE ProjectDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\ProjectDB_FULL.bak'
WITH FORMAT,
     MEDIANAME = 'ProjectDB_FullBackup',
     NAME = 'Full Backup of ProjectDB';

	 -- Differential Backup 
BACKUP DATABASE ProjectDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\ProjectDB_DIFF.bak'
WITH DIFFERENTIAL,
     NAME = 'Differential Backup of ProjectDB';

	 -- Transaction Log Backup 
BACKUP LOG ProjectDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\ProjectDB_LOG.trn'
WITH NAME = 'Transaction Log Backup of ProjectDB';

-- Check the recovery model of the database
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'ProjectDB';


-- Set to FULL recovery model
ALTER DATABASE ProjectDB SET RECOVERY FULL;
