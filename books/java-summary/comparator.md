---
title: "Comparatorインターフェース"
---

## 概要

Java のコレクションやストリームの要素を順序付けるための比較機能を提供するインターフェース。`java.util`パッケージに属し、2 つのオブジェクトを比較して順序を決定するためのメソッドを定義している。これにより、カスタムの比較ロジックを実装してソートを行うことができる。

## 目的

- **カスタム比較ロジックの提供**:
  特定の基準に基づいてオブジェクトを比較し、順序付けを行うための方法を提供する。
- **コレクションのソート**:
  リストやセットなどのコレクションの要素をカスタムの順序でソートするために使用される。
- **ストリーム操作**:
  ストリーム API でソートや最大/最小値の計算などの操作にカスタムの順序付けを適用するために使用される。

## Comparator インターフェースの主要メソッド

:::details compare(T o1, T o2) ~ 2 つのオブジェクトの比較

- **説明**:
  - 2 つのオブジェクトを比較し、1 つ目のオブジェクトが 2 つ目のオブジェクトより小さい、等しい、大きいを示す整数を返す。
- **シグネチャ**:
  ```java
  int compare(T o1, T o2)
  ```
- **例**:
  ```java
  Comparator<Integer> comparator = (a, b) -> Integer.compare(a, b);
  int result = comparator.compare(5, 10); // -1 (5は10より小さい)
  ```
  :::

:::details reversed() ~ 逆順の Comparator を返す

- **説明**:
  - 現在の Comparator の順序を逆にした Comparator を返す。
- **シグネチャ**:
  ```java
  default Comparator<T> reversed()
  ```
- **例**:
  ```java
  Comparator<Integer> comparator = Comparator.naturalOrder();
  Comparator<Integer> reversedComparator = comparator.reversed();
  int result = reversedComparator.compare(5, 10); // 1 (逆順なので5は10より大きいとみなす)
  ```
  :::

:::details thenComparing(Comparator<? super T> other) ~ 次の Comparator との連結

- **説明**:
  - 現在の Comparator で比較した結果が等しい場合に、次の Comparator で比較する。
- **シグネチャ**:
  ```java
  default Comparator<T> thenComparing(Comparator<? super T> other)
  ```
- **例**:
  ```java
  Comparator<Person> byLastName = Comparator.comparing(Person::getLastName);
  Comparator<Person> byFirstName = Comparator.comparing(Person::getFirstName);
  Comparator<Person> combinedComparator = byLastName.thenComparing(byFirstName);
  ```
  :::

## 代表的な静的メソッド

:::details naturalOrder() ~ 自然順序の Comparator を返す

- **説明**:
  - 要素の自然順序（通常は`Comparable`が定義する順序）に従う Comparator を返す。
- **シグネチャ**:
  ```java
  static <T extends Comparable<? super T>> Comparator<T> naturalOrder()
  ```
- **例**:
  ```java
  Comparator<Integer> comparator = Comparator.naturalOrder();
  int result = comparator.compare(5, 10); // -1
  ```
  :::

:::details reverseOrder() ~ 逆自然順序の Comparator を返す

- **説明**:
  - 要素の逆自然順序に従う Comparator を返す。
- **シグネチャ**:
  ```java
  static <T extends Comparable<? super T>> Comparator<T> reverseOrder()
  ```
- **例**:
  ```java
  Comparator<Integer> comparator = Comparator.reverseOrder();
  int result = comparator.compare(5, 10); // 1
  ```
  :::

:::details comparing(Function<? super T, ? extends U> keyExtractor) ~ キー抽出関数に基づく Comparator を返す

- **説明**:
  - 要素からキーを抽出し、そのキーの自然順序に基づいて比較する Comparator を返す。
- **シグネチャ**:
  ```java
  static <T, U extends Comparable<? super U>> Comparator<T> comparing(Function<? super T, ? extends U> keyExtractor)
  ```
- **例**:
  ```java
  Comparator<Person> comparator = Comparator.comparing(Person::getLastName);
  int result = comparator.compare(person1, person2); // lastNameで比較
  ```
  :::

