---
title: "単体テストの構造"
---

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
   - テスト対象の「振る舞い」を実行する `Calculator` インスタンスを生成
2. **実行（Act）**
   - Arrange で用意したテスト対象の `sum` メソッドを実行
   - Arrange で用意した値（`first`, `second`）を使用
   - 実行結果を `result` 変数に保持し、次のフェーズで使用できるようにする
3. **確認（Assert）**
   - `assertEquals` を使用して、期待値 `30` と実際の結果 `result` を比較
   - `assertEquals` は、引数に指定した 2 つの値が等しいことを検証するメソッド

\
このように、AAA パターンを用いることで、すべてのテストケースに対し簡潔で統一された構造を持たせられるようになります。
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
次の例では、以下 2 つの「振る舞い」の検証を同じテストケースに詰め込んでいます。

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

:::message
**テストフィクスチャ**

このように、Arrange フェーズで用意するオブジェクトやデータのことを「テストフィクスチャ」と呼びます。
名前の由来は「固定された(fixed)」という意味からきており、テストが毎回同じ状態から始められるようにするためのものです。

テストフィクスチャには以下のようなものが含まれます：

- テスト対象コンポーネント
- 依存コンポーネント
- テストデータ
- 必要な環境設定

:::

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
同じ「注文の受け付け」という振る舞いを検証していますが、複数のステップに分かれています。

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

#### 🤔 なぜ問題なのか？

2 つ目の例では、「注文を受け付ける」という 1 単位の振る舞いを検証していることに変わりはありません。
そのため、テスト自体が悪いわけではありません。

問題なのは、**テストを書く人が実装の詳細を知らないとテストができない状態です**。

1. 在庫確認が必要なことを知っていないといけない
2. 注文作成の方法を知っていないといけない
3. 在庫の更新方法を知っていないといけない

これはプロダクションコードの設計を見直すべきという警告サインとなります。

#### 🚀 改善の方向性

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

#### ex.）ユーザー登録機能

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

AAA パターンで説明した 3 つのフェーズの他に、**後始末（Cleanup）** が必要になるケースがあります。
これテスト実行後に、使用したリソースを適切に解放するためのフェーズです。

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

テストコードの可読性を高めるために、テスト対象システムと依存コンポーネントを明確に区別できるようにしましょう。

一般的な方法として、テスト対象コンポーネントを示す変数名には `sut` という名前を使用します。

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

以下のいずれかの方法を採用しましょう。

1. **コメントと空行で区切る**

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

2. **空行のみで区切る（コードが十分シンプルな場合）**

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

   :::message
   **必要以上に空行を入れすぎないように注意してください。**
   例えば、Arrange フェーズ内で複数の設定を行う場合、それらの間には空行を入れる必要はありません。
   :::

重要なのは、各フェーズの区切りが一目で分かることです。
テストケースのサイズが大きくなった場合でも、コードの構造が理解しやすくなります。

## テストフィクスチャの共有

複数のテストケースで同じようなテストフィクスチャを必要とする場合、コードの重複を避けるためにフィクスチャを共有したくなるのは自然なことです。
しかし、フィクスチャの共有方法によってはテストの質が損なわれてしまいます。

### 【アンチパターン】コンストラクタや beforeEach でテストフィクスチャを配置する

:::details JUnit（Java）でのコンストラクタ使用例

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CustomerTests
{
    // 共通して使われるテスト・フィクスチャ
    private final Store _store;
    private final Customer _sut;

    // コンストラクタでフィクスチャを初期化（各テスト実行前に呼び出される）
    public CustomerTests()
    {
        _store = new Store();
        _store.addInventory(Product.SHAMPOO, 10);
        _sut = new Customer();
    }

    // 在庫が十分にある場合、購入は成功する
    @Test
    public void purchase_succeeds_when_enough_inventory()
    {
        // Act
        boolean success = _sut.purchase(_store, Product.SHAMPOO, 5);

        // Assert
        assertTrue(success);
        assertEquals(5, _store.getInventory(Product.SHAMPOO));
    }

    // 在庫が十分にない場合、購入は失敗する
    @Test
    public void purchase_fails_when_not_enough_inventory()
    {
        // Act
        boolean success = _sut.purchase(_store, Product.SHAMPOO, 15);

        // Assert
        assertFalse(success);
        assertEquals(10, _store.getInventory(Product.SHAMPOO));
    }
}
```

:::

:::details Vitest（TypeScript）での beforeEach 使用例

```ts
import { beforeEach, test, expect } from "vitest";

