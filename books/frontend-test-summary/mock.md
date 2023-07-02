---
title: "モック"
---

## モックとは？

- ソフトウェアのテストで使われる仮想的なもの
- 実際のオブジェクトやシステムの代わりに使われる
- 本物のものと同じように動作するが、中身は単純になる
- テストの際に依存するものや、時間がかかる操作やリソースを置き換えることができる
- 異なるテストケースを作成することができる
- ソフトウェアのテストを効率的に行うために重要な役割を果たす

## モックを使用する目的

### テストを実行環境と同様の状況に近づけることで忠実性の高いテストを行う

テストを実行する際に、実際の実行環境に近い状況を再現することでテスト結果の信頼性と再現性を高めることができる。
これにより、実際のユーザが直面する可能性のある問題やバグを正確に検出できる。

### 実行に時間がかかるケースや環境構築が難しいケースに対応する

テストによっては、実行に時間がかかる要素や環境構築が複雑な要素が含まれる場合がある。
これらの要素を全て実際の状況でテストするのは非効率であり、実行時間を大幅に増やす可能性がある。
モックを使用することで、これらの要素をシュミレートして迅速かつ効率的に実行することができる。
モックは、データ取得の失敗をシミュレートすることで、エラー処理のテストを実施する手段となる。

### Web API などのデータ取得時に発生する「失敗」のテストを可能にする

テストにコストがかかるケースの代表例が Web API で取得したデータを扱う場面である。
Web API からデータを取得する場合、ネットワークエラーやサーバーエラーなどの問題によってデータ取得が失敗する可能性がある。
これに対処するために、失敗した場合の処理やエラーハンドリングをテストする必要がある。

## スタブとスパイ

「スタブ」「スパイ」とは、モックをそれぞれの目的に応じて分類したオブジェクトの呼称である。テストにおいて特定の役割や機能を持っている。

### スタブ

- スタブの目的は「代用」を行うこと。
- テスト時に他のオブジェクトやシステムとの依存関係を置き換えるために使用される
- 事前に定義された応答やデータを返すだけで、特定の操作や機能の振る舞いを単純化している
- 例えば、ネットワークリクエストをシュミレートする場合、スタブは事前に用意された応答データを返すことで、ネットワーク通信を模倣する
- スタブはテストケースごとに設定され、特定の条件やシナリオに対する応答を提供する

### スパイ

- スパイの目的は「記録」を行うこと。
- テスト中にオブジェクトやシステムの振る舞いや状態を監視・記録するために使用される。
- テストの際に、スパイはメソッドの呼び出し回数や引数、戻り値などの情報を収集し、テスト結果の評価や検証に利用される
- スタブとは異なり、振る舞い自体を変更することはしない

## モックモジュールを使用したスタブ

Jest のモックモジュールを使用し、依存モジュールのスタブを適用してみる。
単体テストや結合テストを実施する際、未実装だったり都合の悪いモジュールが依存関係に含まれている場合がある。モックを用いて代用品に置き換えることでテスト不能だった対象のテストが実施できるようになる。
![Jest Runnerのインストール前後の比較](/images/frontend-test-summary/mock-module-stub.png)

### テスト対象の関数

```ts: greet.ts
export function greet(name: string) {
  return `Hello! ${string}.`;
}

// `Good bye, ${name} See you.` という文字列を返す
export function sayGoodBye(name: string) {
  throw new Error("未実装");
}
```

`sayGoodBy`は引数として`name`を受け取り、`Good bye, ${name} See you.` という文字列を返す関数である。
しかし、現状は未実装になっており、テストを実施するにあたり都合の悪い実装である。
そのため、この場合`sayGoodBy`関数のみをテスト限定の代用品に置き換える必要がある。

### `greet`関数をテストする

```ts
import { greet } from "./greet";

test("挨拶を返す", () => {
  expect(greet("Taro")).toBe("Hello! Taro.");
});
```

`greet`関数は実装済みであるため、 `greet.ts`から import すれば意図通りにテストが成功する。

### `sayGoodBy`関数もテストする

```ts
import { sayGoodBye } from "./greet";

jest.mock("./greet", () => ({
  sayGoodBye: (name: string) => `Good bye, ${name}`,
}));

// greet関数の戻り値はundefinedになるため、テストは失敗する
test("挨拶を返す", () => {
  expect(greet("Taro")).toBe("Hello! Taro.");
});

test("さよならを返す（本来の実装ではない）", () => {
  const message = sayGoodBye("Taro");
  expect(message).toBe("Good bye, Taro");
});
```

