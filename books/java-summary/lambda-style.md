---
title: "ラムダ式"
---

## 概要

- 関数型プログラミングの要素を取り入れ、コードの簡潔さと可読性を向上させるための機能
- **関数型インターフェースに対して使用する**
- 主にコレクション操作やイベントハンドリングでの冗長なコードを減らすことを目的としている

## 目的・解決したい技術的課題

- 冗長な匿名クラスの記述を簡略化する
- コレクション操作をより直感的に記述する
- コードの可読性とメンテナンス性を向上させる

## ラムダ式の基本構文

- `(引数) -> {処理}`
- 引数の型は省略可能。単一の引数の場合は括弧も省略可能
- 処理が単一の式の場合、波括弧と return 文も省略可能

## 使用例

1. **匿名クラスの代替**

   ```java
   // 匿名クラス
   Runnable runnable = new Runnable() {
       @Override
       public void run() {
           System.out.println("Hello, world!");
       }
   };

   // ラムダ式
   Runnable runnable = () -> System.out.println("Hello, world!");
   ```

2. **コレクション操作**

   ```java
   List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

   // 名前のリストを大文字に変換
   List<String> upperCaseNames = names.stream()
                                       .map(name -> name.toUpperCase())
                                       .collect(Collectors.toList());
   ```

3. **イベントハンドリング**

   ```java
   Button button = new Button("Click me");

   // 匿名クラス
   button.setOnAction(new EventHandler<ActionEvent>() {
       @Override
       public void handle(ActionEvent event) {
           System.out.println("Button clicked!");
       }
   });

   // ラムダ式
   button.setOnAction(event -> System.out.println("Button clicked!"));
   ```

## ラムダ式のメリット

- **簡潔さ**
  コード量を大幅に減らし、読みやすくする。
- **可読性**
  意図が明確になり、他の開発者が理解しやすくなる。
- **関数型プログラミング**
  コレクションの操作やイベントハンドリングがより直感的に記述可能。

## 関数型インターフェース

ラムダ式は関数型インターフェースとともに使用される。関数型インターフェースは、抽象メソッドが 1 つだけあるインターフェース。

### 例

- **java.lang.Runnable**: `void run()`
- **java.util.function.Predicate<T>**: `boolean test(T t)`
- **java.util.function.Consumer<T>**: `void accept(T t)`

### 使用例

1. **Predicate**

   ```java
   Predicate<String> isEmpty = s -> s.isEmpty();
   boolean result = isEmpty.test("");  // true
   ```

2. **Consumer**
   ```java
   Consumer<String> printer = s -> System.out.println(s);
   printer.accept("Hello");  // Hello
   ```

## ラムダ式はキャプチャした変数を「効果的に final」でなければならない

Java のラムダ式は、スコープ内の変数をキャプチャ（参照）することができますが、その変数は「効果的に final」でなければなりません。これは、ラムダ式がキャプチャする変数が実際に`final`でなくても、その変数が変更されないことを意味します。

### 効果的に final とは

「効果的に final」とは、その変数が一度初期化された後に再代入されないことを指します。実際に`final`キーワードを付けていない場合でも、再代入が行われていなければ、その変数は「効果的に final」と見なされます。

### 例

```java
public class Demo {
    public static void main(String[] args) {
        String greeting = "Hello";

        // このラムダ式は効果的に final な変数をキャプチャ
        Runnable r = () -> System.out.println(greeting);

        r.run();  // Hello

        // greeting に再代入しない限り、効果的に final である
        // greeting = "Hi";  // これを有効にするとコンパイルエラーになる
    }
}
```

上記の例では、`greeting`は初期化後に再代入されていないため、「効果的に final」と見なされます。そのため、ラムダ式内でキャプチャすることができます。

### 効果的に final でない場合の例

```java
public class Demo {
    public static void main(String[] args) {
        String greeting = "Hello";

        // greeting に再代入する
        greeting = "Hi";

        // ラムダ式内でキャプチャしようとするとコンパイルエラー
        Runnable r = () -> System.out.println(greeting);

        r.run();  // コンパイルエラー
    }
}
```

上記の例では、`greeting`に再代入が行われているため、効果的に final ではありません。この場合、ラムダ式内で`greeting`をキャプチャしようとするとコンパイルエラーが発生します。

### ルールと理由

- **ルール**: ラムダ式がキャプチャする変数は「効果的に final」でなければならない。
- **理由**: これはスレッドセーフ性と予測可能な動作を保証するため。ラムダ式が複数のスレッドから同時にアクセスされる場合、変数の再代入が競合条件を引き起こす可能性があるため、Java はこれを禁止している。

### 実際の使用例

以下の例では、効果的に final な変数を使ったラムダ式の典型的な使い方を示します。

```java
import java.util.function.Consumer;

public class Demo {
    public static void main(String[] args) {
        String greeting = "Hello";
        Consumer<String> greeter = name -> System.out.println(greeting + ", " + name);

        greeter.accept("Alice");  // Hello, Alice
    }
}
```

この例では、`greeting`変数がラムダ式内でキャプチャされ、`Consumer`インターフェースの`accept`メソッドで使用されています。`greeting`変数は再代入されていないため、「効果的に final」であり、コンパイルエラーは発生しません。

### まとめ

- **効果的に final とは**: 変数が初期化された後に再代入されないこと。
- **ラムダ式でのキャプチャ**: ラムダ式がキャプチャする変数は「効果的に final」でなければならない。
- **理由**: スレッドセーフ性と予測可能な動作を保証するため。

この制約を理解し、適切に管理することで、Java のラムダ式を効果的に利用することができます。

## 注意点

- ラムダ式はキャプチャした変数を「効果的に final」でなければならない。
- 複雑なロジックをラムダ式に詰め込むと、かえって可読性が低下するため、適切なバランスが必要。
