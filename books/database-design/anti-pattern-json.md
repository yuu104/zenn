---
title: "【アンチパターン】なんでもJSON"
---

RDB はスキーマレスな設計と相性が悪い。
しかし、データを JSON としてカラムに保存できれば、簡単にスキーマレスな設計を実現可能。
MySQL や PostgreSQL は JSON に対応している。

しかし、JSON 型は完全ではない。

## デメリット

### 複雑すぎるクエリ

以下のデータを例にする。

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

同じ電話番号を持つ人を探すにはどうしたらよいか？
クエリは以下になる。

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
  CROSS JOIN lateral jsonb_array_elements(p1.data -> 'phonenumbers') pns1
  INNER JOIN lateral jsonb_array_elements(p2.data -> 'phonenumbers') pns2
    ON (pns1 -> 'type' = pns2 -> 'type' AND pns1 -> 'number' = pns2 -> 'number');
```

とても複雑になっている...
挙動のイメージがしずらく、パフォーマンスにも課題があるクエリ。

また、`jsonb_array_elements` や　`->` などは PostgreSQL 独自のため、多くのユーザーは知らず、可読性が悪くなる。

### ORM が使えない

多くの ORM は JSON データ型をサポートしていない。
そのため、JSON 型に頼った設計をしてしまうと、長期的な開発工数が激増する可能性がある。

### データの整合性が保てない

以下のような問題がある。

1. **必須属性の指定が難しい**
   - 名前を必須属性にしたい場合、PostgreSQL では CHECK 制約を利用して JSON の Key を指定可能
   - しかし、指定できるのは既知の情報のみ
   - よって、電話番号も必須属性にしたい場合、ALTER が必要になる
   - これならば、DB にカラムを増やす方がシンプルなのでは？
2. **データの中身を指定できない**
   - 日付として `yyy/mm/dd` と `yyy-mm-dd` のように、フォーマットの差異が生じる可能性がある
   - PostgreSQL だと、`->` を利用している場合、演算子の返却値は JSON オブジェクトなので、`"1234"`（文字列）と `1234`（数値）は別物として扱われ、型違いでエラーになる
3. **参照整合性制約を強制できない**
   - JSON の中身は外部キー制約を使用できない
   - そのため、`都道府県` という Key に対して、`東京都` と `東京` の両方が保存される可能性がある
   - Value だけでなく、Key 名も表記揺れの影響を受ける

## JSON 型のメリット

### JSON そのものに対応している

カラムの値が本来 JSON であるべきもの場合、パースすることなく対応できる。
以下のような値は適している。

- Web API の戻り値
- PHP の Composer（設定ファイルが JSON）

これらの値は、正規化してそれぞれの値として保存することも可能だが、JSON として扱うことで便利になるケースも多々ある。
このような場合は JSON 型が適している。

### スキーマレスに値を保存できる

RDB を使用する必要があり、なおかつスキーマレスなデータを保持しておきたいときは JSON が必要とされる。
しかし、RDB 以外での選択肢を検討した上で慎重に意思決定する必要がある。

## JSON 型のユースケース

### Web API の戻り値

Twitter の Web API と連携するため、メインで使用するテーブル（`twitter_account`）とサブデーブル（`teitter_account_detail`）を分けつつ、履歴も残す設計を行う。
![](https://storage.googleapis.com/zenn-user-upload/7b659b288be8-20240916.png)

何故このようにしたのか？

- Twitter 側は予告なく API を変更するので、戻り値が `Error` にならずに保存されているときも対応できるように保存
- 必要なデータは正規化してその他が含まれる JSON は別テーブルに分けることで、パフォーマンスを向上させつつ、必要なデータが取得できなくなったときには `Error` で気づける

API レスポンスで取得したデータを別で保存しておくことで、API 側の仕様変更にも柔軟に対応できる。

### OS 情報

![](https://storage.googleapis.com/zenn-user-upload/2c4dac1eb2fe-20240916.png)

OS 情報にはディストリビューション固有のものがある。
`details` カラムに JDON として保持しておくことで、ディストリビューションごとの違いを吸収する。

「OS テーブル」とそれに紐ずく「ディストリビューションテーブル」をそれぞれ作り、JSON を使用しない手法もある。
しかし、以下のような要件は JSON が適している。

- レコード数が少なく、数千程度
- 一度保存したレコードに対して UPDATE することはほぼない
- 取り出すときは JSON をまるごと取得する

以下の場合は JSON の採用は避けるべき。

- JSON の Key に対して検索したい
- JSON の特定の値を更新したい
- JSON の中の値に制約を設けたい

## アンチパターンのチェックポイント

以下に 1 つでも概要する場合、JSON 型を採用すべきではない。

- 正規化することができる
- JSON に対して頻繁に更新を行いたい
- 検索条件として JSON 内の属性が固定できない

多くのケースはアンチパターンに該当する。
JSON 型は、RDBMS の機能と引き換えに柔軟性を与える、最後の切り札。
