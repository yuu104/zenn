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

## `onSnapshot` メソッドを使用してデータ更新を監視する

- `onSnapshot` は Firestore のドキュメントやコレクションの変更をリアルタイムで監視
- 変更があるたびに指定したコールバック関数が自動的に実行される

### 主な使用ケース

- ユーザーインターフェースのリアルタイム更新
- データベースの変更を即時反映させるアプリケーション機能

### ドキュメント監視

- 特定のドキュメントの変更を監視
- ドキュメントが更新されると、登録されたリスナー関数が呼び出される

```javascript
const docRef = db.collection("collectionName").doc("docId");
const unsubscribe = docRef.onSnapshot((docSnapshot) => {
  if (docSnapshot.exists) {
    console.log("Current data:", docSnapshot.data());
  } else {
    console.log("Document does not exist");
  }
});
```

### コレクション監視

- コレクション内のドキュメントの追加、更新、削除を監視
- 各変更タイプ（`added`, `modified`, `removed`）に対する処理を実装可能

```javascript
const collectionRef = db.collection("collectionName");
const unsubscribe = collectionRef.onSnapshot((snapshot) => {
  snapshot.docChanges().forEach((change) => {
    if (change.type === "added") {
      console.log("New doc:", change.doc.data());
    } else if (change.type === "modified") {
      console.log("Modified doc:", change.doc.data());
    } else if (change.type === "removed") {
      console.log("Removed doc:", change.doc.data());
    }
  });
});
```

### リスナーの解除

- 監視が不要になった場合、`onSnapshot` によって返される関数を呼び出してリスナーを解除
- メモリリーク防止とコスト管理のため、不要になったリスナーは適切に解除することが重要

```javascript
// リスナー解除
unsubscribe();
```

### 監視の停止タイミング

- コンポーネントのアンマウント時（React など）
- ページ遷移やアプリの状態変更時
- 監視対象のデータが不要になった時

### 実装のベストプラクティス

- React での使用例
- `useEffect` フック内でリスナーを登録し、クリーンアップ関数で解除

```javascript
useEffect(() => {
  const unsubscribe = db.collection("myCollection").onSnapshot((snapshot) => {
    // 変更に対する処理
  });

  // コンポーネントのクリーンアップ時にリスナー解除
  return () => unsubscribe();
}, []);
```

リスナーがアクティブな状態が続くと予期せぬ読み取り回数の増加やコスト増加のリスクがあるため、リスナーのライフサイクル管理に注意を払う。

### エラーハンドリング

- `onSnapshot` の第二引数にエラーハンドリング関数を指定可能
- 監視中にエラーが発生した場合、指定したエラーハンドリング関数が呼び出される
- リスナーはエラー発生後もアクティブな状態が続くため、不要になったリスナーは明示的に解除する必要がある

#### 使用例

```js
const docRef = db.collection("collectionName").doc("docId");
const unsubscribe = docRef.onSnapshot(
  (docSnapshot) => {
    // データ更新時の処理
  },
  (error) => {
    console.error("Error listening to document:", error);
    unsubscribe(); // エラー時にリスナーを解除
  }
);
```

#### 注意点

- エラーが発生してもリスナーは自動的には停止しないため、不要になったリスナーは適切に解除することが重要
- エラーハンドリングは、ユーザーに適切なフィードバックを提供し、アプリケーションの挙動をコントロールするために使用される
- エラーの種類に応じて、リスナーの解除、再試行の提案、または適切なエラーメッセージの表示など、異なる対応を検討する
