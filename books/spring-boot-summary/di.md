---
title: "DI（依存性の注入）"
---

## DI とは？

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

## インスタンスのライフサイクル管理

DI では、インスタンスのライフサイクル管理（インスタンスの生成＆破棄）を行います。

- インスタンスの生成とは？
  - クラスを `new` すること
- インスタンスの破棄とは？
  - 変数に `null` を代入すること

```java
// インスタンスの生成
SomeObject obj = new SomeObject();

// インスタンスの破棄
obj = null
```

変数に `null` を代入すると、ガベージコレクションがメモリからインスタンスを開放してくれます。

### スコープ

Spring の DI では、インスタンスの生成と破棄を自動でやってくれます。
タイミングは「スコープ」で指定できます。
スコープとは、インスタンスが生存する期間のことです。
例えば、リクエストスコープでは HTTP のリクエストが送られてくるたびにインスタンスが生成され、リクエスト処理が完了したらインスタンスが破棄されます。

スコープを指定するためには、クラスに `@Scope` を付与します。

```java
@Controller
@Scope("request")
public class SomeController {
    // ...
}
```

`SomeController` はリクエストのたびにインスタンスの生成と破棄を自動で行います。

#### Spring が用意しているスコープ一覧

| スコープ      | 説明                                                                                                                                                                                               |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| singleton     | Spring 起動時にインスタンスを 1 つだけ生成します。<br>アプリケーション全体で、1 つのインスタンスを共有して使います。<br>**@Scope アノテーションを付けなかった場合は、全て singleton になります。** |
| prototype     | Bean を取得するたびに、インスタンスが毎回生成されます。                                                                                                                                            |
| session       | HTTP のセッション単位でインスタンスが生成されます。<br>つまり、ユーザーがログインしている間だけインスタンスが存在しています。<br>Web アプリケーションの場合のみ使用できます。                      |
| request       | HTTP のリクエスト単位でインスタンスが生成されます。<br>Web アプリケーションの場合のみ使用できます。                                                                                                |
| globalSession | ポートレット環境における GlobalSession 単位でインスタンスが生成されます。<br>ポートレットに対応した Web アプリケーションの場合のみ使用できます。                                                   |
| application   | サーブレットのコンテキスト単位でインスタンスが生成されます。<br>Web アプリケーションの場合のみ使用できます。                                                                                       |

## `@Autowired` の使い方

`@Autowired` は以下の 3 箇所で使用できます。

1. フィールド
2. コンストラクタ
3. setter

### フィールドインジェクション

```java
@Component class Sample {
    @Autowired
    private SampleComponent component;
}
```

### コンストラクタインジェクション

**Spring 推奨のインジェクション方法です。**
コンストラクタの引数に依存性を注入できます。
Spring4.3 以降であれば、`@Autowired` を省略できます。

```java
@Component
class Sample {
    private SampleComponent component;

    @Autowired
    public Sample(SampleComponent component) {
        this.component = component;
    }
}
```

### Lambok でコンストラクタを自動生成

`@RequiredArgsConstructor` を付けると、`final` フィールドだけを引数に持つコンストラクタが作成されます。

```java
@Component
@RequiredArgsConstructor
public class Sample {
    private final SampleComponent component;
    private String value;
}
```

`@AllArgsConstructor` を付けると、全てのフィールドを引数に持つコンストラクタが作成されます。

```java
@Component
@AllArgsConstructor
public class Sample {
    private final SampleComponent component;
    private String value;
}
```

コンストラクタインジェクションでは `@Autowired` を省略できるため、上記のサンプルコードでも DI されます。

### setter インジェクション

```java
@Component
public class Sample {
    private final SampleComponent component;

    // setterインジェクション
    @Autowired
    public void setComponent(SampleComponent component) {
        this.component = component;
    }
}
```

## Bean の登録方法

:::details Bean とは？
Bean とは、DI コンテナに登録されているクラスです。
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

:::

Bean の登録方法は以下の 2 つを組み合わせて使うのが主流です。

1. アノテーションベースの実装
2. JavaConfig での実装

