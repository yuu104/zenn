---
title: "React Server Componentsを理解する"
emoji: "📌"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [react, nextjs, typescript]
published: false
---

## はじめに

- React18 から、React Server Components（RSC）が登場した
- Next.js13 では、RSC を標準サポートしている

## CSR の復習

React では CSR 戦略が用いられてきました。
CSR では、クライアントが受け取るのは次のような中身のない空の HTML ファイルでした。

```html
<!DOCTYPE html>
<html>
  <body>
    <div id="root"></div>
    <script src="/static/js/bundle.js"></script>
  </body>
</html>
```

`bundle.js` には、React アプリケーションを構築するために必要なものが全て含まれています。

JS がダウンロードされて解析が完了すると、React が動作し始め、アプリケーション全体のすべての DOM ノードを呼び出し、それを空の `<div id="root">` に格納します。

![](https://storage.googleapis.com/zenn-user-upload/546bc9f4a9a1-20240506.png)
_引用：https://nextjs.org/learn-pages-router/basics/data-fetching/pre-rendering_

### 処理の流れ

1. クライアントからリクエストが送られる
2. サーバから空の HTML と共に、CSS、JS が送信される
3. JS で UI を構築し、必要なデータは API を叩いてフェッチする

![](https://storage.googleapis.com/zenn-user-upload/d2dc28e22865-20240506.png)

### 問題点

とてもシンプルではありますが、CSR には**JS バンドルが大きく、UI の初期表示に時間がかかる** という問題があります。
UI が表示されるまでの間、ユーザーは白い画面を見続けることになります。そして、この問題は開発が進み JS のコード量が大きくなるにつれて悪化する傾向にあります。

## Web ページのパフォーマンス指標

Web ページのパフォーマンス指標として、以下があります。

1. **FCP（First Contentful Paint）**

   - ブラウザが最初のテキストや画像などのコンテンツを描画するまでの時間
   - 真っ白な画面ではなく、何かしらの表示（レイアウトなど）がある状態

2. **LCP（Largest Contentful Paint）**

   - ページの主要なコンテンツが表示されるまでの時間
   - ユーザが関心のあるコンテンツが含まれている
   - DB からデータを取得し、UI にレンダリングされた状態

3. **TTI（Time To Interactive）**
   - ページが完全にインタラクティブになるまでの時間
   - React がダウンロードされ、アプリケーションがレンダリングされ、ハイドレーションが行われる
   - ページ上の UI コンポーネントが反応し始め、ユーザーが入力できる状態

CSR では、FCP が遅くなってしまうのが問題です。そして、この問題を解決するのが SSR です。

## SSR の復習

CSR の問題を解決するために設計されたアプローチです。
空の HTML ファイルを送信する代わりにサーバー側で初期の HTML を生成し、ハイドレーション用のミニマルな JS と共にクライアントへ送信します。
HTML には CSR と同様に `<script>` タグが含まれており、その JS でハイドレーションが行われ、サイトがインタラクティブな状態になります。

![](https://storage.googleapis.com/zenn-user-upload/3f2814cdba3f-20240506.png)
_引用：https://nextjs.org/learn-pages-router/basics/data-fetching/pre-rendering_

SSR では初期ロードの時点である程度のコンテンツが表示されるため、バンドルされた JS がダウンロードされ解析されている間でも、ユーザーは真っ白なページを見続ける必要はありません。そのため、CSR と比べて FCP が改善します。

### 処理の流れ

1. クライアントからリクエストが送られる
2. 初期表示に必要なデータをサーバ側で API コール
3. API からのレスポンスによりデータを取得
4. サーバ側でレンダリングを行い、HTML を生成
5. HTML、CSS、JS をクライアントに送信
6. クライアントは HTML を表示し、ロードした JS を実行してハイドレードする

![](https://storage.googleapis.com/zenn-user-upload/71fd32295596-20240506.png)

:::details ハイドレーションは何をしているのか？

ハイドレーションとは、バンドルされた JS をクライアント側で実行し、以下 2 つを行う処理のことです。

1. **インタラクティブ性の追加**
   サーバ側で生成された HTML に対し、イベントハンドラーやその他のスクリプトを結び付けます。これにより、静的なページがインタラクティブなアプリケーションとして機能するようになります。
1. **仮想ＤＯＭの生成と実ＤＯＭの同期**
   バンドルされる JS はページのインタラクティブ性を担うものだけではありません。**サーバー側で生成された HTML を基に構築される DOM をクライアント側でも構築するためのコード**も含まれています。
   クライアント側は JS で仮想 DOM を構築し、サーバ側で生成された HTML を基に構築された 実 DOM と比較します。比較によりサーバ側でレンダリングされたコンテンツと、クライアント側でレンダリングされたコンテンツが同一であるかを確認し、同一でなければクライアント側で DOM の再構築が行われます。

詳しくは下記リンクを参照するのがオススメです。
https://zenn.dev/jordan23/articles/05b78f925d35ba
https://qiita.com/Yametaro/items/22cde58cd6abf577f1a4

よって、先程の手順 ④〜⑤ を詳細に説明すると、次のようになります。

1. **サーバー側でのレンダリング**
   - サーバ側で React を実行し、HTML を生成する
2. **インタラクティブ用&DOM 再構築用の JS バンドルを用意**
   - サーバーで生成された HTML に対しインタラクティブ性を追加するためのコード（イベントハンドラなど）と、クライアント側で仮想 DOM を構築し、実 DOM と同期するためのコードが含まれる
3. **HTML とバンドル JS の送信**
   - 生成された HTML と JS バンドルをクライアントに送信する
4. **クライアント側で DOM の構築と表示**
   - サーバーから受け取った HTML を基に DOM を構築し、描画処理を行う
   - この時点において、ページにはインタラクティブ性はないが、すぐにユーザに見える形で表示される
5. **バンドル JS の実行と仮想 DOM の構築**
   - バンドル JS を基に仮想 DOM を構築する
   - 構築した仮想 DOM と実 DOM に不一致がないか比較する
6. **DOM の比較と必要に応じた更新**
   - 比較により不一致があれば DOM を再構築する
7. **インタラクティブ性の追加**
   - バンドル JS を基にスクリプトが DOM 要素に結び付けられ、ページがインタラクティブになる
   - これにより、ユーザがページと対話可能になる

:::

### SSR の魅力

<!-- SSR の大きな利点は、**サーバで直接データを取得し、そのデータを基に UI 構築・HTML 生成ができる**ことです。 -->

SSR の大きな利点は、**FCP だけでなく LCP の改善も可能である**ことです。

SSR ではプリレンダリングにより FCP が改善されています。真っ白な画面ではなく、何かしらの表示（レイアウトなど）がある状態を素早く提供できるようになりました。
![](https://storage.googleapis.com/zenn-user-upload/c381cf09e7be-20240506.png)

しかし、必要なデータをクライアント側で取得している状態だと、LCP は改善されません。
ユーザーはローディング画面を見るためにサイトにアクセスしているのではありません。ユーザーが望むのは、DB から取得した情報が表示されている UI です。

![](https://storage.googleapis.com/zenn-user-upload/dd3076fa8d05-20240506.png)

Next.js をはじめとするフレームワークでは、この問題を解決するために**サーバ側でデータの取得を可能にしています**。

```tsx
// pages/products.js
import axios from "axios";

function Products({ products }) {
  return (
    <div>
      <h1>Available Products</h1>
      <ul>
        {products.map((product) => (
          <li key={product.id}>{product.name}</li>
        ))}
      </ul>
    </div>
  );
}

export async function getServerSideProps() {
  const res = await axios.get("https://api.example.com/products");
  const products = res.data;
  return {
    props: { products }, // will be passed to the page component as props
  };
}

export default Products;
```

`getServerSideProps` はサーバ上で実行される関数であり、JS バンドルには含まれず、クライアントで再実行されることはありません。
これにより、LCP の問題が改善されました。

### SSR の問題点

SSR により、CSR が抱える問題を改善できましたが、まだ問題は残っています。

1. **ページ単位という制限**
   - SSR では、サーバー側でのデータ取得とレンダリングがページ単位でしか機能しません
   - そのため、データ取得などが原因でサーバー側の処理が重くなると、プリレンダリングに時間がかかります
   - SSR ではプリレンダリングが完了するまでブラウザには何も表示されないため、FCP が遅くなる可能性があります
2. **SSR 手法が標準化されていない**
   - SSR は Next.js、Gatsby、Remix などのフレームワークがそれぞれ独自の方法を採用しています
   - この非標準化は、技術選択や移行に際しての複雑性を増大させます
3. **常にクライアント上でハイドレーションを行う**
   - SSR を使用しても、最終的にはクライアント上で JS によるハイドレーションが必要です
   - 全てのコンポーネントは、たとえ不要な場合でも実 DOM との比較のために仮想 DOM の構築処理が行われます

これらの問題を解決するために生み出されたのが React Server Components です。

## React Server Components とは？

React Server Component（RSC）とは、React コンポーネントのレンダリングプロセスにおけるアーキテクチャで、CSR や SSR といったレンダリング手法の問題点を解決するために生まれました。

RSC では、Server Components（SC）という新たな概念を持つコンポーネントが登場します。
SC とは、**サーバー側でのみ実行される**コンポーネントです。サーバー側でのみ実行されるので、**JS バンドルには含まれません**。そのため、SSR の問題点であった「常にクライアント上でハイドレーションを行う」を解決できます。

SC では、以下のように非同期関数で書くことが可能です。

```tsx
export default async function ServerComponent() {
  const res = await fetch("https://example.com/posts");
  const posts = await res.json();

  return (
    <div>
      <h1>投稿一覧</h1>
      <ul>
        {posts.map(() => (
          <li>
            <a href={post.url}>{post.title}</a>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

そのため、「**コンポーネント上から直接**外部 API のデータを取得してレンダリングする」ということが可能になり、**コンポーネント単位でのデータ取得＆レンダリング**をサーバー側で行うことができます。これは、SSR の問題点である「ページ単位という制限」を解決しています。

## クライアントコンポーネント（CC）

SC ではない、従来の React コンポーネントのことです。SC と区別するために、これまでのコンポーネントを CC と呼ぶようになりました。
そのため、**ライアント上でのみ実行されるコンポーネントのことではありません**。
SSR の場合、CC はサーバ側でも実行されるため、**クライアントとサーバの両方で実行できます**。

|     | Renders on server? | Renders on client? |
| --- | ------------------ | ------------------ |
| SC  | ⭕️                | ❌                 |
| CC  | ⭕️                | ⭕️                |

## RSC を採用したレンダリングプロセス

RSC を採用すると、React ツリーは以下のように SC と CC が混在するようになります。
![](https://storage.googleapis.com/zenn-user-upload/e93e24d24658-20230924.png)

ではこの新たなアーキテクチャは一体、どのようなプロセス経てブラウザの画面に描画されるのでしょうか？

RSC のレンダリングは、2 つの段階（stage0 と stage1）に分けて考えることができます。

- stage0 : SC のレンダリング
- stage1 : CC のレンダリング

最初に stage0 である SC がサーバー側で実行され、その後 stage1 である CC がレンダリングされます。stage0 → 　 stage1 の順で段階的に実行されます。この「段階的に実行される」ということを具体例を通して見てみましょう。

```tsx
// Server Component
async function Notes() {
  const notes = await db.notes.getAll();
  return (
    <div>
      {notes.map((note) => (
        <Expandable key={note.id}>
          <p note={note} />
        </Expandable>
      ))}
    </div>
  );
}

// Client Component
export default function Expandable({ children }) {
  const [expanded, setExpanded] = useState(false);
  return (
    <div>
      <button onClick={() => setExpanded(!expanded)}>Toggle</button>
      {expanded && children}
    </div>
  );
}
```

`Notes` は SC、`Expandable` は CC です。2 つのコンポーネントは親子関係にあります。
まず初めに、stage0 を実行して、SC をレンダリングします。すると、以下のような結果となります。

```tsx
<div>
  <Expandable key={1}>
    <p>this is the first note</p>
  </Expandable>
  <Expandable key={2}>
    <p>this is the second note</p>
  </Expandable>
  <!-- 省略 -->
</div>
```

SC である `Notes` コンポーネントが stage0 として実行され、ただの HTML になりました。一方、`Expandable` はコンポーネントのままです。`Expandable` は CC であり、stage1 で実行されるからです。
それでは次に、stage1 を実行して CC をレンダリングします。すると、以下のような結果となります。

```tsx
<div>
  <div>
    <button onClick={イベントハンドラ}>Toggle</button>
    <p>this is the first note</p>
  </div>
  <div>
    <button onClick={イベントハンドラ}>Toggle</button>
    <p>this is the second note</p>
  </div>
  <!--...-->
</div>
```

これですべてのコンポーネントのレンダリングが完了し、HTMl タグに変換されました。
このように、RSC におけるレンダリングは「**多段階計算**」と捉えることができます。（この考え方は[こちらの記事](https://zenn.dev/uhyo/articles/react-server-components-multi-stage)が非常に参考になります）

stage0 は SC のレンダリングなので、**サーバー側でしか実行されません**。
stage1 は CC のレンダリングなので、クライアント側では必ず実行されますが、**場合によってはサーバー側でも実行されます**。
何処で何が実行されるのかは以下のように整理できます。

|                    | サーバー側      | クライアント側 |
| ------------------ | --------------- | -------------- |
| 従来型（SSR なし） | -               | stage1         |
| 従来型（SSR あり） | stage1          | stage1         |
| RSC（SSR なし）    | stage0          | stage1         |
| RSC（SSR あり）    | stage0 + stage1 | stage1         |

「従来型（SSR なし）」は、CSR のことです。クライアント側だけでレンダリングされます。
「従来型（SSR あり）」は、これまでの SSR です。SSR では、一度サーバー側で実行することで HTML を生成し、その後クライアント側で実行してハイドレーションを行います。

従来型は SC が存在しないので、当然 stage0 はありません。従来型と RSC を見比べると、サーバー側に stage0 が追加されただけです。
そのため、RSC は「**従来のレンダリングプロセスの前に新たなステージが追加されたもの**」であると理解できます。

## SC のレンダリングプロセス

stage0 の実行内容である、SC のレンダリングプロセスについて解説します。

:::details React におけるレンダリングプロセスをざっくり復習

1. **React 要素の生成**:

   - `React.createElement` 関数は React 要素を生成
   - React 要素は、オブジェクトの形式で、`type`（コンポーネントの種類や HTML タグなど）、`props`（プロパティや子要素を含む）、および`key`や`ref`などの特別なプロパティを含んでいる

   例として、以下のような計 2 つのコンポーネントの場合、

   ```tsx
   function Greeting({ name }) {
     return <h1 className="greeting">Hello!</h1>;
   }

   export default function App() {
     return <Greeting name="Taylor" />;
   }
   ```

   `createElement` により以下のようなオブジェクトが生成される。

   ```json
   // App
   {
     type: Greeting,
     props: {
      name: 'Taylor'
     },
     key: null,
     ref: null,
   }

   // Greeting
   {
     type: "div",
     {className: "greeting!"},
     "Hello!",
   }
   ```

2. **React ツリーの構築**:
   `React.createElement` によって生成された React 要素は、親子関係を持つツリー構造（React ツリー）を形成します。
   このツリーは、アプリケーション内すべてのコンポーネントの階層関係を表しています。

3. **仮想 DOM の構築**:
   React ツリーは仮想 DOM の基盤となります。仮想 DOM は React ツリーから生成され、それは React が UI の状態を効率的に管理し、変更を追跡するための内部的な表現です。仮想 DOM は、実際の DOM とは独立して操作が行われるため、パフォーマンスが向上します。

4. **Diffing アルゴリズムによる変更点の検出**:
   コンポーネントの状態やプロパティが更新されると、新しい React ツリーが生成され、新旧の仮想 DOM が比較されます。この比較プロセスは、変更が必要な DOM ノードだけを特定するために行われます。

5. **実 DOM への更新**:
   変更が必要な部分が特定された後、React はそれらの変更を実 DOM に反映します。このステップは効率的に行われるため、パフォーマンスの低下を最小限に抑えつつ、ユーザーインターフェースが更新されます。

:::

RSC をレンダリングする時には、以下のような流れになります。

1. サーバがレンダリングリクエストを受け取る
2. サーバが React 要素を生成し、React ツリーを構築する
3. 構築した React ツリーをシリアライズする

SC をレンダリングした（stage0 を実行した）ことによる最終成果物は「**React ツリーをシリアライズしたもの**」です。[Next.js](https://nextjs.org/docs/app/building-your-application/rendering/server-components#how-are-server-components-rendered)では、これを「**RSC ペイロード**と呼称しています」

### 1. サーバがレンダリングリクエストを受け取る

- HTTP リクエストによってコンポーネントのレンダリングが開始する
- サーバは、リクエストに含まれる情報をもとに、使用する SC と props を判断する
- このリクエストは通常、特定の URL でページリクエストの形式で届く
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
  `type` には `"div"` といった文字列が入っているため、既にシリアライズ可能であり、特別な処理は必要ない。
- **SC の場合**
  `type` に指定されている SC 関数とその props を呼び出し、ただの HTML に変換する。
  これは、実質的に SC のレンダリングに相当する。
- **CC の場合**
  CC はサーバではレンダリングされないため、、`type` にはコンポーネント関数ではなく、**モジュール参照オブジェクト**が格納されている。
  これはシリアライズ可能であるため、特別な処理は必要ない。

:::details モジュール参照オブジェクトとは？

RSC では、`React.createElement()` により React 要素を生成する際、 `type` フィールドに「**モジュール参照オブジェクト**」と呼ばれるオブジェクトを導入できる。
これは、コンポーネント関数の代わりに、コンポーネント関数へシリアライズ可能な「**参照**」を渡す。
例えば、`ClientComponent` という要素は以下のようになる。

```tsx
{
  $$typeof: Symbol(react.element),
  // type フィールドが、実際のコンポーネント関数の代わりに参照オブジェクトを持つ
  type: {
    $$typeof: Symbol(react.module.reference),
    // ClientComponent は以下のファイルから default export される
    name: "default",
    // ClientComponent を default export しているファイルのパス
    filename: "./src/ClientComponent.client.js"
  },
  props: { children: "oh my" },
}
```

モジュール参照オブジェクトの変換はバンドラーが行なっている。
SC が CC をインポートする際、実際のインポート対象を取得する代わりに、そのファイル名とエクスポート名が含まれたモジュール参照オブジェクトだけを取得している。

:::

これにより、シリアライズ可能な React ツリーがサーバ側で構築される。
このツリーは、**HTML タグとクライアントコンポーネントへの参照**で構成されている。
![](https://storage.googleapis.com/zenn-user-upload/9213030c02b4-20231015.png =500x)
_引用：https://postd.cc/how-react-server-components-work/_

### 3. 構築した React ツリーをシリアライズする

サーバ側で構築した React ツリーは以下のような形式でシリアライズされ、RSC ペイロードが生成されます。
詳しくは[こちら](https://postd.cc/how-react-server-components-work/#11)の記事を参照。

```
M1:{"id":"./src/ClientComponent.client.js","chunks":["client1"],"name":""}
J0:["$","@1",null,{"children":["$","span",null,{"children":"Hello from server land"}]}]
```

## RSC（SSR なし）のレンダリングプロセス

1. **サーバー側で SC をレンダリング**
   stage0 を実行して SC をレンダリングし、RSC ペイロードを生成します。
2. **空の HTML、CC の JS バンドル、RSC ペイロードをクライアントに送信する**
   SSR なしなので、CSR と同様、空の HTML が返却されます。
   JS バンドルに含まれるのは CC だけです。SC はサーバー側で実行が完了しているため、バンドルには含まれません。
   RSC ペイロードには以下のデータが含まれています。
   - SC のレンダリング結果（HTMl タグなど、DOM を構築するための情報）
   - CC がレンダリングされる場所のプレースホルダと、その JS ファイルへの参照
   - SC から CC に渡されるすべての props
3. **クライアント側で React ツリーを再構築する**
   クライアントは RSC ペイロードとバンドル JS を基に React ツリーの再構築を行います。
   RSC ペイロードの `type` フィールドが CC のモジュール参照である要素に遭遇したら、それを実際の CC 関数への参照に置き換えます。
   :::message
   この置き換え処理は、バンドラーが行なっています。
   バンドラーを用いてサーバ上でクライアントコンポーネントをモジュール参照に置き換えたように、逆の変換もバンドラーが行います。
   :::
   React ツリーが再構築されると、SC により事前計算された HTML タグと CC が混合した状態になります。
   ![](https://storage.googleapis.com/zenn-user-upload/1382ecbd6311-20231015.png =500x)
   _引用 : https://postd.cc/how-react-server-components-work/_
4. **DOM を構築し、描画する**
   あとはこれまで通り、仮想 DOM 構築 → 実 DOM 構築 → 描画を行います。

ここまでの流れを図示すると、以下のようになります。
![](https://storage.googleapis.com/zenn-user-upload/5a214ff7cd8f-20240512.png)

## RSC（SSR あり）のレンダリングプロセス

ここでは Next.js を使用した際にレンダリングプロセスを説明します。
https://nextjs.org/docs/app/building-your-application/rendering/server-components#how-are-server-components-rendered

1. **サーバー側で SC をレンダリング**
   stage0 を実行して SC をレンダリングし、RSC ペイロードを生成します。
2. **RSC ペイロードと CC の JS を使用して、HTML を生成する**
   SSR の場合、サーバー側でも stage1 を実行します。
   ここでは、RSC ペイロードを参照しつつ React ツリーを再構築します。
   その結果を HTML として生成します。
3. **生成した HTML と RSC ペイロード、 CC の JS バンドルをクライアントに送信する**
   SSR では、サーバー側で stage1 を実行した結果である HTML も返却します。 JS バンドルの中身は、SSR なしのときと同様、CC のハイドレーション用です。
4. **クライアントは受け取った HTML をブラウザレンダリングする**
   この HTML は、高速に非インタラクティブなプレビューを表示するために使用されます。
5. **React ツリーを再構築する**
   SSR なしのときと同様、RSC ペイロードと JS バンドルを基に React ツリーを再構築します。
6. **バンドル JS を基に CC をインタラクティブにする**
7. **DOM を構築し、描画する**
   仮想 DOM 構築 → 実 DOM の更新 → 描画を行います。

ここまでの流れを図示すると、以下のようになります。
![](https://storage.googleapis.com/zenn-user-upload/ebf15cd55ea4-20240519.png)

## SC と CC の境界

RSC では、**すべてのコンポーネントが、デフォルトで SC とみなされます**。CC を使用したい場合、`"use client"` ディレクティブを宣言する必要があります。

```tsx
"use client";

export const Button = () => {
  return <button onClick={() => console.log("clicked")}>click me!!</button>;
};
```

`"use client"` は、宣言したファイル内のコンポーネントが CC であり、JS バンドルに含める必要があることを React に知らせます。
SC を使用する際は、 `"use server"` のようなディレクティブを指定する必要はありません。

`"use client"` を宣言するうえで重要なのは、**SC と CC の境界となるコンポーネントファイルで使用する**ことです。すべてのコンポーネントファイルに対し、ディレクティブを宣言する必要はありません。
実は、**CC から import されたコンポーネントは、自動的に CC になります**。
![](https://storage.googleapis.com/zenn-user-upload/e1fcecba7241-20240512.png =500x)
そのため、上記の `IconButton` コンポーネントのような汎用性の高いコンポーネントは SC/CC どちらにもなり得ます。

以上をまとめると、以下になります。

- 何も宣言しなければ SC になる
- `"use client"` を宣言すれば CC になる
- CC に import されると、そのコンポーネントは CC になる

CC 上で SC を import できず、import されたコンポーネントは CC になると説明しました。では、どのようにして 以下のように SC と CC が混在したツリーを実現するのでしょうか？どうすれば、CC の子に SC を配置することができるのでしょうか？
![](https://storage.googleapis.com/zenn-user-upload/34ff396577c8-20240512.png =500x)
_引用 : https://postd.cc/how-react-server-components-work/_
**CC（親）→ 　 SC（子）の関係を実現するには、SC を CC の props として渡します**。

具体的には、React の `children` prop を使用します。

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

`children` には、SC のレンダリング結果が入ります。上記コンポーネントが実行されるときにはすでに stage0 が完了しており、SC は存在しません。

```tsx
// このパターンは動作する：
// Client ComponentのchildまたはpropとしてServer Componentを渡す
import ClientComponent from "./client-component";
import ServerComponent from "./server-component";

export default function Page() {
  return (
    <ClientComponent>
      <ServerComponent />
    </ClientComponent>
  );
}
```

よって、上記のように SC → CC → SC となる場合、クライアント側で `ClientComponent` を実行するときには以下のような状態になっています。

```tsx
<ClientComponent>
  <div>
    <p>SCのレンダリング結果</p>
  </div>
</ClientComponent>
```

図で表すと以下のイメージです。
![](https://storage.googleapis.com/zenn-user-upload/cfbabcffc83e-20240512.png =500x)
_引用 : https://demystifying-rsc.vercel.app/client-components/server-children/_

## RSC の制約

### CC は SC をインポートできない

これまでの内容を理解していれば、当然ですよね。
CC のレンダリングは SC のレンダリング後に行われます。そのため、CC をレンダリングする段階では既に SC は存在せず、ただの HTML 要素に変換されています。
そのため、以下のような使用はできません。

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

## RSC のメリット

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

## Streaming HTML と RSC

### SSR の問題点

SSR の問題点として、「**サーバー側でのデータ取得とレンダリングがページ単位でしか機能しない**」がありました。そのため、以下 2 点の問題を抱えています。

1. **サーバー側での処理が遅れた場合、FCP が遅延する**
   サーバー側で行うデータ取得処理が遅れた場合、HTML の生成・クライアントへの送信も当然遅れます。遅れている間はブラウザには何も映らないため、CSR と同様、真っ白の画面が表示され続けます。
   ![](https://storage.googleapis.com/zenn-user-upload/2db55b228262-20240513.png =600x)
   _引用 : https://nextjs.org/docs/app/building-your-application/routing/loading-ui-and-streaming_

2. **クライアント側で一部のハイドレーションが遅れた場合、TTI が遅延する**
   SSR では、JS がすべてロードされてからハイドレートされます。そのため、ロードする JS のサイズが大きい場合、ハイドレートまでの時間がかかります。
   また、JS ロード後、ハイドレートを開始するとツリー全体に対して処理されるまで終了することができません。既にハイドレードが完了しているヘッダーやナビゲーションがあっても、他のコンポーネントが完了していなければアプリケーションはインタラクティブな状態になりません。

### Streaming HTML の登場

Streaming HTML は、サーバーが HTML を小さな部分（チャンク）に分割して順番にブラウザに送信する技術です。の方法により、ブラウザはページ全体がサーバーから送信されるのを待たずに、受信したチャンクを順に処理し、ユーザーに表示することができます。これにより、FCP がさらに向上し、ユーザー体験が改善されます。
![](https://storage.googleapis.com/zenn-user-upload/dcc8a2f88e2e-20240513.png)
_引用 : https://nextjs.org/docs/app/building-your-application/routing/loading-ui-and-streaming_

Streaming HTML では、優先度の高いコンポーネントやデータに依存しないコンポーネントは最初に送信でき、早期にハイドレーションが開始されます。これにより、TTI も改善されます。

### SC との組み合わせ

SC は従来の SSR では出来なかったコンポーネント単位のデータ取得が可能なため、Streaming HTML との相性が非常に良いです。

```tsx
import { Suspense } from "react";

export default function Home() {
  return (
    <Container>
      <NavBar />
      <SideBar />
      <Suspense fallback={<Spinner />}>
        <ServerComponent />
      </Suspense>
    </Container>
  );
}
```

上記のように `<Suspence />` で SC をラップすることで、`<ServerComponent />` 以外の部分が先に送信され、描画を行います。
`<ServerComponent />` の非同期処理が完了するまでは、`fallback` にしている `<Spinner />` がレンダリングされローディング UI を表示できます。
![](https://storage.googleapis.com/zenn-user-upload/d60f5c4be335-20240513.png)
そして、`<ServerComponent />` の非同期処理・レンダリングが完了すると、追加の HTML を送信します。
![](https://storage.googleapis.com/zenn-user-upload/be423a51ebac-20240513.png)

## SC と CC の使い分け

ポイントとして、**UX を実現するための JS が必要な場合**のみ CC にすると考えれば良いでしょう。UX に関係ないコンポーネントは基本サーバ側の処理だけで完結するので、JS バンドル削減のためにも SC にするのが適切です。

![](https://storage.googleapis.com/zenn-user-upload/eda329f0cc58-20240513.png)
_引用 : https://ja.next-community-docs.dev/docs/app-router/building-your-application/rendering/composition-patterns_

## 参考リンク

https://postd.cc/server-components/

https://postd.cc/how-react-server-components-work/

https://zenn.dev/uhyo/articles/react-server-components-multi-stage

https://nextjs.org/docs/app/building-your-application/rendering/server-components

https://zenn.dev/msy/articles/a042024e12fca1

https://ja.react.dev/reference/rsc/server-components#noun-labs-1201738-(2)

https://demystifying-rsc.vercel.app/

https://ja.react.dev/blog/2021/12/17/react-conf-2021-recap#streaming-server-rendering-with-suspense
