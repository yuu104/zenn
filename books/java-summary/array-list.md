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

1. **`get(index)`**
   - 引数に指定したインデックスに該当するデータを参照
2. **`add(data)`**
   - `ArrayList` にデータを追加する
   - 追加された順に 0 からインデックスが振られる
3. **`size()`**
   - `ArrayList` の要素数を出力する
4. **`isEmpty()`**
   - リストに要素がない場合、`true` を返す
5. **`remove(index)`**
   - 引数に指定したインデックスに該当するデータを削除

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
