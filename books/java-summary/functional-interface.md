---
title: "関数型インターフェース"
---

## 目的

関数型インターフェースは、Java においてラムダ式やメソッド参照を使って、コードをより簡潔で明瞭に記述するための仕組みです。これにより、コードの可読性とメンテナンス性が向上します。

## 定義

関数型インターフェースとは、1 つの抽象メソッドを持つインターフェースのことです。これにより、そのインターフェースのインスタンスをラムダ式やメソッド参照として扱うことができます。

## シグネチャ

```java
@FunctionalInterface
public interface インターフェース名 {
    抽象メソッドのシグネチャ;
}
```

## Java SE で提供されている関数型インターフェース

:::details Runnable ~ スレッドで実行されるタスクを表す

`Runnable`は、スレッドで実行されるタスクを定義するための関数型インターフェースです。このインターフェースを実装することで、並行処理を行うタスクを簡潔に記述することができます。

#### 詳細な説明

`Runnable`は、1 つの抽象メソッド`run`を持つ関数型インターフェースです。このメソッドにスレッドで実行する処理を記述します。`Runnable`を使うことで、スレッドを作成して実行するタスクを簡潔に記述でき、ラムダ式やメソッド参照を使ってコードをさらに簡潔にできます。

#### シグネチャ

```java
@FunctionalInterface
public interface Runnable {
    void run();
}
```

- **メソッド**: `void run()`
  - スレッドで実行される処理を定義します。

#### 具体例と解説

##### 例 1: 通常の`Runnable`実装

```java
public class Main {
    public static void main(String[] args) {
        Runnable task = new Runnable() {
            @Override
            public void run() {
                System.out.println("Task is running");
            }
        };

        Thread thread = new Thread(task);
        thread.start(); // "Task is running"と表示されます
    }
}
```

- **解説**:
  - `Runnable`を匿名クラスで実装しています。
  - `run`メソッドに実行するタスクを記述しています。
  - `Thread`オブジェクトを作成し、`Runnable`を渡してスレッドを開始しています。

##### 例 2: ラムダ式を使用した`Runnable`実装

```java
public class Main {
    public static void main(String[] args) {
        Runnable task = () -> System.out.println("Task is running");

        Thread thread = new Thread(task);
        thread.start(); // "Task is running"と表示されます
    }
}
```

- **解説**:
  - ラムダ式を使用して`Runnable`を実装しています。
  - `run`メソッドの実装を簡潔に記述できます。
  - スレッドの作成と実行は同じです。

#### 技術的課題の解決

`Runnable`を使用することで、以下の技術的課題が解決できます。

1. **並行処理の簡素化**:

   - `Runnable`を使用することで、並行処理のタスクを簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **可読性の向上**:

   - ラムダ式を使った`Runnable`の実装は、匿名クラスを使うよりも明確で直感的です。コードが短くなり、何を実行しているかが一目でわかります。

3. **柔軟なタスク管理**:
   - `Runnable`インターフェースを使用することで、タスクをスレッドプールに渡したり、並行処理の制御を容易に行うことができます。

### まとめ

`Runnable`は、並行処理を行うための基本的な関数型インターフェースです。スレッドで実行されるタスクを定義するために使われ、ラムダ式を使用することで簡潔かつ明瞭に記述できます。`Runnable`を効果的に利用することで、並行処理をシンプルに実装し、コードの可読性とメンテナンス性を向上させることができます。
**また、スレッドプログラミングに限らず「引数なし、戻り値なし」という宣言を持つ汎用的な関数型インターフェースとしても利用可能です。**

:::

:::details Function<T, R> ~ 引数を受け取り、結果を返す関数を表す

`Function`は、引数を受け取り、結果を返す操作を定義する関数型インターフェースです。このインターフェースを使用することで、変換や計算を行う処理を簡潔に記述できます。

#### 詳細な説明

