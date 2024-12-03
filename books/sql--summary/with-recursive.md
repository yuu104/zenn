---
title: "WITH RECURSIVE句"
---

`WITH RECURSIVE` は、データベースで再帰的なクエリを実行する際に使う機能です。
これは、自己参照するような階層構造（例えば、社員の上司関係やフォルダ階層）を扱うときに非常に便利です。

## 基本構文

```sql
WITH RECURSIVE cte_name AS (
    -- アンカー部分（初期状態を取得）
    SELECT ...
    UNION ALL
    -- 再帰部分（前回の結果を基に次のステップを取得）
    SELECT ...
    FROM cte_name
    WHERE ...
)
SELECT *
FROM cte_name;
```

1. **アンカー部分（初期クエリ）**
   - 再帰の基点となる初期状態のデータを取得します
2. **再帰部分**
   - 前回のクエリにより取得したデータを基に、次のデータを取得します
   - この処理は再帰的に繰り返され、条件を満たすデータがなくなるまで続きます

**`UNION ALL`** で、重複も含めて全てのデータを結合します。

最終的に、アンカー部分と再帰部分で取得されたすべてのデータが合わさり、クエリ結果（`cte_name`）となります。

## 具体例 ➀: 階層構造の処理

例えば、社員とその上司の関係を考えてみましょう。

**テーブル: `employees`**

| id  | name    | manager_id |
| --- | ------- | ---------- |
| 1   | Alice   | NULL       |
| 2   | Bob     | 1          |
| 3   | Charlie | 2          |
| 4   | Dave    | 2          |
| 5   | Eve     | 3          |

- `manager_id` はその社員の上司の `id` を示します
- `Alice` はトップなので、`manager_id` が `NULL` です

### クエリで階層構造をたどる

「Alice から始まって、全ての社員を階層順にたどりたい」とします。
この場合、`WITH RECURSIVE` を使います。

```sql
WITH RECURSIVE employee_hierarchy AS (
    -- アンカー部分: 最初にマネージャーがいない社員を取得（Alice）
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- 再帰部分: 前回の結果を基に部下を取得
    SELECT e.id, e.name, e.manager_id, eh.level + 1
    FROM employees e
    INNER JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT *
FROM employee_hierarchy;
```

### クエリの流れ

1. **アンカー部分**
   - まず、`manager_id` が `NULL` の `Alice` が選ばれます
2. **再帰部分**
   - `Alice` の `id` を `manager_id` に持つ社員を取得（ここでは `Bob`）
   - 次に `Bob` の `id` を `manager_id` に持つ社員（`Charlie` と `Dave`）を取得
   - この処理を繰り返して、全ての階層が取得されるまで続けます

### 結果

| id  | name    | manager_id | level |
| --- | ------- | ---------- | ----- |
| 1   | Alice   | NULL       | 1     |
| 2   | Bob     | 1          | 2     |
| 3   | Charlie | 2          | 3     |
| 4   | Dave    | 2          | 3     |
| 5   | Eve     | 3          | 4     |

`level` は階層の深さを表しています。

### ポイント

- **アンカー部分と再帰部分**がセットで動き、最初に基点（トップ）を決め、そこから繰り返し次の階層を探していきます
- **`UNION ALL`** を使う理由は、すべての階層データを保持しながら積み上げていくためです
  - `UNION`を使うと重複が削除され、正しい階層が表現できなくなる可能性があります

## 例 ➁: フォルダの文書のデータ構造

ファイルシステムのようなフォルダ階層をたどる状況を考えてみましょう。

**フォルダテーブル: `da_folder`**

| id  | folder_name | parent_id |
| --- | ----------- | --------- |
| 1   | root        | NULL      |
| 2   | home        | 1         |
| 3   | user1       | 2         |
| 4   | user2       | 2         |
| 5   | docs        | 3         |
| 6   | pics        | 3         |
| 7   | projects    | 4         |
| 8   | reports     | 5         |

- `parent_id` はフォルダの親フォルダを示します
- 例えば、`home`フォルダ（ID 2）は`root`フォルダ（ID 1）の子であり、`user1`（ID 3）は`home`の子です

