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

## ロケーター

ここでは、ロケーターについて深ぼって解説します。

ロケーターはページ上の要素を見つけるための機能です。
主要メソッドは下記の通りです。

| メソッド                  | 説明                                                 |
| ------------------------- | ---------------------------------------------------- |
| `page.getByRole()`        | アクセシビリティ属性によって検索                     |
| `page.getByLabel()`       | 関連するラベルのテキストでフォームコントロールを検索 |
| `page.getByPlaceholder()` | プレースホルダーをもとに入力欄を検索                 |
| `page.getByText()`        | テキストコンテンツで検索                             |
| `page.getByAltText()`     | 代替テキストによって要素（通常は画像）を検索         |
| `page.getByTitle()`       | タイトル属性によって要素を検索                       |
| `page.getByTestId()`      | data-testid 属性に基づいて要素を検索                 |

現状は下記になります。
しかし、セマンティック HTML と `getByRole`、そしてこのメソッドを優先的に使用すべき理由へのつながりが少し分かりにくいのかなと思います。
ブラッシュアップしてください。

### getByRole

アクセシビリティ属性に基づいて要素を特定し、取得します。
このメソッドは、アクセシビリティを考慮したテスト作成に非常に有用です。

アクセシビリティ属性には、ボタン、リンク、テキストボックスなどがあり、これらの要素は、HTML のタグが持つ役割（Role）によって定義されます。
例えば、`<button>` タグには自動的に `button` というロールが割り当てられます。

:::message
`getByRole` は**セマンティック HTML**の原則に基づいています。

「セマンティック HTML」とは、HTML の構造が内容の意味を適切に表現することを指します。
例えば：

- `<button>` は「クリック可能なボタン」を意味します
- `<nav>` は「ナビゲーション領域」を示します
- `<a>` は「リンク」を表します

人間のユーザーは視覚的にこれらの要素の役割を理解できますが、スクリーンリーダー（視覚障害者が使用する UI 操作を音声読み上げで行うツール）は、この視覚的な判断ができません。

そこで、HTML 上に「これはボタンである」という情報を明示的に示すことで、スクリーンリーダーが「ログインと書かれたボタン」と認識できるようになります。
:::

`getByRole()` は、このスクリーンリーダー向けの HTML の仕組みを利用して、要素の正確な位置情報を指定できるようにしています。

例えば、次のような HTML があるとします：

```html
<div>
  <button>更新</button>
  <nav><a href="/news">最新情報</a></nav>
</div>
```

この HTML に対して、ロールで要素を探すには次のようなコードを使用します：

```javascript
test("ロール名で要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("link", { name: /最新情報/ })).toBeVisible();
  await expect(page.getByRole("button", { name: /更新/ })).toBeVisible();
});
```

`getByRole()`を使用すると、「送信と書かれたボタン」のような、**自然言語の仕様書に簡単に読み替えられるようなテストコード**が書けます。

:::message
**ロケーターを選ぶ際は、`getByRole`を真っ先に検討すべきです。**
**セマンティック HTML を考慮したテストコードは、より堅牢で、変更用意性に強くなります。**
:::

:::details 利用頻度が高いロール一覧

| ロール       | 該当するタグ                                                                                                 |
| ------------ | ------------------------------------------------------------------------------------------------------------ |
| form         | `<form>`                                                                                                     |
| dialog       | `<dialog>`                                                                                                   |
| button       | `<button>`, `<input type="button">`, `<input type="image">`, `<input type="reset">`, `<input type="submit">` |
| checkbox     | `<input type="checkbox">`                                                                                    |
| spinbutton   | `<input type="number">`                                                                                      |
| radio        | `<input type="radio">`                                                                                       |
| slider       | `<input type="range">`                                                                                       |
| textbox      | 上記以外の`<input>`, `<textarea>`                                                                            |
| combobox     | `<select>` (multiple 属性がついておらず size が 1)                                                           |
| listbox      | `<select>` (上記以外)                                                                                        |
| group        | `<optgroup>`, `<details>`, `<fieldset>`                                                                      |
| option       | `<option>`                                                                                                   |
| progressbar  | `<progress>`                                                                                                 |
| link         | `<a>`, `<area>`                                                                                              |
| status       | `<output>`                                                                                                   |
| list         | `<menu>`, `<ol>`, `<ul>`                                                                                     |
| listitem     | `<li>`                                                                                                       |
| definition   | `<dd>`                                                                                                       |
| term         | `<dfn>`, `<dt>`                                                                                              |
| table        | `<table>`                                                                                                    |
| caption      | `<caption>`                                                                                                  |
| rowgroup     | `<tbody>`, `<tfoot>`, `<thead>`                                                                              |
| row          | `<tr>`                                                                                                       |
| cell         | 通常の`<table>`に属し scope 属性のない`<th>`, `<td>`                                                         |
| gridcell     | role が grid, treegrid に指定された`<table>`に属す`<th>`, `<td>`                                             |
| columnheader | scope 属性が col の`<th>`                                                                                    |
| rowheader    | scope 属性が row の`<th>`                                                                                    |

:::

:::details 利用頻度が低いロール一覧

| ロール        | 該当するタグ                                                    |
| ------------- | --------------------------------------------------------------- |
| document      | `<html>`                                                        |
| main          | `<main>`                                                        |
| banner        | `<header>`                                                      |
| contentinfo   | `<footer>`                                                      |
| complementary | `<aside>`                                                       |
| navigation    | `<nav>`                                                         |
| article       | `<article>`                                                     |
| paragraph     | `<p>`                                                           |
| region        | `<section>`, `<p>`                                              |
| heading       | `<h1>`, `<h2>`, `<h3>`, `<h4>`, `<h5>`, `<h6>`                  |
| separator     | `<hr>`                                                          |
| blockquote    | `<blockquote>`                                                  |
| code          | `<code>`                                                        |
| img           | `<img>` (alt 属性が設定済みか tabindex 属性がある場合), `<svg>` |
| presentation  | `<img>` (alt 属性が空かつ tabindex 属性がない場合)              |
| figure        | `<figure>`                                                      |
| strong        | `<strong>`                                                      |
| subscript     | `<sub>`                                                         |
| superscript   | `<sup>`                                                         |
| emphasis      | `<em>`                                                          |
| insertion     | `<ins>`                                                         |
| deletion      | `<del>`                                                         |
| time          | `<time>`                                                        |
| mark          | `<mark>`                                                        |
| meter         | `<meter>`                                                       |
| math          | `<math>`                                                        |