`Function`は、1 つの抽象メソッド`apply`を持ち、引数を受け取り、結果を返す操作を定義します。このインターフェースを実装することで、変換や計算を行う処理をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface Function<T, R> {
    R apply(T t);
}
```

- **メソッド**: `R apply(T t)`
  - 引数`T`を受け取り、結果`R`を返します。

#### 具体例と解説

##### 例 1: 通常の`Function`実装

```java
public class Main {
    public static void main(String[] args) {
        Function<Integer, String> intToString = new Function<Integer, String>() {
            @Override
            public String apply(Integer i) {
                return Integer.toString(i);
            }
        };

        System.out.println(intToString.apply(5)); // "5"
    }
}
```

- **解説**:
  - `Function`を匿名クラスで実装しています。
  - `apply`メソッドに引数`Integer`を`String`に変換する処理を記述しています。

##### 例 2: ラムダ式を使用した`Function`実装

```java
public class Main {
    public static void main(String[] args) {
        Function<Integer, String> intToString = i -> Integer.toString(i);
        System.out.println(intToString.apply(5)); // "5"
    }
}
```

- **解説**:
  - ラムダ式を使用して`Function`を実装しています。
  - `apply`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`Function`を使用することで、以下の技術的課題が解決できます。

1. **変換処理の簡素化**:

   - `Function`を使用することで、変換処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `Function`インターフェースを使用することで、データの変換や計算を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`Function`は、引数を受け取り、結果を返す操作を定義するための関数型インターフェースです。変換や計算を行う処理を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`Function`を効果的に利用することで、データ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details Consumer<T> ~ 引数を受け取り、結果を返さない操作を表す

`Consumer`は、引数を受け取り、結果を返さない操作を定義する関数型インターフェースです。このインターフェースを使用することで、副作用のある処理を簡潔に記述できます。

#### 詳細な説明

`Consumer`は、1 つの抽象メソッド`accept`を持ち、引数を受け取り、結果を返さない操作を定義します。このインターフェースを実装することで、ログ出力やデータの更新などの副作用のある処理をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}
```

- **メソッド**: `void accept(T t)`
  - 引数`T`を受け取り、結果を返さずに処理を行います。

#### 具体例と解説

##### 例 1: 通常の`Consumer`実装

```java
public class Main {
    public static void main(String[] args) {
        Consumer<String> print = new Consumer<String>() {
            @Override
            public void accept(String s) {
                System.out.println(s);
            }
        };

        print.accept("Hello"); // "Hello"
    }
}
```

- **解説**:
  - `Consumer`を匿名クラスで実装しています。
  - `accept`

メソッドに引数`String`を出力する処理を記述しています。

##### 例 2: ラムダ式を使用した`Consumer`実装

```java
public class Main {
    public static void main(String[] args) {
        Consumer<String> print = s -> System.out.println(s);
        print.accept("Hello"); // "Hello"
    }
}
```

- **解説**:
  - ラムダ式を使用して`Consumer`を実装しています。
  - `accept`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`Consumer`を使用することで、以下の技術的課題が解決できます。

1. **副作用のある処理の簡素化**:

   - `Consumer`を使用することで、副作用のある処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `Consumer`インターフェースを使用することで、データの処理や更新を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 副作用のある操作をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`Consumer`は、引数を受け取り、結果を返さない操作を定義するための関数型インターフェースです。副作用のある処理を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`Consumer`を効果的に利用することで、データ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details Supplier<T> ~ 引数を受け取らず、結果を供給する操作を表す

`Supplier`は、引数を受け取らずに結果を供給する操作を定義する関数型インターフェースです。このインターフェースを使用することで、値やオブジェクトの生成を簡潔に記述できます。

#### 詳細な説明

`Supplier`は、1 つの抽象メソッド`get`を持ち、引数を受け取らずに結果を供給する操作を定義します。このインターフェースを実装することで、値やオブジェクトの生成をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface Supplier<T> {
    T get();
}
```

- **メソッド**: `T get()`
  - 引数を受け取らずに結果`T`を供給します。

#### 具体例と解説

##### 例 1: 通常の`Supplier`実装

```java
public class Main {
    public static void main(String[] args) {
        Supplier<String> supplier = new Supplier<String>() {
            @Override
            public String get() {
                return "Hello";
            }
        };

        System.out.println(supplier.get()); // "Hello"
    }
}
```

- **解説**:
  - `Supplier`を匿名クラスで実装しています。
  - `get`メソッドに引数を受け取らずに`String`を供給する処理を記述しています。

##### 例 2: ラムダ式を使用した`Supplier`実装

```java
public class Main {
    public static void main(String[] args) {
        Supplier<String> supplier = () -> "Hello";
        System.out.println(supplier.get()); // "Hello"
    }
}
```

- **解説**:
  - ラムダ式を使用して`Supplier`を実装しています。
  - `get`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`Supplier`を使用することで、以下の技術的課題が解決できます。

1. **値やオブジェクトの生成の簡素化**:

   - `Supplier`を使用することで、値やオブジェクトの生成を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ生成**:

   - `Supplier`インターフェースを使用することで、データの生成を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 値やオブジェクトの生成操作をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`Supplier`は、引数を受け取らずに結果を供給する操作を定義するための関数型インターフェースです。値やオブジェクトの生成を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`Supplier`を効果的に利用することで、データ生成の柔軟性とコードの再利用性を向上させることができます。

:::

:::details Predicate<T> ~ 引数を受け取り、真偽値を返す操作を表す

`Predicate`は、引数を受け取り、真偽値を返す操作を定義する関数型インターフェースです。このインターフェースを使用することで、条件判定を簡潔に記述できます。

#### 詳細な説明

`Predicate`は、1 つの抽象メソッド`test`を持ち、引数を受け取り、真偽値を返す操作を定義します。このインターフェースを実装することで、条件判定をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
}
```

