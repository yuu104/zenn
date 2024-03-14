---
title: "CSP"
emoji: "🦔"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [security, xss]
published: false
---

## CSP とは

- ブラウザに対して、どのような外部リソースがウェブページで許可されるかを指示するための仕組みで、**ブラウザ標準の機能**
- CSP を用いることで、ブラウザが読み込み可能なリソース（JavaScript, CSS, Img など）をホワイトリストで制限することができる
- これにより、悪意あるリソースの読み込みを防ぐことができる

CSP を設定するためには以下の 2 通りがある。

- Web サーバのレスポンスヘッダーに `Content-Security-Policy` を含ませる
- HTML の `<meta>` タグを使用して指定する

Web サーバのレスポンスヘッダーに含めてポリシーを定義するのがメジャー？

## Web サーバのレスポンスヘッダーに `Content-Security-Policy` を設定

以下のように設定する。

```
Content-Security-Policy: {policy}
```

- `policy` の箇所には、制限するリソースの種類（ディレクティブ）と、読み込み元（ソース）のペアを指定する
- ディレクティブは、特定の種類のリソースに対するポリシーを定義する
- 例えば、
  - `script-src` : どのスクリプトが実行されるかを制御する
  - `img-src` : どの画像が表示されるかを制御する
  - `style-src` : どのスタイルシートが適用されるかを制御する
- XSS に対する設定を明示的に行う場合、基本的にはスクリプトに対する制限をかけたいので、`script-scr` を定義する

### 適用例

```http
Content-Security-Policy: script-src 'self';
```

上記の場合、同じオリジンから読み込まれたスクリプトのみを許可する
:::details オリジンが異なるスクリプトの読み込みはブロックされる

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>csp test</title>
  </head>
  <body>
    <!-- `127.0.0.1:8888`は同一オリジンではないため、ブロックされる -->
    <script src="http://127.0.0.1:8888/csp.js"></script>
  </body>
</html>
```

:::

:::details インラインスクリプトはブロックされる

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>csp test</title>
  </head>
  <body>
    <script>
      alert(1); // インラインスクリプトなので実行されない
    </script>
  </body>
</html>
```

:::

:::details インラインのイベントハンドラはブロックされる

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>csp test</title>
  </head>
  <body>
    <!-- `onerror`は実行されない -->
    <img src="invalid-value" onerror="alert('XSS攻撃')" />
  </body>
</html>
```

:::

:::details javascript スキームによるスクリプトの実行はブロックされる

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>csp test</title>
  </head>
  <body>
    <!-- alert('XSS攻撃')は実行されない -->
    <a href="javascript:alert('XSS攻撃')">Click Me!!</a>
  </body>
</html>
```

:::

以下のように、`;` で区切ることで複数のディレクティブを指定できる。

```http
Content-Security-Policy: defaultsrc 'self'; scriptsrc 'self' *.trusted.com
```

### 代表的なディレクティブ

CSP には以下のように様々なコンテンツを制御するためのディレクティブが用意されている。

| ディレクティブ名          | 意味                                                                                       |
| ------------------------- | ------------------------------------------------------------------------------------------ |
| script-src                | JavaScript などのスクリプトの実行を許可する                                                |
| style-src                 | CSS などのスタイルの適用を許可する                                                         |
| img-src                   | 画像の読み込み先を許可する                                                                 |
| media-src                 | 音声や動画の読み込み先を許可する                                                           |
| connect-src               | XHR や fetch 関数などのネットワークアクセスを許可する                                      |
| default-src               | 指定されていないディレクティブを一括で許可する                                             |
| frame-ancestors           | iframe などで現在ページの埋め込みを許可する                                                |
| upgrade-insecure-requests | http:// から始まる URL のリーソース取得を https:// から始まる URL に変換してリクエストする |
| sandbox                   | コンテンツをサンドボックス化して隔離させることで外部からのアクセスなどを制御する           |

この中でも `default-src` は特別な意味を持つ。
`default-src` は明示的に指定されていない他のディレクティブの制御について指定するディレクティブ。
以下の場合、全ての種類のコンテンツ読み込み先は `trusted.com` 及びそのサブドメインに限定される。

