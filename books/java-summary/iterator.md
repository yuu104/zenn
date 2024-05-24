---
title: "Iteratorインターフェース"
---

## 概要

`Iterator`は、コレクション内の要素を順番に処理するためのインタフェースです。Java のコレクションフレームワークに属し、`java.util`パッケージに含まれています。主な目的は、コレクションの要素に対して一貫性のある方法でアクセスし、処理を行うことです。

## 目的

`Iterator`の主な目的は、コレクションの要素を順番にアクセスし、操作するための標準的な方法を提供することです。これにより、異なる種類のコレクションに対しても一貫した方法で要素を操作できます。

## 解決したい技術的課題

### コレクションの抽象化

- **問題点**: コレクションの内部構造に依存しない要素の巡回が必要。具体的な実装に依存することなく、統一的な方法でコレクションを操作したい。
- **解決策**: `Iterator`は、コレクションの内部構造を隠蔽し、要素の巡回を標準化する。これにより、異なる種類のコレクションに対しても同じ方法で要素を処理できる。

### 安全な要素の削除

- **問題点**: コレクションを巡回しながら要素を削除すると、並行変更例外（ConcurrentModificationException）が発生する可能性がある。
- **解決策**: `Iterator`は、巡回中に安全に要素を削除するための`remove`メソッドを提供する。この方法を使うと、コレクションの一貫性を保ちながら要素を削除できる。

## 主要メソッド

:::details hasNext() - 次の要素の存在確認

- **説明**: コレクションに次の要素が存在するかどうかを判定する。
- **シグネチャ**: `public boolean hasNext()`
- **使用例**:
  ```java
  Iterator<String> iterator = list.iterator();
  while (iterator.hasNext()) {
      String element = iterator.next();
      System.out.println(element);
  }
  ```

:::

:::details next() - 次の要素の取得

- **説明**: コレクションの次の要素を返す。
- **シグネチャ**: `public E next()`
- **使用例**:
  ```java
  Iterator<String> iterator = list.iterator();
  while (iterator.hasNext()) {
      String element = iterator.next();
      System.out.println(element);
  }
  ```

:::

:::details remove() - 要素の削除

- **説明**: `next`メソッドで最後に返された要素をコレクションから削除する。
- **シグネチャ**: `public void remove()`
- **使用例**:
  ```java
  Iterator<String> iterator = list.iterator();
  while (iterator.hasNext()) {
      String element = iterator.next();
      if (element.equals("banana")) {
          iterator.remove();
      }
  }
  ```

:::

:::details forEachRemaining() - 残りの要素に対する処理

- **説明**: 残りの要素すべてに対して指定されたアクションを実行する。
- **シグネチャ**: `default void forEachRemaining(Consumer<? super E> action)`
- **使用例**:
  ```java
  Iterator<String> iterator = list.iterator();
  iterator.forEachRemaining(element -> System.out.println(element));
  ```

:::

:::details listIterator() - 双方向イテレーターの取得

