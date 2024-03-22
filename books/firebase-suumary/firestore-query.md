---
title: "Firestoreにおけるクエリ操作ガイド"
---

## Firestore SDK の初期化

Firestore を使用する前に Firebase Admin SDK または Firebase Web SDK を初期化する。
サービスアカウントキーが必要。

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

- `add()` メソッドを使用し、コレクションに新規ドキュメントを追加
- ドキュメント ID は自動生成される

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

- `doc()`メソッドでドキュメント参照を取得し、`set()`メソッドでデータを設定
- ドキュメント ID は手動で指定するか、引数なしで自動生成

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

## `set` メソッドによるドキュメントの更新

- Firestore の`set`メソッドは、ドキュメントを新規作成または更新する際に使用される
- `{ merge: true }` オプションを付けずに `set` を使用すると、指定されたフィールドのみが残り、他のフィールドは削除される

### `set`メソッドの基本動作

- `set`メソッドは、指定したドキュメントの内容を新しい内容で完全に置き換える
- 第一引数に指定されたフィールドのみがドキュメントに残り、それ以外のフィールドは削除される

### `{merge: true}`オプションの使用

- `{ merge: true }` オプションを `set` メソッドの第二引数として指定すると、既存のドキュメント内容を保持しつつ、指定されたフィールドのみを更新または追加する
- 既存のフィールドはそのまま保持され、指定されていないフィールドは影響を受けない

### 使用例

#### `merge` オプションなしでの `set` 使用例

```javascript
docRef.set({
  email: "alice@example.com",
});
// 結果: ドキュメントは { email: 'alice@example.com' } のみを含む。他のフィールドは削除される。
```

#### `merge` オプションありでの `set` 使用例

```javascript
docRef.set(
  {
    email: "alice@example.com",
  },
  { merge: true }
);
// 結果: ドキュメントは既存のフィールドを保持し、emailフィールドのみ更新される。
```

### 注意点

- ドキュメント更新時に既存のデータを保持したい場合は、`{ merge: true }` オプションの使用を推奨
- `{ merge: true }` オプションなしで `set` を使用すると、指定したフィールド以外のデータが失われるため、意図したデータ構造を維持するための注意が必要

## 注意点

- `doc()` メソッドは同期処理であり、Firestore へのリクエストは発生しない
- データの読み書き操作（`set()`, `get()`, `update()`, `delete()`）が非同期処理として実行され、Firestore へのリクエストを発生させる
- `doc()` の段階でドキュメント ID が自動生成され、クライアント側で保持される
- データベースに実際のドキュメントが作成されるのは、その後の `set()` や `add()` などの操作を通じてのみ
