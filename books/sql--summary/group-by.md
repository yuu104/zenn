---
title: "GROUP BY"
---

- `SELECT` により取得したレコードを任意のルールに従いグルーピングする
- グルーピングしたいカラムをもとに集約関数を使用して、合計や平均、最小値や最大値、カウントなどを計算できる
- これにより、「商品名ごとの売上金額の合計や平均を出力する」ことが可能になる

```sql
SELECT グルーピングするカラム, 集約関(集計対象カラム)
FROM テーブル名
WHERE 条件式
GROUP BY グルーピングをするカラム
ORDER BY ソート条件;
```

- `GROUP BY` は `ORDER BY` と組み合わせることで、「売上金額の合計順に並び替える」などが可能になる
- `GROUP BY` は `WHERE` と `ORDER BY` の間に記述する
- `集計関数` は合計やカウント、最大値、最小値などを求める関数
  - 「集約関数」とも呼ぶ

`商品分類` ごとに `売上金額` を合計したデータを、`商品分類` と一緒に出力する。

```sql
SELECT 商品分類, sum(売上金額)
FROM test_table
GROUP BY 商品分類;
```

![](https://storage.googleapis.com/zenn-user-upload/10f50b8b11ba-20240323.png)

`商品名` ごとに合計する場合

```sql
SELECT 商品名, sum(売上金額)
FROM test_table
GROUP BY 商品名;
```

![](https://storage.googleapis.com/zenn-user-upload/a8ec214b47fa-20240323.png)

上記を合計金額順に並び替える場合

```sql
SELECT 商品名, sum(売上金額)
FROM test_table
GROUP BY 商品名
ORDER BY sum(売上金額);
```

![](https://storage.googleapis.com/zenn-user-upload/e00583e764a9-20240323.png)

集計関数は複数指定できる。

```sql
SELECT 商品名, avg(売上金額), min(売上金額), max(売上金額)
FROM test_table
GROUP BY 商品名;
```

![](https://storage.googleapis.com/zenn-user-upload/f54ab013f960-20240324.png)

`count` 関数を使用すると、グルーピングされたレコードの行数を取得できる。

```sql
SELECT 商品名, count(売上金額)
FROM test_table
GROUP BY 商品名;
```

![](https://storage.googleapis.com/zenn-user-upload/9c0ca6457f88-20240324.png)

単純にテーブル全体のレコード数を取得したい場合は以下のように記述する。

```sql
SELECT count(*) FROM test_table;
```

![](https://storage.googleapis.com/zenn-user-upload/da29ab59f2a6-20240324.png)
