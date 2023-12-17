---
title: "同一オリジンポリシー（Same-Origin Policy）"
---

- Web セキュリティの重要なポリシーの一つ
- ラウザが異なるオリジン（クロスドメイン）のドキュメントやスクリプト間での相互作用を制限するために設計されている

## オリジン（Origin）とは？

ヤフーのサイトを例に説明する。

- オリジン (origin)：https://yahoo.co.jp:443
- ドメイン (domain) : yahoo.co.jp

ドメインとの違いは、プロトコルとポート番号を含んでいるという点。

`origin == protocol + domain + port`

ちなみに、https のポート番号は「443」、http のポート番号は「80」。

## AJAX リクエスト

クライアントは同じオリジンのサーバに対してのみリソースのリクエストを送信することができ、別のオリジンにはリクエストできない。

![](https://storage.googleapis.com/zenn-user-upload/0708167567b9-20231217.png)

![](https://storage.googleapis.com/zenn-user-upload/a6a01e04cb6b-20231217.png)

これにより、ユーザーの知らないうちに別のサイトに対してリクエストを送ること（例えば、CSRF 攻撃）を防ぐことができる。

## iframe による Web ページの読み込み

![](https://storage.googleapis.com/zenn-user-upload/1015ef29ecce-20231217.png)

オリジン A（`https://www.example.com`）のウェブページが、オリジン B（`https://www.another-site.com`）のウェブページの内容を読み取ろうとする。

```js
// オリジンAのスクリプト
let iframe = document.createElement("iframe");
iframe.src = "https://www.another-site.com";
document.body.appendChild(iframe);

// オリジンBの内容を読み取ろうとする
iframe.onload = function () {
  try {
    let contents = iframe.contentDocument.body.innerHTML;
    console.log(contents);
  } catch (e) {
    console.error("読み取り失敗:", e);
  }
};
```

オリジン A のページに含まれる JavaScript が、オリジン B のウェブページの内容（例えば、HTML 要素、テキストなど）を直接読み取ろうとすると、同一オリジンポリシーによりブロックされる。
これにより、悪意のあるスクリプトが他のサイトの情報を盗み出すことを防ぐ。

## クッキーへのアクセス

オリジン A（`https://www.example.com`）のスクリプトが、オリジン B（`https://www.another-site.com`）のクッキーにアクセスしようとする。

```js
// オリジンAのスクリプト
let iframe = document.createElement("iframe");
iframe.src = "https://www.another-site.com";
document.body.appendChild(iframe);

// オリジンBのクッキーを読み取ろうとする
iframe.onload = function () {
  try {
    let cookies = iframe.contentWindow.document.cookie;
    console.log(cookies);
  } catch (e) {
    console.error("クッキー読み取り失敗:", e);
  }
};
```

異なるオリジンの iframe 内のクッキーにアクセスしようとすると、同一オリジンポリシーによりエラーが発生する。
これにより、ユーザーのセッション情報や認証情報などの機密データが保護される。
XSS 攻撃によるデータ漏洩を防ぐために重要。

## なぜ同一オリジンポリシーが存在するのか？

例として、Web サーバにリクエストを送った時のことを考える。
自社で API と Web ページを同一オリジンで開発している場合は以下のような構成になる。

![](https://storage.googleapis.com/zenn-user-upload/f57398b1feb7-20231217.png)

ここでもし、自社 API サーバに偽装サイトからリクエストが送信されたらどうなるか？

![](https://storage.googleapis.com/zenn-user-upload/168f51a9364d-20231217.png)

上記のように `dummy.com` から `example.com` へのリクエストが制限されていない場合、次のようなことが出来てしまう。

- 不正なリクエストを送信してサーバに不具合を起こさせる
- 顧客に本物の Web サイトと偽って偽物の Web サイトを表示し、顧客が入力した情報をもとに `example.com` へリクエストを送り、レスポンスデータを盗む

同一オリジンポリシーにより、別のオリジンへのアクセスに制限をかけることで、このようなセキュリティの問題を解決している。
以下のような貧弱性を防ぐことができる。

- XSS (Cross Site Scripting)
- CSRF (Cross-Site Request Forgeries)

## JavaScript 以外のクロスドメインアクセス

- JavaScript には同一オリジンポリシーによりクロスドメインアクセスが厳しく制限されている
- JavaScript 以外のブラウザ機能で、以下のクロスドメインアクセスが許可されている

### frame 要素と iframe 要素

- iframe 要素と frame 要素はクロスドメインのアクセスができる
- しかし、JavaScript によってクロスドメインのドキュメントにアクセスすることは禁止されている

### img 要素

- img 要素の `src` 属性はクロスドメインの指定が可能
- その場合、画像に対するリクエストには画像のあるホストに対するクッキーが付与されるので、罠サイトに「認証の必要な画像」を表示させることも可能
- HTML5 の canvas 要素を用いると、JavaScript から画像の中身にアクセスできる
- しかし、同一オリジンポリシーおよび CORS の制約を受けるので、クロスドメインの画像参照が問題になることはない

### script 要素

- script 要素に `src` 属性を指定すると、他のサイトから JavaScript を読み込める

![](https://storage.googleapis.com/zenn-user-upload/b4cafc76906c-20231217.png)

- JavaScript のソースコードはサイト B に存在するが、読み込まれた JavaScript は、サイト A のドメインで動作する
- そのため、JavaScript が `document.cookie` にアクセスすると、サイト A 上のクッキーが取得できる
- サイト B に置かれた JavaScript を取得するリクエストでは、サイト B に対するクッキーが送信される
- そのため、利用者のサイト B でのログイン状態によって、サイト B に置かれた JavaScript のソースコードが変化し、その変化がサイト A に影響を与える場合がある

### CSS

- CSS はクロスドメインでの読み込みが可能
- HTML の `link` 要素のほか、CSS 内から `@import`、JavaScript から `addImport` メソッドが使える

### form 要素の action 属性

- form 要素の `action` 属性もクロスドメインの指定が可能
- form の送信（submit）は JavaScript から常に（`action` 先がクロスドメインであっても）操作できる
- form 要素の仕様を悪用した攻撃手法が CSRF 攻撃
- CSRF 攻撃では、ユーザの意図しない form を送信させられ、アプリケーションの機能が勝手に実行される