:::

### getByLabel

`getByLabel()` は、HTML フォームのラベルテキストに基づいて要素を特定し、取得します。
ラベルは通常 `<input>` タグに付けられるので、このメソッドはフォーム要素の検索によく利用されます。

このメソッドを使用すると、ユーザーインターフェイスの視覚的な側面に基づいてテストを書くことができ、実際のユーザー体験により近いテストが可能になります。

例えば、次のような HTML があるとします。

```html
<div>
  <label for="searchbox">検索</label>
  <input
    type="search"
    name="searchword"
    id="searchbox"
    placeholder="検索ワード"
  />
</div>
```

この HTML に対して、ラベルで要素を探すには次のようなコードを使用します。

```javascript
test("ラベル名で要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByLabel("検索")).toBeVisible();
});
```

`getByLabel()` を使用することで、以下のような利点があります。

1. **アクセシビリティの向上**
   ラベルとフォーム要素の適切な関連付けを促進します。
2. **ユーザー中心のテスト**
   実際のユーザーが見る内容に基づいてテストを書くことができます。
3. **堅牢性**
   ID やクラス名の変更に影響されにくいテストを作成できます。

`getByLabel()` は特にフォーム要素のテストに有用ですが、常に適切なラベル付けがされていることを前提としています。
ラベルが存在しない場合や、適切に関連付けられていない場合は、他のロケーターメソッドの使用を検討する必要があります。

### getByPlaceholder()

`getByPlaceholder()` は、HTML 要素の `placeholder` 属性を持つ要素を特定し、取得します。placeholder（プレースホルダー）は、テキストボックスにまだデータが入っていない場合に表示される文字列です。

このメソッドは、特にフォーム要素のテストに有用です。

例えば、次のような HTML があるとします。

```html
<div>
  <label for="searchbox">検索</label>
  <input
    type="search"
    name="searchword"
    id="searchbox"
    placeholder="検索ワード"
  />
</div>
```

以下は、プレースホルダーが `検索ワード` である要素を取得するテストの例です。

```javascript
test("プレースホルダーで要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByPlaceholder("検索ワード")).toBeVisible();
});
```

:::message
フォーム要素にはラベルを付けるのが推奨されており、ラベルが付いているのであれば、このロケーターの代わりに前項の `getByLabel()` でテストを行うことが推奨されます。

UI フレームワークによっては、ラベルがプレースホルダーとして使われており、HTML タグそのものには `placeholder` 属性がない場合があります。
その場合は `getByPlaceholder()` は使えません。
:::

### getByText()

`getByText()` は、要素に含まれるテキストを基に要素を取得します。
このメソッドは非常に柔軟で、部分文字列、完全な文字列、正規表現でのマッチが可能です。

この方法は、ページ上の可視テキストを使って要素を特定するため、ユーザーの視点に近いテストを書くことができます。

以下は、`page` オブジェクトに対し、テキストが"ホーム"である要素を取得して画面上に表示されていることを確認する、サンプルとテストです：

```html
<div>
  <a href="/home">ホーム</a>
</div>
```

```javascript
test("テキストで要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByText("ホーム")).toBeVisible();
});
```

`getByText()` の特徴は下記の通りです。

1. **柔軟性**
   完全一致、部分一致、正規表現によるマッチングが可能です。
2. **ユーザー中心**
   実際にユーザーが画面上で見るテキストを使ってテストを書けます。
3. **シンプル**
   ページ内を単純に文字列検索して要素を取得する点が特徴的です。

:::message
`getByRole()` でもリンクのラベルから要素取得を行えますが、`getByText()` はそのテキストがどのようなロールを持っているかは気にせず、ページ内を単純に文字列検索して取得する点が異なります。
:::

`getByText()` は特に、ボタンのラベル、リンクのテキスト、段落のテキストなど、画面上に表示されるテキストベースの要素を特定する際に有用です。
ただし、非表示の要素や、テキストが動的に変更される要素に対しては注意が必要です。

アクセシビリティを重視する場合は `getByRole()` を優先的に使用し、`getByText()` はその補完的な役割として使うことが推奨されます。

### getByAltText()

`getByAltText()` は、HTML 要素の `alt` 属性に基づいて画像やその他の要素を特定し、取得します。`alt` 属性は HTML 内の `<img>` タグなどで使用され、画像の内容や機能をテキスト形式で説明します。

このメソッドは、特に画像や画像ボタンのテストに有用です。以下は、`page` オブジェクトに対して `alt` 属性が"かわいいわんこ"である要素を取得し、その取得した要素をクリックする、サンプルとテストです。

```html
<div>
  <img
    width="200"
    height="200"
    src="./assets/cute-dog.png"
    alt="かわいいわんこ"
    title="2024/02/21 撮影"
  />
</div>
```

```javascript
test("alt属性で要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByAltText("かわいいわんこ")).toBeVisible();
});
```

`getByAltText()` の特徴と注意点は以下の通りです。

1. **アクセシビリティ**
   `alt` 属性はスクリーンリーダーユーザーにとって重要な情報源です。
   このメソッドを使用することで、アクセシビリティを考慮したテストが可能になります。

2. **視覚的に不可視**
   スクリーンリーダー以外の通常のブラウジングでは、この `alt` 属性がユーザーの目に触れることはありません。

3. **特定のユースケース**
   アイコンのみで表現されたツールバーなど、ユーザーが画像を見て操作対象を選ぶようなケースの場合、「絵でマッチ」というのはテストコードでは表現できないため、その代替手段として（しかたなく）使うのが適切な方法と言えます。

4. **画像以外の要素**
   `alt` 属性は主に画像に使用されますが、他の要素（例：`<area>`、`<input type="image">` など）にも使用可能です。

