---
title: "JSON"
---

## JSON とは

- XML の代わりに利用されている
- XML では要素の記述にタグを用いるため、データに対する修飾子の割合が高くなり、ファイルサイズが大きくなりがち
- JSON はファイルサイズが小さくて軽量
- XML よりも人の目で内容を確認しやすい

## JSON の記述

- JSON は**キー（Key）**と**値(Value)**のペアからなる**メンバー**で構成されている
- キーは**ダブルクォート**で囲み、**文字列**である必要がある
- 値には、文字列型に加え、数値型や配列型、ブーリアン型、オブジェクトなどを指定できる

![](https://storage.googleapis.com/zenn-user-upload/b48a2a0a87e1-20230806.png)

## ユニコードエスケープ処理

キーや値に文字列型を指定する場合は、セキュリティを考慮し、ユニコードエスケープ処理を行うことが推奨されている。
これは、JSON データ内に特殊文字や制御文字、非 ASCII 文字などが含まれいる場合に、それらをエスケープして安全に扱う方法。

JSON では、文字列内に以下のような特殊文字を直接記述することができない。
そのため、これらの文字は**JSON データへエンコードする際に**エスケープする必要がある。

- ダブルクォート（`"`）
- バックスラッシュ（`\`）
- 改行（`\n`）
- キャリッジリターン（`\r`）
- タブ（`\t`）
- バックスペース（`\b`）
- フォームフィード（`\f`）

ユニコードエスケープ処理により、**JSON の中に JavaScript の不正なコードが紛れ込むのを防ぐ**ことができる。

### 具体的なエスケープ方法

`\u`　に続けて Unicode 番号を 4 桁の 16 進数で指定した、`\u○○○○` といった形式にする。
例えば、日本語文字列「こんにちは」を JSON データに埋め込む場合、以下のようにエスケープされる。

```json
{
  "greeting": "\u3053\u3093\u306B\u3061\u306F"
}
```

JSON データを生成する際に、ユニコードエスケープ処理を行うことはセキュリティの観点から重要であることがわかった。
しかし、私たちは普段の開発で JSON データを扱う際、ユニコードエスケープ処理を意識していない。
それは、言語やライブラリが自動的に処理をしてくれているからである。
例えば、TypeScript の場合は、JSON データをエンコードする際に、`JSON.stringify()`を使用するが、このメソッドが自動でユニコードエスケープをしてくれている。
