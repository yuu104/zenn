---
title: "SUBSTRING"
---

対象の文字列から「開始位置」と「文字数」を指定して一部を切り出すことができる関数。

## 基本構文

```sql
SELECT SUBSTRING(column_name, 開始位置, 文字数) FROM table_name;
```

- `開始位置` は整数を指定する
- 負の値でも良いが、DBMS によっては非対応の場合もある
- `開始位置` n が正の場合、最初の文字から n 番目が対象となる
  ![](https://storage.googleapis.com/zenn-user-upload/86e609873ee2-20240325.png)
- `開始位置` n が負の場合、最後の文字から n 番目が対象となる
  ![](https://storage.googleapis.com/zenn-user-upload/20ff7403b4a3-20240325.png)

## 使用例

下記の `Customers` テーブルを例に考える。

| CustomerID | Name    | Country | City          | Age |
| ---------- | ------- | ------- | ------------- | --- |
| 1          | Alice   | USA     | New York      | 12  |
| 2          | Bob     | Canada  | Toronto       | 23  |
| 3          | Charlie | USA     | San Francisco | 50  |
| 4          | David   | USA     | New York      | 32  |
| 5          | Eve     | Canada  | Vancouver     | 8   |
| 6          | Frank   | Canada  | Toronto       | 63  |

`Name` カラムから、各名前の最初の 2 文字を抽出する場合

```sql
SELECT Name, SUBSTRING(Name, 1, 2) AS FirstTwoChars FROM Customers;
```

| Name    | FirstTwoChars |
| ------- | ------------- |
| Alice   | Al            |
| Bob     | Bo            |
| Charlie | Ch            |
| David   | Da            |
| Eve     | Ev            |
| Frank   | Fr            |
