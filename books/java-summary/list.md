---
title: "List インターフェース"
---

## 概要

- 順序付けられた要素のコレクションを表現するインターフェース
- 要素の挿入順序を保持し、重複要素を許可する
- 代表的な実装として `ArrayList` と `LinkedList` がある
- `List` は、データの追加、削除、検索、並べ替えなどの操作を効率的に行うための便利なデータ構造

## 目的

- `List` を使用する主な目的は、順序付きのコレクションを扱うこと
- これにより、データの挿入、削除、アクセスを簡単かつ効率的に行うことができる
- 特に、順序を保持したまま操作を行いたい場合や、動的にサイズを変更したい場合に有用

## 主な特徴

1. **順序の保持**: 挿入した順序で要素が保持される。
2. **ランダムアクセス**: インデックスを使用して任意の位置の要素にアクセスできる。
3. **重複の許可**: 同じ要素を複数回追加できる。
4. **コレクションの操作**: 要素の挿入、削除、検索、ソート、フィルタリングなどの操作をサポート。

## 主要メソッド

### 基本操作

:::details of(E ...elements) ~ 不変リストの作成

- **説明**
  複数の要素を持つ不変リストを作成する。
- **シグネチャ**
  複数のオーバーロードがある。

  ```java
  static <E> List<E> of(E... elements)
  static <E> List<E> of()
  static <E> List<E> of(E e1)
  static <E> List<E> of(E e1, E e2)
  static <E> List<E> of(E e1, E e2, E e3)
  static <E> List<E> of(E e1, E e2, E e3, E e4)
  static <E> List<E> of(E e1, E e2, E e3, E e4, E e5)
  static <E> List<E> of(E e1, E e2, E e3, E e4, E e5, E e6)
  static <E> List<E> of(E e1, E e2, E e3, E e4, E e5, E e6, E e7)
  static <E> List<E> of(E e1, E e2, E e3, E e4, E e5, E e6, E e7, E e8)
  static <E> List<E> of(E e1, E e2, E e3, E e4, E e5, E e6, E e7, E e8, E e9)
  static <E> List<E> of(E e1, E e2, E e3, E e4, E e5, E e6, E e7, E e8, E e9, E e10)
  ```

- **使用例**
  ```java
  List<String> list = List.of("one", "two", "three");
  System.out.println(list); // [one, two, three]
  ```

:::

:::details add(E e) ~ 要素の追加

- **説明**:
  - リストの末尾に指定された要素を追加します。
- **シグネチャ**:
  ```java
  boolean add(E e)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one"); // ["one"]
  list.add("two"); // ["one", "two"]
  ```
  :::

:::details add(int index, E element) ~ 指定位置への要素の追加

- **説明**:
  - 指定された位置に要素を挿入します。
- **シグネチャ**:
  ```java
  void add(int index, E element)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add(0, "two"); // ["two", "one"]
  ```
  :::

:::details get(int index) ~ 指定位置の要素の取得

- **説明**:
  - 指定された位置にある要素を返します。
- **シグネチャ**:
  ```java
  E get(int index)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  String element = list.get(0); // "one"
  ```
  :::

:::details set(int index, E element) ~ 指定位置の要素の置き換え

- **説明**:
  - 指定された位置の要素を指定された要素で置き換えます。
- **シグネチャ**:
  ```java
  E set(int index, E element)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.set(0, "two"); // ["two"]
  ```
  :::

:::details remove(int index) ~ 指定位置の要素の削除

- **説明**:
  - 指定された位置にある要素を削除します。
- **シグネチャ**:
  ```java
  E remove(int index)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.remove(0); // ["two"]
  ```
  :::

:::details remove(Object o) ~ 指定された要素の削除

- **説明**:
  - リストから指定された要素の最初の出現を削除します。
- **シグネチャ**:
  ```java
  boolean remove(Object o)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.remove("one"); // ["two"]
  ```
  :::

### 検索操作

:::details indexOf(Object o) ~ 最初の出現位置の取得

- **説明**:
  - 指定された要素が最初に出現する位置を返します。存在しない場合は`-1`を返します。
