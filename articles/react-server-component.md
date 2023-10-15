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

サーバ側でレンダリングするとはどういうことなのか？
それは、サーバ側で React 要素を生成することである。
サーバはクライアントからの HTTP リクエストをもとに、サーバコンポーネント関数を呼び出し、`React.createElement()` で React 要素を生成する。
そして、生成した React 要素から React ツリーを構築し、クライアントに送信する。
クライアントは受け取った React 要素とクライアントコンポーネントで React ツリーを再構築し、DOM へ反映させる。

![](https://storage.googleapis.com/zenn-user-upload/c65e803902b8-20231015.png)

## SC のレンダリングプロセス

RSC をレンダリングする時には、以下のような流れになる。

1. サーバがレンダリングリクエストを受け取る
2. サーバが React 要素を生成し、React ツリーを構築する
3. 構築した React ツリーをシリアライズしてクライアントへ送信する
4. クライアントが React ツリーを再構築する

### 1. サーバがレンダリングリクエストを受け取る

- RSC を使用する場合、ページのレンダリングは必ずサーバで始まる
- API コールによってコンポーネントのレンダリングが開始する
- 従って、「ルート」コンポーネントは必ず SC であり、他の SC や CC をレンダリングする場合もある
- サーバは、リクエストに含まれる情報をもとに、使用する SC と props を判断する
- このリクエストは通常、特定の URL でページリクエストの形で届く
- URL 内のパスやクエリ文字列が props に対応する

### 2. サーバが React 要素を生成し、React ツリーを構築する

`React.createElement()` により生成されるのは React 要素を構成するオブジェクトである。
`type` には、文字列なら `"div"` のような HTML タグ名が、関数なら React コンポーネントのインスタンスが入る。

```tsx
// <div>oh my</div> を返す場合
> React.createElement("div", { title: "oh my" })
{
  $$typeof: Symbol(react.element),
  type: "div",
  props: { title: "oh my" },
  ...
}

// <MyComponent>oh my</MyComponent> を返す場合
> function MyComponent({children}) {
    return <div>{children}</div>;
  }
> React.createElement(MyComponent, { children: "oh my" });
{
  $$typeof: Symbol(react.element),
  type: MyComponent   // MyComponent 関数への参照 function
  props: { children: "oh my" },
  ...
}
```

`type` に HTML タグではなくコンポーネントを指定した場合、`type`はコンポーネントとして定義した関数を参照する。
しかし、**関数はシリアライズできない**。
そのため、`type` で指定された値がコンポーネント関数である場合、シリアライズ可能な文字列に変換する。

具体的には、`type` に指定された値に対し、以下の処理を行う。

- **HTML タグの場合**
  `type` には `"div"` のような文字列が入っているため、既にシリアライズ可能であり、特別な処理は必要ない。
- **SC の場合**
  `type` に指定されている SC 関数とその props を呼び出し、ただの HTML に変換する。
  これは、実質的に SC のレンダリングに相当する。
- **CC の場合**
  CC はサーバではレンダリングされないため、、`type` にはコンポーネント関数ではなく、**モジュール参照オブジェクト**が格納されている。
  これはシリアライズ可能であるため、特別な処理は必要ない。

#### モジュール参照オブジェクトとは？

RSC では、`React.createElement()` により React 要素を生成する際、 `type` フィールドに「**モジュール参照オブジェクト**」と呼ばれるオブジェクトを導入できる。
これは、コンポーネント関数の代わりに、コンポーネント関数へシリアライズ可能な「**参照**」を渡す。
例えば、`ClientComponent` という要素は以下のようになる。

```tsx
{
  $$typeof: Symbol(react.element),
  // type フィールドが、実際のコンポーネント関数の代わりに参照オブジェクトを持つようになりました
  type: {
    $$typeof: Symbol(react.module.reference),
    // ClientComponent は以下のファイルから default export されます
    name: "default",
    // ClientComponent を default export しているファイルのパス
    filename: "./src/ClientComponent.client.js"
  },
  props: { children: "oh my" },
}
```

モジュール参照オブジェクトの変換はバンドラーが行なっている。
SC が CC をインポートする際、実際のインポート対象を取得する代わりに、そのファイル名とエクスポート名が含まれたモジュール参照オブジェクトだけを取得している。

これにより、シリアライズ可能な React ツリーがサーバ側で構築される。
このツリーは、**HTML タグとクライアントコンポーネントへの参照**で構成されている。
![](https://storage.googleapis.com/zenn-user-upload/9213030c02b4-20231015.png)
引用：https://postd.cc/how-react-server-components-work/

### 3. 構築した React ツリーをシリアライズしてクライアントへ送信する

サーバ側で構築した React ツリーは以下のような形式でシリアライズされる。
詳しくは[こちら](https://postd.cc/how-react-server-components-work/#11)の記事を参照。

```
M1:{"id":"./src/ClientComponent.client.js","chunks":["client1"],"name":""}
J0:["$","@1",null,{"children":["$","span",null,{"children":"Hello from server land"}]}]
```

### 4. クライアントが React ツリーを再構築する

クライアントはシリアライズ結果を受け取り、ブラウザでレンダリングするために React ツリーの再構築を行う。
`type` がモジュール参照である要素に遭遇したら、それを実際のクライアントコンポーネント関数への参照に置き換える。

この置き換え処理は、バンドラーが行なっている。
バンドラーを用いてサーバ上でクライアントコンポーネントをモジュール参照に置き換えたように、逆の変換もバンドラーが行う。

React ツリーが再構築されると、以下のような純粋な HTML タグとクライアントコンポーネントが混合した状態になる。
![](https://storage.googleapis.com/zenn-user-upload/1382ecbd6311-20231015.png)
引用：https://postd.cc/how-react-server-components-work/

あとは、普段通りこのツリーをレンダリングし、DOM をコミットするだけ。

## RSC の制約

### ルートコンポーネントは必ず RSC

- RSC を使用する場合、レンダリングの一部はサーバが行う必要がある
- そのため、ページのレンダリングは必ずサーバで始まる
- したがって、「ルート」コンポーネントは必ず SC である必要がある

### CC は SC をインポートできない

SC はブラウザ上で実行できず、ブラウザ上では機能しないコードが含まれる可能性がある。
したがって、以下のように CC 上で SC をインポートしてレンダリングすることはできない。

```tsx
"use client";

// You cannot import a Server Component into a Client Component.
import ServerComponent from "./Server-Component";

export default function ClientComponent({
  children,
}: {
  children: React.ReactNode;
}) {
  const [count, setCount] = useState(0);

  return (
    <>
      <button onClick={() => setCount(count + 1)}>{count}</button>

      <ServerComponent />
    </>
  );
}
```

しかし、SC を CC の props として渡すことはできる。

```tsx
"use client";

import { useState } from "react";

export default function ClientComponent({
  children,
}: {
  children: React.ReactNode;
}) {
  const [count, setCount] = useState(0);

  return (
    <>
      <button onClick={() => setCount(count + 1)}>{count}</button>
      {children}
    </>
  );
}
```

```tsx
// This pattern works:
// You can pass a Server Component as a child or prop of a
// Client Component.
import ClientComponent from "./client-component";
import ServerComponent from "./server-component";

// Pages in Next.js are Server Components by default
export default function Page() {
  return (
    <ClientComponent>
      <ServerComponent />
    </ClientComponent>
  );
}
```

### props は全てシリアライズ可能であること

- SC はシリアライズされるため、子コンポーネントや HTML タグに渡す props もシリアライズ可能でなければならない
- つまり、SC からイベントハンドラを props として渡すことはできない

```tsx
// 悪い例: サーバーコンポーネントは props として子孫コンポーネントに関数を渡すことができません。なぜなら関数はシリアライズできないからです。
function SomeServerComponent() {
  return <button onClick={() => alert("OHHAI")}>Click me!</button>;
}
```

### その他の制約

- インタラクティブ機能とイベントリスナーを使用できない
- 状態管理（`useState`）や副作用（`useEffect`）は使用できない
- ブラウザ専用の API を使用できない

## Next.js における RSC のレンダリングプロセス

Next.js の公式ドキュメントによると、Next.js における SC のレンダリング手法は以下の通り。

**サーバ側**

1. React がサーバ側で RSC ペイロード形式にレンダリング
2. Next.js が RSC ペイロードと CC の js 命令を使用し、サーバ上で HTML を生成する

**クライアント側**

1. サーバで生成した HTML を高速で表示する（非インタラクティブなプレビュー）
2. RSC ペイロードがクライアントとサーバのコンポーネントツリーを調整し、DOM を更新する
3. クライアントが HTML を使用して非インタラクティブなページを表示する
4. js ファイルを実行し、CC をハイドレートし、アプリケーションをインタラクティブにする

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

### 設計面のメリット

「**データの取得処理とそのデータを用いた DOM の表現が簡潔になる**」

これまでは、データフェッチは以下のような実装を行う必要があった。

```tsx
const Component = (id) => {
  const [data, setData] = useState(null);

  useEffect(() => {
    axios.get(`/endpoints/${id}`).then((result) => {
      setData(result.data);
    });
  }, []);

  return data ? <div>Hello {data.name}</div> : null;
};
```

上記では、データ取得 → 表示までに

- 状態（`useState`）
- 副作用（`useEffect`）

という二つの概念を意識して実装する必要がある。

また、このコードはブラウザで実行されるため、

- DB へ直接アクセスできない
- 故に、API を用意してアクセスする必要がある

という問題がある。

SC ではこの「データアクセス → 　 DOM を構築」というプロセスをより簡潔かつコンポーネントという単位に閉じた実装が可能になる。

```tsx: Server Componentの実装
const ServerComponent = async ({ id }) => {
  const { data } = await axios.get(`/endpoints/${id}`)

  return(
    <ClientComponent data={data} />
  )
}
```

```tsx: Client Componentの実装
const ServerComponents = ({ data }) => {
  return <div>Hello {data.name}</div>;
};
```

## SSR との違い

SSR と RSC は根本的が概念が異なるが、ブラウザ側からみると、

- SSR はサーバで生成した**HTML**を返す
- RSC はサーバで生成した**コンポーネントをペイロードしたもの**を返す

データフェッチの観点から比較すると、

- SSR はページ単位でデータ取得
- RSC はコンポーネント単位でデータ取得

## 使用ケース

SC と CC の使い分けの判断基準は、
**サーバで処理した方が効率が良いコンポーネントかどうか？**
という部分になる。
![](https://storage.googleapis.com/zenn-user-upload/6451055ce774-20230924.png)

それぞれのざっくりな役割は

- SC はデータの取得やコンテンツのレンダリング
- CC はインタラクティブな UI の実現

## 参考リンク

https://qiita.com/naruto/items/c17c79ec5c2a0c7c4686

https://zenn.dev/sumiren/articles/f39a151e7320d5

https://postd.cc/how-react-server-components-work/

https://zenn.dev/uhyo/articles/react-server-components-multi-stage

https://qiita.com/getty104/items/74d975ff02bdf4fa9b2b

https://zenn.dev/izumin/articles/bc47e189e25874

https://nextjs.org/docs/app/building-your-application/rendering/server-components
