---
title: "HAVING"
---

- `GROUP BY` により**グルーピングされたデータの中から**、さらに特定の条件でデータを抽出する
- `GROUP BY` と `ORDER BY` の間に記述する

```sql
SELECT グルーピングをするカラム, 集計関数(集計対象カラム)
FROM テーブル名
WHERE 条件式
GROUP BY グルーピングをするカラム
HAVING 集計関数(集計対象カラム)で条件式
ORDER BY ソート条件;
```

商品名ごとに売上金額の合計を出力する場合は、`GROUP BY` により以下の SQL 文を実行すればよかった。

```sql
SELECT 商品名, sum(売上金額)
FROM test_table
GROUP BY 商品名;
```

![](https://storage.googleapis.com/zenn-user-upload/a0acb2017eea-20240324.png)

上記データから、売上金額が 100 万円以上の商品名のみ抽出したい場合、`HAVING` を使用して条件抽出を行う。

```sql
SELECT 商品名, sum(売上金額)
FROM test_table
GROUP BY 商品名
HAVING sum(売上金額) >= 1000000;
```

`HAVING` に集計関数を含んだカラムを条件式に入れ込むことで、データ抽出ができる。

![](https://storage.googleapis.com/zenn-user-upload/3c64f746a759-20240324.png)

### WHERE と HAVING の違い

- `WHERE` も `HAVING` もやっていることは同じ
- どちらもデータに対して抽出処理を実行する
- 異なるのは呼ばれるタイミングのみ

```sql
SELECT グルーピングをするカラム, 集計関数(集計対象カラム)
FROM テーブル名
WHERE 条件式
GROUP BY グルーピングをするカラム
HAVING 集計関数(集計対象カラム)で条件式
ORDER BY ソート条件;
```

SQL が実行される順番は以下の通り。

![](https://storage.googleapis.com/zenn-user-upload/ba1235f7cd79-20240324.png)

- `WHERE` は `GROUP BY` よりも前に実行される
- `HAVING` は `GROUP BY` よりも後に実行される

これにより、分かることは

- `WHERE` は `GROUP BY` によりグルーピングされる前にデータに対し抽出条件を付与する
- `HAVING` は `GROUP BY` によりグルーピングされた後にデータに対し抽出条件を付与する

よって、`WHERE` に対し、集計関数を含んだカラムを指定するとエラーになる。

```sql
SELECT 商品名, sum(売上金額)
FROM test_table
WHERE sum(売上金額) >= 1000000
GROUP BY 商品名;
```

![](https://storage.googleapis.com/zenn-user-upload/dfc04ab32554-20240324.png)

`WHERE` 句が呼ばれる時点では `GROUP BY` はまだ呼ばれていないため、`WHERE` で集計関数を使用することはできない。

`WHERE` と `HAVING` を同時に使用するとどういったことができるのか？

```sql
SELECT 商品名, sum(売上金額)
FROM test_table
WHERE 商品名 != "ジャケット"
GROUP BY 商品名
HAVING sum(売上金額) <= 1000000;
```

`商品名` が「ジャケット」以外のデータに対し、`商品名` ごとにグルーピングし、`売上金額` の合計が 100 万円以下のデータを取得している。

![](https://storage.googleapis.com/zenn-user-upload/228f2eeb1b46-20240324.png)

`WHERE` と `HAVING` を併用することにより、複雑なデータ集計が可能となる。