:::message
`getByAltText()` は視覚的に確認できない属性を使用するため、ユーザーの実際の操作とは異なる場合があります。
可能な限り、`getByRole()` や `getByText()` などの視覚的に確認可能な方法を優先し、`getByAltText()` は補完的に使用することが推奨されます。
:::

このメソッドは、特に画像ベースのナビゲーションや、画像が重要な意味を持つウェブサイトのテストに有用です。ただし、過度に依存すると保守性の低いテストになる可能性があるため、適切なバランスで使用することが重要です。

### getByTitle()

`getByTitle()` は、HTML 要素の `title` 属性を使用して要素を特定し、取得します。
`title` 属性は `<a>` タグや `<img>` タグといった一部のタグで利用できます。
`title` 属性の値は通常、マウスオーバーしたときに表示されます。

```javascript
test("title属性で要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByTitle("2024/02/21 撮影")).toBeVisible();
});
```

`getByTitle()` の特徴と注意点。

1. **補足情報の検証**: `title` 属性は通常、要素に関する追加情報を提供するために使用されます。このメソッドを使用することで、そういった補足情報の存在を確認できます。

2. **視認性の問題**: `title` 属性の内容は通常、マウスオーバー時にのみ表示されるため、常に視認可能というわけではありません。

3. **使用の優先順位**: 可能な限り、`getByRole()`、`getByText()` など、より直接的で視認性の高い方法を優先し、`getByTitle()` は補完的に使用することが推奨されます。

:::message
`getByTitle()` は `title` 属性に依存するため、ユーザーインターフェースの変更に弱い可能性があります。
また、`title` 属性の内容はユーザーに常に見えるわけではないため、テストが実際のユーザー体験を正確に反映しない場合があります。
:::

### getByTestId()

`getByTestId()` は、HTML 要素の `data-testid` 属性を使用して要素を特定し、取得します。
`data-` から始まるカスタムデータ属性は、HTML をコーディングする人が任意で付与しても良い属性として、WHATWG でルール化されています。
`data-testid` はテスト用に要素を一意に特定するための属性として、さまざまなテストツールで採用している慣例的な属性名です。

以下は、`page` オブジェクトに対して `data-testid` 属性が `admin-menu` もしくは `cache-clear` である要素が画面上に表示されていることを確認するサンプルとテストです。

```html
<div>
  <ul>
    <li><button data-testid="admin-menu">管理者メニュー</button></li>
    <li><button data-testid="cache-clear">キャッシュクリア</button></li>
  </ul>
</div>
```

```javascript
test("data-testid属性で要素取得", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByTestId("admin-menu")).toBeVisible();
  await expect(page.getByTestId("cache-clear")).toBeVisible();
});
```

`getByTestId()` の特徴と注意点。

1. **テスト専用の属性**
   `data-testid` はユーザーインターフェースには影響を与えず、純粋にテスト目的で使用されます。

2. **ホワイトボックステスト**
   この方法は、アプリケーションの内部構造に依存するため、ホワイトボックステストの性質を持ちます。

3. **使用の優先順位**
   Playwright や Testing Library では、この属性は他の方法がない場合の最終手段としています。

4. **フレームワークによる違い**
   Playwright のライバルとして語られることが多い Cypress では、この属性を使ったタグ検索を推奨しています。

5. **カスタマイズ可能**
   Playwright で用いるテスト用のカスタムデータ属性はデフォルトで `data-testid` となっていますが、設定ファイルで別のカスタムデータ属性に変更できます。

   ```typescript
   // playwright.config.ts
   import { defineConfig } from "@playwright/test";

   export default defineConfig({
     use: {
       testIdAttribute: "data-new-test-id",
     },
   });
   ```

:::message
`data-testid` と似た要素として、`id` や `class` もありますが、これらはテスト用というわけではなく、別の役割も持っているため、テスト以外の動機によって変更されてしまうことがあります。
`data-testid` の立ち位置としては、「なるべく使うべきではないが `id` や `class` よりはまし」と覚えておきましょう。
:::

:::message
**data-testid はいつ使うべきか？**

唯一、`data-testid` を気兼ねなく使っても問題がないと思われるケースは、ユニットテストやコンポーネントのテストであること、かつ、これが外部に公開された Web API である場合です。

下記ように、省略可能な `data-testid` 属性をコンポーネントに付与し、もし指定されたらコンポーネントのルートの要素にこの属性をフォワードして付与します。

```jsx
function Component(props: {['data-testid']?: string}) {
  return <div data-testid={props['data-testid']}>My Component</div>
}
```

このような実装であっても、E2E テストではなるべく使わないほうが良いでしょう。
あくまで目に見える要素を使ってテストを書くべきです。
:::

`getByTestId()` は、他の方法では特定が難しい要素のテストに有用ですが、過度に依存すると保守性の低いテストになる可能性があります。
可能な限り、セマンティックな要素や視覚的に確認可能な属性を使用したテストを優先し、`getByTestId()` は補完的に使用することが推奨されます。

### その他のロケーター

これまで紹介してきたものの他にも、CSS セレクターや XPath を使ったロケーターがあります。
これらのロケーターは詳細な要素の指定が可能ですが、HTML の構造に強く依存するため、使用には注意が必要です。

以下に例を示します。

```javascript
await page.locator("button").click(); // タグで指定
await page.locator("#reset-button").click(); // idで指定
await page.locator(".primary-button").click(); // CSSで指定
await page.locator("//button").click(); // XPathで指定
```

これらのロケーターの特徴と注意点は下記の通りです。

1. **柔軟性**
   CSS セレクターや XPath は非常に柔軟で、ほぼすべての要素を指定できます。

2. **脆弱性**
   HTML の構造変更に弱く、リファクタリングなどで容易に破綻する可能性があります。

3. **可読性**
   特に XPath は複雑になりやすく、可読性が低下する傾向があります。

4. **ブラックボックステスト**
   これらのセレクターは、前述の `data-testid` を使ったセレクターと同様に、アプリケーションの内部構造に依存したホワイトボックステストになってしまいます。

:::message
これらのセレクターは、他の方法では特定できない要素に対してのみ、慎重に使用することが推奨されます。
可能な限り、セマンティックで安定したロケーター（例：`getByRole()`、`getByText()`）を優先的に使用してください。
:::

