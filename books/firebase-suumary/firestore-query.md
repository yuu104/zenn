---
title: "Firestoreにおけるクエリ操作ガイド"
---

## Firestore SDK の初期化

Firestore を使用する前に Firebase Admin SDK または Firebase Web SDK を初期化する。サービスアカウントキーが必要。

```javascript
const admin = require("firebase-admin");
const serviceAccount = require("path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
```

## 新規ドキュメントの追加

### 自動生成 ID でのドキュメント追加

`add()`メソッドを使用し、コレクションに新規ドキュメントを追加。ドキュメント ID は自動生成される。

```javascript
db.collection("users")
  .add({
    name: "Alice",
    age: 30,
    email: "alice@example.com",
  })
  .then((docRef) => {
    console.log("Document written with ID:", docRef.id);
  })
  .catch((error) => {
    console.error("Error adding document:", error);
  });
```

### ドキュメント ID 指定でのドキュメント作成

`doc()`メソッドでドキュメント参照を取得し、`set()`メソッドでデータを設定。ドキュメント ID は手動で指定するか、引数なしで自動生成。

```javascript
const newDocRef = db.collection("users").doc(); // 自動生成ID
newDocRef.set({
  name: "Bob",
  age: 25,
  email: "bob@example.com",
});
```

## ドキュメントの取得

`doc()`メソッドで特定のドキュメント参照を取得後、`get()`メソッドでドキュメントのデータを読み込む。

```javascript
db.collection("users")
  .doc("documentId")
  .get()
  .then((doc) => {
    if (doc.exists) {
      console.log(doc.data());
    } else {
      console.log("No document!");
    }
  });
```

## 注意点

- `doc()`メソッドは同期処理であり、Firestore へのリクエストは発生しない。データの読み書き操作（`set()`, `get()`, `update()`, `delete()`）が非同期処理として実行され、Firestore へのリクエストを発生させる。
- `doc()`の段階でドキュメント ID が自動生成され、クライアント側で保持される。データベースに実際のドキュメントが作成されるのは、その後の`set()`や`add()`などの操作を通じてのみ。

このガイドは、Firestore を使用した開発における基本的なドキュメント操作に関する簡潔な参照資料です。
