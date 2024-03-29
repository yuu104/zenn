---
title: "SQLインジェクション"
---

## 概要

- SQL の呼び出し方に不備がある場合に発生する脆弱性
- アプリケーションに SQL インジェクション脆弱性がある場合、以下の影響を受ける可能性がある
  - DB 内のすべての情報が外部から盗まれる
  - DB の内容が書き換えられる
  - 認証を回避される（ID とパスワードを用いずにログインされる）
  - その他、DB サーバ上のファイル読み出し、書き込み、プログラムの実行などを行われる
- すべて、攻撃者が能動的に（利用者の関与なしで）サーバを攻撃できる
- SQL インジェクションの確実な対策は、静的プレースホルダを利用して SQL を呼び出すこと

![](https://storage.googleapis.com/zenn-user-upload/3383868f0029-20240111.png)

## 攻撃手法と影響

- 以下は `books` テーブルから `author` カラムが指定された著者名（`$author`）と一致する全ての書籍を選択する SQL
- 攻撃者は、`$author` の値を操ることで、SQL インジェクション攻撃を試みることができる

```sql
SELECT * FROM books WHERE author = '$author' ORDER BY id;
```

### エラーメッセージ経由の情報漏洩

`$author` に以下の値が注入されたとする。

```
' AND EXTRACTVALUE(0, (SELECT CONCAT(id, ':', password) FROM users LIMIT 0, 1));
```

この値を元のクエリに挿入すると、以下のようになる。

```sql
SELECT * FROM books WHERE author = '' AND EXTRACTVALUE(0, (SELECT CONCAT(id, ':', password) FROM users LIMIT 0, 1));' ORDER BY id;
```

クエリの内容は以下の通り。

1. **最初の `'` で文字列リテラルを閉じる**
   - これにより、元の `author` 条件が終了する
2. **`AND EXTRACTVALUE(...)`**
   - `EXTRACTVALUE` 関数が注入され、悪意のある操作が開始される
3. **`(SELECT CONCAT(id, ':', password) FROM users LIMIT 0, 1)`**
   - `users` テーブルから最初のユーザの `id` と `password` を連結して取得する
   - この結果は `EXTRACTVALUE` 関数に渡される
4. **`EXTRACTVALUE(0, ...)`**
   - `EXTRACTVALUE` 関数は、今回の場合、意図的なエラーを発生させるために使用される
   - 関数が無効な XML データ（ここでは `id` と `password` の連結結果）を処理しようとすると、エラーメッセージが発生する

- `EXTRACTVALUE` 関数は無効な XML データを処理しようとするとエラーを発生させ、このエラーメッセージには `id` と `password` の連結結果が含まれる可能性がある
- この方法で、攻撃者は `users` テーブルの機密情報（ユーザー ID とパスワード）を外部に漏洩させることができる

### `UNION SELECT` を用いた情報漏洩

:::details UNION SELECT とは？

1. **目的**: `UNION SELECT` は異なる SQL クエリの結果を一つの結果セットに結合する

2. **条件**:

   - 結合する各クエリは同じ数の列を持つ必要がある
   - 対応する列のデータ型は互換性が必要

3. **動作**:

   - `UNION` は異なる SELECT 文の結果を合わせ、重複する行を取り除く
   - `UNION ALL` は重複を含めてすべての結果を合わせる

4. **使用例**:

   - テーブル A とテーブル B があり、両方のテーブルから都市名を選択する場合：
     ```sql
     SELECT city FROM tableA
     UNION
     SELECT city FROM tableB
     ```
   - この例では、tableA と tableB の両方から「city」列を選択し、重複する都市名を排除して一つのリストとして表示する

5. **パフォーマンス**:

   - `UNION` は重複除去の処理があるため、`UNION ALL` よりも処理が遅くなることがある

6. **用途**:
   - データレポート、異なるテーブルからのデータ集約、異なるソースからの情報統合に利用される

:::

`$author` に以下の値が注入されたとする。

```
' UNION SELECT id, password, name, address, NULL, NULL, NULL FROM users--
```

この値を元のクエリに挿入すると、以下のようになる。

```sql
SELECT * FROM books WHERE author = '' UNION SELECT id, password, name, address, NULL, NULL, NULL FROM users--' ORDER BY id;
```

クエリの内容は以下の通り。

1. **最初の `'` で文字列リテラルを閉じる**
   - これにより、元の `author` 条件が終了する
2. **`UNION SELECT`**
   - 別の `SELECT` 文を追加して、元のクエリの結果セットに追加の行を結合する
3. **`id, password, name, address, NULL, NULL, NULL FROM users`**
   - `users` テーブルから `id`, `password`, `name`, `address` 列を選択し、`books` テーブルの列数に合わせるために残りの列に `NULL` を使用する
4. **`--` で残りのクエリをコメントアウト**
   - これにより、元のクエリの `ORDER BY id` 部分は無視される

- この攻撃により、攻撃者は `users` テーブルの `id`, `password`, `name`, `address` などの機密情報にアクセスできる可能性がある
- 攻撃者はデータベースの構造に関する情報（例えば、テーブル名や列名）も得ることができる
- `UNION SELECT` を用いた攻撃が成立すると、一度の攻撃で大量の情報を漏洩させられる

### SQL インジェクションによる認証回避

Web アプリケーションでは、ユーザがログインする際に以下のような SQL クエリを使用することが一般的。

```sql
SELECT * FROM users WHERE username = '$username' AND password = '$password';
```

攻撃者は、ユーザー名またはパスワードのフィールドに特別に構成された入力を提供することで、この認証プロセスを悪用する。
例えば、ユーザー名に以下のような値を入力することができる。

```
' OR '1'='1
```

これを元のクエリに挿入すると、クエリは以下のようになる。

```sql
SELECT * FROM users WHERE username = '' OR '1'='1' AND password = '$password';
```

クエリの内容は以下の通り。

1. **最初の `'` で文字列リテラルを閉じる**
   - 攻撃者は最初のシングルクォートを使用して、クエリ内の文字列リテラルを閉じる
2. **`OR '1'='1'`**
   - この部分は常に真と評価される（1 は常に 1 と等しいため）
   - その結果、`username` の条件は無視され、常に真となる
3. **結果として、パスワードのチェックがバイパスされる**
   - このクエリは、有効なユーザー名を必要とせず、どんなパスワードでも真と評価されるため、認証が回避される

この種の攻撃により、攻撃者は権限を持たないユーザーアカウントにアクセスしたり、管理者アカウントに不正アクセスしたりする可能性がある。

### SQL インジェクション攻撃によるデータ改ざん

`$author` に以下の値が注入されたとする。

```
' ; UPDATE books SET author = '攻撃者' WHERE author = '特定の著者' ; --
```

この値を元のクエリに挿入すると、以下のようになる。

```sql
SELECT * FROM books WHERE author = '' ; UPDATE books SET author = '攻撃者' WHERE author = '特定の著者' ; --' ORDER BY id;
```

1. **最初の `'` で文字列リテラルを閉じる**
   - 攻撃者は最初のシングルクォートを使用して、クエリ内の文字列リテラルを閉じる
2. **`;` で SQL ステートメントを終了させる**
   - セミコロンは SQL ステートメントの終わりを示す
3. **`UPDATE books SET author = '攻撃者' WHERE author = '特定の著者'`**
   - 新しいステートメントで `books` テーブルの `author` 列のデータを改ざんする
4. **`--` で残りのクエリをコメントアウト**
   - これにより、元のクエリの ORDER BY id 部分は無視される

この攻撃により、攻撃者はデータベース内のデータを無許可で改ざんすることができる。
これは情報の信頼性を損ない、さらにはデータベースの整合性を破壊する可能性がある。

### その他の攻撃

データベースエンジンによっては、SQL インジェクション攻撃によって、以下が可能になる場合がある。

- OS コマンドの実行
- ファイルの読み出し
- ファイルの書き出し
- HTTP リクエストにより他のサーバを攻撃

## 脆弱性が生まれる原因

- SQL インジェクションとは開発者の意図しない形に SQL 文が改変されること
- その典型的な原因は「**リテラル**」の扱いにある
-

### リテラルとは？

- 「リテラル」とは、プログラムコード内に直接記述される値のこと
- これは変数ではなく、その場でその値を持つデータ
- SQL 文において、リテラルは主に文字列や数値などのデータを表現するために使用される
- リテラルは様々なタイプのデータを表すために使用され、主に以下のカテゴリーに分けられる

1. **文字列リテラル**
   - テキストデータを表し、通常はシングルクォート（`'`）またはダブルクォート（`"`）で囲まれる
   - 例：'Hello', "World"
2. **数値リテラル**
   - 整数や浮動小数点数などの数値を直接表す
   - 例：100, 3.14
3. **論理値リテラル**
   - 真（true）または偽（false）の論理値を表す
4. **その他のリテラル**
   - 日付や時間など、特定のフォーマットで表現されるデータ型もある

- 脆弱性の原因は SQL 文における「リテラル」の不適切な扱い
- **文字列リテラルや数値リテラルを含むクエリにおいて、リテラルの終端を意図的に操作されることで、クエリが予期せぬ方法で実行される可能性がある**

### 文字リテラルと SQL インジェクション

例えば、以下のような SQL 文があるとする。

```sql
SELECT * FROM users WHERE username = '$username';
```

もしユーザーが `username` フィールドに `' OR '1'='1` と入力した場合、SQL 文は次のようになる。

```sql
SELECT * FROM users WHERE username = '' OR '1'='1';
```

ここで、攻撃者は `'` を使って文字列リテラルを終了させ、`OR '1'='1'` という新しい条件を追加している。
この条件は常に真となるため、SQL 文はすべてのユーザーデータを返す可能性がある。

### 数値リテラルと SQL インジェクション

例えば、以下のような SQL 文があるとする。

```sql
SELECT * FROM products WHERE id = $id;
```

ここで `$id` はユーザーからの入力（製品の ID）を表す**数値**を想定している。

しかし、攻撃者が数値リテラルの脆弱性を悪用する場合、彼らは次のような値を入力するかもしれない。

```
1 OR 1=1
```

Web アプリケーション開発に広く用いられるスクリプト系の言語（PHP、Perl、Ruby など）は変数に型の制約がないため、数値を想定した変数に数値以外の文字が入る場合がある。

この入力を元のクエリに挿入すると、クエリは以下のようになる。

```sql
SELECT * FROM products WHERE id = 1 OR 1=1;
```

この部分は条件 `1=1` を加えており、これは常に真となる。
よって、`id` が `1` である製品だけでなく、すべての製品が選択される可能性がある。

## 脆弱性対策

脆弱性を解消するには、**SQL 文を組み立てる際に SQL 文の変更を防ぐ**。
方法は以下がある。

1. **プレースホルダにより SQL 文を組み立てる**
2. **アプリケーション側で SQL 文を組み立てる際に、リテラルを正しく構成するなど、SQL 文が変更されないようにする**

手法 2 は完全な対応が難しいため、手法 1 がおすすめ。

### プレースホルダによる SQL の組み立て

プレースホルダを利用した SQL は以下のようになる。

```sql
SELECT * FROM books WHERE author = ? ORDER BY id;
```

- SQL 文中の「`?`」がプレースホルダ
- SQL 文中で**変数の値**を表すために使用される特別なマーカー
- プレースホルダは、「場所とり」という意味の英語
- プレースホルダは後から具体的な値に置き換えられる（**バインド**される）
- プレースホルダには、**動的プレースホルダ**と**静的プレースホルダ**が存在する

### 静的プレースホルダ

- **動作**
  - SQL クエリの構造がデータベースに送信され、データベース側でバインドされる
  - このプロセスはデータベース側で処理される
- **バインドのタイミング**
  - クエリがデータベースに送信され、SQL がコンパイルされた後、データベース側で値がバインドされる
- **安全性**
  - 高い
  - プレースホルダの状態で SQL 文がコンパイルされるため、後から SQL 文が変更される可能性は原理的にありえない

![](https://storage.googleapis.com/zenn-user-upload/f303b4c32ad7-20240126.png)

### 動的プレースホルダ

- **動作**
  - SQL クエリとプレースホルダの値がアプリケーション側で組み立てられる
  - アプリケーション側のライブラリやフレームワークによってパラメータをバインドしてからデータベースに送信する
  - バインドにあたりリテラルは適切に構成されるため、処理系にバグがなければ SQL インジェクションは発生しない
- **バインドのタイミング**
  - クエリがデータベースに送信される前に、アプリケーション側で値がバインドされる
- **安全性**
  - 静的プレースホルダには劣る

![](https://storage.googleapis.com/zenn-user-upload/3d43ab47dc70-20240126.png)

### SQL コンパイルとは？

https://zenn.dev/yuu104/books/database-design/viewer/statistics#%E3%82%AA%E3%83%97%E3%83%86%E3%82%A3%E3%83%9E%E3%82%A4%E3%82%B6%E3%81%A8%E5%AE%9F%E8%A1%8C%E8%A8%88%E7%94%BB

### プレースホルダの注意点

- プレースホルダはリテラル値（数値、文字列、日付など）のためのもの
- テーブル名や列名などの SQL 文の構造部分にプレースホルダを使用することはできない

#### 正しい使用例

以下の SQL クエリでは、ユーザー ID とパスワード（リテラル値）をプレースホルダを使用してバインドしている。

```sql
SELECT * FROM users WHERE user_id = ? AND password = ?;
```

このクエリでは、`?` がプレースホルダ
Python を使用している場合、以下のように実際の値をバインドすることができる。

```python
user_id = "user123"
password = "pass123"
cursor.execute("SELECT * FROM users WHERE user_id = ? AND password = ?", (user_id, password))
```

#### 誤った使用例

一方、以下の例では、テーブル名を動的にバインドしようとしている。
これは不適切な使用方法。

```sql
SELECT * FROM ? WHERE user_id = ?;
```

- プレースホルダはテーブル名や列名には使用できない
- このような動的なテーブル名や列名を扱う場合は、アプリケーション側で安全に構築するか、データベースの権限とセキュリティに特に注意する必要がある

## SQL インジェクションの保険的対策

- 保険的対策とは、根本的に抜けがあったり、ミドルウェアに脆弱性があったりする場合に、攻撃の被害を軽減する対策

### 詳細なエラーメッセージの抑止

- SQL インジェクション攻撃により DB の内容を盗む手法として、エラーメッセージの利用がある
- SQL のエラーが表示されると、SQL インジェクションの存在が外部から分かりやすくなる
- 詳細なエラーメッセージを抑止することで、万一 SQL インジェクション脆弱性の対策漏れがあっても、被害に遭いにくくなる

### 入力値の妥当性検証

- アプリケーション要件に従った入力値検証を行うと、結果として脆弱性対策になる場合がある
  - 郵便番号：数値のみ
  - ユーザ ID：英数字
- 入力値検証による制限があれば、万一プレースホルダの利用を怠っていても SQL インジェクション攻撃は成立しない
- しかし、入力値検証だけでは脆弱性は解消しない
  - 住所欄やコメント欄など、文字種の制限がないパラメータもある
- よって、プレースホルダの利用を徹底することが大事

### データベースの権限設定

- アプリの機能を実現するために必要最低限な権限のみ与えれば、被害を最小限にとどめられる
- 商品情報を表示するだけのアプリケーションでは、商品テーブルに対する書き込みは必要ない
- データベースユーザに商品テーブルの読み出し権限だけを与え、書き込み権限を与えなければ、データの改ざんはできなくなる
