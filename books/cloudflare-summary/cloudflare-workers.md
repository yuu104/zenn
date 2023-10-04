---
title: "Cloudflare Workers"
---

## 概要

- エッジサーバでスクリプトを実行してくれるサーバーレスコンピューティングであり、FaaS
- Web リクエストに応じたレスポンスを返すサービスを簡単に構築できる
- Workers は世界中に配置されたエッジサーバで実行されるため、クライアントからの要求に高速に応答することができる
- Azure Functions や AWS Lambda と同じようなサービス
- JavaScript（V8）を実行することが可能

## サーバレスコンピューティングとは？

https://www.cloudflare.com/ja-jp/learning/serverless/what-is-serverless/
https://qiita.com/takanorig/items/3a3a0b43b5be5b4a124f
https://www.science.co.jp/document_jamstack_blog/30226/

## FaaS とは？

https://www.cloudflare.com/ja-jp/learning/serverless/glossary/function-as-a-service-faas/

クラウドコンピューティングの一種。
アプリケーションの機能や処理を個別の関数（コードの断片）として実行できるようにするサーバレスアーキテクチャ。
つまり、アプリケーションを小さな関数の集まりとして構築し、それぞれの関数が特定のタスクや処理を担当する。
開発者はコードを記述し、クラウドプロバイダーが関数の実行環境を提供し、必要なときに関数をスケーリングする。

### 特徴

- **サーバレス**
  開発者はサーバの管理を行う必要がない。
- **イベント駆動**
  関数はトリガーに応じて自動的に実行され、イベント駆動型のアーキテクチャをサポートする。
- **瞬時のスケーリング**
  高負荷時に自動的に関数のインスタンスを増減させ、スケーリングが簡単。
- **従量課金**
  実際に使用したリソースに対して課金されるため、コスト効率が高い。
- **複数の言語サポート**
  多くの FaaS プラットフォームは複数のプログラミング言語をサポートし、開発者が選択肢を持てる。

### ユースケース

#### 画像のリサイズ

1. ユーザが Web アプリに画像をアップロードする
2. 画像のアップロードがトリガーとなり、サーバレス関数が実行される
3. サーバレス関数は、アップロードされた画像をリサイズし、異なる解像度のバージョンを生成する
4. ユーザにリサイズされた画像が表示される

このケースでは、アプリの一部であるリサイズ機能をサーバレス関数として実装し、必要なときにトリガーされるようにしている。

#### データの処理と通知

1. センサーやデバイスからリアルタイムのデータが収集される
2. データの到着がトリガーとなり、サーバレス関数が呼び出される
3. サーバレス関数はデータを解析し、特定の条件に合致する場合に通知を生成する。
   例えば、温度が一定以上に上昇した場合に警告通知を生成することができる。
4. 通知が適切な受信者に送信される

このケースでは、データの処理と通知をサーバレス関数として分離し、データが到着したときに関数が実行されるようにしている。

#### バックエンド API の処理

1. クライアントからの HTTP リクエストがアプリケーションのバックエンドに送信される
2. リクエストの到着がトリガーとなり、FaaS 関数が実行される
3. サーバレス関数はリクエストを処理し、データベースからデータを取得したり、認証を行ったり、他のビジネスロジックを実行する
4. 関数は HTTP レスポンスを生成してクライアントに返す

このケースでは、バックエンド API の各エンドポイントをサーバレス関数として実装し、リクエストごとに適切な関数が実行される。

### メリット

- **コスト効率**
  従量課金なので、実際に使用したリソースに対してのみ支払いが発生する。
- **スケーラビリティ**
  自動的にスケーリングするため、トラフィックの変動に適応できる。
- **高可用性**
  クラウドプロバイダーが冗長性を提供し、高可用性を実現する。
- **簡素化された運用**
  サーバーの管理やメンテナンスが不要で、運用コストが低い。

### デメリット

- **コールドスタート**
  関数が初めて実行される際に遅延が発生することがあり、一部のアプリケーションに影響を与えることがある。
- **制約**
  メモリや実行時間の制約があるため、一部のタスクには適していない場合がある。
- **リプレイスが困難**
  サーバレスアーキテクチャはベンダーごとにやり方が異なる。

## Cloudflare Workers の特徴

- JS のコードをデプロイするだけでサーバサイド機能が構築できる
- 負荷に応じて自動的にスケーリングされ、常に安定して処理される
- 常時起動されているわけではなく、呼び出しに応じて起動される
- 使用量に応じた従量課金ではあるが、ある程度までは無料で使える

上記のように、従来の FaaS と同様な部分もありつつ、似て非なる点もいくつかある。

以下は Cloudflare Workers の大きな特徴。

### 全世界の CDN エッジで実行される