- **シグネチャ**:
  ```java
  int indexOf(Object o)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  int index = list.indexOf("two"); // 1
  ```
  :::

:::details lastIndexOf(Object o) ~ 最後の出現位置の取得

- **説明**:
  - 指定された要素が最後に出現する位置を返します。存在しない場合は`-1`を返します。
- **シグネチャ**:
  ```java
  int lastIndexOf(Object o)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.add("one");
  int index = list.lastIndexOf("one"); // 2
  ```
  :::

### 範囲操作

:::details subList(int fromIndex, int toIndex) ~ 部分リストの取得

- **説明**:
  - 指定された範囲内の要素を含む部分リストを返します。
- **シグネチャ**:
  ```java
  List<E> subList(int fromIndex, int toIndex)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.add("three");
  List<String> sublist = list.subList(1, 3); // ["two", "three"]
  ```
  :::

### コレクション操作

:::details addAll(Collection<? extends E> c) ~ すべての要素の追加

- **説明**:
  - 指定されたコレクションのすべての要素をリストの末尾に追加します。
- **シグネチャ**:
  ```java
  boolean addAll(Collection<? extends E> c)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.addAll(Arrays.asList("two", "three")); // ["one", "two", "three"]
  ```
  :::

:::details addAll(int index, Collection<? extends E> c) ~ 指定位置へのすべての要素の追加

- **説明**:
  - 指定されたコレクションのすべての要素を指定された位置に挿入します。
- **シグネチャ**:
  ```java
  boolean addAll(int index, Collection<? extends E> c)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.addAll(1, Arrays.asList("two", "three")); // ["one", "two", "three"]
  ```
  :::

:::details removeAll(Collection<?> c) ~ 指定された要素を含むすべての要素の削除

- **説明**:
  - リストから指定されたコレクションに含まれるすべての要素を削除します。
- **シグネチャ**:
  ```java
  boolean removeAll(Collection<?> c)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.add("three");
  list.removeAll(Arrays.asList("one", "three")); // ["two"]
  ```
  :::

:::details retainAll(Collection<?> c) ~ 指定された要素を含む要素の保持

- **説明**:
  - リストから指定されたコレクションに含まれないすべての要素を削除します。
- **シグネチャ**:
  ```java
  boolean retainAll(Collection<?> c)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.add("three");
  list.retainAll(Arrays.asList("one", "three")); // ["one", "three"]
  ```
  :::

:::details clear() ~ すべての要素の削除

- **説明**:
  - リストからすべての要素を削除します。
- **シグネチャ**:
  ```java
  void clear()
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  list.clear(); // []
  ```
  :::

### その他の操作

:::details size() ~ リストのサイズの取得

- **説明**:
  - リストの要素数を返します。
- **シグネチャ**:
  ```java
  int size()
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  int size = list.size(); //
  ```

:::

:::details isEmpty() ~ リストが空かどうかの確認

- **説明**:
- リストが要素を含んでいない場合は`true`を返し、そうでない場合は`false`を返します。
- **シグネチャ**:

```java
boolean isEmpty()
```

- **例**:
  ```java
  List<String> list = new ArrayList<>();
  boolean empty = list.isEmpty(); // true
  list.add("one");
  empty = list.isEmpty(); // false
  ```
  :::

:::details contains(Object o) ~ 要素が含まれているかの確認

- **説明**:
  - リストに指定された要素が含まれている場合は`true`を返し、そうでない場合は`false`を返します。
- **シグネチャ**:
  ```java
  boolean contains(Object o)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  boolean contains = list.contains("one"); // true
  contains = list.contains("two"); // false
  ```
  :::

:::details iterator() ~ イテレータの取得

- **説明**:
  - リスト内の要素を反復するためのイテレータを返します。
- **シグネチャ**:
  ```java
  Iterator<E> iterator()
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  Iterator<String> iterator = list.iterator();
  while (iterator.hasNext()) {
      System.out.println(iterator.next());
  }
  ```
  :::

:::details toArray() ~ 配列への変換

- **説明**:
  - リスト内のすべての要素を含む配列を返します。
