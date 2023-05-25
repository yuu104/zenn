---
title: "フロントエンド開発における自動テストまとめ"
emoji: "🙆"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: [Typescript, React, Jest, nextjs, reacttestinglibrary]
published: false
---

# テストの目的

### 事業の信頼のため

- 経済的な影響を及ぼすバグを含めてしまった場合、信頼を取り戻すまでの活動に間接的な経済影響を及ぼす
- バグを含めてリリースしてしまうと、サービスに対するイメージが低下してしまう

### 健全なコードを維持するため

- プロジェクトの実装が進むと、似通った処理はモジュール化するなどといったリファクタリングを行う
- しかし、リファクタリングにより実装済みの機能に影響を及ぼす可能性があり、リファクタリングを見送ってしまう
- テストコードを書く習慣があると、リファクタリングの際に逐一既存実装が壊れていないか確認できる

### 実装品質に自信を持つため

- テストコードが書きづらいと感じたら、テスト対象に処理を詰め込み過ぎているサインかも
- テストを書くことで実装したコードの品質を見直す機会に繋がり、より良い実装へと導いてくれる

### 円滑なコラボレーションのため

- チーム開発において、開発生産性を高めるためにも実装コード意外に細く情報を残すことが大事
- テストコードは単純なテキストドキュメントよりも優れた補足情報
- テストには 1 つずつタイトルが与えられ、どのような機能・振る舞いを持つのかが記載されている
- 実装コードがテストの要件を満たしている限り、補足内容と実装内容が異なることはない
- 技術的な誤りがないかの確認だけでなく、要件を満たしているかの確認もできる

### リグレッションを防ぐため

:::details リグレッションとは？
あるソフトウェアの新しい機能追加やバグ修正が行われた際に、以前正常に動作していた機能が予期しない不具合を発生する現象のこと。
:::

- 細かくモジュール分割することで、モジュール単体の責務やテストはシンプルになる
- 一方で、モジュール同士の依存関係が発生し、依存先の変更によってリグレッションが発生しやすくなる

# フロントエンドテストの種類と範囲

Web アプリケーションコードは、以下にある様々なモジュールを組み合わせて実装する。

1. ライブラリが提供する関数
2. ロジックを担う関数
3. UI を表現する関数
4. Web API クライアント
5. API サーバー
6. DB サーバー

フロントエンドテストの自動テストを書くとき、1〜6 のうち「どこからどこまでの範囲をカバーしたテストであるか」を意識する必要がある。
Web フロントエンドにおけるテストの範囲は以下の 4 つに分類される。

### 静的解析

- TypeScript や ESLint による静的解析
- バグの早期発見には欠かせない
- 単一のモジュール内部検証だけでなく、2 と 3 の間、3 と 4 の間など**隣接するモジュール間連携の不整合**に対して検証する

### 単体テスト

- 2 のみ、3 のみ、といったように**モジュール単体が提供する機能**に着目したテスト
- テスト対象モジュールが、定められた入力値から期待する出力値が得られるかをテストする
- 独立した検証が行えるため、滅多に発生しないケース（コーナーケース）の検証に向いている

### 結合テスト

- 1〜4 まで、2〜3 までというように**モジュールをつなげることで提供できる機能**に着目したテスト
- 範囲が広いほどテスト対象を効率よくカバーすることができる
- 相対的にざっくりとした検証になる傾向がある

### E2E テスト

- 1〜6 を通し、ヘッドレスブラウザ+UI オートメーションで実施するテスト
- ユーザーがシステムを使用する場面を想定し、実際にシステムを操作してテストを行う
- システム全体を対象に行われるテストであるため、複数のコンポーネントやシステム間の相互作用を含む複雑なテストケースを扱うことができる
- そのため、より本物のアプリケーションに近いテストが可能

# 目的別のテスト分類

テストは目的によって**テストタイプ**に分類される。
テストタイプは検証目的に応じて設定され、テストタイプごとに適したテストツールが存在する。

