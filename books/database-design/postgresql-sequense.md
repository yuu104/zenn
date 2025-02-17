---
title: "【PostgreSQLシーケンス】"
---

## シーケンスとは

シーケンスは、一意の連番を自動生成するためのデータベースオブジェクトです。主にテーブルの主キーの値を自動的に生成するために使用されますが、それ以外の用途にも利用できます。

## なぜシーケンスを使うのか

シーケンスを使用する主な理由は以下の通りです：

1. **一意性の保証**: 複数のユーザーが同時にアクセスしても、重複のない一意の値が保証されます
2. **自動化**: 主キーの値を手動で管理する必要がなくなります
3. **柔軟性**: テーブルから独立したオブジェクトなので、複数のテーブルで共有できます
4. **制御性**: 値の生成を細かく制御できます

## シーケンスの基本的な使い方

### シーケンスの作成

```sql
CREATE SEQUENCE my_sequence
    INCREMENT BY 1    -- 増分値（1ずつ増加）
    START WITH 1      -- 開始値
    MINVALUE 1        -- 最小値
    MAXVALUE 99999    -- 最大値
    CACHE 1           -- キャッシュサイズ
    CYCLE;            -- 最大値に達したら最小値に戻る（CYCLE）または停止（NO CYCLE）
```

### シーケンスの操作関数

1. **nextval('シーケンス名')**: 次の値を取得
2. **currval('シーケンス名')**: 現在の値を取得（nextval を 1 回以上実行後）
3. **lastval()**: 最後に生成された値を取得
4. **setval('シーケンス名', 値)**: シーケンスの現在値を設定

```sql
-- 次の値を取得
SELECT nextval('my_sequence');

-- 現在の値を確認
SELECT currval('my_sequence');

-- 最後に生成された値を確認
SELECT lastval();

-- 値を特定の数値に設定
SELECT setval('my_sequence', 100);
```

## シーケンスの実践的な使用パターン

### 1. 明示的なシーケンス作成

```sql
-- シーケンスの作成
CREATE SEQUENCE users_id_seq;

-- テーブルでの使用
CREATE TABLE users (
    id integer DEFAULT nextval('users_id_seq') PRIMARY KEY,
    name varchar(50)
);
```

### 2. SERIAL 型の使用（PostgreSQL 9.1 以降）

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,  -- 内部的にシーケンスが作成される
    name varchar(50)
);
```

### 3. IDENTITY 列の使用（PostgreSQL 10 以降・推奨）

```sql
CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name varchar(50)
);
```

## シーケンスの管理

### シーケンス情報の確認

```sql
-- シーケンスの一覧を表示
SELECT * FROM information_schema.sequences;

-- 特定のシーケンスの詳細を確認
SELECT * FROM my_sequence;
```

### シーケンスの変更

```sql
-- 増分値の変更
ALTER SEQUENCE my_sequence INCREMENT BY 2;

-- 最小値・最大値の変更
ALTER SEQUENCE my_sequence MINVALUE 1000 MAXVALUE 9999;

-- サイクルの設定変更
ALTER SEQUENCE my_sequence CYCLE;
```

### シーケンスの削除

```sql
DROP SEQUENCE my_sequence;
```

## シーケンスの特徴と注意点

### 1. トランザクションとの関係

- シーケンスの値の生成はトランザクションの外で行われます
- トランザクションをロールバックしても、取得した値は戻りません
- これにより、値の欠番が発生する可能性があります

```sql
BEGIN;
SELECT nextval('my_sequence');  -- 例: 1を取得
ROLLBACK;
SELECT nextval('my_sequence');  -- 2を取得（1は欠番となる）
```

### 2. キャッシュの影響

- パフォーマンス向上のため、シーケンス値はメモリにキャッシュされます
- サーバークラッシュ時にキャッシュされた値が失われる可能性があります
- これも値の欠番の原因となります

### 3. 並行処理での動作

- シーケンスは並行アクセスに対して安全です
- 複数のセッションが同時に nextval()を呼び出しても、一意の値が保証されます

## ベストプラクティス

1. **IDENTITY 列の使用**

   - PostgreSQL 10 以降では、IDENTITY 列の使用が推奨されます
   - より標準的で、管理が容易です

2. **シーケンスの共有**

   - 複数のテーブルで同じシーケンスを共有する場合は注意が必要です
   - 共有する理由が明確な場合のみ使用してください

3. **初期値の設定**

   - 既存データがある場合、setval()で適切な初期値を設定してください

   ```sql
   SELECT setval('my_sequence', (SELECT MAX(id) FROM my_table));
   ```

4. **キャッシュサイズの設定**
   - 高トラフィックの環境では、適切なキャッシュサイズを設定することでパフォーマンスが向上します
   - ただし、サーバークラッシュ時の欠番リスクとのバランスを考慮してください

## 一般的なユースケース

### 1. 主キーの自動生成

```sql
CREATE TABLE orders (
    order_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date date DEFAULT current_date,
    customer_id int
);
```

### 2. 複数テーブルでの共有シーケンス

```sql
CREATE SEQUENCE document_id_seq;

CREATE TABLE invoices (
    doc_id int DEFAULT nextval('document_id_seq') PRIMARY KEY,
    invoice_date date
);

CREATE TABLE receipts (
    doc_id int DEFAULT nextval('document_id_seq') PRIMARY KEY,
    receipt_date date
);
```

### 3. カスタム番号体系

```sql
-- 2024年度の請求書番号（例: INV2024001, INV2024002, ...）
CREATE SEQUENCE invoice_2024_seq;

CREATE TABLE invoices_2024 (
    invoice_no varchar(20) DEFAULT 'INV2024' || lpad(nextval('invoice_2024_seq')::text, 3, '0') PRIMARY KEY,
    amount decimal(10,2)
);
```

## トラブルシューティング

### 1. 欠番の発生

欠番が発生する主な原因：

- トランザクションのロールバック
- サーバークラッシュによるキャッシュの損失
- 明示的なシーケンス値の設定

対策：

- 欠番を許容する設計にする
- キャッシュサイズを小さくする
- 重要な場合は代替の採番方式を検討する

### 2. シーケンス値の枯渇

対策：

- 十分な最大値を設定する
- CYCLE オプションの使用を検討する
- 定期的に使用状況をモニタリングする

### 3. パフォーマンスの問題

対策：

- キャッシュサイズを適切に設定する
- 不要な currval()や lastval()の呼び出しを避ける
- シーケンスの共有は必要な場合のみにする

## まとめ

PostgreSQL のシーケンスは、一意の値を生成するための強力で柔軟なツールです。基本的な使用方法は簡単ですが、高度な機能や設定オプションも提供されています。

現代の PostgreSQL では、単純な自動採番には IDENTITY 列 の使用が推奨されます。より複雑なニーズがある場合や、特別な要件がある場合にのみ、明示的なシーケンスの作成を検討してください。

シーケンスを使用する際は、トランザクションとの関係、キャッシュの影響、欠番の可能性などの特性を理解し、適切に設計・運用することが重要です。
