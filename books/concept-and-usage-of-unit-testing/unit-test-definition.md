---
title: "単体テストの定義"
---

## 単体テストとは？

単体テストとは以下の 3 つを備えたテストのことです。

1. **「単体（unit）」と呼ばれる少量のコードを検証する**
2. **実行時間が短い**
3. **隔離された状態で実行される**

上記が定義になるのですが、次の要素が気になるでしょう。

- 「単体」とは何を指すのだろう？
- 「隔離」ってどういうこと？何から何を隔離するの？

## 隔離された状態で実行される

まずは「隔離」について見ていきましょう。

「隔離された状態で実行される」をもう少し噛み砕いた表現にすると以下になります。

- **テスト対象（クラスや関数）**が**依存コンポーネント**の影響を受けずにテストされる

「何から何を隔離するの？」に対する解としては「**テスト対象**から**依存コンポーネント**を隔離する」となります。

:::details 「コンポーネント」とは？
ここでいう「コンポーネント」とは、ソフトウェアの構成要素を指しており、具体的には以下のようなものが含まれます。

- クラスや関数
- モジュール
- 外部ライブラリやフレームワーク
- API やデータベース

:::

単体テストにおいて、「**依存をどう捉え、どのように隔離するか？**」は非常に重要です。

### 依存とは？