- **メソッド**: `boolean test(T t)`
  - 引数`T`を受け取り、真偽値を返します。

#### 具体例と解説

##### 例 1: 通常の`Predicate`実装

```java
public class Main {
    public static void main(String[] args) {
        Predicate<Integer> isEven = new Predicate<Integer>() {
            @Override
            public boolean test(Integer i) {
                return i % 2 == 0;
            }
        };

        System.out.println(isEven.test(4)); // true
    }
}
```

- **解説**:
  - `Predicate`を匿名クラスで実装しています。
  - `test`メソッドに引数`Integer`が偶数かどうかを判定する処理を記述しています。

##### 例 2: ラムダ式を使用した`Predicate`実装

```java
public class Main {
    public static void main(String[] args) {
        Predicate<Integer> isEven = i -> i % 2 == 0;
        System.out.println(isEven.test(4)); // true
    }
}
```

- **解説**:
  - ラムダ式を使用して`Predicate`を実装しています。
  - `test`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`Predicate`を使用することで、以下の技術的課題が解決できます。

1. **条件判定の簡素化**:

   - `Predicate`を使用することで、条件判定を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータフィルタリング**:

   - `Predicate`インターフェースを使用することで、データのフィルタリングを柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 条件判定をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`Predicate`は、引数を受け取り、真偽値を返す操作を定義するための関数型インターフェースです。条件判定を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`Predicate`を効果的に利用することで、データフィルタリングの柔軟性とコードの再利用性を向上させることができます。

:::

:::details BiFunction<T, U, R> ~ 2 つの引数を受け取り、結果を返す関数を表す

`BiFunction`は、2 つの引数を受け取り、結果を返す操作を定義する関数

型インターフェースです。このインターフェースを使用することで、複数の引数を扱う関数を簡潔に記述できます。

#### 詳細な説明

`BiFunction`は、1 つの抽象メソッド`apply`を持ち、2 つの引数を受け取り、結果を返す操作を定義します。このインターフェースを実装することで、複数の引数を受け取る変換や計算をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface BiFunction<T, U, R> {
    R apply(T t, U u);
}
```

- **メソッド**: `R apply(T t, U u)`
  - 2 つの引数`T`と`U`を受け取り、結果`R`を返します。

#### 具体例と解説

##### 例 1: 通常の`BiFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        BiFunction<Integer, Integer, Integer> sum = new BiFunction<Integer, Integer, Integer>() {
            @Override
            public Integer apply(Integer a, Integer b) {
                return a + b;
            }
        };

        System.out.println(sum.apply(2, 3)); // 5
    }
}
```

- **解説**:
  - `BiFunction`を匿名クラスで実装しています。
  - `apply`メソッドに 2 つの引数`Integer`を受け取り、和を返す処理を記述しています。

##### 例 2: ラムダ式を使用した`BiFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        BiFunction<Integer, Integer, Integer> sum = (a, b) -> a + b;
        System.out.println(sum.apply(2, 3)); // 5
    }
}
```

- **解説**:
  - ラムダ式を使用して`BiFunction`を実装しています。
  - `apply`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`BiFunction`を使用することで、以下の技術的課題が解決できます。

1. **複数引数の変換処理の簡素化**:

   - `BiFunction`を使用することで、複数引数の変換処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `BiFunction`インターフェースを使用することで、複数引数のデータ操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`BiFunction`は、2 つの引数を受け取り、結果を返す操作を定義するための関数型インターフェースです。複数引数の変換や計算を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`BiFunction`を効果的に利用することで、複数引数のデータ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details UnaryOperator<T> ~ 引数と同じ型の結果を返す関数を表す

`UnaryOperator`は、引数と同じ型の結果を返す操作を定義する関数型インターフェースです。これは`Function<T, R>`の特殊形です。

#### 詳細な説明

`UnaryOperator`は、1 つの抽象メソッド`apply`を持ち、引数と同じ型の結果を返す操作を定義します。このインターフェースを実装することで、同じ型のデータを変換する処理をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface UnaryOperator<T> extends Function<T, T> {
    T apply(T t);
}
```

