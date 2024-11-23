---
title: "【アンチパターン】単一参照テーブル"
---

## 単一参照デーブル

ダブルネーミングの概念がテーブル全体に広がったもの。
以下の第 3 正規化まで進んだテーブル群を例に考える。

![](https://storage.googleapis.com/zenn-user-upload/b28c26655eb4-20231028.png)

`会社` テーブルと `部署` テーブルはデータの構造が同じであるため、**一つのテーブルにまとめることが可能**。

以下のように、同じ構造をもつエンティティを同一のデーブルとして定義したものを**単一参照テーブル**と呼ぶ。

![](https://storage.googleapis.com/zenn-user-upload/a010d1ed20ab-20231028.png)

## メリット

- マスタテーブルの数が減るため、ER 図やスキーマがシンプルになる
- コード検索の SQL を共通化できる

## デメリット

- `コードタイプ`、`コード値`、`コード内容` の各列とも、必要とされる列長はコード体系によって異なるため、余裕を見てかなり大きめの可変長文字列型で宣言する必要がある
- 一つのテーブルにレコードを集約するため、コード体系の種類と大きさによっては、レコード数が多くなり、検索のパフォーマンスが悪化する
- コード検索の SQL 内でコードタイプやコード値を間違えて指定してもエラーになることがないため、バグに気づきにくい
- ER 図がスッキリするとは言っても、ER モデルとしては正確さを欠いており、逆に ER 図の可読性を下げる