上記の例では、`jest.mock`関数を使用して`sayGoodBye`関数をスタブに置き換えている。
第一引数にはモック化するモジュールのパスを指定する。指定したパスにある関数がスタブに置き換わる。
第二引数には代用品に実装を施す関数で、`sayGoodBye`関数を置き換えている。本来は Error がスローされる実装となっていたが、`Good bye, ${name}`の文字列を返す関数に置き換わる。
しかし、第二引数で指定しなかった関数は、代用品に何も実装を施さないことになり、戻り値が`undefined`になる。これでは本来実装されている`greed`関数が期待通りの値を返さなくなってしまう。
そのため、以下のようにモジュールの一部をスタブに置き換えるように実装する必要がある。

### モジュールの一部をスタブに置き換える

```ts
import { greet } from "./greet";

jest.mock("./greet", () => ({
  ...jest.requireActual("./greet"),
  sayGoodBye: (name: string) => `Good bye, ${name}.`,
}));

test("挨拶を返す", () => {
  expect(greet("taro")).toBe("Hello! taro");
});

test("さよならを返す（本来の実装ではない）", () => {
  const message = `${sayGoodBye("Taro")} See you.`;
  expect(message).toBe("Good bye, Taro. See you.");
});
```

`jest.requireActual`関数は、指定したモジュールの実際の実装を返す。
`jest.requireActual`関数を使用することで、モジュール本来の実装を代用品の実装に適用することができる。
これにより、`sayGoodBye`関数のみ代用品に置き換えることができる。

## Web API のモック基礎

Web API に関連するコードは、Web API クライアントを代用品（スタブ）に置き換えることでテストを書くことができる。
スタブは本物の API レスポンスではないが、レスポンス前後の「関連コード」を検証するには有効な手段になる。
![](/images/frontend-test-summary/web-api-stab-by-mock-module.png)

### Web API クライアント

```ts:fetchers.ts
export type Profile = {
  id: string;
  name?: string;
  age?: number;
  email: string;
};

export function getMyProfile(): Promise<Profile> {
  return fetch("https://myapi.testing.com/my/profile").then(async (res) => {
    const data = await res.json();

    if (!res.ok) {
      throw data;
    }
    return data;
  });
}
```

### テスト対象関数

```ts
import { getMyProfile } from "./fetchers";

export async function getGreet() {
  const data = await getMyProfile();
  if (!data.name) {
    // ①名前がなけれは、定型分を返す
    return "Hello, anonymous user!";
  }
  // ②名前を含んだ挨拶を返す
  return `Hello, ${data.name}!`;
}
```

`getMyProfile`関数では API リクエストが発生する。
そのため、リクエストに応える API サーバーが存在しなければ、`getGreet`関数をテストすることができない。
そこで、`getMyProfile`関数をスタブに置き換えることにより、データ取得に関わるテストが書けるようになる。

### `jest.spyOn`による Web API クライアントのスタブ実装

`jest.mock`を使用したスタブ実装とは別の実装方法として、TypeScript と親和性の高い`jest.spyOn`を使用する。
`jest.spyOn`を使用する場合、テストファイル冒頭で`jest.mock`により対象モジュールをモック化する必要がある。

```ts
import * as Fetchers from "./fetchers";

jest.mock("./fetchers");
```

次に、`jest.spyOn`でモック化対象の関数を置き換える。

```ts
jest.spyOn(対象のモジュール, 対象の関数名称);
jest.spyOn(Fetchers, "getMyProfile");
```

`対象オブジェクト`とは、`import * as`で読み込んだ`Fetcher`を指す。
`対象の関数名称`とは、ここでは`getMyProfle`という関数名称を指す。
もし`Fetchers`に定義されていない関数名称を指定した場合、TypeScript の型エラーとなる。

### データ取得成功を再現するテスト

`mockResolvedValueOnce`によりモック化した`getMyProfile`関数に対してスタブを実装する。

```ts
jest.spyOn(Fetchers, "getMyProfile").mockResolvedValueOnce({
  id: "xxxxxxx-123456",
  email: "taroyamada@myapi.testing.com",
});
```