- **メソッド**: `T apply(T t)`
  - 引数`T`を受け取り、同じ型`T`の結果を返します。

#### 具体例と解説

##### 例 1: 通常の`UnaryOperator`実装

```java
public class Main {
    public static void main(String[] args) {
        UnaryOperator<Integer> square = new UnaryOperator<Integer>() {
            @Override
            public Integer apply(Integer x) {
                return x * x;
            }
        };

        System.out.println(square.apply(4)); // 16
    }
}
```

- **解説**:
  - `UnaryOperator`を匿名クラスで実装しています。
  - `apply`メソッドに引数`Integer`を受け取り、平方を返す処理を記述しています。

##### 例 2: ラムダ式を使用した`UnaryOperator`実装

```java
public class Main {
    public static void main(String[] args) {
        UnaryOperator<Integer> square = x -> x * x;
        System.out.println(square.apply(4)); // 16
    }
}
```

- **解説**:
  - ラムダ式を使用して`UnaryOperator`を実装しています。
  - `apply`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`UnaryOperator`を使用することで、以下の技術的課題が解決できます。

1. **同じ型のデータ変換処理の簡素化**:

   - `UnaryOperator`を使用することで、同じ型のデータ変換処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `UnaryOperator`インターフェースを使用することで、同じ型のデータ操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`UnaryOperator`は、引数と同じ型の結果を返す操作を定義するための関数型インターフェースです。同じ型のデータ変換を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`UnaryOperator`を効果的に利用することで、データ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details BinaryOperator<T> ~ 2 つの同じ型の引数を取り、その型の結果を返す関数を表す

`BinaryOperator`は、2 つの同じ型の引数を取り、その型の結果を返す操作を定義する関数型インターフェースです。これは`BiFunction<T, U, R>`の特殊形です。

#### 詳細な説明

`BinaryOperator`は、1 つの抽象メソッド`apply`を持ち、2 つの同じ型の引数を取り、その型の結果を返す操作を定義します。このインターフェースを実装することで、同じ型のデータを操作する処理をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface BinaryOperator<T> extends BiFunction<T, T, T> {
    T apply(T t1, T t2);
}
```

- **メソッド**: `T apply(T t1, T t2)`
  - 2 つの同じ型の引数`T`を受け取り、同じ型`T`の結果を返します。

#### 具体例と解説

##### 例 1: 通常の`BinaryOperator`実装

```java
public class Main {
    public static void main(String[] args) {
        BinaryOperator<Integer> multiply = new BinaryOperator<Integer>() {
            @Override
            public Integer apply(Integer x, Integer y) {
                return x * y;
            }
        };

        System.out.println(multiply.apply(2, 3)); // 6
    }
}
```

- **解説**:
  - `BinaryOperator`を匿名クラスで実装しています。
  - `apply`メソッドに 2 つの引数`Integer`を受け取り、積を返す処理を記述しています。

##### 例 2: ラム

ダ式を使用した`BinaryOperator`実装

```java
public class Main {
    public static void main(String[] args) {
        BinaryOperator<Integer> multiply = (x, y) -> x * y;
        System.out.println(multiply.apply(2, 3)); // 6
    }
}
```

- **解説**:
  - ラムダ式を使用して`BinaryOperator`を実装しています。
  - `apply`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`BinaryOperator`を使用することで、以下の技術的課題が解決できます。

1. **同じ型のデータ操作処理の簡素化**:

   - `BinaryOperator`を使用することで、同じ型のデータ操作処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `BinaryOperator`インターフェースを使用することで、同じ型のデータ操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`BinaryOperator`は、2 つの同じ型の引数を取り、その型の結果を返す操作を定義するための関数型インターフェースです。同じ型のデータ操作を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`BinaryOperator`を効果的に利用することで、データ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details BiConsumer<T, U> ~ 2 つの引数を受け取り、結果を返さない操作を表す

`BiConsumer`は、2 つの引数を受け取り、結果を返さない操作を定義する関数型インターフェースです。このインターフェースを使用することで、2 つの引数を扱う副作用のある処理を簡潔に記述できます。

#### 詳細な説明

`BiConsumer`は、1 つの抽象メソッド`accept`を持ち、2 つの引数を受け取り、結果を返さない操作を定義します。このインターフェースを実装することで、ログ出力やデータの更新などの副作用のある処理をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface BiConsumer<T, U> {
    void accept(T t, U u);
}
```

