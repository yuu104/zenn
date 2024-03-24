---
title: "BETWEEN演算子"
---

- `BETWEEN` 演算子は、指定した範囲内に値が存在するかどうかを判定するために使用される
- この演算子は主に数値、日付、または文字列データ型のカラムに対して使用され、指定した 2 つの値の間（両端の値を含む）にあるレコードを選択するのに役立つ

## 基本構文

```sql
SELECT *
FROM テーブル名
WHERE カラム名 BETWEEN 下限値 AND 上限値;
```

`カラム名` が下限値から上限値間のデータを取得している。

上記を `AND` 演算子のみを使用して記述すると以下のようになる。

```sql
SELECT *
FROM テーブル名
WHERE カラム名 >= 下限値 AND カラム名 <= 上限値;
```

`BETWEEN` を使用することで、`カラム名` を 2 回記述する必要がなくなり、SQL 文の可読性が上がる。

指定した範囲外のデータを取得する場合は、`NOT` をつける。

```sql
SELECT *
FROM テーブル名
WHERE カラム名 NOT BETWEEN 下限値 AND 上限値;
```

## 使用例

#### 数値での使用例

```sql
SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20;
```

`Price` カラムが 10〜20 の範囲内にある全ての `Products` テーブルのレコードを選択している。

#### 日付での使用例

```sql
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';
```

`OrderDate` カラムが 2023 年 1 月 1 日〜2023 年 12 月 31 日までの間にあるすべての `Orders` テーブルのレコードを選択している。

#### 文字列での使用例

```sql
SELECT * FROM Customers
WHERE FirstName BETWEEN 'A' AND 'M';
```

- `FirstName` カラムがアルファベットの'A'から'M'（'M'を含む）までの範囲にあるすべての `Customers` テーブルのレコードを選択している
- 文字列の範囲指定では、辞書順に範囲が適用される

## BETWEEN 演算子の注意点

- `BETWEEN` 演算子は両端の値を含む
- 数値範囲だけでなく、日付や文字列範囲の指定にも使用できるが、使用するデータ型によっては意図しない結果を返すことがあるため注意が必要
