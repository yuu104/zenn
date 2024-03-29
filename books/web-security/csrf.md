---
title: "CSRF（クロスサイト・リクエストフォージェリ）"
---

## CSRF とは

- ユーザが信頼しているサイトに対して、外部から不正なリクエストを送信する攻撃手法
- ユーザのブラウザからリクエストが発生し、「重要な処理」を実行させられる

:::details 重要な処理とは？
ログインした利用者のアカウントにより実行される、取り消しできないような処理。
例えば、

- 利用者のクレジットカードでの決済
- 利用者の口座からの送金
- メール送信
- パスワードやメールアドレスの変更

:::

- CSRF 脆弱性の影響は、アプリケーションの「重要な処理」の悪用に限られる
- Web API でも CSRF 脆弱性が混入する場合がある

## 攻撃手法と影響

![](https://storage.googleapis.com/zenn-user-upload/f445dd71bb9d-20240131.png)
*https://www.ipa.go.jp/security/vuln/websecurity-HTML-1_6.html*

攻撃の理解にあたっては、特に以下について注目するとよい

- 対象の Web サイトのユーザが、正規の手順でログイン済であることを前提とする
  - **ログイン済 ≒ ユーザの Web ブラウザにセッション Cookie が発行されている**ことがポイント
    - したがって、Web サイトへのユーザーとしてのログイン有無自体は関係がない
- 対象の Web サイトが、設計上意図しない更新操作を受け付けてしまうことで攻撃が成立する
  - **受け付けてしまう ≒HTTP リクエストがバックエンドで処理される**ことがポイント
    - したがって、HTTP リクエストに対するレスポンスがどのような結果となったかは関係がない
    - Web ブラウザに不正なレスポンスが表示されることで発生する攻撃は XSS のような別の攻撃として分類される

## 攻撃の具体例

CSRF 攻撃の一般的な例を説明する。
この例では、オンラインバンキングサイトにログインしているユーザーを対象とし、攻撃者がユーザーの銀行口座から自分の口座に不正にお金を振り込むシナリオを想定する。

1. **ターゲットのログイン**
   - ユーザー（被害者）が銀行のウェブサイトにログインし、セッションが開始される
   - セッション ID はクッキーに保存される
2. **攻撃者の準備**
   - 攻撃者は、銀行のサイトで送金を行うリクエストを模倣した HTML フォームを作成する
   - このフォームは、攻撃者の口座にお金を送るように設定されている
   - 例として、フォームの内容は以下の通り
     ```html
     <form action="https://bank.example.com/transfer" method="POST">
       <input type="hidden" name="amount" value="1000" />
       <input type="hidden" name="account" value="攻撃者の口座番号" />
     </form>
     ```
   - 攻撃者が用意したフォームは、ターゲットとなるサイト（この場合は銀行のサイト）に実際に存在するフォームの構造を模倣している
   - CSRF 攻撃では、攻撃者はターゲットのサイト上で行われる通常のリクエストの形式を知っている必要がある
3. **攻撃者のリンク配布**
   - このフォームを含むウェブページを攻撃者が作成し、メールやソーシャルメディアを通じてターゲットにリンクを送る
4. **ユーザーのクリック**
   - ユーザーがそのリンクをクリックし、ページを開くと、JavaScript を使用して自動的にフォームを送信する
5. **不正なリクエストの送信**
   - ユーザーのブラウザは、フォームのデータと共にユーザーのセッションクッキーも銀行のサーバーに送信する
   - 銀行のサーバーはこのリクエストを正規のユーザーのリクエストと誤認識する
6. **不正な取引の実行**
   - 銀行のサイトはリクエストを処理し、ユーザーの口座から攻撃者の口座に 1000 ドルを振り込む

注目ポイントは、

- この攻撃はユーザーが銀行のサイトにログインしている間にのみ機能する
- 攻撃者はユーザーのセッション ID やパスワードを知る必要はない
- ユーザーがリンクをクリックするだけで攻撃が実行される
- 攻撃によってパスワードが変更される場合は、情報漏洩も...

## CSRF と XSS の比較

![](https://storage.googleapis.com/zenn-user-upload/51a7a7a735aa-20240131.png)

- CSRF は ③ のリクエストに対するサーバ側の処理を悪用するもの
  - 悪用内容はサーバ側で用意された処理に限定される
- XSS では、④ のレスポンス内容に含まれる、悪意あるスクリプトがブラウザ上で実行されることにより攻撃される
  - ブラウザ上でできることは何でも可能
- 攻撃の広範さという点では XSS の脅威の方が大きい

## 脆弱性が生まれる原因

CSRF 脆弱性が生まれる背景として、以下の Web の性質がある。

1. **`form` 要素の `action` 属性にはどのドメインの URL でも指定できる**
   - `form` の `action` 属性には、リクエストを送信するサーバーの URL を指定する
   - この URL は、現在のドメインと異なる（外部の）ドメインでも構わない
   - この性質を悪用すると、攻撃者は自分のコントロール下にあるサイトから、正規のサイトへのリクエストを送信できる
2. **クッキーに保管されたセッション ID は、対象サイトに自動的に送信される**
   - ユーザーがサイトにログインすると、その認証情報（例えばセッション ID）はクッキーに保存される
   - ブラウザは同じサイトへの後続のリクエストに対して、これらのクッキーを自動的に付加して送信する
   - これによりユーザーは再ログインすることなくサイトを利用できる
   - しかし、これが CSRF の脆弱性を生む
   - ユーザーが攻撃者の準備したページを訪れた際に、そのページから正規のサイトにリクエストが送られると、ユーザーのブラウザは自動的にそのユーザーのセッションクッキーをリクエストと共に送信する
   - 正規のサイトはこのリクエストを正当なユーザーからのものと誤認し、攻撃者の意図する不正な行動を実行してしまう

これらの Web の性質が組み合わさることで、CSRF 攻撃が可能になり、サイトはこの種の攻撃からユーザーを守るために追加のセキュリティ措置を講じる必要がある。

## 正常なリクエストと CSRF 攻撃によるリクエストはほとんど変わらない

以下は、正常なリクエストと CSRF 攻撃によるリクエスト。

**正常なリクエスト**

```http
POST /transfer HTTP/1.1
Host: bank.example.com
Cookie: sessionid=123456789
Referer: https://bank.example.com/transfer
Content-Type: application/x-www-form-urlencoded
Content-Length: ...

amount=1000&account=recipient_account_number
```

**CSRF 攻撃によるリクエスト**

```http
POST /transfer HTTP/1.1
Host: bank.example.com
Cookie: sessionid=123456789
Referer: https://evil.example.com/attack-page
Content-Type: application/x-www-form-urlencoded
Content-Length: ...

amount=1000&account=attacker_account_number
```

- 両者を比較すると、HTTP リクエストの内容はほとんど同じ
- `Referer` ヘッダのみ異なる
- `Referer` 意外はクッキーも含めて同じ
- よって、アプリケーション側で `Referer` ヘッダをチェックしない限り、両者は区別できない

## 対策の概要

**HTTP リクエストがリクエストが正規利用者の意図したものであることを確認する**必要がある。
そのため、対策としては、以下 2 点を実施する。

- CSRF 対策の必要なページを区別する
- 正規利用者の意図したリクエストを確認できるよう実装する

### CSRF 対策の必要なページを区別する

- CSRF 対策は、全てのページについて実施するものではない
- 対策の必要がないページの方が多い
- 他サイトから勝手に実行されると困るページに対し、CSRF 対策を施す
  - EC サイトの場合、物品購入や、パスワード変更、個人情報編集などの確定画面

![](https://storage.googleapis.com/zenn-user-upload/2ce5cc4eb494-20240201.png)

開発プロセスの中では、以下のようにする。

- 要件定義工程で機能一覧を作成し、CSRF 対策の必要な機能にマークする
- 基本設計工程で画面遷移図を作成し、CSRF 対策の必要なページにマークする
- 開発工程で CSRF 対策を作り込む

### 正規利用者の意図したリクエストであることを確認する

![](https://storage.googleapis.com/zenn-user-upload/b0fd341c4783-20240201.png)

リクエストの判定手法としては、以下に示すように様々ある。

## 秘密情報（CSRF トークン）を利用した対策

- CSRF 対策が必要なページに対して、第三者が知り得ないトークンを要求をするようにする
- これにより、不正なリクエストを送信させられても、アプリケーション側で判別できる
- 最近はアプリケーションフレームワーク側でトークンの生成とチェック機能を持つものが多い
- トークンは第三者に推測されにくい乱数（暗号論的擬似乱数生成器）を用いて生成する
- **利用している Web フレームワークが提供する CSRF 保護機構が存在する場合、独自実装はせずそちらを利用したほうがよい**

![](https://storage.googleapis.com/zenn-user-upload/128b84e6ea9a-20240201.png)

トークンを使用した CSRF 対策の流れは以下になる。

1. **トークンの生成**
   - サーバは、ユーザがセッションを開始する（例：ログインする）たびに一意でランダムな CSRF トークンを生成する
2. **トークンのクライアントへの送信**

   - 生成されたトークンは、ユーザーのブラウザに送信される

   :::details 送信方法について

   #### 1. HTML フォームの隠しフィールド

   - **実装方法**
     - サーバはレスポンスとして HTML ページを送信する際に、フォーム内に以下のようにトークンを埋め込む
       ```html
       <input type="hidden" name="csrf_token" value="トークン値" />
       ```
     - トークンはユーザにとっては見える必要のない情報
     - よって、`type=hidden` により非表示にする
   - **使用ケース**
     - 主にユーザが直接操作を伴う（例：送信ボタンをクリックする）標準的なフォーム送信に使用される
   - **セキュリティ面**
     - トークンはフォーム送信時にサーバーに送り返されるため、ユーザーの意図しない外部サイトからのリクエストを防ぐことができる

   #### 2. HTTP レスポンスヘッダー

   - **実装方法**
     - サーバは HTTP レスポンスのヘッダーに CSRF トークンを含め、`Set-Cookie` ヘッダーやカスタムからのリクエストを防ぐことができる
   - **使用ケース**
     - API や Ajax ベースのアプリケーションでよく使用される
     - クライアントの JavaScript はこのヘッダーからトークンを読み取り、後続の Ajax リクエストで利用する
   - **セキュリティ面**
     - Ajax リクエストでの CSRF 対策に効果的だが、トークンが JavaScript からアクセス可能であるため、XSS のリスクに注意する必要がる

   #### 3. メタタグ

   - **実装方法**
     - サーバーは HTML ページの `<head>` セクションに `<meta name="csrf-token" content="トークン値">` としてトークンを埋め込む
   - **使用ケース**
     - 主にシングルページアプリケーション（SPA）で利用され、JavaScript がメタタグからトークンを取得して Ajax リクエストに添付する
   - **セキュリティ面**
     - JavaScript から容易にアクセスできるため、XSS 攻撃によるトークン漏洩のリスクが存在する

   #### 3. クッキー

   - **実装方法**
     - サーバーはクッキーに CSRF トークンをセットし、ブラウザに保存させる
     - このクッキーは、後続のリクエストでサーバーに自動的に送信される
   - **使用ケース**
     - クッキーを使用してトークンを管理する方法は、クライアント側の実装が簡単になるケースで利用される
   - **セキュリティ面**
     - クッキーによるトークンの管理は、CSRF 攻撃に対して本質的に脆弱ではないが、XSS 攻撃によるトークンの盗難には注意が必要

   #### 4. JavaScript API を通じて

   - **実装方法**
     - サーバーは CSRF トークンを取得するための専用の API エンドポイントを提供し、クライアントはこの API を呼び出してトークンを取得する
   - **使用ケース**
     - API 中心のアプリケーションや、JavaScript ヘビーなウェブアプリケーションで利用される
   - **セキュリティ面**
     - この方法も XSS 攻撃に対するセキュリティリスクを持つ - トークンが JavaScript からアクセス可能であるため、厳格な XSS 対策が必要

   :::

3. **クライアント側でのトークンの保持**
   - ユーザのブラウザは、このトークンを保持する
   - フォームやバックエンド API にリクエストを送信する際、トークンもリクエストに含める
   - Ajax の場合は HTTP ヘッダーやボディにトークンを添付する
4. **サーバでのトークン検証**
   - サーバーは受信したリクエスト内の CSRF トークンを、ユーザーのセッションに関連付けられたトークンと照合する
   - トークンが一致する場合、リクエストは合法と見なされ処理される
   - トークンが一致しないか、存在しない場合はリクエストは拒否され、CSRF 攻撃の可能性があると見なされる
5. **トークンの再発行**
   - セキュリティをさらに強化するため、サーバーは重要なトランザクション後にトークンを再発行することがある

## Double Submit Cookie（二重送信 Cookie）を使用した CSRF 対策

- CSRF トークンによる対策は、サーバ側でトークンを管理する必要がある
- しかし、サーバ側でトークンを保持せず、ブラウザの Cookie にトークンを保持させることでブラウザに CSRF トークンの管理を委譲できる

手順は以下の通り。

1. **トークンの生成**
   - サーバ側で CSRF トークンを生成する
2. **トークンの送信**
   - 生成した CSRF トークンを含めた Cookie を発行し、クライアントに送信する
   - この時、`HttpOnly` 属性は付与しない
3. **フォーム（HTTP リクエスト）の送信**
   - ユーザがフォームを送信するとき、Cookie にある CSRF トークンを JavaScript を使用して取得する
   - 取得した CSRF トークンと Cookie にある CSRF トークンを含めてサーバにリクエストを送信する
   - JavaScript により Cookie から取得したトークンはリクエストヘッダーやリクエストボディに含めて送信する
4. **サーバ側でトークンの検証**
   - サーバは、リクエストと共に送られてきたトークンと、Cookie 内のトークンを比較する
   - トークンが一致すれば、リクエストは正当なものとして処理される

![](https://storage.googleapis.com/zenn-user-upload/2af33504960a-20240204.png)

- 攻撃者は被害者のブラウザを利用して悪意のあるリクエストを行うが、被害者の Cookie にはアクセスできないため、正しいトークンをリクエストに含めることができない
- Double Submit Cookie 方式では、リクエストに含めるトークンと Cookie のトークンが一致する必要があるため、攻撃者は正しいトークンを知ることができず、CSRF 攻撃を成功させることが困難になる

## SameSite Cookie を使用した CSRF 対策

- SameSite は `Set-Cookie` HTTP レスポンスヘッダの属性
- Cookie の送信を制御するための機能で、Cookie の送信を同一サイト（samesite）に制限することができる
- 「同一サイト」とは、eTLD+1 が同一の URL
  :::details eTLD+1 とは？

  1. **TLD（トップレベルドメイン）**

     - ドメイン名の再右側に位置し、ドメイン階層の最上位を表す
     - 例：`.com`、`.org`、`.jp` など

  2. **eTLD（有効なトップレベルドメイン）**

     - TLD に加えて、国や地域、組織を特定する追加の階層（サブドメイン）を含む
     - そのような階層が含まれている場合、eTLD は TLD+サブドメインとなる
     - 例：`.co.jp`、`.ac.uk`

  3. **eTLD+1**
     - eTLD にさらに一つ下の階層を加えたもの
     - 具体的な Web サイトやエンティティを識別するためのドメイン名
     - 例：`www.example.co.uk` の場合、eTLD は `.co.uk` で、eTLD+1 は `example.co.uk` になる

  :::

- CSRF はログイン後のページで行われる重要な処理に対して、罠サイト（クロスサイト）経由でログインユーザの Cookie を使用してリクエストを送信する攻撃
- よって、Cookie を送信しなければ、多くの CSRF 攻撃を防げる

```http
Set-Cookie: session=0123456789abcdef; HttpOnly; Secure; SameSite=Lax;
```

`SameSite` 属性に設定可能な値は以下の通り。

| 属性値 | 値の意味                                                                                                                                                                      |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Strict | クロスサイトから送信するリクエストには Cookie を付与しない                                                                                                                    |
| Lax    | URL が変わるような画面遷移かつ GET メソッドを使ったリクエストであれば、クロスサイトでも Cookie を送る。他の方法を使ったクロスサイトからのリクエストには Cookie を付与しない。 |
| None   | サイトに関係なく、すべてのリクエストで Cookie を送信する                                                                                                                      |

- `Strict` を設定したほうがセキュリティを強化できる
- しかし、他の Web アプリケーションのリンクから遷移したときにも Cookie が送信されないため、一度ログインした Web アプリケーションでも未ログイン状態になる
- `Lax` は URL が変わるような画面遷移かつ GET メソッドであれば、クロスサイトでも Cookie を送信する
- よって、他の Web アプリケーションのリンクから画面遷移してもログイン状態を保ことができる
- Google Chrome などはデフォルトで `Lax` が設定されている
- しかし、`SameSite` が指定されていない Cookie は発行されてから 2 分経たないと `Lax` にならない仕様になっている
- よって、その 2 分間は CSRF 攻撃を受ける可能性がある
- そのため、`SameSite` は指定しておいた方が良い

## Origin ヘッダを使用した CSRF 対策

- `Origin` ヘッダは、ブラウザがクロスオリジンの HTTP リクエストを行う際に使用される HTTP ヘッダ
- このヘッダは、リクエストが発行された元のオリジンを示す

CSRF 攻撃を防ぐために、`Origin` ヘッダを利用する方法は以下の通り。

1. **ヘッダの存在と正確性の確認**
   - サーバーは、受信したリクエストに `Origin` ヘッダが存在するかを確認する
   - クロスオリジンのリクエストでは、ブラウザは通常このヘッダを自動的に付加する
2. **オリジンの検証**
   - サーバーは、`Origin` ヘッダに含まれるオリジンが許可されたオリジンと一致するかどうかを確認する
3. **不一致時のリクエスト拒否**
   - `Origin` ヘッダが存在しない、またはオリジンが一致しない場合、サーバーはリクエストを拒否する
   - これにより、攻撃者がユーザーを騙して別のオリジンから不正なリクエストを送信する CSRF 攻撃を防ぐことができる

Express.js サーバで `Origin` ヘッダの検証によるリクエスト元の判別例は以下の通り。

```js
const allowedOrigin = "https://site.example";

app.post("/remit", (req, res) => {
  // `Origin`ヘッダがない場合、または同一オリジンではない場合はエラーにする
  if (!req.headers.origin || req.headers.origin !== allowedOrigin) {
    res.status(403);
    res.send("許可されていないリクエストです");
    return;
  }
  // 途中省略
});
```

Origin ヘッダを使用した CSRF 対策の利点として、簡単に実装できる点がある。
CSRF トークンと比較して、追加のクライアントサイドのロジックやサーバー側の状態管理が不要。

## パスワード再入力による CSRF 対策

正規利用者による正常なリクエストであることを確認する方法として利用できる。
パスワード再入力は、CSRF 対策意外に、以下の目的でも利用される。

- 物品の購入などに先立って、正規利用者であることを確認する
- 共有 PC で別人が操作している状況などがなく、本当に正規の利用者であることを確認する

よって、**対象ページが上記の要件を満たしている場合は、パスワード再入力による CSRF 対策を行うと良い**。
逆に、それ以外のページ（ログアウト処理など）でパスワード再入力を求めると、煩雑で使いにくい UX になる。

## Referer ヘッダのチェックによる CSRF 対策

- 正規のリクエストと CSRF 攻撃によるリクエストでは、`Referer` ヘッダのみが異なる
- 正規のリクエストでは、実行画面の 1 つ手前のページに対する URL が `Referer` としてセットされているはずなので、それを確認する
- しかし、欠点として、この対策法を採用すると、ブラウザやパーソナルファイアウォール等の設定で `Referer` を送信しないようにしている利用者が、そのサイトを利用できなくなる不都合が生じる可能性がある

## CSRF 攻撃への保険的対策

- **「重要な処理」の実行後に、対象利用者の登録済みメールアドレスに対して、処理内容の通知メールを送信する**
- メール通知では、CSRF 攻撃を防ぐことはできない
- しかし、万一 CSRF 攻撃を受けた際に利用者が早期に気づくことができ、被害を最小限にとどめることができるかもしれない
- 通知メールを送信すると、CSRF 攻撃だけでなく XSS 攻撃などで成りすましされた場合でも「重要な処理」が悪用されたことを早期に気づける
- ただし、メールには重要な情報を含まず、「重要な処理」が実行されたことのみを通知するようにする
