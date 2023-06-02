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

「スタブ」「スパイ」とは、モックをそれぞれの目的に応じて分類したオブジェクトの呼称である。テストに’おいて特定の役割や機能を持っている。

### スタブ

- スタブの目的は「代用」を行うこと。
- テスト時に他のオブジェクトやシステムとの依存関係を置き換えるために使用される
- 事前に定義された応答やデータを返すだけで、特定の操作や機能の振る舞いを単純化している
- 例えば、ネットワークリクエストをシュミレートする場合、スタブは事前に用意された応答データを返すことで、ネットワーク通信を模倣する
- スタブはテストケースごとに設定され、特定の条件やシナリオに対する応答を提供する

### スパイ

- スパイの目的は「記録」を行うこと。
- テスト中にオブジェクトやシステムの振る舞いや状態を監視・記録するために使用される。
- スパイは実際のオブジェクトやシステムの一部であり、その動作やメソッド呼び出しをトラックする。
- テストの際に、スパイはメソッドの呼び出し回数や引数、戻り値などの情報を収集し、テスト結果の評価や検証に利用される

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
  sayGoodBye: (name: string) => `Good bye, ${name}`,
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

### Web API クライアントのスタブ実装
