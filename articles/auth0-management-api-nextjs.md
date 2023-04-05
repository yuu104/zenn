---
title: "Auth0 Management API を使ってログインユーザの Email を変更する"
emoji: "🐈"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [nextjs, auth0]
published: true
---

# Management API とは？

Auth0 テナント内のユーザーやアプリケーションなどの設定や管理を行うための API。
具体的には、以下のような機能がある。

- ユーザーの作成、更新、削除、検索
- アプリケーションの作成、更新、削除、検索
- ルールの作成、更新、削除、検索
- コネクションの作成、更新、削除、検索
- クライアントの作成、更新、削除、検索
- リソースサーバーの作成、更新、削除、検索

このような機能を使って、ユーザーの認証やアクセス制御、アプリケーションの管理、コネクションの設定などを行うことができる。
Auth0 ダッシュボードからできることは大抵 Management API からでもでいるらしい。

# Management API のリクエストについて

- Management API は JSON 形式でデータを送受信する
- API リクエストは`Content-Type`が`application/json`で送信する必要がある
- API エンドポイントにアクセスするには認証情報が必要になる
- 認証情報には、JWT を使用する
- Node.js の SDK を使用すると簡単に実装できる
  - SDK がアクセストークンを自動的に取得し、API リクエストを送信してくれる

# Node.js SDK を利用した Management API の使用手順

## 1. Machine to Machine アプリケーションの作成

管理したい Auth0 テナントに Machine to Machine アプリケーションが必要なのでここで作成する。
![](/images/auth0-management-api-nextjs/create-application.png)
Machine to Machine アプリケーションは "Auth Management API" の 1 つしか選択肢がないが、これを選択する。
![](/images/auth0-management-api-nextjs/authorize-machine-to-machine-application.png)
最後に API のスコープを指定する。
今回はユーザ管理周りのものを全て選択しておく。
![](/images/auth0-management-api-nextjs/select-permissions.png)

## 2. node-auth0 をインストール

```shell
% yarn add auth0
```

バージョン: `^3.3.0`

## 3. 実装

まずは各管理操作で共通利用する Management API のクライアントを定義する。

```ts
import auth0Client from "auth0";

const managementClient = new auth0Client.ManagementClient({
  domain: process.env.AUTH0_MANAGEMENT_APP_DOMAIN!,
  clientId: process.env.AUTH0_MANAGEMENT_APP_CLIENT_ID!,
  clientSecret: process.env.AUTH0_MANAGEMENT_APP_CLIENT_SECRET,
  scope: "update:users",
});
```

`ManagementClient` を取得し、Machine to Machine アプリケーションで登録した `domain`, `clientId`, `client_secret` の値を指定し、スコープとして `update:users` を指定してインスタンス化する。

```ts
/**
 * @param req - Next.js API Request
 * @param res - Next.js API Response
 */
export async function updateAuthEmail(
  req: NextApiRequest,
  res: NextApiResponse
) {
  const { id } = req.query;

  if (!id || Array.isArray(id))
    return res.status(400).end("Bad request. Query parameters are not valid.");

  const { email } = req.body;

  const params = { id };
  const data = { email };
  managementClient.updateUser(params, data, (error, user) => {
    if (error) {
      console.error(error);
      return res.status(500).end(error);
    }

    res.status(200).json(user);
  });
}
```

`id`: Auth0 ユーザの識別子
`email`: 新規メールアドレス
インスタンス化した`managementClient`を使用して更新処理を行う。
`managementClient.updateUser()`がユーザ情報の更新メソッド。
第一引数にユーザの識別子が入ったオブジェクト、第二引数に更新情報が入ったオブジェクトを指定する。
https://auth0.github.io/node-auth0/ManagementClient.html#updateUser

# 参考リンク

https://dotnsf.blog.jp/archives/1081639207.html

https://dev.classmethod.jp/articles/manage-auth0-users-using-auth0-management-api-with-nodejs/

https://www.isoroot.jp/blog/4114/#second

https://qiita.com/smesh/items/ea5100f570211ffe7890
