---
title: "JOIN"
---

`JOIN` はテーブルを結合するためのキーワードで、以下の 4 種類存在する。

- `INNER JOIN`
- `LEFT OUTER JOIN`（`LEFT JOIN`）
- `RIGHT OUTER JOIN`（`RIGHT JOIN`）
- `FULL OUTER JOIN`（`FULL JOIN`）

上記 4 つの中でも、`JOIN` は「内部結合」と「外部結合」に分類される。

## 内部結合と外部結合

内部結合（INNER JOIN）と外部結合（OUTER JOIN）は、複数のテーブルからデータを結合して取得する際に使用する SQL の結合方法だが、取得されるデータセットが異なる。

### 内部結合

- 二つのテーブルに共通するレコードのみを取得する
- つまり、結合条件にマッチする行のみが結果として返される
- どちらか一方のテーブルにしか存在しないレコードは結果に含まれない
- 内部結合は `INNER JOIN` を使用する

### 外部結合

- 二つのテーブルのうち、一方または両方のテーブルに存在するレコードを全て取得する
- マッチしないレコードの場合、もう一方のテーブルのカラムには NULL が入る
- 外部結合には`LEFT OUTER JOIN`、`RIGHT OUTER JOIN`、`FULL OUTER JOIN` の三種類がある

## `JOIN` 句の解説

「Customers（顧客）」テーブルと「Orders（注文）」テーブルを考える。

**`Customers` テーブル**

| CustomerID | CustomerName |
| ---------- | ------------ |
| 1          | Alice        |
| 2          | Bob          |
| 3          | Carol        |

**`Orders` テーブル**

| OrderID | CustomerID | OrderDate  |
| ------- | ---------- | ---------- |
| 100     | 1          | 2024-03-01 |
| 101     | 2          | 2024-03-05 |
| 102     | 4          | 2024-03-10 |

### `INNER JOIN`

- `INNER JOIN` は両テーブルに共通するレコードのみを返す
- この場合、`CustomerID` が両テーブルに存在する `Alice` と `Bob` の情報のみが結果として返される

`INNER JOIN` は `JOIN` と省略して記述することも可能。
主要な DBMS ではどちらの記法にも対応している。

- どちらを使用するかは現場によって様々
- 海外では他の JOIN との混合を避けるため、`INNER JOIN` と詳しく記述することが多い？

**SQL クエリ**:

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
```

**結果**:

| CustomerName | OrderID |
| ------------ | ------- |
| Alice        | 100     |
| Bob          | 101     |

![](https://storage.googleapis.com/zenn-user-upload/8e143a5b6834-20240324.png)

### `LEFT OUTER JOIN`（`LEFT JOIN`）

- `LEFT JOIN` は左のテーブル（Customers）の全レコードと、右のテーブル（`Orders`）のマッチするレコードを返す
- `Carol` は注文が存在しないが、`Customers` テーブルには存在するため、結果に含まれる
  - その場合は `NULL` が入る

**SQL クエリ**:

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
```

**結果**:

| CustomerName | OrderID |
| ------------ | ------- |
| Alice        | 100     |
| Bob          | 101     |
| Carol        | NULL    |

![](https://storage.googleapis.com/zenn-user-upload/0178d32cce4f-20240324.png)

### `RIGHT OUTER JOIN`（`RIGHT JOIN`）

- 右のテーブル（`Orders`）の全レコードと、左のテーブル（`Customers`）のマッチするレコードを返す
- `CustomerID` が `4` の注文は、`Customers` テーブルにマッチしないため、`CustomerName` は `NULL` になる

**SQL クエリ**:

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
```

**結果**:

| CustomerName | OrderID |
| ------------ | ------- |
| Alice        | 100     |
| Bob          | 101     |
| NULL         | 102     |

![](https://storage.googleapis.com/zenn-user-upload/8fa1c3a5cf3c-20240324.png)

### `FULL OUTER JOIN`（`FULL JOIN`）

- 両テーブルの全レコードを返す
- 一方のテーブルにしか存在しないレコードも結果に含まれる

**SQL クエリ**:

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL JOIN Orders ON Customers.CustomerID = Orders.CustomerID;
```

**結果**:

| CustomerName | OrderID |
| ------------ | ------- |
| Alice        | 100     |
| Bob          | 101     |
| Carol        | NULL    |
| NULL         | 102     |

![](https://storage.googleapis.com/zenn-user-upload/125b917e37cb-20240324.png)

## `ON` キーワード

- SQL 文における`ON`キーワードは、主に `JOIN` 句内で使用され、二つのテーブルを結合する際の条件を指定するために使われる
- `ON`句は、どのカラムの値を基にしてテーブル間で結合を行うかを明確にする役割を持っている
- これにより、関連するデータを正確にマッチングさせて結合することがでる

### `ON`句の基本構文

```sql
SELECT columns
FROM table1
JOIN table2
ON table1.column_name = table2.column_name;
```

ここで、`table1.column_name = table2.column_name` は結合条件を示しており、`table1` の `column_name` と `table2` の `column_name` が等しいレコード同士を結合する。

### `ON`句の使用例

例えば、`Customers` テーブル（顧客情報を格納）と `Orders` テーブル（注文情報を格納）があり、それぞれに `CustomerID` という共通のカラムがあるとする。
この二つのテーブルを `CustomerID` を基に結合して、顧客ごとの注文情報を取得したい場合には以下のように`ON`句を使用する。

```sql
SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
JOIN Orders
ON Customers.CustomerID = Orders.CustomerID;
```

このクエリでは、`Customers`テーブルの`CustomerID`と`Orders`テーブルの`CustomerID`が一致するレコード同士を結合し、顧客名とその顧客の注文 ID を取得する。

## どっちが REFT？RIGHT?

`ON` の前が LEFT、後が RIGHT
