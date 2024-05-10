---
title: "Stringオブジェクト"
---

- **定義と機能**: String オブジェクトは JavaScript で文字列を扱うためのオブジェクト型、プリミティブ型の文字列に対する操作やプロパティアクセスをサポート
- **作成方法**: `new String(value)` を使用して生成、`value` は任意の値で、通常は文字列
- **プロパティとメソッド**: `.length` で文字列の長さを取得、`.charAt(index)`、`.toUpperCase()`、`.toLowerCase()` など多数のメソッドを提供
- **自動ボクシング**: プリミティブ型の文字列にメソッドを適用する際、JavaScript ランタイムが自動的に String オブジェクトへ変換
- **使用例**:
  ```javascript
  let stringObj = new String("hello");
  console.log(stringObj.toUpperCase()); // "HELLO"
  ```
- **typeof 演算子の結果**: `typeof` 演算子を使用すると String オブジェクトは `"object"` として識別される
- **プリミティブ型との違い**: String オブジェクトはプロパティやメソッドを持つが、プリミティブ型の文字列は不変で直接的なプロパティやメソッドを持たない

## `trim` メソッド ~ 文字列の両端から空白を除去する

- **機能**: 文字列の両端から空白文字を削除
- **戻り値**: 空白を取り除いた新しい文字列を返す、元の文字列は変更されない
- **使用対象**: 空白文字には通常のスペース、タブ、改行などが含まれる
- **使用例**:
  ```javascript
  let greeting = "   Hello world!   ";
  console.log(greeting.trim()); // "Hello world!"
  ```
- **非破壊的操作**: `trim` は元の文字列を変更せずに新しい文字列を生成して返す
- **関連メソッド**: `trimStart()` または `trimLeft()` は文字列の先頭の空白のみを削除、`trimEnd()` または `trimRight()` は末尾の空白のみを削除

`trim` メソッドはフォーム入力やファイル読み込みなど、ユーザーからの入力やデータの整理に特に有用。

## `replace` メソッド ~ 文字列を置換する

### `replace` メソッドについてのまとめ

- **機能**: 文字列内の指定された部分を新しい文字列で置換
- **戻り値**: 置換後の新しい文字列を返す、元の文字列は変更されない
- **引数**: 2 つの引数を取る、第一引数には置換対象の文字列または正規表現、第二引数には新しい文字列または置換を動的に制御する関数が入る
- **使用例**:
  ```javascript
  let text = "Hello world";
  console.log(text.replace("world", "everyone")); // "Hello everyone"
  ```
- **正規表現の利用**: 第一引数に正規表現を使用し、より複雑なパターンの文字列置換を実行できる
  ```javascript
  let text = "I like apples and apples";
  console.log(text.replace(/apples/g, "oranges")); // "I like oranges and oranges"
  ```
- **関数を使った動的置換**: 置換プロセスをカスタマイズするために、第二引数に関数を使用することができる

  ```javascript
  let text = "I have 100 dollars";
  console.log(text.replace(/\d+/, (match) => parseInt(match) + 100)); // "I have 200 dollars"
  ```

- `replace` メソッドは、単純な文字列の置換から、正規表現を使用した複雑なパターンマッチングと置換まで、多様な文字列処理が可能
- これにより、テキストデータのフォーマット変更、特定語の置換、データのサニタイズなど、広範な用途で利用される