- **シグネチャ**:
  ```java
  Object[] toArray()
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  Object[] array = list.toArray(); // ["one", "two"]
  ```
  :::

:::details toArray(T[] a) ~ 指定された型の配列への変換

- **説明**:
  - リスト内のすべての要素を指定された型の配列に格納し、返します。
- **シグネチャ**:
  ```java
  <T> T[] toArray(T[] a)
  ```
- **例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("one");
  list.add("two");
  String[] array = list.toArray(new String[0]); // ["one", "two"]
  ```
  :::

## まとめ

`List`インターフェースは、順序付けされたコレクションを管理するための豊富なメソッドを提供します。要素の追加、削除、検索、部分リストの取得、コレクションの操作など、様々な操作を効率的に行うことができます。これらのメソッドを理解し、適切に使用することで、リストの操作を効果的に行うことができます。

## 解決したい技術的課題

### 動的なデータの挿入・削除

- **問題点**
  配列は固定サイズであり、要素数の変更に柔軟に対応できない。挿入や削除が頻繁に行われる場合、配列のサイズ変更や要素のシフト操作がパフォーマンスの低下を引き起こす。

- **解決策**
  `ArrayList`や`LinkedList`を使用することで、動的なサイズ変更が可能となり、挿入や削除が効率的に行える。特に、`ArrayList`はランダムアクセスが高速で、`LinkedList`は頻繁な挿入・削除に適している。

  ```java
  List<String> arrayList = new ArrayList<>();
  arrayList.add("apple");
  arrayList.add("banana");
  arrayList.remove("apple");

  List<String> linkedList = new LinkedList<>();
  linkedList.add("apple");
  linkedList.add("banana");
  linkedList.remove("apple");
  ```

### 順序の保持とアクセスの効率化

- **問題点**
  順序を保持しながらデータを操作する必要がある場合、配列では操作が煩雑になることがある。また、ランダムアクセスが必要な場合、効率的なデータ構造が求められる。

- **解決策**
  `List`は順序を保持しつつ、効率的なアクセスを提供する。特に、`ArrayList`はランダムアクセスが高速であり、`LinkedList`は順序を保持しながら挿入・削除が効率的に行える。

  ```java
  List<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  String secondElement = list.get(1); // banana
  list.add(1, "blueberry");
  System.out.println(list); // [apple, blueberry, banana, cherry]
  ```

## まとめ

`List`は順序付き要素のコレクションを提供し、動的なデータ操作、順序保持、イミュータブルリストの作成、並行性のある操作など、多くの技術的課題を解決するための強力なツール。`ArrayList`や`LinkedList`などの具体的な実装を活用することで、特定の要件に応じた最適なデータ操作が可能になる。

システム開発において、配列ではなく`List`を使用することは、多くのケースでコードの品質を向上させる。以下にその理由と考慮すべき点を詳述する。

## 配列と `List` の比較

### 配列

- **固定サイズ**: 作成時にサイズを指定する必要があり、動的なサイズ変更ができない。
- **低レベル操作**: 要素の追加や削除を手動で管理する必要があり、コードが煩雑になりがち。
- **性能**: メモリ使用量が少なく、高速に動作するが、柔軟性に欠ける。

### `List`

- **動的サイズ**: 要素の追加や削除が容易で、動的にサイズを変更できる。
- **高レベル操作**: 豊富なメソッドを提供しており、直感的に操作できる。
- **抽象化**: インターフェースで定義されているため、実装を容易に変更できる。

### `List` の利点

1. **柔軟性**

   - リストは動的にサイズを変更できるため、要素の追加や削除が簡単。
   - `ArrayList`や`LinkedList`など、用途に応じた実装を選択できる。

2. **可読性と保守性**

   - 高レベルのメソッドを提供するため、コードが簡潔で読みやすくなる。
   - `add()`, `remove()`, `contains()`, `get()`などのメソッドを使うことで、直感的にリストを操作できる。

3. **標準的なインターフェース**

   - `List`インターフェースを使用することで、実装を切り替える際の影響を最小限に抑えられる。
   - 例えば、`ArrayList`から`LinkedList`に変更する際も、インターフェースを使っている限りコードの変更は少ない。

4. **スレッドセーフ**

   - `Collections.synchronizedList()`や`CopyOnWriteArrayList`を使用することで、スレッドセーフなリストを簡単に作成できる。

5. **便利なユーティリティメソッド**
   - `Collections`や`Streams`と連携することで、リストの操作がさらに簡単になる。
   - 例えば、ソートやフィルタリング、集約などの操作が容易になる。

### 配列が適している場合

- **固定サイズのデータ**: データのサイズが固定で、変更されない場合は配列が適している。
- **性能が重要**: メモリ使用量を最小限に抑え、最高のパフォーマンスが求められる場合は配列が適している。

### 結論

システム開発において、ほとんどの場合`List`を使用することが推奨される。`List`は柔軟性が高く、コードの可読性と保守性を向上させるため、特に動的なデータ操作が必要な場合に非常に有用。一方、固定サイズのデータや最高のパフォーマンスが求められる場合には、配列を使用するのが適している。
具体的なシナリオに応じて`List`と配列を使い分けることで、システム全体の品質と効率を最大化できる。

## `List` は参照型しか扱えない

- 配列とは違い、`int` や `double`、`char` などのプリミティブ型を扱えない
- `List`は参照型（オブジェクト）を扱うためのインターフェースであり、プリミティブ型（基本型）を直接扱うことはできない
- しかし、Java の**オートボクシング機能**を利用して、**プリミティブ型を対応するラッパークラスで扱うことができる**

| プリミティブ型 | ラッパークラス |
| -------------- | -------------- |
| `boolean`      | `Boolean`      |
| `char`         | `Character`    |
| `byte`         | `Byte`         |
| `short`        | `Short`        |
| `int`          | `Integer`      |
| `long`         | `Long`         |
| `float`        | `Float`        |
| `double`       | `Double`       |

### オートボクシング

オートボクシングは、プリミティブ型を対応するラッパークラスに自動的に変換する機能。
これにより、プリミティブ型の値を`List`に格納することができる。

```java
List<Integer> intList = new ArrayList<>();
intList.add(1);  // プリミティブ型intが自動的にIntegerに変換される
intList.add(2);
intList.add(3);

