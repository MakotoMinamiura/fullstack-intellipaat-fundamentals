SQL Assignment 3

クライアントから提供されたデータセットの分析

課題：
・予約数がゼロでないレストランの名前、種類、料理を表示するストアドプロシージャの作成。
・トランザクションを使用して、料理タイプ ‘Cafe’ を ‘Cafeteria’ に更新し、その結果を確認した後のロールバック。
・レストランの評価が最も高い上位 5 地域の行番号付き情報取得。
・WHILEループを使用した１から５０までの情報表示。
・評価が最も高い上位５つのレストランを保存する "TopRating" ビューの作成。
・新しいレコードが挿入されたときにメッセージを表示するトリガーの作成。

---データベースの作成
CREATE DATABASE JomatoDB2;
USE JomatoDB2;

---テーブル作成
CREATE TABLE restaurant_data (
    id INT IDENTITY(1,1) PRIMARY KEY,
    restaurant_name VARCHAR(255) NOT NULL,
    restaurant_type VARCHAR(100) NOT NULL,
    cuisine VARCHAR(100) NOT NULL,
    rating FLOAT NOT NULL,
    area VARCHAR(100) NOT NULL,
    table_booking INT NOT NULL
);

---データ挿入
INSERT INTO restaurant_data (restaurant_name, restaurant_type, cuisine, rating, area, table_booking) VALUES
('Italian Bistro', 'Fine Dining', 'Italian', 4.5, 'Downtown', 5),
('Sushi House', 'Casual Dining', 'Japanese', 4.8, 'Uptown', 3),
('Spicy Indian', 'Fast Food', 'Indian', 4.2, 'Midtown', 2),
('Gourmet Café', 'Café', 'Cafe', 4.0, 'Downtown', 4),
('Fusion Delight', 'Casual Dining', 'Fusion', 4.6, 'Downtown', 6),
('BBQ Corner', 'Fast Food', 'BBQ', 3.9, 'Uptown', 0),
('Seafood Paradise', 'Fine Dining', 'Seafood', 4.7, 'Seaside', 8),
('Taco Fiesta', 'Casual Dining', 'Mexican', 4.1, 'Midtown', 1),
('Vegan Haven', 'Healthy Dining', 'Vegan', 4.3, 'Uptown', 2),
('Classic Diner', 'Diner', 'American', 3.8, 'Midtown', 0);


SELECT * FROM restaurant_data;

---予約数が０ではないレストランを取得

CREATE PROCEDURE GetRestaurantsWithBookings
AS
BEGIN
    SELECT restaurant_name, restaurant_type, cuisine
    FROM restaurant_data
    WHERE table_booking > 0;
END;

SELECT * FROM restaurant_data;

EXEC GetRestaurantsWithBookings;

---トランザクション

BEGIN TRANSACTION;

UPDATE restaurant_data
SET cuisine = 'Cafeteria'
WHERE cuisine = 'Cafe';

-- 確認
SELECT * FROM restaurant_data WHERE cuisine = 'Cafeteria';

-- ロールバック
ROLLBACK;

-- 変更が反映されていないことを確認
SELECT * FROM restaurant_data WHERE cuisine = 'Cafe';

---評価が最も高い上位 5 地域の行番号付き情報取得

WITH RankedAreas AS (
    SELECT 
        area, 
        AVG(rating) AS avg_rating,
        ROW_NUMBER() OVER (ORDER BY AVG(rating) DESC) AS row_num
    FROM restaurant_data
    GROUP BY area
)
SELECT TOP 5 * FROM RankedAreas;

---Whileループ

CREATE PROCEDURE PrintNumbers
AS
BEGIN
    DECLARE @i INT = 1;

    WHILE @i <= 50
    BEGIN
        PRINT @i;
        SET @i = @i + 1;
    END
END;

EXEC PrintNumbers;

---評価が最も高い５つ

CREATE VIEW TopRating AS
SELECT TOP 5 restaurant_name, rating
FROM restaurant_data
ORDER BY rating DESC;

SELECT * FROM TopRating;

---Triger

CREATE TRIGGER InsertMessageTrigger
ON restaurant_data
AFTER INSERT
AS
BEGIN
    PRINT 'A new restaurant record has been inserted!';
END;

INSERT INTO restaurant_data (restaurant_name, restaurant_type, cuisine, rating, area, table_booking)
VALUES ('New Restaurant', 'Casual Dining', 'Italian', 4.5, 'Downtown', 1);

