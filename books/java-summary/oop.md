---
title: "オブジェクト指向"
---

## オブジェクト指向とは

**「ある役割を持ったモノ」ごとにクラスを分割し、モノとモノとの関係性を定義していくことでシステムを作り上げようとするシステム構成の考え方。**

- モノ = クラス
- クラスごとに分業して一気に開発を進めることができる
- 情報（コード）の管理やメンテナンス性に優れている
- 大規模なシステム開発で効果を発揮する
- Java は「オブジェクト指向言語」

## オブジェクト指向の要素

モノを表現するためには **「属性（どのようなものか）」** と **「機能（何ができるか）」** が必要になる。

1. **属性**
   - クラス内で定義された**変数**
   - **「フィールド」** とも呼ぶ
2. **機能**
   - クラス内で定義された**関数**
   - **「メソッド」** とも呼ぶ

フィールドとメソッドを合わせて**メンバ**と言う。

## インスタンスの生成

以下のクラスのインスタンスを生成する。

```java
public class Dog {
  // フィールド
  String breed;
  int age;
  String color;

  // コンストラクタ
  public Dog(String breed, int age, String color) {
    this.breed = breed;
    this.age = age;
    this.color = color;
  }

  // メソッド
  void bark() {
    System.out.println("Woof!");
  }
}
```

- インスタンスは `new` キーワードを使用して生成する
- `new` は指定されたクラスの新しいオブジェクトをメモリ上に確保し、そのオブジェクトへの**参照**を返す
- 型はクラス名と同じ

```java
// Dogクラスのインスタンスを生成
Dog myDog = new Dog("Shiba", 5, "Red");

// インスタンスメソッドの呼び出し
myDog.bark(); // Woof!
```

## コンストラクタ

- **インスタンス化する際に自動でフィールドを初期化するためのメソッド**
- 属性に具体的な値がないと実態として扱うことができない

### ルール・特徴

- **名前:** クラス名と同じ
- **戻り値:** 戻り値を持たず、型も定義しない（`void` も含めない）
- **呼び出し:** インスタンス生成時、必ず最初に自動で呼び出される
- **アクセス修飾子:** `public`、`private`、`protected`、修飾子なしのどれか

### コンストラクタは複数指定可能（オーバーロード）

- コンストラクタはメソッド
- よって、オーバーロード可能

```java
public class Rectangle {
  private int width;
  private int height;

  public Rectangle() {
    this(0, 0);  // パラメータ付きコンストラクタを呼び出す
  }

  // 幅と高さを受け取るコンストラクタ
  public Rectangle(int width, int height) {
    this.width = width;
    this.height = height;
  }

  // 正方形を定義するコンストラクタ
  public Rectangle(int size) {
    this(size, size);  // 幅と高さが同じRectangleを作成
  }

  public void display() {
    System.out.println("Width: " + width + ", Height: " + height);
  }
}

public class TestRectangle {
  public static void main(String[] args) {
    Rectangle rect1 = new Rectangle();
    Rectangle rect2 = new Rectangle(50, 40);
    Rectangle rect3 = new Rectangle(30);

    rect1.display();  // Width: 0, Height: 0
    rect2.display();  // Width: 50, Height: 40
    rect3.display();  // Width: 30, Height: 30
  }
}
```

### インスタンス化はコンストラクタを呼び出している

Java でインスタンス化するというプロセスは、実際にはクラスのコンストラクタを呼び出して新しいオブジェクトをメモリ上に作成することを意味する。

