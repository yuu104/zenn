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
   - **「フィールド」**とも呼ぶ
2. **機能**
   - クラス内で定義された**関数**
   - **「メソッド」**とも呼ぶ

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

### コンストラクタは複数指定可能（バーバーロード）

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

## デフォルトコンストラクタ

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

#### getter

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

#### setter

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

#### getter と setter は「インターフェース的な役割」を果たす

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

### アクセス修飾子を付与する対象

アクセス修飾子によるアクセス制限が可能なものは以下の 3 つ

- クラス
- フィールド
- メソッド（コンストラクタも含む）

#### クラスに付与可能なアクセス修飾子

| アクセス修飾子 | 説明                                   |
| -------------- | -------------------------------------- |
| `public`       | どこからでもアクセス可能               |
| 無指定         | どうパッケージ内からのアクセスのみ可能 |

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