- **説明**: リスト内の要素を双方向に反復処理するリストイテレーターを取得する。
- **シグネチャ**: `ListIterator<E> listIterator()`
- **使用例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("apple");
  list.add("banana");
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      System.out.println(iterator.next());
  }
  while (iterator.hasPrevious()) {
      System.out.println(iterator.previous());
  }
  ```

:::

:::details listIterator(int index) - 指定位置からの双方向イテレーターの取得

- **説明**: リスト内の要素を指定された位置から双方向に反復処理するリストイテレーターを取得する。
- **シグネチャ**: `ListIterator<E> listIterator(int index)`
- **使用例**:
  ```java
  List<String> list = new ArrayList<>();
  list.add("apple");
  list.add("banana");
  ListIterator<String> iterator = list.listIterator(1);
  while (iterator.hasNext()) {
      System.out.println(iterator.next());
  }
  ```

:::

:::details hasPrevious() - 前の要素の存在確認

- **説明**: リストに前の要素が存在するかどうかを判定する。
- **シグネチャ**: `public boolean hasPrevious()`
- **使用例**:
  ```java
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      iterator.next();
  }
  while (iterator.hasPrevious()) {
      System.out.println(iterator.previous());
  }
  ```

:::

:::details previous() - 前の要素の取得

- **説明**: リストの前の要素を返す。
- **シグネチャ**: `public E previous()`
- **使用例**:
  ```java
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      iterator.next();
  }
  while (iterator.hasPrevious()) {
      System.out.println(iterator.previous());
  }
  ```

:::

:::details nextIndex() - 次の要素のインデックス取得

- **説明**: 次の要素のインデックスを返す。
- **シグネチャ**: `public int nextIndex()`
- **使用例**:
  ```java
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      int index = iterator.nextIndex();
      String element = iterator.next();
      System.out.println("Index: " + index + ", Element: " + element);
  }
  ```

:::

:::details previousIndex() - 前の要素のインデックス取得

- **説明**: 前の要素のインデックスを返す。
- **シグネチャ**: `public int previousIndex()`
- **使用例**:
  ```java
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      iterator.next();
  }
  while (iterator.hasPrevious()) {
      int index = iterator.previousIndex();
      String element = iterator.previous();
      System.out.println("Index: " + index + ", Element: " + element);
  }
  ```

:::

:::details set() - 要素の置換

- **説明**: `next`または`previous`で最後に返された要素を置換する。
- **シグネチャ**: `public void set(E e)`
- **使用例**:
  ```java
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      String element = iterator.next();
      if (element.equals("banana")) {
          iterator.set("blueberry");
      }
  }
  System.out.println(list); // ["apple", "blueberry"]
  ```

:::

:::details add() - 要素の挿入

- **説明**: 指定された要素をリストに挿入する。
- **シグネチャ**: `public void add(E e)`
- **使用例**:
  ```java
  ListIterator<String> iterator = list.listIterator();
  while (iterator.hasNext()) {
      String element = iterator.next();
      if (element.equals("banana")) {
          iterator.add("blackberry");
      }
  }
  System.out.println(list); // ["apple", "banana", "blackberry", "cherry"]
  ```

:::

### まとめ

- **Iterator**は、コレクション内の要素を順番に処理するためのインタフェースで、主に`hasNext()`、`next()`, `remove()`、`forEachRemaining()`などのメソッドを提供する。
- **ListIterator**は、`Iterator`の拡張版で、双方向の要素の反復処理や、要素の挿入、置換などの操作が可能。
- コレクションを安全かつ一貫性のある方法で巡回・操作するための標準的な手段として、これらのインタフェースとメソッドを適切に使用することで、効率的なコレクション操作が実現できる。

## 具体例

:::details 基本的な使用例

```java
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        Iterator<String> iterator = list.iterator();
        while (iterator.hasNext()) {
            String element = iterator.next();
            System.out.println(element);
        }
    }
}
```

:::details 要素の削除

```java
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("apple");
        list.add("banana");
        list.add("cherry");

        Iterator<String> iterator = list.iterator();
        while (iterator.hasNext()) {
            String element = iterator.next();
            if (element.equals("banana")) {
                iterator.remove();
            }
        }

        // リストの内容を表示
        for (String fruit : list) {
            System.out.println(fruit);
        }
    }
}
```

:::

## 利点と注意点

### 利点

- **一貫性のあるインタフェース**: `Iterator`は、異なる種類のコレクションに対しても一貫した方法で要素を操作できる。
- **安全な削除**: 巡回中に要素を安全に削除するための`remove`メソッドを提供する。
- **柔軟性**: コレクションの内部構造に依存しない操作が可能。

### 注意点

- **一方向の巡回**: `Iterator`は、コレクションを一方向にしか巡回できない。双方向に巡回する必要がある場合は、`ListIterator`を使用する。
- **一度しか使えない**: 一度使用した`Iterator`は再利用できない。新たにコレクションの`iterator`メソッドを呼び出して新しい`Iterator`を取得する必要がある。

### まとめ

`Iterator`は、コレクションの要素を効率的に巡回し、安全に操作するための標準的なインタフェースです。コレクションの内部構造に依存しない要素のアクセスを提供し、巡回中の要素削除を安全に行うことができます。`Iterator`を適切に使用することで、コレクション操作の一貫性と安全性を確保できます。