**① 名前がなければ、定型文を返す**場合のテストは次のようになる。

```ts
test("データ取得成功時：ユーザー名がない場合", async () => {
  // getMyProfile が resolve した時の値を再現
  jest.spyOn(Fetchers, "getMyProfile").mockResolvedValueOnce({
    id: "xxxxxxx-123456",
    email: "taroyamada@myapi.testing.com",
  });

  await expect(getGreet()).resolves.toBe("Hello, anonymous user!");
});
```

`mockResolvedValueOnce`に`name`を追加すれば **② 名前を含んだ挨拶を返す** 場合のテストになる。

```ts
test("データ取得成功時：ユーザー名がある場合", async () => {
  jest.spyOn(Fetchers, "getMyProfile").mockResolvedValueOnce({
    id: "xxxxxxx-123456",
    email: "taroyamada@myapi.testing.com",
    name: "taroyamada",
  });

  await expect(getGreet()).resolves.toBe("Hello, taroyamada!");
});
```

### データ取得失敗を再現するテスト

`getMyProfile`で呼び出している API からのレスポンス HTTP ステータスが 200〜299 の範囲外の場合（`res.ok`が falsy な場合）、関数内部で例外がスローされる。
例外がスローされることにより、`getMyProfile`関数が返す Promise は reject される。

```ts
export function getMyProfile(): Promise<Profile> {
  return fetch("https://myapi.testing.com/my/profile").then(async (res) => {
    const data = await res.json();

    if (!res.ok) {
      throw data;
    }
    return data;
  });
}
```

`myapi.testing.com`から 200 番台以外のレスポンスは、以下のようなエラーオブジェクトが返ってくると定められている。
つまり、上記の例外としてスローしている`data`に相当する。

```ts
export const httpError: HttpError = {
  err: { message: "internal server error" },
};
```

そのため、`getMyProfile`関数の reject を再現するスタブを`mockRejectedValueOnce`で以下のように実装できる。

```ts
jest.spyOn(Fetchers, "getMyProfile").mockRejectedValueOnce(httpError);
```

これで、`getMyProfile`関数がデータ取得に失敗した場合の`getGreet`関数の振る舞いをテストすることができる。

```ts
test("データ取得失敗時", async () => {
  // getMyProfile が reject した時の値を再現
  jest.spyOn(Fetchers, "getMyProfile").mockRejectedValueOnce(httpError);

  await expect(getGreet()).rejects.toMatchObject({
    err: { message: "internal server error" },
  });
});
```

例外がスローされることを検証したい場合は以下のように書くこともできる。

```ts
test("データ取得失敗時、エラー相当のデータが例外としてスローされる", async () => {
  expect.assertions(1);
  jest.spyOn(Fetchers, "getMyProfile").mockRejectedValueOnce(httpError);
  try {
    await getGreet();
  } catch (err) {
    expect(err).toMatchObject(httpError);
  }
});
```

## Web API のレスポンスデータを切り替える関数を作成してテストする

先程は各テストごとに`jest.spyOn`を書いていた。
レスポンスデータの切り替えを可能にするユーティリティ関数を使用すれば`jest.spyOn`をテストごとに書く必要がなくなる。

### テスト対象の関数

`getMyArticleLinksByCategory`はログインユーザが投稿した記事データから指定したカテゴリーに該当する記事のリンク及びタイトルを取得する関数。

```ts
import { getMyArticles } from "../fetchers";

export async function getMyArticleLinksByCategory(category: string) {
  // データを取得する関数
  const data = await getMyArticles();
  // 取得したデータのうち、指定したタグが含まれる記事に絞り込む
  const articles = data.articles.filter((article) =>
    article.tags.includes(category)
  );
  if (!articles.length) {
    // 該当記事がない場合、null を返す
    return null;
  }
  // 該当記事がある場合、一覧向けに加工したデータを返す
  return articles.map((article) => ({
    title: article.title,
    link: `/articles/${article.id}`,
  }));
}
```

`getMyArticles`は記事データ取得の Web API クライアントで、以下の型定義にある`Articles`を返す。

```ts
export type Article = {
  id: string;
  createdAt: string;
  tags: string[];
  title: string;
  body: string;
};

export type Articles = {
  articles: Article[];
};
```

この関数に対して、以下の項目をテストする。

