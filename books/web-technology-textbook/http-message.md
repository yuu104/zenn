---
title: "HTTPメッセージ"
---

## HTTP メッセージの構造

HTTP 通信では、リクエストとレスポンスで共に HTTP メッセージと呼ばれる形式のメッセージを使用する。
HTTP/1.1 はテキストベースプロトコルであるため、HTTP メッセージには ASCII 文字列を用いる。

![](https://storage.googleapis.com/zenn-user-upload/c23922630579-20230811.png)

## リクエストメッセージ

### リクエストメッセージの構造

![](https://storage.googleapis.com/zenn-user-upload/dc8bc07c01dc-20230811.png)

1 行目 : **リクエストライン**
2 行目〜空行 : **ヘッダー**
空行〜末尾 : **ボディ**

### リクエストライン

![](https://storage.googleapis.com/zenn-user-upload/b19664cb344f-20230811.png)

### メソッド

メソッドは、リソースに対する処理内容を指定する。
![](https://storage.googleapis.com/zenn-user-upload/a45d215f5d36-20230811.png)

### リクエスト URL

リクエスト URL には、リクエストするリソースの位置情報を指定する。

例えば、`http://www.example.jp` の `index.html` をリクエストする場合、リクエスト URL は `http://www.example.jp/index.html` となる。

リクエスト URL は、以下の要素で構成されている。

1. **スキーム（プロトコル）**
   一般的なスキームには `http://` や `https://` がある。
   これによって、リクエストがどのプロトコルを使用して通信すべきかが指定される。
2. **ホスト名**
   リソースが配置されているサーバのアドレスを指定する。
   `www.example.com` などのドメイン名がホスト名となる。
3. **ポート番号**
   HTTP であれば 80、HTTPS であれば 443。
4. **パス**
   サーバー上のディレクトリやファイルの場所を示す部分。
   URL のホスト部分の後ろにスラッシュ「/」で区切られた文字列がパスとして指定される。
5. **クエリパラメータ**
   クエストに付加的な情報を提供するためのキーと値のペア。
   URL の末尾に「?」を付けてクエリパラメータを指定し、複数のパラメータは「&」で区切る。

一般的に、リクエスト URL の指定でスキームやホスト名、ポート番号を省略できる。
これは、HTTP 接続の確立前に、TCP 接続で Web サーバーに接続されるため、わざわざプロトコルやホスト名を明示する必要がないからである。

そのため、リソースの位置情報にはサーバから相対的な位置を示す**相対 URL**を使用する。
ホスト名やポート番号は、ヘッダー内の `HOST:` で指定する。
![](https://storage.googleapis.com/zenn-user-upload/68ff843b5f77-20230811.png)

上記のように、一般的に、リクエスト URL にはスキームやホスト名を除いた、パス以降の URL を指定するが、スキームやホスト名を含んだ絶対 URL で指定することも可能。
プロキシサーバに対してリクエストを送信する場合は、絶対 URL を用いる。
![](https://storage.googleapis.com/zenn-user-upload/40975c3d09c0-20230811.png)

### HTTP バージョン

末尾の HTTP バージョンには使用するプロトコル名とバージョンを指定する。
該当バージョンで使用するには、クライアントとサーバの両方で対応している必要がある。

### ヘッダー

ヘッダーでは、クライアントからサーバに対して送信するリクエストの内容を詳細に記述する。
例えば、`Host:` ではホスト名、`Cookie` ではクッキーを指定する。
![](https://storage.googleapis.com/zenn-user-upload/7788838e7639-20230811.png)

HTTP/1.1 で定義されているヘッダーだけで 40 種類程存在し、拡張ヘッダーまで含めるとさらに数が増える。
必須になるヘッダーは `Host:` だけ。

![](https://storage.googleapis.com/zenn-user-upload/32123e8b917a-20230811.png)
![](https://storage.googleapis.com/zenn-user-upload/2fd6ddf4e6f8-20230811.png)

ヘッダーの行数や文字数はブラウザや Web サーバによって異なり、8K バイトや 16K バイトといった上限が設けられている。

### ボディ

ボディは省略可能。
リクエストラインで GET メソッドを指定した場合は、ボディを含まないリクエストメッセージをサーバに送信できる。

POST メソッドを指定した場合はボディを使用する。
**URL エンコード**や**マルチパートエンコード**を用いて、クライアントからサーバに送信するデータをエンコードしたものをボディに埋め込んで送信する。
![](https://storage.googleapis.com/zenn-user-upload/d0a5003146e4-20230811.png)

## レスポンスメッセージ

### レスポンスメッセージの構造

![](https://storage.googleapis.com/zenn-user-upload/6065beed026f-20230811.png)

### ステータスライン

![](https://storage.googleapis.com/zenn-user-upload/d58a5df5af75-20230811.png)

**ステータスコード**には 100〜500 番台まである。
**テキスト**には、ステータスコードの概要を説明する短い文章がセットされる。

![](https://storage.googleapis.com/zenn-user-upload/a4ff946d3402-20230811.png)

ステータスコードを確認することで、リクエストが成功したのか、失敗したのかがわかる。
失敗した場合も、値によって原因を探ることができる。

:::details 300 番台のリダイレクトについて
以下のようなレスポンスメッセージを受け取った場合、ステータスコードが `302` であることから別の URL へ移動したことが分かる。
代わりに新しい URL が `Location:` ヘッダーに示されている。
![](https://storage.googleapis.com/zenn-user-upload/0bcc570e8e42-20230811.png)

Web サーバから 300 番台のレスポンスを受け取ると、ブラウザは自動的にリダイレクト処理をしてくれる。
:::

### ヘッダー

![](https://storage.googleapis.com/zenn-user-upload/0e20fde33a4e-20230811.png)
![](https://storage.googleapis.com/zenn-user-upload/b4222b4a733d-20230811.png)

### ボディ

サーバからクライアントに対して転送したいデータがある場合に使用する。
レスポンスでも、リクエストと同様にボディが省略される場合がある。