はい、ご指摘の通りです。ロケーターの視点から「壊れにくいテスト」について解説を行うことが適切です。以下のように内容を整理し直しました：

承知しました。添付画像の内容を基に、「高度なロケーター」という節を以下のように執筆いたします。

### 高度なロケーター

1 ページに必ず同名のボタンが 1 つだけあるのであれば、前述のロケーターで十分対応できます。
しかし、一覧参照画面などがあると、同じ構造の行がたくさんあり、まずはその行を選んでからボタンを選択するといった 2 段階のステップで要素を選択する必要があります。

Playwright のロケーターはそのような高度な使い方にも対応しています。

1. **フィルター**
   テーブルの行を選択するのに便利なのがフィルターです。
   リストの要素は残念ながら 1 つのロケーターでの特定はできません。
   次のような HTML があるとします。

   ```html
   <ul>
     <li id="1">赤色紙</li>
     <li id="2">青色紙</li>
     <li id="3">黄色紙</li>
   </ul>
   ```

   リスト表示される名前はリストの要素の子要素であって、リスト要素そのものではありません。
   たとえば、id="2"の`<li>`タグを選択したいとします。
   その場合は次のように、基本のロケーター候補をまとめて取得したあとに、`filter()` メソッドを使って絞り込みを行います。

   ```javascript
   await page
     .getByRole("listitem") // 全部の <li> を取得
     .filter({ hasText: /青/ }); // そのうち青という文字を子要素に含むものを選別
   ```

   このサンプルに関していえば、`getByText()` を使えば一度で取得できるにはできますが、同じテキストを使った要素が多数ある場合に困る可能性があるため、ロール情報も組み合わせてより明示的に指定するという想定をしています。

   `filter()` の引数では以下のような条件が設定できます。

   - `{hasText: テキスト}`: 特定のテキストを含む（テキストは文字列か正規表現）
   - `{hasNotText: テキスト}`: 特定のテキストを含まない（テキストは文字列か正規表現）
   - `{has: ロケーター}`: 子要素を含む
   - `{hasNot: ロケーター}`: 子要素を含まない

   条件が複数ある場合には `filter()` メソッドをさらにチェーンして絞り込みます。

2. **一度絞り込んだ要素の中からさらに検索**
   ロケーターは多重に組み合わせることでさらに子要素を取ってくることもできます。
   前述のフィルターは最初に取得した要素に対して取捨選択するためのしくみであり、フィルターの結果は最初のロケーターの結果のリストに含まれる要素です。
   その結果に対してさらにロケーターを組み合わせると、ロケーターの選択した要素の子要素を取得できます。

   たとえば、次のようなネストされたリストについて考えてみます。
   和食にも中華にも両方「麺」があります。
   今日は刀削麺の気分で、後者の「麺」を選択したいと考えているものとします。

   ```html
   <ul>
     <li>
       和食
       <ul>
         <li><a href="/sushi">寿司</a></li>
         <li><a href="/japanese-noodle">麺</a></li>
       </ul>
     </li>
     <li>
       中華
       <ul>
         <li><a href="/fried-rice">炒飯</a></li>
         <li><a href="/chinese-noodle">麺</a></li>
       </ul>
     </li>
   </ul>
   ```

   その場合は、最初に `getByRole()` と `filter()` で選択し、残った要素に対して再び同じメソッドのペアを重ね掛けすることで、後者の麺と書かれたリストのみを取得できます。

   ```javascript
   await page
     .getByRole("listitem")
     .filter({ hasText: /中華/ })
     .getByRole("listitem")
     .filter({ hasText: /麺/ });
   ```

3. **複数の要素の絞り込み**
   `getByRole()` などのロケーターは選択された要素のリストを返します。
   このリストは JavaScript の配列ではなく、Playwright 固有のオブジェクトです。
   前述のように `filter()` メソッドで絞り込んだり、追加のロケーターで子要素を選択したりとさまざまな機能を持っています。

   また、配列に似たような意味を持つオブジェクトであるため、配列のような操作も可能です。
   たとえば `count()` で数のカウントもできますし、結果に対して「最初の要素」といった絞り込みも行えます。

   たとえば、次のように複数の段落があったとします。

   ```html
   <p>最初の段落</p>
   <p>2つめの段落</p>
   <p>3つめの段落</p>
   <p>最後の段落</p>
   ```

   ```javascript
   await expect(page.getByRole("paragraph").first()).toHaveText(/最初/);
   await expect(page.getByRole("paragraph").nth(2)).toHaveText(/3つ/);
   await expect(page.getByRole("paragraph").last()).toHaveText(/最後/);
   ```

   リストの編集機能などがある場合に、「最後の要素が新しく追加した情報を持つ要素かどうか」といったテストを書きたい場合に活躍するでしょう。

4. **`or()`, `and()` メソッド**
   探索結果は配列のような要素となると紹介しましたが、この結果の要素に対する和集合や積集合を取る `or()` メソッドや `and()` メソッドも用意されています。

   `or()` と `and()` どちらも引数にロケーターをとります。
   次のコードはテキストボックスもしくは、ボタンの総数を取得します。

   ```javascript
   await expect(
     page.getByRole("textbox").or(page.getByRole("button"))
   ).toHaveCount(4);
   ```

   `and()` は 2 つのロケーターの両方に含まれる要素を返します。

### 壊れにくいテストとロケーターの選択

ロケーターの選択は、テストの堅牢性に大きく影響します。
E2E テストにおいて、アプリケーションの小さな変更でテストが失敗しないようにするには、以下の点に注意してロケーターを選択する必要があります。

1. **セマンティック HTML の活用**

   - HTML のタグや CSS は開発者視点では内部構造ですが、ユーザー視点では出力の一部です
   - セマンティック HTML の情報を使ったテストは、2024 年現在、E2E テストや JavaScript のユニットテストで一般的です
   - Playwright は標準機能としてセマンティック HTML を使用した Web ページのスキャン方法を提供しています

