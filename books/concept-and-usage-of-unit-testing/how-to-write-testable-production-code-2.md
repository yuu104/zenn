---
title: "テスタブルなプロダクションコードの設計②"
---

## 単体テストの理想と現実のジレンマ

以前の分析から、「結果の Assert」が最も価値の高いテスト手法であることが分かりました。
テスト対象の内部実装ではなく最終的な出力だけを検証するため、リファクタリングへの耐性が高く、保守もしやすいからです。

しかし、実際のアプリケーションには必ず「副作用」が存在します。
DB へのアクセス、外部 API の呼び出し、ファイル操作、メール送信など、これらはすべて副作用です。

副作用が混在したコードでは、「結果の Assert だけでテスト対象の振る舞いを正確に検証することが難しい」という問題が生じます。
例えば、ユーザー登録機能をテストする場合、単にユーザーオブジェクトが正しく作成されたかだけでなく、DB に保存されたか、確認メールが送信されたかなど、副作用も検証する必要があります。

かといって、副作用の Assert を多用することは避けたいところです。偽陽性を招きやすく、リファクタリングへの耐性が低くなるためです。

この「結果の Assert が望ましいが、副作用の検証も必要」というジレンマを解決するためには、どうすればよいのでしょうか？
→ **プロダクションコードの設計自体を見直すのです。**

## どうすれば副作用に振り回されないコードになるのか？

副作用問題を解決するための鍵は、次の 2 つを明確に分離することにあります。

- **ビジネスロジック**（決定を下すコード）
- **副作用**（決定に基づくアクションを実行するコード）

### ビジネスロジックと副作用の違い

ビジネスロジックとは...
**入力データをビジネスルールに従って判断し、何らかの決定を出力するコード**です。

例えば：

- ユーザー入力の検証（メールアドレスの形式チェック、パスワード強度の評価など）
- 料金の計算（割引適用、税金計算など）
- 割引条件の判定（特定の条件を満たすかどうかの判断）
- ビジネスルールのチェック（在庫の確認、与信判断など）

\
一方、副作用とは...
**外部の状態を変更する操作や、外部状態に依存する操作**です。

例えば：

- データベースへの書き込み/読み取り
- 外部 API の呼び出し
- ファイルの入出力
- メールの送信
- ログの記録

### 純粋関数 ~テスト容易性の鍵~

ビジネスロジックと副作用を分離する際に中心となる概念が「純粋関数」です。
次の特性を持ちます：

1. **同じ入力に対し常に同じ出力を返す**（参照透過性）
2. **副作用がない**（外部状態を変更しない）
3. **外部状態に依存しない**

```typescript
// 純粋関数の例
function sum(a: number, b: number): number {
  return a + b;
}

// 非純粋関数の例（外部状態に依存）
function getCurrentUserName(): string {
  return this.currentUser.name; // 外部の変数に依存
}

// 非純粋関数の例（副作用あり）
function saveToDatabase(user: User): void {
  this.database.save(user); // 外部の状態を変更
}
```

純粋関数の最大の利点は、テストが容易なことです。
入力を与えて出力を検証するだけで、振る舞いを完全に検証できます。
外部との依存関係がないため、テストダブル（モックやスタブ）を用意する必要もありません。

```typescript
// 純粋関数のテスト例
test("sum関数は2つの数値を足し合わせる", () => {
  // Arrange & Act
  const result = sum(2, 3);

  // Assert
  expect(result).toBe(5);
});
```

:::message
**つまり...**

ビジネスロジックを純粋関数として実装することで、「結果の Assert」による高品質なテストが自然と実現します。

**重要度が高い**プロダクションコードに対し、**質の高い**テストを実施することができるのです。
:::

### なぜ分離が重要なのか

通常のアプリケーションでは、ビジネスロジックと副作用が密接に絡み合っています。

ユーザー登録処理を例にすると：

「バリデーション → 重複チェック（DB）→ ユーザー作成 → DB 保存 → 確認メール送信」

といった流れで、ビジネスロジックと副作用が混在しています。

この混在が、テストを難しくしている大きな要因です。
同じメソッド内にあると、「結果の Assert」だけでは不十分となり、テストの質が下がってしまいます。

ビジネスロジックと副作用を明確に分離することで、以下のメリットが得られます：

1. **ビジネスロジックを純粋関数として実装できる**

   - 外部状態に依存せず、外部状態も変更しない
   - 「結果の Assert」でテスト可能になる
   - **重要度が高い**プロダクションコードに対し、**質の高い**テストが可能