- **メソッド**: `void accept(T t, U u)`
  - 2 つの引数`T`と`U`を受け取り、結果を返さずに処理を行います。

#### 具体例と解説

##### 例 1: 通常の`BiConsumer`実装

```java
public class Main {
    public static void main(String[] args) {
        BiConsumer<String, Integer> printEntry = new BiConsumer<String, Integer>() {
            @Override
            public void accept(String key, Integer value) {
                System.out.println(key + ": " + value);
            }
        };

        printEntry.accept("age", 30); // age: 30
    }
}
```

- **解説**:
  - `BiConsumer`を匿名クラスで実装しています。
  - `accept`メソッドに 2 つの引数`String`と`Integer`を受け取り、それらを出力する処理を記述しています。

##### 例 2: ラムダ式を使用した`BiConsumer`実装

```java
public class Main {
    public static void main(String[] args) {
        BiConsumer<String, Integer> printEntry = (key, value) -> System.out.println(key + ": " + value);
        printEntry.accept("age", 30); // age: 30
    }
}
```

- **解説**:
  - ラムダ式を使用して`BiConsumer`を実装しています。
  - `accept`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`BiConsumer`を使用することで、以下の技術的課題が解決できます。

1. **複数引数の副作用のある処理の簡素化**:

   - `BiConsumer`を使用することで、複数引数の副作用のある処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `BiConsumer`インターフェースを使用することで、複数引数のデータ操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 副作用のある操作をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`BiConsumer`は、2 つの引数を受け取り、結果を返さない操作を定義するための関数型インターフェースです。副作用のある処理を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`BiConsumer`を効果的に利用することで、複数引数のデータ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details BiPredicate<T, U> ~ 2 つの引数を受け取り、真偽値を返す操作を表す

`BiPredicate`は、2 つの引数を受け取り、真偽値を返す操作を定義する関数型インターフェースです。このインターフェースを使用することで、複数の条件判定を簡潔に記述できます。

#### 詳細な説明

`BiPredicate`は、1 つの抽象メソッド`test`を持ち、2 つの引数を受け取り、真偽値を返す操作を定義します。このインターフェースを実装することで、複数の条件判定をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface BiPredicate<T, U> {
    boolean test(T t, U u);
}
```

- **メソッド**: `boolean test(T t, U u)`
  - 2 つの引数`T`と`U`を受け取り、真偽値を返します。

#### 具体例と解説

##### 例 1: 通常の`BiPredicate`実装

```java
public class Main {
    public static void main(String[] args) {
        BiPredicate<String, Integer> lengthGreaterThan = new BiPredicate<String, Integer>() {
            @Override
            public boolean test(String str, Integer len) {
                return str.length() > len;
            }
        };

        System.out.println(lengthGreaterThan.test("Hello", 3)); // true
    }
}
```

- **解説**:
  - `BiPredicate`を匿名クラスで実装しています。
  - `test`メソッドに 2 つの引数`String`と`Integer`を受け取り、文字列の長さが指定された長さより大きいかどうかを判定する処理を記述しています。

##### 例 2: ラムダ式を使用した`BiPredicate`実装

```java
public class Main {
    public static void main(String[] args) {
        BiPredicate<String, Integer> lengthGreaterThan = (str, len) -> str.length() > len;
        System.out.println(lengthGreaterThan.test("Hello", 3)); // true
    }
}
```

- **解説**:
  - ラムダ式を使用して`BiPredicate`を実装しています。
  - `test`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`BiPredicate`を使用することで、以下の技術的課題が解決できます。

1. **複数条件判定の簡素化**:

   - `BiPredicate`を使用することで、複数条件の判定を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータフィルタリング**:

   - `BiPredicate`インターフェースを使用することで、複数引数のデータフィルタリングを柔軟に行うことができます。

3. \*\*

コードの再利用性向上\*\*: - 条件判定をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`BiPredicate`は、2 つの引数を受け取り、真偽値を返す操作を定義するための関数型インターフェースです。複数条件の判定を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`BiPredicate`を効果的に利用することで、複数引数のデータフィルタリングの柔軟性とコードの再利用性を向上させることができます。

:::

:::details DoubleFunction<R> ~ double 型の引数を受け取り、結果を返す関数を表す

`DoubleFunction`は、`double`型の引数を受け取り、結果を返す操作を定義する関数型インターフェースです。このインターフェースを使用することで、`double`型のデータを扱う関数を簡潔に記述できます。

#### 詳細な説明

`DoubleFunction`は、1 つの抽象メソッド`apply`を持ち、`double`型の引数を受け取り、結果を返す操作を定義します。このインターフェースを実装することで、`double`型のデータを扱う変換や計算をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface DoubleFunction<R> {
    R apply(double value);
}
```

