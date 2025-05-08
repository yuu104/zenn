---
title: "テスタブルなプロダクションコードの設計"
---

テスタブルなコードとは、単純にテストが書きやすいコードではありません。
それは **「リファクタリングへの耐性」が高く、価値のある単体テストが自然と導かれるコード** のことです。

本章では、そのための重要な設計原則として「観察可能な振る舞い」と「実装の詳細」の分離について説明します。

## 「観察可能な振る舞い」と「実装の詳細」を分離する

テスタブルな設計の核心は、「観察可能な振る舞い」と「実装の詳細」を明確に分離することにあります。
この分離こそが、リファクタリングに強く、価値のある単体テストを可能にする基盤です。

クライアントが目標を達成するために必要なもの（観察可能な振る舞い）だけを公開し、それ以外のもの（実装の詳細）はすべて隠蔽する
— これがテスタブルなコードの設計の本質です。

### 【復習】観察可能な振る舞い

観察可能な振る舞い（Observable Behavior）とは、クライアントがシステムの目標を達成するために直接的に関わるコードの側面です。
具体的には次の 2 つに分類されます：

1. **操作（Operations）**：クライアントが目標達成のために呼び出すメソッド

   - 結果を返すメソッド（例：`calculateTotal()`）
   - 副作用を引き起こすメソッド（例：`sendEmail()`）

2. **状態（State）**：クライアントが参照するシステムの現在の状態
   - 公開されたプロパティ（例：`user.name`）
   - 状態を返すメソッド（例：`isLoggedIn()`）

### 【復習】実装の詳細

実装の詳細（Implementation Details）とは、クライアントの目標達成に直接関係しないコードの内部構造です。
例えば：

- 内部で使用されるヘルパーメソッド
- プライベートなフィールドや変数
- アルゴリズムの具体的な実装方法
- 内部の最適化のためのコード

## 「分離する」ってどういうこと？

「観察可能な振る舞い」と「実装の詳細」を分離するとは、**クライアントが必要な操作だけを行え、不要な内部詳細には一切アクセスできない状態を作ること**です。

具体的には、次の 3 つの観点から分離を実現します：

1. **アクセス制御による分離**

   - 観察可能な振る舞いのみを公開 API（public）として公開する
   - 実装の詳細は非公開（private/protected）にする

   ```typescript
   // 良い例
   class User {
     private _name: string; // 内部状態は非公開

     public get name(): string {
       return this._name;
     } // 観察可能な状態は公開

     private normalizeInput(value: string): string {
       /* ... */
     } // 実装詳細は非公開
   }
   ```

2. **責任の所在による分離**

   - クライアントコードに余計な責任を負わせない
   - 不変条件の維持はクラス自身の責任とする

   ```typescript
   // 悪い例：クライアントに責任を負わせる
   class User {
     public name: string;

     public normalizeName(input: string): string {
       // 名前を正規化するロジック
       return input.trim().substring(0, 50);
     }
   }

   // クライアントが正規化の責任を負っている
   user.name = user.normalizeName(inputName);

   // 良い例：クラスが責任を持つ
   class User {
     private _name: string;

     set name(value: string) {
       // クラス内部で自動的に正規化
       this._name = this.normalizeName(value);
     }

     private normalizeName(input: string): string {
       return input.trim().substring(0, 50);
     }
   }

   // クライアントは単純に値を設定するだけ
   user.name = inputName;
   ```

3. **抽象化レベルによる分離**

   - 公開 API は目的を表現する高レベルの抽象化を提供する
   - 実装詳細は「どのように」を扱う低レベルの抽象化である

   ```typescript
   // 高レベル抽象化（何をするか）
   public register(user: User): void

   // 低レベル抽象化（どのように行うか）
   private validateEmail(email: string): boolean
   private hashPassword(password: string): string
   ```

## 分離しないことによる問題

観察可能な振る舞いと実装の詳細が適切に分離されていないコードは、以下の 2 つの観点で問題が生じます。

### 実装詳細の漏洩例

次のコードで、実装詳細が漏洩している例を見てみましょう：

```typescript
// 実装詳細が漏洩したUserクラス
class User {
  private _name: string;

  // nameプロパティ
  get name(): string {
    return this._name;
  }

  set name(value: string) {
    this._name = value; // 不変条件の検証なし
  }

  // 実装詳細が漏洩している - 本来はプライベートであるべき
  public normalizeName(name: string): string {
    const result = (name || "").trim();
    return result.length > 50 ? result.substring(0, 50) : result;
  }
}

// クライアントコード
class UserController {
  public renameUser(userId: number, newName: string): void {
    const user = this.getUserFromDatabase(userId);
    // クライアントが不変条件を維持する責任を負っている
    const normalizedName = user.normalizeName(newName);
    user.name = normalizedName;
    this.saveUserToDatabase(user);
  }
}
```

