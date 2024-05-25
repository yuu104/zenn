---
title: "コレクション"
---

## コレクションの概要

- データのグループを効率的に管理・操作するためのクラスやインターフェースの集まりのこと
- データの追加、削除、検索、ソートなどの基本操作を提供する多くのインタフェースとクラスが含まれる

## コレクションの目的

### データ管理の効率化

- さまざまなデータ構造を効率的に管理すること
- これにより、データの保存、取得、操作が容易になる
- 例えば、`ArrayList`は動的配列として使用でき、データのランダムアクセスが高速
- `HashSet`は一意の要素を保持し、重複を排除するのに便利

### 再利用可能なアルゴリズムの提供

コレクションフレームワークは、多くの再利用可能なアルゴリズム（例えば、ソート、検索、フィルタリング）を提供します。これにより、データ操作に関する複雑なアルゴリズムを自分で実装する必要がなくなり、コードの簡潔さと信頼性が向上します。

### 一貫性のある API 提供

コレクションフレームワークは、一貫性のある API を提供します。これにより、異なるデータ構造間での操作が統一され、プログラムの可読性と保守性が向上します。例えば、`List`、`Set`、`Map`は共通の操作（例えば、要素の追加、削除、検索）をサポートし、統一された方法で扱うことができます。

## 解決したい技術的課題

### データの効率的な管理

プログラム内で大量のデータを効率的に管理することは重要です。従来、配列を使ってデータを管理していた場合、配列のサイズを変更するたびに新しい配列を作成し、既存のデータをコピーする必要がありました。コレクションフレームワークを使うと、`ArrayList`のような動的配列を利用して、データの追加や削除が効率的に行えます。

### 重複データの排除

一意の要素のみを保持する必要がある場合、`HashSet`などのコレクションを使用することで、重複データを簡単に排除できます。これにより、データの一意性を保証し、重複による問題を防ぐことができます。

### データ操作の標準化

コレクションフレームワークは、データ操作のための標準的な方法を提供します。これにより、独自のデータ操作ロジックを実装する必要がなくなり、コードの一貫性と再利用性が向上します。例えば、`Collections.sort`メソッドを使うと、リストを簡単にソートできます。

### パフォーマンスの最適化

特定の操作に最適なデータ構造を選択することで、プログラムのパフォーマンスを向上させることができます。例えば、要素の検索が頻繁に行われる場合、`HashMap`を使用すると高速な検索が可能です。また、要素の順序が重要な場合、`LinkedHashSet`や`TreeSet`を使用して、順序付きの集合を管理できます。

## コレクションの主なインタフェースとクラス

### インタフェース

- **Collection**: すべてのコレクションの基本インタフェース。
- **List**: 順序付きのコレクション。重複を許可する。
  - 実装クラス: `ArrayList`, `LinkedList`, `Vector`
- **Set**: 一意の要素を保持するコレクション。順序は保証されない。
  - 実装クラス: `HashSet`, `LinkedHashSet`, `TreeSet`
- **Queue**: 順序付きコレクション。通常、FIFO（先入れ先出し）で要素を保持。
  - 実装クラス: `LinkedList`, `PriorityQueue`
- **Map**: キーと値のペアを保持するコレクション。キーは一意でなければならない。
  - 実装クラス: `HashMap`, `LinkedHashMap`, `TreeMap`, `Hashtable`

### クラス

- **ArrayList**: 可変長の配列を実装するクラス。
- **LinkedList**: 両方向リンクリストを実装するクラス。
- **HashSet**: ハッシュテーブルを使用して要素を格納するセット。
- **TreeSet**: ソートされた順序で要素を保持するセット。
- **HashMap**: ハッシュテーブルを使用してキーと値のペアを格納するマップ。
- **TreeMap**: ソートされた順序でキーと値のペアを保持するマップ。

## 具体例

### List の使用例

```java
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        System.out.println("List size: " + list.size()); // 出力: List size: 3

        for (String fruit : list) {
            System.out.println(fruit);
        }
    }
}
```

### Set の使用例

```java
import java.util.HashSet;
import java.util.Set;

public class Main {
    public static void main(String[] args) {
        Set<String> set = new HashSet<>();
        set.add("apple");
        set.add("banana");
        set.add("apple"); // 重複する要素は無視される

        System.out.println("Set size: " + set.size()); // 出力: Set size: 2

        for (String fruit : set) {
            System.out.println(fruit);
        }
    }
}
```

