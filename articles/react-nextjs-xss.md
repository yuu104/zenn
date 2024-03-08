---
title: "React, Next.jsで発生するXSS脆弱性と対策"
emoji: "🐙"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, nextjs, security, xss]
published: false
---

## はじめに

React や Next.js で使用する JSX 内の式埋め込みでは、基本的に HTML として解釈されないようエスケープされる。

```tsx
export default function App() {
  const html = `<script>alert('XSS攻撃')</script>`;

  return (
    <div className="App">
      <h1>Hello, React</h1>
      {html}
    </div>
  );
}
```

![](https://storage.googleapis.com/zenn-user-upload/21161d294087-20240108.png)

上記では、`<script>alert('aaa')</script>` は文字列として表示され、スクリプトは実行されない。
しかし、XSS 脆弱性が存在しないとは限らない。

## `dangerouslySetInnerHTML` の使用による脆弱性の発生

JSX では、`dangerouslySetInnerHTML` 属性を使用することで、エスケープを無効化し、HTML を直接挿入することが可能。
よって、以下のような XSS を引き起こす可能性がある。

#### `img` タグを使用して XSS 攻撃

```tsx
export default function App() {
  const html = `<img src="invalid-image" onerror="alert('XSS攻撃')">`;

  return (
    <div className="App">
      <h1>Hello, React</h1>
      <div dangerouslySetInnerHTML={{ __html: html }} />
    </div>
  );
}
```

`<img src="invalid-image" onerror="alert('XSS攻撃')">` は文字列としてエスケープされず、`alert('XSS攻撃')` が実行される。

#### `form` タグを使用して XSS 攻撃

```tsx
export default function App() {
  const html = `
    <form action="http://api.example.com/change_password" method="POST">
      <input type="hidden" name="password" value="hack" />
      <input type="submit" value="Reactの詳細ページ" />
    </form>
  `;

  return (
    <div className="App">
      <h1>Hello, React</h1>
      <div dangerouslySetInnerHTML={{ __html: html }} />
    </div>
  );
}
```

「React の詳細ページ」というリンクをクリックすると、パスワードが変更される例。

#### `<script>` 要素は実行されない

- `dangerouslySetInnerHTML` は、内部的に JavaScript の `innerHTML` を使用している
- よって、`<script>` の実行は行われない

```tsx
export default function App() {
  const html = `<script>XSS攻撃</script>`;

  return (
    <div className="App">
      <h1>Hello, React</h1>
      <div dangerouslySetInnerHTML={{ __html: html }} />
    </div>
  );
}
```

![](https://storage.googleapis.com/zenn-user-upload/38d1a0cf2b37-20240108.png)

### 対策

- `dangerouslySetInnerHTML` をそもそも使用しない
- [sanitize-html](https://www.npmjs.com/package/sanitize-html) ライブラリによるサニタイズ
- [DOMPurify](https://www.npmjs.com/package/dompurify) ライブラリによるサニタイズ
- [Sanitizer API](https://developer.mozilla.org/ja/docs/Web/API/HTML_Sanitizer_API)によるサニタイズ
- CSP を設定する

サニタイズライブラリの比較は[こちらを参照](https://push.co.jp/archives/1472)。

## javascript スキームによる脆弱性の発生

- `a` タグ の `href` 属性、`img` タグや `frame` タグ、`iframe` タグの `src` 属性などは、URL を属性値としている
- URL を外部から変更できる場合、URL として `javascript:JavaScript式` という形式（javascript スキーム）を指定することで、JS を起動できる

```tsx
export default function App() {
  const link = `javascript:alert("XSS攻撃")`;

  return (
    <div className="App">
      <h1>Hello, React</h1>
      <a href={link}>Reactの詳細ページ</a>
    </div>
  );
}
```

`<a href={link}>Reactの詳細ページ</a>` のリンクをクリックすると、`alert("XSS攻撃")` が実行されてしまう。

:::message
javascript スキームの問題は React 本体でも対策が進められている。
React16.9 からはデベロッパーツールの Console パネルに警告文を表示するようになっている。（2022 年 12 月時点）
:::

### 対策

- http/https スキームの URL しか指定できないようにする
- 先頭からユーザが決められる文字列を `href` や `src` に挿入しない
- CSP を設定する

## CSP による XSS 対策

### CSP とは

- ブラウザに対して、どのような外部リソースがウェブページで許可されるかを指示するための仕組み
- Web ページに適用されるセキュリティポリシーを定義するためのブラウザの機能
- CSP を用いることで、ブラウザが読み込み可能なリソース（JavaScript, CSS, Img など）をホワイトリストで制限することができる
- これにより、悪意あるリソースの読み込みを防ぐことができる

:::details 「ホワイトリスト」とは？
許可リストのこと。逆にブラックリストとは禁止リストのこと。
:::

CSP を設定するためには以下の 2 通りがある。

- Web サーバのレスポンスヘッダーに `Content-Security-Policy` を含ませる
- HTML の `<meta>` タグを使用して指定する

Web サーバのレスポンスヘッダーに含めてポリシーを定義するのがメジャー？

### Web サーバのレスポンスヘッダーに `Content-Security-Policy` を設定

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

#### 適用例

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

他のディレクティブに関しては、下記参照。
https://qiita.com/yuria-n/items/c50a1bc0ba51f6e33215
https://www.proactivedefense.jp/blog/blog-vulnerability-assessment/post-2179#index_id1

### HTML の `<meta>` タグを使用して指定する

- `<head>` セクションに `<meta>` タグを使用して、CSP を設定する
- `<meta>` タグを使った方法は、サーバーの設定にアクセスできない場合や、特定のページにのみポリシーを適用したい場合に便利

```html
<meta http-equiv="Content-Security-Policy" content="script-src 'self'" />
```

注意点として、**`<meta>` タグを使用して CSP を指定する場合、全てのディレクティブが使用できるわけではない**。
`frame-ancestors` や `report-uri` ディレクティブは使用できない。

### `<meta>` タグとレスポンスヘッダーのどちらで CSP 設定すべきか？

- 基本的には Web サーバのレスポンスヘッダーで設定すれば良いと思う
- `<meta>` タグでの設定は色々と制限があるため、サクッと設定したい場合のみ使用する感じで良さそう

### CSP を導入前にテストする

- CSP は性質上、ホワイトリスト形式
- よって、少し設定を間違えると、サイトが機能しなくなる恐れがある
- 元々適用していなかったサイトに CSP を適用させるのは難易度が高い
- そのため、適用前に**ブロックしないテスト専用の CSP**がある
- `Content-Security-Policy-Report-Only` ヘッダーは CSP の一種
- ポリシー違反があった場合に、実際にブロックはせず、違反を報告してくれる
- 既存サイトの CSP を設定・更新する際に、ポリシーの影響をモニタリングし、調整するために使える
- **`Content-Security-Policy-Report-Only` ヘッダは `<meta>` タグによる設定ができない**

#### 基本的な概念

- **レポートモード**:
  `Content-Security-Policy-Report-Only` ヘッダーを使用すると、ブラウザは設定されたポリシーに違反する行為をブロックせず、代わりに指定されたレポート URI に違反レポートを送信する。

- **デバッグ目的**:
  このモードは、新しいポリシーを導入する際のデバッグやテストに非常に役立つ。違反が発生してもユーザー体験に影響を与えることなく、ポリシーがどのように機能するかを理解しやすくなる。

- **段階的な導入**:
  CSP を初めて導入する場合や、既存のポリシーを大幅に変更する場合、`Report-Only` モードを使用して、予期しない問題が発生しないかを確認しながら段階的に導入することができる。

#### 使用方法

- HTTP レスポンスヘッダーとして設定する

  ```http
  Content-Security-Policy-Report-Only: [ポリシーディレクティブ]; report-uri [レポートURI];
  ```

- 例えば、以下のように設定することができる：
  ```http
  Content-Security-Policy-Report-Only: default-src 'self'; report-uri /csp-report-endpoint;
  ```
  この設定では、自ドメイン (`'self'`) からのリソースのみを許可し、ポリシー違反が発生した場合は `/csp-report-endpoint` にレポートを送信する

#### 注意点

- **レポートの収集**:
  レポート URI は、CSP 違反レポートを受け取るエンドポイントを指定する必要がある。このエンドポイントは違反レポートの収集と分析を行うための仕組みを備えている必要がある。

- **本番環境での使用**:
  テストやデバッグフェーズ後、問題が解決されたと確信したら、`Content-Security-Policy` ヘッダーに切り替えて、ポリシーを強制することが推奨される。

### CSP のデメリット

- CSP はブラウザが読み込み可能なリソースをホワイトリストで制限するもの
- それが故に、メンテナンスが大変
- 読み込みを許可するリソースのリストアップが大変
- 少し設定を間違えると、サイトが機能しなくなる恐れがある

## Next.js で CSP 設定

### Web サーバのレスポンスヘッダーに `Content-Security-Policy` を設定

https://zenn.dev/team_zenn/articles/introduced-csp-to-zenn

https://nextjs.org/docs/pages/building-your-application/configuring/content-security-policy

### HTML の `<meta>` タグを使用して指定する

https://zenn.dev/snaka/articles/e474f6125ce9ef#%E5%AE%9F%E8%A3%85%E4%BE%8B

## 参考リンク

https://qiita.com/kazzzzzz/items/897f8ed89ca36a0734de

https://azukiazusa.dev/blog/react-javascript-xss/

https://zenn.dev/nyazuki/articles/7b62a373c7e94e#csp-%E3%81%A7-xss-%E6%94%BB%E6%92%83%E5%AF%BE%E7%AD%96%E3%81%99%E3%82%8B

https://hackmd.io/@euxn23/ByfD97Ujv
