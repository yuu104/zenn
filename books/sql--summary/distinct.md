---
title: "DISTINCT"
---

- `DISTINCT` は値の重複を排除してクエリ結果から重複する値を除外して、一意な値のみを取得するために使用される
- キーワードは特に、テーブル内の特定のカラムから重複するデータを排除し、ユニークな値のリストを取得したい場合に便利

## 基本構文

```sql
SELECT DISTINCT column_name
FROM table_name;
```

- `column_name` は重複を排除したいカラムを指定する
- 複数のカラムを指定することもでき、その場合は指定したカラムの組み合わせ全体で一意な行を返す

## 使用例

具体的な`Customers`テーブルを用意し、`DISTINCT`相当の操作を実行した結果を以下に示す。

| CustomerID | Name    | Country | City          |
| ---------- | ------- | ------- | ------------- |
| 1          | Alice   | USA     | New York      |
| 2          | Bob     | Canada  | Toronto       |
| 3          | Charlie | USA     | San Francisco |
| 4          | David   | USA     | New York      |
| 5          | Eve     | Canada  | Vancouver     |
| 6          | Frank   | Canada  | Toronto       |

### `Country`カラムの一意な値を出力

```sql
SELECT DISTINCT Country FROM Customers;
```

**結果**:

```
USA
Canada
```

### `City` と `Country` カラムの組み合わせで一意なリストを出力

```sql
SELECT DISTINCT City, Country FROM Customers;
```

**結果**:

| City          | Country |
| ------------- | ------- |
| New York      | USA     |
| Toronto       | Canada  |
| San Francisco | USA     |
| Vancouver     | Canada  |

### `Country` が何種類あるのか出力する

```sql
SELECT count(DISTINCT Country) FROM Customers;
```

**結果**

```
2
```

## DISTINCT と GROUP BY の違い

- 「カラムを値の重複なしで抽出する」という目的に関してはどちらでも対応可能
- `DISTINCT` は `GROUP BY` を使用したクエリに置き換え可能
- 実行結果はどちらも同じ
- しかし、両者では**重複を排除する過程**が異なる
- `DISTINCT` は**重複した値を削除**する
- `GROUP BY` は**重複した値を一つにまとめる**

下記の `DISTINCT` を使用したクエリは

```sql
SELECT DISTINCT Country FROM Customers;
```