### Map の使用例

```java
import java.util.HashMap;
import java.util.Map;

public class Main {
    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();
        map.put("apple", 1);
        map.put("banana", 2);
        map.put("cherry", 3);

        System.out.println("Map size: " + map.size()); // 出力: Map size: 3

        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
    }
}
```

## Stream API との統合

コレクションと Stream API を一緒に使用すると、データ操作がさらに簡単かつ効率的になる。

```java
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        List<String> upperCaseList = list.stream()
                                         .map(String::toUpperCase)
                                         .collect(Collectors.toList());

        upperCaseList.forEach(System.out::println);
    }
}
```

## `Collections` クラス

### 概要

- コレクションフレームワークで提供されるユーティリティクラス
- コレクションの操作を補助するための静的メソッドが多数含まれている
- インスタンス化できず、全てのメソッドは静的

### 目的

- コレクションの操作（ソート、検索、変換、同期化など）を簡潔に行うこと
- これにより、コードの可読性とメンテナンス性が向上する

### 主な特徴

- **ソート**: リストのソートを行うメソッドを提供。
- **検索**: コレクション内で特定の要素を検索するメソッドを提供。
- **変換**: コレクションの要素を変換するメソッドを提供。
- **同期化**: コレクションを同期化するメソッドを提供。
- **ユーティリティ**: コレクションの操作に便利なメソッドを多数提供。

### 主なメソッド

#### ソート関連

:::details sort() - リストのソート

- **説明**: リストを自然順序でソートする。
- **シグネチャ**: `void sort(List<T> list)`
- **使用例**:
  ```java
  List<String> list = new ArrayList<>(Arrays.asList("banana", "apple", "cherry"));
  Collections.sort(list);
  System.out.println(list); // [apple, banana, cherry]
  ```
  :::

:::details sort() - リストを指定のコンパレータでソート

- **説明**: 指定されたコンパレータでリストをソートする。
- **シグネチャ**: `void sort(List<T> list, Comparator<? super T> c)`
- **使用例**:
  ```java
  Collections.sort(list, Collections.reverseOrder());
  System.out.println(list); // [cherry, banana, apple]
  ```
  :::

#### 検索関連

:::details binarySearch() - リスト内のバイナリ検索

- **説明**: ソートされたリスト内で指定されたキーのバイナリ検索を行う。
- **シグネチャ**: `int binarySearch(List<? extends Comparable<? super T>> list, T key)`
- **使用例**:
  ```java
  List<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  Collections.sort(list);
  int index = Collections.binarySearch(list, "banana");
  System.out.println(index); // 1
  ```
  :::

:::details binarySearch() - 指定のコンパレータでバイナリ検索

- **説明**: コンパレータを使用して、ソートされたリスト内で指定されたキーのバイナリ検索を行う。
- **シグネチャ**: `int binarySearch(List<? extends T> list, T key, Comparator<? super T> c)`
- **使用例**:
  ```java
  int index = Collections.binarySearch(list, "banana", Collections.reverseOrder());
  System.out.println(index); // 1
  ```
  :::

#### 最小値・最大値関連

:::details max() - コレクション内の最大要素を取得

- **説明**: コレクション内の最大要素を返す。
- **シグネチャ**: `T max(Collection<? extends T> coll)`
- **使用例**:
  ```java
  int max = Collections.max(Arrays.asList(1, 2, 3));
  System.out.println(max); // 3
  ```
  :::

:::details max() - 指定のコンパレータで最大要素を取得

- **説明**: 指定されたコンパレータで比較してコレクション内の最大要素を返す。
- **シグネチャ**: `T max(Collection<? extends T> coll, Comparator<? super T> comp)`
- **使用例**:
  ```java
  String max = Collections.max(Arrays.asList("apple", "banana", "cherry"), Collections.reverseOrder());
  System.out.println(max); // cherry
  ```
  :::

:::details min() - コレクション内の最小要素を取得

- **説明**: コレクション内の最小要素を返す。
- **シグネチャ**: `T min(Collection<? extends T> coll)`
- **使用例**:
  ```java
  int min = Collections.min(Arrays.asList(1, 2, 3));
  System.out.println(min); // 1
  ```
  :::

:::details min() - 指定のコンパレータで最小要素を取得

