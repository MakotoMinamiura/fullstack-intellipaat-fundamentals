SQL Case-Study 1-1

---テーブル作成とデータ挿入（例）

CREATE TABLE Location (
    Location_ID INT PRIMARY KEY,
    City NVARCHAR(50)
);

INSERT INTO Location (Location_ID, City) VALUES
(122, 'New York'),
(123, 'Dallas'),
(124, 'Chicago'),
(167, 'Boston');

SELECT * FROM Location;

CREATE TABLE Department (
    Department_ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Location_ID INT FOREIGN KEY REFERENCES Location(Location_ID)
);

INSERT INTO Department (Department_ID, Name, Location_ID) VALUES
(10, 'Accounting', 122),
(20, 'Sales', 124),
(30, 'Research', 123),
(40, 'Operations', 167);

SELECT * FROM Department;

CREATE TABLE Job (
    Job_ID INT PRIMARY KEY,
    Designation NVARCHAR(50)
);

INSERT INTO Job (Job_ID, Designation) VALUES
(667, 'Clerk'),
(668, 'Staff'),
(669, 'Analyst'),
(670, 'Sales Person'),
(671, 'Manager'),
(672, 'President');

SELECT * FROM Job;

CREATE TABLE Employee1 (
    Employee_ID INT PRIMARY KEY,
    Last_Name NVARCHAR(50),
    First_Name NVARCHAR(50),
    Middle_Name NVARCHAR(50),
    Job_ID INT FOREIGN KEY REFERENCES Job(Job_ID),
    Hire_Date DATE,
    Salary INT,
    Commission INT,
    Department_ID INT FOREIGN KEY REFERENCES Department(Department_ID)
);

INSERT INTO Employee1 (Employee_ID, Last_Name, First_Name, Middle_Name, Job_ID, Hire_Date, Salary, Commission, Department_ID) VALUES
(7369, 'Smith', 'John', 'Q', 667, '1984-12-17', 800, NULL, 20),
(7499, 'Allen', 'Kevin', 'J', 670, '1985-02-20', 1600, 300, 30),
(755, 'Doyle', 'Jean', 'K', 671, '1985-04-04', 2850, NULL, 30),
(756, 'Dennis', 'Lynn', 'S', 671, '1985-05-15', 2750, NULL, 30),
(757, 'Baker', 'Leslie', 'D', 671, '1985-06-10', 2200, NULL, 40),
(7521, 'Wark', 'Cynthia', 'D', 670, '1985-02-22', 1250, 50, 30);

SELECT * FROM Employee1;

---簡単なクエリ

1. すべての従業員の詳細をリストする
SELECT * FROM Employee;

2. すべての部署の詳細をリストする
SELECT * FROM Department;

3. すべての職種（ジョブ）の詳細をリストする
SELECT * FROM Job;

4. すべてのロケーションをリストする
SELECT * FROM Location;

5. 名、姓、給与、コミッションをリストする
SELECT First_Name, Last_Name, Salary, Commission FROM Employee1;

6. エイリアス付きで従業員ID、姓、部署IDをリストする
SELECT 
    Employee_ID AS "ID of the Employee",
    Last_Name AS "Name of the Employee",
    Department_ID AS "Dep_id"
FROM Employee1;

7. 従業員の年間給与を名前付きでリストする

SELECT 
    First_Name, 
    Last_Name, 
    Salary * 12 AS Annual_Salary
FROM Employee1;

---WHERE条件
1. 「Smith」についての詳細をリストする
SELECT * FROM Employee1
WHERE Last_Name = 'Smith';

2. 部署20で働いている従業員をリストする
SELECT * FROM Employee1
WHERE Department_ID = 20;

3. 給与が2000〜3000の従業員をリストする
SELECT * FROM Employee1
WHERE Salary BETWEEN 2000 AND 3000;

4. 部署10または20で働いている従業員をリストする
SELECT * FROM Employee1
WHERE Department_ID IN (10, 20);

5. 部署10または30で働いていない従業員をリストする
SELECT * FROM Employee1
WHERE Department_ID NOT IN (10, 30);

6. 名前が'L'で始まる従業員をリストする
SELECT * FROM Employee1
WHERE First_Name LIKE 'L%';

7. 名前が'L'で始まり'E'で終わる従業員をリストする

SELECT * FROM Employee1
WHERE First_Name LIKE 'L%E';

8. 名前の長さが4文字で'J'で始まる従業員をリストする
SELECT * FROM Employee1
WHERE LEN(First_Name) = 4 AND First_Name LIKE 'J%';