![](https://storage.googleapis.com/zenn-user-upload/118c981a7764-20240504.png)

インスタンス化のプロセスは以下の手順。

1. **メモリ割り当て**
   - クラスのインスタンスを作成するとき、Java 仮想マシン（JVM）はそのオブジェクトに必要なメモリをヒープ上に割り当てる
   - これはオブジェクトが消費するデータ（フィールドなど）の量に依存する
2. **コンストラクタの呼び出し**
   - メモリが割り当てられた後、指定されたコンストラクタが呼び出される
   - この時点で、オブジェクトのフィールドに初期値が設定されたり、初期化コードが実行されたりする
3. **オブジェクトの使用準備完**
   - コンストラクタの実行が完了すると、オブジェクトは使用のために準備が整う
   - アプリケーション内の他の部分から、このオブジェクトにアクセスしてメソッドを呼び出したり、フィールドを操作したりすることができる

### デフォルトコンストラクタ

- クラス内にコンストラクタが明示的に定義されていない場合、内部で実装されるコンストラクタ
- 一つでもコンストラクタが明示的に定義されている場合、デフォルトコンストラクタは定義されない

```java
public class Animal {
  private String name;

  // 明示的なコンストラクタが定義されていないため、Javaは以下のデフォルトコンストラクタを提供する
  // public Animal() {
  //    super();  // Objectクラスのコンストラクタを呼び出す
  // }

  public void setName(String name) {
    this.name = name;
  }

  public String getName() {
    return this.name;
  }
}
```

## this

- **「このインスタンス」** という意味を表す
- クラス内のメソッドやコンストラクタから現在のオブジェクトのインスタンス変数や他のメソッドにアクセスする際に `this` を使用する

具体的には以下の意味を持つ。

- **`this()`:** コンストラクタ
- **`this.変数名`**: フィールド変数

### this の使用シーン

1. **現在のインスタンスのメンバへのアクセス**

   - フィールド名とメソッド引数・ローカル変数の名前が同じ場愛、フィールドを識別するために `this` を使用する
   - これにより、名前の衝突を解消し、フィールドへのアクセスを明確にする

   ```java
   public class Point {
    private int x;
    private int y;

    public Point(int x, int y) {
      this.x = x; // フィールドxに、コンストラクタのパラメータxの値を代入
      this.y = y; // フィールドyに、コンストラクタのパラメータyの値を代入
    }
   }
   ```

2. **コンストラクタ内でオーバーロードした別のコンストラクタを呼び出す**

   - 同一クラス内の別のコンストラクタを呼び出すために `this()` を使用する
   - これは、コンストラクタのオーバーロードを効率的に管理し、コードの重複を避けるために役立つ

   ```java
   public class Rectangle {
    private int width;
    private int height;

    public Rectangle() {
      this(0, 0); // 別のコンストラクタを呼び出す
    }

    public Rectangle(int width, int height) {
      this.width = width;
      this.height = height;
    }
   }
   ```

3. **メソッドチェーン**

   - メソッドチェーンとは、オブジェクトに対する複数のメソッド呼び出しを一連の連続した呼び出しとして書くスタイルのこと
   - 各メソッドがオブジェクト自身（this）を返すことにより実現する

   ```java
   public class Builder {
    private int value;

    public Builder setValue(int value) {
      this.value = value;
      return this; // thisを返すことでメソッドチェーンが可能に
    }

    public Builder increment() {
      this.value++;
      return this;
    }

    public void printValue() {
      System.out.println(this.value);
    }
   }

   public class TestBuilder {
     public static void main(String[] args) {
        new Builder().setValue(10).increment().printValue(); // 出力: 11
     }
   }
   ```

### コンストラクタからコンストラクタを呼ぶ際の注意点

- Java では、`this()` によりオーバーライドしたコンストラクタを呼び出す
- `this()` 呼び出しは、呼び出し元のコンストラクタの最初、つまり他のどんなステートメントよりも先に位置しなければならない

```java
public class MyClass {
  private int x;
  private int y;

  public MyClass() {
    this(0, 0);  // 他のコンストラクタを最初に呼び出す
  }

  public MyClass(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
```

もし、`this()` の前に他のステートメントがある場合、コンパイルエラーとなる。

```java
public class MyClass {
  private int x;
  private int y;

  public MyClass() {
    System.out.println("ハロー"); // このステートメントの後で this(int, int) を呼び出そうとする
    this(10, 20); // コンパイラエラー: Constructor call must be the first statement in a constructor
  }

  public MyClass(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void display() {
    System.out.println("X: " + x + ", Y: " + y);
  }
}
```

### ローカル変数とフィールド変数の名前衝突に注意

- メソッド内でローカル変数とフィールド変数が同じ名前を持つ場合、**ローカル変数が優先される**
- これは「シャドーイング」と呼ばれる現象
- メソッド内のスコープで定義された変数が外部のスコープの変数を隠蔽する
- この状況を避けるためには、`this` キーワードを使用してクラスレベルのフィールドに明確にアクセスする

```java
public class ShadowTest {
  private int x = 0;

  public void setX(int x) {
    this.x = x;  // 'this.x' はフィールド、'x' はローカル変数
  }

  public int getX() {
    return x;  // ここで 'x' はフィールド 'this.x' を指す
  }
}
```

**フィールド変数を明示する必要があるときは、必ず `this` をつけるようにする。**

## 「モノとモノとの関係性を定義していくことでシステムを作り上げる」って？

- OOP では、システムを小さなモノ（クラス）に分割し、各クラスが特定の機能を持つことで全体の複雑さを管理する
- 異なるクラスのインスタンスが互いに協力し合いながら動作することで、大きな機能を実現する

### ショッピングシステムを例に考える

システムには最低でも以下の 3 クラスが必要。

- 顧客
- 商品
- 注文

#### クラスの定義

1. **Product（商品）クラス**

- 商品に関する情報を持つ
- フィールド：商品名、価格
- メソッド：商品情報の表示

```java
public class Product {
 private String name;
 private double price;

 public Product(String name, double price) {
   this.name = name;
   this.price = price;
 }

 public void display() {
   System.out.println(name + ": $" + price);
 }
}
```

2. **Customer（顧客）クラス**

   - 顧客に関する情報を持つ
   - フィールド：顧客名、顧客 ID
   - メソッド：顧客情報の表示

   ```java
   public class Customer {
    private String name;
    private int id;

    public Customer(String name, int id) {
      this.name = name;
      this.id = id;
    }

    public void display() {
      System.out.println("Customer ID: " + id + ", Name: " + name);
    }
   }
   ```

3. **Order（注文）クラス**

   - 注文に関する情報を持ち、顧客と商品のインスタンスを管理する
   - フィールド：顧客インスタンス、商品インスタンスリスト
   - メソッド：注文商品の追加、注文情報の表示、合計金額の計算

   ```java
   import java.util.ArrayList;
   import java.util.List;

   public class Order {
     private Customer customer;
     private List<Product> products = new ArrayList<>();

     public Order(Customer customer) {
        this.customer = customer;
     }

     public void addProduct(Product product) {
        products.add(product);
     }

     public void displayOrder() {
       customer.display();
       for (Product product : products) {
          product.display();
       }
     }

     public double getTotalPrice() {
       double total = 0;
       for (Product product : products) {
          total += product.price;
       }
       return total;
     }
   }
   ```

#### システムの使用

```java
public class ShoppingSystem {
  public static void main(String[] args) {
    Customer customer = new Customer("John Doe", 1);
    Product apple = new Product("Apple", 0.75);
    Product bread = new Product("Bread", 1.50);

    Order order = new Order(customer);
    order.addProduct(apple);
    order.addProduct(bread);

    order.displayOrder();  // 注文情報と顧客情報を表示
    System.out.println("Total Price: $" + order.getTotalPrice());  // 合計金額を表示
  }
}
```

`Order` クラスは `Customer` クラスと `Product` クラスのインスタンスを使用し、注文の詳細を管理している。
このようにして、OOP では複数のクラスが連携して全体の機能を形成する。

## カプセル化

- **外部クラスからのフィールドやメソッド、自クラスへのアクセスを制御すること**
- `private` や `public`、`protected` などの「アクセス修飾子」を使用する

### 目的

- オブジェクトの詳細な実装を隠蔽する
- オブジェクトのデータ（フィールド）を保護し、外部からの不適切な使用を防ぐ
- ミス・悪意によるフィールドの書き換えや意図せぬ用途でメソッドが起動することを防ぐ

### アクセス修飾子

クラス、フィールド、メソッド、コンストラクタへのアクセスを制御するために使用する。
アクセス修飾子によって、クラスのメンバ（フィールドやメソッドなど）へのアクセスをクラス内部、パッケージ内部、サブクラス、またはすべての場所から許可するかを制限できる。

1. **`public`**
   - どのクラスからでもアクセス可能
   - 一般的に、API など外部に公開するメソッドやフィールドに使用される
2. **`private`**
   - 自クラス内部からのみアクセス可能
   - 他のクラスから存在を隠す
   - 他クラスからの変更・参照ができなくなる
   - **基本的に、フィールドには `private` をつける**
3. **`protected`**
   - 同じパッケージ内のクラスや、異なるパッケージに属するサブクラスからアクセス可能
4. **無指定（デフォルト）**
   - 同じパッケージ内のクラスからのみアクセス可能
   - パッケージ内部でのみ使用されるクラスやメンバに適用する

### アクセス用メソッド（getter と setter）

- `private` なフィールドには外部から参照・変更できるような専用メソッドを必要に応じて提供する必要がある
- このメソッドを **「アクセス用メソッド」** と呼び、参照用メソッドを **「getter」**、代入用メソッドを **「setter」** と呼ぶ

:::details getter

- クラスのプライベートフィールドの値を取得するために使用する
- 通常、メソッドは引数を取らず、フィールド値を返す
- **メソッド名は通常 `get` で始まり、その後にフィールド名が続く**

```java
public class Person {
  private String name;  // プライベートフィールド

  // ゲッターメソッド
  public String getName() {
      return name;
  }
}
```

:::

:::details setter

- クラスのプライベートフィールドに値を設定するために使用する
- 通常、設定したい値を引数として受け取り、フィールドの値を更新する
- **メソッド名は `set` で始まり、その後にフィールド名が続く**

```java
public class Person {
  private String name;  // プライベートフィールド

  // セッターメソッド
  public void setName(String newName) {
    this.name = newName;
  }
}
```

:::

:::details getter と setter は「インターフェース的な役割」を果たす

- getter と setter はクラスのフィールドへのアクセスを提供する「インターフェース的な役割」を果たす
- これにより、クラスの内部実装とクラスを使用するコードとの間に抽象的な境界が作られ、クラスのフィールドがどのように使用されるかを厳密にコントロールできるようになる

「インターフェース的な役割」の概要として、

1. **隠蔽と抽象化**
   - getter と setter は、クラスのフィールドに直接アクセスする代わりに、それらを操作するための公式な手段を提供する
   - これにより、フィールドのデータ型が変更されたり、内部の実装が変更されたりしても、クラスの使用方法は変わらない
   - このような抽象化は、クラスの利用者にとっては実装の詳細を意識することなく、一貫したインターフェースを通じてクラスとやり取りできることを意味する
2. **データ整合性の保証**
   - 設定しようとしているデータがクラスのルールや制約に適合しているかどうかを確認するロジックを実装できる
   - 例：年齢を表すフィールドに負の数を設定することを防ぐためのチェックを setter に追加する
   - この方法により、クラスの状態が常に妥当であることを保証する
3. **柔軟なアクセス制御**
   - getter と setter を通じてフィールドへのアクセスを管理することで、読み取り専用や書き込み専用といったアクセスレベルの制御が容易になる
   - 特定のフィールドに対して getter メソッドのみを提供することで、そのフィールドを読み取り専用にすることができる

```java
public class Employee {
  private String name;
  private int age;

  // name のゲッター
  public String getName() {
    return name;
  }

  // name のセッター
  public void setName(String name) {
    this.name = name;
  }

  // age のゲッター
  public int getAge() {
    return age;
  }

  // age のセッター
  public void setAge(int age) {
    if (age >= 0) {
      this.age = age;
    } else {
      throw new IllegalArgumentException("Age cannot be negative");
    }
  }
}
```

:::

### アクセス修飾子を付与する対象

アクセス修飾子によるアクセス制限が可能なものは以下の 3 つ

- クラス
- フィールド
- メソッド（コンストラクタも含む）

#### クラスに付与可能なアクセス修飾子

| アクセス修飾子 | 説明                                   |
| -------------- | -------------------------------------- |
| `public`       | どこからでもアクセス可能               |
| 無指定         | 同一パッケージ内からのアクセスのみ可能 |

#### メンバに使用可能なアクセス修飾子

| アクセス修飾子 | 説明                                              |
| -------------- | ------------------------------------------------- |
| `public`       | （`public` クラスの場合）どこからでもアクセス可能 |
| `protected`    | 同パッケージ内とサブクラスからアクセス可能        |
| 無指定         | 同パッケージ内からのアクセスのみ可能              |
| `private`      | 同クラス内からのアクセスのみ可能                  |

### `main` メソッドが `public` である理由

- `main` メソッドあアプリケーションのエントリーポイント
- JVM から呼び出される
- JVM 自体はクラスの外にあるため、`public` である必要がある

### カプセル化の利点

1. **データ隠蔽**
   - クラス内のフィールドはプライベート（`private`）として宣言し、クラス外部から直接アクセスされないよう制限する
   - オブジェクトの状態が不正な方法で変更されないようにする
2. **インターフェースの提供**
   - オブジェクトとのやり取りは、公開されている（`public`な）メソッドを通じてのみ行う
   - パブリックなメソッドは「インターフェース」として機能し、オブジェクトの内部ロジックやデータ構造が変更されても、使用方法に影響を与えない
3. **再利用性とメンテナンスの容易さ**
   - カプセル化されたコードは他のプロジェクトで再利用しやすい
   - 内部実装を変更しても公開インターフェースが保持される限り、既存のコードに影響を与えない
   - ソフトウェアのメンテナンスが容易になる

## 継承

### 概要

- 既存クラスのメンバを受け継いで別のクラスを作成すること
- 継承により、**コードの再利用** が促進され、プログラムの構造がより自然で理解しやすくなる
- 継承元となるクラスを **「スーパークラス」** という
- 継承先となるクラスを **「サブクラス」** という
- サブクラスはスーパークラスのメソッドをオーバーライド（再定義）したり、新規メソッドやプロパティを追加できる

### 構文

```java
class サブクラス名 extends スーパークラス名 {}
```

以下の例は、基本的なフィールドとメソッドを持つ `Vehicle` クラスから、`Car` と `Bike` クラスを派生させる。

```java
class Vehicle {
  protected int speed; // 速度を表すフィールド

  public Vehicle() {
    this.speed = 0;  // 初期速度は0
  }

  public void move() {
    this.speed = 10; // 移動すると速度は10になる
    System.out.println("This vehicle is moving at speed: " + speed + " km/h.");
  }
}

class Car extends Vehicle {
  private int fuelLevel; // 燃料レベルを表すフィールド

  public Car() {
    this.fuelLevel = 100; // 初期燃料レベルは100
  }

  public void honk() {
    System.out.println("The car is honking: Beep beep!");
  }

  public void refuel(int amount) {
    this.fuelLevel += amount; // 燃料を追加する
    System.out.println("Fuel level after refuel: " + fuelLevel);
  }
}

class Bike extends Vehicle {
  private boolean isElectric; // 電動バイクかどうかを表すフィールド

  public Bike() {
    this.isElectric = false; // 初期設定では非電動
  }

  public void pedal() {
    this.speed += 5; // ペダルをこぐと速度が5 km/h増加する
    System.out.println("The bike is pedaling at speed: " + speed + " km/h.");
  }

  public void switchToElectricMode() {
    this.isElectric = true; // 電動モードに切り替える
    System.out.println("Electric mode activated.");
  }
}
```

### 継承の利点

- ソースコードの重複を防ぐ
- 機能拡張が容易になる
- プログラム構造の理解が容易になる
- 仕様変更への対応が容易になる

### Java では単一継承のみ

- Java では単一継承のみ認められている
- 1 つのクラスが複数のスーパークラスを持つことはできない
- **階層的な継承**は可能

### スーパークラスのメンバへアクセスする

サブクラスからスーパークラスのメンバへアクセスする手法は様々ある。

:::details 変数名を指定して直接アクセスする

スーパークラスが `public` や `protected` で定義したメンバは、サブクラスから直接アクセス可能。

```java
class Parent {
  protected int value = 100;

  public void hello() {
    System.out.println("Hello");
  }
}

class Child extends Parent {
  void display() {
    System.out.println(value);  // 直接アクセス
    hello(); // 直接アクセス
  }
}
```

ただ、この方法は**ローカル変数との名前衝突のリスクがあるため、非推奨**。

:::

:::details this キーワードを使用して直接参照する

自クラスのメンバへアクセスするときと同様に、`this` を使用してスーパークラスのメンバへアクセスする。

```java

class Parent {
  protected int value = 100;

  public void hello() {
    System.out.println("Hello");
  }
}

class Child extends Parent {
  void display() {
    System.out.println(this.value);
    this.hello();
  }
}

```

ただし、サブクラスに同じ名前のメンバが存在した場合、サブクラスが優先されてしまう。

```java
class Parent {
  protected int value = 100;

  public void hello() {
    System.out.println("Hello");
  }
}

class Child extends Parent {
  protected int value = 200;

  void display() {
    System.out.println(this.value);  // 200
    this.hello();
  }
}
```

:::

:::details super キーワードを使用して直接参照する

`super` キーワードを使用することで、サブクラスの `value` ではなく、隠蔽されたスーパークラスの `value` へアクセス可能。

```java
class Parent {
  protected int value = 100;

  public void hello() {
    System.out.println("Hello");
  }
}

class Child extends Parent {
  protected int value = 200;

  void display() {
    System.out.println(super.value);  // 100
    super.hello();
  }
}
```

**スーパークラスのメンバへアクセスする際は、`super` キーワードを使用が推奨。**

:::

:::details getter、setter を介したアクセス

- スーパークラスのメンバが `private` な場合、`super` などによる直接のアクセスが不可能
- よって、getter や setter を通じて間接的にアクセスする
- これにより、スーパークラスのカプセル化を維持しつつ、サブクラスからの安全なアクセスが可能となる

```java
class Parent {
  protected int value = 100;

  protected int getValue() { // getter
    return this.value;
  }

  public void hello() {
    System.out.println("Hello");
  }
}

class Child extends Parent {
  protected int value = 200;

  void display() {
    System.out.println(super.getValue());  // 100
    super.hello();
  }
}
```

:::

:::details ベストプラクティス

1. **フィールドは `private` にしておく**

   - クラスのデータをカプセル化し、クラス外部から直接アクセスされるのを防ぐ
   - これにより、フィールドの値が予期しない方法で変更されることを防ぐ
   - 将来的にクラス内部の実装を変更しても、公開インターフェースに影響を与えることが少なくなる

2. **フィールドへの直接的なアクセスはせず、getter や setter を使用する**
   - フィールドへのアクセスを抽象化する
   - これにより、フィールドの値を取得・設定する際の追加のロジックを容易に実装できる
   - 例: バリデーションチェック、イベントのトリガー
3. **スーパークラスのメンバへ直接アクセスする際は、`super` を使用する**
   - サブクラスで定義したフィールドとの名前衝突を避けるため

:::

### `final` キーワードで継承を禁止する

クラスを `final` で宣言すると、そのクラスは継承できなくなる。

```java
public final class Calculator {
  public int add(int a, int b) {
    return a + b;
  }
}

// このクラスはコンパイルエラーになる
class AdvancedCalculator extends Calculator {
  // エラー: Cannot inherit from final 'Calculator'
}
```

### 継承とコンストラクタ、`super()`

:::details スーパークラスのコンストラクタはサブクラスには継承されない

- コンストラクタはそのクラス固有の特殊なメソッド
- インスタンス化の際にフィールドに対して初期値を設定するのは該当クラスのコンストラクタ
  :::

:::details サブクラスでスーパークラスのコンストラクタを呼び出す

- サブクラスのコンストラクタで `super()` を使用し、スーパークラスのコンストラクタを呼び出す必要がある
- `this()` を使用して自クラスのコンストラクタを呼び出すイメージ

```java
class Parent {
  int x;

  Parent(int x) {
    this.x = x;
    System.out.println("Parent constructor called.");
  }
}

class Child extends Parent {
  int y;

  Child(int x, int y) {
    super(x);  // Parentのコンストラクタを呼び出す
    this.y = y;
    System.out.println("Child constructor called.");
  }
}
```

上記は、`Child` クラスのコンストラクタが `super(x)` により `Parent` クラスのコンストラクタを呼び出している。
これにより、`Parent` クラスの `x` が適切に初期化され、その後 `y` が設定される。

:::

:::details コンストラクタは上位クラスから順に呼び出す必要がある
継承関係を持つクラスをインスタンス化する際、コンストラクタの呼び出し順序は、スパークラス → 　サブクラスへと階層的に行われる必要がある。
インスタンスを作成する際、以下のステップに従ってコンストラクタが呼び出される。

1. **スーパークラスのコンストラクタの呼び出し**
   - 最も上位のスーパークラス（Object クラスを除く）のコンストラクタが最初に呼び出される
   - これにより、クラス階層の基礎となる部分が最初に初期化される
2. **サブクラスのコンストラクタの実行**
   - スーパークラスのコンストラクタの実行が完了すると、次に下位のクラスのコンストラクタが順に実行さる

### なぜこの順序が必要か？

- サブクラスのコンストラクタでスーパークラスのフィールドを使用する場合、そのフィールドが正しく設定されている必要がある
- クラス間の継承は、サブクラスがスーパークラスの機能を「拡張」するという契約に基づいており、そのためにも、スーパークラスの状態がサブクラスの機能によって予期せず変更される前に、完全に初期化されている必要がある

:::

:::details super() はコンストラクタ内の先頭で呼び出す

- `super()` の呼び出しはコンストラクタの**最初のステートメント**である必要がある
- この規則は言語仕様によって強制されている

**正しい記述**

```java
public ChildClass(int value) {
  super(value);  // スーパークラスのコンストラクタを最初に呼び出す
  // その他の初期化コード
}
```

**誤った記述**

```java
public ChildClass(int value) {
  someInitialization();  // スーパークラスのコンストラクタ呼び出し前に他の初期化を行う（エラー）
  super(value);  // コンパイルエラーが発生する
}
```

:::

:::details 1 つのコンストラクタ内で super() や this() を 2 つ以上使用できない

- `super()` はコンストラクタ内の最初のステートメントで呼び出す必要がある
- `this()` はコンストラクタ内の最初のステートメントで呼び出す必要がある

上記 2 点の制約から、同一コンストラクタ内では `super()`、`this()` のうち 1 つのみしか呼び出せない。

```java
class Parent {
  Parent() {
    System.out.println("Parent Constructor");
  }
}

class Child extends Parent {
  Child() {
    super();  // スーパークラスのコンストラクタを呼び出す
    System.out.println("Child Constructor");
  }

  Child(String msg) {
    this();  // 同じクラスの別のコンストラクタを呼び出す
    System.out.println("Child Constructor with message: " + msg);
  }
}

public class Main {
  public static void main(String[] args) {
    Child child = new Child("Hello");
  }
}
```

上記の場合、以下の手順でコードが実行される。

1. `Child` クラスのインスタンス化の際に `Child(String msg)` が呼び出される
2. このコンストラクタでは、最初のステトメントに `this()` の記述があるため、`Child()` が呼び出される
3. `Child()` では `super()` の記述があるため、`Parent()` が呼び出される

:::

:::details super() を明示的に呼び出さない場合
サブクラスのコンストラクタで `super()` を明示的に呼び出さなかった場合、処理の先頭で**暗黙的に** `super()` （引数なし）が実行される。

```java
class Parent {
 int x;

 Parent() {
  this.x = 10;
  System.out.println("Parent Constructor: x = " + x);
 }
}

class Child extends Parent {
 int y;

 Child() {
  // super(); がここに暗黙的に挿入される
  this.y = 20;
  System.out.println("Child Constructor: y = " + y);
 }
}
```

:::

### オーバーライド

- スーパークラスのメソッドを、サブクラス側で同じ名前で再定義すること
- オーバーライドされたメソッドは、スーパークラスのメソッドを隠蔽する
- サブクラスのインスタンスでそのメソッドがよびだされると、オーバーライドした内容で処理される

:::details オーバーライドのルール

1. **メソッドシグネチャの一致**
   - メソッド名と引数がスーパークラス側のメソッドと一致している必要がある
2. **アクセス修飾子**
   - スーパークラスのメソッドと同じ or より公開度が高い
   - 例：`protected` → 　`public` は可能、`public` → 　`protected` は不可
3. **戻り値の型**
   - スーパークラスのメソッドと同じ or そのサブタイプ

:::

:::details 使用例

```java
class Animal {
  public void eat() {
    System.out.println("This animal eats food.");
  }
}

class Dog extends Animal {
    public void eat() {
      System.out.println("Dog eats bones.");
    }
}

public class Main {
  public static void main(String[] args) {
    Animal myAnimal = new Animal();
    myAnimal.eat();  // Outputs: This animal eats food.

    Dog myDog = new Dog();
    myDog.eat();  // Outputs: Dog eats bones.

    Animal myAnimalDog = new Dog();
    myAnimalDog.eat();  // Outputs: Dog eats bones.
  }
}

```

- `Dog` クラスが `Animal` クラスの `eat()` メソッドをオーバーライドしている
- `Dog` のインスタンスでは、`eat()` が呼ばれると、オーバーライドした `Dog` の `eat()` が実行される

:::

:::details @Override アノテーション

- `@Override` アノテーションは、特定のメソッドがスーパークラスのメソッドをオーバーライドする意図であることを明示的に示すために使用する
- コンパイラに対してそのオーバーライドであることを確認するよう指示するもの
- **もしスーパークラスに同じシグネチャを持つメソッドが存在しない場合、コンパイラはエラーを生成する**

### 利点

1. **コンパイル時の安全性の確保**
   - `@Override` アノテーションを使用することで、メソッドが正しくオーバーライドされているかをコンパイルが検証する
   - これにより、プログラマのミスやリファクタリングによる問題を事前に検出できる
2. **コードの可読性向上**
   - アノテーションをメソッドに付けることで、他のプログラマがコードを読む際にそのメソッドがオーバーライドされたものであることをすぐに理解できる
   - 特に大きなプロジェクトや多数のクラスが関与する場合に有効
3. **意図的なエラーの発見**
   - スーパークラスのメソッドが削除されたり、シグネチャが変更されたりした場合に、`@Override` アノテーションがついたメソッドはコンパイルエラーを引き起こす

### 使用例

```java
class Animal {
  public void eat() {
    System.out.println("This animal eats food.");
  }
}

class Dog extends Animal {
  @Override
  public void eat() {
    System.out.println("Dog eats bones.");
  }
}
```

- `Doc` クラスの `eat()` メソッドに `@Override` アノテーションを使用している
- もし、`Animal` クラスに `eat()` が存在しなかったり、シグネチャが異なってればコンパイルエラーとなる

:::

:::details final キーワードでオーバーライドを禁止する

スーパークラスのメソッドに `final` キーワードを付けると、そのメソッドはオーバーライドできなくなる。

```java
class Parent {
  public final void show() {
    System.out.println("This method cannot be overridden.");
  }
}

class Child extends Parent {
  // この試みはエラーを引き起こします。
  @Override
  public void show() {
    System.out.println("Trying to override.");
  }
}
```

上記では、`Parent` クラスの `show()` が `final` として宣言されているため、`Child` クラスでオーバーライドしようとするとコンパイルエラーが発生する。

:::

### アクセス修飾子 `protected`

以下のいずれかに該当するクラスはアクセス可能。

- 同一パッケージ
- サブクラス

`public` よりも制限的で、`private` よりも広範。

```java
package com.example.animals;

public class Animal {
  protected int age;

  protected void eat() {
    System.out.println("This animal eats food.");
  }
}

package com.example.animals;

public class Dog extends Animal {
  public void displayAge() {
    System.out.println("The dog's age is " + age);  // 直接アクセス可能
  }

  @Override
  protected void eat() {
    super.eat();  // スーパークラスの protected メソッドにアクセス
    System.out.println("Dog eats bones.");
  }
}
```

`Doc` クラスは `Animal` クラスと同一パッケージだが、異なるパッケージでも継承関係にあるため、`eat()` メソッドへアクセス可能。

## クラスオブジェクト・インスタンスオブジェクト・静的メンバ（`static`）

### クラスオブジェクト

- クラスそのものを表すオブジェクト
- インスタンスの元となるファイル情報を格納しているメモリ領域
- Java の実行において、ファイルの読み込みの際に JVM によってメモリ上に自動生成される

### インスタンスオブジェクト

- インスタンスのこと
- `new` キーワードを使用してクラスから生成される具体的なオブジェクト
- これは実際のデータ（フィールド）を持ち、メソッドを具体的に実行できる

### 静的メンバ（`static`）

- クラスオブジェクトに属するメンバ
- 任意のインスタンスには属さない
- **静的メンバは全てのインスタンス間で共有され、インスタンスを生成しなくてもアクセスできる**

静的メンバは `static` キーワードを使用して定義する。

```java
public class Counter {
  private static int count = 0; // 静的フィールド

  public Counter() {
    count++; // インスタンスごとにカウントアップ
  }

  public static int getCount() { // 静的メソッド
    return count;
  }
}

public class Main {
  public static void main(String[] args) {
    Counter counter1 =　new Counter();
    Counter counter2 = new Counter();

    System.out.println(Counter.getCount()); // 2
    System.out.println(counter1.getCount()); // 2
    System.out.println(counter2.getCount()); // 2
  }
}
```

- `Counter` クラスが持つ静的フィールド `count` が、クラスの全てのインスタンスによって共有される
- `Conter` クラスがインスタンス化され、コンストラクタが実行される度、静的フィールド `count` が +1 される
- `count` はクラスオブジェクトで管理されているため、`counter1` と `counter2` で共有される

## 抽象クラス（`abstract`）

- **仕様のみを定義した継承前提のクラス**
- 「このクラスを継承したサブクラスには〇〇というメソッドがあるべきだ」を定義したクラス
- インスタンス化されて使用されることを想定していないため、**インスタンス化しようとするとコンパイルエラーになる**
- 他のクラスが抽象クラスを継承し、具体的な実装を提供する
- `abstract` 修飾子を付与することで抽象クラスとなる

:::details 特徴

1. **インスタンス不可**
   - 抽象クラスは直接インスタンス化できない
   - 抽象クラスは完全に実装されていないため、インスタンスが機能的に不完全であるから
2. **継承用**
   - 抽象クラスの目的は継承
   - サブクラスは抽象クラスから継承し、未実装の抽象メソッドを実装する
3. **設計のテンプレート提供**
   - 特定の基本機能を提供しつつ、詳細な実装はサブクラスに委ねることで、設計のテンプレートとして機能する
   - これにより、一貫性のあるインターフェースを保ちつつ、柔軟な実装が可能
4. **抽象メソッドはオーバーライド前提**
   - 抽象メソッドをオーバーライドしないとコンパイルエラーとなる
   - 抽象メソッドをオーバーライドし、具体的な処理を定義することを「実装」と呼ぶ
5. **抽象クラス内のフィールド**
   - 通常のクラスと同様に、フィールドや静的フィールドを含むことができる
6. **抽象クラス内の通常メソッド**
   - 抽象クラスは完全に抽象メソッド（未実装のメソッド）だけで構成される必要はない

:::

:::details 実装例

```java
public abstract class Vehicle {
  protected int speed;  // フィールド

  public void setSpeed(int speed) {  // 通常のメソッド
    this.speed = speed;
  }

  public abstract void move();  // 抽象メソッド
}

public class Car extends Vehicle {
  @Override
  public void move() {
    System.out.println("Car moves at speed: " + speed + " km/h");
  }
}

public class Main {
  public static void main(String[] args) {
    Vehicle myCar = new Car();
    myCar.setSpeed(60);
    myCar.move();  // 出力: Car moves at speed: 60 km/h
  }
}
```

上記は、`Vehicle` という抽象クラスが定義されており、`move()` という抽象メソッドを持っている。
`Doc` クラスはこの抽象クラスを継承し、具体的な `move()` メソッドを実装している。

:::

## 可変長引数

- メソッドが不特定多数の引数を受け取れるようにするための機能
- 可変長引数を使用すると、配列を渡すのと同じように、0 個以上の引数を渡すことができる

### 可変長引数の定義

可変長引数は、メソッドのパラメータリストの最後に `...` を使用して定義する。

```java
public class VarargsExample {
    public static void printNumbers(int... numbers) {
        for (int number : numbers) {
            System.out.println(number);
        }
    }

    public static void main(String[] args) {
        // 可変長引数メソッドの呼び出し
        printNumbers(1, 2, 3); // 出力: 1 2 3
        printNumbers(10, 20);  // 出力: 10 20
        printNumbers();        // 出力なし
    }
}
```

### 注意点

- 可変長引数は、メソッドの最後のパラメータでなければならない
  ```java
  public void exampleMethod(String fixedParam, int... varargs) {
      // 実装
  }
  ```
- 可変長引数を使うメソッドをオーバーロードする場合は、注意が必要
- 曖昧さを避けるために、特定の引数リストのメソッドを先に定義するのが一般的

```java
public class VarargsExample {
    public static void printNumbers(int number) {
        System.out.println("Single number: " + number);
    }

    public static void printNumbers(int... numbers) {
        for (int number : numbers) {
            System.out.println("Number: " + number);
        }
    }

    public static void main(String[] args) {
        printNumbers(1);       // Single number: 1
        printNumbers(1, 2, 3); // Number: 1 Number: 2 Number: 3
    }
}
```