2. **副作用を含む処理を明示的に扱える**

   - どこで副作用が発生するかが明確になる
   - テスト戦略を分けて考えられる

3. **コードの責務が明確になる**
   - 「何を決めるか」と「どう実行するか」が分離される
   - 各コンポーネントの役割が明確になる

この分離を実現するための設計手法として、**関数型アーキテクチャ**が効果的です。

## 関数型アーキテクチャ ~ビジネスロジックと副作用を分離する~

関数型アーキテクチャは、ビジネスロジックと副作用を分離するための設計手法です。
名前に「関数型」とありますが、必ずしも関数型言語（Haskell、F#など）を使う必要はなく、オブジェクト指向言語（Java、TypeScript など）でも適用可能な考え方です。

### 関数型アーキテクチャの本質

関数型アーキテクチャの本質は「ビジネスロジック」と「副作用」を明確に分けることで、責務と関心を分離することにあります。

具体的な方法としては：

- **ビジネスロジック**（決定を下すコード）を中心に置き、純粋関数として実装する
- **副作用**（決定に基づくアクションを実行するコード）をアプリケーションの境界部分に押し出す
- 純粋なビジネスロジックと副作用の間の調整役となるコンポーネントを設ける

典型的なアプリケーションの流れは以下のようになります。

1. 入力（リクエスト、コマンドなど）を受け取る
2. 必要に応じて事前の副作用を実行
   - ex.）DB から現在の状態を読み取る
3. 純粋関数としてビジネスロジックを実行し、決定を下す
4. ビジネスロジックの結果に基づいて、副作用を実行する
   - ex.）DB に保存、メール送信

通常、アプリケーションはレイヤーアーキテクチャとして実装されます：

- **ドメイン層**：ビジネスルールやエンティティの振る舞いを表現（純粋関数として実装）
- **ユースケース層**：ドメイン層の純粋関数と副作用を持つインフラストラクチャ層を連携する調整役
- **インフラストラクチャ層**：副作用を含む実装（DB アクセス、外部 API 呼び出し、メール送信など）

しかし、関数型アーキテクチャの本質は特定のレイヤー構造ではなく、「ビジネスロジック（純粋関数）」と「副作用」の分離にあることを理解することが重要です。

### 実装パターン：入力 → 純粋計算 → 副作用

関数型アーキテクチャを実現するための基本的な実装パターンを見ていきましょう。

#### 基本フロー

基本的なフローは「入力の読み取り → 純粋な計算（ビジネスロジック） → 副作用の実行」という流れになります。

```typescript
// 基本的な関数型アーキテクチャのフロー
function processOrder(orderId: string) {
  // 1. 入力の読み取り / 事前の副作用
  const order = this.orderRepository.findById(orderId);
  const inventory = this.inventoryRepository.getInventory();

  // 2. 純粋な計算（ビジネスロジック）
  const orderResult = this.processOrderLogic(order, inventory);

  // 3. 事後の副作用
  if (orderResult.isSuccess) {
    this.inventoryRepository.updateInventory(orderResult.updatedInventory);
    this.paymentService.processPayment(order.paymentDetails);
    this.emailService.sendOrderConfirmation(order);
  } else {
    this.emailService.sendOrderFailureNotification(order, orderResult.error);
  }

  return orderResult;
}

// 純粋関数としてのビジネスロジック
function processOrderLogic(order: Order, inventory: Inventory): OrderResult {
  // ビジネスルールに基づいた計算
  if (!this.isValidOrder(order)) {
    return OrderResult.failure("Invalid order");
  }

  if (!this.hasEnoughInventory(inventory, order)) {
    return OrderResult.failure("Not enough inventory");
  }

  const updatedInventory = this.calculateUpdatedInventory(inventory, order);
  return OrderResult.success(updatedInventory);
}
```

#### 結果型による成功/失敗の表現

純粋関数は例外をスローすべきではありません。
**例外は副作用として捉えることができるからです。**

代わりに、結果型（`Result<T>` など）を使って成功/失敗を表現します。

