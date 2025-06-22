-- Educators Recruit Business Scenario

-- Drop table if exists for idempotency
IF OBJECT_ID('dbo.Educators', 'U') IS NOT NULL
    DROP TABLE dbo.Educators;

-- Create table to store educator information
CREATE TABLE dbo.Educators (
    EducatorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    CollegeAttended VARCHAR(100) NOT NULL,
    DegreeTitle VARCHAR(100) NOT NULL,
    MediaSource VARCHAR(50) NOT NULL,
    DateContacted DATE NOT NULL,
    SchoolPlaced VARCHAR(100) NULL,
    DateFoundJob DATE NULL
);
GO

-- Insert sample data provided in the README
INSERT INTO dbo.Educators
    (FirstName, LastName, DateOfBirth, Gender, CollegeAttended, DegreeTitle, MediaSource, DateContacted, SchoolPlaced, DateFoundJob)
VALUES
    ('Mary', 'Lynn', '2000-09-13', 'female', 'Excelsior College', 'BA in Mathematics Education', 'magazine', '2022-05-02', 'Brooklyn High School', '2022-05-09'),
    ('Josh', 'Frank', '1998-04-23', 'male', 'Georgia State University', 'MA in Social Studies Education', 'social media site', '2022-02-12', 'Manhattan Elementary School', '2022-05-09'),
    ('Charles', 'Smith', '1994-07-09', 'male', 'Excelsior College', 'PhD in Education', 'social media site', '2021-08-07', 'New York City Day School', '2021-08-12'),
    ('Samantha', 'Brown', '1999-09-24', 'female', 'Columbia University', 'BA in English Education', 'newspaper', '2021-05-23', 'Brooklyn High School', '2021-07-30'),
    ('Howard', 'Lang', '1998-08-04', 'male', 'Georgia State University', 'MA in History Education', 'word of mouth', '2022-01-31', NULL, NULL),
    ('Sarah', 'Blanks', '1995-10-20', 'female', 'Columbia University', 'MA in Science Education', 'social media', '2020-05-23', 'New York City Day School', '2020-08-17'),
    ('Ella', 'Lewis', '2000-08-22', 'female', 'Excelsior College', 'BA in English Education', 'word of mouth', '2022-04-01', NULL, NULL),
    ('Julie', 'Goldman', '1997-03-30', 'female', 'University of Denver', 'MA in Social Studies Education', 'social media', '2020-07-14', 'Manhattan Elementary School', '2020-08-17');
GO

-- 1. Number of students from each college placed in under 2 weeks
SELECT
    CollegeAttended,
    COUNT(*) AS PlacedUnderTwoWeeks
FROM dbo.Educators
WHERE SchoolPlaced IS NOT NULL
  AND DATEDIFF(day, DateContacted, DateFoundJob) <= 14
GROUP BY CollegeAttended;
GO

-- 2. Successful placements by gender
SELECT
    Gender,
    COUNT(*) AS SuccessfulPlacements
FROM dbo.Educators
WHERE SchoolPlaced IS NOT NULL
GROUP BY Gender;
GO

-- 3. Average daily contacts and media distribution
-- Average contacts per day
SELECT
    AVG(CAST(ContactCount AS FLOAT)) AS AvgContactsPerDay
FROM (
    SELECT DateContacted, COUNT(*) AS ContactCount
    FROM dbo.Educators
    GROUP BY DateContacted
) AS DailyContacts;

-- Count per media source
SELECT
    MediaSource,
    COUNT(*) AS TotalContacts
FROM dbo.Educators
GROUP BY MediaSource;
GO

-- 4. Average placements per day
SELECT
    AVG(CAST(PlacementCount AS FLOAT)) AS AvgPlacementsPerDay
FROM (
    SELECT DateFoundJob, COUNT(*) AS PlacementCount
    FROM dbo.Educators
    WHERE DateFoundJob IS NOT NULL
    GROUP BY DateFoundJob
) AS DailyPlacements;
GO

-- 5. Daily placements per degree title
SELECT
    DateFoundJob,
    DegreeTitle,
    COUNT(*) AS Placements
FROM dbo.Educators
WHERE DateFoundJob IS NOT NULL
GROUP BY DateFoundJob, DegreeTitle
ORDER BY DateFoundJob, DegreeTitle;
GO

-- 6. List of educators with age and degree
SELECT
    FirstName,
    LastName,
    DATEDIFF(year, DateOfBirth, GETDATE()) AS Age,
    DegreeTitle
FROM dbo.Educators;
GO
