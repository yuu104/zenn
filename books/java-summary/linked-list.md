---
title: "LinkedList"
---

## 概要

- Java のコレクションフレームワークに属するデータ構造
- 双方向リンクリスト（Doubly Linked List）として実装されている
- 各要素はノードと呼ばれ、次および前のノードへの参照を持つ
- これにより、要素の挿入や削除が効率的に行える

## 目的

- **要素の挿入や削除を効率的に行うこと**
- 特に、リストの中央部での操作が頻繁に行われる場合や、要素の順序を変更する必要がある場合に有用
- `ArrayList`がランダムアクセスを高速に行えるのに対して、`LinkedList`は要素の追加・削除操作を高速に行える

## 解決したい技術的課題

### 動的なデータの挿入・削除

- **問題点**
  `ArrayList` は内部で配列を使用しており、配列のサイズを超える要素が追加されると、新しい配列を割り当てて既存の要素をコピーする必要がある。この再割り当てはメモリ効率が悪く、パフォーマンスが低下する。また、`ArrayList` の要素はメモリ上に連続して配置されているため、リストの中央に要素を追加する際には、追加位置以降のすべての要素をシフトする必要があり、これも効率が悪い。
- **解決策**
  `LinkedList` では、各要素が独立したノードとして存在し、前後のノードへの参照を持っている。これにより、任意の位置への挿入や削除が効率的に行える。ノードの参照を更新するだけで済むため、他の要素をシフトする必要がない。

### メモリ効率

- **問題点**
  `ArrayList` では、要素の順序を変更する操作が非効率になることがある。要素を移動させるたびに他の要素をシフトする必要があり、特にリストの中央での操作はパフォーマンスが低下する。
- **解決策**
  `LinkedList` は必要なときにのみメモリを割り当てるため、メモリ使用の効率が良い。各ノードは前後のノードへの参照を持つため、必要に応じてメモリを動的に管理できる。頻繁な追加・削除操作においては効果的。

### 順序の柔軟な変更

- **問題点**
  順序の変更が頻繁に行われるデータでは、配列ベースのデータ構造では非効率になることがある。要素の移動に伴うシフト操作が必要となり、パフォーマンスが低下する。
- **解決策**
  `LinkedList` は要素の順序を変更する操作が効率的に行える。特定の要素の前後に簡単に新しい要素を挿入したり、削除したりすることができ、他の要素をシフトする必要がないため、順序変更が頻繁なデータに適している。

## LinkedList の主なメソッド

:::details add()

- **説明**: 指定された要素をリストの末尾に追加する。
- **シグネチャ**: `public boolean add(E e)`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.add("banana");
  // リストは ["apple", "banana"]
  ```

:::

:::details addFirst()

- **説明**: 指定された要素をリストの先頭に追加する。
- **シグネチャ**: `public void addFirst(E e)`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("banana");
  list.addFirst("apple");
  // リストは ["apple", "banana"]
  ```

:::

:::details addLast()

- **説明**: 指定された要素をリストの末尾に追加する。`add()`と同じ。
- **シグネチャ**: `public void addLast(E e)`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.addLast("banana");
  // リストは ["apple", "banana"]
  ```

:::

:::details get()

- **説明**: 指定された位置にある要素を返す。
- **シグネチャ**: `public E get(int index)`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  String element = list.get(0);
  // elementは "apple"
  ```

:::

:::details getFirst()

- **説明**: リストの最初の要素を返す。
- **シグネチャ**: `public E getFirst()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.add("banana");
  String first = list.getFirst();
  // firstは "apple"
  ```

:::

:::details getLast()

- **説明**: リストの最後の要素を返す。
- **シグネチャ**: `public E getLast()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.add("banana");
  String last = list.getLast();
  // lastは "banana"
  ```

:::

:::details remove()