```typescript
// 結果型の例
class Result<T> {
  private constructor(
    private readonly _value: T | null,
    private readonly _error: string | null,
    private readonly _isSuccess: boolean
  ) {}

  public static success<T>(value: T): Result<T> {
    return new Result(value, null, true);
  }

  public static failure<T>(error: string): Result<T> {
    return new Result(null, error, false);
  }

  public get isSuccess(): boolean {
    return this._isSuccess;
  }

  public get value(): T {
    if (!this._isSuccess) {
      throw new Error("Cannot get value from failure result");
    }
    return this._value as T;
  }

  public get error(): string {
    if (this._isSuccess) {
      throw new Error("Cannot get error from success result");
    }
    return this._error as string;
  }
}

// 使用例
function divide(a: number, b: number): Result<number> {
  if (b === 0) {
    return Result.failure("Division by zero");
  }
  return Result.success(a / b);
}

// 呼び出し側
const result = divide(10, 2);
if (result.isSuccess) {
  console.log(`Result: ${result.value}`);
} else {
  console.log(`Error: ${result.error}`);
}
```

このパターンを使うことで、例外に頼らずに純粋関数で成功/失敗を表現できます。
呼び出し側は必ず結果のチェックを行う必要があるため、エラーハンドリングが漏れにくくなるという利点もあります。

### 【具体例】ユーザー登録機能のリファクタリング

具体的なユーザー登録のフローを例に、関数型アーキテクチャの適用前と適用後を比較してみましょう。

#### Before: 副作用混在型の実装

```typescript
// 副作用とビジネスロジックが混在した実装
class UserService {
  private readonly database: Database;
  private readonly emailSender: EmailService;

  constructor(database: Database, emailSender: EmailService) {
    this.database = database;
    this.emailSender = emailSender;
  }

  public async registerUser(email: string, password: string): Promise<User> {
    // 入力検証（ビジネスロジック）
    if (!this.isValidEmail(email)) {
      throw new Error("Invalid email format");
    }

    if (password.length < 8) {
      throw new Error("Password too short");
    }

    // 重複チェック（副作用）
    const existingUser = await this.database.findUserByEmail(email);
    if (existingUser) {
      throw new Error("User already exists");
    }

    // パスワードハッシュ化（ビジネスロジック）
    const hashedPassword = this.hashPassword(password);

    // ユーザー作成（ビジネスロジック + 副作用）
    const user = new User(email, hashedPassword);
    await this.database.saveUser(user);

    // 確認メール送信（副作用）
    await this.emailSender.sendWelcomeEmail(email);

    return user;
  }

  private isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  private hashPassword(password: string): string {
    // パスワードハッシュ化ロジック
    return "hashed_" + password; // 簡略化
  }
}
```

`UserService` の公開 API である `registerUser()` では、ビジネスロジック（メールアドレスの検証、パスワード検証、ハッシュ化）と副作用（DB 操作、メール送信）が混在しています。

`registerUser()` を単体テストする場合、「結果の Assert」だけでテストすることが難しく、モックを多用したテストが必要になります。

#### After: 関数型アーキテクチャを適用した実装

```typescript
// ドメイン層（純粋関数）
class UserRegistrationDomain {
  public static validateRegistration(
    email: string,
    password: string
  ): Result<void> {
    if (!UserRegistrationDomain.isValidEmail(email)) {
      return Result.failure("Invalid email format");
    }

    if (password.length < 8) {
      return Result.failure("Password too short");
    }

    return Result.success(void 0);
  }

  private static isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  public static hashPassword(password: string): string {
    // パスワードハッシュ化ロジック
    return "hashed_" + password; // 簡略化
  }

  public static createUser(email: string, hashedPassword: string): User {
    return new User(email, hashedPassword);
  }
}

// ユースケース層（調整役）
class UserRegistrationUseCase {
  private readonly userRepository: UserRepository;
  private readonly emailService: EmailService;

  constructor(userRepository: UserRepository, emailService: EmailService) {
    this.userRepository = userRepository;
    this.emailService = emailService;
  }

  public async execute(email: string, password: string): Promise<Result<User>> {
    // 1. 事前の副作用（ユーザー存在確認）
    const existingUser = await this.userRepository.findByEmail(email);
    if (existingUser) {
      return Result.failure("User already exists");
    }

    // 2. ビジネスロジック（純粋関数）
    const validationResult = UserRegistrationDomain.validateRegistration(
      email,
      password
    );
    if (validationResult.isFailure) {
      return Result.failure(validationResult.error);
    }
    const hashedPassword = UserRegistrationDomain.hashPassword(password);
    const user = UserRegistrationDomain.createUser(email, hashedPassword);

    // 3. 事後の副作用（保存と通知）
    await this.userRepository.save(user);
    await this.emailService.sendWelcomeEmail(email);

    return Result.success(user);
  }
}

// インフラストラクチャ層のインターフェース（副作用）
interface UserRepository {
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<void>;
}

interface EmailService {
  sendWelcomeEmail(email: string): Promise<void>;
}
```