- **説明**: 指定されたコンパレータで比較してコレクション内の最小要素を返す。
- **シグネチャ**: `T min(Collection<? extends T> coll, Comparator<? super T> comp)`
- **使用例**:
  ```java
  String min = Collections.min(Arrays.asList("apple", "banana", "cherry"), Collections.reverseOrder());
  System.out.println(min); // apple
  ```
  :::

#### 同期化関連

:::details synchronizedCollection() - コレクションの同期化

- **説明**: コレクションを同期化する。
- **シグネチャ**: `Collection<T> synchronizedCollection(Collection<T> c)`
- **使用例**:
  ```java
  Collection<String> syncCollection = Collections.synchronizedCollection(new ArrayList<>());
  ```
  :::

:::details synchronizedList() - リストの同期化

- **説明**: リストを同期化する。
- **シグネチャ**: `List<T> synchronizedList(List<T> list)`
- **使用例**:
  ```java
  List<String> syncList = Collections.synchronizedList(new ArrayList<>());
  ```
  :::

:::details synchronizedSet() - セットの同期化

- **説明**: セットを同期化する。
- **シグネチャ**: `Set<T> synchronizedSet(Set<T> s)`
- **使用例**:
  ```java
  Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
  ```
  :::

:::details synchronizedMap() - マップの同期化

- **説明**: マップを同期化する。
- **シグネチャ**: `Map<K, V> synchronizedMap(Map<K, V> m)`
- **使用例**:
  ```java
  Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());
  ```
  :::

#### 不変コレクション関連

:::details unmodifiableCollection() - 不変コレクションの作成

- **説明**: 不変コレクションを返す。
- **シグネチャ**: `Collection<T> unmodifiableCollection(Collection<? extends T> c)`
- **使用例**:
  ```java
  Collection<String> unmodifiableCollection = Collections.unmodifiableCollection(new ArrayList<>(Arrays.asList("apple", "banana")));
  ```
  :::

:::details unmodifiableList() - 不変リストの作成

- **説明**: 不変リストを返す。
- **シグネチャ**: `List<T> unmodifiableList(List<? extends T> list)`
- **使用例**:
  ```java
  List<String> unmodifiableList = Collections.unmodifiableList(new ArrayList<>(Arrays.asList("apple", "banana")));
  ```
  :::

:::details unmodifiableSet() - 不変セットの作成

- **説明**: 不変セットを返す。
- **シグネチャ**: `Set<T> unmodifiableSet(Set<? extends T> s)`
- **使用例**:
  ```java
  Set<String> unmodifiableSet = Collections.unmodifiableSet(new HashSet<>(Arrays.asList("apple", "banana")));
  ```
  :::

:::details unmodifiableMap() - 不変マップの作成

- **説明**: 不変マップを返す。
- **シグネチャ**: `Map<K, V> unmodifiableMap(Map<? extends K, ? extends V> m)`
- **使用例**:
  ```java
  Map<String, String> unmodifiableMap = Collections.unmodifiableMap(new HashMap<>(Map.of("apple", "fruit", "carrot", "vegetable")));
  ```
  :::

#### その他のユーティリティメソッド

:::details addAll() - コレクションに要素を追加

- **説明**: 指定された要素をコレクションに追加する。
- **シグネチャ**: `boolean addAll(Collection<? super T> c, T... elements)`
- **使用例**:
  ```java
  List<String> list = new ArrayList<>();
  Collections.addAll(list, "apple", "banana", "cherry");
  System.out.println(list); // [apple, banana, cherry]
  ```
  :::

:::details reverse() - リストの要素を逆順に並べ替え

- **説明**: リストの要素を逆順に並べ替える。
- **シグネチャ**: `void reverse(List<?> list)`
- **使用例**:
  ```java
  Collections.reverse(list);
  System.out.println(list); // [cherry, banana, apple]
  ```
  :::

:::details shuffle() - リストの要素をランダムに並べ替え

- **説明**: リストの要素をランダムに並べ替える。
- **シグネチャ**: `void shuffle(List<?> list)`
- **使用例**:
  ```java
  Collections.shuffle(list);
  System.out.println(list); // [banana, apple, cherry] など
  ```
  :::

:::details fill() - リストの全要素を置き換える

- **説明**: 指定されたリストの全ての要素を指定されたオブジェクトで置き換える。
- **シグネチャ**: `void fill(List<? super T> list, T obj)`
- **使用例**:
  ```java
  Collections.fill(list, "orange");
  System.out.println(list); // [orange, orange, orange]
  ```
  :::

