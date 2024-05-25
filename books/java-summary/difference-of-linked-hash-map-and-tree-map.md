---
title: "LinkedHashMapとTreeMapの違い"
---

## LinkedHashMap

- **概要**: 挿入順序またはアクセス順序を保持するマップ。
- **内部構造**: ハッシュテーブルとダブルリンクリストを組み合わせた構造。
- **ソート順序**: 挿入順序またはアクセス順序を保持するが、キーの自然順序やカスタム順序はサポートしない。
- **パフォーマンス**: `HashMap`と同様に、検索、挿入、削除の時間計算量は平均して O(1)。

## TreeMap

- **概要**: `TreeMap`は、キーを自然順序またはカスタムコンパレータに基づいてソートして保持するマップ。
- **内部構造**: 赤黒木（Red-Black Tree）を使用。
- **ソート順序**: キーの自然順序またはカスタムコンパレータによってソートされる。
- **パフォーマンス**: 検索、挿入、削除の時間計算量は O(log n)。

## 主な違い

### 1. データの順序保持

- **LinkedHashMap**:

  - 挿入順序またはアクセス順序を保持。
  - 順序の変更が頻繁なシナリオに適している。

- **TreeMap**:
  - キーの自然順序またはカスタム順序に基づいてソート。
  - 順序付きの検索や範囲検索が必要なシナリオに適している。

### 2. 使用目的と特性

- **LinkedHashMap**:

  - キャッシュ実装（LRU キャッシュなど）や、挿入順序を重視するシナリオに適している。
  - 例: 順序が重要なデータの管理、キャッシュシステムなど。

- **TreeMap**:
  - ソートされたデータの管理や、範囲検索を効率的に行う必要があるシナリオに適している。
  - 例: ナビゲーションシステム、金融アプリケーション、時系列データの管理など。

## ユースケース

### LinkedHashMap のユースケース

1. **LRU キャッシュの実装**:
   頻繁にアクセスされるデータをキャッシュし、最も古いデータを削除する。

   ```java
   LinkedHashMap<String, String> cache = new LinkedHashMap<String, String>(16, 0.75f, true) {
       @Override
       protected boolean removeEldestEntry(Map.Entry<String, String> eldest) {
           return size() > 3;
       }
   };
   ```

2. **挿入順序を保持するデータ管理**:
   データの挿入順序を維持し、表示順序を保証する。

   ```java
   LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
   map.put("apple", 1);
   map.put("banana", 2);
   map.put("cherry", 3);
   System.out.println(map); // {apple=1, banana=2, cherry=3}
   ```

### TreeMap のユースケース

1. **ソートされたデータの管理**:
   キーを自然順序またはカスタムコンパレータでソートし、データを管理する。

   ```java
   TreeMap<String, Integer> map = new TreeMap<>();
   map.put("banana", 2);
   map.put("apple", 1);
   map.put("cherry", 3);
   System.out.println(map); // {apple=1, banana=2, cherry=3}
   ```

2. **範囲検索の実装**:
   指定されたキーの範囲内のデータを効率的に取得する。

   ```java
   TreeMap<String, Integer> map = new TreeMap<>();
   map.put("apple", 1);
   map.put("banana", 2);
   map.put("cherry", 3);
   SortedMap<String, Integer> subMap = map.subMap("apple", "cherry");
   System.out.println(subMap); // {apple=1, banana=2}
   ```