:::details comparing(Function<? super T, ? extends U> keyExtractor, Comparator<? super U> keyComparator) ~ カスタムキー Comparator を使った比較

- **説明**:
  - 要素からキーを抽出し、指定されたキー Comparator に基づいて比較する Comparator を返す。
- **シグネチャ**:
  ```java
  static <T, U> Comparator<T> comparing(Function<? super T, ? extends U> keyExtractor, Comparator<? super U> keyComparator)
  ```
- **例**:
  ```java
  Comparator<Person> comparator = Comparator.comparing(Person::getLastName, String.CASE_INSENSITIVE_ORDER);
  int result = comparator.compare(person1, person2); // case-insensitiveでlastNameを比較
  ```
  :::

:::details comparingInt(ToIntFunction<? super T> keyExtractor) ~ int キーの自然順序に基づく Comparator を返す

- **説明**:
  - 要素から int キーを抽出し、そのキーの自然順序に基づいて比較する Comparator を返す。
- **シグネチャ**:
  ```java
  static <T> Comparator<T> comparingInt(ToIntFunction<? super T> keyExtractor)
  ```
- **例**:
  ```java
  Comparator<Person> comparator = Comparator.comparingInt(Person::getAge);
  int result = comparator.compare(person1, person2); // ageで比較
  ```
  :::

:::details comparingDouble(ToDoubleFunction<? super T> keyExtractor) ~ double キーの自然順序に基づく Comparator を返す

- **説明**:
  - 要素から double キーを抽出し、そのキーの自然順序に基づいて比較する Comparator を返す。
- **シグネチャ**:
  ```java
  static <T> Comparator<T> comparingDouble(ToDoubleFunction<? super T> keyExtractor)
  ```
- **例**:
  ```java
  Comparator<Employee> comparator = Comparator.comparingDouble(Employee::getSalary);
  int result = comparator.compare(employee1, employee2); // salaryで比較
  ```
  :::

:::details comparingLong(ToLongFunction<? super T> keyExtractor) ~ long キーの自然順序に基づく Comparator を返す

- **説明**:
  - 要素から long キーを抽出し、そのキーの自然順序に基づいて比較する Comparator を返す。
- **シグネチャ**:
  ```java
  static <T> Comparator<T> comparingLong(ToLongFunction<? super T> keyExtractor)
  ```
- **例**:
  ```java
  Comparator<Event> comparator = Comparator.comparingLong(Event::getTimestamp);
  int result = comparator.compare(event1, event2); // timestampで比較
  ```
  :::

### 使用例

以下は、`Comparator`インターフェースを使用してリストをカスタム順序でソートする例です。

```java
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class ComparatorExample {
    public static void main(String[] args) {
        List<Person> people = Arrays.asList(
            new Person("John", "Doe", 30),
            new Person("Jane", "Doe", 25),
            new Person("Alice", "Smith", 35)
        );

        // LastNameでソートし、同じLastNameの場合はFirstNameでソート
        Comparator<Person> comparator = Comparator
                                        .comparing(Person::getLastName)
                                        .thenComparing(Person::getFirstName);

        people.sort(comparator);

        // 結果を表示
        people.forEach(System.out::println);
    }
}

class Person {
    private String firstName;
    private String lastName;
    private int age;

    // コンストラクタ、ゲッター、toStringメソッド
    public Person(String firstName, String lastName, int age) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.age = age;
    }

    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public int getAge() { return age; }

    @Override
    public String toString() {
        return firstName + " " + lastName + " (" + age + ")";
    }
}
```

この例では、`Comparator`を使って`Person`オブジェクトのリストを

`lastName`でソートし、同じ`lastName`の場合は`firstName`でソートしています。

## まとめ

`Comparator`インターフェースは、Java でオブジェクトの順序をカスタムに定義するための強力なツール。コレクションやストリームのソート、比較操作に広く利用され、柔軟な順序付けを実現する。Comparator の主要メソッドと使用例を理解することで、複雑なソートやカスタム比較ロジックを効果的に実装できるようになる。
