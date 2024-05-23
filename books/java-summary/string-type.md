---
title: "String型"
---

## `String` は参照型である

`String` 型の変数を宣言を見ると、一見プリミティブ型のように感じる。

```java
String name = "Hiro";
```

しかし、`String` 型は**参照型**である。
そのため、以下のように宣言することも可能。

```java
String name = new String("Hiro");
```

- 文字列を扱う `String` 型はプリミティブかのように扱うシーンが非常に多い
- よって、プリミティブ型と同じような感覚で扱えるようになっている
- それゆえ、`String` は**擬似プリミティブ型**と呼ばれる

## `String` の正体

`String` 型は `char[]` 型の参照である。

![](https://storage.googleapis.com/zenn-user-upload/673a9e997f04-20240418.png)

よって、以下のように宣言することもできる。

```java
char[] charArray = {'J', 'a', 'v', 'a'};
String str2 = new String(charArray);
```

## 宣言方法の違い

`String` 型の宣言方法には以下 2 つの方法があった。

- 文字列リテラルを使用する
- `new` キーワードを使用する

### 文字列リテラルを使用する

```java
String name = "Hiro";
```

- 文字列リテラルによる宣言は、コンパイル時に**文字列プール**とよばれる特別なメモリ領域に格納される
- 文字列プールは、**同じ文字列リテラルに対しては常に同じ参照を返す**
- そのため、メモリ使用効率が良くなる

よって、以下のような比較を行うことができる。

```java
String myName = "Hiro";
String hisName = "Hiro";

boolean isSameName = myName == hisName // 参照先アドレスを比較

System.out.println(isSameName); // true
```

### `new` キーワードを使用する

```java
String name = new String("Hiro");
```

- `new` キーワードにより、`String` オブジェクトを明示的に作成している
- この場合、文字列プールを無視して常に新しい `String` オブジェクトがヒープメモリ上に創られる

よって、文字リテラルによる宣言とは異なり、以下のような比較はできない。

```java
String myName = new String("Hiro");
String hisName = new String("Hiro");

boolean isSameName = myName == hisName // 参照先アドレスを比較

System.out.println(isSameName); // false
```

比較したい場合、`equals()` メソッドを使用する。

```java
String myName = new String("Hiro");
String hisName = new String("Hiro");

boolean isSameName = myName.equals(hisName); // 参照先アドレスを比較

System.out.println(isSameName); // false
```

## 文字列比較のベストプラクティス

Java で文字列の比較を行うときは **`equals()` メソッドを使う**。
なぜ `==` ではダメなのか？

```java: == が true になるケース
String str = "hoge";
String str_2 = "hoge";
//このif文の条件は`true`だが、それは値が同じだからではなく参照先(アドレス値)が同じだから。
if (str == str_2){
    System.out.println("値は同じです");
} else {
    System.out.println("値は違います");
}

```

- 上記コードの `str` と `str_2` は値が同じである
- しかし、値の一致と `==` の結果は関係ない
- `==` は参照先アドレスを比較している
- 今回、文字リテラルによる宣言を行なっているため、`str` と `str_2` の参照先アドレスは同じ
- よって、比較結果が `true` になる

```java: == が false になるケース
String str = "hoge";
String str_2 = new String("hoge");
//この場合は参照の再利用はされず、strとstr_2の参照先(アドレス値)は異なるため条件はfalseになります。
if (str == str_2){
    System.out.println("値は同じです");
} else {
    System.out.println("値は違います");
}
```

`String` 型の値自体を比較するためには、冒頭で書いた通り `equals` メソッドを使用するようにする。

```java
String str = "hoge";
String str_2 = new String("hoge");
//equalsメソッドを使うことで、値自体の比較ができます。
if (str.equals(str_2)){
  System.out.println("値は同じです");
} else {
  System.out.println("値は違います");
}
```

## 主要メソッド

:::details chars()

- **説明**: 文字列の各文字を`IntStream`として返します。各文字はその Unicode コードポイントとして表されます。
- **シグネチャ**: `public IntStream chars()`
- **使用例**:
  ```java
  String str = "Hello";
  IntStream intStream = str.chars();
  intStream.forEach(ch -> System.out.println((char) ch));
  // 出力:
  // H
  // e
  // l
  // l
  // o
  ```

:::

:::details charAt()

- **説明**: 指定したインデックスの文字を返します。インデックスは 0 から始まります。
- **シグネチャ**: `public char charAt(int index)`
- **使用例**:
  ```java
  String str = "Hello, World!";
  char ch = str.charAt(7); // chは'W'
  ```

:::

:::details substring()

- **説明**: 指定した開始インデックスから終了インデックスまでの部分文字列を返します。終了インデックスの文字は含まれません。
- **シグネチャ**: `public String substring(int beginIndex, int endIndex)`
- **使用例**:
  ```java
  String str = "Hello, World!";
  String subStr = str.substring(7, 12); // subStrは"World"
  ```

:::

:::details equals()

- **説明**: 文字列が指定されたオブジェクトと等しいかどうかを比較します。文字列の内容が同じ場合に`true`を返します。
- **シグネチャ**: `public boolean equals(Object anObject)`
- **使用例**:
  ```java
  String str1 = "Hello";
  String str2 = "Hello";
  boolean isEqual = str1.equals(str2); // isEqualはtrue
  ```

:::

:::details compareTo()

- **説明**: 辞書順で文字列を比較します。比較結果が負の値なら呼び出し元の文字列が引数の文字列よりも辞書順で前に来ることを意味し、正の値なら後に来ることを意味します。同じなら 0 を返します。
- **シグネチャ**: `public int compareTo(String anotherString)`
- **使用例**:
  ```java
  String str1 = "Apple";
  String str2 = "Banana";
  int result = str1.compareTo(str2); // resultは負の値
  ```

:::

:::details compareToIgnoreCase()

- **説明**: 大文字と小文字を区別せずに文字列を辞書順で比較します。比較結果が負の値なら呼び出し元の文字列が引数の文字列よりも辞書順で前に来ることを意味し、正の値なら後に来ることを意味します。同じなら 0 を返します。
- **シグネチャ**: `public int compareToIgnoreCase(String str)`
- **使用例**:
  ```java
  String str1 = "apple";
  String str2 = "Banana";
  int result = str1.compareToIgnoreCase(str2);
  // resultは負の値（大文字と小文字を区別しないため、"apple"は"Banana"より前に来る）
  ```

:::

:::details regionMatches()

- **説明**: 文字列の指定された部分領域が、別の文字列の指定された部分領域と一致するかどうかを比較します。
- **シグネチャ**:
  ```java
  public boolean regionMatches(int toffset, String other, int ooffset, int len)
  public boolean regionMatches(boolean ignoreCase, int toffset, String other, int ooffset, int len)
  ```
- **使用例**:

  ```java
  String str1 = "Hello, World!";
  String str2 = "WORLD";
  boolean result1 = str1.regionMatches(7, str2, 0, 5);
  // result1はfalse（大文字と小文字が区別されるため）

  boolean result2 = str1.regionMatches(true, 7, str2, 0, 5);
  // result2はtrue（大文字と小文字が区別されないため）
  ```

:::

:::details equalsIgnoreCase()

- **説明**: 文字列が指定されたオブジェクトと等しいかどうかを、大文字と小文字を区別せずに比較します。
- **シグネチャ**: `public boolean equalsIgnoreCase(String anotherString)`
- **使用例**:
  ```java
  String str1 = "Hello";
  String str2 = "hello";
  boolean result = str1.equalsIgnoreCase(str2);
  // resultはtrue（大文字と小文字が区別されないため）
  ```

:::

:::details indexOf()

- **説明**: 指定した文字列が最初に出現する位置のインデックスを返します。見つからない場合は-1 を返します。
- **シグネチャ**: `public int indexOf(String str)`
- **使用例**:
  ```java
  String str = "Hello, World!";
  int index = str.indexOf("World"); // indexは7
  ```

:::

:::details toUpperCase()

- **説明**: 文字列を全て大文字に変換して新しい文字列を返します。
- **シグネチャ**: `public String toUpperCase()`
- **使用例**:
  ```java
  String str = "Hello, World!";
  String upperStr = str.toUpperCase(); // upperStrは"HELLO, WORLD!"
  ```

:::

:::details toLowerCase()

- **説明**: 文字列を全て小文字に変換して新しい文字列を返します。
- **シグネチャ**: `public String toLowerCase()`
- **使用例**:
  ```java
  String str = "Hello, World!";
  String lowerStr = str.toLowerCase(); // lowerStrは"hello, world!"
  ```

:::

:::details trim()

- **説明**: 文字列の先頭および末尾の空白を削除した新しい文字列を返します。
- **シグネチャ**: `public String trim()`
- **使用例**:
  ```java
  String str = "  Hello, World!  ";
  String trimmedStr = str.trim(); // trimmedStrは"Hello, World!"
  ```

:::

:::details contains()

- **説明**: 文字列が指定されたシーケンスを含んでいるかどうかを判定します。
- **シグネチャ**: `public boolean contains(CharSequence s)`
- **使用例**:
  ```java
  String str = "Hello, World!";
  boolean result = str.contains("World");
  // resultはtrue
  ```

:::

:::details startsWith()

- **説明**: 文字列が指定された接頭辞で始まるかどうかを判定します。
- **シグネチャ**: `public boolean startsWith(String prefix)`
- **使用例**:
  ```java
  String str = "Hello, World!";
  boolean result = str.startsWith("Hello");
  // resultはtrue
  ```

:::

:::details endsWith()

- **説明**: 文字列が指定された接尾辞で終わるかどうかを判定します。
- **シグネチャ**: `public boolean endsWith(String suffix)`
- **使用例**:
  ```java
  String str = "Hello, World!";
  boolean result = str.endsWith("World!");
  // resultはtrue
  ```

:::

:::details isEmpty()

- **説明**: 文字列が空（長さが 0）であるかどうかを判定します。
- **シグネチャ**: `public boolean isEmpty()`
- **使用例**:
  ```java
  String str = "";
  boolean result = str.isEmpty();
  // resultはtrue
  ```

:::

:::details replace()

- **説明**: 指定された文字または文字シーケンスを新しい文字または文字シーケンスに置き換えた新しい文字列を返します。
- **シグネチャ**:
  ```java
  public String replace(char oldChar, char newChar)
  public String replace(CharSequence target, CharSequence replacement)
  ```
- **使用例**:
  ```java
  String str = "Hello, World!";
  String replacedStr = str.replace('o', 'a');
  // replacedStrは "Hella, Warld!"
  ```

:::

:::details split()

- **説明**: 指定された正規表現に一致する部分で文字列を分割し、配列として返します。
- **シグネチャ**: `public String[] split(String regex)`
- **使用例**:
  ```java
  String str = "apple,banana,cherry";
  String[] fruits = str.split(",");
  // fruitsは ["apple", "banana", "cherry"]
  ```

:::

:::details toCharArray()

- **説明**: 文字列を`char`配列に変換して返します。
- **シグネチャ**: `public char[] toCharArray()`
- **使用例**:
  ```java
  String str = "Hello";
  char[] charArray = str.toCharArray();
  // charArrayは ['H', 'e', 'l', 'l', 'o']
  ```

:::

:::details valueOf()

- **説明**: 任意のデータ型をその文字列表現に変換します（オーバーロードされたメソッドが多数あります）。
- **シグネチャ**:
  ```java
  public static String valueOf(boolean b)
  public static String valueOf(char c)
  public static String valueOf(char[] data)
  public static String valueOf(int i)
  public static String valueOf(long l)
  public static String valueOf(float f)
  public static String valueOf(double d)
  public static String valueOf(Object obj)
  ```
- **使用例**:
  ```java
  int num = 42;
  String str = String.valueOf(num);
  // strは "42"
  ```

:::

`StringBuilder`クラスについて網羅的かつ簡潔に解説します。

### `StringBuilder` クラス

- Java で可変長の文字列を扱うためのクラス
- 通常、文字列の操作（連結、挿入、置換など）は不変の`String`クラスを使用すると非効率になる場合がある
- この課題を解決するために、`StringBuilder`は効率的な文字列操作を提供する

:::details 基本的な使い方

#### インスタンスの生成

```java
StringBuilder sb = new StringBuilder();
```

#### 文字列の追加

```java
sb.append("Hello");
sb.append(" ");
sb.append("World");
System.out.println(sb.toString()); // 出力: Hello World
```

#### 文字列の挿入

```java
sb.insert(6, "Beautiful ");
System.out.println(sb.toString()); // 出力: Hello Beautiful World
```

#### 文字列の置換

```java
sb.replace(6, 15, "Awesome");
System.out.println(sb.toString()); // 出力: Hello Awesome World
```

#### 文字列の削除

```java
sb.delete(6, 13);
System.out.println(sb.toString()); // 出力: Hello World
```

#### 文字列の逆転

```java
sb.reverse();
System.out.println(sb.toString()); // 出力: dlroW olleH
```

:::

:::details 目的

**文字列操作を効率化すること。**
具体的には以下のような場面で有効。

1. **頻繁な文字列連結**
   多くの文字列をまとめる場合に有用。
2. **動的な文字列生成**
   プログラムの実行中に文字列を動的に変更する必要がある場合に有用。

:::

:::details 解決したい技術的課題

1. **非効率な文字列連結**

   - **問題点**: `String`クラスは不変（immutable）です。つまり、一度作成された文字列は変更できません。そのため、文字列を連結するときに新しい`String`オブジェクトが毎回生成されます。これにより、多くの中間オブジェクトが作成され、メモリと CPU の使用効率が悪くなります。

   - **解決策**: `StringBuilder`は内部バッファを持ち、そのバッファ内で文字列を変更するため、新しいオブジェクトを生成することなく文字列を連結できます。これにより、メモリの使用効率が向上し、パフォーマンスも改善されます。

   ```java
   // 非効率な方法（Stringを使用）
   String str = "";
   for (int i = 0; i < 1000; i++) {
      str += "a";
   }

   // 効率的な方法（StringBuilderを使用）
   StringBuilder sb = new StringBuilder();
   for (int i = 0; i < 1000; i++) {
      sb.append("a");
   }
   String result = sb.toString();
   ```

2. 頻繁な文字列操作

   - **問題点**:

   文字列の挿入、置換、削除を頻繁に行う場合、`String`ではその都度新しい文字列オブジェクトを生成するため、操作が非効率になります。

- **解決策**:
  `StringBuilder`は可変の文字列バッファを提供し、そのバッファ内で直接操作を行うため、頻繁な文字列操作が効率的に行えます。

  ```java
  // 非効率な方法（Stringを使用）
  String str = "Hello World";
  str = str.replace("World", "Java");  // 新しいStringオブジェクトが生成される

  // 効率的な方法（StringBuilderを使用）
  StringBuilder sb = new StringBuilder("Hello World");
  sb.replace(6, 11, "Java");  // 内部バッファ内で直接置換
  String result = sb.toString();
  ```

:::

:::details まとめ

`StringBuilder`を使うことで、以下の技術的課題を解決できる。

1. **非効率な文字列連結**
   `StringBuilder`は新しいオブジェクトを生成せずに文字列を連結できるため、メモリと CPU の効率が良くなる。
2. **頻繁な文字列操作**
   `StringBuilder`は内部バッファを使って直接文字列を操作できるため、挿入、置換、削除などの操作が高速に行えます。

このように、`StringBuilder`は頻繁な文字列操作が必要な場面で非常に有用で、パフォーマンスの向上とメモリ効率の改善を図ることができる。

:::