### 機能テスト（インタラクションテスト）

- 開発対象の機能に不具合がないかを検証する
- Web フロントエンドにおける開発対象機能の大部分は、UI コンポーネントの操作（インタラクション）が起点になるため、インタラクションテストが機能テストそのものになる
- React などのライブラリで実装された UI コンポーネントにおいては、ブラウザなしでもインタラクションテストができる
  - **仮想ブラウザ**でテストを実行するため

:::details 実際のブラウザなしでも可能なインタラクションテストの例

- ボタンを押下すると、コールバック関数が呼ばれる
- 文字を入力すると、送信ボタンが活性化する
- ログアウトボタンを押下すると、ログイン画面に遷移する

![](/images/frontend-test-summary/specific-examples-of-interaction-testing-that-can-be-done-without-a-real-browser.png)

:::

- 実際のブラウザが必要な機能テストは、ヘッドレスブラウザ+UI オートメーションを使用する
- ブラウザ環境を忠実に再現する必要のある機能テストがある場合に選択する

:::details 実際のブラウザが必要なインタラクションテストの例

- 最下部までスクロールすると、新しいデータがロードされる
- セッションストレージに保存した値が復元される

![](/images/frontend-test-summary/specific-examples-of-interaction-tests-that-require-a-real-browser.png)

:::

### 非機能テスト（アクセシビリティテスト）

- 非機能テストのうち、心身特性に隔てのない製品を提供できているかという検証が**アクセシビリティテスト**
  - キーボード入力による操作が充実しているか？
  - 視認性に問題のないコントラスト比となっているか？
- アクセシビリティテストは検証項目によって適切なテストツールが異なる

:::details アクセシビリティテストの例

- チェックボックスとして、チェックできる
- エラーレスポンスが表示された場合、エラー文言が読み上げ対象としてレンダリングされる
- 表示している画面で、アクセシビリティ違反がないか調べる

![](/images/frontend-test-summary/accessibility-testing.png)

:::

### ビジュアルリグレッションテスト

- UI コンポーネントの外観が変化していないことを検証するテスト
- UI コンポーネントが変更された場合に、ビジュアルに何らかの問題が生じていないかを確認するために行う
- ヘッドレスブラウザに描画された内容をキャプチャし、キャプチャ画像を比較することで見た目のリグレッションが発生していないかを検証する
- ユーザー操作を与えたことにより変化した UI コンポーネントの画像比較も可能

:::details ビジュアルリグレッションテストの例

- ボタンの見た目にリグレッションがない
- メニューバーを開いた状態にリグレッションがない
- 表示された画面にリグレッションがない

![](/images/frontend-test-summary/visual-regression-test.png)

:::

# テスト戦略モデル

各種テストはいくつかの層に分類して考えることができる。
![](/images/frontend-test-summary/relationship-between-test-coverage-and-cost.png)

- 上層のテストは忠実性の高いテスト（本物に近いテスト）になる
- 上層のテストは実行するにあたり本物に近いテスト環境を揃える必要がある
  - テスト用に用意した DB サーバーを起動してセットアップするなど
- テストに必要なコストは開発に与える影響が大きく、開発者間で十分に検討する必要がある
- **コスト配分をどのように設計して最適化を行うか**が、テスト戦略最大の検討事項となる

### アイスクリームコーン型

![](/images/frontend-test-summary/ice-cream-cone.png)

- 上層のテストが多いモデル
- 戦略モデルのアンチパターン
- 運用コストが高く、稀に失敗する不安定なテストがより多くのコストを必要とする
- コストが高くなると、自動テストによって開発体験が著しく低下するという本末転倒な悪影響が生じる

### テストピラミッド型

![](/images/frontend-test-summary/test-pyramid.png)

- 下層のテストが多いモデル
- 安定した費用対効果の高いテスト戦略になる

### テスティングトロフィー型

