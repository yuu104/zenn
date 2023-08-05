---
title: "DTDとブラウザレンダリングモード"
---

## ブラウザのレンダリングモード

Web ページの画面描画は、ブラウザの**レンダリングエンジン**によって行われる。
HTML ファイルが同じであっても、レンダリングエンジンの差異により、レイアウトの崩れや文字サイズが異なる場合がある。

このような現状を解消するために、各ブラウザのレンダリングエンジンにはモードが用意されており、HTML を解釈して画面に描画する方法を変更できる。

ブラウザのレンダリングモードは**標準モード（Standard）**と**互換モード（Quirks）**の 2 種類がある。
::: details 標準モード
CSS などを仕様通りに正しく表示するモード。
現在のブラウザは CSS を解釈して標準仕様通りに Web ページを表示するが、それを文書宣言で指定する場合は、標準モードを指定する。
:::

::: details 互換モード
CSS 普及する前のブラウザとの互換性を維持するためのモード。
互換モードを指定することで、ブラウザは標準仕様とは異なる方法で HTML を解釈して画面に描画する。
互換モードでは CSS の指定が正しく解釈されないため、レイアウトや文字サイズなどが意図したものと異なる可能性がある。
:::

## DOCTYPE スイッチ

- HTML でブラウザのレンダリングモードを切り替えること
- DOCTYPE スイッチをするには、**文書宣言（DTD）**を使用する
- 具体的には、HTML の冒頭に `<!DOCTYPE ...>`　を記述する

![](https://storage.googleapis.com/zenn-user-upload/b674ae315f64-20230805.png)

## 文書型宣言（DTD）の指定方法

HTML の 1 行目に「<!DOCTYPE」で始まる宣言を記述することで、レンダリングモードを指定できる。
HTML4.01 では、指定方法が 3 種類ある。
DTD でブラウザのレンダリングモードを指定する際は、この 3 種類の指定方法を使い分ける。
（システム識別子の有無も影響する）

### Strict DTD

- HTML4.01 本来の記述に厳密に従う
- W3C が非推奨とするタグと属性は使えない
- フレームワークは使えない

```html
<!DOCTYPE HTMLPUBLIC"//W3C//DTDHTML4.01//EN">
```

```html
<!DOCTYPE HTMLPUBLIC"//W3C//DTDHTML4.01//EN""http://www.w3.org/TR/html4/strict.dtd">
```

### Transitional DTD

- W3C が非推奨とするタグや属性が使える
- フレームワークは使えない

```html
<!DOCTYPE HTMLPUBLIC"//W3C//DTDHTML4.01Transitional//EN">
```

```html
<!DOCTYPE HTMLPUBLIC"//W3C//DTDHTML4.01Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
```

### Frameset DTD

- W3C が非推奨とするタグや属性が使える
- フレームワークが使える

最近では、Web ページにフレームが使用されなくなったため、Frameset DTD は使用されていない。

```html
<!DOCTYPE HTMLPUBLIC"//W3C//DTDHTML4.01Frameset//EN">
```

```html
<!DOCTYPE HTMLPUBLIC"//W3C//DTDHTML4.01Frameset//EN""http://www.w3.org/TR/html4/frameset.dtd">
```

![](https://storage.googleapis.com/zenn-user-upload/215f8dc232ad-20230805.png)

DTD を指定したとしても、実際にモードが適用されるかどうかはブラウザに依存する。

## HTML5 の文書型宣言

最新の HTML5 では文書型宣言は 1 種類のみ。
表記はシンプルになり、大文字、小文字を区別せずに短く記述することができる。

```html
<!DOCTYPE html>
```

HTML5 であることを明示的にブラウザに伝えるよう、HTML ファイルに上記を追加する。
省略した場合、互換モードに設定される。
