---
title: "Playwright"
---

## Playwright とは

- Microsoft が開発を主導するオープンソースの Web アプリケーション向けテストフレームワーク
- 主要ブラウザに対応し、異なるブラウザ間で一貫したテストを実施可能

### 特徴

1. **クロスブラウザ/クロスプラットフォーム/多言語サポート**
   - Chromium、WebKit、Firefox をはじめとする主要なブラウザ／ブラウザエンジンをサポート
   - Windows、Linux、macOS などの主要なプラットフォームで動作する
   - JavaScript/TypeScript、Python、.NET（C#）、Java などの複数の言語で Playwright API を使用可能
2. **堅牢で安定したテスト**
   - HTML の要素が操作可能になるまで自動で待機するオートウェイト機能
   - 特定の操作やアサーションが失敗した場合にその操作を自動的に再試行する自動リトライ機能
   - 実行トレースやビデオ、スクリーンショットをキャプチャするトレーシング機能
3. **制限のないテストシナリオ**
   - 複数のタブ、複数のドメイン、複数のユーザーにまたがるテストシナリオを可能
   - 従来はアクセスするのに苦労することが多かった Shadow DOM やインラインフレーム内の要素に対し、開発者がとくに意識することなくシームレスにアクセスできる
   - アクセシビリティ情報（WAI-ARIA ロール）の活用により、壊れにくく堅牢なテストが実現できる
4. **テストの完全な分離と高速化**
   - 各ブラウザに対して独立したブラウザコンテキストを生成
     - 新規ブラウザプロファイルを生成するような感じ
   - それぞれのテストが他のテストの設定やデータに影響されることがない
   - 多くのテストで繰り返されるログイン操作などは、ログイン情報を一度コンテキストに保存して再利用することが可能
   - デフォルトでテストはファイルごとに並列で実行される

:::details 他ツールとの比較（2024 年 2 月時点）