:::details copy() - リストの内容をコピー

- **説明**: 元のリストの内容を新しいリストにコピーする。

- **シグネチャ**: `void copy(List<? super T> dest, List<? extends T> src)`
- **使用例**:
  ```java
  List<String> dest = new ArrayList<>(Arrays.asList("x", "x", "x"));
  Collections.copy(dest, list);
  System.out.println(dest); // [apple, banana, cherry]
  ```
  :::

:::details nCopies() - オブジェクトの複数個のリストを返す

- **説明**: 指定されたオブジェクトの n 個のイミュータブルなリストを返す。
- **シグネチャ**: `List<T> nCopies(int n, T o)`
- **使用例**:
  ```java
  List<String> nCopiesList = Collections.nCopies(3, "apple");
  System.out.println(nCopiesList); // [apple, apple, apple]
  ```
  :::

:::details replaceAll() - 全出現要素を置き換える

- **説明**: 指定されたリスト内の全ての出現する要素を新しい要素で置き換える。
- **シグネチャ**: `boolean replaceAll(List<T> list, T oldVal, T newVal)`
- **使用例**:
  ```java
  Collections.replaceAll(list, "apple", "orange");
  System.out.println(list); // [orange, banana, cherry]
  ```
  :::

:::details rotate() - リストの要素を循環移動

- **説明**: 指定された距離だけリストの要素を循環移動する。
- **シグネチャ**: `void rotate(List<?> list, int distance)`
- **使用例**:
  ```java
  Collections.rotate(list, 1);
  System.out.println(list); // [cherry, orange, banana]
  ```
  :::

:::details swap() - リスト内の二つの要素を入れ替え

- **説明**: リスト内の二つの要素を入れ替える。
- **シグネチャ**: `void swap(List<?> list, int i, int j)`
- **使用例**:
  ```java
  Collections.swap(list, 0, 1);
  System.out.println(list); // [orange, cherry, banana]
  ```
  :::

以上が`Collections`クラスの主要なメソッドのリストです。それぞれのメソッドを使用することで、コレクションの操作が簡単かつ効率的に行えるようになります。

### 解決したい技術的課題

:::details コレクションのソート

**問題点**: コレクションを効率的にソートしたい。
**解決策**: `Collections.sort()`メソッドを使用すると、リストを簡単にソートできる。逆順ソートには`Collections.reverseOrder()`を使用する。

```java
List<Integer> numbers = Arrays.asList(5, 3, 8, 1);
Collections.sort(numbers);
System.out.println(numbers); // [1, 3, 5, 8]
```

:::

:::details コレクションの同期化

**問題点**: 複数スレッドからコレクションに安全にアクセスしたい。
**解決策**: `Collections.synchronizedList()`などを使用して、コレクションを同期化する。

```java
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
syncList.add("apple");
synchronized(syncList) {
    for (String item : syncList) {
        System.out.println(item);
    }
}
```

:::
:::details 不変コレクションの作成

**問題点**: コレクションを変更不可にしたい。
**解決策**: `Collections.unmodifiableList()`などを使用して、不変コレクションを作成する。

```java
List<String> list = new ArrayList<>(Arrays.asList("apple", "banana"));
List<String> unmodifiableList = Collections.unmodifiableList(list);
// unmodifiableList.add("cherry"); // UnsupportedOperationExceptionが発生する
```

:::

:::details 最大値・最小値の取得

**問題点**: コレクション内の最大値や最小値を効率的に取得したい。
**解決策**: `Collections.max()`や`Collections.min()`を使用して、簡単に最大値・最小値を取得する。

```java
List<Integer> numbers = Arrays.asList(5, 3, 8, 1);
int max = Collections.max(numbers);
int min = Collections.min(numbers);
System.out.println("Max: " + max); // Max: 8
System.out.println("Min: " + min); // Min: 1
```

:::

## まとめ

コレクションフレームワークは、データの効率的な管理、標準的なアルゴリズムの提供、一貫性のある API の提供により、Java プログラミングの重要な部分を担っています。Stream API と組み合わせることで、データ操作がさらに効率的かつ簡単になります。コレクションフレームワークを使うことで、プログラムのパフォーマンスを最適化し、コードの可読性と保守性を向上させることができます。