2. **ロケーターの選択ガイド**:

   - `getByRole()`: アクセシビリティと機能の両面を捉えられるため、多くの場合で最適な選択です。例：「送信ボタン」の取得。

   - `getByLabel()`: フォーム要素に対して特に有用です。関連するラベルのテキストで要素を取得でき、アクセシビリティの観点からも推奨されます。

   - `getByText()`: ユーザーに見えるテキストで要素を特定します。ボタンのラベルやリンクのテキストなど、視覚的なテキストに基づく要素の特定に適しています。

   - `getByPlaceholder()`: 入力欄の初期テキストで要素を特定します。ただし、入力があると消えるため、他の方法と組み合わせて使用するのが好ましいです。

   - `getByAltText()`: 主に画像要素に対して使用します。代替テキストで要素を特定するため、アクセシビリティを考慮したテストに有用です。

   - `getByTitle()`: ツールチップなど、補足情報がある要素の特定に使用します。ただし、常に視認可能ではないことに注意が必要です。

   - `getByTestId()`: 他の方法で特定できない場合の最終手段です。テスト用の属性を要素に追加して使用しますが、過度の使用は避けるべきです。

3. **E2E テストの特性を考慮**:

   - E2E テストはユーザーマニュアルに近い抽象度を持つべきです
   - ボタン、メニュー、ラジオボタンなどのロール情報は、ユーザーにとって重要な情報であるため明示的に指定しても良いでしょう

4. **プレースホルダーの注意点**:

   - プレースホルダーは入力があると消えるため、テストの唯一の手がかりとして使用するのは避けるべきです
   - プレースホルダーに依存したテストは、ユーザビリティの問題を示唆している可能性があります

5. **適切なラベルの使用**:

   - `<label>`タグの使用が推奨されます
   - 明示的なラベル（`for`属性使用）と暗示的なラベル（入力要素を内包）の 2 種類があります
   - アクセシビリティの観点から、明示的なラベルが望ましいです

6. **aria 属性の活用**:

   - `<label>`タグが使えない場合、aria 属性を使用してラベルを指定できます
   - ただし、可能な限り`<label>`タグの使用を優先すべきです

7. **具体的な実装への依存を避ける**:
   - 特定の CSS クラス名に依存したテストは壊れやすいです
   - このようなテストはコンポーネントの単体テストとしては適切かもしれませんが、E2E テストでは避けるべきです

:::message
これらの点に注意してロケーターを選択することで、リファクタリングに強い堅牢なテストを作成できます。
セマンティック HTML とアクセシビリティを意識したアプローチは、**テストの信頼性を高めるだけでなく、アプリケーション全体の品質向上にも寄与します。**
:::

## ナビゲーション

次に、ナビゲーションについて詳しく説明します。

ナビゲーションは URL に関連する「アクション」をまとめた機能群です。

### goto()

`goto()` メソッドは、Playwright で最も頻繁に使用されるナビゲーション機能の一つです。このメソッドは、ユーザーがブラウザで特定のページを開く動作をシミュレートします。

1. **基本的な使い方**

   ```javascript
   await page.goto("http://example.com");
   ```

   この操作は、指定された URL のページを開きます。
   `await` キーワードを使用することで、ページの遷移が完了し、CSS や JavaScript、画像などのリソースが読み込まれるまで待機します。
   これにより、ページが完全に読み込まれた後でテストや操作を開始できます。

2. **相対パスの使用**

   Playwright の設定ファイル（`playwright.config.ts`）で `baseURL` を設定している場合、`goto()` メソッドで相対パスを使用できます。これは、テストコードをより簡潔に保ち、柔軟性を高めるのに役立ちます。

   例えば、以下のように設定ファイルで `baseURL` を指定した場合：

   ```typescript
   // playwright.config.ts
   import { defineConfig, devices } from "@playwright/test";

   export default defineConfig({
     use: {
       baseURL: "http://localhost:3000",
     },
   });
   ```

   テストコード内では、次のように相対パスを使用できます。

   ```javascript
   await page.goto("/login"); // http://localhost:3000/login にアクセスします
   ```

   この方法を使用すると、テスト環境や本番環境など、異なる環境間での URL の切り替えが容易になります。
   また、テストコードがより読みやすく、メンテナンスしやすくなります。

### waitForURL()

`waitForURL()` は、ページ遷移が完了するまで待機する機能を提供します。

1. **使用場面**

   このメソッドは以下のような状況で特に有用です。

   1. リンクのクリック後の遷移
   2. ページ遷移を伴うボタンのクリック
   3. フォーム送信後のリダイレクト

   これらのアクションを実行した後、新しいページへの遷移が完了するまで待機します。

2. **ページ遷移の裏で起こっている処理**

   1. サーバーへのリクエスト送信
   2. 新しいコンテンツのロード
   3. 必要に応じてリダイレクトの処理

   この過程は人間の目には瞬時に見えますが、テストコードではサーバーアクセスを待つ必要があるため、待機時間が発生します。

3. **使用例**

   ```javascript
   await page.waitForURL("*/login");
   ```

   この例では、URL が `/login` で終わるページへの遷移が完了するまで待機します。

:::message

結果確認のロケーターが遷移前のページにアクセスして間違った検証を行ってしまう可能性があります。`waitForURL()` を使用することで、この問題を回避できます。

しかし、通常のウェブサイト操作では、「URL が変わった」ことを毎回目視で確認してからページ操作をすることはありません。ブラウザに表示されているコンテンツの変化を確認してページが変わったことを知るはずです。

そのため、`waitForURL()` の使用は必須ではありません。テストの後続の操作に支障がなければ、このナビゲーション待機を使用する必要はない場合もあります。

:::

`waitForURL()` は、特定の URL への遷移を確実に待つ必要がある場合に有用なメソッドです。
しかし、多くの場合、ページ上の要素の変化を待つ他のメソッド（例：`waitForSelector()`）で代用可能です。
テストのシナリオや対象のウェブアプリケーションの挙動に応じて、適切な待機方法を選択することが重要です。

### toHaveTitle() と toHaveURL() - ナビゲーションに特化したマッチャー

画面の中のコンテンツに対するマッチャーについては後ほど詳しく紹介しますが、本節ではナビゲーションに特化したマッチャーを 2 つ紹介します。

1. `toHaveTitle()`: ページのタイトルを確認します。
2. `toHaveURL()`: URL を確認します。

