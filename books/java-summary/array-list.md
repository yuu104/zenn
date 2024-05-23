---
title: "ArrayList"
---

## ArrayList とは

- Java SE の `java.util` に含まれるクラス
- 動的にサイズが変更可能な配列を提供する

## 定義方法

```java
ArrayList<型> 変数名 = new ArrayList<型>();
```

## 主要なメソッド

:::details add()

- **説明**: 指定された要素をリストの末尾に追加する。
- **シグネチャ**: `public boolean add(E e)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  list.add("banana");
  // リストは ["apple", "banana"]
  ```

:::

:::details add(int index, E element)

- **説明**: 指定された位置に要素を挿入する。既存の要素は右にシフトされる。
- **シグネチャ**: `public void add(int index, E element)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  list.add(1, "banana");
  // リストは ["apple", "banana"]
  ```

:::

:::details get()

- **説明**: 指定された位置にある要素を返す。
- **シグネチャ**: `public E get(int index)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  String element = list.get(0);
  // elementは "apple"
  ```

:::

:::details set()

- **説明**: 指定された位置の要素を指定された要素に置き換える。
- **シグネチャ**: `public E set(int index, E element)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  list.set(0, "banana");
  // リストは ["banana"]
  ```

:::

:::details remove(int index)

- **説明**: 指定された位置にある要素を削除し、その要素を返す。
- **シグネチャ**: `public E remove(int index)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  String removed = list.remove(0);
  // removedは "apple"
  // リストは []
  ```

:::

:::details size()

- **説明**: リストの要素数を返す。
- **シグネチャ**: `public int size()`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
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
  ArrayList<String> list = new ArrayList<>();
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
  ArrayList<String> list = new ArrayList<>();
  boolean empty = list.isEmpty();
  // emptyは true
  ```

:::

:::details contains()

- **説明**: リストが指定された要素を含んでいるかどうかを判定する。
- **シグネチャ**: `public boolean contains(Object o)`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  boolean contains = list.contains("apple");
  // containsは true
  ```

:::

:::details toArray()

- **説明**: リスト内のすべての要素を含む配列を返す。
- **シグネチャ**: `public Object[] toArray()`
- **使用例**:
  ```java
  ArrayList<String> list = new ArrayList<>();
  list.add("apple");
  list.add("banana");
  Object[] array = list.toArray();
  // arrayは ["apple", "banana"]
  ```

:::

## `ArrayList` は参照型しか扱えない

- 配列とは違い、`int` や `double`、`char` などのプリミティブ型を扱えない
- プリミティブ型を扱いたい場合、**対応するラッパークラス**を型として指定する

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

## `ArrayList` は `List` インターフェースを実装している

`ArrayList` 型定義時に、変数の型を `ArrayList` ではなく `List` にできる。

```java
List<型> 変数名 = new ArrayList<型>();
```

### 変数の型を `List` と `ArrayList` のどちらにすべきか？

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

## 使用例

```java
import java.util.ArrayList;;

public class ArrayListSample {
  public static void main(String[] args) {
    ArrayList<String> list = new ArrayList<String>();

    // 要素の追加
    list.add("Apple");
    list.add("Banana");
    list.add("Cherry");

    // 要素の取得
    String item = list.get(1);  // "Banana"

    // 要素数の取得
    int size = list.size();  // 2

    // 全要素の表示
    for (String fruit : list) {
        System.out.println(fruit);
    }
  }
}
```
