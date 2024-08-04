---
title: "DI（依存性の注入）"
---

## DI とは？

### 依存性とな何か？

### 依存性とは何か？

依存性とは、あるクラスが他のクラスやオブジェクトを必要とする関係のことです。
例えば、Car クラスが Engine クラスのインスタンスを必要とする場合、Car は Engine に依存していると言えます。

```java
public class Car {
    private Engine engine;

    public Car() {
        this.engine = new Engine(); // 依存関係が強く結合している
    }

    public void methodCar() {
      this.engine.methodB();
    }
}
```

もしも `Engine` のメソッド（`methodB`）で引数が必要になると、`Car` はコードを修正しなければいけません。

### 注入とは何か？

注入とは、あるオブジェクトが必要とする依存オブジェクトを外部から提供することです。
これにより、オブジェクトは自身で依存オブジェクトを作成する必要がなくなります。

```java
public class Car {
    private Engine engine;

    public Car(Engine engine) { // コンストラクタを通じて注入
        this.engine = engine;
    }
}
```

### 依存性の注入とは何か？

**「インターフェース」や「抽象クラス」を継承したクラスのインスタンスを代入すること**です。

例えば、Java には `List` インターフェースが存在します。
メソッド引数の型が `List` の場合、`List` を実装したクラスでなければインスタンスを代入できません。

そして、インターフェースや抽象クラスは複数の継承クラスを持ちます。
`List` の継承クラスは、`ArrayList` や `LinkedList` などがあります。

つまり、「依存性の注入」とは、

- どの継承クラスを使用するのか（依存）を選択し、
- そのインスタンスを変数に代入する（注入）

ということです。

下記コードでは、`List` をコンストラクタ引数にとる `Car` クラスに対し、

- 継承クラスである `ArrayList` を依存性として選択し、
- インスタンスである `list` を `Car` クラス外部から注入する

ということをしています。

```java
public class Car {
    private List list;

    public Car(List engine) { // コンストラクタを通じて注入
        this.engine = engine;
    }
}
public void method(List list) {
  // ...
}

List<Object> list = new ArrayList<>();

Car car = new Car(list);
```

## なぜインターフェースや抽象クラスを使用するのか？

**クラスを交換できるようにし、保守性を高めるため**です。

以下のメリットがあります。

- 処理内容の追加・変更ができる
- テストがしやすくなる

### 処理内容の追加・変更ができる

インターフェースを使用すれば、クラスを変更でき、処理の中身を変更できます。
例えば、`List` を実装した `ArrayList` と `LinkedList` では特徴が異なります。

- `ArrayList`
  - 長所：要素へのアクセスが早い
  - 短所：要素の追加が遅い
- `LinkedList`
  - 長所：要素の追加が早い
  - 短所：要素へのアクセスが遅い

型を `List` として定義し、実装クラスを変更できるようにしておけば、それだけ変更に強くなり拡張性が高くなります。

```java
// 実装クラスを変更できる（疎結合）
List<Object> listA = new ArrayList<>();

// ArrayList 以外に変更できない（密結合）
ArrayList<Object> listB = new ArrayList<>();
```