![](/images/frontend-test-summary/testing-trophy.png)

- 「TestingLibrary」の開発者、KentC.Dodds.氏が提唱するテスト戦略モデル
- 最も比重を置くべきなのは**結合テスト**であるという主旨

フロントエンドが提供する機能は、ユーザー操作（インタラクション）を起点に提供される。
そのため、ユーザー操作を起点とした結合テストを充実させることこそが、より良いテスト戦略になるという意図がある。

# 単体テスト

テスティングフレームワークである「Jest」を使用する。

## Jest を使った簡単なテスト

```ts:src/03/02/index.ts
export function add(a: number, b: number) {
  return a + b;
}
add(1, 2);
```

上記の関数に対するテストは以下の通り。
1 と 2 の和が、３であることを検証している。

```ts:src/03/02/index.test.ts
import { add } from "./";

test("add: 1 + 2 は　3", () => {
  expect(add(1, 2)).toBe(3);
});
```

テストは実装ファイルとは別の「テストファイル」に記述し、テスト対象（`add`関数）をインポートしてテストする。

- 実行ファイル：`src/03/02/index.ts`
- テストファイル：`src/03/02/index.test.ts`

上記は「実装ファイル名称.ts」に対し、テストファイルは「実装ファイル名称.test.ts」という命名規則でテストを作成している。
テストファイルの配置場所は、必ず実装ファイルの隣に置かなければならないわけではなく、ルートに`__test__`ディレクトリを用意し、その中に配置するパターンもメジャー。

## テストの構成要素

1 つのテストは、Jest が提供する API の`test`関数で定義する。
`test`関数は、2 つの引数によって構成される。

```ts
test(テストタイトル, テスト関数);
```

第一引数であるテストタイトルは、テストの内容を簡単に表すタイトルを与える。

```ts
test("1 + 2 は 3");
```

第二引数であるテスト関数には「**アサーション**」を書く。
アサーションとは「検証値が期待通りである」という検証を行う文。

```ts
test("1 + 2 は 3", () => {
  expext(検証値).toBe(期待値);
});
```

アサーションは`expext`関数に続けて記述する「**マッチャー**」で構成されている。
マッチャーは Jest から標準で、様々な種類のものが提供されている。
https://jestjs.io/ja/docs/expect#matchers

- アサーション：`expect(検証値).toBe(期待値)`
- マッチャー：`toBe(期待値)`

`toBe`マッチャーは検証値と期待値を比較して等さを検証する。
単純なプリミティブ値（数値、文字列、真偽値など）やオブジェクト、配列などの参照型に対して使用できる。

## テストグループの作成

関連する複数のテストをグルーピングしたい場合、`describe`関数が利用できる。
`add`関数に対するテストをグルーピングしたい場合、以下のように書ける。
`test`関数と同じように、`describe(グループタイトル, グループ関数)`の 2 つの引数によって構成される。

```ts:index.test.ts
describe("add", () => {
  test("1 + 1 は 2", () => {
    expect(add(1, 1)).toBe(2);
  });

  test("1 + 2 は 3", () => {
    expect(add(1, 2).toBe(3));
  });
});
```

`descripbe`関数は以下のようにネストさせることが可能。

```ts:index.ts
export function add(a: number, b: number) {
  return a + b;
}

export function sub(a: number, b: number) {
  return a - b;
}
```

```ts:index.test.ts
describe("四則演算", () => {
  describe("add", () => {
    test("1 + 1 は 2", () => {
      expect(add(1, 1)).toBe(2);
    });

    test("1 + 2 は 3", () => {
      expect(add(1, 2)).toBe(3);
    });
  });

  describe("sub", () => {
    test("1 - 1 は 0", () => {
      expect(sub(1, 1)).toBe(0);
    });

    test("2 - 1 は 1", () => {
      expect(sub(2, 1)).toBe(1);
    });
  });
});
```

