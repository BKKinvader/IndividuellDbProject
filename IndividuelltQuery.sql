


-----------------------------------------------------------------------------------------
--GetEmployeeInfo(1)
--Skapa procedure med information om alla som jobbar i skolan och hur länge de har jobbat
CREATE PROCEDURE GetEmployeeInfo
AS
BEGIN
    SELECT Employees.name AS EmployeeName, Department.departmentName AS DepartmentName, 
           SUM(DATEDIFF(day, Employees.start_date, GETDATE())) / 365 AS TotalYearsWorked
    FROM Employees
    JOIN Department ON Employees.department_id = Department.Id
    GROUP BY Employees.name, Department.departmentName
END

---------------------------------------------
--Lägga till ny employee PROCEDURE (2)
CREATE PROCEDURE AddNewEmployee 
(
	@Name varchar(50), 
	@StartDate date, 
	@DepartmentId int)
AS
BEGIN
    INSERT INTO Employees (name, start_date, department_id)
    VALUES (@Name, @StartDate, @DepartmentId)
END


-----------------------------------------------
-- Add new student procedure (3)
CREATE PROCEDURE AddNewStudent
(
    @Name NVARCHAR(50),
	@SecurityNumber NVARCHAR(50),
	@ContactInfo NVARCHAR(50), 
	@ParentID INT,
    @ClassID INT,
    @EnrollmentDate DATE
)
AS
BEGIN
    INSERT INTO Students (name, security_number,contact_info, parent_id, class_id, enrollment_date)
    VALUES (@Name,@SecurityNumber,@ContactInfo,@ParentID, @ClassID, @EnrollmentDate)
END
---------------------------------------------------------------------------------------------------------
--SetStudentGrade by ID (4)
CREATE PROCEDURE SetStudentGradeById
(

    @StudentID INT,
    @CourseID INT,
    @Grade DECIMAL(5,2),
    @TeacherID INT
)
AS
BEGIN
DECLARE @today AS DATE = GETDATE();
    INSERT INTO Grades (student_id, course_id, grade, grade_date, teacher_id)
    VALUES (@StudentID, @CourseID, @Grade, @today, @TeacherID)
END

-----------------------------------------------------------------------------------------------------------
--SetGrade By Name (5)
CREATE PROCEDURE SetStudentGradeByName 
(
	@studentName NVARCHAR(50), 
	@courseID INT, 
	@teacherID INT, 
	@grade DECIMAL(5, 2), 
	@date DATE)
AS
BEGIN
    DECLARE @studentID INT
    SET @studentID = (SELECT id FROM Students WHERE Name = @studentName)
    IF @studentID IS NOT NULL
    BEGIN
        INSERT INTO Grades (student_id, course_id, teacher_id, grade, grade_date)
        VALUES (@studentID, @courseID, @teacherID, @grade, @date)
    END
END
-------------------------------------------------------------------------------------------------
--Check student grades (6)
CREATE PROCEDURE GetStudentGrades (@studentName NVARCHAR(50))
AS
BEGIN
    SELECT Students.name AS 'Student Name', Courses.name as 'CourseName', Classes.name AS 'Class Name', Grades.grade, 
           Employees.name AS 'Teacher Name', Grades.grade_date
    FROM Students
	INNER JOIN Grades ON Students.id = Grades.student_id
	INNER JOIN Courses ON Grades.course_id = Courses.id
    INNER JOIN Classes ON Students.class_id = Classes.id
    INNER JOIN Employees ON Employees.id = Grades.teacher_id
    WHERE Students.name = @studentName
    ORDER BY Grades.grade_date DESC;