9. 部署30にいて、給与が2500以上の従業員をリストする
SELECT * FROM Employee1
WHERE Department_ID = 30 AND Salary > 2500;

10. コミッションを受け取っていない従業員をリストする
SELECT * FROM Employee1
WHERE Commission IS NULL;

---ORDER BY

1. 従業員ID昇順で、従業員IDと姓をリストする
SELECT Employee_ID, Last_Name
FROM Employee1
ORDER BY Employee_ID ASC;

2. 給与降順で、従業員IDと名前をリストする
SELECT Employee_ID, First_Name, Last_Name
FROM Employee1
ORDER BY Salary DESC;

3. 姓昇順で従業員詳細をリストする
SELECT * 
FROM Employee1
ORDER BY Last_Name ASC;

4. 姓昇順、部署ID降順で従業員詳細をリストする
SELECT * 
FROM Employee1
ORDER BY Last_Name ASC, Department_ID DESC;

---GROUP BY と HAVING

1. 部署別の最高給与、最低給与、平均給与

SELECT Department_ID, 
       MAX(Salary) AS Max_Salary, 
       MIN(Salary) AS Min_Salary, 
       AVG(Salary) AS Avg_Salary
FROM Employee1
GROUP BY Department_ID;

2. 職種別の最高給与、最低給与、平均給与
SELECT Job_ID, 
       MAX(Salary) AS Max_Salary, 
       MIN(Salary) AS Min_Salary, 
       AVG(Salary) AS Avg_Salary
FROM Employee1
GROUP BY Job_ID;

3. 月ごとの入社人数（昇順）
SELECT MONTH(Hire_Date) AS Month, 
       COUNT(*) AS Num_Employees
FROM Employee1
GROUP BY MONTH(Hire_Date)
ORDER BY Month;

4. 年月ごとの入社人数（年・月昇順）
SELECT YEAR(Hire_Date) AS Year, 
       MONTH(Hire_Date) AS Month, 
       COUNT(*) AS Num_Employees
FROM Employee1
GROUP BY YEAR(Hire_Date), MONTH(Hire_Date)
ORDER BY Year, Month;

5. 最低4人の従業員がいる部署
SELECT Department_ID
FROM Employee1
GROUP BY Department_ID
HAVING COUNT(*) >= 4;

6. 2月に入社した従業員数
SELECT COUNT(*) AS Feb_Joiners
FROM Employee1
WHERE MONTH(Hire_Date) = 2;

7. 5月または6月に入社した従業員数
SELECT COUNT(*) AS May_June_Joiners
FROM Employee1
WHERE MONTH(Hire_Date) IN (5, 6);

8. 1985年に入社した従業員数

SELECT COUNT(*) AS Joiners_1985
FROM Employee1
WHERE YEAR(Hire_Date) = 1985;

9. 1985年の月ごとの入社人数
SELECT MONTH(Hire_Date) AS Month, 
       COUNT(*) AS Num_Employees
FROM Employee1
WHERE YEAR(Hire_Date) = 1985
GROUP BY MONTH(Hire_Date)
ORDER BY Month;

10. 1985年4月に入社した従業員数
SELECT COUNT(*) AS April_1985_Joiners
FROM Employee1
WHERE YEAR(Hire_Date) = 1985 AND MONTH(Hire_Date) = 4;

11. 1985年4月に3人以上入社した部署ID
SELECT Department_ID
FROM Employee1
WHERE YEAR(Hire_Date) = 1985 AND MONTH(Hire_Date) = 4
GROUP BY Department_ID
HAVING COUNT(*) >= 3;

---JOIN（結合）

1. 従業員とその部署名をリストする
SELECT e.First_Name, e.Last_Name, d.Name AS Department_Name
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID;

2. 従業員とその役職をリストする
SELECT e.First_Name, e.Last_Name, j.Designation
FROM Employee1 e
JOIN Job j ON e.Job_ID = j.Job_ID;

3. 従業員と部署名・都市名をリストする
SELECT e.First_Name, e.Last_Name, d.Name AS Department_Name, l.City
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID
JOIN Location l ON d.Location_ID = l.Location_ID;

4. 各部署で働いている従業員数（部署名付き）
SELECT d.Name AS Department_Name, COUNT(*) AS Num_Employees
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID
GROUP BY d.Name;

5. 営業部門で働いている従業員数
SELECT COUNT(*) AS Sales_Employees
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID
WHERE d.Name = 'Sales';

