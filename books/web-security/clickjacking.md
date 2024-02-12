---
title: "クリックジャッキング"
---

## クリックジャッキングとは？

- ユーザの意図とは異なるボタンやリンクをクリックさせることで、意図しない処理を実行させる攻撃
- 攻撃対象の画面上で特定のボタンなどを利用者にクリックさせることができれば、利用者の意図しない投稿やサイトの設定変更ができる場合がある
- クリックジャッキングは、`iframe` と CSS を巧妙に利用することで、透明にした攻撃対象ページと罠サイトを重ね合わせ、利用者が気づかないうちに攻撃対象サイトでのクリックを誘導する
- 利用者にボタンなどをクリックさせることで「重要な処理」を実行させることはできるが、その結果の画面内容を攻撃者が知ることはできない
- CSRF に似ている

## クリックジャッキングの仕組み

クリックジャッキング攻撃は、`iframe` を使用したクロスオリジンのページ埋め込みとユーザによるクリックによって成立する。
具体的な手順は以下の通り。

1. 攻撃対象の Web アプリケーションのページを `iframe` を使用して罠サイト上に重ねる
2. `iframe` に対し、CSS を使用して透明にし、ユーザには見えないようにする
3. 攻撃対象のページ上にある重要な処理を行うボタンが罠サイト上のボタンの位置と重なるように CSS で調整する
4. 罠サイトにアクセスしたユーザが罠サイト上のボタンをクリックするように誘導する
5. ユーザは罠サイト上のボタンをクリックしたつもりでも、実際は透明に重ねられた攻撃対象のページ上のボタンがクリックされる

- 例えば、ログイン済みの管理者だけが操作できる管理画面を考える
- 画面上にはデータを削除するボタンが配置されており、攻撃者はこのボタンをクリックさせたい
- 管理者に意図しない削除ボタンのクリックをさせるために、攻撃者は透明な `iframe` を使って管理画面に重ねた罠サイトを用意する
- また、管理画面の削除ボタンと同じ位置に罠サイトにもボタンが配置されている

![](https://storage.googleapis.com/zenn-user-upload/39a7d5e607be-20240210.png)
_罠サイトの画面上に透明な `iframe` を配置する_

- 罠サイトの上に管理画面が重ねられている
- しかし、透明な `iframe` を使用しているため管理者ユーザには罠サイトしか見えない

![](https://storage.googleapis.com/zenn-user-upload/a57145fe45cd-20240210.png)
_ユーザに見えている画面_

- しかし、ユーザは誘導されて「ギフト券プレゼント」ボタンをクリックしたとき、実際は透明な状態で上に重なっている管理画面の削除ボタンをクリックしてしまう

![](https://storage.googleapis.com/zenn-user-upload/3d2f9cd2832e-20240210.png)
_実際にクリックされる画面_

クリックジャッキングを成立させるためには以下のように透明な `iframe` に攻撃対象のページを読み込ませる。

```html
<!DOCTYPE html>
<html>
  <head>
    <title>クリックジャッキング</title>
    <style>
      /* iframeを透明にしてこのページの上に重ねる */
      #frm {
        opacity: 0;
        position: absolute;
        z-index: 1;
        top: 100;
        left: 200;
      }
    </style>
  </head>
  <body>
    <!-- 割愛するが、ユーザを騙す内容が書かれている -->

    <button>ギフト券プレゼント</button>

    <!-- 攻撃対象の画面をiframeで読み込み -->
    <iframe id="frm" src="http://site.example:3000/admin.html"></iframe>
  </body>
</html>
```

- `<style>` の中で、`<iframe>` に対して `opacity: 0` を設定し、透明にしている
- `position: absolute` や `z-index: 1` などで罠サイト上に `<iframe>` を重ねて配置している
- さらに、クリックさせたいボタンと罠サイトのボタンを同じ位置に配置するように `top` や `left` で `<iframe>` の位置を調整している

## クリックジャッキングの対策

- **`iframe` などのフレーム内にページを埋め込むことを制限する**
- フレーム内への埋め込みを制限するためには、レスポンスに `X-Frame-Options` ヘッダまたは `frame-ancestors` ディレクティブを使った CSP ヘッダを含める

### X-Frame-Options

`X-Frame-Options` ヘッダを付与されたページはフレーム内への埋め込みが制限される。
`X-Frame-Options` ヘッダは次のように指定できる。

- **`X-Frame-Options: DENY`**
  - すべてのオリジンに対してフレーム内への埋め込みを禁止する
- **`X-Frame-Options: SAMEORIGIN`**
  - 同一オリジンに対してフレーム内への埋め込みを許可する
  - クロスオリジンのフレーム内への埋め込みは禁止する
- **`X-Frame-Options: ALLOW-FROM uri`**
  - `ALLOW-FROM` の後に続く `uri` の箇所に、指定したオリジンに対してフレーム内への埋め込みを許可する
  - `uri` の部分には `https://site.example` のような URI を指定する
  - ただし、`ALLOW-FROM` をサポートしていないブラウザがあったり、この機能自体にバグがあったりする
  - よって、許可するオリジンを指定したい場合は、CSP の `frame-ancestors` を利用したほうがよい

## CSP frame-ancestors

CSP の `frame-ancestors` ディラクティブも `X-Frame-Options` と同じく、フレーム内へのページ埋め込みを制限する。
ディレクティブは次のように指定できる。

- **`Content-Security-Policy: frame-ancestors 'none'`**
  - `X-Frame-Options: DENY` と同じ
  - すべてのオリジンに対してフレーム内への埋め込みを禁止する
- **`Content-Security-Policy: frame-ancestors 'self'`**
  - `X-Frame-Options: SAMEORIGIN` と同じ
  - 同一オリジンに対してフレーム内への埋め込みを許可する
  - クロスオリジンのフレーム内への埋め込みは禁止する
- **`Content-Security-Policy: frame-ancestors uri`**

  - `X-Frame-Options: ALLOW-FROM uri` と同じ
  - 指定したオリジンに対してフレーム内への埋め込みを許可する

- `frame-ancestors: site.example` のようにスキームを指定しないこともできる
- `frameancestorshttps://*.site.example` のように `*` を使用して、文字列の部分一致を指定できる
- `frameancestors 'self' https://*.site.exapmlehttps://example.com` のように複数のオリジンを指定できる

## 脆弱性が生まれる原因

- アプリケーションのバグが原因ではない
- HTML の仕様を巧妙に悪用した攻撃

## 保険的対策

- **「重要な処理」の実行後に、登録済みメールアドレスに通知メールを送信する**
- CSRF と同じ
- これでクリックジャッキング攻撃を防ぐことはできない
- しかし、万一クリックジャッキング攻撃を受けた際に利用者が早期に気づくことができ、被害を最小限にとどめることができる可能性がある

## まとめ

![](https://storage.googleapis.com/zenn-user-upload/d57e2460e551-20240210.png)