![](https://storage.googleapis.com/zenn-user-upload/205198f1de36-20240804.png)

疎結合にしておけば `List` を実装しているクラスであれば何でも対応可能です。

### テストがしやすくなる

モックオブジェクト（スタブ）の使用が簡単になります。

1. **モックオブジェクトとは**

   - モックオブジェクトは、実際のオブジェクトの振る舞いをシミュレートする偽のオブジェクトです
   - テスト対象のクラスが依存するオブジェクトの代わりに使用されます

2. **インターフェースとモックの関係**

   - インターフェースを使用すると、そのインターフェースを実装したモックオブジェクトを簡単に作成できます
   - 実際の実装クラスではなく、インターフェースに依存することで、テスト時に実装を簡単に置き換えられます

3. **テストの容易さの具体例**

   まず、インターフェースと実装クラスを定義します。

   ```java
   public interface PaymentGateway {
       boolean processPayment(double amount);
   }

   public class RealPaymentGateway implements PaymentGateway {
       public boolean processPayment(double amount) {
           // 実際の支払い処理のロジック（外部APIを呼び出すなど）
           return true;
       }
   }
   ```

   次に、このインターフェースを使用するクラスを作成します。

   ```java
   public class OrderService {
       private final PaymentGateway paymentGateway;

       public OrderService(PaymentGateway paymentGateway) {
           this.paymentGateway = paymentGateway;
       }

       public boolean placeOrder(double amount) {
           // 注文処理のロジック
           return paymentGateway.processPayment(amount);
       }
   }
   ```

   ここで、`OrderService`をテストする場合

   ```java
   import static org.junit.jupiter.api.Assertions.*;
   import static org.mockito.Mockito.*;

   import org.junit.jupiter.api.Test;

   public class OrderServiceTest {

       @Test
       public void testPlaceOrder_Successful() {
           // モックオブジェクトの作成
           PaymentGateway mockPaymentGateway = mock(PaymentGateway.class);
           when(mockPaymentGateway.processPayment(anyDouble())).thenReturn(true);

           // テスト対象のオブジェクトにモックを注入
           OrderService orderService = new OrderService(mockPaymentGateway);

           // テストの実行
           boolean result = orderService.placeOrder(100.0);

           // 検証
           assertTrue(result);
           verify(mockPaymentGateway).processPayment(100.0);
       }

       @Test
       public void testPlaceOrder_Failed() {
           PaymentGateway mockPaymentGateway = mock(PaymentGateway.class);
           when(mockPaymentGateway.processPayment(anyDouble())).thenReturn(false);

           OrderService orderService = new OrderService(mockPaymentGateway);

           boolean result = orderService.placeOrder(100.0);

           assertFalse(result);
           verify(mockPaymentGateway).processPayment(100.0);
       }
   }
   ```

4. **このアプローチの利点**

   - 実際の支払いゲートウェイを使用せずにテストできます（外部依存がない）
   - テストの実行が速くなります（実際の API 呼び出しがない）
   - 異なるシナリオ（成功、失敗など）を簡単にシミュレートできます
   - `OrderService`の動作を、`PaymentGateway`の振る舞いから分離してテストできます

5. **モックフレームワークの利用**
   - 上記の例では Mockito を使用していますが、これにより簡単にモックオブジェクトを作成し、その振る舞いを定義できます
   - `when(...).thenReturn(...)` を使用して、特定の入力に対する出力を定義します
   - `verify(...)` を使用して、特定のメソッドが呼び出されたことを確認します

インターフェースを使用することで、このようなモックオブジェクトの作成と使用が非常に簡単になり、結果としてユニットテストの品質と効率が向上します。
実際の実装に依存せずにテストができるため、テストの信頼性も高まります。

## Spring の DI

Spring の DI では以下の処理を行っています。

1. DI の対象クラスを探す
2. `@Autowired` アノテーションが付いてる箇所に、インスタンスを注入する

### DI の対象クラスを探す

Spring の起動時、DI の対象となるクラスを探します。このことを、**コンポーネントスキャン**と言います。
以下のアノテーションが付与されたクラスが対象となります。

- `@Component`
- `@vontroller`
- `@Service`
- `@Repository`
- `@Configuration`
- `@ResetController`
- `@ControllerAdvice`
- `@MaagedBean`
- `@Named`
- `@Mapper`
- `@Bean`

上記の対象クラスは**DI コンテナ**に登録されています。
DI コンテナとは、DI 対象クラスの管理をしてくれる入れ物のことです。

例えば、`@Controller` と `@Service` アノテーションが付けられたクラスが 1 つずつあるとします。その場合、コンポーネントスキャンの結果として、以下のような DI コンテナーが作成されます。

```java
public class DiContainer {
  // 各クラスのインスタンスを生成
  private SampleController controller = new SampleController();
  private SampleService service = new SampleService();

  // SampleController の getter
  public static SampleController getSampleController() {
    return controller;
  }

  // SampleService の getter
  public static SampleService getSampleService() {
    return service;
  }
}
```

DI コンテナクラスでは、対象クラスのインスタンスをフィールドとして持っています。
それらの getter を持つクラスが生成されると考えれば良いです。

DI コンテナに登録されているクラスのことを **Bean** と呼びます。
`SampleController` や `SampleService` も Bean です。

### `@Autowired` アノテーションが付いてる箇所に、インスタンスを注入する

`@Autowired` は以下のように使用されます。

```java
@Autowired
private SampleService service;
```

そして、上記は以下のように変換されます。

```java
private SampleService service = DIContainer.getSampleService();
```

このようにして、`@Autowired` が付いている箇所にインスタンスが注入されます。

## `@Autowired` の使い方

`@Autowired` は以下の 3 箇所で使用できます。

1. フィールド
2. コンストラクタ
3. setter

### フィールドインジェクション

```java

```