`normalizeName`メソッドが実装の詳細です。
何故なら、クライアントの目的は「ユーザー名を変更すること」であり、「どのように名前を正規化するか」は**目的達成のための過程**だからです。

クライアントにとって必要なのは「名前を変更する」という操作であり、その過程で行われる処理（空白除去、長さ制限など）は目的達成のための手段に過ぎません。
このような目的達成の過程は実装の詳細と言えます。

実装詳細が漏洩すると、クライアントがこれらの内部処理に依存するようになります。この依存関係が後述する様々な問題を引き起こします。

### ① テストが壊れやすくなる（偽陽性の誘発）

実装詳細がクライアントからアクセス可能になると、本来テスト対象とすべきでない内部実装がテスト出来てしまいます。これが偽陽性を引き起こす原因となります。

```typescript
// 偽陽性を引き起こすテスト例
test("ユーザー名が正規化される", () => {
  const user = new User();
  // 実装詳細（normalizeName）に直接依存するテスト
  expect(user.normalizeName(" John Doe ")).toBe("John Doe");
});
```

このテストの問題点：

- クライアントが達成したい目標（「ユーザー名を変更する」）とは関係ない実装詳細をテストしている
- 実装の詳細が変更された場合（例：異なる方法で空白を処理するなど）、「ユーザー名を変更する」というクライアントの主目的は正しく動作しているにもかかわらずテストが失敗する
- 結果として、有用な失敗（真陽性）と無用な失敗（偽陽性）が区別しづらくなる

### ② コードの保守性が低下する

実装詳細が漏洩すると、コードベース全体の保守が難しくなります。

#### 不変条件が破られるリスクが高まる

実装詳細を隠蔽せず、不変条件の維持をクライアントの責任にすると、一部のクライアントが適切な手順を踏まない可能性が生じます。

```typescript
// 危険なクライアントコード例
user.name = "a".repeat(100); // normalizeName を呼ばずに直接設定すると50文字制限が破られる
```

このようなコードが複数のクライアントに散在すると、データの整合性を維持することが困難になります。

#### 使用方法の複雑化

複数のステップ（`normalizeName`の呼び出しと`name`の設定）が必要な場合、新しいクライアントコードが追加されるたびに、正しい使用方法を理解し実装する必要があります。

```typescript
// 複雑な使用方法
const normalizedName = user.normalizeName(newName);
user.name = normalizedName;
```

これは、特に新しい開発者がコードベースに参加する際の学習コストを増大させます。

#### API 設計の一貫性の欠如

実装詳細が漏洩した API は、クライアントが直接必要とする操作（「ユーザー名を変更する」のような目的）と内部処理の詳細（「名前を正規化する方法」のような実装）が混在します。これにより：

- クライアントはどのメソッドがビジネス上の重要な操作で、どのメソッドが単なる実装の詳細かを判断しづらくなる
- コードベースが成長するにつれ、「これらのメソッドはどの順序で呼ばれるべきか」といった暗黙の依存関係が増える
- 結果として、API の使用方法が一貫せず、部分的に異なる実装が散在するようになりがち

例えば、あるクライアントでは:

```typescript
user.name = user.normalizeName(newName);
```

別のクライアントでは:

```typescript
// normalizeName を呼び忘れる
user.name = newName;
```

さらに別のクライアントでは:

```typescript
// 独自の正規化ロジックを追加
const processedName = user.normalizeName(newName).toUpperCase();
user.name = processedName;
```

このような不統一が広がると、コードベース全体の理解と保守が難しくなります。

## 分離するときの考え方

観察可能な振る舞いと実装の詳細を分離するための主要な設計原則として、「カプセル化」と「Tell, Don't Ask」があります。

### カプセル化

カプセル化とは、データとそれを操作するコードを一つのユニットに集約し、内部の詳細を外部から隠すことです。カプセル化の主な目的は、不変条件（常に真であるべき条件）の保護です。

