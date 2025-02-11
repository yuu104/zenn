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

「AAA」とは、テストケースの構造に関するパターンのことです。
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
「統一性がある」ことは「可読性が高まる」ことに繋がるため、構造を理解し実践することは、テスト実装者だけでなくチーム全体にも利益をもたらします。

## 【アンチパターン】同じフェーズを複数用意する

1 つのテストケースに同じフェーズが複数存在するは、単体テストとして望ましくありません。
![](https://storage.googleapis.com/zenn-user-upload/a64b95da5632-20250209.png =250x)

### 🤔 なぜアンチパターンなのか？

**複数の「振る舞い」を検証している**からです。

上記は「実行（Act）」と「確認（Assert）」を 2 回行っています。
これは、単体テストの定義である「**1 単位の振る舞いを検証すること**」に反しています。

このような検証は「結合テスト」として実施すべきです。

### 🤔 どうしてアンチパターンを踏んでしまうのか？

「効率を重視してしまう」ケースが多いのではないでしょうか？

- 「似たようなテストを書くなら、1 つのテストケースにまとめた方が効率的では？」と考えてしまう
- テストコードの量を減らしたい。DRY を意識しすぎるあまり、複数の検証を 1 つのテストに詰め込んでしまう
- テスト対象の実行結果が、次のテストケースの事前条件として使えることに気づいてしまう

\
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

\
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

## 【アンチパターン】if 文の使用

テストコード内で if 文を使用することは、単体テストのアンチパターンとされています。
これは単体テストに限らず、統合テストにおいても該当します。

### 🤔 なぜアンチパターンなのか？

**テストの意図が曖昧になる**からです。
対象となる「振る舞い」が条件によって変化し、テストケースが何を検証したいのかが分かりづらくなります。

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

## AAA における各フェーズの適切なサイズは？

### 準備（Arramge）が最も大きくなりやすい

準備フェーズは、テストに必要なオブジェクトや状態を整えるため、必然的に大きくなりがちです。これは問題ありません。

```java
@Test
public void ユーザーを正しく登録できる() {
    // Arrange - 必要なセットアップは全て行う
    String email = "test@example.com";
    String password = "password123";
    String firstName = "Taro";
    String lastName = "Yamada";
    int age = 25;
    Address address = new Address("Tokyo", "Shibuya", "1-1-1");

    UserCreateRequest request = new UserCreateRequest(
        email, password, firstName, lastName, age, address
    );
    UserService userService = new UserService();
}
```

ただ、大きすぎるとテストケースの可読性が下がることもあるでしょう。
そんな時は、テストクラスの別メソッドに切り出すと良いです。

```java
@Test
public void ユーザーを正しく登録できる() {
    // Arrange
    UserCreateRequest request = createDefaultUserRequest();
    UserService userService = createUserService();

    // Act & Assert（省略）
}

private UserCreateRequest createDefaultUserRequest() {
    return new UserCreateRequest(
        "test@example.com",
        "password123",
        "Taro",
        "Yamada",
        25,
        new Address("Tokyo", "Shibuya", "1-1-1")
    );
}

private UserService createUserService() {
    // 必要な依存関係を含むUserServiceのインスタンスを作成
    return new UserService(new UserRepository(), new PasswordEncoder());
}
```

切り出すことで、テストケースの可読性が向上するだけでなく、準備（Arrange）フェーズをテストケース間で共有することが可能になります。

切り出し方の手法は他にも様々存在しますが、メジャーなものだと以下の 2 つがあります。

:::details オブジェクト・マザー（Object Mother）

- テストデータを生成する「母体」となるクラスを用意する方法
- よく使うテストデータを一箇所で管理できる
- メソッド名で用途が分かりやすい

```java
public class UserTestMother {
    // 標準的なユーザーリクエストを作成
    public static UserCreateRequest createDefault() {
        return new UserCreateRequest(
            "test@example.com",
            "password123",
            "Taro",
            "Yamada",
            25,
            new Address("Tokyo", "Shibuya", "1-1-1")
        );
    }

    // 未成年ユーザーのリクエストを作成
    public static UserCreateRequest createMinor() {
        return new UserCreateRequest(
            "minor@example.com",
            "password123",
            "Taro",
            "Yamada",
            15,  // 年齢だけ変更
            new Address("Tokyo", "Shibuya", "1-1-1")
        );
    }
}
```

:::

:::details テスト・データ・ビルダー（Test Data Builder）

- ビルダーパターンを使ってテストデータを柔軟に構築
- 必要な値だけを変更できる
- デフォルト値を持つため、毎回すべての値を指定する必要がない

```java
public class UserCreateRequestBuilder {
    // デフォルト値を定義
    private String email = "test@example.com";
    private String password = "password123";
    private int age = 25;

    // 必要な値だけを変更するメソッド
    public UserCreateRequestBuilder withEmail(String email) {
        this.email = email;
        return this;
    }

    public UserCreateRequestBuilder withAge(int age) {
        this.age = age;
        return this;
    }

    public UserCreateRequest build() {
        return new UserCreateRequest(email, password, age);
    }
}
```

:::

テストクラスでは、それぞれ以下のように使用します。

```java
@Test
public void ユーザー登録のテスト() {
    // Object Motherパターンの使用例
    UserCreateRequest request1 = UserTestMother.createDefault();

    // Test Data Builderパターンの使用例
    UserCreateRequest request2 = new UserCreateRequestBuilder()
        .withEmail("custom@example.com")
        .withAge(30)
        .build();
}
```

どちらを選ぶかは、テストデータの性質や用途によって決めましょう。

- 定型的なデータが多い → Object Mother
- カスタマイズが多い → Test Data Builder

### 実行（Act）のコードが 2 行以上の場合は注意

通常、実行（Act）フェーズは 1 行で十分です。
2 行以上になる場合、それはプロダクションコードの設計に問題がある可能性を示唆します。

**ex.）EC サイトの注文処理**
商品を注文する際のシンプルなテストケースを見てみましょう。
このテストでは「注文が正常に受け付けられること」という振る舞いを検証します。

```java
@Test
public void 商品を注文できる() {
    // Arrange
    Order order = new Order("みかん", 3);
    Shop shop = new Shop();

    // Act - 注文という1つの振る舞いが1行で表現できている
    OrderResult result = shop.placeOrder(order);

    // Assert
    assertTrue(result.isSuccessful());
    assertEquals(OrderStatus.ACCEPTED, result.getStatus());
}
```

一方で、以下のようなテストコードを見かけることがあります。
同じ「注文の受け付け」という振る舞いを検証していますが、、複数のステップに分かれています。

```java
@Test
public void 商品を注文できる_悪い例() {
    // Arrange
    Order order = new Order("みかん", 3);
    Shop shop = new Shop();

    // Act - 注文という1つの振る舞いなのに、複数のステップが必要
    boolean hasStock = shop.checkStock("みかん", 3);  // 在庫確認
    int orderId = shop.createOrder(order);           // 注文作成
    shop.updateStock("みかん", -3);                  // 在庫更新

    // Assert
    assertTrue(hasStock);
    assertTrue(orderId > 0);
}
```

**🤔 なぜ問題なのか？**
2 つ目の例では、「注文を受け付ける」という 1 単位の振る舞いを検証していることに変わりはありません。
そのため、テスト自体が悪いわけではありません。

問題なのは、**テストを書く人が実装の詳細を知らないとテストができない状態です**。

1. 在庫確認が必要なことを知っていないといけない
2. 注文作成の方法を知っていないといけない
3. 在庫の更新方法を知っていないといけない

これはロダクションコードの設計を見直すべきという警告サインとなります。

\
**🚀 改善の方向性**
プロダクションコードは以下のように改善できます。

```java
public class Shop {
    public OrderResult placeOrder(Order order) {
        // 在庫確認、注文作成、在庫更新をこのメソッド内でカプセル化
        if (!hasEnoughStock(order)) {
            return OrderResult.failed("在庫不足");
        }

        int orderId = createNewOrder(order);
        updateStock(order);

        return OrderResult.successful(orderId);
    }

    private boolean hasEnoughStock(Order order) { /* ... */ }
    private int createNewOrder(Order order) { /* ... */ }
    private void updateStock(Order order) { /* ... */ }
}
```

このように、関連する処理を 1 つのメソッドにカプセル化することで、

- テストを書く人は「注文する」という振る舞いだけを理解していれば良い
- 実装の詳細に依存せずにテストが書ける
- プロダクションコードの内部実装を変更してもテストを修正する必要がない

:::message

「実行（Act）を 1 行にする」という原則は、あくまでも目安です。
特にビジネスロジックを扱うコードでは、この原則に従うことで設計の問題点を発見できます。
\
ただし、これは絶対的なルールではありません。

次ような場合、一時的に複数行の Act が存在することは許容されます。

- ユーティリティクラスをテストする
- インフラに関するコードをテストする
- 段階的なリファクタリングの過程で、既存のコードベースをテストする

:::

### 確認（Assert）のサイズ

「テストでは確認（Assert）を 1 つだけにすべき」という意見を聞くことがあります。
しかし、これは誤解です。
大切なのは「1 単位の振る舞い」を検証することであり、その振る舞いから複数の結果が生じるのであれば、それら全てを確認するのは自然なことです。

**ex.）ユーザー登録機能**
ユーザー登録という 1 つの振る舞いを検証するテストを見てみましょう。
この振る舞いからは複数の結果が生じます。

- ユーザーが正しく作成されたか
- メールアドレスが正しく設定されているか
- アカウントが有効化されているか
- 確認メールが送信されたか

```java
@Test
public void 新規ユーザーを正しく登録できる() {
    // Arrange
    UserRegistrationRequest request = new UserRegistrationRequest(
        "test@example.com",
        "password123",
        "Taro Yamada"
    );
    UserService userService = new UserService();

    // Act
    User registered = userService.register(request);

    // Assert - ユーザー登録という1つの振る舞いに対する複数の検証
    assertNotNull(registered.getId());  // IDが発行されている
    assertEquals(request.getEmail(), registered.getEmail());  // メールアドレスが設定されている
    assertTrue(registered.isActive());  // アカウントが有効化されている
    assertFalse(registered.isVerified());  // メール未認証状態になっている
}
```

これらの確認は全て「ユーザー登録」という 1 つの振る舞いから生じる結果です。
そのため、複数の Assert が存在しても問題ありません。

:::message

ただし、Assert のサイズが大きすぎる場合、注意が必要です。

```java
@Test
public void ユーザー情報を検証する_冗長な例() {
    // Arrange
    UserRegistrationRequest request = new UserRegistrationRequest(
        "test@example.com", "password123", "Taro Yamada"
    );
    UserService userService = new UserService();

    // Act
    User actual = userService.register(request);

    // Assert - 全フィールドを個別に検証している
    assertEquals(request.getEmail(), actual.getEmail());
    assertEquals(request.getName(), actual.getName());
    assertEquals(UserStatus.ACTIVE, actual.getStatus());
    assertFalse(actual.isVerified());
    assertEquals(AccountType.STANDARD, actual.getAccountType());
    assertEquals(0, actual.getLoginCount());
    assertNull(actual.getLastLoginAt());
    assertEquals(Collections.emptyList(), actual.getRoles());
    // etc...
}
```

\
このような冗長な検証が必要になるのは、多くの場合プロダクションコードの抽象化が適切でないことを示唆しています。

1. オブジェクトの責務が大きすぎる
2. 適切な集約が行われていない

\
個別のフィールドを検証するのではなく、オブジェクトの同値性を適切に定義することで、テストをシンプルにできます。

```java
@Test
public void ユーザー情報を検証する_改善例() {
    // Arrange
    UserRegistrationRequest request = new UserRegistrationRequest(
        "test@example.com", "password123", "Taro Yamada"
    );
    UserService userService = new UserService();

    // Act
    User actual = userService.register(request);

    // Assert - 期待するオブジェクトと実際のオブジェクトを比較
    User expected = new User(
        request.getEmail(),
        request.getName(),
        UserStatus.ACTIVE,
        AccountType.STANDARD
    );
    assertEquals(expected, actual);
}
```

:::

\
このように、Assert の数は「1 単位の振る舞い」から生じる結果の数に応じて自然に決まります。
もし冗長な検証が必要になる場合は、プロダクションコードの設計を見直すきっかけとして捉えましょう。

## テスト後の後始末（第４のフェーズ）

場合によっては、確認（Assert）の次のフェーズとして**後始末**が必要になる。

ex.）

- テスト時に生成したファイルを削除する
- DB の接続を切断する

このような後始末の処理は個別のメソッドに切り出し、テストケースのメソッドから呼び出す。

しかし、単体テストの場合、**後始末の処理は必要ないケースがほとんど**。
なぜなら、「後始末」は大抵プロセス外依存になり、そのほとんどは共有依存となるため、単体テストでは扱わない。（テストダブルに置き換える）

よって、後始末が必要になるようなテストは結合テスト以降になるケースが多い。

## テスト後の後始末（第４のフェーズ）

AAA パターンで説明した 3 つのフェーズの他に、**後始末（Cleanup）** が必要になるケースがあります。
これは主にテスト実行後に、使用したリソースを適切に解放するためのフェーズです。

例えば以下のような場合です。

```java
@Test
public void 一時ファイルに書き込みができる() {
    // Arrange
    File tempFile = new File("temp.txt");
    FileWriter writer = new FileWriter(tempFile);

    // Act
    writer.write("test data");
    writer.close();

    // Assert
    assertTrue(tempFile.exists());
    assertEquals("test data", Files.readString(tempFile.toPath()));

    // Cleanup - テスト後に一時ファイルを削除
    tempFile.delete();
}
```

このような後始末処理は、テストケースごとに記述するのではなく、テストフレームワークの機能を使って共通化するのが一般的です。

```java
public class FileWriterTest {
    private File tempFile;

    @BeforeEach
    void setUp() {
        tempFile = new File("temp.txt");
    }

    @AfterEach
    void cleanup() {
        if (tempFile.exists()) {
            tempFile.delete();
        }
    }

    @Test
    public void 一時ファイルに書き込みができる() {
        // Arrange
        FileWriter writer = new FileWriter(tempFile);

        // Act
        writer.write("test data");
        writer.close();

        // Assert
        assertTrue(tempFile.exists());
        assertEquals("test data", Files.readString(tempFile.toPath()));
    }
}
```

### 単体テストにおいて「後始末」は稀なケース

しかし、単体テストにおいて後始末が必要になるケースは稀です。
なぜなら、**「後始末」は大抵プロセス外依存になり、そのほとんどは共有依存となるため**です。

後始末が必要になるケースは、主に結合テストや E2E テストなど、実際のリソースを使用するテストで発生します。

## リーダブルなテストコードを書くための Tips

### テスト対象コンポーネントと依存コンポーネントを区別しやすくする

テスト対象システム（System Under Test: SUT）は重要な役割を担っています。アプリケーション全体の中で「どの部分の振る舞いを検証するのか」を提供するのがテスト対象システムだからです。

テストコードの可読性を高めるために、テスト対象システムと依存コンポーネントを明確に区別できるようにしましょう。

一般的な方法として、テスト対象システムを示す変数名には `sut` という名前を使用します：

```java
@Test
public void Sum_of_two_numbers() {
    // Arrange
    double first = 10;
    double second = 20;
    Calculator sut = new Calculator();  // テスト対象システムを示す命名

    // Act
    double result = sut.sum(first, second);

    // Assert
    assertEquals(30, result);
}
```

### AAA の各フェーズを区別しやすくする

テストコードの構造を理解しやすくするために、AAA の各フェーズを視覚的に区別することも重要です。

以下のいずれかの方法を採用しましょう：

1. コメントと空行で区切る

```java
@Test
public void Sum_of_two_numbers() {
    // Arrange
    double first = 10;
    double second = 20;
    Calculator sut = new Calculator();

    // Act
    double result = sut.sum(first, second);

    // Assert
    assertEquals(30, result);
}
```

2. 空行のみで区切る（コードが十分シンプルな場合）

```java
@Test
public void Sum_of_two_numbers() {
    double first = 10;
    double second = 20;
    Calculator sut = new Calculator();

    double result = sut.sum(first, second);

    assertEquals(30, result);
}
```

ただし、**必要以上に空行を入れすぎないように注意**してください。例えば、Arrange フェーズ内で複数の設定を行う場合、それらの間には空行を入れる必要はありません。

重要なのは、各フェーズの区切りが一目で分かることです。テストケースのサイズが大きくなった場合でも、コードの構造が理解しやすくなります。