両方のマッチャーは文字列と正規表現を使用できます。以下のサンプルコードでは正規表現を使用しています。

```javascript
// タイトルを確認
await expect(page).toHaveTitle(/商品詳細/);

// URLを確認
await expect(page).toHaveURL(/.*checkout/);
```

これらのマッチャーには重要な特徴があります。

1. **デフォルトで 5 秒間リトライを続ける**
   ナビゲーションはテストコードから見ると無視できない待ちが発生すると前述しましたが、これらのマッチャーは期待した状態になるまでデフォルトで 5 秒間リトライし続けます。

2. **明示的な待機が不要**
   このリトライ機能により、`waitForURL()` のような明示的な待ちの指示は必要ありません。

3. **テスト固有の確認**：
   これらのマッチャーは、人間がブラウザを操作する場合にほとんど意識することのない項目をチェックします。
   そのため、他の項目で代用できる場合は、これらを利用するほうが自然なテストになるでしょう。

## アクション

ロケーターは要素の選択を行いますが、多くの E2E テストではユーザーの操作をシミュレートする必要があります。
そこで登場するのがアクションです。

アクションは、ロケーターが選択した要素に対して行われ、キーボード操作やマウス操作などのユーザーの行動を再現します。
各要素の特性に応じて、実行可能なアクションは異なります。

Playwright は実際の Web 操作に近づけるよう、アクションの可能性を慎重に考慮します。
例えば、小さすぎる要素や`display: none`が設定された要素、`disabled`状態の要素に対するアクションは実行されません。
また、テキスト入力を受け付ける要素では`editable`属性が必要です。

ロケーターが複数の要素にマッチする場合でも、アクション実行時には単一の要素を特定する必要があります。
これにより、意図しない操作を防ぎ、テストの信頼性を高めます。

このようなアクションの特性を理解し活用することで、より現実的で堅牢な E2E テストを構築することができます。

### キーボード操作：fill()/clear()/press()/pressSequentially()

テキストボックスに対するキーボード操作には、主に以下のメソッドが使用されます。

1. **fill()**: テキスト入力に使用します。
2. **clear()**: フォームを空にします。
3. **press()**: 個別のキーを指定します。
4. **pressSequentially()**: 文字列を 1 文字ずつ入力します。

#### fill() と clear()

```javascript
await page.getByRole("textbox", { name: /username/i }).fill("Peter Parker");
await page.getByPlaceholder(/password/).fill("I am Spiderman");
await page.getByRole("textbox", { name: /organization/i }).clear();
```

- fill()は一度クリアしてから、指定されたテキストを入力します
- 同じ要素に対して fill()を複数回呼ぶと、最後に呼び出した結果が残ります

#### press() と pressSequentially()

これらのメソッドは、より低レベルのテキスト操作や特殊キーの入力に使用します。

```javascript
// Enterキー
await page.getByRole("textbox").press("Enter");

// Control + Aキー
await page.getByRole("textbox").press("Control+KeyA");

// 文字列を1文字ずつ入力
await page.getByRole("textbox").pressSequentially("hello");
```

- press()はショートカットキーのエミュレーションにも使えます
- pressSequentially()は連続入力であるため、fill()に近い呼び出しになります

これらのメソッドを適切に組み合わせることで、様々なキーボード操作をシミュレートできます。
テキスト入力や特殊キーの操作、フォームのクリアなど、実際のユーザー操作に近い形でテストを行うことが可能です。

### チェックボックス・ラジオボタンの操作 : check()/uncheck()

チェックボックスやラジオボタンの場合は `check()` メソッドで選択、`uncheck()` で解除できます。

```ts
await page.getByRole("checkbox", { name: /読みました/ }).check();

await page.getByRole("checkbox", { name: /読みました/ }).uncheck();
```

### セレクトボックスの選択：selectOption()

`<select>` 要素に対する操作には、`selectOption()` メソッドを使用します。このメソッドは、単一選択（combobox ロール）と複数選択（listbox ロール）の両方のセレクトボックスに対応しています。

1. **単一選択（combobox ロール）の場合**
   1 つしか項目を選択できない `<select>` 要素に対しては、以下のように使用します：

   ```javascript
   await page
     .getByRole("combobox", { name: /ペット/ })
     .selectOption("ハムスター");
   ```

   選択肢は値でもラベルでも指定できます。

2. **複数選択（listbox ロール）の場合**
   `multiple` 属性がついた `<select>` 要素に対しても同じメソッドを使いますが、配列で指定することで複数項目の選択が行えます：

   ```javascript
   await page
     .getByRole("listbox", { name: /飲み物/ })
     .selectOption(["コーヒー", "ルートビア"]);
   ```

3. **注意点**
   1 つしか選べない `<select>` に対して配列を与えてもエラーにはなりませんが、先頭の要素以外は無視されるので注意してください。

   このメソッドを使用することで、ドロップダウンリストや複数選択リストなどのフォーム要素を簡単に操作でき、ユーザーの選択操作を効果的にシミュレートすることができます。

### マウス操作：click()/dblclick()/hover()/dragTo()

Playwright は様々なマウス操作のアクションを提供しています。

1. **`click()`** メソッド（シングルクリック）
2. **`dblclick()`** メソッド（ダブルクリック）
3. **`hover()`** メソッド（マウスホバー）
4. **`dragTo(ロケーター)`** メソッド（ドラッグ＆ドロップ）

クリックやダブルクリックには以下のようなオプションがあります：

- `{force: true}`: タグの可視性チェックをスキップして強制的にイベント発動
- `{button: "right"}` や `{button: "middle"}`: 右クリックや中ボタンクリックイベントを発行（デフォルトは `{button: "left"}`）
- `{modifiers: ["Control"]}`: 装飾キーを押しながらクリックするイベントを発行。装飾キーには "Shift"、"Alt"、"Meta"（macOS だと ⌘ キー）が設定可能。配列に複数文字列を設定することで同時押しも設定可能

より細かい操作を行う `mouse.hover()`、`mouse.move()`、`mouse.up()`、`mouse.down()` メソッドもあります。
これらを使うとマウスの座標を指定して操作できます。これらプリミティブな要素でも、ドラッグ＆ドロップを再現できます。

