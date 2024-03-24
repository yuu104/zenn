---
title: "ORDER BY"
---

`ORDER BY` は取得対象レコードの並び替えを行うために使用する。

```sql
SELECT カラム名 FROM テーブル名 ORDER BY 並び替え条件;
```

取得対象のデータを昇順または降順に並び替える。

`ASC` は昇順を指し、売上金額に着目して昇順に並び替える。

```sql
SELECT * FROM test_table ORDER BY 売上金額 ASC;
```

![](https://storage.googleapis.com/zenn-user-upload/63e09e7bd665-20240323.png)

`DESC` は降順を指し、売上金額に着目して降順に並び替える。

```sql
SELECT * FROM test_table ORDER BY 売上金額 DESC;
```

![](https://storage.googleapis.com/zenn-user-upload/43cb3f161d0c-20240323.png)

何も指定しない場合はデフォルトで昇順（`ASC`）になる。

```sql
SELECT * FROM test_table ORDER BY 売上金額;
```

![](https://storage.googleapis.com/zenn-user-upload/3a42c54b7f63-20240323.png)

文字列型のカラムに対して `ORDER BY` を指定した場合

```sql
SELECT * FROM test_table ORDER BY 商品名;
```

![](https://storage.googleapis.com/zenn-user-upload/7315a99655d6-20240323.png)

1 文字目が同じなら、2 文字目以降で判断する。

複数のカラムを指定して並び替えすることもできる。

```sql
SELECT * FROM test_table ORDER BY 売上金額, 売上日
```

最初に指定した `売上金額` が優先で並び替えされ、その後 `売上金額` が同じレコードを `売上日` で並び替える。

![](https://storage.googleapis.com/zenn-user-upload/9bf0666f627b-20240323.png)

カラムごとに昇順・降順の指定が可能。

```sql
SELECT * FROM test_table ORDER BY 売上金額 DESC, 売上日 ASC;
```

![](https://storage.googleapis.com/zenn-user-upload/6e24d3f49713-20240323.png)
