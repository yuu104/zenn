---
title: "【アンチパターン】なんでもJSON"
---

## はじめに

RDB とスキーマレス設計には、相性が悪い側面があります。
それでも、「JSON 型でデータを保存できればスキーマレスな設計が簡単に実現できる」という考えから、MySQL や PostgreSQL で JSON 型を使いたくなることがあります。

しかし、これにはリスクが伴います。JSON 型を使った設計は一見柔軟に見えますが、RDB 設計のアンチパターンに陥る可能性があります。
本記事では、「なんでも JSON」によるアンチパターンについて説明します。

## デメリット

### ① クエリが複雑になる

例えば、次のようにデータを JSON 型で保存するテーブルを考えます。

```sql
CREATE TABLE people(
    id serial primary key,
    data jsonb not null
);

INSERT INTO people(data) VALUES ($$
{
    "name": "Bob",
    "addresses": [
        {
            "street": "Centre",
            "streetnumber": 24,
            "town": "Thornlie",
            "state": "WesternAustralia",
            "country": "Australia"
        },
        {
            "street": "Example",
            "streetnumber": "4/311-313",
            "town": "Auckland",
            "country": "NewZealand"
        }
    ],
    "phonenumbers": [
        {
            "type": "mobile",
            "number": "12345678"
        }
    ]
}
$$);

INSERT INTO people(data) VALUES ($$
{
  "name": "Fred",
  "phonenumbers": [
    { "type": "mobile", "number": "12345678" }
  ]
}
$$);

INSERT INTO people(data) VALUES ($$
{
  "name": "John Doe"
}
$$);
```

「同じ電話番号を持つ人」を探すにはどうしたらよいでしょうか？
クエリは以下になります。

```sql
SELECT
  p1.id AS person1,
  p2.id AS person2,
  p1.data ->> 'name' AS "p1 name",
  p2.data ->> 'name' AS "p2 name",
  pns1 ->> 'type' AS "type",
  pns1 ->> 'number' AS "number"
FROM people p1
  INNER JOIN people p2
    ON (p1.id > p2.id)
  CROSS JOIN LATERAL jsonb_array_elements(p1.data -> 'phonenumbers') pns1
  INNER JOIN LATERAL jsonb_array_elements(p2.data -> 'phonenumbers') pns2
    ON (pns1 -> 'type' = pns2 -> 'type' AND pns1 -> 'number' = pns2 -> 'number');
```

とても複雑になっていますね...

可読性が低下し、パフォーマンス上の課題も生じやすくなります。
また、`jsonb_array_elements` や `->` などの PostgreSQL 独自機能は多くの開発者にとって馴染みがなく、理解を妨げる要因となります。

### ② ORM が使えない

多くの ORM は JSON データ型をサポートしていません。
そのため、JSON 型に頼った設計をしてしまうと、長期的には開発工数が増大するリスクがあります。

### ③ データの整合性が保てない

JSON は次のような障壁により、データの整合性を保つことが難しいです。

1. **必須属性の指定が難しい**
   必須にしたい属性に対して簡単に制約を設けることができません。
   `CHECK` 制約を使えば既知の情報に対しては指定できますが、新しい属性を追加するたびに `ALTER` が必要になります。
   \
   例えば、電話番号を必須にするために JSON 内の特定キーをチェックする `CHECK` 制約を追加したとします。
   その後、新たに住所を必須にしたい場合、再び `ALTER` 文を使って `CHECK` 制約を更新する必要があります。

   :::details 具体的なクエリ例

   ```sql
   -- 初期の CHECK 制約の追加（電話番号が必須）
   ALTER TABLE people
   ADD CONSTRAINT check_phone_number
   CHECK (data ? 'phonenumbers');

   -- 新たに住所を必須にするための CHECK 制約の更新
   ALTER TABLE people
   DROP CONSTRAINT check_phone_number,
   ADD CONSTRAINT check_phone_and_address
   CHECK (data ? 'phonenumbers' AND data ? 'addresses');
   ```

   :::

   この手間を考えると、単純に新しいカラムを追加する方がシンプルで管理しやすい場合があります。

2. **データフォーマットのばらつき**
   同じ情報でもフォーマットが異なる可能性があります（例: yyyy/mm/dd と yyyy-mm-dd）。
   \
   また、PostgreSQL だと、`->` を利用している場合、演算子の返却値は JSON オブジェクトなので、`"1234"`（文字列）と `1234`（数値）は別物として扱われ、両者を比較するクエリを書くとエラーになります。

   ```sql
   SELECT * FROM people WHERE data -> 'id' = '1234';
   ```

   そのため、JSON の値を文字列として扱う `->>` という演算子を使用し、文字列に統一してから比較する必要があります。

   ```sql
   SELECT * FROM people WHERE data ->> 'id' = '1234';
   ```

