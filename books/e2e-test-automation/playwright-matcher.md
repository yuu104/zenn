---
title: "【Playwright】マッチャー"
---

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

## テキストと要素の存在を確認するマッチャー

Playwright では、ページ上のテキストや要素の存在を確認するために、主に 4 つのマッチャーを使用します：

1. **`toContainText()`**: テキストが含まれているか確認
2. **`toHaveText()`**: 完全に一致するテキストがあるか確認
3. **`toBeVisible()`**: 要素が表示されているか確認
4. **`toBeAttached()`**: 要素が DOM に存在するか確認

### 使い方の例

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

### 違いと注意点

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

### まとめ

- テキストの内容を確認: `toContainText() または toHaveText()
- 要素が見えるか確認: toBeVisible()
- 要素の存在だけ確認: toBeAttached()

はい、`not`についての解説をします。

## not

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

## toBeChecked()

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

## toBeDisabled() と toBeEnabled()

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

## toBeEmpty() と toBeHidden()

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

### 主な違い

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

## toBeFocused()

タグにフォーカスが当たっていることを確認します。

```ts
// フォーカスを当てるアクション
await page.getByRole("button").focus();

// 確認
await expect(page.getByRole("button")).toBeFocused();
```

## toHaveCount()

ロケーターが指すノードの数が、引数に指定された個数分存在することを確認します。

```ts
await expect(page.getByRole("listitem")).toHaveCount(7);
```

はい、`toHaveValue()`と`toHaveValues()`について分かりやすく簡潔に説明します。

## toHaveValue() と toHaveValues()

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
