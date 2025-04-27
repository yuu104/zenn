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

しかし、実際には「モック」と「スタブ」の 2 つに分類できる。
![](https://storage.googleapis.com/zenn-user-upload/3d627293ff7d-20250426.png)

### モック

- **外部に向かう**コミュニケーション（出力）を模倣する
- **外部に向かう**コミュニケーション（出力）を検証する

テスト対象が依存コンポーネントに対して「どのように呼び出したか」を模倣・検証するという意味です。

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

- **内部に向かう**コミュニケーション（出力）を模倣する

テスト対象が依存コンポーネントから「どのようなデータを受け取るか」を模倣します。

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

スタブは依存コンポーネントを**模倣**するために使用しますが、**検証（Assert）**するためには使用しません。