この改善版では：

1. **ドメイン層**（`UserRegistrationDomain`）：純粋関数としてビジネスロジックを実装

   - 入力検証、パスワードハッシュ化、ユーザー作成などの純粋な処理
   - 外部状態に依存せず、副作用もない
   - 「結果の Assert」でテスト可能

2. **ユースケース層**（`UserRegistrationUseCase`）：ドメインロジックと副作用の調整役

   - 全体の流れを制御
   - 副作用（リポジトリやサービス）の呼び出し
   - ドメインロジックの実行
   - 結果の返却

3. **インフラストラクチャ層**（`UserRepository`, `EmailService`）：副作用を含む実装のインターフェース
   - データベースアクセス、メール送信などの副作用を担当
   - インターフェースとして定義され、実装は詳細として扱われる

このように分離することで、ドメイン層（純粋関数）は「結果の Assert」による高品質なテストが可能になります。また、ユースケース層もビジネスロジックと副作用が明確に分離されているため、テストが書きやすくなります。

## 実践的なテスト戦略

関数型アーキテクチャを適用したコードに対するテスト戦略を考えてみましょう。

### ドメイン層のテスト（結果の Assert）

ドメイン層は純粋関数なので、「結果の Assert」による高品質なテストが可能です。

```typescript
// ドメイン層のテスト
describe("UserRegistrationDomain", () => {
  describe("isValidEmail", () => {
    test("有効なメールアドレスを検証できる", () => {
      // Arrange & Act
      const result = UserRegistrationDomain.isValidEmail("user@example.com");

      // Assert
      expect(result).toBe(true);
    });

    test("無効なメールアドレスを検証できる", () => {
      // Arrange & Act
      const result1 = UserRegistrationDomain.isValidEmail("invalid");
      const result2 = UserRegistrationDomain.isValidEmail("invalid@");
      const result3 = UserRegistrationDomain.isValidEmail("@example.com");

      // Assert
      expect(result1).toBe(false);
      expect(result2).toBe(false);
      expect(result3).toBe(false);
    });
  });

  describe("validateRegistration", () => {
    test("有効な入力の場合は成功結果を返す", () => {
      // Arrange & Act
      const result = UserRegistrationDomain.validateRegistration(
        "user@example.com",
        "password123"
      );

      // Assert
      expect(result.isSuccess).toBe(true);
    });

    test("無効なメールアドレスの場合はエラーを返す", () => {
      // Arrange & Act
      const result = UserRegistrationDomain.validateRegistration(
        "invalid",
        "password123"
      );

      // Assert
      expect(result.isFailure).toBe(true);
      expect(result.error).toBe("Invalid email format");
    });

    test("短すぎるパスワードの場合はエラーを返す", () => {
      // Arrange & Act
      const result = UserRegistrationDomain.validateRegistration(
        "user@example.com",
        "short"
      );

      // Assert
      expect(result.isFailure).toBe(true);
      expect(result.error).toBe("Password too short");
    });
  });
});
```

これらのテストは非常にシンプルで、モックやスタブを使用する必要がありません。また、テストが失敗した場合も、実装の詳細ではなく、ビジネスロジックの問題を示しています。リファクタリングへの耐性も高く、ドメインロジックの内部実装が変わっても、動作が同じならテストは成功し続けます。

### ユースケース層のテスト

ユースケース層のテストでは、モックやスタブを使用して副作用を持つ依存コンポーネントを置き換えます。