- 指定したタグを持つ記事が一件もない場合、`null`が返る
- 指定したタグを持つ記事が一件以上ある場合、リンク及びタイトル一覧が返る
- データ取得に失敗した場合、例外がスローされる

### レスポンスを切り替える関数（モック生成関数）を実装する

テスト対象の関数は Web API クライアント（`getMyArticle`関数）を利用しており、テスト時はこの関数を。
そのため、レスポンスを再現するデータを用意する。
このようなテスト用データを**フィクスチャー**と呼ぶ。

```ts
export const getMyArticlesData: Articles = {
  articles: [
    {
      id: "howto-testing-with-typescript",
      createdAt: "2022-07-19T22:38:41.005Z",
      tags: ["testing"],
      title: "TypeScript を使ったテストの書き方",
      body: "テストを書く時、TypeScript を使うことで、テストの保守性が向上します…",
    },
    {
      id: "nextjs-link-component",
      createdAt: "2022-07-19T22:38:41.005Z",
      tags: ["nextjs"],
      title: "Next.js の Link コンポーネント",
      body: "Next.js の画面遷移には、Link コンポーネントを使用します…",
    },
    {
      id: "react-component-testing-with-jest",
      createdAt: "2022-07-19T22:38:41.005Z",
      tags: ["testing", "react"],
      title: "Jest ではじめる React のコンポーネントテスト",
      body: "Jest は単体テストとして、UIコンポーネントのテストが可能です…",
    },
  ],
};

export const httpError: HttpError = {
  err: { message: "internal server error" },
};
```

モック生成関数をフィクスチャーを使用して実装する。
この関数は`getMyArticles`をスタブ化する際に必要なセットアップを、必要最小限のパラメータで切り替え可能にする。
このユーティリティ関数を使用すれば`jest.spyOn`をテストごとに書く必要がなくなる。

```ts
function mockGetMyArticles(status = 200) {
  if (status > 299) {
    return jest
      .spyOn(Fetchers, "getMyArticles")
      .mockRejectedValueOnce(httpError);
  }
  return jest
    .spyOn(Fetchers, "getMyArticles")
    .mockResolvedValueOnce(getMyArticlesData);
}
```

### 指定したタグを持つ記事が一件もない場合、`null`が返る

```ts
test("指定したタグをもつ記事が一件もない場合、null が返る", async () => {
  mockGetMyArticles();
  const data = await getMyArticleLinksByCategory("playwright");

  expect(data).toBeNull();
});
```

あらかじめ用意したフィクスチャーには`playwright`というタグが含まれた記事は存在しないため、レスポンスは`null`になる。

### 指定したタグを持つ記事が一件以上ある場合、リンク及びタイトル一覧が返る

```ts
test("指定したタグをもつ記事が一件以上ある場合、リンク一覧が返る", async () => {
  mockGetMyArticles();
  const data = await getMyArticleLinksByCategory("testing");

  expect(data).toMatchObject([
    {
      link: "/articles/howto-testing-with-typescript",
      title: "TypeScript を使ったテストの書き方",
    },
    {
      link: "/articles/react-component-testing-with-jest",
      title: "Jest ではじめる React のコンポーネントテスト",
    },
  ]);
});
```

フィクスチャーには`testing`というタグを含んだ記事が 2 件用意されているのでテストは成功する。

### データ取得に失敗した場合、例外がスローされる

```ts
test("データ取得に失敗した場合、reject される", async () => {
  mockGetMyArticles(500);

  await getMyArticleLinksByCategory("testing").catch((err) => {
    expect(err).toMatchObject({
      err: { message: "internal server error" },
    });
  });
});
```

`mockGetMyArticles`関数の引数に 300 以上の数値を指定することでリクエスト失敗時のレスポンスになる。
そのため、`getMyArticleLinksByCategory`関数は reject されるのでテストは成功する

## モック関数を使ったスパイ

スパイとは「テスト対象にどのような入出力が生じたか？」を記録するオブジェクトであり、記録された値を検証することで、意図通りの挙動となっているかを確認する。

### モック関数

モック関数は、テスト中に本物の関数やメソッドを置き換えるための、テスト用の偽物の関数で、関数が呼び出されたかどうか、どのような引数で呼び出されたか、関数が返す値などの情報を記録し、検証することができる。

### 関数が実行されたことを検証する

