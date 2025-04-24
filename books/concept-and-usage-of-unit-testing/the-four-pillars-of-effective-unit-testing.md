---
title: "価値の高い単体テストを構成する4本の柱"
---

テストの質を良くする要素は以下の 3 つ。

- **開発サイクルの中でテストできる**
- **コードベースの重要な部分のみがテスト対象となっている**
- **最小限の保守コストで最大限の価値が生み出せている**

価値のあるテストケースを**認識する**ことと**作成する**ことは異なるスキルです。

この Chapter では、**価値のあるテストケースを認識するための基準**について解説します。

## 価値の高い単体テストを構成する 4 本の柱

1. **リグレッションに対する保護**
2. **リファクタリングへの耐性**
3. **迅速なフィードバック**
4. **保守のしやすさ**

## ① リグレッションに対する保護

**リグレッション** とは、変更を加えた後に、既存の機能が意図したように動かなくなるバグのことです。
例えば、新しい機能を追加したときに、それまで正常に動いていた別の機能が突然動かなくなる状況です。

### なぜリグレッションが問題なのか？

リグレッションが最も深刻なのは、既存の機能の振る舞いが予期せず変わってしまうことです。
新規機能を開発するたびに既存機能が壊れるようでは、開発速度は著しく低下します。

重要なポイントとして、**コードは資産ではなく、負債**だということを理解しておく必要があります。
コードベースが大きくなればなるほど、より多くの潜在的なバグを抱えることになります。
だからこそ、リグレッションから保護する仕組みを作り出すことが非常に重要なのです。
もし適切な保護が得られなければ、開発チームは絶え間ないバグ対応に時間を取られ、プロジェクトの成長を維持できなくなってしまいます。

