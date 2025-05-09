---
title: "テストダブル"
---

## テストダブルの種類

以下 5 種類存在します。

- ダミー
- スタブ
- スパイ
- モック
- フェイク

しかし、実際には「モック」と「スタブ」の 2 つに分類できます。
![](https://storage.googleapis.com/zenn-user-upload/3d627293ff7d-20250426.png)

### モック

- [テスト対象] → [依存コンポーネント] へのコミュニケーションを**模倣**する
- [テスト対象] → [依存コンポーネント] へのコミュニケーションを**検証**する

テスト対象が依存コンポーネントを「**どのように呼び出したか**」模倣・検証するという意味です。

例えば：

- メール送信サービスを正しく呼び出したか？
- DB に正しいデータを保存しようとしたか？
- ログを正しい形式で記録したか？

```ts
test("ユーザー登録時にメール送信が呼ばれる", () => {
  // Arrange
  const mockEmailService: EmailService = {
    sendWelcomeEmail: vi.fn(), // 模倣
  };
  const userService = new UserService(mockEmailService);

  // Act
  userService.registerUser("test@example.com");

  // Assert（検証）
  expect(mockEmailService.sendWelcomeEmail).toHaveBeenCalledWith(
    "test@example.com"
  );
});
```

### スタブ

- [依存コンポーネント] → [テスト対象]へのコミュニケーションを**模倣**する

テスト対象が依存コンポーネントから「**どのようなデータを受け取るか**」を模倣します。

:::message
**スタブは検証（Assert）には使用しません。**

偽陽性を生む原因となるからです。
:::

例えば：

- ユーザー情報の取得結果を返す
- API からのレスポンスを返す
- 設定ファイルの値を返す

```java
@Test
public void ユーザー情報を正しく処理できる() {
    // Arrange
    UserRepository stubRepository = new UserRepository() { // 模倣
        @Override
        public User findById(String id) {
            return new User("123", "テストユーザー", true);
        }
    };
    UserService userService = new UserService(stubRepository);

    // Act
    User user = userService.getUser("123");

    // Assert
    assertEquals("テストユーザー", user.getName());
}
```

![](https://storage.googleapis.com/zenn-user-upload/4ee560f32775-20250427.png)

## 「モック」は複数の意味を持つ

「モック」という言葉は、コンテキストによって異なる意味を指します。

1. **テストダブルにおける「モック」**

   - 前章で解説した通り

2. **ライブラリにおける「モック」**
   - テストダブルを実現するためのライブラリ
     - 「モックライブラリ」と呼ばれる
   - ライブラリを利用して「モックオブジェクト」を作成する

### ライブラリにおける「モック」

モックオブジェクトとは、モックライブラリによって生成される**テストダブルの実装**です。
同じモックオブジェクトを、モックとしてもスタブとしても使用できます。

**モックオブジェクトをモックとして使用する例**

```java
@Test
public void 挨拶メールが送信される() {
    // Arrange
    // モックオブジェクトを生成
    EmailGateway mockEmailGateway = mock(EmailGateway.class);
    Controller sut = new Controller(mockEmailGateway);

    // Act
    sut.greetUser("user@email.com");

    // Assert
    // モックとして使用：外部への呼び出しを検証
    verify(mockEmailGateway).sendGreetingsEmail("user@email.com");
}
```

**モックオブジェクトをスタブとして使用する例**

```java
@Test
public void レポートが正しく作成される() {
    // Arrange
    // モックオブジェクトを生成
    Database stubDatabase = mock(Database.class);
    // スタブとして使用：戻り値を設定
    when(stubDatabase.getNumberOfUsers()).thenReturn(10);
    Controller sut = new Controller(stubDatabase);

    // Act
    Report report = sut.createReport();

    // Assert
    assertEquals(10, report.getNumberOfUsers());
}
```

:::message
**モックライブラリが生成する単一のオブジェクトが、用途に応じてモックにもスタブにもなり得る**という点が「モック」という言葉の混乱を招く要因の一つとなっています。
:::

## スタブを Assert に使用しない

スタブは依存コンポーネントを**模倣**するために使用しますが、**検証（Assert）** するための使用は避けるべきです。

### 何故か？ → 偽陽性を招くから

スタブを Assert する
↓ スタブ = テスト対象の最終結果を算出するための**途中処理結果**
途中処理結果を Assert する
↓
実装方法をテストする
↓
偽陽性を招く

具体的なコード例で見てみましょう：

```java
@Test
public void レポートが正しく作成される_誤った例() {
    // Arrange
    Database stub = mock(Database.class);
    when(stub.getNumberOfUsers()).thenReturn(10);
    Controller sut = new Controller(stub);

    // Act
    Report report = sut.createReport();

    // Assert
    assertEquals(10, report.getNumberOfUsers()); // ✅ 最終的な結果の検証
    verify(stub).getNumberOfUsers();             // ❌ スタブの呼び出しを検証（途中処理の検証）
}
```

- テスト対象はレポートの作成を責務とする `Controller.createReport()`
- レポート作成に必要なデータを取得する `Database.getNumberOfUsers()` をスタブ化
- `Controller` の依存コンポーネントとして `Database` が存在する

\
この例には 2 つの Assert が存在します：

1. **`assertEquals(10, report.getNumberOfUsers())` ✅**

   - テスト対象の振る舞い（レポート作成）の最終結果を検証している
   - 実装方法が変わっても、この検証は有効であり続ける

2. **`verify(stub).getNumberOfUsers()` ❌**
   - テスト対象の「実装方法」（データ取得の手段）を検証している
   - 具体例：
     - 現在：DB から直接データを取得
     - 将来：パフォーマンス改善のためキャッシュを導入
       ex. `Database` -> `Cache` に変更
     - 結果：テストが失敗する
   - テスト対象（`Controller.createReport()`）の振る舞いに変化はなく正しく動作しているのに、テストが実装の変更を検知して失敗する
     → 偽陽性

:::message
**テストで検証すべきは「最終的な結果」であり、「結果を導くための途中処理」ではない。**
:::