System.out.println(intList);  // [1, 2, 3]
```

### アンボクシング

アンボクシングは、ラッパークラスのオブジェクトをプリミティブ型に自動的に変換する機能。
`List` から値を取り出す際に便利。

```java
int firstElement = intList.get(0);  // Integerが自動的にintに変換される
System.out.println(firstElement);  // 1
```

### ラッパークラスを使う利点と注意点

:::details 利点

1. **汎用性**：`List`やその他のコレクションにプリミティブ型のデータを簡単に格納できる。
2. **オブジェクト特有の機能**：ラッパークラスにはプリミティブ型にはないメソッドが提供されており、例えば`Integer.parseInt()`や`Double.isNaN()`などが利用できる。

:::

:::details 注意点

1. **メモリ効率**：ラッパークラスはプリミティブ型よりも多くのメモリを使用する。
2. **パフォーマンス**：オートボクシングとアンボクシングは、必要に応じて自動的に変換を行うため、頻繁な変換が発生するとパフォーマンスに影響が出る可能性がある。

:::

### プリミティブ型専用のコレクション

大量のプリミティブ型データを扱う場合、Apache Commons や Trove、FastUtil などのサードパーティライブラリを使用すると、プリミティブ型専用のコレクションを利用でき、メモリ効率とパフォーマンスが向上する。

- **Apache Commons Primitives**：

  ```java
  IntList intList = new ArrayIntList();
  intList.add(1);
  intList.add(2);
  ```

- **Trove**：
  ```java
  TIntArrayList troveIntList = new TIntArrayList();
  troveIntList.add(1);
  troveIntList.add(2);
  ```

### まとめ

`List`は参照型しか直接扱えないが、オートボクシングとアンボクシングを利用することで、プリミティブ型も実質的に扱うことができる。大量のプリミティブ型データを扱う場合は、専用のコレクションライブラリを検討することが推奨される。