3. **参照整合性制約を強制できない**
   - JSON の中身は外部キー制約を使用できません
   - そのため、`都道府県` という Key に対して、`東京都` と `東京` の両方が保存される可能性があります
   - Value だけでなく、Key 名も表記揺れの影響を受けます

## JSON 型のメリット

### ① JSON そのものに対応している

カラムの値が本来 JSON であるべきもの場合、パースすることなく対応できます。
以下のような値は適しています。

- Web API の戻り値
- PHP の Composer（設定ファイルが JSON）

これらの値は、正規化してそれぞれの値として保存することも可能ですが、JSON として扱うことで便利になるケースも多々あります。
このような場合は JSON 型が適しています。

### ② スキーマレスに値を保存できる

RDB を使用する必要があり、なおかつスキーマレスなデータを保持しておきたいときは JSON が必要とされます。
しかし、RDB 以外での選択肢を検討した上で慎重に意思決定する必要があります。

## JSON 型のユースケース

### ① Web API の戻り値

Twitter の Web API と連携するため、メインで使用するテーブル（`twitter_account`）とサブデーブル（`teitter_account_detail`）を分けつつ、履歴も残す設計を行う。
![](https://storage.googleapis.com/zenn-user-upload/7b659b288be8-20240916.png)

何故このようにしたのか？

- Twitter 側は予告なく API を変更するので、戻り値が `Error` にならずに保存されているときも対応できるように保存
- 必要なデータは正規化してその他が含まれる JSON は別テーブルに分けることで、パフォーマンスを向上させつつ、必要なデータが取得できなくなったときには `Error` で気づける

API レスポンスで取得したデータを別で保存しておくことで、API 側の仕様変更にも柔軟に対応できる。

### ② OS 情報

![](https://storage.googleapis.com/zenn-user-upload/2c4dac1eb2fe-20240916.png)

OS 情報にはディストリビューション固有のものがある。
`details` カラムに JSON として保持しておくことで、ディストリビューションごとの違いを吸収する。

「OS テーブル」とそれに紐ずく「ディストリビューションテーブル」をそれぞれ作り、JSON を使用しない手法もある。
しかし、以下のような要件は JSON が適している。

- レコード数が少なく、数千程度
- 一度保存したレコードに対して `UPDATE` することはほぼない
- 取り出すときは JSON をまるごと取得する

以下の場合は JSON の採用は避けるべき。

- JSON の Key に対して検索したい
- JSON の特定の値を更新したい
- JSON の中の値に制約を設けたい

## JSON 型を採用しても良いケース

以下の条件に当てはまる場合、JSON 型の使用はアンチパターンには該当せず、有効な選択肢となり得ます。

1. **検索に利用しない場合**

   - JSON データに対して頻繁に検索を行わない場合、JSON 型を使うことで柔軟にスキーマレスなデータを保持することが可能です。
   - 検索を行わないことで、インデックスを使用する必要がなく、JSON の特性を活かしたデータ保存が行えます。

2. **データの更新が全体で行われる場合**

   - データを更新する場合に、JSON データを丸ごと上書きするような用途であれば、JSON 型の利用は問題ありません。
   - 部分的な更新が必要な場合はクエリが複雑化しやすいですが、全体を更新する場合はこの問題を回避できます。

3. **スキーマが頻繁に変更される可能性がある場合**

   - 保持するデータのスキーマが頻繁に変更される可能性がある場合、固定のカラムを持つ構造では柔軟に対応できません。
   - そのため、スキーマレスな JSON 型を使うことで、柔軟な対応が可能となります。
   - 例えば、外部サービスから取得する API のレスポンスデータを保持する際に、レスポンスが予告なく変更される可能性があるケースに適しています。

4. **データをそのまま取り出して利用する場合**
   - JSON データをほぼそのままの形で利用する場合には、JSON 型は非常に便利です。
   - 例えば、外部サービスのレスポンスデータをそのまま保存して、必要に応じてそれを再利用するような場合です。
   - このような用途では、JSON 型の利用によりシンプルな設計が可能です。

## JSON 型の採用を避けるべきケース

以下に 1 つでも該当する場合、JSON 型を採用すべきではありません。

- 正規化することができる
- JSON に対して頻繁に更新を行いたい
- 検索条件として JSON 内の属性が固定できない

:::message
**多くのケースはアンチパターンに該当する**。
**JSON 型は、RDBMS の機能と引き換えに柔軟性を与える、最後の切り札。**
:::

## JSON を扱う際に参考になりそうな資料

https://zenn.dev/yumemi_inc/articles/eba113a2483c14