- **説明**: 指定された位置にある要素を削除し、その要素を返す。
- **シグネチャ**: `public E remove(int index)`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  String removed = list.remove(0);
  // removedは "apple"
  // リストは []
  ```

:::

:::details removeFirst()

- **説明**: リストの最初の要素を削除し、その要素を返す。
- **シグネチャ**: `public E removeFirst()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.add("banana");
  String removed = list.removeFirst();
  // removedは "apple"
  // リストは ["banana"]
  ```

:::

:::details removeLast()

- **説明**: リストの最後の要素を削除し、その要素を返す。
- **シグネチャ**: `public E removeLast()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.add("banana");
  String removed = list.removeLast();
  // removedは "banana"
  // リストは ["apple"]
  ```

:::

:::details size()

- **説明**: リストの要素数を返す。
- **シグネチャ**: `public int size()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  int size = list.size();
  // sizeは 1
  ```

:::

:::details clear()

- **説明**: リストからすべての要素を削除する。
- **シグネチャ**: `public void clear()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  list.clear();
  // リストは []
  ```

:::

:::details isEmpty()

- **説明**: リストが空であるかどうかを判定する。
- **シグネチャ**: `public boolean isEmpty()`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  boolean empty = list.isEmpty();
  // emptyは true
  ```

:::

:::details contains()

- **説明**: リストが指定された要素を含んでいるかどうかを判定する。
- **シグネチャ**: `public boolean contains(Object o)`
- **使用例**:
  ```java
  LinkedList<String> list = new LinkedList<>();
  list.add("apple");
  boolean contains = list.contains("apple");
  // containsは true
  ```

:::

## 具体例

### 基本的な使用例

```java
import java.util.LinkedList;

public class Main {
    public static void main(String[] args) {
        LinkedList<String> list = new LinkedList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        // 先頭に要素を追加
        list.addFirst("date");

        // 末尾に要素を追加
        list.addLast("elderberry");

        // 要素の取得
        System.out.println("First element: " + list.getFirst()); // 出力: date
        System.out.println("Last element: " + list.getLast());   // 出力: elderberry

        // 要素の削除
        list.removeFirst();
        list.removeLast();

        // リストの表示
        for (String fruit : list) {
            System.out.println(fruit);
        }
    }
}
```

## `LinkedList` と `ArrayList` の比較・使い分け

- `ArrayList`と`LinkedList`は、基本的な役割や機能は同じ
- しかし、内部構造の違いにより得意な操作が異なる
- 要件に応じてこれらを使い分けることで、プログラムの効率とパフォーマンスを最適化できる

### `ArrayList`

#### 特徴

- **内部構造**: 可変長の配列を使用。
- **メモリ配置**: 要素は連続したメモリ領域に配置される。
- **アクセス速度**: インデックスを使ったランダムアクセスが高速（O(1)）。

#### 長所

- ランダムアクセスが高速。
- 要素の追加や削除が配列の末尾で行われる場合は高速。

#### 短所

- 要素の挿入や削除がリストの中央で行われる場合、要素のシフトが必要であり、これが効率を低下させる（O(n)）。
- 容量を超えると配列の再割り当てが発生し、メモリと CPU のオーバーヘッドが発生。

#### ユースケース

- 順序が重要で、ランダムアクセスが頻繁に行われる場合。
- 末尾への追加が主な操作である場合。

```java
ArrayList<String> list = new ArrayList<>();
list.add("apple");
list.add("banana");
String element = list.get(1); // ランダムアクセスが高速
```

### `LinkedList`

#### 特徴

- **内部構造**:
  双方向リンクリストを使用。
- **メモリ配置**:
  要素は連続したメモリ領域に配置されず、ノードごとにメモリが割り当てられる。
- **挿入・削除の効率**:
  リストの先頭や末尾での要素の挿入や削除が効率的（O(1)）。中間位置での挿入や削除もインデックスの位置を特定する時間（O(n)）を除けば効率的。
- **アクセス速度**:
  インデックスを使ったランダムアクセスが遅い（O(n)）。`LinkedList` は指定されたインデックスまでリストを順に辿る必要があるため、時間計算量が O(n)となる。

#### 長所

- 要素の挿入や削除が効率的（特にリストの中央で行われる場合は O(1)）。
- メモリの再割り当てが不要で、メモリ使用効率が良い。

#### 短所

- ランダムアクセスが遅い。
- 各ノードが前後の参照を持つため、メモリオーバーヘッドがある。

#### ユースケース

- 要素の挿入や削除が頻繁に行われる場合。
- データの順序変更が頻繁に必要な場合。