`jest.fun`を使用してモック関数を作成する。
作成したモック関数は、テストコードで関数として使用する。
これにより、関数が期待通りに呼び出されたか、どのような引数で呼び出されたか、関数が返す値は何かを検証することができる。

下記のテストでは、マッチャーの`toBeCalled`を使って検証することで、実行されたか否かを判定できる。

```ts
test("モック関数は実行された", () => {
  const mockFn = jest.fn();
  mockFn();
  expect(mockFn).toBeCalled();
});

test("モック関数は実行されていない", () => {
  const mockFn = jest.fn();
  expect(mockFn).not.toBeCalled();
});
```

### 実行された回数を記録する

マッチャーの`toHaveBeenCalledTimes`を使って検証することで、何回実行されたかを検証できる。

```ts
test("モック関数は実行された回数を記録している", () => {
  const mockFn = jest.fn();
  mockFn();
  expect(mockFn).toHaveBeenCalledTimes(1);
  mockFn();
  expect(mockFn).toHaveBeenCalledTimes(2);
});
```

### 実行時引数の検証

モック関数は、実行時の引数を記録している。
モック関数を実行する`greet`関数を用意して検証してみる。
モック関数は、関数定義の中に忍ばせることができる。

```ts
test("モック関数は関数の中でも実行できる", () => {
  const mockFn = jest.fn();
  function greet() {
    mockFn();
  }
  greet();
  expect(mockFn).toHaveBeenCalledTimes(1);
});
```

`greet`関数に引数`message`を追加してみる。
モック関数である`mockFn`は実行時に`"hello"`という引数をもって実行されたことを記録する。
記録内容を検証するために`toHaveBeenCalledWith`というマッチャーを使用したアサーションを書く。

```ts
test("モック関数は実行時の引数を記録している", () => {
  const mockFn = jest.fn();
  function greet(message: string) {
    mockFn(message); // 引数をもって実行される
  }
  greet("hello"); // "hello"をもって実行されたことがmockFnに記録される
  expect(mockFn).toHaveBeenCalledWith("hello");
});
```

### テスト対象の引数に関数がある場合のテスト

以下の`greet`関数は与えられた第一引数`name`を使用し、第二引数のコールバック関数を実行している。

```ts
export function greet(name: string, callback?: (message: string) => void) {
  callback?.(`Hello! ${name}`);
}
```

次のようなテストを書くことで、コールバック関数の実行時引数を検証することができる。

```ts
test("モック関数はテスト対象の引数として使用できる", () => {
  const mockFn = jest.fn();
  greet("Jiro", mockFn);
  expect(mockFn).toHaveBeenCalledWith("Hello! Jiro");
});
```

### 実行時引数のオブジェクト検証

文字列以外にも、配列やオブジェクトを検証できる。

```ts
const config = {
  mock: true,
  feature: { spy: true },
};

export function checkConfig(callback?: (payload: object) => void) {
  callback?.(config);
}

test("モック関数は実行時引数のオブジェクト検証ができる", () => {
  const mockFn = jest.fn();
  checkConfig(mockFn);
  expect(mockFn).toHaveBeenCalledWith({
    mock: true,
    feature: { spy: true },
  });
});
```

大きなオブジェクトの場合、一部だけを検証したい場合がある。
`expect.objectContaining`を使用することで、オブジェクトの部分的な検証ができる。

```ts
test("expect.objectContaining による部分検証", () => {
  const mockFn = jest.fn();
  checkConfig(mockFn);
  expect(mockFn).toHaveBeenCalledWith(
    expect.objectContaining({
      feature: { spy: true },
    })
  );
});
```

## セットアップと破棄

Jest ではテストスイートやテストケースが実行される前後に特定の処理を実行するための関数として、以下の４つの関数が提供されている。

### `beforeAll`

- テストスイート内のすべてのテストケースが実行される前に、1 度だけ実行される関数
- データベースの接続の確立や外部リソースのセットアップなど、テストケースが実行される前に一度だけ必要な処理を行う場合に使用され

### `beforeEach`

- 各テストケースが実行される前に、毎回実行される関数
- テストケースごとに共通のセットアップが必要な場合や、テストデータの初期化が必要なときに使用される

### `afterAll`

- テストスイート内のすべてのテストケースが実行された後に、1 度だけ実行される関数
- データベース接続の切断やリソースの解放など、テストスイート全体の後処理が必要な場合に使用される