- **メソッド**: `R apply(double value)`
  - `double`型の引数を受け取り、結果`R`を返します。

#### 具体例と解説

##### 例 1: 通常の`DoubleFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        DoubleFunction<String> doubleToString = new DoubleFunction<String>() {
            @Override
            public String apply(double value) {
                return "Value: " + value;
            }
        };

        System.out.println(doubleToString.apply(4.5)); // "Value: 4.5"
    }
}
```

- **解説**:
  - `DoubleFunction`を匿名クラスで実装しています。
  - `apply`メソッドに`double`型の引数を受け取り、その値を文字列に変換する処理を記述しています。

##### 例 2: ラムダ式を使用した`DoubleFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        DoubleFunction<String> doubleToString = value -> "Value: " + value;
        System.out.println(doubleToString.apply(4.5)); // "Value: 4.5"
    }
}
```

- **解説**:
  - ラムダ式を使用して`DoubleFunction`を実装しています。
  - `apply`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`DoubleFunction`を使用することで、以下の技術的課題が解決できます。

1. **`double`型の変換処理の簡素化**:

   - `DoubleFunction`を使用することで、`double`型のデータ変換処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `DoubleFunction`インターフェースを使用することで、`double`型のデータ操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`DoubleFunction`は、`double`型の引数を受け取り、結果を返す操作を定義するための関数型インターフェースです。`double`型のデータ変換を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`DoubleFunction`を効果的に利用することで、`double`型のデータ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details IntConsumer ~ int 型の引数を受け取り、結果を返さない操作を表す

`IntConsumer`は、`int`型の引数を受け取り、結果を返さない操作を定義する関数型インターフェースです。このインターフェースを使用することで、`int`型のデータを扱う副作用のある処理を簡潔に記述できます。

#### 詳細な説明

`IntConsumer`は、1 つの抽象メソッド`accept`を持ち、`int`型の引数を受け取り、結果を返さない操作を定義します。このインターフェースを実装することで、ログ出力やデータの更新などの副作用のある処理をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface IntConsumer {
    void accept(int value);
}
```

- **メソッド**: `void accept(int value)`
  - `int`型の引数を受け取り、結果を返さずに処理を行います。

#### 具体例と解説

##### 例 1: 通常の`IntConsumer`実装

```java
public class Main {
    public static void main(String[] args) {
        IntConsumer printInt = new IntConsumer() {
            @Override
            public void accept(int value) {
                System.out.println(value);
            }
        };

        printInt.accept(10); // 10
    }
}
```

- **解説**:
  - `IntConsumer`を匿名クラスで実装しています。
  - `accept`メソッドに`int`型の引数を受け取り、それを出力する処理を記述しています。

##### 例 2: ラムダ式を使用した`IntConsumer`実装

```java
public class Main {
    public static void main(String[] args) {
        IntConsumer printInt = value -> System.out.println(value);
        printInt.accept(10); // 10
    }
}
```

- **解説**:
  - ラムダ式を使用して`IntConsumer`を実装しています。
  - `accept`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`IntConsumer`を使用することで、以下の技術的課題が解決できます。

1. **`int`型の副作用のある処理の簡素化**:

   - `IntConsumer`を使用することで、`int`型のデータを扱う副作用のある処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `IntConsumer`インターフェースを使用することで、`int`型のデータ操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 副作用のある操作をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`IntConsumer`は、`int`型の引数を受け取り、結果を返さない操作を定義するための関数型インターフェースです。`int`型のデータ操作を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`IntConsumer`を効果的に利用することで、`int`型のデータ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details LongSupplier ~ long 型の結果を供給する操作を表す

`LongSupplier`は、引数を受け取らずに`long`型の結果を供給する操作を定義する関数型インターフェースです。このインターフェースを使用することで、`long`型の値やオブジェクトの生成を簡潔に記述できます。