ソフトウェア開発において、ほとんどのコードは他のコンポーネントに依存して動作しています。
![](https://storage.googleapis.com/zenn-user-upload/47ae479d2419-20241205.png =400x)
テスト対象のコードが他のコンポーネントに依存している場合、その依存関係が正しく動作しないとテスト結果に影響を及ぼします。

### 依存の種類

一口に「依存」と言っても様々な観点があり、それぞれテスト対象に与える影響が異なります。

#### ① 共有依存

**テストケース間**で共有される依存です。
グローバルな設定ファイル、共有キャッシュ、静的なシングルトンオブジェクトなどが該当します。

もし共有依存を持つ複数のテストケースが同時に実行されると、**テスト間で副作用が発生しやすいです**。
例えば、複数のテストが同じキャッシュにアクセスしたり、設定ファイルを書き換えたりする場合、一つのテストが他のテストに影響を及ぼしてしまいます。

**テスト対象に共有依存が存在すると、検証結果が不安定になります。**

#### ② プライベート依存

**テストケース間**で共有されない依存です。
各テストケースが独立したコンポーネントを使用します。
プライベート依存には、さらに次の 2 種類に分類できます。

:::details ① 可変依存
状態の変更が可能な依存コンポーネントを指します。
オブジェクトの内部状態が操作や外部からの影響によって変わる場合、この依存は可変とみなされます。

次の `UserSession` クラスは可変性があるオブジェクトです。

```java
public class UserSession {
 private String userId;
 private boolean loggedIn;

 public UserSession(String userId) {
     this.userId = userId;
     this.loggedIn = false; // 初期状態ではログインしていない
 }

 // ユーザーIDを取得
 public String getUserId() {
     return userId;
 }

 // ログイン状態を取得
 public boolean isLoggedIn() {
     return loggedIn;
 }

 // ログイン状態を変更
 public void logIn() {
     this.loggedIn = true;
 }

 // ログアウト状態に変更
 public void logOut() {
     this.loggedIn = false;
 }
}
```

`loggedIn` フィールドの状態は `logIn()` 及び `logout()` メソッドによって変更可能です。

そのため、テスト対象コンポーネントが UserSession に依存している場合、内部状態によって振る舞いが変化し、検証結果に影響します。

:::

:::details ② 不変依存
初期化後、状態が一切変化しない依存コンポーネントです。

```java
import java.util.Collections;
import java.util.Map;

public class StaticConfig {
private final Map<String, String> settings;

    public StaticConfig() {
        settings = Map.of(
            "mode", "test",
            "version", "1.0.0"
        );
    }

    public String get(String key) {
        return settings.get(key);
    }

}
```

一度インスタンス化したら、その状態を変えることはできません。
`settings` フィールドの値も不変であり、外部から変更できません。

そのため、テスト対象コンポーネントが `StaticConfig` に依存していても、内部状態に左右されることなくテスト結果が一貫します。
:::

#### ③ プロセス外依存

テスト対象とは別のプロセスで動作する外部コンポーネントへの依存です。
DB、外部 API、メッセージキューなどが該当します。

プロセス外依存は通常、ネットワークや外部プロセスを介して通信するため、テストの際にネットワークの遅延や外部システムの状態に依存することがあります。
そのため、**テストの実行速度が遅くなる**可能性があります。

:::message
**プロセス外依存は共有依存？プライベート依存？**
\
ケースバイケースです。

DB はプロセス外依存であり、共有依存でもあります。
しかし、「各テストケースが同じ DB に依存している」というケースであればの話です。

もし、各テストケースを異なる Docker コンテナ上で実行させ、各コンテナ内に DB を用意したらどうなるでしょうか？
依存先が DB なので「プロセス外依存」であることには変わりません。
ただ、各テストケースは別の DB を使用しているため、「共有依存」ではなく「プライベート依存」です。

同様に、「読み込み専用の DB」も共有依存にはなりません。
なぜなら、読み込み専用であるため、あるテストケースが他のテストケースに影響していないからです。
:::

### 隔離とは？

依存の種類とテスト対象に与える影響についてお話しました。
単体テストでは、これらの依存をテスト対象から隔離することが重要になります。
それが質の高いテストを作ることに繋がるからです。

テスト対象から隔離する」とは具体的に何をするのでしょうか？
↓↓↓
依存コンポーネントを**テストダブル**に置き換えます。

テストダブルとは、**依存コンポーネントの代わりを務めるコンポーネント**のことです。
名前の通り、テスト時に「影武者」のような役割を果たします。
テストダブルにより、依存コンポーネントがテストに与える影響を排除し、テスト対象コードそのものの振る舞いを純粋に確認できるようになるのです。
![](https://storage.googleapis.com/zenn-user-upload/c376663c9591-20241208.png)

\
テストダブルにはいくつかの種類が存在し、用途によって適切なものを選択します。

:::details ① スタブ（Stub）
**依存先が返すデータを固定値にする**ためのテストダブルです。
テスト対象が期待するデータを簡単に準備できます。

\
**使用ケース :**
依存先の複雑なロジックを避けて、シンプルなデータを返したいとき。

\
**例 :**

```ts
const stubUserRepository = {
  find: (id: string) => ({ id, name: "Test User" }),
};

const result = stubUserRepository.find("123");
expect(result).toEqual({ id: "123", name: "Test User" });
```

- `stubUserRepository.find` は、常に `{ id: "123", name: "Test User" }` を返すようにスタブ化されています
- 実際のデータベースを使わずに、固定値を返すスタブを利用することで、外部依存を排除しています

:::

:::details ② モック（Mock）
**テスト対象が依存先をどう使ったか**を検証するためのテストダブルです。
「依存先のメソッドが呼び出されたか」「どんなデータを引数に渡したか」等を確認できます。
\
**使用ケース :**
テストケースが依存コンポーネントを「正しいデータで呼び出したか」を確認したいとき

\
**例 :**

```ts
const mockApiClient = {
  get: jest.fn().mockResolvedValue({ data: { name: "Alice" } }),
};

const userService = new UserService(mockApiClient);
await userService.fetchUser("123");

// API が正しい URL で呼び出されたかを確認
expect(mockApiClient.get).toHaveBeenCalledWith("/users/123");
```

- `jest.fn()`： Jest のモック関数を作成します。この関数は呼び出し履歴を記録し、検証可能です。
- `mockResolvedValue`： モック関数が Promise を返す場合、その返り値を指定します。この例では、`mockApiClient.get` を呼び出すと、常に `{ data: { name: "Alice" } }` が返ります。
- `toHaveBeenCalledWith`： モック関数が指定の引数で呼び出されたかを確認します。ここでは、`/users/123` という URL が正しく渡されたことをテストしています。

:::

:::details ③ スパイ（Spy）
**依存先のメソッドをそのまま使用しつつ、呼び出し履歴を記録する**テストダブルです。
モックのように完全に置き換えるのではなく、実際の処理を行いながら、その呼び出し状況を監視できます。

\
**使用ケース :**
実際の依存先の動作を維持しつつ、「正しい引数で呼び出されたか」や「呼び出し回数」を確認したいとき。

\
**例 :**

```ts
const spyLogger = jest.spyOn(console, "log");

console.log("Test message");

// console.log が呼び出されたか確認
expect(spyLogger).toHaveBeenCalledWith("Test message");
```

- `jest.spyOn`： 対象オブジェクトのメソッドをスパイ化します。この例では、`console.log` の呼び出し履歴を記録しています。
- スパイ化された console.log は、通常通りメッセージを出力しますが、どのような引数で呼び出されたかを確認できます

:::

:::details ④ フェイク（Fake）
**依存コンポーネントを簡易的に実装したもの**です。
実際の依存先と似た動きをしますが、軽量化されています。
\
**使用ケース :**
依存コンポーネントが本物だと準備が大変で、簡単な代替を用意したいとき。

\
**例 :**

```ts
const inMemoryDb: any[] = [];
const fakeDb = {
  insert: (item: any) => inMemoryDb.push(item),
  find: (predicate: (item: any) => boolean) => inMemoryDb.find(predicate),
};

fakeDb.insert({ id: "1", name: "Laptop" });
const result = fakeDb.find((item) => item.id === "1");
expect(result).toEqual({ id: "1", name: "Laptop" });
```

- `fakeDb` は実際のデータベースの代わりに、配列を使った簡易的なデータ管理を行っています
- データベースのセットアップやクリーンアップが不要なため、テストが軽量で高速になります

:::

:::details ⑤ ダミー（Dummy）
**とりあえず必要だから用意するだけ**のテストダブルです。
テストには使われないこともあります。
\
 **使用ケース :**
テスト対象が依存を必要とするが、その依存自体はテストで重要ではない場合。

\
**例 :**

```ts
const dummyDependency = {}; // 空オブジェクトを渡すだけ
const service = new SomeService(dummyDependency);

expect(service.doSomething()).toBe(true);
```

- `dummyDependency` は、`SomeService` のコンストラクタに渡すためだけのダミーオブジェクトです
- 実際にはテストには影響を与えないため、シンプルに空オブジェクトを使っています

:::

### どの依存を隔離するのか？

テストダブルによって依存コンポーネントを隔離することをお話しました。
「隔離された状態で実行される」の意味が何となく分かってきたのではないでしょうか？

しかし、ここで次のような疑問が浮かぶかもしれません。

- 「すべての依存を隔離するべきなのか？」
- 「どの依存を隔離し、どの依存をそのまま使うべきなのか？」

「どの依存を隔離するか」というテーマにおいて、2 つの代表的なアプローチが存在します。
それが「**ロンドン学派**」と「**古典学派**」です。

:::message

実際、この疑問に対する明確な正解はありません。
どの依存を隔離するかは、プロジェクトの特性やテストの目的によって異なります。
そして、この考え方は個人やチームによっても違いがあります。

:::

### ロンドン学派

ロンドン学派は、**依存コンポーネントを徹底的に隔離する**という考えです。
ほぼすべての依存をテストダブルで置き換えます。
![](https://storage.googleapis.com/zenn-user-upload/8b5a03da6269-20241214.png)

:::message
**例外としての不変依存**
ロンドン学派では、原則すべての依存を隔離しますが、「不変依存」は例外とされ、そのまま使用します。
![](https://storage.googleapis.com/zenn-user-upload/ff85c435b28b-20241214.png)

**理由:**

1. **テスト結果に影響しない**
   不変依存は状態が変わらず、テスト結果に影響を与えないため、そのまま使用しても特に問題がありません。
2. **テストダブル化により複雑になる**
   逆に複雑さが増すかもしれません。
   その結果、テストの保守性が低下する可能性があります。

:::

### 古典学派

古典学派は、**共有依存のみを隔離する**という考えです。
他の依存コンポーネントは隔離せず、そのまま使用してテストします。
![](https://storage.googleapis.com/zenn-user-upload/0bc7657048b4-20241214.png)

:::message
**🤔 なぜ共有依存だけ？**

1. **古典学派は「テストケースを隔離する」という考えだから**
   `共有依存` = `テストケース間で共有する依存` なので、共有依存のみテストダブルにすれば良いということになります。
2. **テストの実行速度を上げるため**
   単体テストが備えるべき特徴の１つとして「実行時間が短い」があります。
   共有依存の多くはプロセス外依存になります。
   そのため、共有依存をテストダブルに置き換えることで、短い実行時間を満たしているのです。
3. **並列に実行できるから**
   テストケースが独立していれば、同時に実行しても検証結果に影響はありません。
4. **実行順序が関係なくなる**
   テストケースが独立していれば、実行順序を考慮しなくて良くなります。

:::

### ロンドン学派と古典学派の「隔離」の違い

| 派閥         | 隔離対象       | テスト・ダブルの置き換え対象 |
| ------------ | -------------- | ---------------------------- |
| ロンドン学派 | コンポーネント | 不変依存を除くすべての依存   |
| 古典学派     | テストケース   | 共有依存                     |

## 「単体」の意味

次は「単体」の意味について見ていきましょう。

その前に再度、単体テストの定義を確認してみます。

1. **「単体（Unit）」と呼ばれる少量のコードを検証する**
2. **実行時間が短い**
3. **隔離された状態で実行される**

「隔離」の意味は理解できました。
ロンドン学派と古典学派で捉え方の違いがあるため、定義も異なります。

「単体（Unit）」はどうでしょうか？
この言葉も曖昧であり、捉え方が異なりそうです。

### ロンドン学派の「単体」

- 「単体」= 「コンポーネント」

### 古典学派の「単体」

古典学派における「単体」の単位は「**振る舞い**」です。

テスト対象の「振る舞い」をテストします。

### 「振る舞い」とは何か？

この言葉に補足を入れると、
「**（クライアントから観察可能な）振る舞い**」となります。

:::message

**「クライアント」って何？**
\
テスト対象を利用するコンポーネントのことです。

- コード（テストコードも含む）
- 外部アプリケーション
- UI

:::

そのため「振る舞い」とは
「**クライアントが自身の目標を達成するために、テスト対象が提供する観察可能な機能**」
を指します。

クライアントには何かしらの目標があり、達成のためにテスト対象を利用します。
例えば次のような目標です：

- ユーザー情報を取得したい
- 商品を購入したい

テスト対象はこのような目標達成を可能にするための機能を提供します。

![](https://storage.googleapis.com/zenn-user-upload/a10e93b1255a-20250509.png =550x)

上記では少し抽象的なのでより具体的に示すと、「振る舞い」は次の２つに分類されます。

1. **操作（Operations）**：クライアントが呼び出すメソッド
   - **結果**を返すメソッド（例：`getUser()`）
   - **副作用**を引き起こすメソッド（例：`sendEmail()`）
2. **状態（State）**：クライアントが参照する状態
   - 公開されたプロパティ（例： `user.name`）
   - 状態を返すメソッド（例：`is:LoggedIn()`）

\
そのため「振る舞いをテストする」というのは、次の要素を検証（Assert）するということを指します。

- **どんな値を返すか？（結果）**
- **どんな影響を与えるのか？（副作用）**
- **どんな状態か？（状態）**

![](https://storage.googleapis.com/zenn-user-upload/496c87456bd6-20250509.png =550x)

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

## 古典学派 vs ロンドン学派

### なぜロンドン学派ではダメなのか？

以下はロンドン学派のメリットです。
しかしこれらは、単体テストの目的である「プロジェクトの持続的な成長を促す」という観点で考えると、反論の余地が存在します。

1. **依存関係が複雑でも簡単にテスト可能**
   依存関係が複雑に絡み合うクラスをテストするのは手間がかかるし、検証結果が不安定になります。
   しかし、すべての依存をテストダブルに置き換えれば、シンプルにテストできます。

   :::message
   **🤔 反論**

   - 「複雑なクラスを上手くテストする」ことが単体テストの目的ではない
   - 「ソフトウェアの成長を持続可能にするため」が単体テストの目的
   - 「依存関係が複雑に絡み合うクラス」はソフトウェアの持続可能な成長を妨げる要因であるため、テスト対象コードの見直しをすべき
   - テスト手法の工夫を行なっても根本的な解決にならない

   :::

2. **テスト失敗時の原因特定が簡単**
   すべての依存をテストダブルに置き換えることで、テスト失敗時の原因がテスト対象クラス内に限定され、デバッグが用意になります。

   :::message
   **🤔 反論**

   - 頻繁に実行していれば、テストに失敗した場合、変更したコードが原因であるため確認すべきスコープは明確

   :::

3. **テスト対象コードの意図が明確になる**
   依存コンポーネントをすべて排除することで、1 テストケース : 1 コンポーネント とすることが出来ます。
   そのため、責務分離によってテストケースの作成がしやすくなり、テスト全体もシンプルな構造となります。
   ![](https://storage.googleapis.com/zenn-user-upload/a49a2b10181c-20241204.png =500x)
   _テストクラスとプロダクションコードのクラスを 1:1 にする_

   :::message
   **🤔 反論**

   - 「単体」の単位は「振る舞い」であるべき
   - 振る舞いが 1 クラスで収まらない場合もある
   - 「振る舞いをテストする」という考え方の場合、ロンドン学派は合わない可能性が高い

   :::

## 古典学派の考える単体テストの定義

1. **1 単位の振る舞いを検証すること**
2. **実行時間が短いこと**
3. **他のテストケースから隔離して実行されること**
