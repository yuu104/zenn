---
title: "HTMLの基本構造"
---

## 文書宣言・ヘッダー・ボディ

HTML ドキュメントは、大きく分けて**文書型宣言**、**ヘッダー**、**ボディ**で構成されている。

![](https://storage.googleapis.com/zenn-user-upload/0c10c7b07d1d-20230805.png)

## 文書型宣言

HTML ドキュメントの先頭には、どのような**文書型定義**(**DTD** : Document TypeDefinition)に基づいて記述されているかを`<!DOCTYPE ...>` を使用して宣言する。
:::details なぜ文書型宣言をするの？
HTML には複数のバージョンが存在し、バージョンごとに使えるタグや属性、その指定方法が異なっているから。
文書型宣言により、どのバージョンに基づいて作られた HTML ドキュメントなのかを明確にしている。
:::

![](https://storage.googleapis.com/zenn-user-upload/27635403616c-20230805.png)
**システム識別子**は省略可能。

`<!DOCTYPE ...>` はブラウザで解釈され、レンダリングの方法を決定する。

文書型宣言の詳細は[こちら](https://zenn.dev/yuu104/books/web-technology-textbook/viewer/dtd)

## ヘッダー

ヘッダーには以下のような HTML ドキュメントに対するメタデータを挿入する。

- ページタイトル
- 使用言語（文字コード）
- キャッシュの有効期限
- 検索サイトのためのキーワード
- サイトの説明

ヘッダー内で使われる主要なタグは以下の通り。

- `<title>`
- `<link>`
- `<script>`
- `<meta>`

![](https://storage.googleapis.com/zenn-user-upload/31a52b0c52c9-20230805.png)

ユーザに直接見えるのは `<title>` タグの内容だけ。

## ボディ

ボディには様々な HTML タグを使用して、Web ページの本文を記述する。
ボディを構成する要素を、**ブロックレベル要素**と**インライン要素**に分けることができる。

![](https://storage.googleapis.com/zenn-user-upload/0da693154dbe-20230805.png)
