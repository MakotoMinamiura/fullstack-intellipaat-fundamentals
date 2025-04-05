SQL Case-Study 1-1

課題：あなたはデータベース管理者です。
顧客に関する質問、特に異なる州からの売上と利益、マーケティング費用、売上原価（COGS）、予算利益などに
関してデータを使って分析しようとしています。
プライバシー上の理由から、顧客データのサンプルのみが提供されていますが、このサンプルを使ってSQLクエリを作成し、
必要な質問に答えられるようにしてください。

-- FactTable
CREATE TABLE FactTable (
    Date DATE,
    ProductID INT,
    Profit DECIMAL,
    Sales DECIMAL,
    Margin DECIMAL,
    COGS DECIMAL,
    Total_Expenses DECIMAL,
    Marketing DECIMAL,
    Inventory DECIMAL,
    Budget_Profit DECIMAL,
    Budget_COGS DECIMAL,
    Budget_Margin DECIMAL,
    Budget_Sales DECIMAL,
    Area_Code INT
);

-- ProductTable
CREATE TABLE ProductTable (
    Product_Type VARCHAR(50),
    Product VARCHAR(50),
    ProductID INT,
    Type VARCHAR(50)
);

-- LocationTable
CREATE TABLE LocationTable (
    Area_Code INT,
    State VARCHAR(50),
    Market VARCHAR(50),
    Market_Size VARCHAR(50)
);

1. LocationTableに存在する州の数を表示

SELECT COUNT(DISTINCT State) AS NumberOfStates FROM LocationTable;

2. Regular Typeの製品はいくつあるか？

SELECT COUNT(*) AS RegularProductCount FROM ProductTable WHERE Type = 'Regular';

3. ProductID = 1 のマーケティング費用の合計

SELECT SUM(Marketing) AS TotalMarketingSpend FROM FactTable WHERE ProductID = 1;

4. 最小売上

SELECT MIN(Sales) AS MinSales FROM FactTable;

5. 最大COGS（売上原価）

SELECT MAX(COGS) AS MaxCOGS FROM FactTable;

6. Product Type が Coffee の製品情報

SELECT * FROM ProductTable WHERE Product_Type = 'Coffee';

7. Total Expenses > 40 のレコード

SELECT * FROM FactTable WHERE Total_Expenses > 40;

8. Area Code = 719 の平均売上

SELECT AVG(Sales) AS AvgSales FROM FactTable WHERE Area_Code = 719;

9. Colorado州の総利益

SELECT SUM(f.Profit) AS TotalProfit
FROM FactTable f
JOIN LocationTable l ON f.Area_Code = l.Area_Code
WHERE l.State = 'Colorado';

10. 各ProductIDの平均在庫

SELECT ProductID, AVG(Inventory) AS AvgInventory FROM FactTable GROUP BY ProductID;

11. 州名を昇順で表示

SELECT DISTINCT State FROM LocationTable ORDER BY State;

12. 平均Budget Margin > 100 の製品の平均Budget Profit

SELECT ProductID, AVG(Budget_Profit) AS AvgBudgetProfit
FROM FactTable
GROUP BY ProductID
HAVING AVG(Budget_Margin) > 100;

13. 2010-01-01 の総売上

SELECT SUM(Sales) AS TotalSales FROM FactTable WHERE Date = '2010-01-01';

14. 各ProductIDの各日付における平均Total Expenses

SELECT Date, ProductID, AVG(Total_Expenses) AS AvgExpenses
FROM FactTable
GROUP BY Date, ProductID;

15. 特定の列を含む結合テーブル

SELECT f.Date, f.ProductID, p.Product_Type, p.Product, f.Sales, f.Profit, l.State, f.Area_Code
FROM FactTable f
JOIN ProductTable p ON f.ProductID = p.ProductID
JOIN LocationTable l ON f.Area_Code = l.Area_Code;

16. ギャップのない売上順位

SELECT ProductID, Sales,
       RANK() OVER (ORDER BY Sales DESC) AS SalesRank
FROM FactTable;

17. 州ごとの売上と利益

SELECT l.State, SUM(f.Sales) AS TotalSales, SUM(f.Profit) AS TotalProfit
FROM FactTable f
JOIN LocationTable l ON f.Area_Code = l.Area_Code
GROUP BY l.State;

18. 州ごとの売上・利益・製品名

SELECT l.State, p.Product, SUM(f.Sales) AS TotalSales, SUM(f.Profit) AS TotalProfit
FROM FactTable f
JOIN LocationTable l ON f.Area_Code = l.Area_Code
JOIN ProductTable p ON f.ProductID = p.ProductID
GROUP BY l.State, p.Product;

19. 売上5%増加後の売上表示

SELECT ProductID, Sales, Sales * 1.05 AS IncreasedSales FROM FactTable;

20. 最大利益を持つProductIDとProductType

SELECT TOP 1 f.ProductID, p.Product_Type, f.Profit
FROM FactTable f
JOIN ProductTable p ON f.ProductID = p.ProductID
ORDER BY f.Profit DESC;

21. Product Typeに基づくストアドプロシージャ（MySQL例）

CREATE PROCEDURE GetProductsByType
    @prodType VARCHAR(50)
AS
BEGIN
    SELECT * FROM ProductTable
    WHERE Product_Type = @prodType;
END;

22. Total Expensesが60未満ならProfit、それ以外はLoss

SELECT *,
       CASE WHEN Total_Expenses < 60 THEN 'Profit' ELSE 'Loss' END AS Status
FROM FactTable;

23. 日付と製品ごとの週次売上（ROLLUP付き）

SELECT Date, ProductID, SUM(Sales) AS WeeklySales
FROM FactTable
GROUP BY Date, ProductID WITH ROLLUP;

24. Area Codeを含むテーブルに対するUNIONとINTERSECT

-- UNION
SELECT Area_Code FROM FactTable
UNION
SELECT Area_Code FROM LocationTable;

-- INTERSECT (PostgreSQLの場合)
SELECT Area_Code FROM FactTable
INTERSECT
SELECT Area_Code FROM LocationTable;

25. ユーザー指定のProduct Typeを取得する関数

CREATE FUNCTION GetProductByType (@pType VARCHAR(50))
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @result VARCHAR(100);

    SELECT TOP 1 @result = Product
    FROM ProductTable
    WHERE Product_Type = @pType;

    RETURN @result;
END;

26. ProductID = 1 のProductTypeをCoffee → Teaに変更して元に戻す

-- 変更
UPDATE ProductTable SET Product_Type = 'Tea' WHERE ProductID = 1;

-- 元に戻す
UPDATE ProductTable SET Product_Type = 'Coffee' WHERE ProductID = 1;

27. Total Expenses が100～200の範囲にあるレコード

SELECT Date, ProductID, Sales
FROM FactTable
WHERE Total_Expenses BETWEEN 100 AND 200;

28. Product Type が Regular の製品を削除

DELETE FROM ProductTable WHERE Type = 'Regular';

29. Product列の5番目の文字のASCII値

SELECT ASCII(SUBSTRING(Product, 5, 1)) AS ASCIIValue
FROM ProductTable;