END
--------------------------------------------------------------------------------------------------------
--Total salary in VIEW (7)
CREATE VIEW SalarySummary AS
SELECT Department.departmentName AS Department, SUM(Employees.salary) AS TotalSalary, COUNT(Employees.id) AS EmployeeCount
FROM Department
INNER JOIN Employees ON Department.id = Employees.department_id
GROUP BY Department.departmentName
----------------------------------------------------------------------------------------------------------
--Average salary (8)
CREATE VIEW AverageSalary AS
SELECT Department.departmentName AS Department, AVG(Employees.salary) AS AverageSalary,COUNT(Employees.id) AS EmployeeCount
FROM Department
INNER JOIN Employees ON Department.id= Employees.department_id
GROUP BY Department.departmentName
-----------------------------------------------------------------------------------------------------------
--Create procedure to recive studentID number and get information about the student (9)
CREATE PROCEDURE GetStudentsInfo (@id INT)
AS
BEGIN
	SELECT Students.id, Students.name, Students.security_number AS SecurityNum, Classes.name AS Class, Students.contact_info AS Phone, Parents.name AS Parent
	FROM Students
	INNER JOIN Classes ON Students.class_id = Classes.id
	INNER JOIN Parents ON Students.parent_id = Parents.id
	WHERE Students.id = @id
END
------------------------------------------------------------------------------------------------------------
--Set Grades for students by Transactions (10)
CREATE PROCEDURE SetStudentGradeByTransaction (@StudentId INT, @CourseId INT, @Grade INT, @TeacherId INT)
AS
BEGIN TRY
   BEGIN TRANSACTION
   DECLARE @today AS DATE = GETDATE();
 
   IF NOT EXISTS (SELECT * FROM Students WHERE Students.id = @StudentId)
   BEGIN
      PRINT 'Student was not found';
      ROLLBACK TRANSACTION
   END
    IF NOT EXISTS (SELECT * FROM Employees WHERE Employees.id = @TeacherId)
   BEGIN
      PRINT 'Teacher was not found';
      ROLLBACK TRANSACTION
   END
   ELSE
   BEGIN
      -- Insert grade into the Grades table
      INSERT INTO Grades (student_id, course_id, grade, teacher_id, grade_date)
      VALUES (@StudentId, @CourseId, @Grade, @TeacherId, @today)

      COMMIT TRANSACTION
   END
END TRY
BEGIN CATCH
   ROLLBACK TRANSACTION
   PRINT 'Incorrect data';
END CATCH
--------------------------------------------------------------------------------------------------------------
             










--EXEC (1) GetEmployeeInfo procedure
EXEC GetEmployeeInfo
---------------------------------------------------------------------------------------------------

--EXEC (2) Add Employee
-- För att adda employee så måste man execute AddNewEmployee + name, start_date och department_id
-- Använd GetDate(); om man vill ha dagens datum
--DECLARE @today AS DATE = GETDATE();
EXEC AddNewEmployee 'Sam Smith', '2022-01-01', 2
-----------------------------------------------

--EXEC (3)
-- Execute AddNewStudent Namn,Personnummer, kontaktinfo, föräldrarID, klass och datum de började
EXEC AddNewStudent 'Lara Craft', '000506-3433','0709495663',4 ,1 ,'2022-01-01'
-------------------------------------------------------------------------------------------------------

--EXEC (4) SetStudent grade by ID
--Add student_id, course_id, grade, grade_date, teacher_id
EXEC SetStudentGradeById  
	@StudentID = 2,
    @CourseID = 5,
    @Grade = 2,
    @TeacherID = 5
------------------------------------------------------------------------------------------------------------

--EXEC (5) Add Student grade by Name
--Funkar bara om studentens namn finns
EXEC SetStudentGradeByName 'Tim Nilsson', 1, 2, 5, '2022-01-01'
-----------------------------------------------------------------------------------------------------------

--EXEC (6) Check grades by Name
EXEC GetStudentGrades 'Tim Nilsson'
------------------------------------------------------------------------------------------------------------
--View (7) SalarySummary
SELECT * FROM SalarySummary
------------------------------------------------------------------------------------------------------------
--View (8) AverageSalary
SELECT * FROM AverageSalary
----------------------------------------------------------------------------------------------------------
--EXEC (9) GetStudentInfo by ID
EXEC GetStudentsInfo @id = 1
--------------------------------------------------------------------------------------------------------------
--EXEC (10) Transaction StudentID and TeacherID do not exist
 EXEC SetStudentGradeByTransaction 
	@StudentId = 20,
	@CourseId = 2,
	@Grade = 4,
	@TeacherId = 20
--------------------------------------------------------------------------------------------------------------