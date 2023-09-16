---
title: "キー"
---

## RDB におけるキーとは

- 任意のレコード（1 行とは限らない）を特定するための**列の組み合わせ**
- キーの種類は複数ある

## 主キー

- **プライマリーキー**とも呼ぶ
- テーブルにおいて必ず一つ存在する
- 一つしか存在しない
- 主キーを指定すれば、必ず 1 行のレコードを指定できるような列の組み合わせ

![](https://storage.googleapis.com/zenn-user-upload/cd7a8064809e-20230910.png)

上記の場合テーブルでは、`社員ID` が主キーとなる。

「主キーがテーブルに必ず存在しなければならない」というルールは、以下のことを導く。
**テーブルには重複行は存在できない**

![](https://storage.googleapis.com/zenn-user-upload/11b99240b845-20230910.png)

### 主キーの決め方

主キーを決定するうえで考慮すべきこと。
https://qiita.com/wanko5296/items/a96bdeccc250f7c18cee

## 複合キー

- 複数列を組み合わせた主キー

## 候補キー

- 主キーとして利用可能なキーが複数存在した場合、それらの「候補」となるキー
- 候補キーは複数存在し得る
- 主キーは一つのテーブルに一つしか設定できないため、候補キーから一つを選択する

## 外部キー

- 二つのテーブル間の列同士で設定するもの

![](https://storage.googleapis.com/zenn-user-upload/b240eb38fba7-20230910.png)

上記では `社員` テーブルの `部署` カラムが外部キーになる。
このカラムは、部署一覧を保持する `部署` テーブルの `部署` 列を参照している。

### 外部キーの役割

外部キーは `社員` テーブルに対して一種の「**制約**」を課すことを役割としている。
`部署` テーブルに存在しないデータが `社員` テーブルの `部署` カラムに存在しないように制約している。
このような制約を「**外部キー制約（参照整合性制約）**」と呼ぶ。

例えば、`社員` テーブルに以下のレコードを登録することはできない。

![](https://storage.googleapis.com/zenn-user-upload/78b8db22cb9d-20230910.png)

`部署` カラムにある `広報` というデータは、`部署` テーブルに登録されていない。
そのため、このレコードを登録しようとすると SQL 文はエラーになる。

一方、`部署` テーブルに以下のレコードを登録することは可能。

![](https://storage.googleapis.com/zenn-user-upload/db3e4090a77f-20230910.png)

`部署` テーブルは `社員` テーブルの「親」にあたる存在であるため、「子」の状態を気にすることなく変更可能。

### カスケード

- 外部キーに関連する概念
- 「削除カスケード」と「更新カスケード」の 2 種類存在する

#### 削除カスケード

- 親テーブルのレコードが削除されたとき、それに関連する子テーブルのレコードも自動的に削除されるアクション

#### 更新カスケード

- 親テーブルの主キー値が変更されたとき、それに関連する子テーブルの外部キー値も自動的に更新されるアクション

- このように、カスケードによりデータ整合性を維持し、手動でデータの同期を行わなくても関連データを保つのに役立つ
- 親テーブルのレコードを削除・更新時に、カスケードを実行するか SQL をエラーにするかを選択することができる
- 子テーブル作成時にカスケードの設定を行うことができる