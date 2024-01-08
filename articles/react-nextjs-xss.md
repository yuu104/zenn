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
よって、XSS を引き起こす可能性がある。

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
- CSP を設定する

## javascript スキームによる脆弱性の発生

- `a` タグ の `href` 属性、`img` タグや `frame` タグ、`iframe` タグの `src` 属性などは、URL を属性値としている
- URL を外部から変更できる場合、URL として `javascript:JavaScript式` という形式（javascript スキーム）で、JS を起動できる

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

### 対策

- http/https スキームの URL しか指定できないようにする
- 先頭からユーザが決められる文字列を `href` や `src` に挿入しない
- CSP を設定する

## CSP による XSS 対策

### CSP とは

- ブラウザに対して、どのような外部リソースがウェブページで許可されるかを指示するための仕組み
- Web ページに適用されるセキュリティポリシーを定義するためのブラウザの機能
- これにより、悪意あるリソースの読み込みを防ぐことができる

CSP を設定するためには以下の 2 通りがある。

- Web サーバのレスポンスヘッダーに `Content-Security-Policy` を含ませる
- HTML の `<meta>` タグを使用して指定する

Web サーバのレスポンスヘッダーに含めてポリシーを定義するのがメジャー？

### Web サーバのレスポンスヘッダーに `Content-Security-Policy` を含ませる

以下のように設定する。

```
Content-Security-Policy: {policy}
```

- `policy` の箇所には、適用したい CSP を表す「ディレクティブ」から構成される文字列が入る
- ディレクティブは、特定の種類のリソースに対するポリシーを定義する
- 例えば、
  - `script-src` : どのスクリプトが実行されるかを制御する
  - `img-src` : どの画像が表示されるかを制御する
  - `style-src` : どのスタイルシートが適用されるかを制御する
- XSS に対する設定を明示的に行う場合、`script-scr` を定義する

#### 適用例

サイト管理者が、すべてのコンテンツをサイト自身のドメイン（サブドメインを除く）から取得させたい場合。

```
Content-Security-Policy: default-src 'self'
```

## 参考リンク

https://qiita.com/kazzzzzz/items/897f8ed89ca36a0734de