```typescript
// ユースケース層のテスト - beforeEachを使わない版
describe("UserRegistrationUseCase", () => {
  test("新規ユーザーを正常に登録できる", async () => {
    // Arrange
    const mockUserRepository: UserRepository = {
      findByEmail: jest.fn().mockResolvedValue(null),
      save: jest.fn(),
    };

    const mockEmailService: EmailService = {
      sendWelcomeEmail: jest.fn(),
    };

    const useCase = new UserRegistrationUseCase(
      mockUserRepository,
      mockEmailService
    );

    // Act
    const result = await useCase.execute("new@example.com", "password123");

    // Assert
    expect(result.isSuccess).toBe(true);
    // 副作用の検証（必要最小限）
    expect(mockUserRepository.save).toHaveBeenCalled();
    expect(mockEmailService.sendWelcomeEmail).toHaveBeenCalledWith(
      "new@example.com"
    );
  });

  test("既存ユーザーの場合は登録に失敗する", async () => {
    // Arrange
    const existingUser = new User("existing@example.com", "hashedpwd");
    const mockUserRepository: UserRepository = {
      findByEmail: jest.fn().mockResolvedValue(existingUser),
      save: jest.fn(),
    };
    const mockEmailService: EmailService = {
      sendWelcomeEmail: jest.fn(),
    };
    const useCase = new UserRegistrationUseCase(
      mockUserRepository,
      mockEmailService
    );

    // Act
    const result = await useCase.execute("existing@example.com", "password123");

    // Assert
    expect(result.isFailure).toBe(true);
    expect(result.error).toBe("User already exists");
    // 副作用が実行されていないことを検証
    expect(mockUserRepository.save).not.toHaveBeenCalled();
    expect(mockEmailService.sendWelcomeEmail).not.toHaveBeenCalled();
  });

  test("無効な入力の場合は登録に失敗する", async () => {
    // Arrange
    const mockUserRepository: UserRepository = {
      findByEmail: jest.fn().mockResolvedValue(null),
      save: jest.fn(),
    };

    const mockEmailService: EmailService = {
      sendWelcomeEmail: jest.fn(),
    };

    const useCase = new UserRegistrationUseCase(
      mockUserRepository,
      mockEmailService
    );

    // Act
    const result = await useCase.execute("invalid", "password123");

    // Assert
    expect(result.isFailure).toBe(true);
    expect(result.error).toBe("Invalid email format");
    // 副作用が実行されていないことを検証
    expect(mockUserRepository.save).not.toHaveBeenCalled();
    expect(mockEmailService.sendWelcomeEmail).not.toHaveBeenCalled();
  });
});
```

ユースケース層のテストでは、副作用のあるコンポーネントをモックに置き換えていますが、その検証は必要最小限にとどめています。
主な検証はユースケースの結果（`Result<User>`）に対して行われ、副作用の検証は「呼び出されたかどうか」程度に抑えています。

### インフラストラクチャ層のテスト

インフラストラクチャ層（DB 操作、メール送信など）は、多くの場合、統合テストでカバーします。これらは単体テストではなく、実際のデータベースやメールサーバーに接続して動作を確認します。

テスト戦略をまとめると：

1. **ドメイン層**（純粋関数）：「結果の Assert」でテスト
2. **ユースケース層**（調整役）：テストダブルを用い、「副作用の Assert」で副作用の呼び出しをテスト
3. **インフラストラクチャ層**（副作用）：統合テストでテスト

この戦略により、テストの質が高く（特にドメイン層）、かつテストの網羅性も確保できます。

## まとめ：関数型アーキテクチャの利点と限界

関数型アーキテクチャを適用することで、テスタブルなプロダクションコードを実現できます。その主なメリットは：

1. **ビジネスロジックが純粋関数として分離される**：これにより、「結果の Assert」による高品質なテストが可能になります。

2. **副作用が明示的になる**：どこで副作用が発生するかが明確になり、テスト戦略の立案が容易になります。

3. **関心事の分離が進む**：ドメインロジック、ユースケース調整、インフラストラクチャといった形で責務が明確に分離されます。

4. **テストの質が向上する**：特にドメイン層のテストは「結果の Assert」で行えるため、リファクタリングへの耐性が高まります。

もちろん、関数型アーキテクチャにも限界はあります：

1. **導入コスト**：既存のコードベースに関数型アーキテクチャを導入するには、大幅なリファクタリングが必要になる場合があります。

2. **完全な純粋関数化は難しい**：現実のアプリケーションでは、完全にビジネスロジックと副作用を分離することが難しい場合もあります。

3. **学習曲線**：関数型の考え方に慣れていないチームでは、学習コストがかかる場合があります。

しかし、完全に関数型アーキテクチャを採用しなくても、ビジネスロジックと副作用の分離という考え方を部分的に取り入れることで、テスト品質を向上させることは可能です。

ドメインロジックが複雑で、ビジネスルールが重要な役割を果たすアプリケーションでは、関数型アーキテクチャの採用が特に効果的です。純粋関数として表現されたビジネスルールは、テストしやすく、理解しやすく、変更にも強くなります。
