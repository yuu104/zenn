---
title: "【Playwright】ロケーター"
---

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

## getByRole

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

## getByLabel

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

## getByPlaceholder()

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

## getByText()

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

## getByAltText()

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

## getByTitle()

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

## getByTestId()

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

## その他のロケーター

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

4. **内部構造に依存**
   これらのセレクターは、前述の `data-testid` を使ったセレクターと同様に、アプリケーションの内部構造に依存したホワイトボックステストになってしまいます。

:::message
これらのセレクターは、他の方法では特定できない要素に対してのみ、慎重に使用することが推奨されます。
可能な限り、セマンティックで安定したロケーター（例：`getByRole()`、`getByText()`）を優先的に使用してください。
:::

はい、ご指摘の通りです。ロケーターの視点から「壊れにくいテスト」について解説を行うことが適切です。以下のように内容を整理し直しました：

承知しました。添付画像の内容を基に、「高度なロケーター」という節を以下のように執筆いたします。

## 高度なロケーター

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

## 壊れにくいテストとロケーターの選択

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