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
