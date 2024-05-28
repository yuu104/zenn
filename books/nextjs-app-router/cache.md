---
title: "キャッシュ"
---

App Router では、「レンダリング結果」と「データフェッチ結果」を**デフォルトで**キャッシュする機能が備わっている。
キャッシュの種類は以下 4 つ。

- Request Memoization
- Data Cache
- Full Route Cache
- Router Cache

| 種類                | キャッシュ対象                             | 保管場所  | 目的                                                      | キャッシュ期間                   |
| ------------------- | ------------------------------------------ | --------- | --------------------------------------------------------- | -------------------------------- |
| Request Memoization | `fetch` 関数の戻り値（データフェッチ結果） | Server    | Route Segment（コンポーネントツリー）でデータを再利用する | ブラウザリクエストごと           |
| Data Cache          | データフェッチ結果                         | Server 　 | ブラウザリクエスト・デプロイをまたぐデータの保存          | 永久的（再検証可能）             |
| Full Route Cache    | HTML, RSC Payload                          | Server    | レンダリングコストの削減                                  | 永久的（再検証可能）             |
| Router Cache        | RSC Payload                                | Client    | ナビゲーション時のブラウザリクエスト削減                  | ユーザーセッション or 時間ベース |

キャッシュされる順番は

1. Request Memoization
2. Data Cache
3. Full Route Cache
4. Router Cache