例：x:100, y:100 の地点から x:300, y:100 の地点までドラッグ＆ドロップ

```javascript
await page.mouse.move(100, 100);
await page.mouse.down();
await page.mouse.move(300, 100);
await page.mouse.up();
```

:::message

- キャンバスを使って実装されたゲームの操作のシミュレートには活用できるかもしれませんが、通常これらのメソッドは不要です
- 座標を指定してテストを記述すると、テストがより壊れやすくなり修正も難しくなります
- クリック可能エリアを何らかの方法で識別可能にするなど、そもそもアプリをテストしやすい構造にすることを検討したほうが良いでしょう
- 細かいジェスチャーでの操作を提供する場合も、単純なクリックで同じ操作ができるようにしておくことなどを検討しましょう
- スマートフォンでの閲覧時には、マウスオーバーやドラッグ＆ドロップを前提として構築された画面は非常に利用しづらい画面になる点も注意が必要です

:::

### フォーカス：focus()

フォーカス移動は `focus()` メソッドで行います。このメソッドは単純な文字数のチェックなどではなく、より複雑な状況で使用されます。

主な使用場面：

1. データベースへのアクセスが必要な重い入力情報のバリデーションが必要な場合
2. blur イベントでフォーカスが外れたときに特定の処理を行う必要がある場合

`focus()` メソッドを使用することで、これらのシナリオをテストすることができます。例えば、入力フォームに一度フォーカスして、その後他の要素にフォーカスすることで、blur イベントを発生させることができます。

使用例：

```javascript
await page.getByRole("textbox", { name: /名前/ }).focus();
```

このコードは、`名前` というラベルが付いたテキストボックスにフォーカスを当てます。

`focus()` メソッドを使用することで、以下のようなテストシナリオを作成できます。

1. フォームフィールドのバリデーション：フィールドにフォーカスを当て、その後フォーカスを外すことで、バリデーションロジックをトリガーできます。

2. 自動補完機能のテスト：フィールドにフォーカスを当てることで、自動補完の候補が表示されるかどうかを確認できます。

3. キーボードナビゲーションのテスト：要素間のフォーカス移動をシミュレートして、キーボードでのナビゲーションが正しく機能するかを確認できます。

4. 動的な UI の変更のテスト：特定の要素にフォーカスが当たったときに UI が変化する場合、そのような動作をテストできます。

### ファイルのアップロード：setInputFiles()

`<input type="file">` 要素に対してファイルを指定する際は、`setInputFiles()` メソッドを利用します。このメソッドは非常に柔軟で、以下の特徴があります：

1. 単一のファイルだけでなく、複数のファイルも設定できます。
2. 引数は配列も受け取れるので、複数ファイルを一度に設定可能です。
3. 空配列を渡すことで、選択をリセットすることもできます。

#### 使用例

1. 既存のファイルを選択する場合：

```javascript
await page
  .getByLabel("Upload file")
  .setInputFiles(path.join(__dirname, "myfile.pdf"));
```

2. メモリ上でファイルを作成してアップロードする場合：

```javascript
await page.getByLabel("Upload file").setInputFiles({
  name: "file.txt",
  mimeType: "text/plain",
  buffer: Buffer.from("this is test"),
});
```

:::message

`__dirname` は ES6 Modules 形式の JavaScript コードだと利用できません。
もし、`ReferenceError: \_\_dirname is not defined` というエラーが出る場合は、ファイルの先頭に以下の 4 行を追加してください：

```javascript
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
```

これらのコードを追加することで、ES6 Modules 環境でも `__dirname` を使用できるようになります。

:::

## マッチャー

マッチャーは、操作を行った後に、画面が期待した結果に変化したかを観察するためのツールです。

Playwright では、以下のようなマッチャーが提供されています：

- `await expect(locator).toContainText()`
- `await expect(locator).toHaveText()`
- `await expect(locator).toBeVisible()`
- `await expect(locator).toBeAttached()`
- `await expect(locator).not`
- `await expect(locator).toBeChecked()`
- `await expect(locator).toBeDisabled()`
- `await expect(locator).toBeEnabled()`
- `await expect(locator).toBeEmpty()`
- `await expect(locator).toBeHidden()`
- `await expect(locator).toBeFocused()`
- `await expect(locator).toHaveCount()`
- `await expect(locator).toHaveValue()`
- `await expect(locator).toHaveValues()`

マッチャーは検査したいロケーターを、生成関数の `expect()` に渡して取得します。
マッチャーのメソッドは、この `expect()` が返すオブジェクトのメソッドです。

ロケーターの結果の取得には `await` を付けていましたが、マッチャーを利用する場合は、引数のロケーターには await を付けずに、マッチャーの実行結果に 1 つだけ `await` を付与すれば正しく動くようになっています。
もちろん、ロケーターのほうに `await` を重複して付与しても問題はありません。

承知しました。より分かりやすく説明し直します。

### テキストと要素の存在を確認するマッチャー

Playwright では、ページ上のテキストや要素の存在を確認するために、主に 4 つのマッチャーを使用します：

1. **`toContainText()`**: テキストが含まれているか確認
2. **`toHaveText()`**: 完全に一致するテキストがあるか確認
3. **`toBeVisible()`**: 要素が表示されているか確認
4. **`toBeAttached()`**: 要素が DOM に存在するか確認

#### 使い方の例

例えば、ページに "Success" という見出しがある場合：

```html
<h1>Success</h1>
```

これを確認するには：

```javascript
// テキストが含まれているか
await expect(page.getByRole("heading")).toContainText("Success");

// テキストが完全一致するか
await expect(page.getByRole("heading")).toHaveText("Success");

// 見出しが表示されているか
await expect(page.getByRole("heading", { name: "Success" })).toBeVisible();

// 見出し要素が存在するか
await expect(page.getByRole("heading")).toBeAttached();
```

#### 違いと注意点

1. **toContainText() vs toHaveText()**:

   - toContainText(): 部分一致で OK
   - toHaveText(): 完全一致が必要

2. **空のテキスト**:

   - toContainText(), toHaveText(): 空のテキストではマッチしない
   - toBeVisible(): テキストがないと「見えない」と判断
   - toBeAttached(): テキストの有無に関係なく、要素の存在だけで判断

