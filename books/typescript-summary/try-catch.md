---
title: "例外処理 ~ try/cahch"
---

## 例外を投げる・発生させる

- `throw` を使用する。
- プログラムのフローを中断し、例外を発生させる

### `throw` の使用方法

1. **プリミティブ値を投げる**:

   - 最も単純な例外は、プリミティブ値（例：文字列や数値）を直接投げること
   - これは情報量が少ないため、**一般的には推奨されない**

   ```javascript
   throw "An error occurred"; // 文字列を投げる
   throw 404; // 数値を投げる
   ```

2. **エラーオブジェクトを投げる**:

   - `Error` オブジェクト（またはそのサブクラス）を生成して投げることが一般的
   - これにより、エラーメッセージとスタックトレースが含まれるため、デバッグが容易になる

   ```javascript
   throw new Error("Something went wrong");
   throw new TypeError("Expected a number, but got a string");
   throw new RangeError("Value must be between 1 and 10");
   ```

3. **カスタムエラーを定義して投げる**:

   - 特定のエラータイプを識別するためにカスタムエラークラスを定義し、それを投げることもできる
   - これはアプリケーションで特有のエラー処理を行う場合に有用

   ```javascript
   class MyCustomError extends Error {
     constructor(message) {
       super(message);
       this.name = "MyCustomError";
     }
   }

   throw new MyCustomError("This is a custom error!");
   ```

## 例外を処理する

- `try/catch` を使用する
- 例外が発生し得る処理を `try` で囲う
- `catch` は例外が発生した際に呼ばれる部分
- `catch` の中に例外処理を記述する

```ts
try {
  const data = await getData();
  const modified = modify(data);
  await sendData(modified);
} catch (e) {
  console.log(`エラー発生 ${e}`);
} finally {
  // 最後に必ず呼ばれる
}
```

- `finally` は最後に必ず呼ばれる部分
- `try`、`catch` 内で `return` しても、`finally` は必ず実行される
- 関数内で `try/catch/finally` を使用した場合、最終的な戻り値は `finally` で `return` した値となる

## 例外の再送

- エラーハンドリングの一部として、キャッチされた例外を再度投げる（throw する）プロセス
- エラーを適切に処理した後、そのエラーを上位のコード（より高いレベルのエラーハンドラー）へ伝えるために使用される

なぜ、必要なのか？

1. **エラーログ記録後のエラー伝播**
   エラーをローカルでログに記録した後、さらにシステムの他の部分でそのエラーを処理したい場合。
2. **部分的なエラー処理**
   エラーを部分的に解決または特定した後、それを他のコンポーネントで完全に解決するために再送する。
3. **エラーの分類と再分配**
   捕捉したエラーを特定のタイプに分類し、特定のタイプのエラーハンドラーに送るために再送する。

実装例は以下の通り。

```ts
function processRequest(data) {
  try {
    // リスクのある処理を試みる
    handleData(data);
  } catch (error) {
    console.error("Error occurred:", error);
    // エラーをログに記録した後、さらに上位にエラーを投げる
    throw error; // 例外の再送
  }
}

try {
  processRequest(data);
} catch (error) {
  // 最終的なエラーハンドリング
  console.error("Failed to process request:", error);
}
```

## `Error` クラス

- 例外処理で「問題が発生した」ときの情報伝達に使う
- `new Error()` でインスタンス化したものを `throw` する

### プロパティ（フィールド）

1. **`name`**
   - **型** : `string`
   - **デフォルト値** : `"Error"`
   - **説明** :
     - エラーの名前
     - カスタムエラークラスを作成するときに上書きすることができる
2. **`message`**
   - **型** : `string`
   - **デフォルト値** : 空文字
   - **説明** :
     - エラーメッセージ
     - エラーが発生した原因や詳細を説明する
3. **`stack`**
   - **型** : `string | undefined`
   - **デフォルト値** : `undefined`
   - **説明** :
     - スタックトレース情報を格納する
     - エラーがスローされたときの呼び出しスタックを示す
     - ブラウザやランタイム環境によって形式が異なることがある

```ts
try {
  throw new Error("An example error message");
} catch (e) {
  console.error(e.name); // "Error"
  console.error(e.message); // "An example error message"
  console.error(e.stack); // スタックトレース
}
```