#### 詳細な説明

`LongSupplier`は、1 つの抽象メソッド`getAsLong`を持ち、引数を受け取らずに`long`型の結果を供給する操作を定義します。このインターフェースを実装することで、`long`

型の値やオブジェクトの生成をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface LongSupplier {
    long getAsLong();
}
```

- **メソッド**: `long getAsLong()`
  - 引数を受け取らずに`long`型の結果を供給します。

#### 具体例と解説

##### 例 1: 通常の`LongSupplier`実装

```java
public class Main {
    public static void main(String[] args) {
        LongSupplier currentTimeMillis = new LongSupplier() {
            @Override
            public long getAsLong() {
                return System.currentTimeMillis();
            }
        };

        System.out.println(currentTimeMillis.getAsLong()); // 現在のミリ秒を出力
    }
}
```

- **解説**:
  - `LongSupplier`を匿名クラスで実装しています。
  - `getAsLong`メソッドに引数を受け取らずに現在のミリ秒を返す処理を記述しています。

##### 例 2: ラムダ式を使用した`LongSupplier`実装

```java
public class Main {
    public static void main(String[] args) {
        LongSupplier currentTimeMillis = () -> System.currentTimeMillis();
        System.out.println(currentTimeMillis.getAsLong()); // 現在のミリ秒を出力
    }
}
```

- **解説**:
  - ラムダ式を使用して`LongSupplier`を実装しています。
  - `getAsLong`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`LongSupplier`を使用することで、以下の技術的課題が解決できます。

1. **`long`型の値やオブジェクトの生成の簡素化**:

   - `LongSupplier`を使用することで、`long`型の値やオブジェクトの生成を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ生成**:

   - `LongSupplier`インターフェースを使用することで、`long`型のデータ生成を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 値やオブジェクトの生成操作をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`LongSupplier`は、引数を受け取らずに`long`型の結果を供給する操作を定義するための関数型インターフェースです。`long`型の値やオブジェクトの生成を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`LongSupplier`を効果的に利用することで、`long`型のデータ生成の柔軟性とコードの再利用性を向上させることができます。

:::

:::details ToIntFunction<T> ~ 引数を受け取り、int 型の結果を返す関数を表す

`ToIntFunction`は、引数を受け取り、`int`型の結果を返す操作を定義する関数型インターフェースです。このインターフェースを使用することで、データの変換や計算を簡潔に記述できます。

#### 詳細な説明

`ToIntFunction`は、1 つの抽象メソッド`applyAsInt`を持ち、引数を受け取り、`int`型の結果を返す操作を定義します。このインターフェースを実装することで、データの変換や計算をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface ToIntFunction<T> {
    int applyAsInt(T value);
}
```

- **メソッド**: `int applyAsInt(T value)`
  - 引数`T`を受け取り、`int`型の結果を返します。

#### 具体例と解説