3. **複数要素**:
   複数の要素をまとめてチェックできます。例：

   ```javascript
   await expect(page.getByRole("listitem")).toHaveText([
     "りんご",
     "バナナ",
     "オレンジ",
   ]);
   ```

#### まとめ

- テキストの内容を確認: `toContainText() または toHaveText()
- 要素が見えるか確認: toBeVisible()
- 要素の存在だけ確認: toBeAttached()

はい、`not`についての解説をします。

### not

`not`は、マッチャーの結果を反転させるために使用される重要な機能です。

`expect`とマッチャーの間に`not`を挿入することで、テストの意味が否定になります。

```javascript
// Success と書かれた見出しが存在しないことを確認
await expect(page.getByRole("heading")).not.toContainText(/Success/);
```

上記例では、ページ内に `Success` というテキストを含む見出しが存在しないことを確認しています。

:::message

マッチャーの中には、肯定と否定の両方の意味を持つペアが存在します：

- `toBeEnabled()` と `toBeDisabled()`
- `toBeVisible()` と `toBeHidden()`

これらのペアが存在する場合は、それらを直接使用するのが良いでしょう。
しかし、そのようなペアが存在しないマッチャーに対しては、`not`を使用して否定の意味を表現します。

:::

### toBeChecked()

チェックボックスにチェックが入っていることを確認します。

```ts
// チェックを入れるアクション
await page.getByRole("checkbox", { name: /18歳以上です/ }).check();

// 確認
await expect(
  page.getByRole("checkbox", { name: /18歳以上です/ })
).toBeChecked();
```

はい、「toBeDisabled() と toBeEnabled()」について説明します。

### toBeDisabled() と toBeEnabled()

これらのマッチャーは、ロケーターが指定する要素が利用できるかできないかを確認するために使用します。
主に `<button>` や `<input>` などのフォーム要素で使われ、`disable` 属性を使って非活性化ができる要素に対して適用されます。

例えば、以下のような HTML があるとします：

```html
<button disabled>送信</button> <button>リセット</button>
```

これらの要素に対して、以下のようにテストを書くことができます：

```javascript
await expect(page.getByRole("button", { name: /送信/ })).toBeDisabled();
await expect(page.getByRole("button", { name: /リセット/ })).toBeEnabled();
```

はい、toBeEmpty()と toBeHidden()について説明します。

### toBeEmpty() と toBeHidden()

これらのマッチャーは、要素が空または非表示の場合にマッチします。

例えば、以下のような空の要素があるとします：

```html
<li></li>
```

この要素に対して、次のどちらのコードもマッチします：

```javascript
await expect(page.getByRole("listitem")).toBeEmpty();
await expect(page.getByRole("listitem")).toBeHidden();
```

#### 主な違い

1. **存在しない要素の扱い**:

   - `toBeHidden()`: `<li>` タグが存在しない場合でも正しいとみなします。
   - `toBeEmpty()`: タグが存在しない場合はエラーになります。
     (.not.toBeEmpty()もエラーになります)

2. **非表示要素の扱い**:
   `toBeHidden()` は以下の場合も「見えない」と判断します（エラーにならない）：
   - 中のテキストが空で大きさがゼロの要素
   - `display: none` の要素
   - `visibility: hidden` の要素

つまり、`toBeHidden()` はより柔軟にマッチします。

各状況での挙動は以下のようになります。

| マッチャー        | テキストが空 | タグが存在しない | テキストは空ではないが display: none | テキストは空ではないが visibility: hidden |
| ----------------- | ------------ | ---------------- | ------------------------------------ | ----------------------------------------- |
| .toBeEmpty()      | OK           | エラー           | エラー                               | エラー                                    |
| .toBeHidden()     | OK           | OK               | OK                                   | OK                                        |
| .not.toBeEmpty()  | エラー       | エラー           | OK                                   | OK                                        |
| .not.toBeHidden() | エラー       | エラー           | エラー                               | エラー                                    |

### toBeFocused()

タグにフォーカスが当たっていることを確認します。

```ts
// フォーカスを当てるアクション
await page.getByRole("button").focus();

// 確認
await expect(page.getByRole("button")).toBeFocused();
```

### toHaveCount()

ロケーターが指すノードの数が、引数に指定された個数分存在することを確認します。

```ts
await expect(page.getByRole("listitem")).toHaveCount(7);
```

はい、`toHaveValue()`と`toHaveValues()`について分かりやすく簡潔に説明します。

### toHaveValue() と toHaveValues()

1. **`toHaveValue()`**

   - 用途：`<input>`や`<textarea>`などの単一の値を持つフォーム要素の値を確認します。
   - 使用例：
     ```javascript
     // フォームに入力するアクション
     await page
       .getByRole("textbox", { name: /E-Mail/ })
       .fill("sample@example.com");
     // 確認
     await expect(page.getByRole("textbox", { name: /E-Mail/ })).toHaveValue(
       "sample@example.com"
     );
     ```

2. **`toHaveValues()`**

- 用途：複数選択可能な`<select multiple>`要素の選択結果を確認します。
- 使用例：
  ```javascript
  // 項目を複数選択するアクション
  await page
    .getByRole("listbox", { name: /飲み物/ })
    .selectOption(["紅茶", "抹茶"]);
  // 確認
  await expect(page.getByRole("listbox", { name: /飲み物/ })).toHaveValues([
    "紅茶",
    "抹茶",
  ]);
  ```

3. **主な違い**
   - `toHaveValue()`：単一の値を確認
   - `toHaveValues()`：複数の値（配列）を確認

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

実行順序は以下のようになります：

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

承知しました。以下に、添付画像の内容を踏まえた解説文と節のタイトルを作成しました。

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

:::

`skip()` や `only()` の使用は開発中の一時的な措置として有用ですが、コードをコミットする前には必ず削除または無効化してください。

これらの機能をコミットしたままにすると、CI/CD パイプラインで一部のテストが実行されなかったり、重要なテストがスキップされたりする可能性があります。

:::

はい、承知しました。添付画像の内容を踏まえて、以下のような解説文を作成しました。

### テストファイルの命名

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