## テストの実行方法

### CLI から実行する方法

`package.json`に以下の npm script を追加する。

```json:package.json
{
  "scripts": {
    "test": "jest"
  }
}
```

以下のコマンドを実行すると、プロジェクトに含まれるテストファイルを探し、全て実行する。

```bash
$ npm test
```

ファイルパスを指定すると特定のテストファイルだけが実行される。

```bash
$ npm test 'src/example.test.ts'
```

### Jest Runner から実行する方法

VSCode の拡張機能である「Jest Runner」を利用すると、コマンドを手動入力せずにテストを実行できる。
https://marketplace.visualstudio.com/items?itemName=firsttris.vscodejestrunner
![Jest Runnerのインストール前後の比較](/images/frontend-test-summary/jest-runner.png)
テスト・テストグループの左上に「Run | Debug」というテキストが現れる。
「Run」をクリックすることで、対象のテスト・テストグループが VSCode 上のターミナルで実行される。

### 実行結果の見方

テストを実行すると、プロジェクト内に見つかった対象テストファイルの実行結果が一行ずつ表示される。
行頭に「PASS」と記されているのは成功したテストファイル。

```bash
PASS src/03/06/index.test.ts
PASS src/03/07/index.test.ts
PASS src/03/08/index.test.ts
PASS src/03/09/index.test.ts
```

### テストが全て成功した場合

一通りテストが完了すると、結果概要が表示される。
下記は 29 件のテストファイル（Test Suites）が見つかり、126 件中 122 件のテストが成功（4 件はスキップ ≒ 保留）した旨が記されている。

```bash
TEST Suites: 29 passed, 29 total
Tests:       4 skipped, 122 passed, 126 total
Snapshots:   9 passed, 9 total
Time:        11.205 s
Ran all test suites.
```

### テストが一部失敗した場合

```ts:src/03/02/index.test.ts
test("1 + 1 は 3", () => {
  expect(add(1, 1)).toBe(3);
});
```

上記のテストを実行すると、該当ファイルの行頭に赤字で「FAIL」と記される。

```bash
FAIL src/03/02/index.test.ts
```

ターミナルのメッセージには、テストが失敗した箇所や失敗した理由について詳細な報告が記されている。

```bash
FAIL src/03/02/index.test.ts
⚫️四則演算 > add > 1 + 1 は 3

  expect(received).toBe(expected) // Object.is equality

  Expected: 3
  Received: 2

  4 |   describe("add", () => {
  5 |     test("1 + 1 は 3", () => {
> 6 |       expect(add(1, 1)).toBe(3);
    |                         ^
  7 |     });
  8 |     test("1 + 2 は 3", () => {
  9 |       expect(add(1, 2)).toBe(3);

  at Object.<anonymous> (src/03/02/index.test.ts:6:25)
```

結果概要を確認すると、1 件のテストが失敗していることがわかる。

```bash
TEST Suites: 1 failed 28 passed, 29 total
Tests:       1 failed 4 skipped, 121 passed, 126 total
Snapshots:   9 passed, 9 total
Time:        9.587 s
```

## 例外をスローする実装

`add`関数に「引数 a、b は 0〜100 の数値しか受け付けない」という仕様を追加する。

```ts:index.ts
export function add(a: number, b: number) {
  if (a < 0 || a > 100) {
    throw new Error("入力値は0〜100の間で入力してください");
  }
  if (b < 0 || b > 100) {
    throw new Error("入力値は0〜100の間で入力してください");
  }

  return a + b;
}
```

この関数が例外をスローするパターンのテストを作成する。
期待する挙動は「範囲外の値を与えた場合、例外がスローされること」である。
例外発生をテストする場合、`expect`の引数は値ではなく「例外発生が想定される関数」を指定する。
マッチャーには`toThrow`を使用する。

```ts
expect(例外スローが想定される関数).toThrow();
```

