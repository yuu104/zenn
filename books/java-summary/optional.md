---
title: "Optional クラス"
---

## 目的

`Optional`は、値が存在するかどうかを表現するためのコンテナクラス。主に null による問題を回避し、明示的に値の存在を示すことで、コードの安全性と可読性を向上させるために使用される。

## 主な特徴

1. **値の存在を明示的に表現**:

   - 値が存在する場合と存在しない場合を明確に区別できる。
   - null チェックの代替として使用できる。

2. **null の使用を避ける**:

   - null による NullPointerException を防ぐ。
   - メソッドチェーンでの null チェックを簡素化。

3. **意図を明確にする**:
   - メソッドの戻り値に`Optional`を使用することで、呼び出し側に値が存在しない可能性を明示的に伝える。

## 主なメソッド

:::details of() - 値を持つ Optional を作成

- **説明**: 指定した非 null 値を持つ`Optional`を返す。
- **シグネチャ**: `public static <T> Optional<T> of(T value)`
- **使用例**:
  ```java
  Optional<String> optional = Optional.of("Hello");
  System.out.println(optional.isPresent()); // true
  ```
  :::

:::details empty() - 空の Optional を作成

- **説明**: 空の`Optional`インスタンスを返す。
- **シグネチャ**: `public static <T> Optional<T> empty()`
- **使用例**:
  ```java
  Optional<String> optional = Optional.empty();
  System.out.println(optional.isPresent()); // false
  ```
  :::

:::details ofNullable() - null を許容する Optional を作成

- **説明**: 指定した値が null でない場合はその値を、null の場合は空の`Optional`を返す。
- **シグネチャ**: `public static <T> Optional<T> ofNullable(T value)`
- **使用例**:
  ```java
  Optional<String> optional = Optional.ofNullable(null);
  System.out.println(optional.isPresent()); // false
  ```
  :::

:::details isPresent() - 値の存在確認

- **説明**: 値が存在する場合は true を返し、存在しない場合は false を返す。
- **シグネチャ**: `public boolean isPresent()`
- **使用例**:
  ```java
  Optional<String> optional = Optional.of("Hello");
  System.out.println(optional.isPresent()); // true
  ```
  :::

:::details ifPresent() - 値が存在する場合のアクション

- **説明**: 値が存在する場合に指定されたアクションを実行する。
- **シグネチャ**: `public void ifPresent(Consumer<? super T> action)`
- **使用例**:
  ```java
  Optional<String> optional = Optional.of("Hello");
  optional.ifPresent(System.out::println); // Hello
  ```
  :::

:::details orElse() - デフォルト値の提供

- **説明**: 値が存在する場合はその値を返し、存在しない場合は指定されたデフォルト値を返す。
- **シグネチャ**: `public T orElse(T other)`
- **使用例**:
  ```java
  Optional<String> optional = Optional.empty();
  String result = optional.orElse("Default");
  System.out.println(result); // Default
  ```
  :::

:::details orElseGet() - デフォルト値の遅延評価

- **説明**: 値が存在する場合はその値を返し、存在しない場合は指定されたサプライヤから取得した値を返す。
- **シグネチャ**: `public T orElseGet(Supplier<? extends T> other)`
- **使用例**:
  ```java
  Optional<String> optional = Optional.empty();
  String result = optional.orElseGet(() -> "Default");
  System.out.println(result); // Default
  ```
  :::

:::details orElseThrow() - 例外のスロー

- **説明**: 値が存在する場合はその値を返し、存在しない場合は指定された例外をスローする。
- **シグネチャ**: `public <X extends Throwable> T orElseThrow(Supplier<? extends X> exceptionSupplier) throws X`
- **使用例**:
  ```java
  Optional<String> optional = Optional.empty();
  try {
      String result = optional.orElseThrow(() -> new IllegalArgumentException("Value is absent"));
  } catch (IllegalArgumentException e) {
      System.out.println(e.getMessage()); // Value is absent
  }
  ```

:::

:::details map() ~ 値のマッピング

#### 説明

- `Optional` が値を持っているときに、その値に対して指定されたマッピング関数を適用し、新たな `Optional` を返す
- 値を持っていない場合、空の `Optional` を返す

#### シグネチャ

```java
public <U> Optional<U> map(Function<? super T, ? extends U> mapper)
```

#### 具体例

1. **値が存在する場合の変換**

   ```java
   import java.util.Optional;

   public class Main {
       public static void main(String[] args) {
           Optional<String> optionalString = Optional.of("hello");

           // mapを使用して文字列の長さを取得
           Optional<Integer> optionalLength = optionalString.map(String::length);

           // 結果を出力
           optionalLength.ifPresent(length -> System.out.println("長さ: " + length));
       }
   }
   ```

   - `optionalString` は `"hello"` を含む `Optional`
   - `map` メソッドで文字列の長さを計算する関数 `String::length` を適用する
   - `optionalLength` は `Optional<Integer>` 型で、`"hello"` の長さである `5` を含む
   - `ifPresent` メソッドを使って、`optionalLength` が存在する場合にその値を出力する

2. **値が存在しない場合の処理**

   ```java
   import java.util.Optional;

   public class Main {
       public static void main(String[] args) {
           Optional<String> emptyOptional = Optional.empty();

           // mapを使用して文字列の長さを取得
           Optional<Integer> optionalLength = emptyOptional.map(String::length);

           // 結果を出力（何も出力されない）
           optionalLength.ifPresent(length -> System.out.println("長さ: " + length));
       }
   }
   ```

:::

## 解決したい技術的課題

### NullPointerException の回避

- **問題点**
  null チェックを忘れた場合、NullPointerException が発生し、予期しないクラッシュが発生することがある。

- **解決策**
  `Optional`を使用することで、null を明示的に扱い、NullPointerException の発生を防ぐ。

  ```java
  String value = null;
  Optional<String> optional = Optional.ofNullable(value);
  optional.ifPresent(System.out::println); // 出力なし
  ```

### 値の存在確認の簡素化

- **問題点**
  従来の null チェックでは、コードが冗長になりやすく、意図が明確でない。

  ```java
  String value = getValue();
  if (value != null) {
      System.out.println(value);
  }
  ```

- **解決策**
  `Optional`を使用して、値の存在確認を簡潔に記述する。

  ```java
  Optional<String> optional = Optional.ofNullable(getValue());
  optional.ifPresent(System.out::println);
  ```

### デフォルト値の提供

- **問題点**
  null の場合にデフォルト値を提供する際、コードが複雑になることがある。

  ```java
  String value = getValue();
  String result = (value != null) ? value : "Default";
  ```

- **解決策**
  `Optional`を使用して、デフォルト値を簡潔に提供する。

  ```java
  String result = Optional.ofNullable(getValue()).orElse("Default");
  ```

### 例外のスロー

- **問題点**
  値が存在しない場合に例外をスローする処理を行う際、コードが複雑になりやすい。

  ```java
  String value = getValue();
  if (value == null) {
      throw new IllegalArgumentException("Value is absent");
  }
  ```

- **解決策**
  `Optional`を使用して、例外を簡潔にスローする。

  ```java
  String result = Optional.ofNullable(getValue()).orElseThrow(() -> new IllegalArgumentException("Value is absent"));
  ```

## まとめ

`Optional`は、null を明示的に扱うことでコードの安全性と可読性を向上させる強力なツール。NullPointerException を回避し、値の存在確認やデフォルト値の提供、例外のスローを簡潔に記述することができる。これにより、Java のコーディングにおける一般的な null 関連の問題を効果的に解決できる。