```typescript
// カプセル化の例
class BankAccount {
  private _balance: number; // データを隠蔽

  // 公開インターフェース
  get balance(): number {
    return this._balance;
  }

  // 不変条件（残高がマイナスにならない）を保護
  withdraw(amount: number): boolean {
    if (amount <= 0 || this._balance < amount) return false;
    this._balance -= amount;
    return true;
  }
}
```

### Tell, Don't Ask 原則

「Tell, Don't Ask」（尋ねるな、命じよ）原則は、オブジェクトの内部状態を問い合わせてから操作するのではなく、直接オブジェクトに操作を命じるべきだという考え方です。

#### 悪い例（Ask）

```typescript
// データを「尋ねて」(Ask)から操作
if (account.balance >= amount) {
  account.balance -= amount; // 直接データを変更
  dispenseCash(amount);
}
```

#### 良い例（Tell）

```typescript
// 操作を「命じる」(Tell)
if (account.withdraw(amount)) {
  dispenseCash(amount);
}
```

「Tell, Don't Ask」に従うことで、データと操作が一箇所に集約され、不変条件が保護されます。

## きちんと分離されたプロダクションコード

最後に、実装詳細がきちんと分離された User クラスの例を見てみましょう：

```typescript
// きちんと分離されたUserクラス
class User {
  private _name: string;

  // 観察可能な振る舞い（状態）
  get name(): string {
    return this._name;
  }

  // 観察可能な振る舞い（操作）
  set name(value: string) {
    // 内部で自動的に不変条件を維持
    this._name = this.normalizeName(value);
  }

  // 実装詳細（非公開）
  private normalizeName(name: string): string {
    const result = (name || "").trim();
    return result.length > 50 ? result.substring(0, 50) : result;
  }
}

// クライアントコード
class UserController {
  public renameUser(userId: number, newName: string): void {
    const user = this.getUserFromDatabase(userId);
    // シンプルな1操作で目標達成
    user.name = newName;
    this.saveUserToDatabase(user);
  }
}
```

### 分離の効果

1. **テストの偽陽性が減少**

   - クライアントのテストは観察可能な振る舞い（`name`プロパティ）だけに依存するため、内部実装が変わっても壊れない

   ```typescript
   // 堅牢なテスト例
   test("ユーザー名が設定できる", () => {
     const user = new User();
     user.name = " John Doe ";
     expect(user.name).toBe("John Doe");
   });
   ```

2. **不変条件が常に保護される**

   - どのようにプロパティが設定されても、不変条件（50 文字制限、空白除去）は常に維持される
   - クライアントがルールを忘れるリスクが排除される

3. **API 使用の簡素化**
   - 複数のステップではなく、単一の操作（`name = value`）で目標を達成できる
   - 新しいクライアントでも適切に使用できる

## 分離できているかの見極め方

設計した API が観察可能な振る舞いと実装の詳細を適切に分離できているかを判断する方法があります。
それは、**「クライアントが単一の目標を達成するためにテスト対象コードに対して何度呼び出しを行っているか」**を確認することです。

理想的な API 設計は、**いかなる目標であれ、1 つの操作で目標達成できるようにする**ことです。

リファクタリング前の例では、`UserController` クラスは「ユーザーの名前を変更する」という単一の目標を達成するために、`User` クラスに対して次の 2 つの操作を行わなければなりませんでした。

```ts
string normalizedName = user.normalizeName(newName);
user.name = normalizedName;
```

一方、リファクタリング後では、操作の数は 1 つに減っています。

```ts
user.name = newName;
```

ビジネスロジックが含まれる場合、この見極め方は特に有効です。
例外的なケースもありますが、そのようなケースは稀です。

:::message
**複数のメソッド呼び出しが行われているコードを見つけたら、そのコードが実装の詳細を漏洩していないか調査し、必要に応じてリファクタリングしましょう。**
:::

## まとめ

テスタブルなプロダクションコード設計の核心は、「観察可能な振る舞い」と「実装の詳細」を明確に分離することです。この分離により、リファクタリングへの耐性が高く、偽陽性の少ない単体テストが自然と実現します。

適切な分離のためには：

1. アクセス制御を使って実装詳細を隠蔽する
2. 不変条件の維持をクラス自身の責任とする
3. 「Tell, Don't Ask」原則に従い、データと操作を一箇所に集約する

プロダクションコードの設計とテストの質は密接に関連しています。良い設計はリファクタリングへの耐性を高め、結果として価値の高いテストへとつながるのです。

:::message
**TIP： API をきちんと設計すれば、単体テストは自然と質の良いものになるんですよ。**
:::
