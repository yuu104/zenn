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

:::details

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

これらの点に注意してロケーターを選択することで、リファクタリングに強い堅牢なテストを作成できます。
セマンティック HTML とアクセシビリティを意識したアプローチは、テストの信頼性を高めるだけでなく、アプリケーション全体の品質向上にも寄与します。
