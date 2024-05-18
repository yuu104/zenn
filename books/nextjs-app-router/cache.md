---
title: "キャッシュ"
---

App Router では、「レンダリング結果」と「データフェッチ結果」をデフォルトでキャッシュする機能が備わっている。
キャッシュの種類は以下 4 つ。

- Request Memoization
- Data Cache
- Full Route Cache
- Router Cache

| 種類                | キャッシュ対象                             | 保管場所                                         | 目的                                                      | キャッシュ期間                   |
| ------------------- | ------------------------------------------ | ------------------------------------------------ | --------------------------------------------------------- | -------------------------------- |
| Request Memoization | `fetch` 関数の戻り値（データフェッチ結果） | Server                                           | Route Segment（コンポーネントツリー）でデータを再利用する | ブラウザリクエストごと           |
| Data Cache          | データフェッチ結果                         | ブラウザリクエスト・デプロイをまたぐデータの保存 | 永久的（再検証可能）                                      |
| Full Route Cache    | HTML, RSC Payload                          | Server                                           | レンダリングコストの削減                                  | 永久的（再検証可能）             |
| Router Cache        | RSC Payload                                | Client                                           | ナビゲーション時のブラウザリクエスト削減                  | ユーザーセッション or 時間ベース |

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
