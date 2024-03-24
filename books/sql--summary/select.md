---
title: "SELECT文"
---

`SELECT` 文は DB から欲しいデータを取り出す。

```sql
SELECT カラム名 FROM テーブル名;
```

基本的に、SQL 文の最後にはセミコロン（`;`）をつける。
RDBMS によっては不要なものもある。

複数のカラムを指定して取得する方法は下記のようにカンマ（`,`）で繋げる。

```sql
SELECT ID, 売上日, 社員ID FROM test_table;
```

![](https://storage.googleapis.com/zenn-user-upload/efc085c545bb-20240323.png)

`as` をつけることにより、データ抽出後のカラム名を変更できる。

```sql
SELECT ID, 売上日 as sales_date, 社員ID as employ_id FROM test_table;
```

![](https://storage.googleapis.com/zenn-user-upload/28a1c1f0c9d4-20240323.png)

`as` を省略することもできる。

```sql
SELECT ID, 売上日 sales_date, 社員ID employ_id FROM test_table;
```

![](https://storage.googleapis.com/zenn-user-upload/28a1c1f0c9d4-20240323.png)

アスタリスク（`*`）を指定することで、全てのカラムを取得できる。

```sql
SELECT * FROM test_table;
```

![](https://storage.googleapis.com/zenn-user-upload/48588343a2ee-20240323.png)

テーブル名やカラム名の指定に関して、大文字・小文字は区別されない。

```sql
SELECT * FROM TEST_TABLE;
```

![](https://storage.googleapis.com/zenn-user-upload/48588343a2ee-20240323.png)
