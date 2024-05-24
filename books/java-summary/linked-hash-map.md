---
title: "LinkedHashMap"
---

## 概要

`LinkedHashMap`は、`HashMap`と`LinkedList`の特性を組み合わせたデータ構造であり、キーと値のペアを格納するマップ。挿入順序を保持しつつ、ハッシュテーブルを用いた高速な操作を提供する。

## 目的

- データの挿入順序またはアクセス順序を保持しながら、キーと値のペアを効率的に管理すること
- これにより、順序が重要な場合でも効率的なデータ操作が可能となる

## 主な特徴

1. **挿入順序の保持**: 要素がマップに挿入された順序を保持する。
2. **アクセス順序の保持**: アクセス順序に基づいて要素を再配置できる（オプション）。
3. **ハッシュテーブルとリンクリストの併用**: ハッシュテーブルを用いた高速な検索、挿入、削除とリンクリストによる順序保持。
4. **高いメモリ効率**: ハッシュテーブルとリンクリストを併用することで、メモリ使用量を抑えつつ順序を保持。

## 主なメソッド

:::details put() - キーと値のペアを追加

- **説明**: 指定されたキーと値のペアをマップに追加する。
- **シグネチャ**: `V put(K key, V value)`
- **使用例**:
  ```java
  Map<String, Integer> map = new LinkedHashMap<>();
  map.put("apple", 1);
  map.put("banana", 2);
  System.out.println(map); // {apple=1, banana=2}
  ```
  :::

:::details get() - 値の取得

- **説明**: 指定されたキーに関連付けられた値を返す。
- **シグネチャ**: `V get(Object key)`
- **使用例**:
  ```java
  int value = map.get("apple");
  System.out.println(value); // 1
  ```
  :::

:::details remove() - キーと値のペアを削除

- **説明**: 指定されたキーに関連付けられたペアを削除する。
- **シグネチャ**: `V remove(Object key)`
- **使用例**:
  ```java
  map.remove("banana");
  System.out.println(map); // {apple=1}
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

:::details keySet() - キーのセットを取得

- **説明**: マップに含まれるすべてのキーのセットを返す。
- **シグネチャ**: `Set<K> keySet()`
- **使用例**:
  ```java
  Set<String> keys = map.keySet();
  System.out.println(keys); // [apple]
  ```
  :::

:::details values() - 値のコレクションを取得

- **説明**: マップに含まれるすべての値のコレクションを返す。
- **シグネチャ**: `Collection<V> values()`
- **使用例**:
  ```java
  Collection<Integer> values = map.values();
  System.out.println(values); // [1]
  ```
  :::

:::details entrySet() - エントリーのセットを取得

- **説明**: マップに含まれるすべてのキーと値のペア（エントリー）のセットを返す。
- **シグネチャ**: `Set<Map.Entry<K, V>> entrySet()`
- **使用例**:
  ```java
  Set<Map.Entry<String, Integer>> entries = map.entrySet();
  for (Map.Entry<String, Integer> entry : entries) {
      System.out.println(entry.getKey() + "=" + entry.getValue());
  }
  // 出力: apple=1
  ```
  :::

## 解決したい技術的課題

### データの順序保持

- **問題点**
  データの挿入順序やアクセス順序を保持する必要がある場合、通常の`HashMap`では順序が保証されない。

- **解決策**
  `LinkedHashMap`を使用することで、データの挿入順序を保持し、必要に応じてアクセス順序も保持できる。

  ```java
  Map<String, Integer> map = new LinkedHashMap<>();
  map.put("cherry", 3);
  map.put("apple", 1);
  map.put("banana", 2);
  System.out.println(map); // {cherry=3, apple=1, banana=2}
  ```

### 順序とパフォーマンスのバランス

- **問題点**
  順序を保持しつつ、高速なデータ操作を実現する必要がある場合、通常のリストやツリー構造ではパフォーマンスが低下することがある。

- **解決策**
  `LinkedHashMap`は、ハッシュテーブルとリンクリストを組み合わせることで、順序保持と高速なデータ操作を両立する。

  ```java
  Map<String, Integer> map = new LinkedHashMap<>();
  map.put("apple", 1);
  map.put("banana", 2);
  map.put("cherry", 3);
  int value = map.get("banana"); // 高速な検索と順序保持
  System.out.println(value); // 2
  ```

### キャッシュの実装

- **問題点**
  順序付きのキャッシュを実装する際、最近使用された順序で要素を再配置する必要がある。

- **解決策**
  `LinkedHashMap`のアクセス順序モードを利用して、最近使用された要素をリストの末尾に移動させることで、LRU（Least Recently Used）キャッシュの実装が可能。

  ```java
  LinkedHashMap<String, Integer> lruCache = new LinkedHashMap<>(16, 0.75f, true);
  lruCache.put("apple", 1);
  lruCache.put("banana", 2);
  lruCache.put("cherry", 3);
  lruCache.get("apple"); // 'apple'が最後にアクセスされた要素になる
  System.out.println(lruCache); // {banana=2, cherry=3, apple=1}
  ```

### スレッドセーフな操作

- **問題点**
  複数のスレッドから同時にアクセスされる場合、スレッドセーフな操作が必要。

- **解決策**
  `Collections.synchronizedMap()`を使用して、スレッドセーフな`LinkedHashMap`を提供。また、必要に応じて`ConcurrentHashMap`などの代替も検討可能。

  ```java
  Map<String, Integer> syncMap = Collections.synchronizedMap(new LinkedHashMap<>());
  syncMap.put("apple", 1);
  syncMap.put("banana", 2);
  ```

## まとめ

`LinkedHashMap`は、データの挿入順序やアクセス順序を保持しつつ、高速な検索、挿入、削除を実現するデータ構造。キャッシュの実装や順序付きデータの管理に適しており、スレッドセーフな操作が必要な場合には、`Collections.synchronizedMap()`と組み合わせて使用可能。適切な実装を選択することで、効率的かつ柔軟なデータ管理が可能となる。