### `afterEach`

- 各テストケースが実行された後に、毎回実行される関数
- 各テストケースの後にクリーンアップや後処理を行うために使用される

```ts
// 前後処理の実行されるタイミング
describe("テスト", () => {
  beforeAll(() => console.log("1 - beforeAll"));
  afterAll(() => console.log("1 - afterAll"));
  beforeEach(() => console.log("1 - beforeEach"));
  afterEach(() => console.log("1 - afterEach"));
  test("テスト1", () => console.log("1 - test")); //テスト1

  describe("ネストされたテスト", () => {
    beforeAll(() => console.log("2 - beforeAll"));
    afterAll(() => console.log("2 - afterAll"));
    beforeEach(() => console.log("2 - beforeEach"));
    afterEach(() => console.log("2 - afterEach"));
    test("テスト2", () => console.log("2 - test")); //テスト2
  });
});
```

上記の実行結果は以下になる。

```shell
PASS  src/timing.test.js
  テスト
    ✓ テスト1 (3 ms)
    ネストされたテスト
      ✓ テスト2 (3 ms)

  console.log
    1 - beforeAll

      at src/timing.test.js:3:27

  console.log
    1 - beforeEach

      at Object.<anonymous> (src/timing.test.js:5:28)

  console.log
    1 - test

      at Object.<anonymous> (src/timing.test.js:7:30)

  console.log
    1 - afterEach

      at Object.<anonymous> (src/timing.test.js:6:27)

  console.log
    2 - beforeAll

      at src/timing.test.js:10:29

  console.log
    1 - beforeEach

      at Object.<anonymous> (src/timing.test.js:5:28)

  console.log
    2 - beforeEach

      at Object.<anonymous> (src/timing.test.js:12:30)

  console.log
    2 - test

      at Object.<anonymous> (src/timing.test.js:14:32)

  console.log
    2 - afterEach

      at Object.<anonymous> (src/timing.test.js:13:29)

  console.log
    1 - afterEach

      at Object.<anonymous> (src/timing.test.js:6:27)

  console.log
    2 - afterAll

      at src/timing.test.js:11:28

  console.log
    1 - afterAll

      at src/timing.test.js:4:26

Test Suites: 1 passed, 1 total
Tests:       2 passed, 2 total
Snapshots:   0 total
Time:        0.47 s, estimated 1 s
Ran all test suites matching
```

## 現在時刻に依存したテスト

テスト対象が現在時刻に依存したロジックを含んでいる場合、テストの結果はテスト実行時刻に依存する。
これは「特定の時間帯になると、CI の自動テストが失敗してしまう」といった、脆いテストにつながる。
これを防ぐために、テスト実行環境の現在時刻は固定してしまい、いつ実行してもテスト結果が同じになるように設定する必要がある。

### テスト対象の関数

```ts
export function greetByTime() {
  const hour = new Date().getHouts();

  if (hour < 12) {
    return "おはよう";
  } else if (hour < 18) {
    return "こんにちは";
  }
  return "こんばんは";
}
```

### 現在時刻を固定する

テスト実行環境の現在時刻を任意の時刻に固定するには、以下の関数を使用する必要がある。

#### `jest.useFakeTimers`

- Jest に偽のタイマーを使用するように指示するための関数
- 対象のテストが実行される前に`beforeEach`で呼び出す

#### `jest.setSystemTime`

- 偽のタイマーで使用される現在システム時刻を設定するための関数
- テスト実行時に呼び出す

#### `jest.useRealTimers`

- Jest に真のタイマーを使用する（元に戻す）ように指示するための関数
- 対象のテストが実行された後に`afterEach`で呼び出す

```ts
describe("greetByTime(", () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test("朝は「おはよう」を返す", () => {
    jest.setSystemTime(new Date(2023, 4, 23, 8, 0, 0));
    expect(greetByTime()).toBe("おはよう");
  });

  test("昼は「こんにちは」を返す", () => {
    jest.setSystemTime(new Date(2023, 4, 23, 14, 0, 0));
    expect(greetByTime()).toBe("こんにちは");
  });

  test("夜は「こんばんは」を返す", () => {
    jest.setSystemTime(new Date(2023, 4, 23, 21, 0, 0));
    expect(greetByTime()).toBe("こんばんは");
  });
});
```