![](https://storage.googleapis.com/zenn-user-upload/6692da1847ba-20250301.png =550x)

### 偽陰性(false negative)

偽陰性とは、「**テストは成功するが、機能にバグが存在する**」状態のことです。
これはテストが検出すべきバグを見逃しているので、リグレッションに影響します。

火災報知器で例えると、火が出ているのにも関わらず、アラートがならない状態です。

### 偽陰性はなぜ発生するのか？

1. **カバレッジ不足**
   - エッジケースを考慮していない
   - 条件分岐における特定の分岐をテストしていない
2. **テストが実行されていない**
   - テストコードが存在しても、実際にはテストとして認識・実行されないケース
   - 「テストの命名規則に従っていない」「テスト実行設定から漏れている」などの理由で、テストランナーがテストを検出できない場合がある
   - CI/CD パイプラインが適切に設定されていないと、自動テストが実行されないこともある
3. **不適切な検証方法**

   ```ts
   // プロダクションコード
   const TAX_RATE = 0.1;
   function taxAmount(price: number) {
     return (price / (1 + TAX_RATE)) * TAX_RATE; // ← 1円未満の端数が発生する場合がある
   }

   // テストコード
   it("税込価格から税額を返す", () => {
     // Arrange
     const TAX_RATE = 0.1;
     const price = 130;
     const expected = (price / (1 + TAX_RATE)) * TAX_RATE;

     // Act
     const result = taxAmount(price);

     // Assert
     assert.equal(taxAmount(price), expected); // ← テストは成功する
   });
   ```

   このテストは、実装と全く同じロジックで期待値を計算しているため、実装に誤りがあってもそれを検出できません。
   テストと実装が同じ間違いを犯しているため、常に成功してしまいます。これは典型的な偽陰性の例です。

   実装とは独立した方法で期待値を定義し、実装の正しさを客観的に検証すべきです。

   ```ts
   // 改善したテスト
   it("税込価格130円から税額を返す", () => {
     const price = 130;
     assert.equal(taxAmount(price), 11.82); // 具体的な期待値
   });
   ```

### 偽陰性を減らし、リグレッションを防ぐためには？

1. **カバレッジを増やす**
   - テスト時に実行されるプロダクション・コードの量が増えるほど、退行を見つける可能性は高まる
   - ただし前提として、**実行結果の適切な検証が行われていなければならない**
   - テスト対象のコードを単に実行しているだけでは不十分
   - 重要なのは、実行結果が期待通りの結果であることも確認すること
2. **重要性の高いビジネスロジックをテストする**
   - ビジネス的に重要な機能になるほど、バグによる被害も大きくなる
   - 重要なドメインロジックに対するテストはビジネスの観点から高い価値を持つ
   - アプリケーションのコードだけでなく、**使用しているライブラリやフレームワークなどの外部コードも考慮する必要がある**
3. **複雑性の高いコードをテストする**

   - 複雑なコードは、単純なコードよりも重要性が高い
   - 複雑なコードほどバグが入り込む余地が大きく、テストによる保護の価値が高まる
   - 単純なプロパティ定義のみのクラスなど「取るに足らないコード」のテスト価値は低い

     ```java
     public class User {
      public String name { get; set; }
     }
     ```

## ② リファクタリングへの耐性

これは、コードの動作を変えずに内部構造を改善する「**リファクタリング**」を行っても、テストが不必要に失敗しない性質を指します。

### 偽陽性（false positive）

リファクタリング中によく遭遇する問題が「**偽陽性（false positive）**」です。
コードの機能自体は正しく動作しているにもかかわらず、テストが失敗してしまう現象です。

火災報知器で例えると、火が出ていないのにアラートがなる状態です。

### 偽陽性がプロダクト開発に与える影響

偽陽性が頻発すると、以下のような流れで、プロジェクトに深刻な問題を引き起こします。

![](https://storage.googleapis.com/zenn-user-upload/5a9c1f077073-20250301.png =450x)

### 何が偽陽性を引き起こすのか？

偽陽性が生まれる原因は、**実装方法をテストしている**ことです。

具体例を見てみましょう。
EC サイトの注文処理を行うクラスをテストします。

:::details プロダクションコード

```java
/**
 * 注文処理を行うクラス
 */
public class OrderProcessor {
    private InventoryService inventoryService;
    private PaymentService paymentService;
    private NotificationService notificationService;

    public OrderProcessor(InventoryService inventoryService,
                          PaymentService paymentService,
                          NotificationService notificationService) {
        this.inventoryService = inventoryService;
        this.paymentService = paymentService;
        this.notificationService = notificationService;
    }

    /**
     * 注文を処理します。
     * 1. 在庫確認
     * 2. 支払い処理
     * 4. 在庫更新
     * 3. 通知送信
     */
    public OrderResult processOrder(Order order) {
        // 在庫確認
        boolean inStock = inventoryService.checkStock(order.getItems());
        if (!inStock) {
            return OrderResult.failed("在庫不足");
        }

        // 支払い処理
        PaymentResult paymentResult = paymentService.processPayment(order.getPaymentDetails());
        if (!paymentResult.isSuccessful()) {
            return OrderResult.failed("支払い処理失敗");
        }

        // 在庫更新
        inventoryService.updateStock(order.getItems());

        // 通知送信
        notificationService.sendOrderConfirmation(order);

        return OrderResult.successful(paymentResult.getTransactionId());
    }
}
```

:::

:::details 偽陽性を引き起こすテストコード

```java
@Test
public void shouldFollowCorrectOrderProcessingSteps() {
    // Arrange
    InventoryService mockInventory = Mockito.mock(InventoryService.class);
    PaymentService mockPayment = Mockito.mock(PaymentService.class);
    NotificationService mockNotification = Mockito.mock(NotificationService.class);
    // モックの設定
    Mockito.when(mockInventory.checkStock(Mockito.any())).thenReturn(true);
    Mockito.when(mockPayment.processPayment(Mockito.any())).thenReturn(
        new PaymentResult(true, "TX12345"));
    OrderProcessor processor = new OrderProcessor(
        mockInventory, mockPayment, mockNotification);
    Order order = new Order(/* 注文詳細 */);

    // Act
    OrderResult result = processor.processOrder(order);

    // Assert
    // 各メソッドが呼び出されたことを検証
    Mockito.verify(mockInventory).checkStock(order.getItems());
    Mockito.verify(mockPayment).processPayment(order.getPaymentDetails());
    Mockito.verify(mockInventory).updateStock(order.getItems());
    Mockito.verify(mockNotification).sendOrderConfirmation(order);

    // Assert
    // メソッドの呼び出し順序を検証
    InOrder inOrder = Mockito.inOrder(mockInventory, mockPayment, mockNotification);
    inOrder.verify(mockInventory).checkStock(Mockito.any());
    inOrder.verify(mockPayment).processPayment(Mockito.any());
    inOrder.verify(mockInventory).updateStock(Mockito.any());
    inOrder.verify(mockNotification).sendOrderConfirmation(Mockito.any());
}
```

:::

上記のテストコードでは、`OrderProcessor`（テスト対象）の依存クラスをテストダブル化し、以下 2 つの観点を検証しています。

- **依存クラスのメソッドが呼び出される**
- **依存クラスのメソッドが期待通りの順に呼び出される**

このようなテストはリファクタリングに対し脆弱です。
例えば、以下 2 つのケースを見てみましょう。

:::details ① パフォーマンス向上のためのリファクタリング

```diff java
public OrderResult processOrder(Order order) {
-    // 在庫確認
-    boolean inStock = inventoryService.checkStock(order.getItems());
-    if (!inStock) {
-        return OrderResult.failed("在庫不足");
-    }
-
-    // 支払い処理
-    PaymentResult paymentResult = paymentService.processPayment(order.getPaymentDetails());
-    if (!paymentResult.isSuccessful()) {
-        return OrderResult.failed("支払い処理失敗");
-    }
-
-    // 在庫更新
-    inventoryService.updateStock(order.getItems());
-
-    // 通知送信
-    notificationService.sendOrderConfirmation(order);

+    // 支払い処理を先に行うように変更（顧客を待たせないため）
+    PaymentResult paymentResult = paymentService.processPayment(order.getPaymentDetails());
+    if (!paymentResult.isSuccessful()) {
+        return OrderResult.failed("支払い処理失敗");
+    }
+
+    // 在庫確認
+    boolean inStock = inventoryService.checkStock(order.getItems());
+    if (!inStock) {
+        // 支払いの取り消し処理を追加
+        paymentService.refundPayment(paymentResult.getTransactionId());
+        return OrderResult.failed("在庫不足");
+    }
+
+    // 在庫更新と通知送信を並列処理に変更（処理速度向上のため）
+    CompletableFuture.allOf(
+        CompletableFuture.runAsync(() -> inventoryService.updateStock(order.getItems())),
+        CompletableFuture.runAsync(() -> notificationService.sendOrderConfirmation(order))
+    ).join();

    return OrderResult.successful(paymentResult.getTransactionId());
}
```

:::

:::details ② コードの明確性向上のためのメソッド名変更

```diff java
// InventoryService.java
public interface InventoryService {
-    boolean checkStock(List<OrderItem> items);
-    void updateStock(List<OrderItem> items);
+    boolean verifyItemsAvailability(List<OrderItem> items);  // より明確な名前に変更
+    void adjustInventory(List<OrderItem> items);  // より明確な名前に変更
}

// OrderProcessor.java (一部)
public OrderResult processOrder(Order order) {
-    boolean inStock = inventoryService.checkStock(order.getItems());
+    boolean inStock = inventoryService.verifyItemsAvailability(order.getItems());
    // ...

-    inventoryService.updateStock(order.getItems());
+    inventoryService.adjustInventory(order.getItems());
    // ...
}
```

:::

これらのリファクタリングでは、次の変更を行いました。

1. **ケース ①**
   - 処理順序の変更（在庫確認前に支払い処理を実行）
   - 新たな安全機能の追加（在庫不足時の支払い返金）
   - 並列処理の採用（処理速度の向上）
2. **ケース ②**
   - メソッド名の改善（より明確で意図が伝わる名前に変更）

どちらの変更も、**テスト対象の外部から観察可能な振る舞いは変わっていません**。
つまり：

- 注文の成功条件は同じ
- 注文の失敗条件は同じ
- 成功/失敗時の返り値は同じ

しかし、前述のテストはどちらのケースでも失敗します。
これが**偽陽性**です。

テストが失敗する理由は以下の通りです：

1. **ケース ① の場合**
   - メソッド呼び出しの順序が変わった
     - （`checkStock` → `processPayment` の順から、`processPayment` → `checkStock` の順に）
   - 並列処理により呼び出し順序が保証されなくなった
     - （`updateStock` と `sendOrderConfirmation` の順序）
2. **ケース ② の場合**
   - 検証対象のメソッド名が変わった
     - （`checkStock` → `verifyItemsAvailability`、`updateStock` → `adjustInventory`）

:::message

**実装方法へのテストが、偽陽性を招く**

例示したテストコードの根本的な問題は、**プロダクションコードの実装方法をテストしている**ことです。

- 特定のメソッドが呼ばれることを検証している
- メソッドが呼ばれた順序を検証している

リファクタリングは**実装方法**を変更する行為です。
故に、実装方法を変更すれば、テストが失敗するのも当然の結果と言えます。

:::

### 偽陽性を引き起こさないテストとは？

**実装方法ではなく、最終的な結果を確認する**ことです。

前述で示したテストでは、内部メソッドの呼び出しを確認していました。
これを、**振る舞い**に着目したテストに変更し、テスト対象メソッドの戻り値を確認します。

```diff java
- @Test
- public void shouldFollowCorrectOrderProcessingSteps() {
+ @Test
+ public void shouldProcessOrderSuccessfully() {
    // Arrange
    InventoryService mockInventory = Mockito.mock(InventoryService.class);
    PaymentService mockPayment = Mockito.mock(PaymentService.class);
    NotificationService mockNotification = Mockito.mock(NotificationService.class);
    // モックの設定
    Mockito.when(mockInventory.checkStock(Mockito.any())).thenReturn(true);
    Mockito.when(mockPayment.processPayment(Mockito.any())).thenReturn(
        new PaymentResult(true, "TX12345"));
    OrderProcessor processor = new OrderProcessor(
        mockInventory, mockPayment, mockNotification);
    Order order = new Order(/* 注文詳細 */);

    // Act
    OrderResult result = processor.processOrder(order);

-   // Assert
-   // 各メソッドが呼び出されたことを検証
-   Mockito.verify(mockInventory).checkStock(order.getItems());
-   Mockito.verify(mockPayment).processPayment(order.getPaymentDetails());
-   Mockito.verify(mockInventory).updateStock(order.getItems());
-   Mockito.verify(mockNotification).sendOrderConfirmation(order);
-
-   // Assert
-   // メソッドの呼び出し順序を検証
-   InOrder inOrder = Mockito.inOrder(mockInventory, mockPayment, mockNotification);
-   inOrder.verify(mockInventory).checkStock(Mockito.any());
-   inOrder.verify(mockPayment).processPayment(Mockito.any());
-   inOrder.verify(mockInventory).updateStock(Mockito.any());
-   inOrder.verify(mockNotification).sendOrderConfirmation(Mockito.any());
+   // Assert
+   // 最終的な結果（テスト対象メソッドの戻り値）のみを検証
+   assertTrue(result.isSuccessful());
+   assertEquals("TX12345", result.getTransactionId());
}
```

改善後のテストには以下の特徴があります。

1. **実装方法に依存していない**
   - 内部処理の変更（メソッド呼び出し順序の変更、並列処理化、メソッド名変更など）に影響されない
   - プロダクションコードをブラックボックスとして扱っている
2. **「振る舞い」をテストしている**
   - 「注文が正常に処理され、取引 ID が返される」という結果を検証

よって、改善後のテストでは、前述した 2 つのリファクタリングのどちらに対しても失敗しません。
なぜなら、テストが検証しているのは最終的な結果だけであり、その結果は両方のリファクタリング後も変わらないからです。

| 実装方法のテスト               | 振る舞いのテスト               |
| ------------------------------ | ------------------------------ |
| 内部メソッドの呼び出しを検証   | 最終的な結果のみを検証         |
| 特定の実装に強く結びついている | 実装から独立している           |
| 偽陽性を頻繁に引き起こす       | 偽陽性をほとんど引き起こさない |
| リファクタリングで壊れやすい   | リファクタリングに強い         |

良いテストは、「プロダクションコードが何をするか」をテストし、「どのようにそれを行うか」には関心を持ちません。
この原則に従うことで、リファクタリングへの耐性が高く、偽陽性を引き起こしにくいテストを作成できます。

## ③ 迅速なフィードバック

迅速なフィードバックとは、テストを実行してからその結果を確認できるまでの時間が短いことを指します。

- テストの実行時間が短い（理想的には数ミリ秒〜数秒程度）
- コード変更からテスト結果の確認までの時間が短い
- 自動化されたテスト実行環境により、変更のたびにすぐテストを実行できる

### 迅速なフィードバックがあると何が嬉しいのか

1. **バグ修正コストの大幅な削減**

   - バグが早期に発見されるほど修正コストは低下します
   - コードを書いた直後にテストが失敗することで、原因の特定が容易になるからです
   - また、問題のあるコードがまだ開発者の記憶に新しいため、修正がスムーズです

2. **バグの早期発見による品質向上**

   - テストが頻繁に実行されるため、バグがコードベースに長く残ることがなくなります
   - 品質問題が蓄積する前に対処できます

3. **無駄な開発の回避**
   - 間違った方向への開発がすぐに検出される
   - フィードバックが遅いと、誤った前提に基づいてコードを書き続ける危険性
   - 早期フィードバックにより、誤った方向への時間投資を最小化
4. **リファクタリングの促進**
   - コード変更の影響をすぐに確認できるため、リファクタリングへの心理的抵抗が少ない
   - 結果として、コードの品質が継続的に向上

## ④ 保守のしやすさ

**コードは資産ではなく負債**であり、テストコードも例外ではありません。
そのため、テストコードの保守コストを維持することはプロジェクトの持続的な成長に欠かせない要素です。

### 保守コストの評価指標

1. **テストケースの理解容易性**

   - テストケースのサイズによって容易性が変動する
   - 一般的にはテストコードの量が小さい程、理解しやすい

2. **テスト実装の難易度**
   - テストしやすいプロダクションコードを書くことが大事
   - テストダブルの多用はテストの難易度を上げる

## 4 つの柱を軸にテストケースを評価する
