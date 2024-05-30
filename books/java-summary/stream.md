---
title: "Stream API"
---

## 概要

- Java 8 で導入されたデータ処理のための API
- コレクションや配列などのデータソースに対して関数型プログラミングスタイルの操作を提供する
- これにより、データのフィルタリング、変換、集約などの操作を効率的かつ簡潔に行うことができる
- Stream API の中心にあるのが `Stream` インターフェース

## 目的

1. **宣言的プログラミング**:

   - コードの意図を明確に表現する
   - イテレータやループの使用を避け、データ処理の流れを簡潔にする

2. **パイプライン処理**:

   - 一連の処理ステップをチェーンで繋げることができる
   - 何らかの条件でフィルタリング → フィルタリング結果を基に何か処理するみたいなことができる
   - 各ステップは中間操作（intermediate operation）か終端操作（terminal operation）として分類される

3. **遅延評価**:
   - 中間操作は遅延評価され、終端操作が呼ばれたときに初めて実行される
   - 効率的な処理を実現し、必要なデータのみを計算する

## Stream API の 3 つの段階

![](https://storage.googleapis.com/zenn-user-upload/baaca376448e-20240530.png)

1. **ストリームの生成**

   - `Stream` インターフェースを実装するオブジェクトを生成する
   - コレクションから `stream()` メソッド等を呼び出すことで生成できる
   - `Stream` インターフェースの静的メソッドによって直接生成することも可能

2. **中間操作**
   - 生成したストリームの各要素に対して何らかの処理を実行する
     - 例：フィルタリング、マッピング
   - **処理結果をストリームで出力する**
   - **中間操作メソッドの戻り値は `Stream` インターフェースを実装している**
   - 中間操作は複数連結可能
3. **終端操作**

   - ストリームから目的とするデータを取り出す
   - 終端操作によって一連のパイプラインは終了する
   - 終端操作は**リダクション**を行う
     :::details リダクションとは？

     - ストリームの要素を 1 つの結果にまとめる操作のこと
     - 要素の集計や集約を行い、単一の値やコレクションを生成するために使用される
     - 典型的なリダクション操作には、合計、平均、最大値、最小値などがある

     :::

   - よって、戻り値はプリミティブ型やコレクション
   - **終端操作は必ず一度だけ実行する必要がある**

## 基本構成要素

1. **Source**:

   - Stream の入力となるデータソース。コレクション、配列、I/O チャネルなど。
   - 例: `List<String> list = Arrays.asList("a", "b", "c");`

2. **中間操作**:

   - ストリームを変換する操作。遅延評価され、ストリームを返す。
   - 例: `filter()`, `map()`, `sorted()`

3. **終端操作**:
   - ストリームを消費し、結果を生成する操作。これによりストリームの処理が完了する。
   - 例: `forEach()`, `collect()`, `reduce()`

**中間操作・終端操作のメソッドは、ほとんどが関数型インターフェースを引数に取る。**
よって、ラムダ式やメソッド参照を渡す。

## 順次ストリームと並列ストリーム

ストリームには 2 種類ある。

1. **順次ストリーム**
   - 要素を一つずつ順番に取り出して処理するストリーム
   - ストリーム内の各要素は、ストリームが生成された時点で順序付けされる
2. **並列ストリーム**
   - マルチスレッドによって各要素を暗黙的に並列処理する
   - 各要素がどのような順番で処理されるか保証されない

## プリミティブ型ストリーム

ストリームには特定のプリミティブ型に特化したストリームインターフェースがある。

- `IntStream` : `int` に特化したストリーム
- `LongStream` : `long` に特化したストリーム
- `DoubleStream` : `double` に特化したストリーム

これらのインターフェースには `Stream` と同様の機能を持ちつつ、プリミティブ型固有の API も用意されている。

### `IntStream`

:::details 主要メソッド

- **`range`**
  指定された範囲の連続した整数を生成する。
  ```java
  static IntStream range(int startInclusive, int endExclusive)
  ```
- **`rangeClosed`**
  指定された範囲の連続した整数を生成する（終了値を含む）。
  ```java
  static IntStream rangeClosed(int startInclusive, int endInclusive)
  ```
- **`of`**
  指定された整数のストリームを生成する。
  ```java
  static IntStream of(int... values)
  ```

:::

:::details 使用例

```java
import java.util.stream.IntStream;

public class Main {
    public static void main(String[] args) {
        // 1から5までの範囲の整数を生成
        IntStream.range(1, 5).forEach(System.out::println);
        // 出力: 1, 2, 3, 4

        // 1から5までの範囲の整数を生成（終了値を含む）
        IntStream.rangeClosed(1, 5).forEach(System.out::println);
        // 出力: 1, 2, 3, 4, 5

        // 配列からストリームを生成
        IntStream.of(1, 2, 3, 4, 5).forEach(System.out::println);
        // 出力: 1, 2, 3, 4, 5
    }
}
```

:::

### `LongStream`

:::details 主要メソッド

- **`range`**
  指定された範囲の連続した長整数を生成する。
  ```java
  static LongStream range(long startInclusive, long endExclusive)
  ```
- **`rangeClosed`**
  指定された範囲の連続した長整数を生成する（終了値を含む）。
  ```java
  static LongStream rangeClosed(long startInclusive, long endInclusive)
  ```
- **`of`**
  指定された長整数のストリームを生成する。
  ```java
  static LongStream of(long... values)
  ```

:::

:::details 使用例

```java
import java.util.stream.LongStream;

public class Main {
    public static void main(String[] args) {
        // 1から5までの範囲の長整数を生成
        LongStream.range(1, 5).forEach(System.out::println);
        // 出力: 1, 2, 3, 4

        // 1から5までの範囲の長整数を生成（終了値を含む）
        LongStream.rangeClosed(1, 5).forEach(System.out::println);
        // 出力: 1, 2, 3, 4, 5

        // 配列からストリームを生成
        LongStream.of(1L, 2L, 3L, 4L, 5L).forEach(System.out::println);
        // 出力: 1, 2, 3, 4, 5
    }
}
```

:::

### `DoubleStream`

:::details 主要メソッド

- **`of`**
  指定された浮動小数点数のストリームを生成する。
  ```java
  static DoubleStream of(double... values)
  ```
- **`generate`**
  指定されたサプライヤから生成された要素を持つ無限ストリームを生成する。
  ```java
  static DoubleStream generate(DoubleSupplier s)
  ```
- **`range` は存在しない**

:::

:::details 使用例

```java
import java.util.stream.DoubleStream;

public class Main {
    public static void main(String[] args) {
        // 配列からストリームを生成
        DoubleStream.of(1.1, 2.2, 3.3, 4.4, 5.5).forEach(System.out::println);
        // 出力: 1.1, 2.2, 3.3, 4.4, 5.5

        // 無限ストリームを生成（ランダムな値）
        DoubleStream.generate(Math::random).limit(5).forEach(System.out::println);
        // 出力: 5つのランダムな値
    }
}
```

:::

## ストリームの生成

### コレクションから生成する

`List` や `Set` には `stream()` メソッドが定義されており、これを呼び出すことで順次ストリームを生成できる。

- **シグネチャ**

  ```java
  Stream<E> stream();
  ```

- **例**

  ```java
  List<String> list = Arrays.asList("a", "b", "c");
  Stream<String> stream = list.stream();
  ```

### `Stream` インターフェースから生成する

複数のファクトリメソッドが存在する。

:::details of ~ 指定された値を要素に持つ、順序付けされた順次ストリームを生成

- **詳細な説明**:
  指定された値を要素として含む順次ストリームを生成する。単一の値、複数の値、または配列を指定することができる。
- **シグネチャ**:
  ```java
  static <T> Stream<T> of(T t)
  static <T> Stream<T> of(T... values)
  ```
- **具体例と解説**:

  ```java
  // 単一の値からストリームを生成
  Stream<String> singleStream = Stream.of("a");
  singleStream.forEach(System.out::println); // 出力: a

  // 複数の値からストリームを生成
  Stream<String> multiStream = Stream.of("a", "b", "c");
  multiStream.forEach(System.out::println); // 出力: a, b, c

  // 配列からストリームを生成
  String[] array = {"a", "b", "c"};
  Stream<String> arrayStream = Stream.of(array);
  arrayStream.forEach(System.out::println); // 出力: a, b, c
  ```

:::

:::details generate ~ サプライヤから生成された要素を持つ無限ストリームを生成

- **詳細な説明**:
  指定されたサプライヤ（供給者）を使用して生成された要素を持つ、順序付けされない無限ストリームを生成する。各要素は、サプライヤによって提供される。
- **シグネチャ**:
  ```java
  static <T> Stream<T> generate(Supplier<T> s)
  ```
- **具体例と解説**:

  ```java
  // ランダムな値を生成する無限ストリームを生成
  Stream<Double> randomStream = Stream.generate(Math::random);

  // ストリームの先頭から10個の要素を表示
  randomStream.limit(10).forEach(System.out::println);
  ```

:::

:::details iterate ~ 初期要素と関数を基に生成された要素を持つ無限ストリームを生成

- **詳細な説明**:
  初期要素から開始し、指定された関数を適用して次の要素を生成する無限ストリームを生成する。ストリームの各要素は、前の要素に関数を適用することで得られる。
- **シグネチャ**:
  ```java
  static <T> Stream<T> iterate(T seed, UnaryOperator<T> f)
  ```
- **具体例と解説**:

  ```java
  // 0から始まり、各要素が前の要素に1を足した値となる無限ストリームを生成
  Stream<Integer> iterateStream = Stream.iterate(0, n -> n + 1);

  // ストリームの先頭から10個の要素を表示
  iterateStream.limit(10).forEach(System.out::println); // 出力: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
  ```

:::

:::details concat ~ 2 つのストリームを連結したストリームを生成

- **詳細な説明**:
  2 つのストリームを連結して 1 つのストリームを生成する。最初のストリームの要素が先に、次に 2 番目のストリームの要素が続く順序になる。
- **シグネチャ**:
  ```java
  static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T> b)
  ```
- **具体例と解説**:

  ```java
  // 2つのストリームを生成
  Stream<String> stream1 = Stream.of("a", "b", "c");
  Stream<String> stream2 = Stream.of("d", "e", "f");

  // 2つのストリームを連結
  Stream<String> concatenatedStream = Stream.concat(stream1, stream2);
  concatenatedStream.forEach(System.out::println); // 出力: a, b, c, d, e, f
  ```

:::

### 配列からの生成

`Array.stream()` メソッドで生成できる。

- **シグネチャ**
  ```java
  public static <T> Stream<T> stream(T[] array)
  public static IntStream stream(int[] array)
  public static LongStream stream(long[] array)
  public static DoubleStream stream(double[] array)
  ```
- **具体例**

  ```java
  import java.util.Arrays;
  import java.util.stream.IntStream;
  import java.util.stream.Stream;

  public class Main {
      public static void main(String[] args) {
          // オブジェクト型配列からストリームを生成
          String[] stringArray = {"a", "b", "c"};
          Stream<String> stringStream = Arrays.stream(stringArray);
          stringStream.forEach(System.out::println); // 出力: a, b, c

          // プリミティブ型配列からストリームを生成
          int[] intArray = {1, 2, 3, 4, 5};
          IntStream intStream = Arrays.stream(intArray);
          intStream.forEach(System.out::println); // 出力: 1, 2, 3, 4, 5
      }
  }
  ```

## `Stream` インターフェースの主要メソッド

### 中間操作

:::details map() ~ 要素の変換

- **説明**:
  - 各要素を指定された関数に適用した結果を含むストリームを返す
- **シグネチャ**:
  ```java
  <R> Stream<R> map(Function<? super T, ? extends R> mapper)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  List<Integer> lengths = list.stream()
                              .map(String::length)
                              .collect(Collectors.toList());
  System.out.println(lengths); // [3, 3, 5]
  ```
  - **説明**: この例では、文字列のリストを文字列の長さに変換し、その結果を新しいリストに収集しています。

:::

:::details filter() ~ 要素のフィルタリング

- **説明**:
  - 指定された条件を満たす要素だけを含むストリームを返す
- **シグネチャ**:
  ```java
  Stream<T> filter(Predicate<? super T> predicate)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  List<String> filtered = list.stream()
                              .filter(s -> s.length() > 3)
                              .collect(Collectors.toList());
  System.out.println(filtered); // [three]
  ```
  - **説明**: この例では、文字列の長さが 3 より大きい要素だけをフィルタリングしている

:::

:::details distinct() ~ 重複要素の削除

- **説明**:
  - 重複する要素を取り除いたストリームを返します。元のストリームの要素の順序が維持されます。
- **シグネチャ**:
  ```java
  Stream<T> distinct()
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "two", "three");
  List<String> distinctList = list.stream()
                                  .distinct()
                                  .collect(Collectors.toList());
  System.out.println(distinctList); // [one, two, three]
  ```
  - **説明**: この例では、重複する要素を取り除き、ユニークな要素だけを保持しています。

:::

:::details sorted() ~ 要素のソート

- **説明**:
  - ストリームの要素を自然順序でソートします。要素が`Comparable`を実装している必要があります。
- **シグネチャ**:
  ```java
  Stream<T> sorted()
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("three", "one", "two");
  List<String> sortedList = list.stream()
                                .sorted()
                                .collect(Collectors.toList());
  System.out.println(sortedList); // [one, three, two]
  ```
  - **説明**: この例では、文字列リストをアルファベット順にソートしています。

:::

:::details sorted() ~ カスタムコンパレータによるソート

- **説明**:
  - ストリームの要素を指定されたコンパレータでソートします。任意の順序でソートすることができます。
- **シグネチャ**:
  ```java
  Stream<T> sorted(Comparator<? super T> comparator)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("three", "one", "two");
  List<String> sortedList = list.stream()
                                .sorted(Comparator.reverseOrder())
                                .collect(Collectors.toList());
  System.out.println(sortedList); // [two, three, one]
  ```
  - **説明**: この例では、文字列リストを逆順にソートしています。

:::

:::details peek() ~ 要素に対するアクションの実行

- **説明**:
  - 各要素に対して指定されたアクションを実行し、その後のストリームを返します。デバッグやログのために使用されます。
- **シグネチャ**:
  ```java
  Stream<T> peek(Consumer<? super T> action)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  List<String> result = list.stream()
                            .peek(System.out::println)
                            .collect(Collectors.toList());
  ```
  - **説明**: この例では、各要素がストリーム処理中に標準出力に出力されます。

:::

:::details limit() ~ 要素数の制限

- **説明**:
  - ストリームの要素数を指定された最大数まで制限します。それ以降の要素は無視されます。
- **シグネチャ**:
  ```java
  Stream<T> limit(long maxSize)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three", "four");
  List<String> limitedList = list.stream()
                                 .limit(2)
                                 .collect(Collectors.toList());
  System.out.println(limitedList); // [one, two]
  ```
  - **説明**: この例では、最初の 2 つの要素だけを取得しています。

:::

:::details skip() ~ 要素のスキップ

- **説明**:
  - 最初の n 個の要素をスキップしたストリームを返します。それ以降の要素だけが含まれます。
- **シグネチャ**:
  ```java
  Stream<T> skip(long n)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three", "four");
  List<String> skippedList = list.stream()
                                 .skip(2)
                                 .collect(Collectors.toList());
  System.out.println(skippedList); // [three, four]
  ```
  - **説明**: この例では、最初の 2 つの要素をスキップし、それ以降の要素を取得しています。

:::

:::details flatMap() ~ フラットマッピング

- **説明**:
  - 各要素をストリームに変換し、それらをフラットに結合し、一つのストリームにする
  - 各要素に対して関数を適用してストリームを生成する
  - ネストされたストリームができるので、それらを結合してフラットにする
- **シグネチャ**:
  ```java
  <R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper)
  ```
- **具体例**:
  ```java
  List<List<String>> list = Arrays.asList(
      Arrays.asList("one", "two"),
      Arrays.asList("three", "four")
  );
  List<String> flatMappedList = list.stream()
                                    .flatMap(List::stream)
                                    .collect(Collectors.toList());
  System.out.println(flatMappedList); // [one, two, three, four]
  ```
  - **説明**: この例では、ネストされたリストを平坦化し、一つのリストにしています。

:::

:::details mapToInt() ~ int ストリームへのマッピング

- **説明**:
  - 各要素を int に変換し、`IntStream` を返す
- **シグネチャ**:
  ```java
  IntStream mapToInt(ToIntFunction<? super T> mapper)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  int sum = list.stream()
                .mapToInt(String::length)
                .sum();
  System.out.println(sum); // 11
  ```
  - **説明**: この例では、各文字列の長さを取得し、その合計を計算しています。

:::

:::details mapToDouble() ~ double ストリームへのマッピング

- **説明**:
  - 各要素を double に変換し、double ストリームを返します。浮動小数点数の処理に使用されます。
- **シグネチャ**:
  ```java
  DoubleStream mapToDouble(ToDoubleFunction<? super T> mapper)
  ```
- **具体例**:

  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  double average = list.stream()
                       .mapToDouble(String::length)
                       .average()
                       .orElse(0.0);
  System.out.println(average); // 3.6666666666666665
  ```

  - **説明**: この例では、各文字列の長さの平均を計算しています。

:::

:::details mapToLong() ~ long ストリームへのマッピング

- **説明**:
  - 各要素を long に変換し、long ストリームを返します。大きな整数値の処理に使用されます。
- **シグネチャ**:
  ```java
  LongStream mapToLong(ToLongFunction<? super T> mapper)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  long totalLength = list.stream()
                         .mapToLong(String::length)
                         .sum();
  System.out.println(totalLength); // 11
  ```
  - **説明**: この例では、各文字列の長さを取得し、その合計を計算しています。

:::

:::details flatMapToInt() ~ int ストリームへのフラットマッピング

- **説明**:
  - 各要素を int ストリームにマッピングし、そのストリームをフラットに結合した結果を含む int ストリームを返します。ネストされた数値ストリームを平坦化します。
- **シグネチャ**:
  ```java
  IntStream flatMapToInt(Function<? super T, ? extends IntStream> mapper)
  ```
- **具体例**:
  ```java
  List<List<Integer>> list = Arrays.asList(
      Arrays.asList(1, 2),
      Arrays.asList(3, 4)
  );
  int sum = list.stream()
                .flatMapToInt(l -> l.stream().mapToInt(Integer::intValue))
                .sum();
  System.out.println(sum); // 10
  ```
  - **説明**: この例では、ネストされたリストを平坦化し、数値の合計を計算しています。

:::

:::details flatMapToDouble() ~ double ストリームへのフラットマッピング

- **説明**:
  - 各要素を double ストリームにマッピングし、そのストリームをフラットに結合した結果を含む double ストリームを返します。ネストされた浮動小数点数のストリームを平坦化します。
- **シグネチャ**:
  ```java
  DoubleStream flatMapToDouble(Function<? super T, ? extends DoubleStream> mapper)
  ```
- **具体例**:
  ```java
  List<List<Double>> list = Arrays.asList(
      Arrays.asList(1.0, 2.0),
      Arrays.asList(3.0, 4.0)
  );
  double sum = list.stream()
                   .flatMapToDouble(l -> l.stream().mapToDouble(Double::doubleValue))
                   .sum();
  System.out.println(sum); // 10.0
  ```
  - **説明**: この例では、ネストされたリストを平坦化し、浮動小数点数の合計を計算しています。

:::

:::details flatMapToLong() ~ long ストリームへのフラットマッピング

- **説明**:
  - 各要素を long ストリームにマッピングし、そのストリームをフラットに結合した結果を含む long ストリームを返します。ネストされた長整数ストリームを平坦化します。
- **シグネチャ**:
  ```java
  LongStream flatMapToLong(Function<? super T, ? extends LongStream> mapper)
  ```
- **具体例**:
  ```java
  List<List<Long>> list = Arrays.asList(
      Arrays.asList(1L, 2L),
      Arrays.asList(3L, 4L)
  );
  long sum = list.stream()
                 .flatMapToLong(l -> l.stream().mapToLong(Long::longValue))
                 .sum();
  System.out.println(sum); // 10
  ```
  - **説明**: この例では、ネストされたリストを平坦化し、長整数の合計を計算しています。

:::

### 終端操作

:::details collect() ~ 要素の収集

- **説明**:
  - ストリームの要素を収集し、リストやセットなどのコレクションに変換します。さまざまな収集方法が提供されています。
- **シグネチャ**:
  ```java
  <R, A> R collect(Collector<? super T, A, R> collector)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  List<String> collectedList = list.stream()
                                   .collect(Collectors.toList());
  System.out.println(collectedList); // [one, two, three]
  ```
  - **説明**: この例では、ストリームの要素をリストに収集しています。

:::

:::details forEach() ~ 要素に対するアクションの実行

- **説明**:
  - ストリームの各要素に対して指定されたアクションを実行します。終端操作であり、ストリームの処理を終了させます。
- **シグネチャ**:
  ```java
  void forEach(Consumer<? super T> action)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  list.stream()
      .forEach(System.out::println);
  ```
  - **説明**: この例では、各要素が標準出力に出力されます。

:::

:::details reduce() ~ 要素の畳み込み

- **説明**:
  - ストリームの要素を畳み込み（リダクション）操作を行い、一つの結果にまとめます。初期値を指定しない場合、ストリームが空の場合は`Optional.empty()`を返します。
- **シグネチャ**:
  ```java
  Optional<T> reduce(BinaryOperator<T> accumulator)
  ```
- **具体例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
  Optional<Integer> sum = list.stream()
                              .reduce(Integer::sum);
  sum.ifPresent(System.out::println); // 15
  ```
  - **説明**: この例では、数値の合計を計算しています。

:::

:::details count() ~ 要素数の取得

- **説明**:
  - ストリームの要素数を返します。要素数が多い場合に効率的に処理されます。
- **シグネチャ**:
  ```java
  long count()
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  long count = list.stream()
                   .count();
  System.out.println(count); // 3
  ```
  - **説明**: この例では、リストの要素数を数えています。

:::

:::details anyMatch() ~ 条件を満たす要素の存在確認

- **説明**:
  - ストリームのいずれかの要素が指定された条件を満たすかどうかを返します。短絡評価されます。
- **シグネチャ**:
  ```java
  boolean anyMatch(Predicate<? super T> predicate)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  boolean anyMatch = list.stream()
                         .anyMatch(s -> s.length() > 3);
  System.out.println(anyMatch); // true
  ```
  - **説明**: この例では、長さが 3 より大きい要素が存在するかどうかを確認しています。

:::

:::details allMatch() ~ 全要素が条件を満たすかの確認

- **説明**:
  - ストリームのすべての要素が指定された条件を満たすかどうかを返します。短絡評価されます。
- **シグネチャ**:
  ```java
  boolean allMatch(Predicate<? super T> predicate)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  boolean allMatch = list.stream()
                         .allMatch(s -> s.length() > 2);
  System.out.println(allMatch); // true
  ```
  - **説明**: この例では、すべての要素が長さ 2 より大きいかどうかを確認しています。

:::

:::details noneMatch() ~ 全要素が条件を満たさないかの確認

- **説明**:
  - ストリームのすべての要素が指定された条件を満たさないかどうかを返します。短絡評価されます。
- **シグネチャ**:
  ```java
  boolean noneMatch(Predicate<? super T> predicate)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  boolean noneMatch = list.stream()
                          .noneMatch(s -> s.length() > 5);
  System.out.println(noneMatch); // true
  ```
  - **説明**: この例では、すべての要素が長さ 5 より大きくないかどうかを確認しています。

:::

:::details findFirst() ~ 最初の要素の取得

- **説明**:
  - ストリームの最初の要素を返します。ストリームが空の場合は`Optional.empty()`を返します。順序が保証されるストリームで有用です。
- **シグネチャ**:
  ```java
  Optional<T> findFirst()
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  Optional<String> first = list.stream()
                               .findFirst();
  first.ifPresent(System.out::println); // one
  ```
  - **説明**: この例では、リストの最初の要素を取得しています。

:::

:::details findAny() ~ 任意の要素の取得

- **説明**:
  - ストリームの任意の要素を返します。ストリームが空の場合は`Optional.empty()`を返します。並列ストリームで有用です。
- **シグネチャ**:
  ```java
  Optional<T> findAny()
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  Optional<String> any = list.stream()
                             .findAny();
  any.ifPresent(System.out::println); // one (結果は異なる場合があります)
  ```
  - **説明**: この例では、リストの任意の要素を取得しています。

:::

:::details toArray() ~ 配列への変換

- **説明**:
  - ストリームの要素を配列に変換します。デフォルトでは`Object[]`の配列を返します。
- **シグネチャ**:
  ```java
  Object[] toArray()
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  Object[] array = list.stream()
                       .toArray();
  System.out.println(Arrays.toString(array)); // [one, two, three]
  ```
  - **説明**: この例では、リストの要素を配列に変換しています。

:::

:::details toArray() ~ 指定された型の配列への変換

- **説明**:
  - ストリームの要素を指定された型の配列に変換します。ジェネレータ関数を使用して、特定の型の配列を作成します。
- **シグネチャ**:
  ```java
  <A> A[] toArray(IntFunction<A[]> generator)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  String[] array = list.stream()
                       .toArray(String[]::new);
  System.out.println(Arrays.toString(array)); // [one, two, three]
  ```
  - **説明**: この例では、リストの要素を`String`配列に変換しています。

:::

:::details max() ~ 最大値の取得

- **説明**:
  - ストリームの要素のうち、指定されたコンパレータで最大の要素を返します。ストリームが空の場合は`Optional.empty()`を返します。
- **シグネチャ**:
  ```java
  Optional<T> max(Comparator<? super T> comparator)
  ```
- **具体例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
  Optional<Integer> max = list.stream()
                              .max(Integer::compare);
  max.ifPresent(System.out::println); // 5
  ```
  - **説明**: この例では、リストの最大値を取得しています。

:::

:::details min() ~ 最小値の取得

- **説明**:
  - ストリームの要素のうち、指定されたコンパレータで最小の要素を返します。ストリームが空の場合は`Optional.empty()`を返します。
- **シグネチャ**:
  ```java
  Optional<T> min(Comparator<? super T> comparator)
  ```
- **具体例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
  Optional<Integer> min = list.stream()
                              .min(Integer::compare);
  min.ifPresent(System.out::println); // 1
  ```
  - **説明**: この例では、リストの最小値を取得しています。

:::

:::details sum() ~ 合計の計算（IntStream、LongStream、DoubleStream）

- **説明**:
  - ストリームの要素の合計を返します。`IntStream`、`LongStream`、`DoubleStream`で利用可能です。
- **シグネチャ**:
  ```java
  int sum()
  ```
- **具体例**:
  ```java
  int[] array = {1, 2, 3, 4, 5};
  int sum = Arrays.stream(array).sum();
  System.out.println(sum); // 15
  ```
  - **説明**: この例では、数値配列の合計を計算しています。

:::

:::details average() ~ 平均の計算（IntStream、LongStream、DoubleStream）

- **説明**:
  - ストリームの要素の平均を返します。`IntStream`、`LongStream`、`DoubleStream`で利用可能です。ストリームが空の場合は`OptionalDouble.empty()`を返します。
- **シグネチャ**:
  ```java
  OptionalDouble average()
  ```
- **具体例**:
  ```java
  int[] array = {1, 2, 3, 4, 5};
  OptionalDouble average = Arrays.stream(array).average();
  average.ifPresent(System.out::println); // 3.0
  ```
  - **説明**: この例では、数値配列の平均を計算しています。

:::

### その他の操作

:::details iterator() ~ イテレータの取得

- **説明**:
  - ストリームの要素を反復処理するためのイテレータを返します。ストリームの要素を順次処理するために使用されます。
- **シグネチャ**:
  ```java
  Iterator<T> iterator()
  ```

:::

:::details spliterator() ~ スプリテレータの取得

- **説明**:
  - ストリームの要素を並列処理するためのスプリテレータを返します。並列ストリームでの効率的な処理に使用されます。
- **シグネチャ**:
  ```java
  Spliterator<T> spliterator()
  ```

:::

:::details isParallel() ~ 並列ストリームかの確認

- **説明**:
  - ストリームが並列ストリームかどうかを返します。ストリームの処理方法を確認するために使用されます。
- **シグネチャ**:
  ```java
  boolean isParallel()
  ```

:::

:::details sequential() ~ 並列ストリームを逐次ストリームに変換

- **説明**:
  - 並列ストリームを逐次ストリームに変換します。逐次処理を強制するために使用されます。
- **シグネチャ**:
  ```java
  Stream<T> sequential()
  ```

:::

:::details parallel() ~ 逐次ストリームを並列ストリームに変換

- **説明**:
  - 逐次ストリームを並列ストリームに変換します。並列処理を強制するために使用されます。
- **シグネチャ**:
  ```java
  Stream<T> parallel()
  ```

:::

:::details unordered() ~ 順序が保証されないストリームに変換

- **説明**:
  - ストリームを順

序が保証されないストリームに変換します。要素の順序が重要でない場合に使用されます。

- **シグネチャ**:
  ```java
  Stream<T> unordered()
  ```

:::

### 集約操作（`Collectors`を使用）

:::details summingInt() ~ 合計の計算

- **説明**:
  - ストリームの要素を指定された関数でマッピングし、その合計を計算します。数値データの集計に使用されます。
- **シグネチャ**:
  ```java
  public static <T> Collector<T, ?, Integer> summingInt(ToIntFunction<? super T> mapper)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  int sum = list.stream()
                .collect(Collectors.summingInt(String::length));
  System.out.println(sum); // 11
  ```
  - **説明**: この例では、文字列の長さの合計を計算しています。

:::

:::details averagingInt() ~ 平均の計算

- **説明**:
  - ストリームの要素を指定された関数でマッピングし、その平均を計算します。数値データの平均値を取得するために使用されます。
- **シグネチャ**:
  ```java
  public static <T> Collector<T, ?, Double> averagingInt(ToIntFunction<? super T> mapper)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  double average = list.stream()
                       .collect(Collectors.averagingInt(String::length));
  System.out.println(average); // 3.6666666666666665
  ```
  - **説明**: この例では、文字列の長さの平均を計算しています。

:::

:::details summarizingInt() ~ 統計情報の取得

- **説明**:
  - ストリームの要素を指定された関数でマッピングし、その統計情報（合計、平均、最大値、最小値など）を取得します。数値データの統計情報を収集するために使用されます。
- **シグネチャ**:
  ```java
  public static <T> Collector<T, ?, IntSummaryStatistics> summarizingInt(ToIntFunction<? super T> mapper)
  ```
- **具体例**:
  ```java
  List<String> list = Arrays.asList("one", "two", "three");
  IntSummaryStatistics stats = list.stream()
                                   .collect(Collectors.summarizingInt(String::length));
  System.out.println(stats); // IntSummaryStatistics{count=3, sum=11, min=3, average=3.666667, max=5}
  ```
  - **説明**: この例では、文字列の長さの統計情報を取得しています。

:::

## 利用例

以下は、`Stream`インターフェースを使用してコレクションのデータをフィルタリング、マッピング、収集する例です。

```java
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class StreamExample {
    public static void main(String[] args) {
        List<String> list = Arrays.asList("one", "two", "three", "four");

        // コレクションからストリームを生成し、中間操作と終端操作を行う
        List<String> filteredList = list.stream()
                                        .filter(s -> s.startsWith("t"))
                                        .map(String::toUpperCase)
                                        .sorted()
                                        .collect(Collectors.toList());

        // 結果を表示
        filteredList.forEach(System.out::println);
    }
}
```

この例では、以下の操作を行っています。

1. `stream()`メソッドでリストからストリームを生成。
2. `filter`メソッドで、要素が`"t"`で始まるものだけをフィルタリング。
3. `map`メソッドで、各要素を大文字に変換。
4. `sorted`メソッドで、要素をソート。
5. `collect`メソッドで、結果をリストに収集。

## 解決したい技術的課題

### 複雑なデータ処理の簡素化

- **問題点**
  例えば、あるリストから特定の条件を満たす要素をフィルタリングし、変換した結果を別のリストに格納する必要がある場合、従来の方法では以下のように記述することが多い。

  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry", "date");
  List<String> result = new ArrayList<>();
  for (String s : list) {
      if (s.startsWith("a")) {
          result.add(s.toUpperCase());
      }
  }
  ```

- **解決策**
  Stream API を使うと、上記の処理を以下のように簡潔に記述できる。

  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry", "date");
  List<String> result = list.stream()
                            .filter(s -> s.startsWith("a"))
                            .map(String::toUpperCase)
                            .collect(Collectors.toList());
  ```

### パフォーマンスの最適化

- **問題点**
  大量のデータをフィルタリングし、その結果をリストに格納する場合、従来の方法では全要素を逐次的に処理するため、時間がかかる。

  ```java
  List<Integer> list = IntStream.range(0, 1000000).boxed().collect(Collectors.toList());
  List<Integer> evenNumbers = new ArrayList<>();
  for (Integer num : list) {
      if (num % 2 == 0) {
          evenNumbers.add(num);
      }
  }
  ```

- **解決策**
  Stream API の並列処理を使用して、処理を効率化できる。

  ```java
  List<Integer> list = IntStream.range(0, 1000000).boxed().collect(Collectors.toList());
  List<Integer> evenNumbers = list.parallelStream()
                                  .filter(num -> num % 2 == 0)
                                  .collect(Collectors.toList());
  ```

### コードの可読性と保守性の向上

- **問題点**
  データを変換し、集計する処理が複雑になると、コードが読みにくくなる。

  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry", "date");
  Map<Integer, List<String>> lengthMap = new HashMap<>();
  for (String s : list) {
      int length = s.length();
      if (!lengthMap.containsKey(length)) {
          lengthMap.put(length, new ArrayList<>());
      }
      lengthMap.get(length).add(s);
  }
  ```

- **解決策**
  Stream API を使って、コードを簡潔かつ明確にする。

  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry", "date");
  Map<Integer, List<String>> lengthMap = list.stream()
                                             .collect(Collectors.groupingBy(String::length));
  ```

## まとめ

- **Stream API**は、データ処理を簡潔かつ効率的に行うための API であり、その中心にあるのが`Stream`インターフェース
- `Stream`インターフェースは、中間操作と終端操作を提供し、データのフィルタリング、変換、集約などをサポートする
- `Stream`は遅延評価され、操作のパイプラインを構築することで、効率的なデータ処理が可能になる

これにより、データ処理を直感的かつ簡潔に表現できるため、コードの可読性と保守性が向上する。
