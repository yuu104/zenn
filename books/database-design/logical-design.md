---
title: "概念スキーマと論理設計"
---

## 論理設計とは

- 概念スキーマを定義すること
- 「**物理層の制約にとらわれない**」部分の設計

:::details 物理層の制約とは？

- DB サーバの CPU パワー
- ストレージのデータ格納場所
- DBMS で使えるデータ型や SQL の構文

のような、具体的で実装レベルの条件のこと。
:::

- 論理設計では、まだハードウェアの購入や DBMS のミドルウェアをインストールしない
- すべて**机上**で行うことが可能

## 論理設計の手順

![](https://storage.googleapis.com/zenn-user-upload/67365d0954d1-20230916.png)

### エンティティの抽出

- **エンティティ**は、現実世界に存在するデータの集合体を指す言葉
  - 「社員」「顧客」「店舗」「車」「会社」「注文履歴」など
- RDB では、エンティティを「テーブル」という単位で格納していく
  - エンティティ = テーブル
- システムのためにどのようなエンティティが必要になるのかを抽出する

### エンティティの定義

- 各エンティティがどのようなデータを保存するのかを決める
- エンティティは、データを「**属性**（attribute）」という形で保存する
  - 属性 = テーブルの「列（カラム）」
- 各テーブルがどのような「列」を持つのかを定義する

![](https://storage.googleapis.com/zenn-user-upload/2711ef961cbb-20230916.png)

## 正規化

https://zenn.dev/yuu104/books/database-design/viewer/normalized-form

## ER 図の作成

https://zenn.dev/yuu104/books/database-design/viewer/er-diagram