- 従来の FaaS では、書いたコードを事業者のどのリージョンにデプロイするかを、最初に決める必要があった
- 例えば、東京リージョンにデプロイした場合、日本国内では速く応答できるが、東京から遠いブラジルなどはレイテンシーが高くなる
- しかし、CloudFlare Workers では、[世界 100 ヵ国 200 以上の拠点](https://www.cloudflare.com/network/)に配置された CDN のエッジにデプロイされ、常にアクセスした場所の最寄りの拠点で実行される
- これにより、サーバからの物理的位置が原因のレイテンシー問題が解消される

### Service Workers のような使い方もできる

- ブラウザにおける Servece Workers のような使い方ができる
- Servece Workers は、「目的のリソースを取得するためのリクエストがネットワークに出ていく直前」で任意の処理を差し込めるレイヤー
  ![](https://storage.googleapis.com/zenn-user-upload/c142abfa062d-20231001.png)
  そのため、

  - 発行されたリクエストを加工する
  - レスポンスをキャッシュしておいて、次からネットワークアクセスを省略する処理

  などが可能となる。

- これに対し、CloudFlare Workers では、「発行されたリクエストが目的のリソースに届く直前」で任意の処理を実行できる
  ![](https://storage.googleapis.com/zenn-user-upload/f1453b9177ff-20231001.png)
  そのため、

  - リソースを加工してレスポンスを返す
  - リダイレクトするなど、そもそものアクセスを禁止
  - AB テストによるコンテンツの出し分け

  というように、CDN 本来のキャッシュ機能をプログラムを介して柔軟に利用できる。

### Node.js ではない JavaScript の実行環境

- Cloudflare Workers の実行環境は、JavaScript の実行エンジにである V8
- これにより、従来の FaaS で問題になっていたコールドスタートが短くなり、安定して高速な応答ができるようになる
- V8 のアップデートは頻繁に行われるため、いつでも最新の JavaScript が使用できる
-

## 開発環境の構築

まずは、node.js をインストールする
`v16.13.0` より新しいバージョンの node が必要になる

```shell
node --version
v18.17.0
```

## サインアップ

https://workers.cloudflare.com/

- Cloudflare のアカウントを作成する
- 無料で使える Free プランが用意されている
- クレジットカードの登録は不要

## プロジェクトの初期化とデプロイ

```shell
$ yarn create cloudflare
```

コマンドを実行すると、いくつか質問される。

1. In which directory do you want to create your application? also used as application name
   - アプリケーションを作成するディレクトリを指定する。プロジェクトの名前を兼ねる。
   - ここでは、`hello` と入力する
2. What type of application do you want to create?
   - 作成するアプリケーションの種類を選ぶ
   - ここでは `"Hello World" Worker` を選択する
3. Do you want to use TypeScript? Yes / No
   - 実装言語として TypeScript を利用するか選ぶ
4. Do you want to use git for version control?
   - git をバージョン管理として利用するかを選択する
5. Do you want to deploy your application? Yes / No
   - 今すぐアプリケーションをデプロイするか選ぶ

以上でプロジェクトの初期化とデプロイは完了する。

コマンドの実行が成功すると、以下のメッセージが出力される。
同時に、`hello` ディレクトリが作成される。

```shell
SUCCESS  View your deployed application at https://hello.yusei8171.workers.dev
```

## 動作確認

すでに Worker はデプロイされて、インターネットからアクセス可能になっている。
以下のコマンドを実行して確認してみる。

```shell
$ curl http://hello.example.yusei8171.workers.dev
Hello, World!
```

## ローカル環境で動作確認

```shell
$ npx wrangler dev
```

デフォルトでは `http://localhost:8787` でリクエストを待ち受ける。

```shell
$ curl http://localhost:8787
Hello World!
```

## デプロイ方法

デプロイは以下のコードを実行するだけ。

```ts
$ npx wrangler deploy
```

通常、デプロイは数秒で完了する。

## `src/index.ts`

```ts
/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

export interface Env {
  // Example binding to KV. Learn more at https://developers.cloudflare.com/workers/runtime-apis/kv/
  // MY_KV_NAMESPACE: KVNamespace;
  //
  // Example binding to Durable Object. Learn more at https://developers.cloudflare.com/workers/runtime-apis/durable-objects/
  // MY_DURABLE_OBJECT: DurableObjectNamespace;
  //
  // Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
  // MY_BUCKET: R2Bucket;
  //
  // Example binding to a Service. Learn more at https://developers.cloudflare.com/workers/runtime-apis/service-bindings/
  // MY_SERVICE: Fetcher;
  //
  // Example binding to a Queue. Learn more at https://developers.cloudflare.com/queues/javascript-apis/
  // MY_QUEUE: Queue;
}

export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext
  ): Promise<Response> {
    return new Response("Hello World!");
  },
};
```

- 冒頭のブロックコメントは Cloudflare Workers の紹介文
- `Env` インターフェースは Cloudflare の様々なサービスと Worker を連携する際に使用する
- `export default` で定義している `fetch()` は Worker のエントリーポイント

### ライフサイクル

`fetch()` で実行される処理の流れは以下の通り。

1. HTTP リクエストを受け取る
2. 何らかの処理を行う
3. HTTP レスポンスを返す

- Worker は `fetch()` の実行単位
- Cloudflare のサーバにリクエストが完了すると、その都度 Worker が作成されて `fetch()` が実行される
- `fetch()` の実行が完了すると Worker は削除される

### リクエストとレスポンスの型

- `fetch()` の引数 `Request` と戻り値の `Response` は JavaScript 標準 API で定義されたインターフェースに準拠している
  - [Request - Cloudflare Workers docs](https://developers.cloudflare.com/workers/runtime-apis/request/)
  - [Response - Cloudflare Workers docs](https://developers.cloudflare.com/workers/runtime-apis/response/)
- レスポンスのヘッダーをカスタマイズしたい場合は、`Response` コンストラクタの第 2 引数に `Headers` のインスタンスを指定する

  ```ts
  // Content-Lengthヘッダーは自動的に設定されます。手作業で設定する必要はありません。
  const headers = new Headers({
    "Content-Type": "application/json",
  });

  return new Response("{values: [1, 2, 3]}", { headers });
  ```

### JSON を返す

```ts
const headers = new Headers({
  "Content-Type": "application/json",
});

const data = { name: "yuu", age: 22 };

return new Response(JSON.stringify(data), { headers });
```

```shell
$ curl http://localhost:8787
{"name":"yuu","age":22}
```

### HTML を戻す

```ts
const headers = new Headers({
  "Content-Type": "text/html",
});

const html = `
		<html>
		<body>
		<h1>Hello World</h1>
		</body>
		</html
		`;

return new Response(html, { headers });
```

![](https://storage.googleapis.com/zenn-user-upload/53e37622233c-20231002.png)

### Request: `cf` プロパティ

- JS 標準の `Request` に加え、Cloudflare が独自に定義したプロパティ
- リクエストが来た国や都市などの情報が含まれている

https://developers.cloudflare.com/workers/runtime-apis/request/#incomingrequestcfproperties

## グローバル変数に依存した処理は行わない

```ts
export interface Env {
  // ...
}

// 説明を簡単にするためcount変数のロックは考慮していません。
var count = 0;

export default {
  async fetch(
    request: Request,
    env: Env,
    ctx: ExecutionContext
  ): Promise<Response> {
    count += 1;

    return new Response(count);
  },
};
```

- 上記はアクセスカウンター
- リクエストを受け取る度にグローバル変数 `count` がインクリメントされる

#### ローカルで Worker を動作させた場合

```shell
$ curl http://localhost:8787
1

$ curl http://localhost:8787
2

$ curl http://localhost:8787
3
```

#### Cloudflare のサーバーで Worker を動作させた場合

```shell
$ curl https://hello.example.workers.dev
1

$ curl https://hello.example.workers.dev
1

$ curl https://hello.example.workers.dev
1
```

- Cloudflare のサーバーで Worker を動作させると、レスポンスとして常に `1` が返されている
- Cloudflare のサーバーで実行される Worker は冗長化されている
- つまり、上記の例で 1 番目・2 番目・3 番目のリクエストを受け取った Worker インスタンスはそれぞれ異なる
- 一見すると正しくインクリメントされていないように見えるが、それぞれの Worker インスタンスでは正しくインクリメントされている
- そのため、偶然に同じ Worker インスタンスが使い回されるとレスポンスとして 2 や 3 が返ってくる可能性はある

- 何にせよ、グローバル変数に依存した処理を実装するべきではない
- Cloudflare のドキュメントにも Worker インスタンスがどのタイミングで破棄されるのか言及がない
- 基本的には、リクエストのたびに作成されて、処理の完了と同時に破棄されると考えて処理を実装するべき

- 従って、グローバル変数を扱う場合や、異なる Worker 同士で処理を共有する場合は Cloudflare KV、処理の結果を永続化する場合は Cloudflare R2 などの別サービスと連携する必要がある

## リソースの制限

https://zenn.dev/moutend/articles/97c98a277f4bae#%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E3%81%AE%E5%88%B6%E9%99%90

## ユースケース

エッジサーバにてコードを実行するので、オリジンサーバに到達する前に実行したい独自処理を得意とする。

- 異なるタイプのリクエストを異なるオリジンサーバにルーティングする
- HTML テンプレートをエッジで展開し、オリジンでの帯域幅の費用を削減する
- キャッシュコンテンツに対する独自コントロール
- User-Agent ごとにリダイレクト
- 全く異なる 2 つのバックエンド間で A/B テストを実現
- 独自のアクセスフィルタリング
- 独自のフェイルオーバーの実装
- ログの収集

上記のように活用方法は様々。
公式サイトに example がある。
https://developers.cloudflare.com/workers/examples

### 利用例

https://product.st.inc/entry/2022/12/20/112524#f-a70ec28d

## 参考リンク

https://www.codegrid.net/articles/2021-cloudflare-workers-1/

https://qiita.com/sakupa80/items/8ccb4e4e4c0f7846ab5c

https://zenn.dev/moutend/articles/97c98a277f4bae#cli%E3%83%84%E3%83%BC%E3%83%AB

https://reffect.co.jp/html/cloudflare-workers/

https://future-architect.github.io/articles/20230427a/