describe("Customer", () => {
  // 共通して使われるテスト・フィクスチャ
  let store: Store;
  let sut: Customer;

  // beforeEachでフィクスチャを初期化（各テスト実行前に呼び出される）
  beforeEach(() => {
    store = new Store();
    store.addInventory(Product.SHAMPOO, 10);
    sut = new Customer();
  });

  // 在庫が十分にある場合、購入は成功する
  test("purchase succeeds when enough inventory", () => {
    // Act
    const success = sut.purchase(store, Product.SHAMPOO, 5);

    // Assert
    expect(success).toBe(true);
    expect(store.getInventory(Product.SHAMPOO)).toBe(5);
  });

  // 在庫が十分にない場合、購入は失敗する
  test("purchase fails when not enough inventory", () => {
    // Act
    const success = sut.purchase(store, Product.SHAMPOO, 15);

    // Assert
    expect(success).toBe(false);
    expect(store.getInventory(Product.SHAMPOO)).toBe(10);
  });
});
```

:::

コンストラクタや `beforeEach` に配置することで、2 つのテストケースは Arrange するロジックを共通化しています。
これにより、各テストケースでは Arrange フェーズのコードを省略できます。

しかし、このアプローチには重大な欠点が 2 つあります。

#### ① テストケース間の結合度が高くなる

テストケース間に強い結合が生まれます。
これにより、あるテストケースのために設定を変更すると、他のテストケースにも影響します。

ex.）初期在庫数を 10 → 15 に変更する場合：

```diff java
   // コンストラクタでフィクスチャを初期化（各テスト実行前に呼び出される）
   public CustomerTests() // または beforeEach(() => {
   {
     _store = new Store();
-    _store.addInventory(Product.SHAMPOO, 10);
+    _store.addInventory(Product.SHAMPOO, 15);
     _sut = new Customer();
   }
```

2 つ目のテストケース（`purchase_fails_when_not_enough_inventory`）が期待通りに動作しなくなります。
購入しようとする数量（15 個）が在庫数（15 個）と等しくなり、テストの前提条件が変わってしまうためです。

:::message
**1 つのテストケースに関する修正が、他のテストケースに影響をあたえてはいけない。**
:::

#### ② テストケースの可読性が下がる

テストケースのメソッドだけを見ても、何を検証したいのかを完全に理解することが難しくなります。

初期状態の設定がコンストラクタに分離されているため、テストの全体像を把握するには、`メソッド本体` + `コンストラクタ（beforeEach）` の両方を確認する必要があります。

:::message

**良いテストは自己完結的であり、テストメソッドを読むだけでテストの意図と前提条件が明確にわかるべき。**

:::

### 適切な共有方法

テストクラスに private なファクトリメソッドを用意する方法が効果的です。

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CustomerTests {

    // 在庫が十分にある場合、購入は成功する
    @Test
    public void purchase_succeeds_when_enough_inventory() {
        // Arrange
        Store store = createStoreWithInventory(Product.SHAMPOO, 10);
        Customer sut = createCustomer();

        // Act
        boolean success = sut.purchase(store, Product.SHAMPOO, 5);

        // Assert
        assertTrue(success);
        assertEquals(5, store.getInventory(Product.SHAMPOO));
    }

    // 在庫が十分にない場合、購入は失敗する
    @Test
    public void purchase_fails_when_not_enough_inventory() {
        // Arrange
        Store store = createStoreWithInventory(Product.SHAMPOO, 10);
        Customer sut = createCustomer();

        // Act
        boolean success = sut.purchase(store, Product.SHAMPOO, 15);

        // Assert
        assertFalse(success);
        assertEquals(10, store.getInventory(Product.SHAMPOO));
    }

    // 指定した在庫を抱える店を作成する
    private Store createStoreWithInventory(Product product, int quantity) {
        Store store = new Store();
        store.addInventory(product, quantity);
        return store;
    }

    // 顧客を作成する
    private static Customer createCustomer() {
        return new Customer();
    }
}
```