### 1. アノテーションベースの実装

以下のアノテーションを付与すれば、DI コンテナに登録されます。

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

基本的に、Bean の登録はアノテーションベースの実装を使用します。

### 2. JavaConfig での実装

- **JavaConfig とは？**
  - Bean のインスタンスを生成するクラス
- **どんな時に使用するのか？**
  - Bean の生成が複雑な場合
  - ライブラリに用意されているクラスを DI コンテナーに登録する時など

```java
@Configuration
public class JavaConfig {
    @Bean
    public SomeComponent getSomeComponent() {
        return new SomeComponent()
    }
}
```

JavaConfig には、`@Configuration` を付けます。
そして、インスタンスを生成するメソッドに `@Bean` を付けます。`@Bean` と一緒に `@Scope` も付与できます。

## DI の注意点

### singleton スコープ

singleton とは、アプリケーション全体で 1 つのインスタンスのみが存在するオブジェクトのことを指します。Spring Boot では、デフォルトでほとんどのビーン（Bean）がシングルトンスコープで管理されています。

シングルトンの主な特徴：

1. **一意性**：アプリケーション内で 1 つのインスタンスのみ存在します。

2. **共有**：全てのクライアントが同じインスタンスを共有します。

3. **状態管理**：状態を持つ場合、その状態はアプリケーション全体で共有されます。

4. **メモリ効率**：1 つのインスタンスのみを作成するため、メモリ使用量を抑えられます。

5. **パフォーマンス**：インスタンス生成のオーバーヘッドが減少します。

Spring Boot では、`@Component`、`@Service`、`@Repository`、`@Controller`などのアノテーションが付けられたクラスは、デフォルトでシングルトンとして扱われます。

シングルトンの使用例：

```java
@Service
public class UserService {
    // このサービスは1つのインスタンスのみ生成され、
    // アプリケーション全体で共有されます。
}
```

よって、複数のインスタンスからアクセスされる場合は注意が必要です。
以下のようなコードは書いてはいけません。

```java
@Getter
@Setter
@Service
public class SomeServiceImpl implements SomeService {
    // 何らかの状態
    private String state;

    @Override
    public void someMethod() {
        // stateを使用した処理
    }
}
```

上記の Service は以下のような使い方を想定しています。

1. `state` に何かしらの値をセットする
2. `someMethod` で `state` を使用した何らかの処理を行う

何が悪いのか？
→ 別のインスタンスが `state` を書き換えられること

対応策として、フィールドをメソッドの引数に変更することでステートレスなクラスにします。

```java
@Service
public class SomeServiceImpl implements SomeService {
    @Override
    public void someMethod(String state) {
        // stateを使用した処理
    }
}
```

別の柵として、singleton 以外のスコープにする方法もあります。

### 異なるスコープ

自身と異なるスコープをフィールドに持っていると、**インスタンスが破棄されないことがあります**。
これは、Java の仕様が原因で発生するものです。

例えば、singleton スコープのインスタンスが、prototype スコープのインスタンスをフィールドに持っている場合です。

```java
@Component
@Scope("prototype")
public class PrototypeComponent {
    // ...
}

@Component
public class SingletonComponent {
    @Autowired
    private PrototypeComponent component;
    // ...
}
```

上記の場合、`PrototypeComponent` が singleton スコープになってしまいます。

他にも、request スコープの Bean を、session スコープの Bean が異なるスコープの Bean をフィールドとして持つ場合は注意が必要です。

### Bean 以外からは DI できない

```java
public class SampleObject {
    @Autowired
    private SampleService service;
}
```

上記のサンプルコードでは、`SampleObject` に `@Component` や `@Controller` などのアノテーションが付与されていません。つまり、`SampleObject` は Bean ではありません。

Spring の DI（依存性注入）は、Spring コンテナが管理する Bean に対して機能します。
そして、Spring コンテナは、自身が管理する Bean に対してのみ依存性を注入します。したがって、`SampleObject` クラスがコンテナに登録されていなければ、`SampleService` クラスの依存性を注入することができません。