「例外スローが想定される関数」はアロー関数式でラップして指定する。
これにより、「例外がスローされること」を検証できる。

```ts
// 正しくない書き方
expext(add(-10, 110)).toThrow();

// 正しい書き方
expect(() => add(-10, 110)).toThrow();
```

例外が発生しない条件でテストを行うと失敗する。

```ts
expect(() => add(70, 80)).toThrow();
```

```bash
expect(received).toThrow()

Received function did not throw

  4 |
  5 |    test("例外がスローされないため失敗する", () => {
> 6 |      expect(() => add(70, 80)).toThrow();
    |                                ^
  7 |    });
  8 |
```

### エラーメッセージによる詳細な検証

エラーメッセージまでテストしたい場合は`toThrow`マッチャーに引数を指定する

```ts
test("引数が'0〜100'の範囲外だった場合、例外をスローする", () => {
  expect(() => add(110, -10)).toThrow("入力値は0〜100の間で入力してください");
});
```

例外は意図的にスローされるものの他、意図しないバグが原因で発生するものもある。

## 用途別のマッチャー

### 真偽値の検証

- `toBeTurthy`: 「真」である値に一致する
- `toBeFalsy`: 「偽」である値に一致する

```ts
test("「真の値」の検証", () => {
  expect(1).toBeTurthy();
  expect("1").toBeTurthy();
  expect(true).toBeTurthy();
  expect(0).not.toBeTurthy();
  expect("").not.toBeTurthy();
  expect(false).not.toBeTurthy();
});

test("「偽の値」の検証", () => {
  expect(0).toBeFalsy();
  expect("").toBeFalsy();
  expect(false).toBeFalsy();
  expect(1).not.toBeFalsy();
  expect("1").not.toBeFalsy();
  expect(true).not.toBeFalsy();
});
```

### `null`や`undefined`の検証

- `toBeNull`: `null`である値に一致する
- `toBeUndefined`: `undefined`である値に一致する

```ts
test("「null, undefined」の検証", () => {
  expect(null).toBeFalsy();
  expect(undefined).toBeFalsy();
  expect(null).toBeNull();
  expect(undefined).toBeUndefined();
  expect(undefined).not.toBeDefined();
});
```

### 数値の検証

```ts
describe("数値の検証", () => {
  const value = 2 + 2;

  test("検証値 は 期待値 と等しい", () => {
    expect(value).toBe(4);
    expect(value).toEqual(4);
  });

  test("検証値 は 期待値 より大きい", () => {
    expect(value).toBeGreaterThan(3); // value > 3
    expect(value).toBeGreaterThanOrEqual(4); // value >= 4
  });

  test("検証値 は 期待値 より小さい", () => {
    expect(value).toBeLessThan(5); // value < 5
    expect(value).toBeLessThanOrEqual(4); // value <= 4
  });
});
```

### 小数値の検証

JavaScipt では少数の計算に誤差が発生する。
これは、10 進数の少数を 2 進数に変換するときに生じる。
少数計算を検証する場合、`toBeCloseTo`マッチャーを使用する。

```ts
expect(検証値).toBeCloseTo(期待値, 桁数);
```

第二引数にはどこまでの桁を比較するのかを指定できる。

```ts
test("小数計算は正確ではない", () => {
  expect(0.1 + 0.2).not.toBe(0.3);
});

test("小数計算の指定桁までを比較する", () => {
  expect(0.1 + 0.2).toBeCloseTo(0.3); // デフォルトは 2桁
  expect(0.1 + 0.2).toBeCloseTo(0.3, 15);
  expect(0.1 + 0.2).not.toBeCloseTo(0.3, 16);
});
```

### 文字列の検証

- `toContain`: 文字列の部分一致
- `toMatch`: 正規表現
- `toHaveLength`: 文字列の長さ