共通化できるフィクスチャをファクトリメソッドとして定義することで、次のような利点が得られます：

- テストコードを削減できる
- テストケースのメソッド側でフィクスチャの呼び出しを制御できるため、テストケース間の結合度を低くできる
- テストケースのメソッド内だけで、何を検証しているのかを把握できる

\
さらに、以下の利点も享受できます：

1. **Arrange フェーズの可読性が高くなる**

   ```diff java
   - // コンストラクタでArrange
   - public CustomerTests() {
   -     _store = new Store();
   -     _store.addInventory(Product.SHAMPOO, 10);
   -     _sut = new Customer();
   - }

   + // ファクトリメソッドを使用してArrange
   + Store store = createStoreWithInventory(Product.SHAMPOO, 10);
   + Customer sut = createCustomer();
   ```

   メソッド名と引数を見ることで、店（`Store`）オブジェクトがどのように生成されるのかを一目で理解できるようになります。

2. **テストフィクスチャコードが共有しやすくなる**

   ```java
   Store store = createStoreWithInventory(Product.SHAMPOO, 10);
   ```

   「⚪︎⚪︎ 商品の在庫を〇〇個持っている店を作成する」というロジックは共通化しつつも、「商品の種類」と「在庫数」はテストケース側で自由にパラメータ化できます。
   これにより、柔軟性を保ちながらコードの重複を避けることができます。

### 結合テストでは例外

コンストラクタや beforeEach でのフィクスチャ設定はアンチパターンと説明しましたが、例外的なケースも存在します。
それは、**すべてのテストケースで同一のフィクスチャ設定が必要な結合テスト**の場合です。

特にデータベースを使用する結合テストでは、テストクラス間で共通のセットアップロジックを共有するために基底クラスを活用する方法が効果的です。

```java
// 基底クラス
public abstract class IntegrationTests implements IDisposable
{
    protected readonly Database _database;

    protected IntegrationTests()
    {
        _database = new Database();
    }

    public void Dispose()
    {
        _database.Dispose();
    }
}

// 派生テストクラス
public class CustomerTests : IntegrationTests
{
    @Test
    public void purchase_succeeds_when_enough_inventory()
    {
        // ここでは、基底クラスで初期化された _database を使ってデータベースに関する
        // 処理を行う
        // ...
    }
}
```

この方法では、`CustomerTests`クラスには独自のコンストラクタがなく、基底クラスの`IntegrationTests`でデータベースが初期化されます。これにより:

1. データベース接続などの共通ロジックを一箇所にまとめられる
2. リソースの適切な解放（Dispose）が保証される
3. 複数のテストクラスで同じセットアップコードを繰り返し書く必要がない

ただし、この例外は「すべてのテストケースで同じ初期状態が必要」な場合に限られます。
テストケースによって異なる初期状態が必要な場合は、やはり各テストメソッド内で明示的に設定するほうが適切です。

## 命名

「どんな振る舞いを検証するのか？」をテストケースのメソッド名から把握できるようにすべき。

### アンチパターン

次のような命名規則は役に立たない。

- **`{テスト対象メソッド}_{事前条件}_{想定する結果}`**

何故か？
→ 「振る舞い」ではなく「実装の詳細」に着目しているから
