---
title: "Stream API"
---

## 目的

Java Stream API は、コレクションデータの処理を効率化し、コードの簡潔さと可読性を向上させるために導入された機能。関数型プログラミングのパラダイムを取り入れ、データ処理を宣言的に記述することを可能にする。

## 主な特徴

1. **宣言的プログラミング**:

   - コードの意図を明確に表現する。
   - イテレータやループの使用を避け、データ処理の流れを簡潔にする。

2. **パイプライン処理**:

   - 一連の処理ステップをチェーンで繋げることができる。
   - 各ステップは中間操作（intermediate operation）か終端操作（terminal operation）として分類される。

3. **遅延評価**:
   - 中間操作は遅延評価され、終端操作が呼ばれたときに初めて実行される。
   - 効率的な処理を実現し、必要なデータのみを計算する。

## 基本構成要素

1. **Source**:

   - Stream の入力となるデータソース。コレクション、配列、I/O チャネルなど。
   - 例: `List<String> list = Arrays.asList("a", "b", "c");`

2. **Intermediate Operations**:

   - ストリームを変換する操作。遅延評価され、ストリームを返す。
   - 例: `filter()`, `map()`, `sorted()`

3. **Terminal Operations**:
   - ストリームを消費し、結果を生成する操作。これによりストリームの処理が完了する。
   - 例: `forEach()`, `collect()`, `reduce()`

## 主な操作

:::details filter() - 要素のフィルタリング

- **説明**: 指定した条件に一致する要素のみを含む新しいストリームを返す。
- **シグネチャ**: `Stream<T> filter(Predicate<? super T> predicate)`
- **使用例**:
  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry");
  List<String> result = list.stream()
                            .filter(s -> s.startsWith("a"))
                            .collect(Collectors.toList());
  System.out.println(result); // [apple]
  ```
  :::

:::details map() - 要素の変換

- **説明**: 各要素に対して関数を適用し、その結果からなる新しいストリームを返す。
- **シグネチャ**: `<R> Stream<R> map(Function<? super T, ? extends R> mapper)`
- **使用例**:
  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry");
  List<Integer> lengths = list.stream()
                              .map(String::length)
                              .collect(Collectors.toList());
  System.out.println(lengths); // [5, 6, 6]
  ```
  :::

:::details sorted() - 要素のソート

- **説明**: 自然順序または指定されたコンパレータに基づいて要素をソートした新しいストリームを返す。
- **シグネチャ**: `Stream<T> sorted()`
- **シグネチャ**: `Stream<T> sorted(Comparator<? super T> comparator)`
- **使用例**:
  ```java
  List<String> list = Arrays.asList("banana", "apple", "cherry");
  List<String> sortedList = list.stream()
                                .sorted()
                                .collect(Collectors.toList());
  System.out.println(sortedList); // [apple, banana, cherry]
  ```
  :::

:::details collect() - 結果の収集

- **説明**: ストリームの要素を収集し、リスト、セット、マップなどのコレクションに変換する。
- **シグネチャ**: `<R, A> R collect(Collector<? super T, A, R> collector)`
- **使用例**:
  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry");
  List<String> collectedList = list.stream()
                                   .collect(Collectors.toList());
  System.out.println(collectedList); // [apple, banana, cherry]
  ```
  :::

:::details forEach() - 各要素に対する操作

- **説明**: ストリームの各要素に対して指定されたアクションを実行する。
- **シグネチャ**: `void forEach(Consumer<? super T> action)`
- **使用例**:
  ```java
  List<String> list = Arrays.asList("apple", "banana", "cherry");
  list.stream().forEach(System.out::println);
  // apple
  // banana
  // cherry
  ```
  :::

:::details reduce() - 要素の集約

- **説明**: ストリームの要素を集約する。初期値と結合関数を使用する。
- **シグネチャ**: `T reduce(T identity, BinaryOperator<T> accumulator)`
- **使用例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
  int sum = list.stream()
                .reduce(0, Integer::sum);
  System.out.println(sum); // 15
  ```
  :::

:::details distinct() - 重複の除去

- **説明**: 重複する要素を除去した新しいストリームを返す。
- **シグネチャ**: `Stream<T> distinct()`
- **使用例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 2, 3, 4, 4, 5);
  List<Integer> distinctList = list.stream()
                                   .distinct()
                                   .collect(Collectors.toList());
  System.out.println(distinctList); // [1, 2, 3, 4, 5]
  ```
  :::

:::details limit() - 要素数の制限

- **説明**: 指定した要素数に制限した新しいストリームを返す。
- **シグネチャ**: `Stream<T> limit(long maxSize)`
- **使用例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
  List<Integer> limitedList = list.stream()
                                  .limit(3)
                                  .collect(Collectors.toList());
  System.out.println(limitedList); // [1, 2, 3]
  ```
  :::

:::details skip() - 要素のスキップ

- **説明**: 指定した要素数をスキップした新しいストリームを返す。
- **シグネチャ**: `Stream<T> skip(long n)`
- **使用例**:
  ```java
  List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
  List<Integer> skippedList = list.stream()
                                  .skip(2)
                                  .collect(Collectors.toList());
  System.out.println(skippedList); // [3, 4, 5]
  ```
  :::

## 利用例

```java
List<String> list = Arrays.asList("a", "b", "c", "d");
List<String> result = list.stream()
                          .filter(s -> s.contains("a"))
                          .map(String::toUpperCase)
                          .sorted()
                          .collect(Collectors.toList());
```

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

### エラー処理の簡素化

- **問題点**
  データ処理中に発生する例外の処理を適切に行うのが難しい。

  ```java
  List<String> list = Arrays.asList("1", "2", "three", "4");
  List<Integer> integers = new ArrayList<>();
  for (String s : list) {
      try {
          integers.add(Integer.parseInt(s));
      } catch (NumberFormatException e) {
          // エラー処理
      }
  }
  ```

- **解決策**
  Stream API と Optional を使ってエラー処理を簡潔にする。

  ```java
  List<String> list = Arrays.asList("1", "2", "three", "4");
  List<Integer> integers = list.stream()
                               .map(s -> {
                                   try {
                                       return Optional.of(Integer.parseInt(s));
                                   } catch (NumberFormatException e) {
                                       return Optional.<Integer>empty();
                                   }
                               })
                               .filter(Optional::isPresent)
                               .map(Optional::get)
                               .collect(Collectors.toList());
  ```

これらの例を通じて、Stream API を利用することで、複雑なデータ処理の簡素化、パフォーマンスの最適化、コードの可読性と保守性の向上、エラー処理の簡素化を実現できることが理解できる。

## まとめ

Java Stream API は、データ処理の簡素化と効率化を目的とした強力なツール。宣言的プログラミング、パイプライン処理、遅延評価といった特徴を活用することで、複雑なデータ処理も簡潔に実装できる。これにより、コードの可読性が向上し、保守性が高まる。技術的課題に対しても効果的な解決策を提供するため、モダンな Java 開発において欠かせない技術となっている。