| 項目                        | Cypress                                                          | Puppeteer                                | Playwright                                                       |
| --------------------------- | ---------------------------------------------------------------- | ---------------------------------------- | ---------------------------------------------------------------- |
| 開発元                      | Cypress.io                                                       | Google                                   | Microsoft                                                        |
| ライセンス                  | MIT License                                                      | Apache License 2.0                       | Apache License 2.0                                               |
| v1.0.0 リリース             | 2017 年                                                          | 2018 年                                  | 2020 年                                                          |
| 最新バージョン              | v13.6.4                                                          | v22.0.0                                  | v1.41.2                                                          |
| 実装言語                    | JavaScript                                                       | JavaScript                               | TypeScript                                                       |
| GitHub Stars                | 45.8k                                                            | 86.1k                                    | 59.3k                                                            |
| ブラウザサポート            | Chromium、Chrome、Edge、Firefox、Electron、WebKit (Experimental) | Chromium、Chrome、Firefox (Experimental) | Chromium、Chrome、Edge、Firefox、WebKit、Electron (Experimental) |
| 言語サポート                | JavaScript/TypeScript                                            | JavaScript/TypeScript                    | JavaScript/TypeScript、Python、Java、.NET (C#)                   |
| テスト実行                  | ブラウザ内実行（ブラウザと同一プロセス）                         | ブラウザ外実行（ブラウザと別プロセス）   | ブラウザ外実行（ブラウザと別プロセス）                           |
| ブラウザの制御              | ブラウザ API 経由（ブラウザの内部機能を直接利用）                | CDP 経由                                 | CDP 経由（Firefox と WebKit は CDP 相当の独自プロトコル経由）    |
| テストランナー              | あり                                                             | なし                                     | あり                                                             |
| テストアサーション          | あり                                                             | なし                                     | あり                                                             |
| 自動待機機能                | あり                                                             | なし                                     | あり                                                             |
| 自動リトライ機能            | あり                                                             | なし                                     | あり                                                             |
| スクリーンショット機能      | あり                                                             | あり                                     | あり                                                             |
| 画面録画機能                | あり                                                             | なし                                     | あり                                                             |
| タイムトラベルデバッグ機能  | あり                                                             | なし                                     | あり                                                             |
| 複数タブ/複数ウィンドウ制御 | できない                                                         | できる                                   | できる                                                           |
| SaaS                        | Cypress Cloud                                                    | なし                                     | Microsoft Playwright Testing                                     |

:::

## テストコードの基本構成

Playwright を使用したテストコードの基本構造を見ていきましょう。
以下の例を通じて、テストの書き方とその主要な要素を解説します。

```typescript
import { test, expect } from "@playwright/test";

test("ページの表示テスト", async ({ page }) => {
  await page.goto("http://localhost:3000");

  await expect(page).toHaveTitle(/ 最初のページ /);

  await expect(page.getByRole("heading")).toHaveText(
    /Playwright のハンズオン /
  );

  await expect(
    page.getByRole("button", { name: / 操作ボタン / })
  ).toBeVisible();
});
```

1. **インポート文**:

   ```typescript
   import { test, expect } from "@playwright/test";
   ```

   Playwright の`test`関数と`expect`アサーション関数をインポートします。
   これらはテストの骨格を形成する重要な要素です。

2. **テスト関数**:

   ```typescript
   test("ページの表示テスト", async ({ page }) => { ... });
   ```

   `test` 関数は、テストケースを定義します。
   第一引数にテストの説明、第二引数に非同期の関数を渡します。
   `{ page }` は、Playwright が提供するページオブジェクトです。

3. **ページナビゲーション**:

   ```typescript
   await page.goto("http://localhost:3000");
   ```

   テスト対象の URL にナビゲートします。
   ローカル環境でのテストを想定しています。

4. **アサーション**:

   - タイトルの確認:
     ```ts
     await expect(page).toHaveTitle(/ 最初のページ /);
     ```
   - 見出しテキストの確認:
     ```typescript
     await expect(page.getByRole("heading")).toHaveText(
       /Playwright のハンズオン /
     );
     ```
   - ボタンの可視性確認:
     ```typescript
     await expect(
       page.getByRole("button", { name: / 操作ボタン / })
     ).toBeVisible();
     ```

   各`expect`文は、ページの特定の要素や状態を検証します。
   正規表現を使用して、柔軟な文字列マッチングを実現しています。

## E2E テストツールの構成要素

E2E テストツールは、実際のユーザー操作をシミュレートし、アプリケーションの動作を検証します。
Playwright を含む多くの E2E テストツールは、主に 4 つの要素から構成されています。
これらの要素を理解することで、効果的なテストの作成と実行が可能になります。

1. **ナビゲーション**
   ナビゲーションは、テストの起点となる重要な要素です。
   主な役割は以下の通りです：

   - ページ遷移：特定の URL にアクセスし、テスト対象のページを開きます。
   - ページ情報取得：現在の URL、タイトル、ページの状態などを取得します。

   Playwright では、`Page`クラスがこの機能を提供します。例えば：

   ```typescript
   await page.goto("https://example.com");
   console.log(await page.title());
   ```

2. **ロケーター**
   ロケーターは、ページ内の特定の要素を見つけ出す役割を果たします。
   テキストボックス、ボタン、リンクなど、操作や検証の対象となる要素を特定します。

   Playwright では、`Page`クラスと`Locator`クラスがこの機能を提供します。様々な方法で要素を特定できます：

   ```typescript
   const submitButton = page.getByRole("button", { name: "Submit" });
   const emailInput = page.getByLabel("Email");
   ```

3. **アクション**
   アクションは、ユーザーの操作をシミュレートします。
   主な操作には以下があります：

   - クリック
   - テキスト入力
   - ドラッグ＆ドロップ
   - ファイル選択
   - キーボード操作

   Playwright では、`Locator`クラスがこれらのアクションメソッドを提供します：

   ```typescript
   await emailInput.fill("user@example.com");
   await submitButton.click();
   ```

4. **マッチャー（アサーション）**
   マッチャーは、テストの期待値と実際の結果を比較し、テストの成否を判定します。
   Playwright では、これを「Assertions」と呼びますが、本質的にはマッチャーと同じ役割を果たします。

   主なアサーションには以下があります：

   - 要素の表示確認
   - テキスト内容の検証
   - 属性値の確認
   - 要素の状態（有効/無効）の確認

   Playwright では、`expect`関数を使用してアサーションを行います：

   ```typescript
   await expect(page).toHaveTitle("Welcome Page");
   await expect(submitButton).toBeEnabled();
   ```

\
これら 4 つの要素（ナビゲーション、ロケーター、アクション、マッチャー）を組み合わせることで、実際のユーザー操作を模倣し、アプリケーションの動作を包括的にテストすることができます。

そして Playwright は、これらの要素を直感的に操作できる API を提供し、効率的な E2E テストの作成をサポートします。

| 分類           | 役割                                             | 公式ドキュメント                                                 | 実装クラス                             |
| -------------- | ------------------------------------------------ | ---------------------------------------------------------------- | -------------------------------------- |
| ナビゲーション | ページ遷移、ページ情報返却                       | [Guides/Navigations](https://playwright.dev/docs/navigations)    | Page                                   |
| ロケーター     | ページ内の要素の特定                             | [Guides/Locators](https://playwright.dev/docs/locators)          | Page, Locator                          |
| アクション     | ユーザー操作のシミュレート                       | [Guides/Actions](https://playwright.dev/docs/input)              | Locator                                |
| マッチャー     | 選択された要素の状態が期待と一致しているかテスト | [Guides/Assertions](https://playwright.dev/docs/test-assertions) | LocatorAssertions、PageAssertions など |

## リトライ

Playwright のマッチャーやアクションは、条件に合う要素が見つかるまで自動でリトライしてくれます。
デフォルトでは 5 秒間待機します。

Playwright ではリトライに関する様々な設定が可能です。

1. **個別設定**
   マッチャーやアクションはどれも `timeout` を付与することで待機時間を個別に設定できます。
   ```ts
   await page.goto("/start");
   await page.getByText("開始").click({ timeout: 10000 }); // 10秒待機
   ```
2. **テストケース単位で設定**

   ```ts
   import { test, expect } from "@playwright/test";

   test("遅いテスト", async ({ page }) => {
     test.slow(); // タイムアウト時間を3倍にする
   });

   test("3倍じゃ足りないテスト", async ({ page }) => {
     test.setTimeout(120000);
   });
   ```

3. **グローバル設定**
   ```ts
   export default defineConfig({
     expect: { timeout: 10 * 1000 }, // マッチャーのタイムアウト（10秒）
     timeout: 60 * 1000, // 個別テストのタイムアウト（1分）
     globalTimeout: 60 * 60 * 1000, // テスト全体のタイムアウト（1時間）
     use: {
       actionTimeout: 10 * 1000, // アクションのタイムアウト（10秒）
       navigationTimeout: 30 * 1000, // ナビゲーションのタイムアウト（30秒）
     },
   });
   ```

### 固定時間待機するコードは避ける

`page.waitForTimeout(ミリ秒)` のような固定時間を待つコードは、以下の理由から避けるべきです。

1. **フレーキーなテスト**
   環境やタイミングによってテストの成否が変わりやすくなります。
2. **実行時間の無駄**
   必要以上に長く待つ可能性があります。
3. **信頼性の低下**
   実際の状態変化を待つのではなく、単に時間経過を待つだけになります。

代わりに、特定のイベントが完了するまで効率よく待機するためのメソッドを利用します。
例えば、`waitForResponse()` や `waitForURL()` なんかがあります。

```ts
// 特定の API が呼ばれて帰ってくるまで待つ
const responsePromise = page.waitForResponse("https://example.com/resource");
await page.getByText("trigger response").click();
const response = await responsePromise;

// URL が特定のページになるまで待つ
await page.waitForURL("**/login");
```

他にも、以下のメソッドが存在します。

- `waitForLoadState()` : DOM ページのロードイベントを待つ
- `waitForRequest()` : リクエストの開始を待つ
- `waitForFunction()` : 渡された関数が `true` を返すのを待つ

## テストコードの組み立て方

ここからは、テストコードの書き方をより詳しく説明していきます。

### test()

`test()` はテストの最小単位を表現する関数です。

```ts
test("テストケース名", async ({ page }) => {
  // テストケース本体
});
```

この基本構造は非常に多くの機能を内包しています：

1. **テスト名**:
   最初の引数には、テストの内容を簡潔に表す説明的な名前を指定します。
2. **非同期関数**:
   第二引数には非同期関数（`async`）を指定します。これにより、`await` キーワードを使用して非同期操作を扱えます。
3. **フィクスチャ**:
   関数の引数（ここでは `{ page }`）は「フィクスチャ」と呼ばれ、Playwright が提供する様々なオブジェクトやユーティリティにアクセスできます。

#### フィクスチャについて

`page` オブジェクトは新しいブラウザウィンドウを表します。
これ以外にも、Playwright は以下のようなフィクスチャを提供しています：

- `browser`: ブラウザインスタンス。並列実行のワーカーごとに共有されます。
- `browserName`: 使用中のブラウザ名。
- `context`: テストごとに作られる実行コンテキスト。
- `page`: コンテキストで分離されたテストごとに作られるブラウザのページ。
- `request`: テストごとの Web API 実行のコンテキスト。

これらのフィクスチャは、テスト関数の第一引数としてアクセスできます。

#### testInfo

`testInfo`は、テスト実行に関する様々な情報や機能を提供するオブジェクトです。
テスト関数の 2 つ目の引数として利用できます。

- 現在実行中のテストのファイル名や名前、行番号などの情報が含まれています。
- タイムアウトなどの設定値を取得したり更新したりできます。
- 添付ファイル機能を使用できます。これにより、UI モードの結果の[Attachments]タブに添付ファイルを付与できます。

`testInfo`の添付ファイル機能は特に有用で、スクリーンショットやログファイル、その他のデータをテスト結果に添付することができます。これにより、テスト失敗時のデバッグがより容易になります。

### テストのグループ化

テストのグループ化は、テストコードの構造化と管理を容易にする重要な機能です。
Playwright では、`test.describe()`メソッドを使用してテストをグループ化することができます。
これにより、テストの可読性が向上し、関連するテストケースをまとめることができます。

グループ化には以下のメリットが存在します :

1. **コードの整理**: 関連するテストケースを論理的にまとめることができます。
2. **準備コードの削減**: グループ内で共通の設定や前処理を一箇所にまとめられます。
3. **テストの集中管理**: 特定の機能や画面に関するテストを集中的に管理できます。
4. **可読性の向上**: テストの構造が明確になり、全体の把握が容易になります。

Playwright でのテストのグループ化は、以下のように`test.describe()`を使用して行います：

```javascript
import { test } from "@playwright/test";

test.describe("一覧ページ", () => {
  test("一覧表示", async () => {
    // テストコード
  });

  test("個別表示", async () => {
    // テストコード
  });
});
```

この例では、「一覧ページ」というグループの中に「一覧表示」と「個別表示」という 2 つのテストケースがグループ化されています。

:::message
**ビヘイビア駆動開発（BDD）との関連**

`test.describe()`メソッドは、ビヘイビア駆動開発（BDD）の考え方に基づいています。
BDD はソフトウェア開発手法の一つで、「振る舞い」を中心にシステムの仕様を記述し、開発を進める方法です。
BDD は、テストコードを単なる検証ツールではなく、ソフトウェアの仕様を表現する「生きたドキュメント」として扱います。

BDD のテストを構成する要素として`describe`と`it`があります：

- `describe(〇〇)`: テスト対象（名詞）を指定
  〇〇をこれから説明します。
- `it(〇〇)`: それが行う動作（動詞）を指定
  それは〇〇という動きをします。

例えば：

```javascript
describe("ログイン画面", () => {
  it("正しいユーザーIDとパスワードを受け付けてログインさせる", () => {
    // テストコード
  });

  it("間違ったユーザーIDとパスワードではエラーを表示する", () => {
    // テストコード
  });
});
```

このような構造により、テストコードが自然言語に近い形で記述でき、テストの意図が明確になります。

Playwright は、`test.describe()`と`test()`を提供しており、これらは BDD の`describe`と`it`に相当します。

:::

### 準備・片付けコードを共有する

Playwright では、テストの準備や片付けのためのコードを効率的に管理するための特別なメソッドが提供されています。これらのメソッドを使用することで、複数のテスト間で共通の設定や後処理を簡単に共有できます。

Playwright は以下の 4 つの主要なフック関数を提供しています：

1. `test.beforeAll()`: 全てのテストの実行前に一度だけ実行されます。
2. `test.beforeEach()`: 各テストケースの実行前に毎回実行されます。
3. `test.afterEach()`: 各テストケースの実行後に毎回実行されます。
4. `test.afterAll()`: 全てのテストの実行後に一度だけ実行されます。

これらの関数を使用することで、テストの準備や後処理を効率的に行うことができます。

例えば、各テストの前にログイン処理を行いたい場合、以下のように`test.beforeEach()`を使用できます：

```javascript
test.beforeEach(async () => {
  await ログイン();
});
```

この設定により、各テストケースの実行前に自動的にログイン処理が行われます。

これらのフック関数は、テストファイル内で定義された順序に従って実行されます。
例えば、以下のようなコード構造がある場合：

```javascript
import { test } from "@playwright/test";

test.beforeEach("親 beforeEach", () => {});
test.beforeAll("親 beforeAll", () => {});
test.afterEach("親 afterEach", () => {});
test.afterAll("親 afterAll", () => {});

test("親テスト", async ({ page }) => {});

test.describe("テストスイート", () => {
  test.beforeEach("子 beforeEach", () => {});
  test.beforeAll("子 beforeAll", () => {});
  test.afterEach("子 afterEach", () => {});
  test.afterAll("子 afterAll", () => {});
  test("子テスト", async ({ page }) => {});
});
```

親テストの実行順序は以下のようになります :

1. 親 beforeAll
2. 親 beforeEach
3. 親テスト
4. 親 afterEach
5. 親 afterAll

子テストの実行順序は以下のようになります：

1. 親 beforeAll
2. 子 beforeAll
3. 親 beforeEach
4. 子 beforeEach
5. 子テスト
6. 子 afterEach
7. 親 afterEach
8. 子 afterAll
9. 親 afterAll

:::message

親テストと子テストは並列で実行される可能性があります。
そのため、どちらが先に実行されるかは状況によって変わる可能性があります。

`beforeAll()`や`afterAll()`などのフック関数は、全てのテストで共有される処理を行うため、テストスイート（`describe()`ブロック）またはグローバルスコープごとに並行して実行されます。

テストコードを書く際は、親テストと子テストの実行順序に依存しないように注意する必要があります。

:::

## すばやく繰り返す：テストの効率的な実行管理

E2E テスト開発において、効率的にテストを実行し、迅速なフィードバックを得ることは非常に重要です。Playwright は、この目的を達成するための便利な機能を提供しています。

### テスト実行の最適化

E2E テストは全画面に対して網羅的にテストを行うことが理想的ですが、開発の途中段階では特定の機能や画面に焦点を当ててテストを繰り返し実行することが効率的です。これにより、開発中の機能に関するフィードバックをすばやく得ることができ、開発の効率が向上します。

### skip()と only()の活用

Playwright は`skip()`と`only()`という 2 つの重要な機能を提供しています。これらを使用することで、テストの実行を柔軟に制御できます。

1. **skip()**: 特定のテストをスキップします。

   ```javascript
   test.skip("スキップするテスト", () => {
     // このテストは実行されません
   });
   ```

2. **only()**: 指定されたテストのみを実行します。
   ```javascript
   test.only("このテストのみを実行", () => {
     // このテストだけが実行されます
   });
   ```

これらの機能を使用することで、時間のかかる特定のテストをスキップしたり、開発中の機能に関連するテストのみを実行したりすることができます。

### only()の適用範囲

`only()`はグローバルスコープ、または`describe()`の同一階層のテストスイート内でのみ有効です。例えば：

```javascript
import { test } from "@playwright/test";

test("親テスト", async ({ page }) => {});

test.describe("テストスイート", () => {
  test("子テスト1", async ({ page }) => {});
  test.only("子テスト2", async ({ page }) => {});
});
```

この場合、「子テスト 2」のみがスキップされ、「親テスト」と「子テスト 2」が実行されます。

:::message

`skip()` や `only()` の使用は開発中の一時的な措置として有用ですが、コードをコミットする前には必ず削除または無効化してください。

これらの機能をコミットしたままにすると、CI/CD パイプラインで一部のテストが実行されなかったり、重要なテストがスキップされたりする可能性があります。

:::

はい、承知しました。添付画像の内容を踏まえて、以下のような解説文を作成しました。

## テストファイルの命名

テストファイルの適切な命名と構造化は、テストスイートの管理と保守性を向上させる重要な要素です。Playwright では、デフォルトで特定の命名規則に従ったファイルをテストファイルとして認識します。

Playwright は、デフォルトで以下の正規表現にマッチするファイルをテストファイルとして扱います：

```
*.（test|spec).（js|ts|mjs）
```

この規則は多くのエディタでも認識され、テストファイルとして特別な扱いを受けます。
例えば、Visual Studio Code では、この規則に従ったファイルは通常のソースコードファイルとは異なる色で表示され、検索性が向上します。

ソースコードは通常フォルダで階層化して管理しますが、E2E テストファイルは異なるアプローチを取ることが有効です。E2E テストはソースコードとドキュメントの中間的な性質を持つため、ユーザーの操作フローに沿った順序で管理すると理解しやすくなります。

例えば、以下のような命名規則を採用することで、テストの流れが一目で分かるようになります：

```
00_login.spec.ts
10_create_report.spec.ts
20_view_report.spec.ts
30_search_report.spec.ts
40_share_report.spec.ts
```

この命名方法には以下の利点があります：

1. テストの実行順序が明確になる
2. ユーザーの操作フローとテストコードの順序が対応する
3. エディタやテストランナーでテストフォルダを見たときの可読性が向上する

Playwright はデフォルトでファイルごとに並行してテストを実行するため、ファイル名の数字プレフィックスが実行順序を強制するわけではありません。並列実行のモードはファイルごとの設定やプロジェクト全体の設定、`--fully-parallel`オプションで変更可能です。

:::message

ただし、以下の点に注意が必要です：

1. 高速化のためだけにファイルを分割する必要はありません
2. テストケース内部のテストも並列実行させることが可能です
3. 管理しやすい単位でファイルを分けることが重要です

:::

## 認証を伴うテスト

Web アプリケーションのテストにおいて、認証が必要なページのテストは特別な配慮が必要です。
この種のテストには独特の課題があり、効率的に実施するためのいくつかの戦略があります。

### 認証テストの課題

1. **頻繁な認証の必要性**:
   正攻法では各テストケースで認証を行う必要がありますが、これにはいくつかの問題があります：

   - テストケースごとに Cookie などがリセットされる
   - 毎回ログイン処理を行うと、テストの実行時間が大幅に増加する

2. **セキュリティ上の配慮**:

   - 認証サービスは、ブルートフォース攻撃対策として、失敗時にウェイトを設けたり、一定時間内の認証回数を制限したりすることがあります。
   - これらの対策により、正当なテストでも認証に時間がかかる場合があります。

3. **実際のユーザー体験との乖離**:
   - 通常のユーザーは 1 日に一度程度しか認証を行わないのに対し、テストでは頻繁に認証を行うことになります。

### 効率的なテスト方法

これらの課題に対処するため、以下のようなアプローチが考えられます：

1. **テストケースの集約**:

   - 一度ログインしたら、複数のテストを連続して実行する
   - ただし、テストケースは可能な限り独立性を保つべきです

2. **フェイク認証の利用**:

   - 外部の認証機構の代替を作成し、テストのポータビリティを向上させる

3. **セッション情報の再利用**:

   - Cookie などのセッション情報を保存し、複数のテストで再利用する
   - これは正攻法のパターンとして認識されています

4. **認証回避モードの実装**:
   - 開発時によく使われる方法ですが、フレームワークによって実装方法が異なります

### セッション情報を再利用する

Playwright のセッション情報再利用の仕組みは以下の流れで動作します：

1. 初回のログイン処理を実行し、その結果（Cookie、ローカルストレージなど）を JSON ファイルに保存
2. 以降のテストでは、保存した JSON ファイルを読み込んでブラウザのセッション情報を復元
3. 認証済みの状態からテストを開始

この方法により、1 回のログインで複数のテストケースを実行できるようになります。

手順としては下記の通りです :

1. **セットアッププロジェクトの作成**

   まず、`playwright.config.ts`ファイルで認証用のセットアッププロジェクトを定義します：

   ```typescript
   import { defineConfig, devices } from "@playwright/test";

   export default defineConfig({
     projects: [
       { name: "setup", testMatch: /.*\.setup\.ts/ },
       {
         name: "chromium",
         use: {
           ...devices["Desktop Chrome"],
           storageState: "playwright/.auth/user.json",
         },
         dependencies: ["setup"],
       },
       // 他のブラウザ設定も同様に
     ],
   });
   ```

   この設定の重要なポイント：

   - `setup`プロジェクトは`.setup.ts`で終わるファイルをテストとして実行
   - `chromium`プロジェクトは`storageState`オプションで認証情報の JSON ファイルを指定
   - `dependencies: ['setup']`により、`setup`プロジェクト実行後に`chromium`プロジェクトが実行される

2. **認証処理の実装**

   次に、`auth.setup.ts`ファイルで実際の認証処理を実装します：

   ```typescript
   import { test as setup, expect } from "@playwright/test";

   const authFile = "playwright/.auth/user.json";

   setup("authenticate", async ({ page }) => {
     // 1. ログインページにアクセス
     await page.goto("http://localhost:8888");

     // 2. ログイン情報を入力
     await page
       .getByPlaceholder("Email Address / Username")
       .fill("admin@example.com");
     await page.getByPlaceholder("Password").fill("very-strong-password");

     // 3. ログインボタンをクリック
     await page.getByRole("button", { name: "Login" }).click();

     // 4. ログイン後のページ遷移を待機
     await page.waitForURL("http://localhost:8888/browser/");

     // 5. ログイン成功の確認
     await expect(page.getByText(/Object Explorer/)).toBeVisible();

     // 6. セッション情報をJSONファイルに保存
     await page.context().storageState({ path: authFile });
   });
   ```

   このスクリプトの動作：

   1. 指定された URL にアクセス
   2. ユーザー名とパスワードを入力
   3. ログインボタンをクリック
   4. ログイン後のページ遷移を待機
   5. ログイン成功を確認（この例では "Object Explorer" テキストの存在を確認）
   6. 現在のセッション情報（Cookie、ローカルストレージなど）を JSON ファイルに保存

3. **認証済み状態でのテスト実行**

   セッション情報が正しく設定されていれば、以降のテストではログイン処理を省略できます：

   ```typescript
   import { test, expect } from "@playwright/test";

   test("open About dialog", async ({ page }) => {
     // 1. 既にログイン済みの状態でページにアクセス
     await page.goto("http://localhost:8888/browser/");

     // 2. ヘルプボタンをクリック
     await page.getByRole("button", { name: /Help/ }).click();

     // 3. "About pgAdmin 4" をクリック
     await page.getByText(/About pgAdmin 4/).click();

     // 4. ダイアログが表示されたことを確認
     await expect(page.getByText(/Application Mode/)).toBeVisible();
   });
   ```

   このテストは、ログイン処理なしで直接目的のページにアクセスし、操作を行います。

4. **セッション情報の中身**
   `playwright/.auth/user.json`ファイルには以下のような情報が保存されます：

   ```json
   {
     "cookies": [
       {
         "name": "pga4_session",
         "value": "d759c0f9-7f4b-4bce-ba62-73c11428c947f6+JXaTEFUVhGc/yWmky2DB2nY0F0CRRN3v/dQqJRUe8=",
         "domain": "localhost",
         "path": "/",
         "expires": 1703889357.696225,
         "httpOnly": true,
         "secure": false,
         "sameSite": "Lax"
       }
     ],
     "origins": [
       {
         "origin": "http://localhost:8888",
         "localStorage": [
           {
             "name": "__test__",
             "value": "ud800"
           }
         ]
       }
     ]
   }
   ```

   この JSON ファイルには：

   - Cookie の情報（名前、値、ドメイン、パス、有効期限など）
   - ローカルストレージの情報
   - オリジン（接続先の URL）

   が含まれています。

:::message

**注意点とベストプラクティス**

1. **セキュリティ**
   `user.json`ファイルには機密情報が含まれる可能性があるため、`.gitignore`に追加してバージョン管理から除外することが重要です。

2. **有効期限**
   セッション情報は一定期間後に無効になる可能性があるため、テスト実行前に定期的に再生成する仕組みを検討してください。

3. **環境依存**
   テスト環境と本番環境で異なるセッション管理方式が使用されている場合、この方法が適用できない可能性があります。環境間の差異に注意してください。

4. **並列実行**
   Playwright はデフォルトでテストを並列実行します。
   セッション情報の共有方法によっては、テスト間で競合が発生する可能性があるため、適切な設計が必要です。

5. **メンテナンス**
   ログインプロセスが変更された場合、`auth.setup.ts`ファイルの更新が必要になります。
   定期的なメンテナンスを忘れずに行ってください。

:::
