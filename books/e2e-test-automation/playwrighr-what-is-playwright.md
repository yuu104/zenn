---
title: "【Playwright】Playwrightとは？"
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