\

**ドキュメントテーブル: `da_document`**

| id  | folder_id | name              |
| --- | --------- | ----------------- |
| 1   | 3         | resume.docx       |
| 2   | 3         | picture.png       |
| 3   | 5         | report.pdf        |
| 4   | 7         | project_plan.xlsx |
| 5   | 6         | vacation.jpg      |

`folder_id` は、そのドキュメントが格納されているフォルダの ID です。

### フォルダ階層をたどる再帰クエリ

特定のフォルダ（例えば、`user1` フォルダ）からスタートし、そのすべてのサブフォルダを再帰的に取得するクエリを書いてみます。

```sql
WITH RECURSIVE r (folderId) AS (
    -- アンカー部分: 特定のフォルダIDからスタート（例えば、ID = 3 を選択）
    SELECT
        id AS folderId
    FROM
        da_folder
    WHERE
        id = 3
    UNION ALL
    -- 再帰部分: 前回の結果を基に、フォルダのサブフォルダを取得
    SELECT
        f.id
    FROM
        da_folder f
        JOIN r ON f.parent_id = r.folderId
)
-- フォルダ内の全てのドキュメントを取得
SELECT
    da_document.id,
    da_document.folder_id,
    da_document.name,
FROM
    r
    JOIN da_document ON da_document.folder_id = r.folderId
```

- **アンカー部分**で、特定のフォルダ ID（ここでは ID = 3、つまり`user1`フォルダ）を基点とします
- **再帰部分**では、`user1`フォルダの下にある全てのサブフォルダを繰り返し取得します
- 最終的に、`user1`フォルダとそのサブフォルダに含まれる全てのドキュメントを取得します

### 段階的なクエリ処理の流れ

1. **アンカー部分の実行**
   クエリは `id=3` を基点として開始します。
   `folderId = 3` が初期結果として取得され、次の再帰クエリに渡されます。

   | folderId |
   | -------- |
   | 3        |

2. **再帰部分の 1 回目の実行**
   次に、`user1` フォルダ（`id=3`）に属するサブフォルダを取得します。
   この場合、`docs`（`id=5`）と `pics`（`id=6`）がサブフォルダとして見つかります。

   | folderId |
   | -------- |
   | 5        |
   | 6        |

   そして、これらが次の再帰のステップとして追加されます。

3. **再帰部分の 2 回目の実行**
   再帰的にフォルダを深く掘り下げ、`docs` フォルダ（`id=5`）のサブフォルダである `reports`（`id=8`）を取得します。
   また、`pics`（`id=6`）のサブフォルダも確認されます。

   | folderId |
   | -------- |
   | 8        |

4. **最終結果の集計**
   再帰部分の最終結果（CTE）が下記になります。
   全ての階層を辿り、`user1`（`id=3`）とそのサブフォルダである `docs`（`id=5`）、`pics`（`id=6`）、さらに `docs` 内のサブフォルダ `reports`（`id=8`）を取得しています。

   | folderId |
   | -------- |
   | 3        |
   | 5        |
   | 6        |
   | 8        |

5. **ドキュメントの取得**
   CTE を使って、各フォルダに含まれるドキュメントを取得します。

   ```sql
   -- フォルダ内の全てのドキュメントを取得
   SELECT
    da_document.id,
    da_document.folder_id,
    da_document.name,
   FROM
    r
    JOIN da_document ON da_document.folder_id = r.folderId
   ```

   | id  | folderId | name         |
   | --- | -------- | ------------ |
   | 1   | 3        | resume.dox   |
   | 2   | 3        | picture.png  |
   | 3   | 5        | report.pdf   |
   | 5   | 6        | vacation.jpg |

## 注意点

1. **無限ループの防止**
   再帰クエリには終了条件（例: `num < 10`）が必要です。
   終了条件を設定しないと、クエリが無限ループに陥る可能性があります。
2. **パフォーマンス**
   再帰クエリはデータが大きい場合にパフォーマンスに影響を与えることがあります。
   上限設定やインデックスの活用が重要です。
