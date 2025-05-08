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

## 「振る舞いをテストする」ってどういうこと？

「振る舞い」という言葉に補足を入れると、「（クライアントから観察可能な）振る舞い」となります。

:::message

**「クライアント」って何？**
テスト対象を利用するコンポーネントのことです。

- コード（テストコードも含む）
- 外部アプリケーション
- UI

:::

つまり、テスト対象を利用する側から見て次の要素を検証（Assert）するということを指します。

- **どんな値を返すか？（結果）**
- **どんな影響を与えるのか？（副作用）**
- **どんな状態か？（状態）**

![](https://storage.googleapis.com/zenn-user-upload/811dc4505f85-20250429.png)

:::details どんな値を返すか？（結果）
メソッドが返す値を検証するテストです。
最も一般的で基本的な振る舞いの検証方法です。

```ts
// テスト対象：買い物かごの合計金額を計算する関数
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

// テストコード
import { test, expect } from "vitest";

test("空の買い物かごの合計金額は0円である", () => {
  // Arrange
  const emptyCart: Item[] = [];

  // Act
  const total = calculateTotal(emptyCart);

  // Assert：関数の戻り値を検証
  expect(total).toBe(0);
});

test("複数商品の合計金額が正しく計算される", () => {
  // Arrange
  const cart: Item[] = [
    { name: "りんご", price: 100, quantity: 2 },
    { name: "バナナ", price: 80, quantity: 3 },
  ];

  // Act
  const total = calculateTotal(cart);

  // Assert：関数の戻り値を検証
  expect(total).toBe(440); // (100×2) + (80×3) = 440
});
```

このテストでは「買い物かごに含まれる商品から合計金額がいくらになるか」というテスト対象メソッドの**結果**を検証しています。
内部実装（`reduce` メソッドを使っているなど）には一切言及せず、入力と出力の関係だけをテストしています。
:::

:::details どんな影響を与えるか？（副作用）

テスト対象が外部に及ぼす影響（副作用）を検証するテストです。
例えば、メール送信、データベース更新、ファイル出力などの処理が正しく行われたかを確認します。

```ts
// テスト対象：ユーザー登録サービス
class UserService {
  constructor(
    private emailSender: EmailSender,
    private userRepository: UserRepository
  ) {}

  async registerUser(email: string, password: string): Promise<User> {
    // メールアドレスのバリデーションなど
    if (!this.isValidEmail(email)) {
      throw new Error("Invalid email format");
    }

    // ユーザー登録
    const user = new User(email, password);
    await this.userRepository.save(user);

    // ウェルカムメール送信（副作用）
    await this.emailSender.sendWelcomeEmail(email);

    return user;
  }

  private isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }
}

// テストコード
import { test, expect, vi } from "vitest";

test("ユーザー登録成功時にウェルカムメールが送信される", async () => {
  // Arrange
  const mockEmailSender = {
    sendWelcomeEmail: vi.fn().mockResolvedValue(undefined),
  };
  const mockUserRepository = {
    save: vi.fn().mockResolvedValue({ id: "user-123" }),
  };

  const userService = new UserService(mockEmailSender, mockUserRepository);

  // Act
  await userService.registerUser("test@example.com", "password123");

  // Assert：外部への影響（副作用）を検証
  expect(mockEmailSender.sendWelcomeEmail).toHaveBeenCalledWith(
    "test@example.com"
  );
});
```

このテストでは「ユーザー登録時にウェルカムメールが送信される」という**副作用**を検証しています。
内部実装ではなく、外部から観察可能な振る舞い（メール送信が行われたか）だけをテストしています。

:::

:::details どんな状態か？（状態）
テスト対象の内部状態の変化を検証するテストです。
ただし、これは公開されているプロパティやメソッドを通じて観察可能な状態に限ります。

```java
// テスト対象：電子書籍リーダー
public class EbookReader {
    private Book currentBook;
    private int currentPage = 0;
    private boolean isBookOpen = false;

    public void openBook(Book book) {
        this.currentBook = book;
        this.currentPage = 0;
        this.isBookOpen = true;
    }

    public void closeBook() {
        this.isBookOpen = false;
    }

    public void nextPage() {
        if (isBookOpen && currentPage < currentBook.getTotalPages() - 1) {
            currentPage++;
        }
    }

    public void previousPage() {
        if (isBookOpen && currentPage > 0) {
            currentPage--;
        }
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public boolean isBookOpen() {
        return isBookOpen;
    }

    public Book getCurrentBook() {
        return currentBook;
    }
}

// テストコード
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class EbookReaderTest {

    @Test
    public void 本を開くと最初のページが表示される() {
        // Arrange
        EbookReader reader = new EbookReader();
        Book book = new Book("プログラミング入門", 200);

        // Act
        reader.openBook(book);

        // Assert：オブジェクトの状態を検証
        assertEquals(0, reader.getCurrentPage());
        assertTrue(reader.isBookOpen());
        assertEquals(book, reader.getCurrentBook());
    }

    @Test
    public void 次のページに進める() {
        // Arrange
        EbookReader reader = new EbookReader();
        Book book = new Book("プログラミング入門", 200);
        reader.openBook(book);

        // Act
        reader.nextPage();

        // Assert：オブジェクトの状態を検証
        assertEquals(1, reader.getCurrentPage());
    }

    @Test
    public void 最後のページで次のページに進もうとしても変化しない() {
        // Arrange
        EbookReader reader = new EbookReader();
        Book book = new Book("プログラミング入門", 2);
        reader.openBook(book);
        reader.nextPage(); // 1ページ目（最後のページ）に移動

        // Act
        reader.nextPage(); // これ以上進めない

        // Assert：オブジェクトの状態を検証
        assertEquals(1, reader.getCurrentPage()); // ページが変わっていないことを確認
    }
}
```

このテストでは「本を開く」「ページを進める」などの操作後の**状態**を検証しています。
内部変数の実装詳細ではなく、公開 API を通じて観察可能な状態（現在のページ番号、本が開いているかなど）だけをテストしています。
:::

:::message
**副作用と振る舞いの関係**
\
副作用をテストする際には注意が必要です。
副作用は「観察可能な振る舞い」の一種でありながら、同時に「実装の詳細」の側面も持ち合わせています。

どの副作用をテストすべきかは、その副作用がクライアントにとってどれだけ重要であるかによって判断します。
API 仕様に明記された副作用や機能要件として期待される副作用は「振る舞い」として検証すべきですが、内部実装として存在するだけの副作用をテストすると偽陽性につながる可能性があります。

「この副作用は何のために存在するのか？」という問いを常に念頭に置きながら、真に重要な振る舞いだけを検証することが重要です。
:::
