---
title: "LinkedHashMap クラス"
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

::: details LRU キャッシュについて

`LinkedHashMap`は、挿入順序またはアクセス順序を保持するためにリンクリストの特性を持つハッシュマップであり、これを利用することで、LRU（Least Recently Used）キャッシュを簡単に実装できる。

### LRU キャッシュの 目的

- メモリ効率を高め、頻繁にアクセスされるデータの取得速度を向上させること
- 古くなったデータを自動的に削除することで、メモリの無駄遣いを防ぎ、システム全体のパフォーマンスを向上させる

### 解決したい技術的課題

1. **メモリ効率の改善**:

   - 大量のデータをメモリに保持すると、メモリ不足が発生する可能性がある
   - 古くて使用されていないデータを自動的に削除することで、メモリの使用効率を向上させる

2. **データアクセスの高速化**:

   - 頻繁にアクセスされるデータをキャッシュに保持することで、データベースや他の永続化ストレージへのアクセス回数を減らし、アクセス速度を向上させる

3. **簡単なキャッシュ管理**:
   - キャッシュの管理をシンプルにし、コード量を減らすことで、メンテナンスを容易にする

### 実装方法

1. **基本的な設定**
   `LinkedHashMap`のコンストラクタでアクセス順序モードを有効にし、キャッシュサイズを制限する。

2. **`removeEldestEntry` メソッドのオーバーライド**
   キャッシュサイズが指定された最大サイズを超えた場合に、最も古いエントリーを削除するために`removeEldestEntry`メソッドをオーバーライドする。

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache<K, V> extends LinkedHashMap<K, V> {
    private final int maxSize;

    public LRUCache(int maxSize) {
        super(maxSize, 0.75f, true); // 初期容量、負荷係数、アクセス順序モードを設定
        this.maxSize = maxSize;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return super.size() > maxSize; // キャッシュサイズが最大サイズを超えたら最も古いエントリーを削除
    }

    public static void main(String[] args) {
        LRUCache<String, String> cache = new LRUCache<>(3);

        cache.put("A", "Apple");
        cache.put("B", "Banana");
        cache.put("C", "Cherry");
        System.out.println(cache); // {A=Apple, B=Banana, C=Cherry}

        cache.get("A"); // 'A'がアクセスされ、最も最近使用されたものになる
        cache.put("D", "Date"); // キャッシュが満杯なので、最も古いエントリー（B=Banana）が削除される
        System.out.println(cache); // {C=Cherry, A=Apple, D=Date}
    }
}
```

### ユースケース

1. **データベースクエリの結果キャッシュ**:
   頻繁に同じクエリが実行される場合、その結果をキャッシュすることで、クエリ実行時間を短縮し、データベースの負荷を軽減する。

   ```java
   Map<String, ResultSet> queryCache = new LRUCache<>(100);
   String sql = "SELECT * FROM users WHERE id = ?";
   if (queryCache.containsKey(sql)) {
       return queryCache.get(sql); // キャッシュから結果を取得
   } else {
       ResultSet result = executeQuery(sql);
       queryCache.put(sql, result);
       return result;
   }
   ```

2. **Web ページのキャッシュ**:
   動的に生成される Web ページの内容をキャッシュすることで、サーバーの負荷を軽減し、レスポンス時間を短縮する。

   ```java
   Map<String, String> pageCache = new LRUCache<>(50);
   String url = "/home";
   if (pageCache.containsKey(url)) {
       return pageCache.get(url); // キャッシュからページ内容を取得
   } else {
       String pageContent = renderPage(url);
       pageCache.put(url, pageContent);
       return pageContent;
   }
   ```

3. **セッションデータのキャッシュ**:
   ユーザーセッション情報をキャッシュすることで、セッションの読み込みと書き込みを高速化する。

   ```java
   Map<String, Session> sessionCache = new LRUCache<>(1000);
   String sessionId = request.getSessionId();
   if (sessionCache.containsKey(sessionId)) {
       return sessionCache.get(sessionId); // キャッシュからセッションを取得
   } else {
       Session session = loadSessionFromDatabase(sessionId);
       sessionCache.put(sessionId, session);
       return session;
   }
   ```

### まとめ

`LinkedHashMap`を使った LRU キャッシュは、メモリ効率の向上、データアクセスの高速化、簡単なキャッシュ管理を実現するための有効な手段。特に、頻繁にアクセスされるデータを効率的に管理することで、システム全体のパフォーマンスを向上させる。データベースクエリ結果のキャッシュ、Web ページのキャッシュ、セッションデータのキャッシュなど、多くのユースケースで活用できる。

:::

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