### コンストラクタ

エラーメッセージを引数に受け取る。

```ts
new Error(message?: string);
```

```ts
const error = new Error("This is an error message");

console.error(error.name); // "Error"
console.error(error.message); // "This is an error message"
console.error(error.stack); // スタックトレース
```

### カスタムエラー

- `Error` クラスを継承し、特定の状況や目的に対応するカスタムエラークラスを作成することができる
- エラーの種類を区別しやすくし、エラーハンドリングをより柔軟かつ詳細に行うことができる

```ts
class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "ValidationError";
  }
}

function validateInput(input: string) {
  if (input.length < 5) {
    throw new ValidationError("Input must be at least 5 characters long.");
  }
}

try {
  validateInput("abc");
} catch (e) {
  if (e instanceof ValidationError) {
    console.error("Validation Error:", e.message);
  } else {
    console.error("Unknown Error:", e);
  }
}
```

### 標準のカスタムエラークラス

はい、これらの標準の例外クラスは`Error`を継承したカスタムエラークラスです。それぞれ特定のエラー状況を表します。以下に、それぞれのエラークラスについて簡単に解説します。

1. **EvalError**
   - `eval()`関数に関するエラーを表す
   - JavaScript の最新の実装では、通常このエラーが発生することはないが、過去のバージョンでは特定の状況で発生することがあった
   ```ts
   try {
     throw new EvalError("Eval error occurred");
   } catch (e) {
     console.error(e.name); // "EvalError"
     console.error(e.message); // "Eval error occurred"
   }
   ```
2. **RangeError**

   - 数値が範囲外である場合に発生する
   - 配列の長さを負の数に設定しようとした場合や、無限ループを作成する可能性がある場合など

   ```ts
   try {
     let arr = new Array(-1);
   } catch (e) {
     console.error(e.name); // "RangeError"
     console.error(e.message); // "Invalid array length"
   }
   ```

3. **ReferenceError**
   - 存在しない変数を参照しようとした場合に発生する
   - 変数が定義されていない場合や、スコープ外で参照された場合など
   ```ts
   try {
     console.log(nonExistentVariable);
   } catch (e) {
     console.error(e.name); // "ReferenceError"
     console.error(e.message); // "nonExistentVariable is not defined"
   }
   ```
4. **SyntaxError**

   - JavaScript の構文が正しくない場合に発生する
   - 通常はコードのパース時に発生し、実行時には発生しない

   ```ts
   try {
     eval("foo bar");
   } catch (e) {
     console.error(e.name); // "SyntaxError"
     console.error(e.message); // "Unexpected identifier"
   }
   ```

5. **TypeError**

   - 変数やパラメータが期待される型ではない場合に発生する
   - 非関数を呼び出そうとした場合や、`null` または `undefined` のプロパティにアクセスしようとした場合など

   ```ts
   try {
     null.f();
   } catch (e) {
     console.error(e.name); // "TypeError"
     console.error(e.message); // "Cannot read properties of null (reading 'f')"
   }
   ```

6. **URIError**
   - `encodeURI()` や `decodeURI()` 関数に無効な URI 文字列が渡された場合に発生する
   ```ts
   try {
     decodeURIComponent("%");
   } catch (e) {
     console.error(e.name); // "URIError"
     console.error(e.message); // "URI malformed"
   }
   ```

## 発生した例外の仕分け

```ts
try {
  // 何かしらの処理
} catch (e) {
  // instanceofを使ってエラーの種類を判別していく
  if (e instanceof NoNetworkError) {
    // NoNetworkErrorの場合
  } else if (e instanceof NetworkAccessError) {
    // NetworkAccessErrorの場合
  } else {
    // その他の場合
  }
}
```

## ベストプラクティス

### `try` 節はなるべく狭くする

これだと、どの関数が例外を発生させているかが分かりにくい。

```ts
try {
  logicA();
  logicB();
  logicC();
  logicD();
  logicE();
} catch (e) {
  // エラー処理
}
```

`try` 節の中をなるべく簡潔にすることで、何に対する例外処理なのかを明確にする。

```ts
logicA();
logicB();
try {
  logicC();
} catch (e) {
  // エラー処理
}
logicD();
logicE();
```

### `Error` 以外を `throw` しない

`throw` は文字列や数値を投げることができる。
