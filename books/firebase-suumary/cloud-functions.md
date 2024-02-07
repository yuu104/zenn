---
title: "Cloud Functions"
---

## 呼び出し可能関数（`functions.https.onCall`）

https://firebase.google.com/docs/functions/callable?hl=ja

`functions.https.onCall()` は、Firebase Cloud Functions の一部であり、クライアントからサーバーサイドのコードを呼び出すための方法を提供するメソッドです。このメソッドを使用すると、クライアントアプリケーション（通常は Web アプリケーションやモバイルアプリケーション）から、Firebase Cloud Functions で実行したい関数を呼び出すことができます。

`functions.https.onCall()` を使用すると、以下のような特徴があります：

1. **シンプルな呼び出し**: クライアントアプリケーションは、単純な HTTP リクエストを送信するように Firebase Cloud Functions を呼び出すことができます。呼び出しは非常に簡潔で、関数の呼び出しに必要なデータを渡すことができます。

2. **認証とセキュリティ**: `functions.https.onCall()` を使用すると、Firebase Authentication を介して認証されたユーザーのみが関数を呼び出すことができます。これにより、セキュリティが確保され、不正なアクセスを防ぐことができます。

3. **リアルタイム通信**: クライアントとサーバー間でリアルタイム通信を実現するために使用できます。たとえば、リアルタイムなチャットアプリケーションでのメッセージの送信や、リアルタイムなゲームアクションの処理に役立ちます。

`functions.https.onCall()` を使用するには、以下のようなステップが必要です：

1. Firebase プロジェクトに Cloud Functions をセットアップします。

2. Firebase CLI を使用して関数をデプロイし、関数を定義します。

3. クライアントアプリケーション内で Firebase SDK を使用して、`functions.https.onCall()` を呼び出します。

4. クライアントアプリケーションからの呼び出しをリッスンし、関数が実行されたときのレスポンスを処理します。

以下は、`functions.https.onCall()` を使用してクライアントからサーバーサイドの関数を呼び出す簡単な例です。

Cloud Functions での関数定義（Node.js での例）:

```javascript
const functions = require("firebase-functions");

exports.addNumbers = functions.https.onCall((data, context) => {
  const { number1, number2 } = data;
  const result = number1 + number2;
  return { result: result };
});
```

クライアントアプリケーション内での関数の呼び出し（JavaScript での例）:

```javascript
const addNumbers = firebase.functions().httpsCallable("addNumbers");
addNumbers({ number1: 5, number2: 3 })
  .then((result) => {
    console.log("結果:", result.data.result);
  })
  .catch((error) => {
    console.error("エラー:", error);
  });
```

この例では、クライアントアプリケーションがサーバーサイドの関数 `addNumbers` を呼び出し、2 つの数を足して結果を受け取ります。`functions.https.onCall()` を使用することで、クライアントとサーバー間でデータを受け渡すための強力な方法が提供され、Firebase プロジェクト内でカスタムロジックを実行するのに役立ちます。