6. 3人以上の従業員がいる部署（部署名付き、昇順）
SELECT d.Name AS Department_Name
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID
GROUP BY d.Name
HAVING COUNT(*) >= 3
ORDER BY d.Name;

7. ダラスで働いている従業員数
SELECT COUNT(*)
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID
JOIN Location l ON d.Location_ID = l.Location_ID
WHERE l.City = 'Dallas';

8. 営業またはオペレーション部門の従業員
SELECT e.*
FROM Employee1 e
JOIN Department d ON e.Department_ID = d.Department_ID
WHERE d.Name IN ('Sales', 'Operations');

--- 条件付き文（CASE）

1. 給与グレードを付けた従業員詳細を表示する
SELECT 
    Employee_ID,
    First_Name,
    Last_Name,
    Salary,
    CASE 
        WHEN Salary >= 3000 THEN 'A'
        WHEN Salary >= 2000 THEN 'B'
        WHEN Salary >= 1000 THEN 'C'
        ELSE 'D'
    END AS Grade
FROM Employee1;

2. グレード別の従業員数をリストする
SELECT 
    CASE 
        WHEN Salary >= 3000 THEN 'A'
        WHEN Salary >= 2000 THEN 'B'
        WHEN Salary >= 1000 THEN 'C'
        ELSE 'D'
    END AS Grade,
    COUNT(*) AS Num_Employees
FROM Employee1
GROUP BY 
    CASE 
        WHEN Salary >= 3000 THEN 'A'
        WHEN Salary >= 2000 THEN 'B'
        WHEN Salary >= 1000 THEN 'C'
        ELSE 'D'
    END;

3. 給与2000〜5000の範囲で、給与グレードと従業員数を表示する
SELECT 
    CASE 
        WHEN Salary >= 3000 THEN 'A'
        WHEN Salary >= 2000 THEN 'B'
    END AS Grade,
    COUNT(*) AS Num_Employees
FROM Employee1
WHERE Salary BETWEEN 2000 AND 5000
GROUP BY 
    CASE 
        WHEN Salary >= 3000 THEN 'A'
        WHEN Salary >= 2000 THEN 'B'
    END;

---サブクエリ（Subqueries）

1. 最高給与を得ている従業員をリストする
SELECT * 
FROM Employee1
WHERE Salary = (SELECT MAX(Salary) FROM Employee1);

2. 営業部門で働いている従業員をリストする
SELECT e.*
FROM Employee1 e
WHERE Department_ID = (
    SELECT Department_ID
    FROM Department
    WHERE Name = 'Sales'
);

3. 「Clerk」として働いている従業員をリストする

SELECT e.*
FROM Employee1 e
WHERE Job_ID = (
    SELECT Job_ID
    FROM Job
    WHERE Designation = 'Clerk'
);

4. 「Boston」に住んでいる従業員をリストする
SELECT e.*
FROM Employee1 e
WHERE Department_ID IN (
    SELECT Department_ID
    FROM Department
    WHERE Location_ID = (
        SELECT Location_ID
        FROM Location
        WHERE City = 'Boston'
    )
);

5. 営業部門で働いている従業員数をリストする

SELECT COUNT(*)
FROM Employee1
WHERE Department_ID = (
    SELECT Department_ID
    FROM Department
    WHERE Name = 'Sales'
);

6. Clerkの給与を10%上げる
UPDATE Employee1
SET Salary = Salary * 1.10
WHERE Job_ID = (
    SELECT Job_ID
    FROM Job
    WHERE Designation = 'Clerk'
);

SELECT Salary from Employee1;

7. 2番目に高い給与を得ている従業員をリストする

SELECT TOP 1 *
FROM Employee1
WHERE Salary < (SELECT MAX(Salary) FROM Employee1)
ORDER BY Salary DESC;

8. 部署30の全員よりも多く稼いでいる従業員をリストする
SELECT *
FROM Employee1
WHERE Salary > ALL (
    SELECT Salary
    FROM Employee1
    WHERE Department_ID = 30
);

9. 従業員がいない部署をリストする
SELECT Department_ID, Name
FROM Department
WHERE Department_ID NOT IN (
    SELECT DISTINCT Department_ID
    FROM Employee1
);

10. 自分の部署の平均給与より多く稼いでいる従業員をリストする
SELECT *
FROM Employee1 e1
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee1 e2
    WHERE e1.Department_ID = e2.Department_ID
);

