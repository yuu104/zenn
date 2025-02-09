---
title: "単体テストの構造"
---

:::message
**Summary**

- テストケースの構造
- テストケースのメソッド命名におけるベストプラクティス
- パラメータ化のテスト
- リーダブルなアサーションの書き方

:::

## AAA パターン

テストケースの構造に関するパターンのことです。
以下 3 つのフェーズで構成されています。

![](https://storage.googleapis.com/zenn-user-upload/d39132fce103-20250209.png =250x)

1. **準備（Arrange）**
   - テストケースの事前条件を満たすようにテスト対象と依存コンポーネントを用意する
2. **実行（Act）**
   - テスト対象を実行し、検証したい「振る舞い」を実行する
   - この時、Arrange しておいた依存コンポーネントも実行される
   - メソッドの戻り値のように、「振る舞い」により結果が返却される場合は、次のフェーズ（Assert）で使用できるように保持しておく
3. **確認（Assert）**
   - 実行結果が期待通りであることを確認する
   - 「実行結果」とは、以下が想定される
     - テスト対象メソッドの「戻り値」
     - テスト対象や依存コンポーネントの「状態」
     - テスト対象により、依存コンポーネントが呼び出されたという「記録」

具体例として、以下のシンプルな足し算メソッド `sum` をテストします。

```java
// テスト対象のCalculatorクラス
public class Calculator {
    public double sum(double first, double second) {
        return first + second;
    }
}
```

テストコードは以下になります。

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CalculatorTest { // 関連性のあるテストケースを集めたクラス

    @Test // ← テストケースであることを示すJUnitのアノテーション
    public void sum_of_two_numbers() { // ← テストケースを表すメソッド
        // Arrange（準備）フェーズ
        double first = 10;
        double second = 20;
        Calculator calculator = new Calculator();

        // Act（実行）フェーズ
        double result = calculator.sum(first, second);

        // Assert（確認）フェーズ
        assertEquals(30, result);
    }
}
```

1. **準備（Arrange）**
   - テストに使用する値（`first = 10`、`second = 20`）を用意
   - テスト対象の `Calculator` インスタンスを生成
2. **実行（Act）**
   - Arrange で用意したテスト対象の `sum` メソッドを実行
   - Arrange で用意した値を使用
   - 実行結果を `result` 変数に保持し、次のフェーズで使用できるようにする
3. **確認（Assert）**
   - `assertEquals` を使用して、期待値 `30` と実際の結果 `result` を比較
   - `assertEquals` は、引数に指定した 2 つの値が等しいことを検証するメソッド

\
このように、AAA パターンを用いることで、すべてのテストケースに対し、簡潔で統一された構造を持たせられるようになります。
「統一性がある」ことは「可読性が高まる」ことに繋がるため、構造を理解し、実践することはテスト実装者だけでなく、チーム全体におおきな利益をもたらします。

## 【アンチパターン】同じフェーズを複数用意する

1 つのテストケースに同じフェーズが複数存在するは、単体テストとして望ましくありません。
![](https://storage.googleapis.com/zenn-user-upload/a64b95da5632-20250209.png =250x)

### なぜアンチパターンなのか？

**複数の「振る舞い」を検証している**からです。

上記は「実行（Act）」と「確認（Assert）」を 2 回おこなっています。
これは、単体テストの定義である「**1 単位の振る舞いを検証すること**」に反しています。

このような検証は「結合テスト」として実施すべきです。

:::message
**🤔 どうしてアンチパターンを踏んでしまうのか？**
以下のように「効率を重視してしまう」ケースが多いのではないでしょうか？

- 「似たようなテストを書くなら、1 つのテストケースにまとめた方が効率的では？」と考えてしまう
- テストコードの量を減らしたい。DRY を意識しすぎるあまり、複数の検証を 1 つのテストに詰め込んでしまう
- テスト対象の実行結果が、次のテストケースの事前条件として使えることに気づいてしまう

下記は以下 2 つの「振る舞い」の検証を同じテストケースに詰め込んでいます。

- ユーザー情報の登録
- ユーザー情報の取得

```java
@Test
public void 間違った例_状態共有による効率化() {
    // Arrange
    User user = new User("test@example.com");
    UserService service = new UserService();

    // Act①
    service.register(user);
    // Assert①
    assertTrue(service.exists(user.getId()));

    // Act② （前のActの結果を使って検証）
    User found = service.findById(user.getId());
    // Assert②
    assertEquals("test@example.com", found.getEmail());
}
```

一見、効率的に思えますが、このようなテストケースは「結合テスト」になります。
単体テストとして検証したい場合、振る舞いを分割し、テストケースを増やしましょう。

```java
@Test
public void ユーザー登録が成功すること() {
    // Arrange
    User user = new User("test@example.com");
    UserService service = new UserService();

    // Act
    service.register(user);

    // Assert
    assertTrue(service.exists(user.getId()));
}

@Test
public void 登録されたユーザーが正しく検索できること() {
    // Arrange
    User user = new User("test@example.com");
    UserService service = new UserService();
    service.register(user);  // テストの前提条件として明示的に実行

    // Act
    User found = service.findById(user.getId());

    // Assert
    assertEquals("test@example.com", found.getEmail());
}
```

:::

## 【アンチパターン】if 文の使用

テストコード内で if 文を使用することは、単体テストのアンチパターンとされています。
これは単体テストに限らず、統合テストにおいても該当します。

### なぜアンチパターンなのか？

**テストの意図が曖昧になる**からです。
検証する「振る舞い」が条件によって変化し、テストケースが何を検証したいのかが分かりづらくなります。

例えば、以下のテストコードは、検証したい「振る舞い」が不明確になっています。

```java
@Test
public void ユーザー登録のテスト() {
    // Arrange
    UserRegisterRequest request = new UserRegisterRequest("test@example.com", "password123");
    UserService userService = new UserService();

    // Act & Assert が条件分岐の中に...
    if (!userService.exists(request.getEmail())) {
        // Act
        User registered = userService.register(request);

        // Assert
        assertNotNull(registered.getId());
        assertEquals(request.getEmail(), registered.getEmail());
    } else {
        // 別のAct & Assert
        assertThrows(DuplicateEmailException.class,
            () -> userService.register(request));
    }
}
```

- 新規ユーザーの登録成功を検証したいのか？
- メールアドレス重複時のエラーを検証したいのか？