##### 例 1: 通常の`ToIntFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        ToIntFunction<String> stringLength = new ToIntFunction<String>() {
            @Override
            public int applyAsInt(String s) {
                return s.length();
            }
        };

        System.out.println(stringLength.applyAsInt("Hello")); // 5
    }
}
```

- **解説**:
  - `ToIntFunction`を匿名クラスで実装しています。
  - `applyAsInt`メソッドに引数`String`を受け取り、その長さを返す処理を記述しています。

##### 例 2: ラムダ式を使用した`ToIntFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        ToIntFunction<String> stringLength = s -> s.length();
        System.out.println(stringLength.applyAsInt("Hello")); // 5
    }
}
```

- **解説**:
  - ラムダ式を使用して`ToIntFunction`を実装しています。
  - `applyAsInt`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`ToIntFunction`を使用することで、以下の技術的課題が解決できます。

1. **データの変換や計算の簡素化**:

   - `ToIntFunction`を使用することで、データの変換や計算処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `ToIntFunction`インターフェースを使用することで、データの操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`ToIntFunction`は、引数を受け取り、`int`型の結果を返す操作を定義するための関数型インターフェースです。データの変換や計算を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`ToIntFunction`を効果的に利用することで、データ操作の柔軟性とコードの再利用性を向上させることができます。

:::

:::details ToDoubleBiFunction<T, U> ~ 2 つの引数を受け取り、double 型の結果を返す関数を表す

`ToDoubleBiFunction`は、2 つの引数を受け取り、`double`型の結果を返す操作を定義する関数型インターフェースです。このインターフェースを使用することで、複数のデータを扱う計算を簡潔に記述できます。

#### 詳細な説明

`ToDoubleBiFunction`は、1 つの抽象メソッド`applyAsDouble`を持ち、2 つの引数を受け取り、`double`型の結果を返す操作を定義します。このインターフェースを実装することで、複数のデータを扱う計算をラムダ式やメソッド参照を使って簡潔に記述できます。

#### シグネチャ

```java
@FunctionalInterface
public interface ToDoubleBiFunction<T, U> {
    double applyAsDouble(T t, U u);
}
```

- **メソッド**: `double applyAsDouble(T t, U u)`
  - 2 つの引数`T`と`U`を受け取り、`double`型の結果を返します。

#### 具体例と解説

##### 例 1: 通常の`ToDoubleBiFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        ToDoubleBiFunction<Integer, Integer> average = new ToDoubleBiFunction<Integer, Integer>() {
            @Override
            public double applyAsDouble(Integer x, Integer y) {
                return (x + y) / 2.0;
            }
        };

        System.out.println(average.applyAsDouble(4, 6)); // 5.0
    }
}
```

- **解説**:
  - `ToDoubleBiFunction`を匿名クラスで実装しています。
  - `applyAsDouble`メソッドに 2 つの引数`Integer`を受け取り、平均値を返す処理を記述しています。

##### 例 2: ラムダ式を

使用した`ToDoubleBiFunction`実装

```java
public class Main {
    public static void main(String[] args) {
        ToDoubleBiFunction<Integer, Integer> average = (x, y) -> (x + y) / 2.0;
        System.out.println(average.applyAsDouble(4, 6)); // 5.0
    }
}
```

- **解説**:
  - ラムダ式を使用して`ToDoubleBiFunction`を実装しています。
  - `applyAsDouble`メソッドの実装を簡潔に記述できます。

#### 技術的課題の解決

`ToDoubleBiFunction`を使用することで、以下の技術的課題が解決できます。

1. **複数データの計算処理の簡素化**:

   - `ToDoubleBiFunction`を使用することで、複数データの計算処理を簡潔に記述できます。ラムダ式を使うことでさらにコードが短くなり、可読性が向上します。

2. **柔軟なデータ操作**:

   - `ToDoubleBiFunction`インターフェースを使用することで、複数データの操作を柔軟に行うことができます。

3. **コードの再利用性向上**:
   - 関数をオブジェクトとして扱うことで、コードの再利用性が向上します。必要な処理を簡単に組み合わせることができます。

### まとめ

`ToDoubleBiFunction`は、2 つの引数を受け取り、`double`型の結果を返す操作を定義するための関数型インターフェースです。複数データの計算を簡潔かつ明瞭に記述でき、ラムダ式を使用することでさらにコードを短くできます。`ToDoubleBiFunction`を効果的に利用することで、複数データの操作の柔軟性とコードの再利用性を向上させることができます。

:::

## 技術的課題の解決

関数型インターフェースを使うことで、以下の技術的課題が解決されます。

1. **冗長なコードの削減**:

   - 従来の匿名クラスの実装よりも、ラムダ式を使うことでコードが簡潔になります。
   - 例: 匿名クラス vs ラムダ式

   ```java
   // 匿名クラス
   Runnable r1 = new Runnable() {
       @Override
       public void run() {
           System.out.println("Hello");
       }
   };

   // ラムダ式
   Runnable r2 = () -> System.out.println("Hello");
   ```

2. **可読性の向上**:

   - 関数型インターフェースとラムダ式を使うことで、処理の意図が明確になり、他の開発者がコードを理解しやすくなります。

3. **柔軟な処理の記述**:

   - 関数型インターフェースを使うことで、メソッドの引数に処理を渡すことができ、コードの柔軟性が向上します。
   - 例: コレクションの操作

   ```java
   List<String> list = Arrays.asList("a", "b", "c");
   list.forEach(s -> System.out.println(s));
   ```

4. **並列処理の簡易化**:
   - ストリーム API と組み合わせることで、並列処理が簡単に実現できます。
   - 例: ストリームの並列処理
   ```java
   List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
   list.parallelStream().forEach(System.out::println);
   ```

## まとめ

関数型インターフェースは、Java における関数型プログラミングを実現するための基盤です。ラムダ式やメソッド参照を使うことで、コードの簡潔性、可読性、柔軟性が大幅に向上します。これにより、複雑な処理をよりシンプルに記述でき、保守性の高いコードを実現できます。
