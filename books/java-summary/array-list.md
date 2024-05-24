---
title: "ArrayList クラス"
---

## 概要

- `ArrayList`は、動的配列として動作する、 `List` インターフェースを実装したクラス
- 要素のランダムアクセスとサイズ変更を効率的に行うために使用される
- 基本的には配列をベースにしたデータ構造であり、配列の長所を活かしながらも、その短所を補うためのメソッドを提供する

## 目的

- 動的なデータ管理と高速なランダムアクセスを実現すること
- 配列の固定サイズの制約を克服し、効率的に要素の追加、削除、アクセスを行うことができる

## 主な特徴

1. **動的配列**: サイズが自動的に調整され、要素の追加や削除が簡単。
2. **高速なランダムアクセス**: 配列と同様にインデックスを使って高速にアクセス可能。
3. **順序の保持**: 挿入した順序を保持。
4. **非同期**: デフォルトではスレッドセーフではない。

## 主要メソッド

以下に`ArrayList`の主要メソッドとその使用例を示す。

:::details add() - 要素の追加

- **説明**: リストの末尾に要素を追加。
- **シグネチャ**: `boolean add(E e)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  System.out.println(list); // [apple]
  ```
  :::

:::details get() - 要素の取得

- **説明**: 指定された位置にある要素を返す。
- **シグネチャ**: `E get(int index)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  String element = list.get(1);
  System.out.println(element); // banana
  ```
  :::

:::details set() - 要素の更新

- **説明**: 指定された位置にある要素を新しい要素で置き換える。
- **シグネチャ**: `E set(int index, E element)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  list.set(1, "blueberry");
  System.out.println(list); // [apple, blueberry, cherry]
  ```
  :::

:::details remove() - 要素の削除

- **説明**: 指定された位置にある要素、または指定された要素を削除。
- **シグネチャ**: `E remove(int index)` または `boolean remove(Object o)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  list.remove(1);
  System.out.println(list); // [apple, cherry]
  list.remove("apple");
  System.out.println(list); // [cherry]
  ```
  :::

:::details size() - 要素数の取得

- **説明**: リストの要素数を返す。
- **シグネチャ**: `int size()`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  int size = list.size();
  System.out.println(size); // 3
  ```
  :::

:::details contains() - 要素の存在確認

- **説明**: リストに指定された要素が存在するか確認。
- **シグネチャ**: `boolean contains(Object o)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  boolean containsApple = list.contains("apple");
  System.out.println(containsApple); // true
  ```
  :::

:::details clear() - 全要素の削除

- **説明**: リストからすべての要素を削除。
- **シグネチャ**: `void clear()`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  list.clear();
  System.out.println(list); // []
  ```
  :::

## 解決したい技術的課題

### 動的なデータ管理

- **問題点**
  固定サイズの配列では、サイズ変更が困難であり、動的なデータ管理が難しい。新しい要素の追加や削除が頻繁に行われる場合、配列のサイズ変更や要素のシフトがパフォーマンスに悪影響を及ぼす。

