---
title: "「振る舞い」の検証"
---

## 「振る舞いを検証する」とは？

次の要素を検証（Assert）するということを指します。

- **どんな値を返すか？（結果）**
- **どんな影響を与えるのか？（副作用）**
- **どんな状態か？（状態）**

![](https://storage.googleapis.com/zenn-user-upload/496c87456bd6-20250509.png =550x)

## 結果の Assert

テスト対象メソッドが返す値を Assert します。

![](https://storage.googleapis.com/zenn-user-upload/2969b3e428bf-20250509.png =550x)

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

### 前提条件

結果を Assert する場合、テスト対象が次の条件を満たす必要があります。

- **副作用を引き起こさない**

## 状態の Assert

テスト対象の内部状態の変化を検証するテストです。
ただし、これは公開されているプロパティやメソッドを通じて観察可能な状態に限ります。

![](https://storage.googleapis.com/zenn-user-upload/00626861806d-20250509.png =550x)

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

## 副作用の Assert

テスト対象が外部に及ぼす影響（副作用）を検証するテストです。
例えば、メール送信、データベース更新、ファイル出力などの処理が正しく行われたかを確認します。

副作用の多くは共有依存とのコミュニケーションを通じて発生するため、モックを用いた Assert となります。

![](https://storage.googleapis.com/zenn-user-upload/6fac19191d9c-20250509.png =550x)

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

このテストでは「本を開く」「ページを進める」などの操作後の**状態**を検証しています。
内部変数の実装詳細ではなく、公開 API を通じて観察可能な状態（現在のページ番号、本が開いているかなど）だけをテストしています。

## どれが一番良いのか？

「価値の高い単体テストを構成する 4 本の柱」を評価指標として比較すれば、おのずと答えは見えます。

- リグレッションに対する保護
- リファクタリングへの耐性
- 迅速なフィードバック
- 保守のしやすさ

### 「リグレッションに対する保護」で比較

「リグレッションに対する保護」は次の３点を備える必要がありました。

- カバレッジ
- プロダクションコードの複雑さ
- ドメインにおける重要性

「プロダクションコードの複雑さ」と「ドメインにおける重要性」においては、Assert 手法とは無関係です。

ただし、**カバレッジは影響します。**

副作用の Assert を行うと、カバレッジが低くなる可能性があります。
副作用の Assert はモックを使用するため、使いすぎると検証されるプロダクションコードの量が少なくなってしまうからです。

結果として、「リグレッションに対する保護」が備わりにくくなるのです。

:::message

**副作用の Assert はモックの使いすぎに注意。**

:::

### 「迅速なフィードバック」で比較

基本的には、プロセス外依存をそのまま扱わない限り、どの Assert 手法を用いても差はありません。

### 「リファクタリングへの耐性」で比較

比較観点としては、**偽陽性を招くか？ = 実装方法への依存度**になります。

偽陽性は Assert 手法によってかなり差が出ます。

![](https://storage.googleapis.com/zenn-user-upload/1d8be5a463f8-20250509.png =550x)

#### 出力の Assert

実装方法への依存度が最も低いです。
なぜなら、テストが見るのはテスト対象メソッドだけだからです。

#### 状態の Assert

出力の Assert に比べ、依存度が少し高くなります。
なぜなら、テスト対象メソッドに加え、メソッド実行によって変更されたプロパティ等の値も見る必要があるからです。
単純にプロダクションコードに依存する数が増えます。

#### 副作用の Assert

依存度が最も高くなります。
副作用の Assert では、テスト対象メソッドが依存コンポーネントとのコミュニケーションを検証します。

これはモックを使って「どのメソッドが呼ばれたか」「どんな引数で呼ばれたか」を確認することが一般的です。
つまり、単なる「何が返されるか」や「状態がどう変わるか」ではなく、「どのように処理が行われるか」という実装の詳細に踏み込むことになります。
実装の詳細に踏み込めば実装方法への依存度は高くなるため、偽陽性が高まります。

:::message
**🤔 あれ、副作用は「振る舞い」ではなかったっけ？**
\
実は、副作用は「観察可能な振る舞い」の一種でありながら、同時に「実装の詳細」の側面も持ち合わせています。

**「観察可能な振る舞い」or「実装の詳細」は、クライアントの目標によって決まる**もので、かなり不安定なのです。
実装当初は「振る舞い」であったとしても、来週には「実装の詳細」になっている...なんてこともあるでしょう。

よって、副作用の Assert を頻繁に使用することは避けるべきです。
:::

:::details 使うとしてもなるべく実装の詳細から遠ざける工夫が必要

1. **検証範囲を絞る**

   ```typescript
   // 悪い例（過度に詳細）
   expect(mockEmailService.sendWelcomeEmail).toHaveBeenCalledWith(
     "test@example.com",
     "Welcome!"
   );

   // 良い例（必要最小限）
   expect(mockEmailService.sendWelcomeEmail).toHaveBeenCalled();
   ```

2. **インターフェースに対するテスト**

   ```typescript
   // 実装よりもインターフェースに対してテスト
   expect(mockNotificationService.notify).toHaveBeenCalled();
   // 具体的な通知手段（メール、SMS等）に依存しない
   ```

:::

### 「保守のしやすさ」で比較

「保守のしやすさ」は次の観点で決まるのでした。

1. **テストケースの理解容易性**
   - テストケースのサイズによって容易性が変動する
   - テストコードの量が小さい程、理解しやすい
2. **テスト実装の難易度**
   - テストダブルの多用はテストの難易度を上げる

よって、評価指標は次の２つとなります。

- **テストコードの量**
- **テストダブルの使用度**

こちらも、Assert 手法によって差が出ます。
![](https://storage.googleapis.com/zenn-user-upload/1d8be5a463f8-20250509.png =550x)

#### 出力の Assert

最も保守コストが低い手法です。

1. **テストコードの量**
   テスト対象メソッドの返却値を検証するだけなので Assert フェーズは基本１行で完結します。
2. **テストダブルの使用度**
   前提条件として、出力の Assert を行うためにはテスト対象は純粋関数である必要があります。
   そのためテスト対象メソッドには副作用が含まれず、テストダブルの利用は 0 となるはずです。

#### 状態の Assert

テストコード量の観点から出力の Assert に劣ります。

1. **テストケースの理解用意性**
   状態を Assert する場合、コード量は検証したいテスト対象の状態数に比例します。

   ```java
    @Test
   public void 本を開くと最初のページが表示される() {
    // Arrange
    EbookReader reader = new EbookReader();
    Book book = new Book("プログラミング入門", 200);

    // Act
    reader.openBook(book);

    // Assert
    assertEquals(0, reader.getCurrentPage()); // 状態①
    assertTrue(reader.isBookOpen()); // 状態②
    assertEquals(book, reader.getCurrentBook()); // 状態③
   }
   ```

#### 副作用の Assert

最も保守コストが高い手法です。

1. **テストダブルの使用度**
   `副作用をAssertする` = `モックを検証する` なので、テストダブルの使用度は高くなります。
2. **テストコードの量**
   Arrange フェーズにてモックの作成が必要となるため、コード量が多くなります。

### 結論

各 Assert 手法を「価値の高い単体テストを構成する 4 本の柱」で比較した結果を以下の表にまとめます。

| Assert 手法     | リグレッションに対する保護 | リファクタリングへの耐性 | 迅速なフィードバック | 保守のしやすさ |
| :-------------- | :------------------------: | :----------------------: | :------------------: | :------------: |
| 結果の Assert   |             ◯              |            ◯             |          ◯           |       ◯        |
| 状態の Assert   |             ◯              |            △             |          ◯           |       △        |
| 副作用の Assert |             △              |            ✕             |          ◯           |       ✕        |

この結果から、可能な限り**結果の Assert**を優先的に使用することが推奨されます。
