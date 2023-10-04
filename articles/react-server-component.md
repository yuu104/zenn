---
title: "React Server Componentsを理解する"
emoji: "📌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, nextjs, typescript]
published: false
---

## はじめに

- React18 から、React Server Components（RSC, SC）が登場した
- Next.js13 では、SC を標準サポートしている
- RSC の登場により、これまでのコンポーネント（js ファイルによりクライアント側で生成するコンポーネント）を Client Components（CC）と呼ぶようになった

## まずは Suspense を知る

- Suspense は機能の名前であると同時に、React から提供されているコンポーネントの名前
- 以下のように使用できる
  ```tsx
  import { Suspense } from "react";
  // ...
  <Suspense fallback={<div>Loading...</div>}>
    <SomeComponent />
  </Suspense>;
  ```
- `<Suspense />` は通常の状態では何もせず、子として渡されたコンテンツ（`<SomeComponent />`）がレンダリングされる
- しかし、中身のコンポーネントがサスペンドした場合、代わりに `fallback` として渡されたコンテンツがレンダリングする

### サスペンドとは？

- コンポーネントが「まだレンダリングできない」状態
- コンポーネントが「ローディング中」である場合にサスペンドする
- `<Suspense />` 内部のコンポーネントが 1 つでもサスペンドすれば、`fallback` がレンダリングされる
- 従って、`<SomeComonent />` の子コンポーネントがサスペンドした場合も `fallback` がレンダリングされる

## React Server Components とは？

- サーバ側でレンダリングされたコンポーネント
- SC の登場により、コンポーネント毎に「クライアントでレンダリングされるコンポーネント」と「サーバでレンダリングされるコンポーネント」を区別が付けられるようになった
  - 以下のように、1 つのページに SC と CC が混在するようになる
    ![](https://storage.googleapis.com/zenn-user-upload/e93e24d24658-20230924.png)

## サーバ側でレンダリング？？

RSC をレンダリングする時には、以下のような流れになる。

1. サーバがレンダリングリクエストを受け取る
2. サーバが仮想 DOM を構築し、**RSC ペイロード**と呼ばれる特別なデータ形式にシリアライズする
   ![](https://storage.googleapis.com/zenn-user-upload/a39fb2114fe6-20230926.png)
3. RSC ペイロードをクライアントにレスポンスする
4. クライアント側で RSC ペイロードをパースして処理する

これが、「サーバでコンポーネントを実行する」の意味。
![](https://storage.googleapis.com/zenn-user-upload/696bc3a781a8-20230924.png)
クライアント側から見ると、SC は「コンポーネントツリーの好きな場所で、**サーバへリクエストを送ると、仮想 DOM が返ってくるもの**」になる。

## RSC の特徴

## 何のための技術なのか

SC は、「**サーバで生成できるコードはクライアントに送らずサーバ側で完結した方が良い**」という考えから出来た。
サーバ側で完結させるメリットは何か？

- JS のバンドルサイズの削減
- データフェッチスピードの高速化
- セキュリティ
- 設計面のメリット

### JS のバンドルサイズの削減

- CC は空の HTML から JS コードにより、コンポーネントを構築している
- しかし、SC はサーバ側でコンポーネントの構築が完結するため、クライアントに JS コードを持っておく必要がない
- 従って、SC 分の JS コード（レンダリング処理）を削減できる
- これにより、パフォーマンスが向上する

### データフェッチスピードの高速化

- SC はサーバで行う処理なので、当然データソースとの距離も近い
- 従って、クライアントから取得を行うよりも高速
- クライアントが行うデータリクエストの量も削減できる

### セキュリティ

- トークンや API キーなどの機密データやロジックをサーバだけで完結でき、サービスの安全性が向上する

### キャッシュ

- サーバでレンダリングされたコンポーネントのキャッシュを行う
- これにより、レンダリング時間やデータフェッチ量が削減され、リクエストから表示までが高速になる

## SSR との違い

- RSC はサーバで**コンポーネント**がレンダリングされる
- SSR はサーバで**HTML**を生成する

Next.js の公式ドキュメントによると、Next.js における SC のレンダリング手法は以下の通り。

1. React がサーバ側で RSC ペイロード形式にレンダリング
2. Next.js が RSC ペイロードと CC の js 命令を使用し、サーバ上で HTML を生成する
3. HTML と js ファイルをクライアントに送信する
4. クライアントが HTML を使用して非インタラクティブなページを表示する
5. js ファイルを実行し、CC をハイドレートする

## 使用ケース

SC と CC の使い分けの判断基準は、**サーバで処理した方が効率が良いコンポーネントかどうか？**という部分になる。
![](https://storage.googleapis.com/zenn-user-upload/6451055ce774-20230924.png)

## 参考リンク

https://qiita.com/naruto/items/c17c79ec5c2a0c7c4686

https://zenn.dev/sumiren/articles/f39a151e7320d5#1.-server-components%E3%81%AE%E7%9B%AE%E7%9A%84

https://postd.cc/how-react-server-components-work/

https://zenn.dev/uhyo/articles/react-server-components-multi-stage

https://qiita.com/getty104/items/74d975ff02bdf4fa9b2b#js%E3%81%AE%E3%83%90%E3%83%B3%E3%83%89%E3%83%AB%E3%82%B5%E3%82%A4%E3%82%BA%E3%81%AE%E5%89%8A%E6%B8%9B

https://zenn.dev/izumin/articles/bc47e189e25874
