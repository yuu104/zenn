---
title: "Arraysクラス"
---

## 概要

`Arrays`クラスは、Java の標準ライブラリである`java.util`パッケージに含まれ、配列に対する操作を簡潔に行うためのユーティリティメソッドを提供します。このクラスはインスタンス化できないため、すべてのメソッドは静的メソッドです。

## 目的

- **配列操作の簡素化**:
  配列のソート、検索、コピー、変換など、さまざまな操作を簡素化するためのメソッドを提供します。
- **効率的なデータ操作**:
  高速な配列操作を実現し、データ処理を効率化します。
- **可読性の向上**:
  複雑な配列操作をシンプルなメソッド呼び出しで実現し、コードの可読性を向上させます。

## 解決したい技術的課題

- **手動での配列操作の冗長性**:
  手動で配列の操作を行うとコードが冗長になりがちです。`Arrays`クラスのメソッドを使うことで、簡潔で直感的なコードを記述できます。
- **パフォーマンスの最適化**:
  `Arrays`クラスのメソッドは、内部的に最適化されたアルゴリズムを使用しており、手動実装よりも効率的な場合が多いです。
- **バグの回避**:
  自前の実装によるバグを避け、標準ライブラリの信頼性の高いメソッドを利用することで、コードの安定性を向上させます。

## 主要メソッド一覧

### 配列のソート

:::details sort(int[] a) ~ 配列のソート

- **説明**:
  - 配列を昇順にソートします。
- **シグネチャ**:
  ```java
  static void sort(int[] a)
  ```
- **例**:
  ```java
  int[] array = {3, 1, 4, 1, 5, 9};
  Arrays.sort(array);
  // array は [1, 1, 3, 4, 5, 9] になる
  ```
  :::

:::details sort(T[] a) ~ 配列のソート (汎用型)

- **説明**:
  - 配列を昇順にソートします。要素は`Comparable`インターフェースを実装している必要があります。
- **シグネチャ**:
  ```java
  static <T extends Comparable<? super T>> void sort(T[] a)
  ```
- **例**:
  ```java
  String[] array = {"banana", "apple", "cherry"};
  Arrays.sort(array);
  // array は ["apple", "banana", "cherry"] になる
  ```
  :::

### 配列の検索

:::details binarySearch(int[] a, int key) ~ バイナリ検索

- **説明**:
  - ソートされた配列内で指定された値をバイナリ検索します。
- **シグネチャ**:
  ```java
  static int binarySearch(int[] a, int key)
  ```
- **例**:
  ```java
  int[] array = {1, 2, 3, 4, 5};
  int index = Arrays.binarySearch(array, 3);
  // index は 2 になる
  ```
  :::

:::details binarySearch(T[] a, T key) ~ バイナリ検索 (汎用型)

- **説明**:
  - ソートされた配列内で指定された値をバイナリ検索します。要素は`Comparable`インターフェースを実装している必要があります。
- **シグネチャ**:
  ```java
  static <T> int binarySearch(T[] a, T key)
  ```
- **例**:
  ```java
  String[] array = {"apple", "banana", "cherry"};
  int index = Arrays.binarySearch(array, "banana");
  // index は 1 になる
  ```
  :::

### 配列のコピー

:::details copyOf(int[] original, int newLength) ~ 配列のコピー

- **説明**:
  - 配列を指定された長さにコピーします。新しい配列の長さが元の配列より長い場合、追加要素はデフォルト値で埋められます。
- **シグネチャ**:
  ```java
  static int[] copyOf(int[] original, int newLength)
  ```
- **例**:
  ```java
  int[] original = {1, 2, 3};
  int[] copy = Arrays.copyOf(original, 5);
  // copy は [1, 2, 3, 0, 0] になる
  ```
  :::

:::details copyOfRange(int[] original, int from, int to) ~ 配列の範囲コピー

- **説明**:
  - 指定された範囲の配列をコピーします。範囲は`from`（含む）から`to`（含まない）までです。
- **シグネチャ**:
  ```java
  static int[] copyOfRange(int[] original, int from, int to)
  ```
- **例**:
  ```java
  int[] original = {1, 2, 3, 4, 5};
  int[] copy = Arrays.copyOfRange(original, 1, 4);
  // copy は [2, 3, 4] になる
  ```
  :::

### 配列の比較

:::details equals(int[] a, int[] a2) ~ 配列の等価性比較

- **説明**:
  - 2 つの配列が等しいかどうかを比較します。要素が同じ順序で同じである場合に`true`を返します。
- **シグネチャ**:
  ```java
  static boolean equals(int[] a, int[] a2)
  ```
- **例**:
  ```java
  int[] array1 = {1, 2, 3};
  int[] array2 = {1, 2, 3};
  boolean isEqual = Arrays.equals(array1, array2);
  // isEqual は true になる
  ```
  :::

### 配列の変換

:::details asList(T... a) ~ 配列をリストに変換

- **説明**:
  - 配列をリストに変換します。このリストは固定サイズであり、変更できません。
- **シグネチャ**:
  ```java
  static <T> List<T> asList(T... a)
  ```
- **例**:
  ```java
  String[] array = {"one", "two", "three"};
  List<String> list = Arrays.asList(array);
  // list は ["one", "two", "three"] になる
  ```
  :::

### 配列のフィル操作

:::details fill(int[] a, int val) ~ 配列を指定された値で埋める

- **説明**:
  - 配列のすべての要素を指定された値で埋めます。
- **シグネチャ**:
  ```java
  static void fill(int[] a, int val)
  ```
- **例**:
  ```java
  int[] array = new int[5];
  Arrays.fill(array, 9);
  // array は [9, 9, 9, 9, 9] になる
  ```
  :::

### 配列の文字列表現

:::details toString(int[] a) ~ 配列の文字列表現

- **説明**:
  - 配列の内容を表す文字列表現を返します。
- **シグネチャ**:
  ```java
  static String toString(int[] a)
  ```
- **例**:
  ```java
  int[] array = {1, 2, 3};
  String arrayString = Arrays.toString(array);
  // arrayString は "[1, 2, 3]" になる
  ```
  :::

## まとめ

`Arrays`クラスは、配列に対する操作を簡素化し、効率的に行うための多くのユーティリティメソッドを提供します。配列のソート、検索、コピー、変換、比較など、日常的に行われる操作を簡潔に記述できるため、コードの可読性と保守性が向上します。これらのメソッドを理解し適切に使用することで、配列操作に関する多くの技術的課題を解決できます。
