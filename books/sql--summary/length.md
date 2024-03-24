---
title: "LENGTH関数"
---

- 文字列の長さを返すために使用される関数
- 引数に指定されたカラムの文字列の長さを整数値で返す

## 基本構文

```sql
SELECT LENGTH(column_name)
FROM table_name;
```

`column_name` には文字列の長さを求めたいカラムを指定する。

また、直接文字列リテラルに対して使用することもできる。

```sql
SELECT LENGTH('text');
```

`WHERE` 句にも使用できる。

```sql
SELECT 商品名, LENGTH(商品名) as 文字数
FROM テーブル名
WHERE LENGTH(商品名) >= 5;
```

## カラムの型について

- 文字列：文字数
- `BLOB` 型：バイト数
- `NULL` : `NULL`
- 上記以外：文字列型に変換した後の文字数
