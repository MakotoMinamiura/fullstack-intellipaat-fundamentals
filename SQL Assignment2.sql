SQL Assignment 2

SQLデータ分析によるフードデリバリープラットフォームの都市別レストランインサイト抽出

課題：
・ユーザー定義関数（UDF）を作成し、「Quick Bites」に「Chicken」を追加する。
　例：「Quick Bites」→「Quick Chicken Bites」

・上記の関数を使用して、最高評価のレストラン名と料理の種類を表示する。

・評価ステータス列を作成し、評価を以下のように分類する:
　4以上: 「Excellent（優秀）」、3.5より上、5未満: 「Good（良い）」、3より上、3.5以下: 「Average（普通）」
　3以下: 「Bad（悪い）」

・評価列のCeil（切り上げ）、Floor（切り下げ）、絶対値を取得し、現在の日付と以下の情報を個別に表示:
　年（Year）
　月名（Month Name）
　日（Day）

・レストランの種類ごとに、合計平均コストをROLLUPを使って表示する。

-- テーブル作成
CREATE TABLE restaurant_data (
    restaurant_id INT PRIMARY KEY IDENTITY(1,1),
    restaurant_name VARCHAR(255) NOT NULL,
    cuisine_type VARCHAR(255) NOT NULL,
    rating FLOAT CHECK (rating BETWEEN 0 AND 5),
    restaurant_type VARCHAR(255),
    average_cost INT
);

-- データ挿入
INSERT INTO restaurant_data (restaurant_name, cuisine_type, rating, restaurant_type, average_cost) VALUES
('Spicy Hub', 'Indian', 4.5, 'Casual Dining', 500),
('Tasty Treat', 'Chinese', 3.8, 'Fast Food', 300),
('Pizza Corner', 'Italian', 4.7, 'Pizzeria', 700),
('Golden Dragon', 'Chinese', 4.2, 'Fine Dining', 1200),
('Pasta Palace', 'Italian', 4.0, 'Casual Dining', 900),
('Burger Joint', 'American', 3.5, 'Fast Food', 400),
('Sushi World', 'Japanese', 4.8, 'Fine Dining', 1500);

-- ユーザー定義関数
CREATE FUNCTION addChickentoQuickBites(@dish_name VARCHAR(255))
RETURNS VARCHAR(255)
AS 
BEGIN
    RETURN CASE 
        WHEN CHARINDEX('Quick Bites', @dish_name) > 0 
        THEN STUFF(@dish_name, CHARINDEX('Quick Bites', @dish_name), LEN('Quick Bites'), 'Quick Chicken Bites')
        ELSE @dish_name 
    END;
END;

-- 動作確認
SELECT dbo.addChickentoQuickBites('Spicy Quick Bites') AS modified_dish;
SELECT dbo.addChickentoQuickBites('Quick Bites Special') AS modified_dish;
SELECT dbo.addChickentoQuickBites('Delicious Burger') AS modified_dish;

-- 最高評価のレストラン
SELECT TOP 1 WITH TIES restaurant_name, cuisine_type, rating AS max_rating
FROM restaurant_data
ORDER BY rating DESC;

-- 評価ステータス
SELECT 
    restaurant_name, 
    rating,
    CASE 
        WHEN rating > 4 THEN 'Excellent'
        WHEN rating > 3.5 THEN 'Good'
        WHEN rating > 3 THEN 'Average'
        ELSE 'Bad'
    END AS rating_status
FROM restaurant_data;

-- Ceil、Floor、絶対値、日付情報
SELECT 
    restaurant_name,
    rating,
    CEILING(rating) AS ceil_rating,
    FLOOR(rating) AS floor_rating,
    ABS(rating) AS abs_rating,
    CURRENT_TIMESTAMP AS today_date,
    YEAR(CURRENT_TIMESTAMP) AS year,
    MONTH(CURRENT_TIMESTAMP) AS month,
    DAY(CURRENT_TIMESTAMP) AS day
FROM restaurant_data;

-- Rollup（NULL対策）
SELECT 
    COALESCE(restaurant_type, 'Total') AS restaurant_type, 
    AVG(average_cost) AS total_avg_cost
FROM restaurant_data
GROUP BY ROLLUP(restaurant_type);





