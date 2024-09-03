---
title: "【アンチパターン】削除フラグ"
---

## そもそも何故削除フラグが必要？

- エンドユーザーから見えなくしたいが、データは消したくない
- 削除したデータを検索したい
- データを消さずにログに残したい
- 操作を誤ってもなかったことにしたい
- 削除してもすぐに元に戻したい

## 問題点

**「状態」を持たせてしまうこと。**
「状態」は、削除フラグに限らず以下がある。

- 課金状態
- ユーザー状態（退会・休会など）

## なぜ状態は悪なのか？

1. クエリの複雑化
2. UNIQUE 制約が使えない
3. カーディナリティが低くなる
4. パフォーマンスの悪化

削除フラグ（`delete_flag`）を例に考える。

`0`: 未削除
`1`: 削除済み

### クエリの複雑化

まず、値を取り出す際に毎度 `delete_flag` でフィルタリングする必要がある。

```sql
SELECT * FROM blog WHERE blog.delete_flag = 0;
```

さらに、ユーザー情報にも削除フラグがある場合、複雑なクエリになる。

```sql
SELECT
    *
FROM
    blog
    INNER JOIN
      users
    ON  users.id = blog.user_id
    AND users.delete_flag = 0
WHERE
    blog.delete_flag = 0
;
```

このように、削除フラグは関連するテーブルすべてに影響を与え、**開発時のコストが増大する**。

### UNIQUE 制約が使えない

削除フラグを使用すると、`delete_flag` が `1` のレコードと `0` のレコードの 2 つが存在することになる。
そうなると、`name` カラムに対して UNIQUE 制約を使用できなくなる。
![](https://storage.googleapis.com/zenn-user-upload/b2260a84992f-20240903.png)

UNIQUE 制約を使用できないデメリットは以下 3 つ。

- データの重複を防げない
- 該当列に対して外部キー制約を利用できない
- 外部キー制約を利用できないことでデータの関連性を担保できない
  - 本来必要のないサロゲートキーを用意しなければならなくなる

### カーディナリティが低くなる

削除フラグは `0` と `1` の 2 種類の値しか入らず、カーディナリティが低い。
しかし、削除フラグは検索時に高頻度で使用する値である（`WHERE delete_flag = 0`）ため、ボトルネックになる。

### パフォーマンスの悪化

削除したデータはレコードとして残り続ける。
テーブルサイズが肥大化し、検索や更新時のパフォーマンスが低下する可能性がある。

## 対策

### 削除済みテーブルを作成する

「**事実のみを保存する**」ことが大切。
![](https://storage.googleapis.com/zenn-user-upload/1f65e82cd197-20240903.png)

削除済みのデータを移す方法は 2 通り。

- アプリケーション側で実装する
- 「**トリガー**」を使用する

「トリガー」は、テーブルに対する操作に反応して別の操作を実行する機能。
これにより、トランザクションを意識することなく削除済みデータを移行できる。
しかし、カラム追加などの仕様変更には弱いため、ケース・バイ・ケースで使用する。

### View を使う（すでに削除フラグがある場合）

![](https://storage.googleapis.com/zenn-user-upload/0a3f2aa80a1e-20240903.png)

```sql
CREATE VIEW active_blog AS
SELECT
    *
FROM
    blog
INNER JOIN users  -- users を JOIN して確認
    ON users.id = blog.user_id
    AND users.delete_flag = 0
INNER JOIN customers  -- customers を JOIN して確認
    ON customers.id = users.customer_id
    AND customers.delete_flag = 0
INNER JOIN category  -- category を JOIN して確認
    ON blog.category_id = category.id
    AND category.delete_flag = 0
WHERE
    blog.delete_flag = 0
```

View の活用により、「クエリの複雑化」というデメリットを解消できる。
仕様変更も、View を変更するだけでよい。

:::message
他のデメリットは解消できないので注意。
:::

## アンチバターンが許容される例

- 対象テーブルが小さく、INDEX が不要
- 対象テーブルがリレーションの親になることがなく、データを取得する際に頻繁に JOIN 対象にならない
- UNIQUE 制約が不要で、外部キーでデータの整合性を担保する必要がない
- フラグの数が非常に少なく、将来的にも増えない

フラグのメリットは、すぐに true か false を判別できる点。
上記条件を満たす場合、テーズルに状態を持たせることは許容される。

しかし、状態を持つことはリファクタリング時に困難を極める。
よって、最初から正しく事実だけを持たせることが無難。
