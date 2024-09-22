---
title: "E2Eテスト"
---

## E2E テスト とは？

ユーザーの実際の使用シナリオに基づいて、アプリケーションの開始から終了までの全プロセスをテストする手法。

Web アプリケーションは、以下にある様々なモジュールを組み合わせて実装する。

1. ライブラリが提供する関数
2. ロジックを担う関数
3. UI を表現する関数
4. Web API クライアント
5. API サーバー
6. DB サーバー

E2E テストは、1〜6 までを「ヘッドレスブラウザ」+「UI オートメーション」の組み合わせを中心に構成されたテスティングフレームワークで実施する。
そのため、ブラウザ固有の API を使用したり、画面をまたぐ機能テストに向いている。

![](https://storage.googleapis.com/zenn-user-upload/3f883d46c242-20240919.png)

**「何をテストするのか？」という目的を明確にすることが重要。**（他のテストでもそうだが...）

## どういうケースに E2E テストが必要か？

### ブラウザ固有の機能連携を含むテストがしたい

以下のようなブラウザを使用した忠実性の高いテストは、UI コンポーネントテストで使用される Jset + jsdom 等では不十分である。

- 複数画面をまたぐ機能
- 画面サイズから算出するロジック
- CSS メディアクエリーによる、表示要素切り替え
- スクロール位置によるイベント発火
- Cookie やローカルストレージなどへの保存

このような場合、E2E テスティングフレームワークを使用して一連の機能連携を検証する。
![](https://storage.googleapis.com/zenn-user-upload/c000f97033ff-20240919.png)

ブラウザ固有の機能&インタラクション」に着眼できればよ良い場合、API サーバーやサブシステムはモックサーバーを使用する。

このテストは、「フィーチャーテスト」とも呼ばれる。

### DB やサブシステム連携を含むテストがしたい

下記のような、**本物に近い環境**を再現してテストしたい場合があるだろう。

- DB サーバーと連携し、データを読み書きする
- 外部ストレージサービスと連携し、メディアをアップロードする
- Redis と連携し、セッション管理する

E2E テスティングフレームワークは、対象のアプリケーションをブラウザ越しに操作可能なため、上記のテストケースに対応できる。

Web フロントエンド層、Web アプリケーション層、永続層が連携することを検証するため、忠実性が高い自動テストが可能。
![](https://storage.googleapis.com/zenn-user-upload/f7ecb842f8a6-20240919.png)

## トレードオフ

E2E テストは多くのシステムと連携する。「DB やサブシステム連携を含むテスト」は特にそう。
よって以下のデメリットがある。

- 実行時間が長い
- 不安定で稀に失敗する
- 実装コストが高い

![](/images/frontend-test-summary/relationship-between-test-coverage-and-cost.png)

## Playwright 基礎

Playwright は、Microsoft から公開されている E2E テストフレームワーク。
クロスブラウザ対応しており、デバッガー／レポーター／トレースビューワー／テストコードジェネレーター機能など、多くの機能を備えている。

### インストールと設定

```shell
npm init playwright@latest
```

インストールが完了すると、設定ファイルの雛形と、サンプルテストコードが出力される。

```
.
├── e2e
│   └── example.spec.ts
├── package-lock.json
├── package.json
├── playwright.config.ts
└── tests-examples
    └── demo-todo-app.spec.ts
```

### E2E テストチュートリアル

```ts: e2e/example.spec.ts
import { test, expect } from "@playwright/test";

test("has title", async ({ page }) => {
  await page.goto("https://playwright.dev/");

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Playwright/);
});

test("get started link", async ({ page }) => {
  await page.goto("https://playwright.dev/");

  // Click the get started link.
  await page.getByRole("link", { name: "Get started" }).click();

  // Expects page to have a heading with the name of Installation.
  await expect(
    page.getByRole("heading", { name: "Installation" })
  ).toBeVisible();
});
```

どのテストも、ブラウザを起動し、指定の URL へ訪問するとことから始まっている。
`page.goto` で指定している `https://playwright.dev/` は、Playwright の公式 Doc ページ。

- 「`has title`」のテストは、ページのタイトルに `Playwright` という文字列が含まれていることを確認している
- 「`get started link`」のテストは、`Get started` のリンクをクリックし、ページ遷移後に `Installation` と表示される見出しが存在することを確認している

**手動でブラウザを操作してアプリケーションを検証するようなテストが、コードにより自動化されている。**

:::message
実際のテストでは、上記のように一般公開されている Web ページにアクセスすることはない。
テスト環境やローカル開発環境で Web アプリケーションサーバーを起動し、テストを実施する。
:::

上記テストは「Locator」と「Assertions」で成り立っている。

### Locator

ウェブページ上の要素（または要素のセット）を表す軽量なオブジェクト。
実際の要素への参照ではなく、要素を見つけるための「命令」のようなもの。

どういうこと？

想像してください。あなたが友人に「図書館で赤い表紙の本を取ってきて」と頼むとします。

1. **「命令」（Locator）**

   - この場合、「赤い表紙の本」が命令（Locator）に相当します
   - この指示は、本を特定するための情報を提供しますが、まだ具体的な本そのものではありません

2. **実際の本（ウェブページ上の要素）**

   - 友人が図書館に行って、実際に赤い表紙の本を見つけたときに初めて、具体的な本が特定されます

3. **Locator の特徴**
   - 柔軟性：図書館の本の配置が変わっても、「赤い表紙の本」という指示は有効です
   - 遅延評価：友人が実際に図書館に行くまで（つまり、テストが実行されるまで）、どの本が選ばれるかはわかりません

ウェブページでの実際の例：

```javascript
// Locatorの作成（指示書を書く）
const loginButton = page.getByRole("button", { name: "ログイン" });

// Locatorの使用（指示に従って要素を見つけ、操作する）
await loginButton.click();
```

この場合、

- `page.getByRole('button', { name: 'ログイン' })` が命令（Locator）です
- `.click()` を呼び出したときに初めて、Playwright はその命令に従ってページ上の実際のボタンを探し、クリックします

Locator の利点は以下にあります。

1. **柔軟性**
   ページの構造が少し変わっても、「ログイン」という名前のボタンを探すという指示は有効です。
2. **読みやすさ**
   テストコードを読むだけで、何をしようとしているのかが明確です。
3. **自動待機**
   ボタンがページ上に現れるまで自動的に待ってくれます。

このように、Locator は「要素を見つけるための指示」を提供し、実際にその指示が実行されるのはテスト実行時です。これにより、より柔軟でメンテナンスしやすいテストを書くことができます。

### Assertions

1. **基本構造**
   ```ts
   await expect(実際の値や状態).アサーションメソッド(期待値);
   ```
2. **主要なアサーションメソッド**

   - `toBeVisible()`: 要素が表示されているか
   - `toHaveText(text)`: 要素が特定のテキストを持っているか
   - `toHaveValue(value)`: 入力フィールドが特定の値を持っているか
   - `toBeEnabled()`: 要素が有効（クリックや入力が可能）か
   - `toBeChecked()`: チェックボックスがチェックされているか
   - `toHaveAttribute(name, value)`: 要素が特定の属性と値を持っているか

3. **実際の例**

   ```ts
   // ログインボタンが表示されているか確認
   await expect(page.getByRole("button", { name: "ログイン" })).toBeVisible();

   // ウェルカムメッセージが正しいか確認
   await expect(page.getByText("ようこそ、ユーザーさん")).toBeVisible();

   // 入力フィールドに正しい値が入力されているか確認
   await expect(page.getByLabel("ユーザー名")).toHaveValue("testuser");

   // エラーメッセージが表示されていないことを確認
   await expect(page.getByText("エラーが発生しました")).not.toBeVisible();

   // ページのURLに "intro" が含まれていることを検証
   await expect(page).toHaveURL(/.*intro/);
   ```

4. **特徴**

   - 自動待機：デフォルトでは、アサーションが真になるまで一定時間（通常 5 秒）待機する。
   - 明確なエラーメッセージ：アサーションが失敗した場合、何が期待され、実際には何が起こったかを明確に示すエラーメッセージが生成される。

5. **否定のアサーション**
   `not` を使用して、「〜でないこと」を確認できる。

   ```javascript
   await expect(page.getByText("エラー")).not.toBeVisible();
   ```

6. **複雑なアサーション**
   複数の条件を組み合わせたり、正規表現を使用したりすることも可能。

   ```javascript
   // テキストが正規表現にマッチするか確認
   await expect(page.getByRole("heading")).toHaveText(/ようこそ、.+さん/);
   ```

7. **ソフトアサーション**

   - 通常、アサーションでテストが失敗した場合、その失敗したアサーションでテストが終了してしまう
   - ソフトアサーションを利用することで、すべてのアサーションを実行して、失敗したアサーションの一覧を確認できるようになる

   ```ts
   await expect.soft(page.getByTestId("status")).toHaveText("Success");
   await expect.soft(page.getByTestId("eta")).toHaveText("1 day");
   ```

### 参考リンク

https://qiita.com/ore88ore/items/bd5a1b65166027806096#locator-%E3%82%92%E5%88%A9%E7%94%A8%E3%81%99%E3%82%8B

## E2E テストの始め方

E2E テストが何者か？やテスティングフレームワークの基本的な使い方は理解した。
しかし、どのように始めれば良いのか？
いきなり「E2E テストやっといて」と言われても困る...

それは「**何をどのようにテストすれば良いのか？**」を定めていないから。

### 「テストシナリオ」と「テストケース」を理解する

- **テストシナリオ**はユーザーの「振る舞い」が検証対象
- **テストケース**は「振る舞い」の中で発生する、特定の「アクション」が検証対象
- **テストシナリオ**は**テストケース**を内包する
- **テストケース**は**テストシナリオ**の中に複数存在できる
- **テストケース**が 1 つの場合もある
- **テストケース**が 1 つの場合、**テストシナリオ** = **テストケース** と捉えることができる

### EC サイトを例にテストコードを書いてみる

ログインから商品購入までの流れを検証したい。

この場合、ユーザーの「振る舞い」即ち**テストシナリオ**は、

- 既存ユーザーが EC サイトにログインし、商品を検索して購入するまでの一連の流れ

と定義できる。

そして、「振る舞い」の中で発生する、特定の「アクション」即ちテストケースをリストアップする。

1. 正しい認証情報を使用してユーザーが正常にログインできる
2. 特定のキーワードで商品を検索できる
3. 商品詳細ページで正確な情報を確認できる
4. 商品をショッピングカートに追加できる
5. チェックアウトプロセスを開始できる
6. 正確な配送先情報を入力できる
7. 有効な支払い情報を入力できる
8. 注文を正常に完了できる

上記を基に、Playwright を用いて E2E テストコードを実装する。

```ts
const { test, expect } = require("@playwright/test");

test.describe("既存ユーザーがECサイトにログインし、商品を検索して購入するまでの一連の流れ", () => {
  test.beforeEach(async ({ page }) => {
    // 各テストケース前の共通セットアップ
    await page.goto("https://example-ec-site.com");
  });

  test("正しい認証情報を使用してユーザーが正常にログインできる", async ({
    page,
  }) => {
    await page.click("#login-link");
    await page.fill("#username", "testuser@example.com");
    await page.fill("#password", "password123");
    await page.click("#login-button");
    await expect(page.locator(".user-dashboard")).toBeVisible();
  });

  test("ユーザーが特定のキーワードで商品を検索できる", async ({ page }) => {
    // ログイン処理（前提条件）
    // ...
    await page.fill("#search-input", "スマートフォン");
    await page.click("#search-button");
    await expect(page.locator(".search-results")).toContainText(
      "スマートフォン"
    );
  });

  test("ユーザーが商品詳細ページで正確な情報を確認できる", async ({ page }) => {
    // ログインと検索処理（前提条件）
    // ...
    await page.click(".product-item:first-child");
    await expect(page.locator(".product-details")).toBeVisible();
    await expect(page.locator(".product-price")).toBeVisible();
    await expect(page.locator(".product-description")).toBeVisible();
  });

  test("ユーザーが商品をショッピングカートに追加できる", async ({ page }) => {
    // ログイン、検索、商品詳細ページアクセス（前提条件）
    // ...
    await page.click("#add-to-cart-button");
    await expect(page.locator(".cart-count")).toHaveText("1");
  });

  test("ユーザーがチェックアウトプロセスを完了できる", async ({ page }) => {
    // ログイン、商品追加まで（前提条件）
    // ...
    await page.click("#checkout-button");
    await page.fill("#name", "テスト ユーザー");
    await page.fill("#address", "東京都渋谷区テスト町1-2-3");
    await page.fill("#phone", "03-1234-5678");
    await page.click("#next-to-payment");
    await page.fill("#card-number", "4111111111111111");
    await page.fill("#card-expiry", "12/25");
    await page.fill("#card-cvc", "123");
    await page.click("#place-order-button");
    await expect(page.locator(".order-complete")).toBeVisible();
    await expect(page.locator(".order-number")).toBeVisible();
  });
});
```

- `test.describe` でテストシナリオ全体をグループ化し、各 `test` で個別のテストケースを表現することで、テストコードの構造が明確になる
- 各テストケースが何をテストしているのか、一目で分かる
- 個別のテストケースに分けることで、特定の機能に変更があった場合、関連するテストケースのみを修正すればよくなる
- 失敗した場合、どのテストケースで問題が発生したのかを特定しやすい
- 各テストケースを独立して実行できるため、テストの信頼性が向上する

ログインのテストは別のテストシナリオでも頻繁に行われることが多いと予測されるため、このような共通操作を関数として切り出すと良い。

## E2E テストを運用していく上で気をつけること

E2E テストは安定運用の難易度が高い。
ネットワーク遅延やメモリ不足によるサーバーからのレスポンス遅延など、原因は様々。

このようなテストは**Flaky テスト（稀に失敗するテスト）**と呼ばれる。
どのように対処すれば良いのか？

### 実行ごとに DB をリセットしよう

永続層を含めた E2E テストを行う場合、テスト後にはデータの内容が変化する。
何度実行しても同じ結果となるよう、スタート地点の状態も同じにする必要がある。

seed スクリプトを用意し、テスト実行の度に初期値にリセットするなどの対策を取ると良い。

### テストユーザーをテストごとに作成しよう

プロフィール編集など、用意していたユーザー情報を変更するテストは破壊的。
そのため、それぞれのテスト向けに、異なるユーザーアカウントを使用し、ユーザーを使い捨てるのが得策

### リソースがテスト間で競合しないようにしよう

Playwright のテストは並列実行されるため、テストが実行される順番が保証されない。
よって、「投稿記事の編集機能をテストする」などの場合、それぞれのテストで新規リソースを作成する。

### 非同期処理は待とう

操作対象の要素が存在し、間違いなくインタラクションを与えているにもかかわらずテストが失敗する場合がある。
そんな時は非同期処理の応答を待機できていることを確認しよう。

### CI 環境と CPU コア数をあわせて確認しよう

CI 環境だけで失敗する場合、ローカルマシンの CPU コア数と CI 環境の CPU コア数が揃っているか確認しよう。
Playwright や Jest は明示的な指定がなければ、実行環境で可能な限りテストスイートの並列実行を試み、この並列実行数は CPU コア数によって変動する。

CPU コア数が変動しないよう固定設定に使用（テストランナーで指定ができる）。
CI にコア数をあわせた上でローカルマシンでもパスすれば、この課題が解決するかもしれない。
そのほか、待ち時間上限を高くするなど対処しましよう。いずれの対処も、テスト実行時間は長くなるが、CI が何度も失敗してやり直すよりも、総合ではずっと時間を短縮できる。

### 【Next.js】ビルド済みのアプリケーションサーバーでテストしよう

Next.js では、開発サーバーとビルド済みサーバーとで挙動が異なる。