```http
Content-Security-Policy: default-src *.trusted.com
```

他のディレクティブに関しては、下記参照。
https://qiita.com/yuria-n/items/c50a1bc0ba51f6e33215
https://www.proactivedefense.jp/blog/blog-vulnerability-assessment/post-2179#index_id1

### ソースのキーワード

`self` のように、ソースに指定できる特別な意味を持つキーワードは以下の通り。

| style-src     | Text                                                                                                                                                                                                            |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| self          | CSP で保護するページと同一オリジンのみ許可する                                                                                                                                                                  |
| none          | あらゆるオリジンも許可しない                                                                                                                                                                                    |
| unsafe-inline | `script-src` や `style-src` ディレクティブにて、インラインスクリプトやインラインスタイルの使用を許可する                                                                                                        |
| unsafe-eval   | `script-src` ディレクティブにて、`eval` 関数の使用を許可する                                                                                                                                                    |
| unsafe-hashes | `script-src` ディレクティブにて、DOM に設定された `onclick` や `onfocus` などの実行は許可するが、`<script>` 要素を使用したインラインスクリプトや `javascript:` スキームを使用した JavaScript の実行を許可しない |

- 明示的に `unsafe-inline` が指定されていないページでは、HTML の `<script>` 要素内のインラインスクリプトやインラインのイベントハンドラ、`<style>` 要素や `style` 属性を使用したスタイルは実行されない

