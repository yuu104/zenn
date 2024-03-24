---
title: "論理演算子"
---

## AND

- **用途**: 2 つ以上の条件を同時に満たすレコードを選択する場合に使用。
- **例**: `Employees`テーブルから、部門 ID が 5 で、かつ給与が 30000 より大きい従業員の名前を選択する。
  ```sql
  SELECT Name
  FROM Employees
  WHERE DepartmentID = 5 AND Salary > 30000;
  ```

## OR

- **用途**: いずれかの条件を満たすレコードを選択する場合に使用。
- **例**: `Products`テーブルから、カテゴリ ID が 3 または価格が 500 未満の商品の名前と価格を選択する。
  ```sql
  SELECT Name, Price
  FROM Products
  WHERE CategoryID = 3 OR Price < 500;
  ```

## NOT

- **用途**: 指定した条件を満たさないレコードを選択する場合に使用。
- **例**: `Students`テーブルから、数学が得意でない（`Math = 'NO'`）学生の名前を選択する。
  ```sql
  SELECT Name
  FROM Students
  WHERE NOT Math = 'YES';
  ```

## 複数の論理演算子の組み合わせ

- **用途**: 複雑な条件を指定したい場合に、複数の論理演算子を組み合わせて使用。
- **例**: `Orders`テーブルから、2024 年 1 月 1 日から 2024 年 3 月 31 日までの間に発注され、価格が 1000 以上または特急便で発送された注文の ID と発注日を選択する。
  ```sql
  SELECT OrderID, OrderDate
  FROM Orders
  WHERE (OrderDate BETWEEN '2024-01-01' AND '2024-03-31')
    AND (Price >= 1000 OR ShippingMethod = 'Express');
  ```

## 評価の優先順位

`AND` は `OR` よりも優先して評価される。
従って、下記 SQL は**商品分類がボトムス**または**単価が 6000 円以上かつ売上金額が 100000 円以上**のデータを取得する。

```sql
SELECT * FROM test_table
WHERE 商品分類 = "ボトムス" OR 単価 >= 6000 AND 売上金額 >= 100000;
```