```ts
const str = "こんにちは世界";

test("検証値 は 期待値 と等しい", () => {
  expect(str).toBe("こんにちは世界");
  expect(str).toEqual("こんにちは世界");
});

test("toContain", () => {
  expect(str).toContain("世界");
  expect(str).not.toContain("さようなら");
});

test("toMatch", () => {
  expect(str).toMatch(/世界/);
  expect(str).not.toMatch(/さようなら/);
});

test("toHaveLength", () => {
  expect(str).toHaveLength(7);
  expect(str).not.toHaveLength(8);
});
```

オブジェクトに含まれる文字列を検証したい場合、`stringContaining`や`stringMatching`を使用する。
対象のプロパティに、期待値文字列の一部が含まれていれば、テストは成功する。

```ts
const str = "こんにちは世界";
const obj = { status: 200, message: str };

test("stringContaining", () => {
  expect(obj).toEqual({
    status: 200,
    message: expect.stringContaining("世界"),
  });
});
test("stringMatching", () => {
  expect(obj).toEqual({
    status: 200,
    message: expect.stringMatching(/世界/),
  });
});
```

### 配列の検証

#### プリミティブ配列

```ts
describe("プリミティブ配列", () => {
  const tags = ["Jest", "Storybook", "Playwright", "React", "Next.js"];

  test("toContain", () => {
    expect(tags).toContain("Jest");
    expect(tags).toHaveLength(5);
  });
});
```

#### オブジェクト配列

```ts
describe("オブジェクト配列", () => {
  const article1 = { author: "taro", title: "Testing Next.js" };
  const article2 = { author: "jiro", title: "Storybook play function" };
  const article3 = { author: "hanako", title: "Visual Regression Testing " };
  const articles = [article1, article2, article3];

  test("toContainEqual", () => {
    expect(articles).toContainEqual(article1);
  });

  test("arrayContaining", () => {
    expect(articles).toEqual(expect.arrayContaining([article1, article3]));
  });
});
```

配列に特定のオブジェクトが含まれているかを検証したい場合、`toContainEqual`を使用する。
2 つ目のテスト「arrayContaining」は、`articles`が`[article1, article3]`を含んでいることを検証している。

### オブジェクトの検証

- `toMatchObject`: オブジェクトが特定のプロパティと値を含んでいるかどうかを検証する
- `toHaveProperty`: オブジェクトが指定されたプロパティを持っているかどうかを検証する

```ts
const author = { name: "taroyamada", age: 38 };

test("toMatchObject", () => {
  expect(author).toMatchObject({ name: "taroyamada", age: 38 });
  expect(author).toMatchObject({ name: "taroyamada" });
  expect(author).not.toMatchObject({ gender: "man" });
});

test("toHaveProperty", () => {
  expect(author).toHaveProperty("name");
  expect(author).toHaveProperty("age");
});
```

- `objectContaining`: ネストしたオブジェクトを検証したい場合に使用する

```ts
const article = {
  title: "Testing with Jest",
  { name: "taroyamada", age: 38 },
};

test("objectContaining", () => {
  expect(article).toEqual({
    title: "Testing with Jest",
    author: expect.objectContaining({ name: "taroyamada" }),
  });

  expect(article).toEqual({
    title: "Testing with Jest",
    author: expect.not.objectContaining({ gender: "man" }),
  });
});
```

## 非同期処理のテスト

以下の非同期処理を含む関数をテスト対象とする。

```ts
export function wait(duration: number) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(duration);
    }, duration);
  });
}
```

非同期処理テストの書き方は複数ある。

### Promise を return する書き方

#### 書き方 1

Promise を返し`then`に渡す関数内にアサーションを書く。
`wait`関数を実行すると、Promise インスタンスが生成される。
これをテスト関数の戻り値として return する事で、Promise が解決するまでテストの判定を待つ。

```ts
test("指定時間待つと、経過時間をもって resolve される", () => {
  return wait(50).then((duration) => {
    expect(duration).toBe(50);
  });
});
```

#### 書き方 2

