---
title: "ロック"
---

## ロックとは？

- 複数のトランザクションが同じデータに対し、同時にアクセスすることを防ぐ仕組み
- データの整合性を保つために使用する
- ロックの単位は様々（**DBMS によってロック可能な単位が異なるので注意**）
  - DB
  - テーブル
  - レコード
  - カラム
- ロックをすることで、トランザクションがデータを更新する際に、他のトランザクションが同じデータの更新や参照をできなくする

:::details 銀行口座の入出金を例に考える

- A さんが口座から 1000 円引き出す
- B さんが口座から 1000 円入金する

A さんの引き出しが完了する前に B さんが口座にアクセスできるとどうなるか？
![](https://storage.googleapis.com/zenn-user-upload/69e4022d09fc-20240517.png)
データの不整合が起こる。
そこで、A さんの引き出しが完了するまで口座データをロックする必要がある。
![](https://storage.googleapis.com/zenn-user-upload/e85ab7497c72-20240517.png)

:::

ロックは 2 種類存在する。

- 共有ロック (Shared Lock, S ロック)
- 排他ロック (Exclusive Lock, X ロック)

## 「ロックを取得する」という用語について

- 「ロックする」と同じ意味
- これは特定のトランザクションがデータに対して排他的または共有的なアクセス権を持つようにする操作

流れは以下の通り。

1. **ロックを要求**:
   トランザクションが特定のデータにアクセスするためにロックを要求する。
2. **ロックの確認**:
   DBMS が他のトランザクションによるロックの状況を確認する。
3. **ロックの取得**:
   要求されたロックが可能であれば、DBMS がロックを設定し、その情報を管理する。

## 共有ロック

- データを読み取るとき（`SELECT`）に使用する
- 複数のトランザクションが同じデータに対し、同時にデータを読み取ることを許可するが、書き込みはできないようにする
- 「今このデータを読み取っているので、他のトランザクションは変更しないでね。僕と一緒に読み取るのはいいよ。」ということ
- 複数のトランザクションが同じロック対象を取得することが可能
- `SELECT` 以外の操作（`INSERT`, `UPDATE`, `DELETE` など）は使用できない

### 具体例

1. トランザクション A が商品リストを読み取る。共有ロックを取得。
2. 同時にトランザクション B も商品リストを読み取る。共有ロックを取得。
3. トランザクション C が商品リストを更新しようとするが、A と B が共有ロックを解除するまで待機。

## 排他ロック

- データを更新する時（`INSERT`, `UPDATE`, `DELETE` など）に使用する
- 複数のトランザクションが同時に同じデータを読み取り・書き込みできないようにする
- 「今このデータを操作してるので、他のトランザクションは触らないでね。読み取りもダメだよ。」ということ
- 排他ロックの重複は不可
- データを読み取るとき（`SELECT`）でも使用できる

### 具体例

1. トランザクション A が在庫データを更新する。排他ロックを取得。
2. 同時にトランザクション B が在庫データを読み取ろうとするが、A が排他ロックを解除するまで待機。

## それぞれのロックでできること・できないこと

|            | 他の TX から読み込み（`SELECT`） | 他の TX から変更 | 他の TX からロックを取得 |
| ---------- | -------------------------------- | ---------------- | ------------------------ |
| 共有ロック | ⭕️                              | ❌               | ⭕️                      |
| 排他ロック | ❌ 　                            | ❌               | ❌                       |

**共有ロックの取得は重複を許す。**

## データ更新時（`INSERT`, `UPDATE`, `DELETE` など）の排他ロックは自動でやってくれる

`INSERT`文の自動ロック

```sql
BEGIN TRANSACTION;

INSERT INTO employees (id, name, salary) VALUES (1, 'John Doe', 50000);
-- データベースシステムが自動的に排他ロックを適用

COMMIT;
-- トランザクションがコミットされると、排他ロックが解除される
```

`UPDATE` 文の自動ロック

```sql
BEGIN TRANSACTION;

UPDATE employees SET salary = salary + 5000 WHERE id = 1;
-- 自動的に排他ロックを適用

COMMIT;
-- トランザクションがコミットされると、排他ロックが解除される

```

`DELETE` 文の自動ロック

```sql
BEGIN TRANSACTION;

DELETE FROM employees WHERE id = 1;
-- データベースシステムが自動的に排他ロックを適用

COMMIT;
-- トランザクションがコミットされると、排他ロックが解除される
```

## データ読み取り時（`SELECT`）のロックは明示的に宣言する必要がある

データ読み取りでは、デフォルトでロックすることはない。

## 共有ロックの取得

### レコード単位

- `SELECT` でロックを取得する場合は以下のように明示的に指示する必要がある
-

:::details MySQL

`LOCK IN SHARE MODE` を末尾につける。

```sql
BEGIN TRANSACTION;
SELECT * FROM products WHERE product_id = 1 LOCK IN SHARE MODE;
COMMIT;
```

:::

:::details PostgreSQL

`FOR SHARE` を末尾につける。

```sql
BEGIN TRANSACTION;
SELECT * FROM products WHERE product_id = 1 FOR SHARE;
COMMIT;
```

:::

**ロックの解放はトランザクション終了時に自動で行われる。**

### テーブル単位

:::details MySQL

- ロックの取得

```sql
-- トランザクションの開始
START TRANSACTION;

-- テーブルの共有ロックを取得
LOCK TABLES my_table WRITE;

-- テーブルへのデータ操作
UPDATE my_table SET column1 = 'value' WHERE id = 1;

-- テーブルのロックを解放
UNLOCK TABLES;

-- トランザクションのコミット
COMMIT;

```

:::

:::details PostgreSQL

```sql
-- トランザクションの開始
BEGIN;

-- テーブルの排他ロックを取得
LOCK TABLE my_table IN SHARE MODE;

-- テーブルへのデータ操作
UPDATE my_table SET column1 = 'value' WHERE id = 1;

-- トランザクションのコミット
COMMIT;  -- ロックが自動的に解放される
```

:::

## 排他ロックの取得

### レコード単位

- レコード単位では、`SELECT` 以外の操作（`INSERT`, `UPDATE`, `DELETE` など）は自動でロックしてくれる
- `SELECT` でロックを取得する場合は以下のように明示的に指示する必要がある

:::details MySQL

`FOR UPDATE` を末尾につける。

```sql
BEGIN TRANSACTION;
SELECT * FROM products WHERE product_id = 1 FOR UPDATE;
COMMIT;
```

:::

:::details PostgreSQL

`FOR UPDATE` を末尾につける。

```sql
BEGIN TRANSACTION;
SELECT * FROM products WHERE product_id = 1 FOR UPDATE;
COMMIT;
```

:::

**ロックの解放はトランザクション終了時に自動で行われる。**

### テーブル単位

:::details MySQL

```sql
-- トランザクションの開始
START TRANSACTION;

-- テーブルの排他ロックを取得
LOCK TABLES my_table WRITE;

-- テーブルへのデータ操作
UPDATE my_table SET column1 = 'value' WHERE id = 1;

-- テーブルのロックを解放
UNLOCK TABLES;

-- トランザクションのコミット
COMMIT;
```

:::

:::details Postgre SQL

```sql
-- トランザクションの開始
BEGIN;

-- テーブルの排他ロックを取得
LOCK TABLE my_table IN EXCLUSIVE MODE;

-- テーブルへのデータ操作
UPDATE my_table SET column1 = 'value' WHERE id = 1;

-- トランザクションのコミット
COMMIT;  -- ロックが自動的に解放される
```

:::

## デッドロック
