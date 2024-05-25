---
title: "TreeMap クラス"
---

## 概要

`TreeMap`は、キーを自然順序またはカスタムコンパレータによってソートして保持する、Java のコレクションフレームワークにおけるマップの一種。内部的には赤黒木（Red-Black Tree）を使用しており、キーの順序を保証しつつ効率的なデータ操作を実現する。

## 目的

- キーの順序を保持しながらデータを管理すること
- これにより、ソートされた順序でのデータアクセスや範囲検索が容易になる

## 主な特徴

- **キーのソート**: キーは自然順序（`Comparable`が実装されている場合）またはカスタムコンパレータに基づいてソートされる。
- **効率的なデータ操作**: 検索、挿入、削除の時間計算量は O(log n)。
- **ナビゲーションメソッド**: サブマップ、ヘッドマップ、テールマップの取得など、範囲操作が可能。

## 主なメソッド

:::details put() - キーと値のペアを追加

- **説明**: 指定されたキーと値のペアをマップに追加し、キーに基づいてソートする。
- **シグネチャ**: `V put(K key, V value)`
- **使用例**:
  ```java
  TreeMap<String, Integer> map = new TreeMap<>();
  map.put("apple", 1);
  map.put("banana", 2);
  map.put("cherry", 3);
  System.out.println(map); // {apple=1, banana=2, cherry=3}
  ```
  :::

:::details get() - 値の取得

- **説明**: 指定されたキーに関連付けられた値を返す。
- **シグネチャ**: `V get(Object key)`
- **使用例**:
  ```java
  int value = map.get("banana");
  System.out.println(value); // 2
  ```
  :::

:::details remove() - キーと値のペアを削除

- **説明**: 指定されたキーに関連付けられたペアを削除する。
- **シグネチャ**: `V remove(Object key)`
- **使用例**:
  ```java
  map.remove("cherry");
  System.out.println(map); // {apple=1, banana=2}
  ```
  :::

:::details containsKey() - キーの存在確認

- **説明**: 指定されたキーがマップに存在するかどうかを確認する。
- **シグネチャ**: `boolean containsKey(Object key)`
- **使用例**:
  ```java
  boolean exists = map.containsKey("apple");
  System.out.println(exists); // true
  ```
  :::

:::details firstKey() - 最小のキーを取得

- **説明**: マップの最小のキーを返す。
- **シグネチャ**: `K firstKey()`
- **使用例**:
  ```java
  String firstKey = map.firstKey();
  System.out.println(firstKey); // apple
  ```
  :::

:::details lastKey() - 最大のキーを取得

- **説明**: マップの最大のキーを返す。
- **シグネチャ**: `K lastKey()`
- **使用例**:
  ```java
  String lastKey = map.lastKey();
  System.out.println(lastKey); // cherry
  ```
  :::

:::details subMap() - 部分マップを取得

- **説明**: 指定された範囲のキーを持つ部分マップを返す。
- **シグネチャ**: `SortedMap<K, V> subMap(K fromKey, K toKey)`
- **使用例**:
  ```java
  SortedMap<String, Integer> subMap = map.subMap("apple", "cherry");
  System.out.println(subMap); // {apple=1, banana=2}
  ```
  :::

## 解決したい技術的課題

### 1. キーのソートと順序保持

- **問題点**
  無秩序に挿入されたデータをキーに基づいてソートされた状態で保持したい。
- **解決策**
  `TreeMap`はキーを自然順序またはカスタムコンパレータによってソートして保持するため、データの挿入順に関わらず常にソートされた状態でデータを管理できる。

  ```java
  TreeMap<String, Integer> map = new TreeMap<>();
  map.put("banana", 2);
  map.put("apple", 1);
  map.put("cherry", 3);
  System.out.println(map); // {apple=1, banana=2, cherry=3}
  ```

### 2. 範囲検索の効率化

- **問題点**
  キーの範囲に基づいて部分マップを効率的に取得したい。

- **解決策**
  `TreeMap`は`subMap`、`headMap`、`tailMap`メソッドを提供し、特定のキー範囲内の部分マップを簡単に取得できる。

  ```java
  SortedMap<String, Integer> subMap = map.subMap("banana", "cherry");
  System.out.println(subMap); // {banana=2}
  ```

### 3. 自然順序またはカスタム順序の適用

- **問題点**
  データを自然順序またはカスタムコンパレータに基づいて管理したい。

- **解決策**
  `TreeMap`は`Comparable`インターフェースを実装するキーの自然順序を使用するか、カスタムコンパレータを指定することで柔軟な順序付けが可能。

  ```java
  TreeMap<String, Integer> map = new TreeMap<>(Comparator.reverseOrder());
  map.put("banana", 2);
  map.put("apple", 1);
  map.put("cherry", 3);
  System.out.println(map); // {cherry=3, banana=2, apple=1}
  ```

## まとめ

`TreeMap`は、キーの順序を保持しながらデータを管理するために非常に有用なデータ構造。効率的な範囲検索、自然順序またはカスタム順序の適用が可能であり、ナビゲーションシステム、金融アプリケーション、キャッシュシステムなど多くのユースケースで役立つ。常にソートされた状態でデータを保持することで、効率的なデータ操作とアクセスが実現できる。