`resolves`を使用したアサーションを return する。
`wait`関数が relolve したときの値を検証したい場合、こちらの書き方の方がシンプル。

```ts
test("指定時間待つと、経過時間をもって resolve される", () => {
  return expect(wait(50)).resolves.toBe(50);
});
```

### async/await を使った書き方

#### 書き方 1

テスト関数を`async`関数とし、関数内で Promise が解決するのを待つ。

```ts
test("指定時間待つと、経過時間をもって resolve される", async () => {
  await expect(wait(50)).resolves.toBe(50);
});
```

#### 書き方 2

検証値の Promise が解決するのを待ってから、アサーションに展開する。

```ts
test("指定時間待つと、経過時間をもって resolve される", async () => {
  expect(await wait(50)).toBe(50);
});
```

async/await を使用した書き方の場合、他の非同期処理のアサーションも１つのテスト関数内に収めることができる。

### Reject を検証するテスト

必ず reject される関数を使用して「reject されること」を検証するテストを書く。

```ts
export function timeout(duration: number) {
  return new Promise((_, reject) => {
    setTimeout(() => {
      reject(duration);
    }, duration);
  });
}
```

#### 書き方 1

Promise を return する書き方。
`catch`メソッドに渡す関数内にアサーションを書く。

```ts
test("指定時間待つと、経過時間をもって reject される", () => {
  return timeout(50).catch((duration) => {
    expect(duration).toBe(50);
  });
});
```

#### 書き方 2

`reject`マッチャーを使用したアプリケーションを使用する方法。
アサーションを return する or async 関数の中で Promise の解決を待つ。

```ts
test("指定時間待つと、経過時間をもって reject される", () => {
  return expect(timeout(50)).rejects.toBe(50);
});

test("指定時間待つと、経過時間をもって reject される", async () => {
  await expect(timeout(50)).rejects.toBe(50);
});
```

#### 書き方 3

try...catch 文を使用する。

```ts
test("指定時間待つと、経過時間をもって reject される", async () => {
  expect.assertions(1);
  try {
    await timeout(50);
  } catch (err) {
    expect(err).toBe(50);
  }
});
```

`expect.assersions(1)`は「アサーションが実行されること」そのものを検証する。
引数は実行される回数の期待値を指定する。

#### 何のために`expect.assersions`を使用するのか？

次のテストにはミスが含まれている。
コメントにあるように、実行されてほしいアサーションに到達しないまま、テストが終了してしまう。

```ts
test("指定時間待つと、経過時間をもって reject される", async () => {
  try {
    await wait(50); // timeout関数のつもりが、wait関数にしてしまった
    // ここで終了してしまい、テストは成功する
  } catch (err) {
    // アサーションは実行されない
    expect(err).toBe(50);
  }
});
```

このようなミスの内容に、テスト関数の冒頭で`expect.assertions`を宣言し、「アサーションが実行されること」を検証する。

```ts
test("指定時間待つと、経過時間をもって reject される", async () => {
  expect.assertions(1); // アサーションが1度実行されることを期待する
  try {
    await wait(50);
    // アサーションが1度も実行されないまま終了するので、テストは失敗する
  } catch (err) {
    expect(err).toBe(50);
  }
});
```

非同期処理のテストは`expect.assertions`を宣言すると、記述ミスを減らすことが期待できる。

### 非同期処理のテストを書く際の注意点

- 非同期処理を含むテストは、テスト関数を async で書く
- `.resolves`や`.rejects`を含むアサーションは await する
- try...catch 文による例外スローを検証する場合、`expect.assersions`を書く

# モック

### モックとは？

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
単体テストや結合テストを実施する際、未実装だったり都合の悪いモジュールが依存関係に含まれている場合がある。この時、代用品に置き換えることでテスト不能だった対象のテストが実施できるようになる。
![Jest Runnerのインストール前後の比較](/images/frontend-test-summary/mock-module-stub.png)