![](https://storage.googleapis.com/zenn-user-upload/0146a70584dd-20240314.png)

- `unsafe-inline` や `unsafe-hashes` のキーワードを使用すれば、それらのインラインスクリプトやインラインスタイルの実行を許可できる
- しかし、`unsafe-xxx` のソースは安全ではないため、XSS を発生させる恐れがある
- `unsafe` という接頭辞がついている理由は、ブラウザはサーバ内で埋め込まれたインラインクリプトやインラインスタイルが、正規に埋め込まれたものなのか、XSS によって埋め込まれたものなのか判断できないから
- よって、**`unsafe-xxx` のソースの使用は非推奨**

また、以下のように一つのディレクティブに対して複数のソースを指定できる。

```http
Content-Security-Policy: script-src 'self' 'unsafe-inline' *.trusted.com
```

上記のようなソースを組み合わせながら、最初は `unsafe-inline` などを使用して緩いポリシーから運用をはじめ、徐々に厳しいポリシーへ移行していくこともできる。

## Strict CSP

- CSP を適用してインラインスクリプトを許可する方法として、`unsafe-inline` ソースを指定するものがあった
- しかし、`unsafe-inline` は非推奨
- 安全にインラインスクリプトやインラインスタイルを許可するためには、**nonce-source** や **hash-source** と呼ばれるソースを利用する

#### none-source

- none-source は、`<script>` 要素に指定したランダムなトークンが CSP ヘッダのソースに指定されているトークンと一致しなければエラーにする機能
- 指定するトークンは固定値ではなく、リクエストごとにトークンを変更して、攻撃者が推測できないようにする必要がある
- none-source は以下のように指定する

```http
Content-Security-Policy: script-src 'nonce-tXCHNF14TxHbBvCj3G0WmQ=='
```

- `tXCHNF14TxHbBvCj3G0WmQ==` の部分がトークン
- ソースに指定したトークンを、以下のように `<script>` 要素の `nonce` 属性に指定する

```html
<script nonce="tXCHNF14TxHbBvCj3G0WmQ==">
  alert("このscriptは許可されているので実行される");
</script>

<script>
  alert("このscriptは許可されていないため実行されない");
</script>
```

- `nonce-source` を利用した場合は以下のように JavaScript ファイルの実行も制限することができる

```html
<!nonceが付与されているため実行されるJavaScriptファイル>
<script src=./allowed.jsnonce="tXCHNF14TxHbBvCj3G0WmQ=="></script>
<script src=https://crossorigin.example/allowed.jsnonce="tXCHNF14TxHbBvCj3G0WmQ=="></script>

<!nonceが付与されていないため実行されないJavaScriptファイル>
<script src=./notallowed.js></script>
```

- `nonce` 属性の値が正しければ、クロスオリジンの JavaScript ファイルの実行も許可される
- 実際の開発では、複数オリジンを指定しなければならない場合など、指定するオリジンの管理が難しいことがある

- また、nonce-source が有効なページでは、`onclick` 属性などで指定されたイベントハンドラの実行が禁止される

```html
<button id="btn" onclick="alert('クリックされました')">ClickMe!</button>
```

#### hash-source

## HTML の `<meta>` タグを使用して指定する

- `<head>` セクションに `<meta>` タグを使用して、CSP を設定する
- `<meta>` タグを使った方法は、サーバーの設定にアクセスできない場合や、特定のページにのみポリシーを適用したい場合に便利

```html
<meta http-equiv="Content-Security-Policy" content="script-src 'self'" />
```

注意点として、**`<meta>` タグを使用して CSP を指定する場合、全てのディレクティブが使用できるわけではない**。
`frame-ancestors` や `report-uri` ディレクティブは使用できない。

## `<meta>` タグとレスポンスヘッダーのどちらで CSP 設定すべきか？

- 基本的には Web サーバのレスポンスヘッダーで設定すれば良いと思う
- `<meta>` タグでの設定は色々と制限があるため、サクッと設定したい場合のみ使用する感じで良さそう

## CSP を導入前にテストする

- CSP は性質上、ホワイトリスト形式
- よって、少し設定を間違えると、サイトが機能しなくなる恐れがある
- 元々適用していなかったサイトに CSP を適用させるのは難易度が高い
- そのため、適用前に**ブロックしないテスト専用の CSP**がある
- `Content-Security-Policy-Report-Only` ヘッダーは CSP の一種
- ポリシー違反があった場合に、実際にブロックはせず、違反を報告してくれる
- 既存サイトの CSP を設定・更新する際に、ポリシーの影響をモニタリングし、調整するために使える
- **`Content-Security-Policy-Report-Only` ヘッダは `<meta>` タグによる設定ができない**

### 基本的な概念

- **レポートモード**:
  `Content-Security-Policy-Report-Only` ヘッダーを使用すると、ブラウザは設定されたポリシーに違反する行為をブロックせず、代わりに指定されたレポート URI に違反レポートを送信する。

- **デバッグ目的**:
  このモードは、新しいポリシーを導入する際のデバッグやテストに非常に役立つ。違反が発生してもユーザー体験に影響を与えることなく、ポリシーがどのように機能するかを理解しやすくなる。

- **段階的な導入**:
  CSP を初めて導入する場合や、既存のポリシーを大幅に変更する場合、`Report-Only` モードを使用して、予期しない問題が発生しないかを確認しながら段階的に導入することができる。

### 使用方法

- HTTP レスポンスヘッダーとして設定する

  ```http
  Content-Security-Policy-Report-Only: [ポリシーディレクティブ]; report-uri [レポートURI];
  ```

- 例えば、以下のように設定することができる：
  ```http
  Content-Security-Policy-Report-Only: default-src 'self'; report-uri /csp-report-endpoint;
  ```
  この設定では、自ドメイン (`'self'`) からのリソースのみを許可し、ポリシー違反が発生した場合は `/csp-report-endpoint` にレポートを送信する

### 注意点

- **レポートの収集**:
  レポート URI は、CSP 違反レポートを受け取るエンドポイントを指定する必要がある。このエンドポイントは違反レポートの収集と分析を行うための仕組みを備えている必要がある。

- **本番環境での使用**:
  テストやデバッグフェーズ後、問題が解決されたと確信したら、`Content-Security-Policy` ヘッダーに切り替えて、ポリシーを強制することが推奨される。

## CSP のデメリット

- CSP はブラウザが読み込み可能なリソースをホワイトリストで制限するもの
- それが故に、メンテナンスが大変
- 読み込みを許可するリソースのリストアップが大変
- 少し設定を間違えると、サイトが機能しなくなる恐れがある