```java
LinkedList<String> list = new LinkedList<>();
list.add("apple");
list.add("banana");
list.add(1, "cherry"); // 中央への挿入が高速
String firstElement = list.getFirst(); // 先頭へのアクセスが容易
```

### 使い分けのポイント

- **ランダムアクセスが頻繁**: `ArrayList`を使用。
- **要素の挿入や削除が頻繁**: `LinkedList`を使用。
- **メモリ効率**: メモリの再割り当てが頻繁に発生する場合は`LinkedList`を検討。
- **順序変更が頻繁**: 要素の順序を頻繁に変更する必要がある場合は`LinkedList`が有利。

以下に、`ArrayList`と`LinkedList`の使い分けの具体例を示します。それぞれのケースで、どちらのリストが適しているかを説明します。

### 具体例 1: 順序付きリストの頻繁なランダムアクセス

- **要件**
  順序付きのデータを大量に扱い、頻繁に特定のインデックスにアクセスする必要がある。

- **適用**
  `ArrayList`

- **理由**
  `ArrayList`は内部で可変長の配列を使用しており、インデックスを使ったランダムアクセスが高速（O(1)）で行えるため、頻繁なランダムアクセスに適している。

```java
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        // 頻繁に特定のインデックスにアクセス
        String fruit = list.get(1); // "banana"
        System.out.println(fruit);
    }
}
```

### 具体例 2: 頻繁な挿入と削除が必要なリスト

- **要件**
  データの挿入と削除がリストの中央で頻繁に行われる。

- **適用**
  `LinkedList`

- **理由**

  `LinkedList`は双方向リンクリストとして実装されており、要素の挿入や削除が効率的（O(1)）に行えるため、リストの中央での操作が頻繁に必要な場合に適している。

```java
import java.util.LinkedList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = new LinkedList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        // 頻繁にリストの中央に要素を挿入
        list.add(1, "date"); // "apple"と"banana"の間に"date"を挿入
        System.out.println(list); // [apple, date, banana, cherry]

        // 頻繁にリストの中央から要素を削除
        list.remove(2); // "banana"を削除
        System.out.println(list); // [apple, date, cherry]
    }
}
```

### 具体例 3: スタックまたはキューの実装

- **要件**
  スタック（LIFO: Last In First Out）またはキュー（FIFO: First In First Out）としてリストを使用する。

- **適用**
  `LinkedList`

- **理由**

  `LinkedList`は`Deque`インタフェースを実装しており、スタックおよびキューの操作を効率的に行うためのメソッド（`addFirst`, `addLast`, `removeFirst`, `removeLast`など）を提供するため、スタックやキューとしての使用に適している。

```java
import java.util.LinkedList;
import java.util.Deque;

public class Main {
    public static void main(String[] args) {
        Deque<String> stack = new LinkedList<>();

        // スタックに要素をプッシュ
        stack.push("apple");
        stack.push("banana");
        stack.push("cherry");

        // スタックから要素をポップ
        String top = stack.pop(); // "cherry"
        System.out.println(top);
    }
}
```

#### 例: キューの実装

```java
import java.util.LinkedList;
import java.util.Queue;

public class Main {
    public static void main(String[] args) {
        Queue<String> queue = new LinkedList<>();

        // キューに要素をエンキュー
        queue.add("apple");
        queue.add("banana");
        queue.add("cherry");

        // キューから要素をデキュー
        String front = queue.poll(); // "apple"
        System.out.println(front);
    }
}
```

### 具体例 4: 順序を維持しつつ、頻繁に並び替えるリスト

- **要件**
  データの順序を維持しながら、頻繁に並び替えを行う。

- **適用**
  `LinkedList`

- **理由**

  順序の変更が頻繁に行われる場合、`LinkedList`はノードの参照を更新するだけで済むため、効率的に順序を変更できる。

```java
import java.util.LinkedList;
import java.util.Collections;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = new LinkedList<>();
        list.add("banana");
        list.add("apple");
        list.add("cherry");

        // 頻繁にリストを並び替える
        Collections.sort(list);
        System.out.println(list); // [apple, banana, cherry]

        Collections.reverse(list);
        System.out.println(list); // [cherry, banana, apple]
    }
}
```
