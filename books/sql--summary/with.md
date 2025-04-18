---
title: "WITH句"
---

## WITH 句とは？

`WITH` 句は、サブクエリを定義して、それを「一時的なテーブル」としてメインクエリで使えるようにする機能です。
この一時的なテーブルを「CTE（Common Table Expression）」とも呼びます。

簡単に言えば、何度も使う複雑なクエリを「名前を付けて整理」するものです。
これにより、複雑な SQL のクエリを見やすく保守しやすくする効果があります。

## サブクエリとの比較と違い

サブクエリとは、メインクエリの中にネストして書かれるクエリのことです。サブクエリは SQL の中で頻繁に使われますが、次のような問題点があります。

- クエリが複雑になると、どの部分が何をしているのか分かりにくい。
- 同じサブクエリを複数回使う場合、それを繰り返し書かなければならず、メンテナンス性が悪い。

`WITH` 句を使うと、これらの問題を解決し、複雑なクエリをスッキリと整理できます。
`WITH` 句で名前を付けることで、コードが再利用しやすく、可読性が高まります。

### 基本的な構文

以下が `WITH` 句の基本的な構文です。

```sql
WITH cte_name AS (
    -- サブクエリ部分
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT *
FROM cte_name;
```

- `cte_name`：サブクエリに名前を付けます。この名前で一時的なテーブルのように扱います
- メインクエリで `cte_name` を使うことで、定義したサブクエリの結果を簡単に参照できます

### 例: 商品の売上の合計を求める

例えば、ある商品の売上合計を計算し、合計金額が `100` 以上のレコードで絞り込みたいとします。

**テーブル: `sales`**

| product | price |
| ------- | ----- |
| A       | 100   |
| B       | 200   |
| A       | 150   |

\
**クエリ結果**

| product | total_sales |
| ------- | ----------- |
| A       | 250         |
| B       | 200         |

### サブクエリの場合

```sql
SELECT product, total_sales
FROM (
    SELECT product, SUM(price) AS total_sales
    FROM sales
    GROUP BY product
) subquery
WHERE total_sales >= 100;
```

- この例では、売上合計を計算するサブクエリをメインクエリ内に直接書いています
- サブクエリがネストされていて、どの部分が何をしているのか理解しにくいことがあります

### WITH 句を使う場合

```sql
WITH total_sales_cte AS (
    SELECT product, SUM(price) AS total_sales
    FROM sales
    GROUP BY product
)
SELECT product, total_sales
FROM total_sales_cte
WHERE total_sales >= 100;
```

- `WITH` 句を使うと、最初に `total_sales_cte` という名前で売上合計を計算し、その結果をメインクエリで使うことができます
- クエリが分かりやすく整理され、読みやすさが向上します

### UNION ALL の登場

`WITH` 句の中で複数のクエリを結合したい場合、`UNION ALL` がよく使われます。

`UNION ALL`は、複数のクエリ結果を結合する際に使うキーワードです。
**重複する行もそのまま保持**するため、すべてのデータをそのまま結合できます。

例えば、以下のように使用します。

```sql
WITH combined_sales AS (
    SELECT product, price FROM sales_2021
    UNION ALL
    SELECT product, price FROM sales_2022
)
SELECT * FROM combined_sales;
```

- ここでは、2021 年と 2022 年の売上データを結合して、一つのテーブルのように扱っています
- `UNION ALL`を使うことで、2021 年と 2022 年に同じデータがあっても、重複をそのまま保持して結合します
- `UNION`（`ALL`なし）だと重複する行が削除されるので、使い分けが重要です

## サブクエリと`WITH`句の比較

| 特徴           | サブクエリ                       | `WITH`句（CTE）                      |
| -------------- | -------------------------------- | ------------------------------------ |
| 可読性         | 複雑になると理解しにくい         | 名前を付けて整理でき、可読性が高い   |
| 再利用性       | 一度だけの利用に向いている       | 複数回利用可能                       |
| クエリの構造   | ネストが深くなると読みにくくなる | クエリがフラットになり、読みやすい   |
| パフォーマンス | 簡単なクエリでは最適化されやすい | 複雑な場合は最適化が難しいこともある |

## サブクエリと WITH 句を使い分け

### サブクエリを使うべきケース

- クエリがシンプルで、1 回限りの処理で済む
- ネストが浅く、可読性が問題にならない
- パフォーマンスが重要で、最適化される可能性が高い

### WITH 句を使うべきケース

- 同じクエリ結果を複数回使いたい
- 複雑なクエリを分割して整理したい
- 階層的なクエリや再帰処理が必要（`WITH RECURSIVE` を使う）