以下の流れでキャッシュされていく。
![](https://storage.googleapis.com/zenn-user-upload/612d47897134-20240518.png)

## Request Memoization

- React の機能であり、`fetch` 関数を拡張して実現している
- `fetch` 関数の戻り値を一時的にキャッシュする
- 一回のブラウザリクエスト内で重複する `fetch` リクエストはキャッシュされる
- そのため、フェッチしたデータを Props 経由で他コンポーネントと共有する必要がなくなった
- これを「**Request のメモ化**」と呼ぶ

![](https://storage.googleapis.com/zenn-user-upload/49b1f5348537-20240518.png)

これで、**重複を気にせずコンポーネント単位で `fetch` 関数を呼び出せる**。

メモ化は**サーバー上で `fetch` 関数を使用したときに有効**になる。
ブラウザリクエストからキャッシュまでの流れは以下の通り。
![](https://storage.googleapis.com/zenn-user-upload/3502c5d67652-20240518.png)

### キャッシュの保存期間

- 単一リクエストが存続している間
- ブラウザレンダリングが完了すると、キャッシュは破棄される
- 異なるユーザー、ブラウザリクエストをまたいで共有されることはない
- よって、保存期間は短い

### キャッシュを廃棄する方法

- 別のブラウザリクエスとが完了すると、自動で破棄される
- よって、明示的に破棄する必要はない

### オプトアウト（キャッシュを無効化）する方法

`AbortController` インスタンスの `signal` プロパティをリクエストに渡す。

```ts
const { signal } = new AbortController();

fetch(url, { signal });
```

:::details AbortController とは？

`AbortController`は、Web API の一部で、特に`fetch`リクエストやその他の非同期タスクを中止するために使用されます。`AbortController`は、`AbortSignal`と連携して動作します。以下に、`AbortController`の詳細な説明と使用例を示します。

### `AbortController`とは

`AbortController`は、非同期操作を中止するためのコントローラーオブジェクトです。`AbortController`は、`signal`というプロパティを持っており、これが`AbortSignal`オブジェクトです。このシグナルは、非同期操作に渡され、その操作を中止するために使用されます。

### 主なメソッドとプロパティ

- **`controller.signal`**: 中止シグナル（`AbortSignal`）を取得します。
- **`controller.abort()`**: このメソッドを呼び出すと、関連付けられた`AbortSignal`を使ってすべてのリスナーに「中止」通知を送ります。

### 使用例

以下に、`fetch`リクエストを`AbortController`で中止する例を示します。

```javascript
const controller = new AbortController();
const signal = controller.signal;

async function fetchData() {
  try {
    const response = await fetch("https://jsonplaceholder.typicode.com/posts", {
      signal,
    });
    const data = await response.json();
    console.log(data);
  } catch (error) {
    if (error.name === "AbortError") {
      console.log("Fetch aborted");
    } else {
      console.error("Fetch error:", error);
    }
  }
}

// Fetchリクエストを開始
fetchData();

// 5秒後にリクエストを中止
setTimeout(() => {
  controller.abort();
  console.log("Fetch request aborted");
}, 5000);
```

### 解説

1. **`AbortController`の作成**:

   ```javascript
   const controller = new AbortController();
   const signal = controller.signal;
   ```

   ここで、新しい`AbortController`インスタンスを作成し、その`signal`プロパティを取得します。

2. **`fetch`リクエストの開始**:

   ```javascript
   const response = await fetch("https://jsonplaceholder.typicode.com/posts", {
     signal,
   });
   ```

   `fetch`リクエストに`signal`オプションを渡します。これにより、`fetch`リクエストは指定された`AbortSignal`によって中止可能になります。

3. **リクエストの中止**:

   ```javascript
   setTimeout(() => {
     controller.abort();
     console.log("Fetch request aborted");
   }, 5000);
   ```

   ここで、`setTimeout`を使って 5 秒後に`controller.abort()`を呼び出しています。これにより、`fetch`リクエストが中止されます。

4. **エラーハンドリング**:
   ```javascript
   if (error.name === "AbortError") {
     console.log("Fetch aborted");
   } else {
     console.error("Fetch error:", error);
   }
   ```
   `fetch`が中止された場合、キャッチされたエラーの`name`プロパティは`'AbortError'`になります。これをチェックして、適切なエラーハンドリングを行います。

### 応用例

複数の非同期操作を中止する場合や、他の非同期 API（例えば、WebSocket や XHR）でも`AbortController`を使用できます。また、`Promise`を手動で中止する場合にも利用できます。

`AbortController`は、リソースの節約やユーザー体験の向上に役立つ強力なツールです。長時間のリクエストや不要になったリクエストを中止することで、効率的な非同期処理が可能になります。

:::

### `fetch` 関数以外でキャッシュする方法

- React の `cache` 関数を使用する
- `cache` でデータ取得関数を囲うことで、`fetch` と同様にキャッシュが可能になる

```tsx
import { cache } from "react";

export const getItem = cache(async (id: string) => {
  const item = await db.item.findUnique({ id });
  return item;
});
```

### キャッシュされる条件

以下 2 つのどちらかを満たせばキャッシュされる。

- サーバー上で `fetch` 関数を使用する
- サーバー上で `cache` 関数を使用する

## Data Cache

- Request Memoization と同様、サーバー上におけるデータフェッチの結果をキャッシュする
- `fetch` 関数を使用した場合、デフォルトでキャッシュされる
- ビルド時やサーバーリクエスト時にキャッシュされる
- **キャッシュされた場合、誰もが共有できるデータとなる**
- よって、キャッシュ可能なのは「静的データ」に限定される

![](https://storage.googleapis.com/zenn-user-upload/ce2601b69141-20240519.png)

### 特徴

- 異なるブラウザリクエストをまたいで共有される
- 異なるユーザーをまたいで共有される
- **再ビルドしても破棄されない**
- キャッシュ更新には再検証が必要

### キャッシュの保存期間

- 再検証が発生するまで、永続的に再利用される
- ローカル開発環境における build & start でも同様

### 再検証

再検証には 2 通りある。

- Time-based Revalidation
- On-demand Revalidation

### オプトアウト（キャッシュ機能の無効化）

1. **`fetch` 関数に以下のどちらかを指定する。**

   ```ts
   // 個々の `fetch` リクエストに対するキャッシュをオプトアウトする。
   fetch(`https://...`, { cache: "no-store" });
   fetch(`https://...`, { next: { revalidate: 0 } });
   ```

2. **以下を Root Layout から `export` することで、特定の Root Segment のキャッシュを一括でオプトアウトできる**

   ```ts
   // ルートセグメント内のすべてのデータリクエストのキャッシュをオプトアウトする
   export const dynamic = "force-dynamic";
   ```

3. **レンダリングプロセスの中で「動的関数」を使用する**
   「動的関数」を使用すると、そのコンポーネント内で使用した `fetch` はキャッシュされない。
   以下の実装では、動的関数である `cookies` を使用しているため、`fetch` 関数は明示的なオプトアウトをしていないにも関わらず、「動的データ取得」として扱われる。

   ```ts
   import { cookies } from "next/headers";

   export function Page() {
     const cookieStore = cookies();

     const res = await fetch(`https://...`);  // 動的データ取得
     const data = await res.json();

     return (
      // 省略
     )
   }
   ```

   しかし、`fetch` 関数で `{ cache: "force-cache" }` の指定や [`export const fetchCache = "force-cache"` の利用](https://ja.next-community-docs.dev/docs/app-router/api-reference/file-conventions/route-segment-config?_highlight=dynamic#fetchcache)があると、動的関数が存在しても「静的データ取得」として扱われ、キャッシュが有効になる。

### 対応するリクエストメソッド

GET だけでなく、POST メソッドによるデータ取得もキャッシュされる。
例えば、以下のように GraphQL サーバーから静的データを取得する際などに活用できる。

```ts
fetch("/path/to/graphql", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ query }),
  next: { revalidate: 60 * 60 * 24 },
});
```

### `fetch` 関数以外でキャッシュする方法

Next.js が提供する `unstable_cache` 関数を使用する。
第一引数に渡す「非同期関数」の戻り値がキャッシュされる。

```ts
import { getUser } from "./data";
import { unstable_cache } from "next/cache";

const getCahrdUser = unstable_cache(async (id) => getUser(id), ["my-app-user"]);

export default async function Component({ userID }) {
  const user = await getCachedUser(userID);
  // ...省略
}
```

## Full Route Cache

- 各 Route のレスポンスを永続的にキャッシュする
- 具体的には、「RSC ペイロード」と「HTML」をキャッシュする

![](https://storage.googleapis.com/zenn-user-upload/5f69662e55a7-20240519.png)
SSG と同じイメージ。

### 特徴

- ビルド時 or 再検証のタイミングでデータフェッチ&レンダリングする
- RSC ペイロードと HTML をキャッシュする
- 再ビルドすると破棄される
- キャッシュされるのは「静的レンダリング」のみ
- 異なるユーザー間で共有される

### キャッシュの保存期間

- デフォルトでは永続的に保存される
- 再ビルドすると破棄される
- 再検証によるキャッシュ更新が可能

### 再検証

再検証のタイミングは 2 つ。

- Data Cache の再検証時
- 再ビルド時

### オプトアウト（キャッシュ機能の無効化）

オプトアウトする方法は 2 つ。

1. **動的レンダリングにする**
   - [動的関数](https://ja.next-community-docs.dev/docs/app-router/building-your-application/caching/#%E5%8B%95%E7%9A%84%E9%96%A2%E6%95%B0)を使うなどしてブラウザリクエストの度にレンダリングが必要な状態にする
   - [`dynamic = "force-dyamic"`](https://ja.next-community-docs.dev/docs/app-router/api-reference/file-conventions/route-segment-config?_highlight=dynamic#dynamic) または [`revalidate = 0`](https://ja.next-community-docs.dev/docs/app-router/api-reference/file-conventions/route-segment-config?_highlight=dynamic#revalidate) を使用して、強制的に動的レンダリングさせる
2. **Data Cache をオプトアウトする**
   レンダリング時にデータ取得が必要な場合、Data Cache をオプトアウトすることで Full Route Cache もオプトアウトされる。ルートにキャッシュされない `fetch` リクエストがある場合、Full Route Cache から除外される。

## Router Cahce

- クライアント側で RSC ペイロードをキャッシュする
- ブラウザのメモリ上にキャッシュされる
- HTML はキャッシュしない

![](https://storage.googleapis.com/zenn-user-upload/55813d509fb3-20240519.png)

### キャッシュの保存期間

一定期間が経過すると、自動で破棄される。所用時間は、レンダリングが静的か動的かによって異なる。

- 動的レンダリング：30 秒
- 静的レンダリング：5 分

### 再検証

3 つの手法がある。

1. **`router.refresh` で新規にリクエストを送信する**
   - `useRouter` の `refresh` 関数を使用することで、ルートを手動で更新できる
   - これは Router Cache を完全にクリアし、現在のルートに対して新たなリクエストを送信する
2. **Server Action 内で `cookies.set` または `cookies.delete` を使用する**
3. **Server Action 内で On-demand Revalidation を実施する**

- 手法 2 は、古い Full Route Cache や Data Cache に HIT する場合があるため、最新の結果がレンダリングされるとは限らない

### オプトアウト（キャッシュ機能の無効化）

- **オプトアウトできない**
- 必ずキャッシュされる

### Link prefetch

`<Link>` コンポーネントは、遷移先のページをプリフェッチする。
これにより、ナビゲーションが高速になり、より良い UX を提供できる。

プリフェッチの流れは以下の図の通り。
![](https://storage.googleapis.com/zenn-user-upload/e21c6e911019-20240519.png)
`<Link>` コンポーネントがユーザーのビューポートに表示されると、自動的にプリフェッチされる。
プリフェッチの動作は、静的ルートと動的ルートで異なる。

- **静的ルート** :
  - デフォルトでルート全体がプリフェッチされ、キャッシュされる
- **動的ルート** :
  - 直近の loading.js ファイルまでの共有レイアウトのみをプリフェッチし 30 秒間キャッシュする
  - つまり、ルートレイアウトやネストされた `layout.ts` のみがプリフェッチの対象となる

`<Link>` には `preferch` prop を指定できる

- デフォルトでは `true`
- `true` を（明示的に？）指定すると、動的ルートであってもキャッシュ保存期間が 5 分になる。
- `false` に指定すると、プリフェッチはオプトアウトされ、静的ルートであってもキャッシュ保存期間が 30 秒となる。

https://zenn.dev/frontendflat/articles/nextjs-prefetch

### 注意点

Route Cache はオプトアウトする手段がないため、動的ルートであっても最低 30 秒はキャッシュされる。
そのため、表示するデータの更新を即座に反映できない可能性がある。

## Data Cache と Full Route Cache

- Data Cache をオプトアウトすると、Full Route Cache が無効になる
- Full Route Cache のオプトアウトは Data Cache に影響しない

## Next.js v15 では起こる破壊的な変更

https://nextjs.org/blog/next-15-rc

https://zenn.dev/akfm/articles/nextjs-cache-default-update
