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

- Content Security Policy（CSP）は、XSS など不正なコードを埋め込むインジェクション攻撃を検知して被害の発生を防ぐための**ブラウザの機能**
- ブラウザに対して、どのような外部リソースがウェブページで許可されるかを指示する
- CSP を用いることで、ブラウザが読み込み可能なリソース（JavaScript, CSS, Img など）をホワイトリストで制限することができる
- これにより、悪意あるリソースの読み込みを防ぐことができる

### Next.js で CSP 設定

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