- **解決策**
  `ArrayList`は内部的に配列を使用しているが、自動的にサイズを調整する機能を持つ。要素の追加や削除が簡単で、動的なデータ管理が可能。

  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  list.add("banana");
  list.remove("apple");
  System.out.println(list); // [banana]
  ```

### 高速なランダムアクセス

- **問題点**
  順序付きデータに対する頻繁なアクセスが必要な場合、リンクリストのようなデータ構造ではアクセスが遅くなる。

- **解決策**
  `ArrayList`はインデックスを使って直接要素にアクセスできるため、高速なランダムアクセスが可能。

  ```java
  ArrayList<String> list = new ArrayList<>(Arrays.asList("apple", "banana", "cherry"));
  String element = list.get(1);
  System.out.println(element); // banana
  ```

### メモリ効率の管理

- **問題点**
  配列のサイズを超える要素が追加されると、新しい配列を割り当てて既存の要素をコピーする必要がある。この再割り当てはメモリ効率が悪く、パフォーマンスが低下する。

- **解決策**
  `ArrayList`は一定の増加率で内部配列を拡張するため、メモリ効率をある程度保ちながら動的なサイズ変更を行う。適切な初期容量を設定することで、再割り当ての回数を減らすことができる。

  ```java
  ArrayList<String> list = new ArrayList<>(100); // 初期容量を100に設定
  list.add("apple");
  list.add("banana");
  ```

### スレッドセーフな操作

- **問題点**
  複数のスレッドが同時にリストにアクセスする場合、スレッドセーフな操作が必要。`ArrayList`はデフォルトでスレッドセーフではないため、データ競合が発生する可能性がある。

- **解決策**
  `Collections.synchronizedList()`を使用して、スレッドセーフなリストを作成する。これにより、複数のスレッドからの安全なアクセスが保証される。

  ```java
  List<String> synchronizedList = Collections.synchronizedList(new ArrayList<>(Arrays.asList("apple", "banana", "cherry")));
  synchronized (synchronizedList) {
      for (String s : synchronizedList) {
          System.out.println(s);
      }
  }
  ```

その通り。配列と`ArrayList`のメモリ管理にはいくつかの重要な違いがある。

## 配列と`ArrayList`のメモリ管理の違い

### 配列

- **固定サイズ**: 配列は初期化時に指定されたサイズ分のメモリを確保する。例えば、`int[] arr = new int[10];`は 10 個分の int 値用のメモリを確保する。
- **メモリ効率**: 要素数分のメモリしか確保しないため、メモリ効率が良い。しかし、サイズを変更する場合には新しい配列を作成し、要素をコピーする必要がある。

### ArrayList

- **動的サイズ**: `ArrayList`は内部的に配列を使用しており、必要に応じてサイズを変更する。要素が追加されるたびに容量が不足すると、新しい配列を作成し、既存の要素をコピーして拡張する。
- **余分のメモリ確保**: 初期容量を持ち、必要に応じて容量を自動的に増加させる。新しい要素が追加されると、現在の容量の約 1.5 倍に増加することが一般的（具体的な増加率は実装に依存する）。

### 初期容量と容量の増加

#### 初期容量

`ArrayList`を作成する際に初期容量を指定できる。指定しない場合、デフォルトの初期容量（通常 10）が使用される。

```java
ArrayList<String> list = new ArrayList<>(); // デフォルト初期容量
ArrayList<String> listWithCapacity = new ArrayList<>(20); // 初期容量20
```

#### 容量の増加

追加操作によって現在の容量が不足すると、新しい容量を持つ配列を確保し、既存の要素を新しい配列にコピーする。これにより、再度追加操作が行われるまでメモリを確保し直す必要がなくなる。

```java
ArrayList<String> list = new ArrayList<>(2);
list.add("apple");
list.add("banana");
// ここで容量が不足するため、内部配列が拡張される
list.add("cherry");
```

### メモリ管理の利点と注意点

#### 利点

1. **柔軟性**: `ArrayList`は動的にサイズを調整するため、要素の追加や削除が容易。
2. **パフォーマンス**: 余分なメモリを確保することで、頻繁なサイズ変更を避け、パフォーマンスの低下を防ぐ。

#### 注意点

1. **メモリ効率**: 配列と比べて余分なメモリを確保するため、メモリ効率がやや低い。
2. **リサイズのコスト**: 容量が不足すると新しい配列を作成し、要素をコピーするため、リサイズにはコストが伴う。

### 具体例

#### 配列の場合

```java
int[] arr = new int[10]; // 要素数分のメモリのみ確保
arr[0] = 1;
arr[1] = 2;
// 配列のサイズを変更するには、新しい配列を作成し、要素をコピーする必要がある
int[] newArr = new int[20];
System.arraycopy(arr, 0, newArr, 0, arr.length);
arr = newArr;
```

#### ArrayList の場合

```java
ArrayList<Integer> list = new ArrayList<>(); // 初期容量はデフォルト
list.add(1); // 自動的に容量が調整される
list.add(2); // 必要に応じて容量が増加
// 要素の追加や削除が簡単
list.add(3);
list.remove(1);
```

### 結論

`ArrayList`は配列と比較して柔軟性が高く、動的にサイズを調整できるため、要素の追加や削除が容易。初期容量を適切に設定することで、リサイズの頻度を減らし、メモリ効率を改善できる。配列はメモリ効率が高く、固定サイズのデータ管理に適しているが、サイズ変更が難点。システム開発では、動的なデータ管理が必要な場合は`ArrayList`を使用することで、コードの可読性と保守性が向上する。

## 変数の型を `List` と `ArrayList` のどちらにすべきか？

設計原則やそのコンテキストによるが、一般的には `List` を使用することが推奨されている。
その理由としては、

1. **柔軟性の向上**
   - `List` を使用することで、後で実装を `ArrayList` から他の `List` 実装（`LinkedList` や `Vector`）に簡単に変更可能
   - 実装の詳細を隠蔽し、より高いレベルの抽象化を提供するため、コードの柔軟性が向上する
2. **依存関係の減少**
   - コードが具体的なクラス（`ArrayList` など）ではなくインターフェースに依存することで、コンポーネント間の結合度が低くなる
   - これにより、テストや保守が容易になり、システム全体の堅牢性が向上する
3. **プログラミングのベストプラクティス**
   - インターフェースを使うことは、多くの設計パターンで推奨されるプラクティス
   - プログラムをインターフェースに対してプログラミングすることで、将来の拡張や変更に対してより柔軟に対応できるようになる

## まとめ

`ArrayList`は動的なデータ管理、高速なランダムアクセス、適切なメモリ管理、およびスレッドセーフな操作のための優れた選択肢。適切な初期容量を設定し、`Collections.synchronizedList()`を使用することで、効率的かつ安全なデータ操作が可能。システム開発において、`ArrayList`は多くの技術的課題を解決するための強力なツールとなる。
