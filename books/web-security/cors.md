---
title: "CORS（Cross-Origin Resource Sharing）"
---

## CORS とは？

> あるオリジンで動いている Web アプリケーションに対して、追加の HTTP ヘッダーを使用して別のオリジンのサーバへのアクセスをオリジン間 HTTP リクエストによって許可できる仕組み

- 日本語で表すと「クロスオリジン間リソース共有」
- つまり、異なるオリジン間（クロスオリジン）でリソースを共有するためのメカニズム

### 読み方

- コルス or シーオーアールエス
- Cross-Origin Resource Sharing の略
- オリジン間リソース共有とも言う

## CORS の必要性

通常、ブラウザは同一オリジンポリシーに基づき、異なるオリジンのリソースへのアクセスを制限する。
クライアントとサーバのオリジンが異なる場合はどうすれば良いのか？
この時に役立つのが CORS で、CORS を用いると、クライアントとは異なるオリジンにリクエストを送る場合、そのリクエストが許可されていることをサーバに一度確認してからでないと POST などの HTTP リクエストを送ることができなくなる。

![](https://storage.googleapis.com/zenn-user-upload/1b103ea58de0-20231217.png)

上記の図だと `domain-a.com` サーバへのリクエストは同一オリジンであるためリクエスト可能だが、`domain-b.com` サーバへのリクエストは CORS によりリクエストを許可してあげる必要がある。

## CORS の仕組み

- XML や fetch を使用してクロスオリジンへのリクエストを送信することは、同一オリジンポリシーによって禁止されている
- 具体的には、**クロスオリジンから受信したレスポンスのリソースへのアクセスが禁止されている**
- しかし、レスポンスに付与されている一連の HTTP ヘッダによって、サーバからアクセスの許可が与えられているリソースへはアクセスできる
- そのヘッダにはアクセスを許可するリクエスト条件が記載されており、条件を満たしているリクエストであれば、ブラウザは受信したリソースへ JavaScript を使用してアクセスすることを許可する
- 条件に一致しなければ、ブラウザはリソースを JavaScript で取り扱うことを禁止し、レスポンスを破棄する

![](https://storage.googleapis.com/zenn-user-upload/9ca6918ad07c-20240203.png)

## クロスオリジンリクエストの流れ

クロスオリジンリクエストには Simple Request（単純リクエスト）と Preflight Request （プリフライトリクエスト）の 2 種類が存在する。

### Simple Request（単純リクエスト）

送信するリクエストが**以下の全ての条件を満たす**場合は、単純リクエストとなる。

1. リクエストの HTTP メソッドが**GET**,**HEAD**,**POST**のいずれかである。
2. 以下のヘッダのみが設定されている。

   - `Connection`
   - `User-Agent`
   - `Accept`
   - `Accept-Language`
   - `Content-Language`
   - `Content-Type`(**但し、下記の条件を満たすもの**)

3. Content-Type ヘッダーが下記のいずれかである。

   - `application/x-www-form-urlencoded`
   - `multipart/form-data`
   - `text/plain`

4. リクエストに使用されるどの XMLHttpRequestUpload にもイベントリスナーが登録されていないこと
5. リクエストに `ReadableStream` オブジェクトが使用されていないこと

単純リクエストの流れは以下のようになる。

1. クライアント側からリクエスト

   - リクエストヘッダに `Origin` が含まれる
   - `Origin` はアクセス元のオリジン情報
   - `Origin` はクロスオリジンリクエストが発生した場合、自動でブラウザが追加する

   ```bash
   GET /app HTTP/1.1
   HOST: api.example.com
   Origin: https://example.com
   ```

2. サーバ側からのレスポンス

   - レスポンスヘッダの中に `Access-Control-Allow-Origin` が含まれる
   - `Access-Control-Allow-Origin` はサーバが許可するオリジンを入れる
   - `Access-Control-Allow-Origin` ヘッダに複数のオリジンを指定することはできない
   - ただし、`*` を指定することで、すべてのオリジンからのアクセスを許可できる

   アクセスが許可されていた場合、`api.example.com` からのレスポンスは下記のようになる

   ```bash
   200 OK
   Content-Type: text/html; charset=UTF-8
   Access-Control-Allow-Origin: https://example.com
   ```

3. クライアント側で `Origin` と `Access-Control-Allow-Origin` が一致していれば成功、一致していなければエラー

![](https://storage.googleapis.com/zenn-user-upload/10d83851d687-20231217.png)

- 単純リクエストは HTML フォームから送られるリクエストを基準として、HTML フォームの場合に比べて過度にリスクが増加しない範囲で条件が選択されている
- HTML フォームはもともと異なるサイト（オリジン）に対してリクエストを無条件に送信できる
- そのため、HTML フォームで送れる程度に制限しておけば、XMLHttpRequest でクロスオリジンにリクエストを送信しても、リスクはそれほど変わらないと考えられる

### Preflight Request（プリフライトリクエスト）

- 単純リクエストになる条件以外のリクエストはプリフライトリクエストになる
- プリフライトリクエストとは、本来のリクエスト送信前に送信するリクエストのこと
- 「本当にリクエスト送っていいの？」っていうのを確かめるためのブラウザのセキュリティ機構
- `PUT` や `DELETE` などのリクエストは、サーバ内のリソースやデータを変更・削除する可能性がある
  - `Access-Control-Allow-Origin` ヘッダで罠サイトが許可されていなかったとしても攻撃を防ぐことはできない
  - `Access-Control-Allow-Origin` はあくまでレスポンスのリソースへのアクセスを JavaScript に許可するものであり、サーバ内の処理を止めることはできない
- クロスオリジンの HTTP リクエストにおいてのみ発生する
- `OPTIONS` メソッドによるリクエストを送信する。

プリフライトリクエストの流れは以下の通り

1. クライアント側から  `OPTIONS`メソッドで以下のリクエストを投げる

   - `Origin` : 単純リクエストと同じ
   - `Access-Control-Request-Method` : 送るメソッド
   - `Access-Control-Request-Headers` : 送るリクエストヘッダ

2. サーバ側からレスポンスを投げる。その時、以下のレスポンスヘッダを含む

- `Access-Control-Allow-Origin` : 単純リクエストと同じ
- `Access-Control-Allow-Methods` : 許可するメソッド
- `Access-Control-Allow-Headers` : 許可するリクエストヘッダ
- `Access-Control-Max-Age`: プリフライトリクエストの結果をキャッシュして良い時間(秒)

3. ブラウザ側でレスポンスヘッダを読み込んで、問題なさそうなら実際のリクエストを開始する

例として、下記の実装でリクエストを行う。

```jsx
const xhr = new XMLHttpRequest();
xhr.open("POST", "https://bar.other/resources/post-here/");
xhr.setRequestHeader("X-PINGOTHER", "pingpong");
xhr.setRequestHeader("Content-Type", "application/xml");
xhr.onreadystatechange = handler;
xhr.send("<person><name>Arun</name></person>");
```

この場合、下記の理由からプリフライトリクエストが飛ぶ。

- リクエストヘッダーにカスタムヘッダが設定されている(`X-PINGOTHER`)
- `Content-Type`ヘッダーが次のいずれでもない
  - application/x-www-form-urlencoded
  - multipart/form-data
  - text/plain

処理の流れは下記のようになる。

![](https://storage.googleapis.com/zenn-user-upload/d4d86c4f5c8f-20231217.webp)

## 具体的な実装

CORS の具体的な実装方法は、主にサーバー側での設定に依存する。
クライアント側（主にブラウザ）は、サーバーからの CORS ヘッダーに基づいて、クロスオリジンリクエストを許可するかどうかを判断する。

### サーバ側の実装

サーバー側では、適切な CORS ヘッダーを HTTP レスポンスに含める必要がある。
これは通常、サーバーの設定ファイルやミドルウェアを通じて行われる。

```js
const express = require("express");
const app = express();

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "https://www.example.com"); // 特定のオリジンを許可
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE"); // 許可するHTTPメソッド
  res.header("Access-Control-Allow-Headers", "Content-Type, Authorization"); // 許可するHTTPヘッダー
  next();
});

app.get("/data", (req, res) => {
  res.json({ message: "これはCORS対応のレスポンスです" });
});

app.listen(3000, () => console.log("サーバーがポート3000で起動しました"));
```

このコードでは、すべてのルートに対して CORS ヘッダーを設定している。
`Access-Control-Allow-Origin` ヘッダーは、リソースへのアクセスを許可するオリジンを指定する。

### クライアント側の実装

クライアント側（ブラウザ）では、通常、特別な CORS の実装は必要ない。
ブラウザは自動的にサーバーからの CORS ヘッダーを確認し、ポリシーに基づいてリクエストを処理する。

```js
fetch("https://api.example.com/data", {
  method: "GET",
})
  .then((response) => response.json())
  .then((data) => console.log(data))
  .catch((error) => console.error("エラー:", error));
```

## 認証情報を含むリクエスト

デフォルトでは xhr や fetch はクロスオリジンへのリクエストに Cockie を送信しない。
例えば、`a.com` という js のページを開いた状態で `b.com` へリクエストを送る際に `b.com` の Cookie も含めてリクエストを送りたいという場合、デフォルトでは異なるオリジンに対して Cookie は送信されない。
オリジンをまたいだリクエストで Cookie を送りたい場合、
Cookie の送受信を許可するために、クライアントサイド・サーバーサイドに実装が必要になる。

### クライアントサイドの実装

#### XHR を使う場合

```js
const xhr = new XMLHttpRequest();
xhr.withCredentials = true; // ここを追加。
```

#### Fetch API を使う場合

```js
fetch("https://trusted-api.co.jp", {
  mode: "cors",
  credentials: "include", // ここを追加。
});
```

#### axios を使う場合

```js
axios.get("https://trusted-api.co.jp", {
  withCredentials: true,
});

axios.defaults.withCredentials = true; // global に設定してしまう場合
```

### サーバサイドの実装

以下 2 つのレスポンスヘッダをつける。

1. `Access-Control-Allow-Origin`
2. `Access-Control-Allow-Credentials: true`

- `Access-Control-Allow-Credentials: true` がなければ、Cookie 付きのリクエストは破棄される
- 認証情報を含むリクエストを許可したい場合、`Access-Control-Allow-Origin` で `*` (ワイルドカード)を指定するのは NG
- そのため、`Access-Control-Allow-Origin` は明示的に指定する

## クロスオリジンリクエストをクライアント側で制御する

- 通常、クロスオリジンリソースのアクセスや更新ははサーバー側のレスポンスヘッダー（プリフライトリクエストのレスポンスも含む）によって制御される
- しかし、クライアント側（特にブラウザでの JavaScript 実装）でさらなる制御を行うことも可能
- クライアント側では、**クロスオリジンに対するリクエスト**を制御できる

fetch 関数には、リクエストのモードを変更する `mode` オプション引数がある。

```js
fetch(url, { mode: `cors` });
```

`mode` に指定できる値は以下。

| リクエストモード | 意味                                                                                                                           |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `same-origin`    | クロスオリジンへのリクエストは送信されずにエラーとなる                                                                         |
| `cors`           | CORS の設定がされていない、または CORS 違反となるリクエストが送信されたときはエラーになる。`mode` が省略された時のデフォルト値 |
| `no-cors`        | クロスオリジンリクエストは単純リクエストのみに制限される                                                                       |

- クロスオリジンへのリクエストを送信するときは `cors` を設定する
- ほぼ全てのブラウザにおいて、デフォルト値は `cors`

## `crossorigin` 属性

- `<img>` 要素や `<script>` 要素などの HTML 要素を使ったリクエストは、デフォルトで CORS を使わない
- これらの要素から送信されるリクエストのモードは、
  - 同一オリジンの場合は `same-origin`
  - クロスオリジンの場合は `no-cors`
- `crossorigin` 属性を付与することで、`cors` モードとしてリクエストできる

```html
<!-- リクエストモードはno-cors -->
<img src="https://cross-rigin.example/sample.png" />

<!-- リクエストモードはcors -->
<img src="https://cross-origin.example/sample.png" crossorigin />
```

`crossorigin` 属性に指定する値によって Cookie の送信を制御できる。

| crossorigin の指定            | Cookie の送信範囲      |
| ----------------------------- | ---------------------- |
| crossorigin                   | 同一オリジンだけに送信 |
| crossorigin=""                | 同一オリジンだけに送信 |
| crossorigin="anonymous"       | 送信しない             |
| crossorigin="use-credentials" | すべてのオリジンへ送信 |

## 参考リンク

https://qiita.com/att55/items/2154a8aad8bf1409db2b#xhr-%E3%82%92%E4%BD%BF%E3%81%86%E5%A0%B4%E5%90%88
