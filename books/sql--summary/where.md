---
title: "WHERE"
---

`SELECT` 文に `WHERE` 句をつけることで、特定条件を満たしたレコードを取得できる。

```sql
SELECT カラム名 FROM テーブル名 WHERE 条件式;
```

`SELECT カラム名` はカラムを指定するのに対し、`WHERE 条件式` はレコードを指定する。

```sql
SELECT カラム名 -- ←　カラム指定
FROM テーブル名
WHERE 条件式; -- ← レコード指定
```

条件式には `=`, `<`, `>`, `<=`, `>=`, `!=` などが使用できる。

```sql
SELECT * FROM test_table WHERE id = 2;
```

![](https://storage.googleapis.com/zenn-user-upload/8442a07ef9a2-20240323.png)

```sql
SELECT * FROM test_table WHERE id <= 2;
```

![](https://storage.googleapis.com/zenn-user-upload/dcac56e8a1b9-20240323.png)

```sql
SELECT * FROM test_table WHERE id >= 2;
```

![](https://storage.googleapis.com/zenn-user-upload/72ba07fa7edf-20240323.png)

```sql
SELECT * FROM test_table WHERE id > 2;
```

![](https://storage.googleapis.com/zenn-user-upload/eac190b06121-20240323.png)

```sql
SELECT * FROM test_table WHERE id < 2;
```

![](https://storage.googleapis.com/zenn-user-upload/7b59c1a3e979-20240323.png)

```sql
SELECT * FROM test_table WHERE id != 2;
```

![](https://storage.googleapis.com/zenn-user-upload/0b7d402d72a9-20240323.png)

SQL では、文字列はシングルクォーテーション（`'`）又はダブルクォーテーション（`"`）で囲む。

```sql
SELECT * FROM test_table WHERE 商品名 = 'ニット';
```
