---
title: "【Playwright】アクション"
---

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

## キーボード操作：fill()/clear()/press()/pressSequentially()

テキストボックスに対するキーボード操作には、主に以下のメソッドが使用されます。

1. **fill()**: テキスト入力に使用します。
2. **clear()**: フォームを空にします。
3. **press()**: 個別のキーを指定します。
4. **pressSequentially()**: 文字列を 1 文字ずつ入力します。

### fill() と clear()

```javascript
await page.getByRole("textbox", { name: /username/i }).fill("Peter Parker");
await page.getByPlaceholder(/password/).fill("I am Spiderman");
await page.getByRole("textbox", { name: /organization/i }).clear();
```

- fill()は一度クリアしてから、指定されたテキストを入力します
- 同じ要素に対して fill()を複数回呼ぶと、最後に呼び出した結果が残ります

### press() と pressSequentially()

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

## チェックボックス・ラジオボタンの操作 : check()/uncheck()

チェックボックスやラジオボタンの場合は `check()` メソッドで選択、`uncheck()` で解除できます。

```ts
await page.getByRole("checkbox", { name: /読みました/ }).check();

await page.getByRole("checkbox", { name: /読みました/ }).uncheck();
```

## セレクトボックスの選択：selectOption()

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

## マウス操作：click()/dblclick()/hover()/dragTo()

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

## フォーカス：focus()

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

## ファイルのアップロード：setInputFiles()

`<input type="file">` 要素に対してファイルを指定する際は、`setInputFiles()` メソッドを利用します。このメソッドは非常に柔軟で、以下の特徴があります：

1. 単一のファイルだけでなく、複数のファイルも設定できます。
2. 引数は配列も受け取れるので、複数ファイルを一度に設定可能です。
3. 空配列を渡すことで、選択をリセットすることもできます。

### 使用例

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
