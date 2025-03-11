SQL Assignment 1 

ABC_Fashionの販売管理システムに関するデータを用いたSQL操作

課題：
・Orders テーブルに新しいレコードを挿入する。
・Salesman テーブルの SalesmanId 列に主キー制約を追加する。
・City 列にデフォルト制約を追加する。
　Customer テーブルの SalesmanId 列に外部キー制約を追加する。
　Customer テーブルの Customer_name 列に NOT NULL 制約を追加する。
・Customer の名前が「N」で終わるデータを取得し、さらに購入金額が 500 を超えるものを取得する。
・SET 演算子を使用し、以下の条件を満たすデータを取得する。
・1つ目の結果：2つのテーブルから SalesmanId の値が一意なデータを取得する。
　2つ目の結果：2つのテーブルから SalesmanId に重複があるデータを取得する。
・以下のカラムを表示し、購入金額が 500 から 1500 の範囲内にあるデータを取得する。
・Orderdate, Salesman Name, Customer Name, Commission, City
　RIGHT JOIN を使用して、Salesman テーブルと Orders テーブルの全ての結果を取得する。



---データベースの作成

create database ABC_Fashion
use ABC_Fashion

---テーブル作成

Create table Salesman(
SalesmanId int,
SalesmanName varchar(255),
Commission decimal(10,2),
City varchar(255),
Age int
);

insert into Salesman(SalesmanId,SalesmanName,Commission,City,Age)
values(101,'Joe',50,'California',17),
(102,'Simon',75,'Texas',25),(103,'Jessie',105,'Florida',35),
(104,'Danny',100,'Texas',22),(105,'Lia',65,'New Jersy',30);

select * from Salesman

---
drop table Customer

create table Customer(
SalesmanId int,
CustomerId int,
CustomerName varchar(255),
PurchaseAmount int);

insert into Customer(
SalesmanId,CustomerId,CustomerName,PurchaseAmount)
values(101,2345,'Andrew',550),(103,1575,'Lucky',4500),
(104,2345,'Andrew',4000),(107,3747,'Remona',2700),
(110,4004,'Julia',4545);

select * from Customer

---

create table Orders
(OrderId int, CustomerId int,SalesmanId int,OrderData Date,Amount money);

drop table Orders

insert into Orders 
values(5001,2345,101,'2021-07-01',550),
(5003,1234,105,'2022-02-15',1500);
select * from Orders;


---
select * from Salesman
select * from Customer
select * from Orders

---制約の追加

--Primary key--

ALTER TABLE Salesman
ADD CONSTRAINT pk_Salesman PRIMARY KEY (SalesmanId);

ALTER TABLE Salesman
ALTER COLUMN SalesmanId INT NOT NULL;

ALTER TABLE Salesman
ADD CONSTRAINT pk_Salesman PRIMARY KEY (SalesmanId);

--Foreign Key--

ALTER TABLE Customer
ADD CONSTRAINT fk_name FOREIGN KEY (SalesmanId) REFERENCES Salesman(SalesmanId);

SELECT DISTINCT SalesmanId FROM Customer WHERE SalesmanId NOT IN (SELECT SalesmanId FROM Salesman);

INSERT INTO Salesman (SalesmanId, SalesmanName, Commission, City, Age)
VALUES (107, 'Unknown', Null, 'Unknown', Null), 
       (110, 'Unknown', Null, 'Unknown', Null);

select * from Salesman
select * from Customer
select * from Orders

alter table Customer
ADD CONSTRAINT fk_name FOREIGN KEY (SalesmanId) REFERENCES Salesman(SalesmanId);

--Default--

ALTER TABLE Salesman
ADD CONSTRAINT df_City DEFAULT 'Unknown' FOR City;

--Not Null
ALTER TABLE Customer
ALTER COLUMN CustomerName varchar(255) NOT NULL;

---顧客名が'N'で終わり、購入額が500以上のデータ取得

select * from Salesman
select * from Customer
select * from Orders

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Orders';

SELECT c.CustomerID, c.CustomerName, SUM(c.PurchaseAmount) AS Total_Purchase
FROM Customer c
WHERE c.CustomerName LIKE '%N'
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(c.PurchaseAmount) > 500;

select * from Salesman
select * from Customer
select * from Orders

---SalesmanIdのSET演算

---ユニークなSalesmanId
SELECT SalesmanId FROM Salesman
UNION
SELECT SalesmanId FROM Customer;

---重複を含むSalesmanId
SELECT SalesmanId FROM Salesman
UNION ALL
SELECT SalesmanId FROM Customer;

---購入額が500~1500の注文の情報を取得

select * from Salesman
select * from Customer
select * from Orders

SELECT 
    o.OrderData,
    s.SalesmanName,
    c.CustomerName,
    s.Commission,
    s.City
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Salesman s ON o.SalesmanID = s.SalesmanID
WHERE c.PurchaseAmount BETWEEN 500 AND 1500;

---SalesmanIdとOrdersのRight Join

SELECT 
    s.SalesmanID,
    s.SalesmanName,
    s.Commission,
    s.City,
	s.Age,
    o.OrderId,
    o.CustomerId,
	o.SalesmanId,
    o.OrderData,
    o.Amount
FROM Salesman s
RIGHT JOIN Orders o ON s.SalesmanID = o.SalesmanID;

select * from Salesman
select * from Customer
select * from Orders

